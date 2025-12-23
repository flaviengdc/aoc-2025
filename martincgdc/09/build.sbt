val scala3Version = "3.7.4"

lazy val root = project
  .in(file("."))
  .settings(
    name := "AoC9",
    version := "0.1.0-SNAPSHOT",
    scalaVersion := scala3Version,
    semanticdbEnabled := true,
    scalacOptions ++= Seq(
      "-language:strictEquality",
      "-Werror",
      "-Wshadow:all",
      "-Wunused:all",
      "-Wenum-comment-discard",
      "-Wvalue-discard",
      "-WunstableInlineAccessors",
      "-Wimplausible-patterns",
      "-Wnonunit-statement",
      "-deprecation",
      "-feature",
      "-unchecked"
    ),
    libraryDependencies += "org.scalameta" %% "munit" % "1.0.0" % Test
  )
