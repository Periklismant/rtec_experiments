#!/bin/sh
exec java -cp ../../repl/target/scala-2.13/fusemate-repl-0.1.0-SNAPSHOT.jar scala.tools.nsc.MainGenericRunner -usejavacp -Xplugin:../../plugin/target/scala-2.13/plugin_2.13-0.1.0-SNAPSHOT.jar "$0" "$@"
!#

// Use a predefined inference engine (fm6.IntTimeIE._) with Time type Int
import fm6.IntTimeIE._
import fm6.IntTimeIE.ruleFramework._
import fm6.IntTimeIE.ruleFramework.signature._

case class SameBatch(time: Time, objs: Set[String]) extends Atom
case class Load(time: Time, obj: String, cont: String) extends Atom
case class Unload(time: Time, obj: String, cont: String) extends Atom
case class In(time: Time, obj: String, cont: String) extends Atom

@rules
val rules = List(
    In(time, obj, cont) :-
      Load(time, obj, cont),

    // In is transitive
    In(time, obj, cont) :- (
      In(time, obj, c), In(time, c, cont)
    ),

    // Frame axiom for In
    In(next, obj, cont) :- (
      In(time, obj, cont),
      Step(next, time),
      NOT ( Unload(next, obj, cont) ),
      NOT ( In(time, obj, c), Unload(next, c, cont) )
    ),

    FAIL(+ Unload((time+prev)/2, cont, c)) :- (
      Unload(time, obj, cont),
      In(time, cont, c), // This is the culprit
      // The following is redundant with the integrity constraints below
      // In absence, it generates a search space though, by trying to unload cont from all c that cont is in (transitively)
      Load(t, cont, c), t < time,
      Step(time, prev)
    ),

    FAIL :- (
      Unload(time, obj, cont),
      Step(time, prev),
      NOT ( In(prev, obj, cont) )
    ),

    FAIL :- (
      Unload(time, obj, cont),
      NOT ( Load(t, obj, cont), t < time )
    ),

    FAIL(- Unload(time, obj, cont), + Unload(time, o, cont)) :- (
      Unload(time, obj, cont),
      NOT ( Load(t, obj, cont), t < time ),
      Load(t, o, cont),
      t < time,
      SameBatch(t, b),
      ((b contains obj) && (b contains o))
    ),

    FAIL(+ Load(t, obj, cont)) :- (
      Unload(time, obj, cont),
      NOT ( Load(t, obj, cont), t < time ),
      Load(t, o, cont),
      t < time,
      SameBatch(t, b),
      ((b contains obj) && (b contains o))
    ),

    FAIL(- Load(t, o, cont), + Load(t, obj, cont)) :- (
      Unload(time, obj, cont),
      NOT ( Load(t, obj, cont), t < time ),
      Load(t, o, cont),
      t < time,
      SameBatch(t, b),
      ((b contains obj) && (b contains o))
    )
  )

val edbCSV = Seq(
    "Load,10,tomatoes,pallet",
    "Load,20,pallet,container",
    "Load,40,container,ship",
    "Unload,60,apples,pallet")


// Convert EDB from CSV to Literals
val edb = edbCSV map { line =>
  line.split(",") match {
    case Array("Load", time, obj, cont) => POS(Load(time.toInt, obj, cont))
    case Array("Unload", time, obj, cont) => POS(Unload(time.toInt, obj, cont))
  }
}

val models = (POS(SameBatch(10, Set("tomatoes", "apples"))) +: edb) saturate rules

for (I <- models) {
  println(I.toList.sortBy(_.time) filter { Set("Load", "Unload") contains _.predName } )
}

