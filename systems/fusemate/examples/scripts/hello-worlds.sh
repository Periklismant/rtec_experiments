#!/bin/sh
exec java -cp ../../repl/target/scala-2.13/fusemate-repl-0.1.0-SNAPSHOT.jar scala.tools.nsc.MainGenericRunner -usejavacp -Xplugin:../../plugin/target/scala-2.13/plugin_2.13-0.1.0-SNAPSHOT.jar "$0" "$@"
!#

// Use a predefined inference engine (fm6.IntTimeIE._) with Time type Int
import fm6.IntTimeIE._
import fm6.IntTimeIE.ruleFramework._
import fm6.IntTimeIE.ruleFramework.signature._

case class MorningWorld(time: Int) extends Atom
case class EveningWorld(time: Int) extends Atom
case class Hello(time: Int) extends Atom

@rules
val rules = List(

    (MorningWorld(time) OR EveningWorld(time)) :-
        Hello(time),

    FAIL :- (
	MorningWorld(time),
	time > 12
	),

    FAIL :- (
	EveningWorld(time),
	time < 12
	),
)

// Print all models.
// There are three, as "12" will be a MorningWorld, an EveningWorld, or both
for (I <- new Models(rules, Set[Lit](Hello(7), Hello(12), Hello(19)))) {
	ppLits(I)
    }



