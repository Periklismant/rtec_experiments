#!/bin/sh
export FUSEMATE_HOME="`dirname $0`/.."

exec java -cp $FUSEMATE_HOME/repl/target/scala-2.13/fusemate-repl-0.1.0-SNAPSHOT.jar scala.tools.nsc.MainGenericRunner -usejavacp -Xplugin:$FUSEMATE_HOME/plugin/target/scala-2.13/plugin_2.13-0.1.0-SNAPSHOT.jar
!#
