#!/bin/sh
# exec scala -classpath "target/scala-2.13/fusemate-0.1.jar" -Xplugin:plugin/target/scala-2.13/plugin_2.13-0.1.0-SNAPSHOT.jar "$0" "$@" 
exec java -cp repl/target/scala-2.13/fusemate-repl-0.1.0-SNAPSHOT.jar scala.tools.nsc.MainGenericRunner -usejavacp -Xplugin:plugin/target/scala-2.13/plugin_2.13-0.1.0-SNAPSHOT.jar "$0" "$@" 
!#

// Use a predefined inference engine (fm6.IntTimeIE._) with Time type Int
import fm6.IntTimeIE._
import fm6.IntTimeIE.ruleFramework._
import fm6.IntTimeIE.ruleFramework.signature._

case class World(time: Time) extends Atom
case class Hello(time: Time) extends Atom

@rules
val rules = List(
  World(time) :- Hello(time),
)

val model = new Models(rules, Set[Lit](Hello(0))) 

ppLits(model.head)


