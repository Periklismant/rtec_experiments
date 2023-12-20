name := "fm6"
version := "0.1"

scalaVersion in ThisBuild := "2.13.3"
scalacOptions in ThisBuild += "-deprecation"
scalacOptions in ThisBuild += "-language:postfixOps"
scalacOptions in ThisBuild += "-feature"
scalacOptions in ThisBuild += "-language:implicitConversions"
// scalacOptions in ThisBuild += "-Ybrowse:typer"
logLevel := Level.Warn

// Usage:
// 'sbt all/stage; assembly; repl/assembly'
// More finegrained:
// - 'sbt plugin/package' makes the compile plugin plugin/target/scala-2.13/plugin_2.13-0.1.0-SNAPSHOT.jar
//   This is neccessary as an implicit dependency before anything else. Re-run when the plugin-code has changed
// - 'sbt assembly' makes the jar target/scala-2.13/fusemate-0.1.jar for inclusion in external projects
// - After that you should be able to run hello-world.sh from the commandline
// - 'sbt supplyChain/stage' to make a cmdline executable for the supply chain example from the paper, similarly other projects.

// todo: how to publish the plugin and annotation projects?

// Use sbt plugin/package to make plugin/target/scala-2.13/plugin_2.13-0.1.0-SNAPSHOT.jar
lazy val plugin = (project in file("plugin"))
  .settings(
    libraryDependencies += "org.scala-lang" % "scala-reflect" % scalaVersion.value,
    libraryDependencies += "org.scala-lang" % "scala-compiler" % scalaVersion.value,
    exportJars := true // makes plugin/target/scala-2.13/plugin_2.13-0.1.0-SNAPSHOT.jar even on compile
)


// Use sbt assembly to make target/scala-2.13/fusemate-0.1.jar for inclusion in external scala projects or jupyter
lazy val root = (project in file("."))
  .dependsOn(plugin)
  .settings(
    // assemblyMergeStrategy in assembly := { case x => MergeStrategy.rename },
    scalacOptions += "-Xplugin:plugin/target/scala-2.13/plugin_2.13-0.1.0-SNAPSHOT.jar",
    assemblyOption in assembly := (assemblyOption in assembly).value.copy(includeScala = false),
    assemblyJarName in assembly := s"fusemate-${version.value}.jar"
  )

// Use sbt repl/assembly to make a fat jar for use in shell scripts, in a read-eval-print-loop, or in java projects
// java -cp repl/target/scala-2.13/fusemate-repl-0.1.0-SNAPSHOT.jar scala.tools.nsc.MainGenericRunner -usejavacp -Xplugin:plugin/target/scala-2.13/plugin_2.13-0.1.0-SNAPSHOT.jar "$0" "$@" 
lazy val repl = (project in file("repl"))
  .dependsOn(root)
  .settings(
    // scalacOptions += "-Xplugin:plugin/target/scala-2.13/plugin_2.13-0.1.0-SNAPSHOT.jar",
    // assemblyMergeStrategy in assembly := { case x => MergeStrategy.rename },
    libraryDependencies += "org.scala-lang" % "scala-reflect" % scalaVersion.value,
    libraryDependencies += "org.scala-lang" % "scala-compiler" % scalaVersion.value,
    assemblyOption in assembly := (assemblyOption in assembly).value.copy(includeScala = true),
    assemblyJarName in assembly := s"fusemate-repl-${version.value}.jar",
    mainClass in assembly := Some("scala.tools.nsc.MainGenericRunner"),
  )

// Use sbt assembly to make target/scala-2.13/fusemate-util-0.1.jar for inclusion in external projects
lazy val util = (project in file("util"))
  .settings(
    libraryDependencies += "com.typesafe.play" %% "play-json" % "2.9.0",
    // assemblyMergeStrategy in assembly := { case x => MergeStrategy.rename }, // Makes assembly terribly slow!
    assemblyOption in assembly := (assemblyOption in assembly).value.copy(includeScala = false),
    assemblyJarName in assembly := s"fusemate-util-${version.value}.jar"
  )

lazy val eventCalculus = (project in file("examples/event-calculus"))
  .dependsOn(plugin)
  .dependsOn(root)
  .enablePlugins(JavaAppPackaging)
  .settings(
    scalacOptions += "-Xplugin:plugin/target/scala-2.13/plugin_2.13-0.1.0-SNAPSHOT.jar",
    mainClass in Compile := Some("fm6.examples.eventCalculus.Main"),
    mappings in (Compile, packageDoc) := Seq(),
  )

lazy val all = project
  .aggregate(plugin, root, repl, util, eventCalculus)


