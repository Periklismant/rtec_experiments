# Fusemate

Fusemate is a software program for computing plausible current states of a
system that evolves over time. Input are a sequence of timestamped events and
a specification of properties of interest. Output is one or more logical
models of the specification and the events. Each of these is meant to be
such a plausible state from an external perspective.

The theory behind Fusemate is built around disjunctive logic programming under
a possible models semantics, stratification in terms of event times, default
negation, and a model revision operator for dealing with incomplete or
erroneous events.

See the `doc` directory for some papers and slides.

Fusemate can also be used as a traditional bottom-up model computation
procedure. The perhaps most interesting feature then is its tight integration
into the Scala programming language. This enables logic programming as an
operator on Scala collections and that can be used freely within any Scala
code. Conversely, the logic programming rules can use values and functions
defined in the embedding Scala environment.

This repository contains the Fusemate the source code and some examples,
including the ones discussed in the included papers. 

## Quick install

Fusemate is installed from sources. The following commands install everything needed,
including a lot of Java infrastructure. Everything is installed underneeth
this directory, so it's easy to remove Fusemate again :)

- Install [sbt](http://www.scala-sbt.org/), the Scala Build Tool. 
- Run `install.sh`. 
- Test: 

```sh
$ ./hello-world.sh
Hello(0)
World(0)
```

### Directory structure

The most important directories:

- `src/main/scala/` : Fusemate inference engine source code.

- `examples/` : The examples in the papers, obvious directory names, and
  others. In particular:

- `examples/description-logic` : a more advanced example than in the CADE-28
  paper, and also demonstrating the rules+DL interface.

- `examples/event-calculus` : a simple standard event-calculus example only, "robot
  picks up key and walks through door". 

- `plugin/src/main/scala/` : Source code for the compile-time macros for traditional logic programming rule syntax.

### Installation in more detail

The installation process requires the Scala Build Tool (sbt), which will
install all neccessary software on demand. This is similar to Java projects which
pull everything from somewhere (e.g. the Maven repository).

Steps:

- Install [sbt](http://www.scala-sbt.org/), the Scala Build Tool. Then run
  `install.sh`. Or do the following, which is what `install.sh` does:

- In the current directory, run `sbt plugin/package` for making the compiler
  plugin `plugin/target/scala-2.13/plugin_2.13-0.1.0-SNAPSHOT.jar`.  
  This is neccessary as an implicit dependency before anything else. Re-run
  when the plugin-code has changed.

- Run `sbt all/stage` to compile more examples in the `examples` directory.

  The `stage` command generates a shell script (*nix) and a BAT file (Windows),
  e.g.
```bash
examples/supply-chain/target/universal/stage/bin/supplychain
examples/supply-chain/target/universal/stage/bin/supplychain.bat
```
  which can be directly run from the commandline.

- Run `sbt repl/assembly` to make a fat jar
  `repl/target/scala-2.13/fusemate-repl-0.1.0-SNAPSHOT.jar` for use in shell
  scripts, in a read-eval-print-loop, or in java projects.
  After that you should be able to run `hello-world.sh` from the commandline.

- Run `sbt assembly` for making the jar archive
 `target/scala-2.13/fusemate-0.1.jar` for inclusion in external scala
  projects or jupyter notebooks.

If you'd like to experiment and change the source code you'd need to recompile
the relevant part(s) as just described. Or just call `install.sh`.

### Testing

After installation, executing `hello-word.sh` in the current directory should
work out of the box:
```sh
$ ./hello-world.sh
Hello(0)
World(0)
```

For running the supply chain example from the paper do the following:
```sh
cd examples/IJCAR-2020
$ ./run.sh data/edb-1.jsonl
```

The output should be the three models mentioned in the paper.

There is also a script version of the supply chain example:
```sh
cd examples/scripts
$ ./supply-chain.sh
```

## Fusemate usage overview

The Fusemate rule language is implemented as an embedding into Scala. This
means a Fusemate input file *is* a Scala source file and needs to be compiled
to be executable.

Fusemate is comprised of two components: a Scala compiler-plugin that compiles
Fusemate rules into Scala expressions, and a runtime library that implements
an inference engine for these rules turned Scala expressions. From a usage
perspective, Fusemate is a Scala library as many others with an additional front-end
component. Because of that, Fusemate can be used like Scala in variety of ways:

**As part of a Scala script**. For example, the script `hello-world.sh` in this directory has:

```sh
#!/bin/sh
exec java -cp repl/target/scala-2.13/fusemate-repl-0.1.0-SNAPSHOT.jar scala.tools.nsc.MainGenericRunner -usejavacp -Xplugin:plugin/target/scala-2.13/plugin_2.13-0.1.0-SNAPSHOT.jar "$0" "$@"
!#

// IntTimeTableauFramework is a predefined inference engine with Scala integers Int as the type of Time
import fm6.TableauFramework.IntTimeTableauFramework._
import fm6.TableauFramework.IntTimeTableauFramework.ruleFramework._
import fm6.TableauFramework.IntTimeTableauFramework.ruleFramework.signature._

case class World(time: Int) extends Atom
case class Hello(time: Int) extends Atom

@rules
val rules = List(
  World(time) :- Hello(time)
)

val M = Set(Hello(0)) saturateFirst rules

ppLits(M)
```

See the `examples/scripts` directory for some more simple example scripts.

The Scala scripts can be run directly from the commandline. Prerequisite is
a Java runtime version 8 (or higher) installed.

**Interactively**. Scala features a read-eval-print loop. It can be started
with the Fusemate compiler plugin and the Fusemate library by executing the
(trivial) shell script `repl.sh` in the `repl` directory.

**Embedded into a (larger) Scala program in a common program development
cycle**. This requires at least superficial knowledge of a Scala development
environment, such as IntelliJ, Eclipse or a combination of a scala build tool
and a program editor (e.g., Emacs).

In our experiments we worked with [sbt](https://www.scala-sbt.org/), the
Scala build tool, to set up some such (small) projects.
**Important:** Sbt version 1.3 or higher is required, version 1.2 or earlier
misses components for working with Scala 2.13.

The build and dependence specification for these projects is in the file
[build.sbt](build.sbt) in this directory. It requires only little familiarity
with sbt in order to run the provided examples. The [build.sbt](build.sbt)
itself has some comments how to do that. See also below for installation
instructions from source. 

For example, the directory `examples/supply-chain` has the example for the paper.  In order to
run it, go to that directory and execute

```sh
./run.sh data/edb-1.jsonl
```

Again, a Java runtime version 8 (or higher) must be installed.

**Within a Jupyter Scala notebook**.
In case you are not familiar with Jupyter or Notebooks in general please visit the
[Jupyter web page](https://jupyter.org/).

Please install Fusemate as described above. Then, as a prerequiste, [install
JupyterLab](https://jupyter.org/install.html) and the [Almond](https://almond.sh/) Scala shell.

*Important installation hint*. The [Almond installation
instructions](https://almond.sh/docs/quick-start-install) explain setting the
desired version of Scala and Almond as environment variables as follows:

```sh
SCALA_VERSION=2.12.8 ALMOND_VERSION=0.9.1
```

However, Fusemate requires Version 2.13.1 of the Scala compiler. Hence,
instead set

```sh
SCALA_VERSION=2.13.1 ALMOND_VERSION=0.9.1
```

before following the remaining instructions.

Once installed, the "hello world" notebook in
[examples/scripts/hello-world.ipynb](examples/scripts/hello-world.ipynb)
should run without problems after adjusting some absolute paths at the
top of the notebook in the obvious way.

## Rules and programs

The explanations so far cover installation and the Scala project context of
Fusemate; the [paper](papers/IJCAR-2020/final.pdf) focuses on the theory.
This section completes the picture by explaining the Fusemate program
structure. It should be helpful to get started writing own programs.

### Syntactic framework and inference engine

The first step is to define an inference engine (essentially a tableau
reasoner) over a specified "time" type.  This is done in the following way:

```
import fm6._

object MyInferenceEngine extends TableauFramework(new RuleFramework(new Signature[Int, Int](0, _ + _))) {
    type Time = Int
  }

import fm6.TableauFramework.IntTimeTableauFramework._
import fm6.TableauFramework.IntTimeTableauFramework.ruleFramework._
import fm6.TableauFramework.IntTimeTableauFramework.ruleFramework.signature._
```

Notice the `Signature` class. It is declared as follows:

```
Signature[Time, TemporalAmount](val BOT: Time, val plus: (Time, TemporalAmount) => Time)(implicit val TimeOrdering: Ordering[Time])
```

A `Signature` represents the basic syntactic objects of the 
model computation calculus. These objects are atoms, literals, default
negated literals, and inference rules.

Parameters are:

- `Time` the type of the time. Useful concrete types are `Int` or `java.util.OffsetDateTime`.

- `TemporalAmount` the type of temporal duration that can be added to Time instances time. 

- `BOT` a value of type `Time` representing "beginning of time".

- `plus` adds a temporal amount to a time.

  `TimeOrdering` an `Ordering[Time]` used to process timed expressions from
  earlier to later ones.  
  Useful types for `Time`, such as the java `LocalDateTime`, often come with a
  readily defined such ordering.

The next step is to define the signature of atoms (only) by extending the
`Atom` class:

```
case class P(time: Int, i: Int) extends Atom
case class Q(time: Int, j: Int) extends Atom
case class PQ(time: Int, i: Int, j: Int) extends Atom
```

An *interpretation* is a set of (ground) atoms, exactly those that are true.
In concrete terms it is a (any) collection of `Atom` instances:

```
val PsAndQs = Seq(
   P(1, 42),
   Q(1, 20),
   Q(2, 30)
)
```

The `Atom` class is abstract and requires a field `time` of the time
type. Atom instances typically provide `time` through case class definitions,
as above. A useful deviation from this scheme is for specifying
time-independent facts by artificially setting the time to `BOT` for all instances:

```
case class Person(name: String, age: Int) extends Atom { val time = BOT }
val persons = Seq(
   Person("joe", 42),
   Person("sue", 20)
)
```

**Classical negation**: classical negation is available with the `NEG` operator on atoms, as in
`NEG(P(1, 42))`. Notice that `NEG`-literals are an instance of `Lit` but not
of `Atom`. In fact, `Atom`s are also `Lit`s, and in interpretations and rules
`Lit`s are permitted instead of `Atom`s:

```
val PsAndQsWithNEG = Seq(
   P(1, 42),
   NEG(Q(1, 20)),
   Q(2, 30)
)
```

Such interpretations are actually *three-valued*: `P(1, 42)` and `Q(2, 30)`
are true, `Q(1, 20)` is false, and all other atoms are unknown.

Classically negated literals `NEG(P(...))` are treated as atoms with NEG as part of
the predicate name, `NEG_P(...)`. The only constraint is that no
interpretation can contain both an atom and its classical negation. This is
consistent with a widely adopted semantics of classical negation in logic
programming
(Gelfond, M., Lifschitz, V. Classical negation in logic programs and
disjunctive databases. New Gener Comput 9, 365–385
(1991). [DOI](https://doi.org/10.1007/BF03037169)).


### Rules

#### Basics

Rules can be defined with a statement of the form

```
@rules
val myRules = List( ... )
```

Notice the `@rules` annotation. The `...` is a comma-separated list of rules.

Example rule:

```
PQ(time, i, j) :- (
	P(time, i), 
	Q(time, j)
	)
```

Rules are written in Prolog-style notation and are of the form `head :-
body`. In the simplest form, the head is an atom and the body is a list of
atoms. Additional forms are exemplified below.  Identifiers starting with
lower case letters, such as `i`,`j` and `time`  (usually) are variables.  
For the various admissibility conditions on variables see the paper.

The `@rules` annotation takes indentifiers as parameters, which indicates
that these identifers are already bound outside the rule. Such identifiers
stand for the values they are bound to. Example:

```
val i = 42

@rules(i)
val myRules = List(
PQ(time, i, j) :- (
	P(time, i), 
	Q(time, j)
	)
)
```

In this rule, both coccurrences of `i` in the rule stands for the value of
`i` in the context where the rule is defined, which is 42 in this
case.

Alternatively, identifiers starting with uppercase letters are always treated
as constants without explicitly saying so:

```
val I = 42

@rules
val myRules = List(
PQ(time, I, j) :- (
	P(time, I), 
	Q(time, j)
	)
)
```

Bodies are evaluated from left to right and variables can occur multiple times:

```
PQ(time, i, i) :- (
	P(time, i), 
	Q(time, i)
	)
```

Of course, when `Q(time, i)` is evaluated, `i` has the value that it
received when `P(time, i)` was evaluated (and the same for `time`).


### Scala inside rules

Scala language elements can be used quite freely within within rules.

Arithmetic expressions:

```
PQ(time, i, i+j) :- (
	P(time, i), 
	Q(time - 1, j)
	)
```

More generally, function calls:

``` 
def f(i: Int, j: Int) = i + j
```

```
PQ(time, i, f(i, j)) :- (
	P(time, i), 
	Q(time - 1, f(i, i))
	)
```

Notice `f(i, i)` in the body literal, whose evaluation result is used for matching. 

Scala library data structures:

```
case class TwoPersons(names: Set[String], avgAge: Int) extends Atom { val time = BOT }
```

Rule:

```
TwoPersons(Set(name1, name2), (age1 + age2)/2) :- (
    Person(name1, age1),
    Person(name2, age2),
	name1 != name2
)
```

This rule selects two Persons of different name. Notice the body literal
`name1 != name2`. Any expression -- like this -- that is not recognized as a
positive body atom is taken as a Boolean Scala expression. As such, all
variables in such expressions must be bound at the time of compilation. 
There is no problem in the example because rule bodies are evaluated
from left to right. Both `name1` and `name2` are bound by the `Person` atoms
before `name1 != name2` is evaluated.

The following rule, hence, yields an error:
```
TwoPersons(Set(name1, name2), (age1 + age2)/2) :- (
	name1 != name2,
    Person(name1, age1),
    Person(name2, age2)
)
```

As a special case, the infix operators `<`, `<=`, `>=` and `>` are overloaded
and can be applied to compare time points. For example, `s < t` means "s is strictly before t". 


### Default negation

Default negation is written with the `NOT` operator:

```
PQ(time, i, i) :- (
	P(time, i), 
	NOT ( 
	  Q(t, _), 
	  t < time )
	)
```

Notice the parenthesis to captuare the body of `NOT`.

The variable `t` is existentially quantified within the `NOT`
expression. Notice the condition `t < time` which says that `t` must be
strictly earlier than `time`. Notice that at the time the `NOT` expression is evaluated,
`time` has been bound already by the preceeding subgoal `P(time, i)`.

Notice the anonymous variable `_`.

When stratification is enabled, it is possible to relax `<` to `<=` provided the
definition graph allows it:

```
PQ(time, i, i) :- (
	P(time, i), 
	NOT ( 
	  Q(t, _), 
	  t <= time )
	)
```

### STH clauses

Positive body literals can be subject to "such that" conditions: `l STH b`
where `l` is a literals and `b` is a body. The bindings in `b` are always
local to `b`

Examples:

```
PQ(time, i, i) :- (
    P(time, i) STH i > 0
  )
```

```
PQ(time, i, j) :- (
	P(time, i), 
	Q(s, j) STH ( 
       s < time,
       NOT ( 
	      Q(t, _), 
	      s < t && t < time 
		  )
	   )
	)
```

In the latter rule, `s` is the most recent timepoint a `Q` literal holds
strictly before `time`.

A `STH` clause can be unfolded, preserving meaning (X):

```
PQ(time, i, j) :- (
	P(time, i), 
	Q(s, j),
    s < time,
    NOT ( 
	    Q(t, _), 
	    s < t && t < time 
    )
	)
```

So what's the point? First, `STH` clauses are potentially more efficient and enable
more concise specification in conjunction with local binders:


### Local binders

Local binders are a means to bind time-valued variables such that certain
conditions are satisfied.

```
PQ(time, i, j) :- (
	P(time, i), 
	Q(s < time, j)
```

The expression `s < time` binds `s` to the latest timepoint strictly before
`time` such that `Q(s, j)` is true in the current model, for some `j`.
This rule is actually equivalent to the rule (X) above.

Local binders can be combined with local quantification:

```
PQ(time, i, j) :- (
	P(time, i), 
	Q(s < time, j) STH time-s > 5
```

Notice the semantics is different to the one in

```
PQ(time, i, j) :- (
	P(time, i), 
	Q(s < time, j),
	time-s > 5
```

### @gnd annotations

In a literal, a variable at the position of the `time` variable can be
annotated  with `@gnd` to indicate that this occurrence of that variable is
ground at the time of evaluation:

```
PQ(time, i, j) :- (
	P(time, i), 
	Q(time: @gnd, j)
```

It does not matter that the variable is actually named `time`:

```
PQ(zeit, i, j) :- (
	P(zeit, i), 
	Q(zeit: @gnd, j)
```

Because of left-to-right evaluation this however gives an error:

```
PQ(time, i, j) :- (
	P(time: @gnd, i), 
	Q(time, j)
```

A `@gnd` annotation is semantically meaningless but helps efficiency. 
The model computation procedure exploits `@gnd` annotations by looking up all
candidate interpretation literals with that `time` in constant time instead
of a linear search. 

### Restart heads

Restart heads are of the form `FAIL(...)` with arguments being +/- signed
literals, where + means "assert and "-" means retract. 
Example: 

```
FAIL(- P(time, i), + P(time-1, i)) :- P(time, i)
```

An integrity constraint is written with a head `FAIL` (no parenthesis).

### Disjunctions

### Configuration

Fusemate inference engine configuration is done by setting variables in the
`fm6.Config` object. 

```
package fm6

object Config {

  import scala.util.matching.Regex
  var stratification = true 
  var pathsCache = false
  var verbose = false 
  var verbosePreds = Set.empty[Regex]
  var debug = false
  var logRestartHeads = false
  var timeWindow: Option[Any] = None
}
```

Their meaning is as follows:

- `stratification`: Whether to enable static stratification analysis on predicate
  symbols. If true, the model computation procedes by computing the extension
  of predicates in increasing stratification order. When exhausted, time is
  increased to the next time point, if any.

- `pathsCache`: whether to cache paths of previous timepoints. This enables
  re-using paths on restarts rather than starting from scratch.  
  This flag will soon be made obsolete with better data structures.

- `verbose`: whether to display derived literals on the fly.

- `verbosePreds`: if verbose is true, the literals with predicate names
  matching these regexps is displayed.  
  Example: `Set(".*dog.*", ".*cat.*")` will display all literals whose
  predicate name contains "dog" or "cat".

- `debug`: quite verbose dump of internal data structures on every inference
  round. 

- `logRestartHeads`: whether restarts are displayed on stdout

## How it works

**This is slightly outdated but still gives the main ideas.**

By way of example, here is the translation from surface-syntax rules into
Scala. Consider this rule:

```scala
@rules
val rules = List(
  World(time) :- Hello(time), NOT(Hello(earlier), earlier < time),
)
```

Given an interpretation

```scala
val J = Set(Hello(5), Hello(7))
```

it is instructive to see how the rule is translated and evaluated in `J`.

The compiler plugin transforms the rule into this Scala case class `Rule`
instance (leaving some details away):

```scala
val r =  Rule(
   (I: Interpretation) => {
       case List(Hello(time)) if
        Rule((I: Interpretation) => {
         case Hello(earlier) if earlier < time => true
      }, ... ).failsOn(I) => World(time) }, ...)
```

The important field is `r.rule`, the function

```scala
r.rule = (I: Interpretation) => {
        case List(Hello(time)) if
        Rule((I: Interpretation) => {
         case Hello(earlier) if earlier < time => true
      }, ... ).failsOn(I) => World(time) }, ...)
```

The parameter `I` is an interpretation that is used purely for
evaluating (the Scala translation of) negative body literals.
The evaluation `r.rule(I)`, hence, is the Scala code for evaluating the rule
for a fixed interpretation for evaluating negative body literals.
More explicitly:

```scala
r.rule(J) = {
        case List(Hello(time)) if
        Rule((I: Interpretation) => {
         case Hello(earlier) if earlier < time => true
      }, ... ).failsOn(J) => World(time) }
```

This is a partial function whose case statement is made from the rules
positive body literals. All other literals, like time constraints, and
negative body literals go into the `if`-part.

The rule interpreter knows the arity of the partial function, which is given
in a certain field of the `Rule` class. The arity in this example is, of
course, 1, and exhaustive application of the rule to the interpretation `J` is
accomplished by loop similar to this:

```scala
for (a <- J) collect { r.rule(J)(List(a)) }
```

Notice that `collect` collects the results of applying a partial function
to a data collection on all points that the function is defined on.

Let us disect the instance `r.rule(J)(List(Hello(5)))` whose `if`-condition corresponds to the
Scala code

```scala
Rule((I: Interpretation) => {
    case Hello(earlier) if earlier < 5 => true
}, ... ).failsOn(J)
```

Here it should become clear that the negative body of the given rule itself
was translated into a `Rule` class instance. The method
call `failsOn(J)` is executed, which returns true if and only if the rule's
partial function is defined nowhere for the fixed interpretation `J`, which is
passed through the formal parameter `I`.

In this example, the partial function

```scala
{  case Hello(earlier) if earlier < 5 => true }
```

is not defined on `Set(Hello(5), Hello(7))`. Hence, the `failsOn`-call returns
true and the `if`condition of the outer partial function is satisfied. Its
conclusion `World(5)` is collected as the result of the call
`r.rule(J)(List(Hello(5)))`.

In contrast,, the partial function

```scala
{  case Hello(earlier) if earlier < 7 => true }
```

in the call of `r.rule(J)(List(Hello(y)))` is defined on `J` and
`World(7)` is not collected.

### Author

[Peter Baumgartner](https://people.csiro.au/B/P/Peter-Baumgartner/)

Any feedback is appreciated
