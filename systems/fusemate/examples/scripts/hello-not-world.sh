#!/bin/sh
# exec scala -classpath "target/scala-2.13/fusemate-0.1.jar" -Xplugin:plugin/target/scala-2.13/plugin_2.13-0.1.0-SNAPSHOT.jar "$0" "$@" 
exec java -cp ../../repl/target/scala-2.13/fusemate-repl-0.1.0-SNAPSHOT.jar scala.tools.nsc.MainGenericRunner -usejavacp -Xplugin:../../plugin/target/scala-2.13/plugin_2.13-0.1.0-SNAPSHOT.jar "$0" "$@" 
!#

// Use a predefined inference engine (fm6.IntTimeIE._) with Time type Int
import fm6.IntTimeIE._
import fm6.IntTimeIE.ruleFramework._
import fm6.IntTimeIE.ruleFramework.signature._

case class World(time: Int) extends Atom
case class Hello(time: Int) extends Atom

@rules
val rules = List(
    World(time) :- (
       Hello(time),
       NOT( Hello(earlier), earlier < time)
       )
)


println("The rule source expression is available through 'toString()':")
println(rules.head.toString())
// Prints this:
// World(time).:-(Hello(time), NOT(Hello(earlier), earlier.<(time)))

println()
println("The transformation result (Scala code) as a String is available in the 'scalaCodeString' field:")
println(rules.head.scalaCodeString)

// Prints this:
// ((currentI: Interpretation) => OnePremiseRule(scala.collection.immutable.List("Hello"), OPRNone, {
//   case Hello((time @ _)) if true.&&(true).&&(OnePremiseRule(scala.collection.immutable.List("Hello"), OPRNone, {
//     case Hello((earlier @ _)) if true.&&(true).&&(earlier.<(time)) => ABORT
//   }).failsOn(currentI, scala.collection.immutable.Set("Hello"))) => World(time)
// }))

val models = new Models(rules, Set[Lit](Hello(0), Hello(1)))

ppLits(models.head)

/*

If the rule above is changed to this:

@rules
val rules = List(
    World(time) :- (
       Hello(earlier),
       NOT( Hello(earlier), earlier < time)
       )
)

then you get a syntax error:

$ ./hello-not-world.sh
./hello-not-world.sh:16: error: not found: value time
       NOT( Hello(earlier), earlier < time)
                                      ^
./hello-not-world.sh:13: error: not found: value time
    World(time) :- (
          ^

 */
