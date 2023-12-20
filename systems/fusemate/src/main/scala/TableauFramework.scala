package fm6

import fm6.util.LayeredSet
import fm6.util.Logging._

import collection.mutable.{ HashSet => MSet }

/**
 * TableauFramework represents the extension of a `Signature` by a bottom-up model computation procedure.
 *  @param Time the type of the time for the `Signature`
 *  @param TimeOrdering an implicit ordering over Time
 */

// Theory extensions for model computation
object Extension extends Enumeration {
  type Extension = Value
  val DL, EC = Value // Description Logic, Event Calculus
}
import Extension._

class TableauFramework[T, TemporalAmount](val ruleFramework: RuleFramework[T, TemporalAmount], val extensions: Seq[Extension]) {

  type Time = T

  /**
   * How to format Time instances. Useful for tailoring, e.g., LocalDateTime
   */
  val timeFormatter: Time => String = _.toString() // Could be overwritten

  import ruleFramework._
  import ruleFramework.signature._
  implicit val sig = signature

  // Handy when importing this._ as these frequently used types become available automatically:
  // Actually, provides a lot of confusion. Not worth it.
 
  // type Rule = ruleFramework.Rule
  // type Atom = ruleFramework.signature.Atom
  // type Lit = ruleFramework.signature.Lit
  // // // val BOT = ruleFramework.signature.BOT
  // type Interpretation = ruleFramework.Interpretation

  // type IsAAt = ruleFramework.signature.IsAAt
  // type HasAAt = ruleFramework.signature.HasAAt

  // private var timeWindowFilter: Option[(Time, Lit) => Boolean] = None

  // def setTimeWindowFilter(twf: (Time, Lit) => Boolean): Unit = { timeWindowFilter = Some(twf) }

  /**
   * PseudoLits are inserted and updated by the inference engine so that these can be used in rule bodies.
   */

  trait PseudoLit
  /** `Now(time)` represents the current timepoint. There is only one instance at any time  */
  case class Now(time: Time) extends Atom with PseudoLit
  /** `Step(time, prev)` is the immediate successor relation for timepoints. Earliest `prev` is BOT, latest `time` in "now"  */
  case class Step(time: Time, prev: Time) extends Atom with PseudoLit // time is the current timepoint, prev is the current timepoint

  /**
   * Tableau represents, as an Iterator, all models of a given set of rules and an EDB.
   * A tableau is a collection of paths, as explained in the paper.
   * @param	rules the given rules
   * @param	initEDB the initial EDB (only in secondary constructor)
   * @param     useStratification determines whether rules are to be analysed for stratification and applied accordingly.
   *            If `None` us the default value `Config.useStratification` otherwise as given. Default is `None`
   */

  object EventCalculus {

    import fm6.extensions.dl.Sig.{ Individual, Concept, Role, Neg }

    import ruleFramework._
    import ruleFramework.signature.{ BOT => ShadowBOT, plus => shadowPlus, Epsilon => ShadowEpsilon, _ }

    /*
       *  Event calculus signature for external use
       */

    object Sig {

      abstract class Fluent
      abstract class Action

      case class Happens(time: Time, a: Action) extends Atom
      case class HoldsAt(time: Time, f: Fluent) extends Atom
      case class HoldsAtNext(time: Time, f: Fluent) extends Atom

      case class Initiates(time: Time, a: Action, f: Fluent) extends Atom
      // Initiated = Happens + Initiates
      case class Initiated(time: Time, f: Fluent) extends Atom

      case class Terminates(time: Time, a: Action, f: Fluent) extends Atom
      // Terminated = Happens + Terminates
      case class Terminated(time: Time, f: Fluent) extends Atom

      // Strongly termimates: Entails the negation
      case class StronglyTerminates(time: Time, a: Action, f: Fluent) extends Atom
      // StronglyTerminated = Happens + StronglyTerminates
      case class StronglyTerminated(time: Time, f: Fluent) extends Atom

      case class Tick(time: Time) extends Atom

      // DL assertions are nothing but fluents: todo: Can allow LiteralConcept instead of ConceptName?
      case class IsA(x: Individual, c: Concept) extends Fluent
      case class HasA(x: Individual, r: Role, y: Individual) extends Fluent
    }

    import Sig._

    /*
       *  Event calculus domain independent axioms
       */

    @rules
    val StdAxioms = List(
      (Initiated(plus(time, Epsilon), f): @preds("TimePlus1")) :- (
        Happens(time, a),
        Initiates(BOT, a, f),
      ),

      (Initiated(plus(time, Epsilon), f): @preds("TimePlus1")) :- (
        Happens(time, a),
        Initiates(time: @gnd, a, f),
      ),

      (Terminated(plus(time, Epsilon), f): @preds("TimePlus1")) :- (
        Happens(time, a),
        Terminates(BOT, a, f),
      ),

      (Terminated(plus(time, Epsilon), f): @preds("TimePlus1")) :- (
        Happens(time, a),
        Terminates(time: @gnd, a, f),
      ),

      (StronglyTerminated(plus(time, Epsilon), f): @preds("TimePlus1")) :- (
        Happens(time, a),
        StronglyTerminates(time: @gnd, a, f),
      ),

      Terminated(time, f) :- StronglyTerminated(time, f),

      // EC 3
      HoldsAt(time, f) :- (
        Initiated(time, f),
        NOT(
          Terminated(time: @gnd, f),
        )),

      // EC 4
      NEG(HoldsAt(time, f)) :- (
        StronglyTerminated(time, f),
        NOT(
          Initiated(time: @gnd, f),
        )),

      // EC 5 Frame Axiom
      HoldsAt(time, f) :- (
        Step(time, prev),
        HoldsAt(prev: @gnd, f),
        NOT(
          Terminated(time: @gnd, f),
        )),

      // EC 6 Frame Axiom
      NEG(HoldsAt(time, f)) :- (
        Step(time, prev),
        NEG(HoldsAt(prev: @gnd, f)),
        NOT(
          Initiated(time: @gnd, f),
        )),
    )

    /*
     *  Event calculus domain independent axioms - for description logic assertions
       */

    // The fluents IsA/HasA that currently hold need are translated into IsAAt/HasAAt counterparts
    @rules
    val DLECAxioms = List(
      // EC -> DL, via IsAAt -> IsA and HasAAt -> HasA
      IsAAt(time, x, Neg(c)) :- NEG(HoldsAt(time, IsA(x, c))),
      IsAAt(time, x, c) :- HoldsAt(time, IsA(x, c)),
      HasAAt(time, x, r, y) :- HoldsAt(time, HasA(x, r, y)),
    // No role negation
    )

    val Axioms = StdAxioms ++ DLECAxioms
  }

  var extensionRules = Seq.empty[Rule]
  if (extensions contains EC) {
    extensionRules ++= EventCalculus.StdAxioms
    if (extensions contains DL) extensionRules ++= EventCalculus.DLECAxioms
  }
  // Nothing to be done for DL only, as there are no additional rules for that


  class Tableau(inputRules: Iterable[Rule], stratificationFlag: Option[Boolean]) extends Iterator[Interpretation] {

    val rules = extensionRules ++ inputRules

    // Stratification

    var nrStrata = 1 // How many elements in strata. If not enabled use one

    // The strata can be indexed 0,1,2,... . If not enabled then there is only one level, 0
    // This way, every atom has an index as per its predName, which we want to find quickly
    val sindex = collection.mutable.AnyRefMap.empty[String, Int]

    if (rules.nonEmpty && stratificationFlag.getOrElse(Config.stratification)) {

      // rules.nonEmpty avoids a trivial corner case giving an error otherwise
      // Define  the call graph
      val callGraph = new util.Graph[String]()
      for (Rule(_, _, _, headPreds, bodyPreds, _, implicitBodyPreds) <- rules) {
        implicitBodyPreds foreach { callGraph.addNode(_) }
        bodyPreds foreach { callGraph.addNode(_) }
        headPreds foreach { callGraph.addNode(_) }
        if (bodyPreds.nonEmpty)
          for (from <- headPreds; to <- bodyPreds)
            callGraph.addEdge(from, to)
        if (implicitBodyPreds.nonEmpty)
          for (from <- headPreds; to <- implicitBodyPreds)
            callGraph.addEdge(from, to)
        if (headPreds.nonEmpty && headPreds.tail.nonEmpty) // at least two elements
          for (h1 <- headPreds; h2 <- headPreds)
            if (h1 != h2) callGraph.addEdge(h1, h2)
      }

      // Find strongly connected components, as a side effect topological sort
      val strata = callGraph.findSCCs().reverse
      nrStrata = strata.length

      // fill idx
      for ((stratum, i) <- (strata.zipWithIndex))
        for (predName <- stratum) sindex(predName) = i

      //if (Config.showStratification) println("Strata, topologically sorted, from low to high: " + (strata map { _.mkString("{", ", ", "}") }).mkString(" → "))
    } //else {
      // if (Config.showStratification) println("Stratification is off") }


      // def index(s: String): Int = if (enabled) sindex(s) else 0
      // Use default value instead:
      def index(s: String): Int = sindex.getOrElse(s, 0) // returns 0 if stratification is not enabled
      def index(l: Lit): Int = index(l.atom.predName)
      def index(o: Or): Int = index(o.elems.head)
      def index(r: Rule): Int = index(r.headPreds.head)

    // End of stratification related defs

    // Separate out the fact rules, the ones with empty body, and add the proper rules
    val properRules = new LayeredSet[Rule](nrStrata, index)
    val factRules = new LayeredSet[Rule](nrStrata, index)
    // Put rules in proper bucket
    for (rule <- rules) if (rule.isFactRule) factRules += rule else properRules += rule

    val EmptyInterpretation = new Interpretation() // Not meant to be modified

    /**
     * Path represents one path in the tableau.
     * A path in the paper is a triple (E,I,t) where E is the EDB, I is the current time and I is an IDB.
     * The model associated to it is computed by a usual given-clause loop.
     */
    class Path() {
      val edb = TimeIndexedSet.empty[Time, TemporalAmount, Lit] // The edb this path is built for
      var time: Time = BOT // The current time
      var dirty = false // whether inferences for time have been carried out
      var currentIdx: Int = 0 // The current stratification index, only heads of that level will be derived

      // The open/closed collections below have the usual meaning of the given-clause loop. The invariant is:
      // All inferences among all elements of closed have already been carried out.
      // Because of this, new inferences never need to be carried out between elements of closed only.
      // In other words, every new inference must involve an element from open.

      val openLits = new LayeredSet[Lit](nrStrata, index) // The EDB/IDB literals yet to be processed, by stratification, for the current time
      val openOrs = new LayeredSet[Or](nrStrata, index) // proper disjunctive heads still to be processed, for the current time
      val openFails = MSet.empty[FAILType] // fails to be processed, for the current time
      val closedLits = MSet.empty[Lit] // closed literals derived for the current time, accumulated over stratifications 0 .. currentIdx
      val model = new Interpretation() // All closed lits derived so far, will provide final interpretation
      val openHeadsLater = TimeIndexedSet.empty[Time, TemporalAmount, Or] // The ordinary heads, disjunctive or definite, with a time stamp later than time

      // Secondary constructor: initialize edb from a given initial EDB
      // Thereby maintaining that openLits contains all literals with current timestamp, i.e., BOT
      def init(initEDB: Iterable[Lit]): Unit = {
        // this()
        edb ++= initEDB
        openLits += Now(BOT)
        openLits ++= edb.valuesAtIterator(BOT)
        openHeadsLater ++= edb.valuesAfterIterator(BOT) map { Or(_) }
        // The above two lines alternatively:
        // edb foreach processHead(Or(_))

        // Execute the facts rules once and forall and put heads into 'open' or 'later', using processHead
        for (
          rule <- factRules;
          curriedRule = rule.rule(EmptyInterpretation);
          head <- curriedRule.exhaustOnTrue()
        ) {
          processHead(head) // todo: check for restarts and fail, which do not make sense here
        }
      }

      // Whether path has all inferences applied, for a given stratification level
      def isExhausted() = openLits.isEmpty && openOrs.isEmpty && openFails.isEmpty && openHeadsLater.isEmpty &&
        (edb.isEmpty || (edb.latestTime <= time))

      /**
       * `interpretationForNOT` returns all literals that can be used within default negation.
       *  @param	idx the stratification index
       *  @return	the set of literals that can be used within default negation
       */

      // Make a deep copy of this path
      def deepClone() = {
        // Would like to use super.val but cannot. Lots of discussions on the internet
        val edbClone = edb.clone() // no need to close as edb is immutable
        val openLitsClone = openLits.clone()
        val closedLitsClone = closedLits.clone()
        val openOrsClone = openOrs.clone()
        val openFailsClone = openFails.clone()
        val modelClone = model.clone()
        val openHeadsLaterClone = openHeadsLater.clone()
        val timeCopy = time
        val dirtyCopy = dirty
        val currentIdxCopy = currentIdx

        new Path() {
          override val edb = edbClone
          override val openLits = openLitsClone
          override val closedLits = closedLitsClone
          override val openOrs = openOrsClone
          override val openFails = openFailsClone
          override val model = modelClone
          override val openHeadsLater = openHeadsLaterClone
          time = timeCopy
          dirty = dirtyCopy
          currentIdx = currentIdxCopy
        }
      }

      // Add a strictly later literal to this path
      def +=(l: Lit): Unit = {
        if (l.time > time || (!dirty && l.time == time)) {
          edb += l
          openHeadsLater += Or(l)
        } else throw ERROR(s"EDB literal time ${l.time} is before or equal to path time $time")
      }

      def ++=(ls: Iterable[Lit]): Unit = ls foreach { this += _ }

      // Put a derived head in the proper open or later set
      def processHead(h: Head): Unit = {
        h match {
          case fail: FAILType => openFails += fail // todo: check time?
          case FAIL => openFails += FAIL() // indicates failure of this candidate
          case And(Or()) => throw ERROR("rule with empty head") // The empty head is not allowed in the language
          case And(Or(TRUELit)) => ()
          case and: And =>
            if (and.time == time) {
              for (or <- and.ors) {
                if (or.elems.isEmpty)
                  throw ERROR("empty head")
                else if (or.elems.tail.isEmpty)
                  openLits += or.elems.head
                else openOrs += or
              }
            } else if (and.time > time)
              openHeadsLater ++= and.ors
            // throw ERROR(s"head with time in the future: $h")
            // laterExps += or
            else throw ERROR(s"head with time in the past: $h")
        }
      }

      /**
       * Exhausts this path under inferences with rules under inferences involving an open literal:
       * - Single conlusions go directly back into open literals and are processed again
       * - Proper disjunctions are collected for later treatment
       * - FAILs are also collected for later
       *
       * After termination `closedLits` contains all `openLits` initially given plus the derived ones.
       *
       *  @param	idx stratification level, only rules with heads from this level are taken
       */

      def exhaust(idx: Int): Unit = {

        /*
         * Invariant: all inferences between all closed lits and rules in effect have been carried out
         */

        dirty = true

        if (Config.debug) {
          logln(s"exhaust: stratification idx = $idx")
        }

        if (Config.debug) {
          logln(s"exhaust: exhausting fact rules")
        }

        // Execute the proper rules for the current stratification level
        while (openLits.nonEmptyTo(idx)) {
          val pivot = openLits.lowestRemoved(idx)
          // Test for !(closedLits contains pivot) is sufficient because pivot must have same time and level
          if (!(closedLits contains pivot)) {
            // No need to duplicate (forward subsumption)
            // Implicit rule says that cannot have both a literal and its complement
            if (closedLits contains pivot.compl) throw ABORT // test for closedLits suffices because complement has same time and stratification
            closedLits += pivot
            model += pivot
            if (Config.debug) logln(s"exhaust: pivot = $pivot")
            // Apply all rules to model involving pivot
            // The relevant rules are those with a head for the current stratification
            for (
              rule <- properRules(idx);
              if (rule.bodyPreds contains pivot.atom.predName); // Efficieny - avoid calling rules that cannot match the pivot
              curriedRule = rule.rule(model);
              head <- curriedRule.exhaust(pivot, model)
            ) {
              // println(s"xxx processing head $head")
              processHead(head)
            }
          }
        }
      }

      def pp(): Unit = {
        val indent = " " * "closedLits: ".length
        println("openLits:       " + openLits.mkString("\n" + indent))
        println("openOrs:        " + openOrs.mkString("\n" + indent))
        println("openFails:      " + openFails.mkString("\n" + indent))
        println("closedLits:  " + closedLits.mkString("\n" + indent))
        println("model:     " + model.mkString("\n" + indent))
        println("openHeadsLater: " + openHeadsLater.mkString("\n" + indent))
        println("time:           " + time)
        println("currentIdx:     " + currentIdx + s" (of ${nrStrata - 1})")
      }
    }
    // End Path

    /*
     * Main body of Tableau
     */

    // A tableau is comprised of a set of paths.
    // We use a buffer to have control over the order of the paths.
    type Paths = collection.mutable.UnrolledBuffer[Path]

    val paths = new Paths()

    // Secondary constructor - with initial EDB
    def this(rules: Iterable[Rule], initEDB: Iterable[Lit], stratificationFlag: Option[Boolean] = None) = {
      this(rules, stratificationFlag)
      val p = new Path()
      p.init(initEDB)
      paths += p
    }

    // Queue like headRemoved on UnrolledBuffer
    implicit class MyPaths(b: Paths) {
      def removedHead() = {
        val res = b.head
        b.trimStart(1)
        res
      }
    }

    case object UNSAT extends Exception // Thrown if there is no (more) model

    // exhaustFirstPath: fully exhaust the first (leftmost) path.
    // Evaluates according to the forest-of-trees model visualization, see the paper.
    // Evaluation is lazy and returns the first path.
    // New paths are added to the right.
    // If no model exists throw UNSAT
    // If the first path is already exhausted this is an O(1) operation and does not change anything.
    // I.e. exhaustFirst is idempotent and there is no performance penalty to call exhaustFirst repeatedly.
    def exhaustFirstPath() = {
      // if (Config.verbose) {
      //   logln(Stratification.infoString())
      //   logln("Model computation ...")
      // }

      var lastVerbPath: Path = null
      var lastVerbPathTime: Time = BOT
      var lastVerbNrLaterEDB: Int = -1

      // We need to search a bit because the first path could FAIL
      while (paths.nonEmpty && !paths.head.isExhausted()) {
        if (Config.debug) {
          logln(s"exhaustFirstPath: paths at main loop entry, current path time = ${paths.head.time}, current path stratification index = ${paths.head.currentIdx}".green)
          pp()
        }

        try {

          /*
           * Ext inference rule:
           * open literals
           */

          val p = paths.head
          // This is the Ext inference rule restricted to unit (non-disjunctive) conclusions: add units as long as possible, as they do not introduce branching
          p.exhaust(p.currentIdx)
          if (Config.debug) {
            logln(s"openLits loop: current path is exhausted for stratification index ${p.currentIdx}")
            logln("openLits loop: paths afterwards:".blue)
            pp()
          }

          assume(p.openLits.isEmptyTo(p.currentIdx))

          // This is the Ext inference rule for non-unit (disjunctive) conclusions:
          // Need to look at open Ors until a non-redundant expansion into branches is found, or run out of disjunctions
          if (p.openOrs.nonEmptyTo(p.currentIdx)) {

            /*
             * Ext inference rule:
             * open disjunctive heads
             */

            val o = p.openOrs.lowestRemoved(p.currentIdx) // can remove destructively because we are working on it
            if (Config.debug) logln(s"openOrs: selected disjunction = $o".blue)
            // logln(s"openOrs loop: selected disjunction = $o".red)
            assume(o.elems.length >= 2)
            // splitss is the set S in possible models lingo, i.e. the set of all non-empty subsets of the head
            // We remove all subsumed literals from each set
            val headSet = o.elems.to(Set)
            val headLitsSubsets = headSet.subsets() filter { _.nonEmpty }
            val splitss = headLitsSubsets.to(Set) map { _ -- p.model }
            val redundantLits = headSet intersect p.model
            // splitss can contain empty set

            if (Config.debug) {
              logln("openOrs: splitss =         " + (splitss map { _.mkString("{", ",", "}") }).mkString("{", ",", "}"))
            }
            paths.removedHead() // removes current path p from paths
            if (Config.debug) logln(s"openOrs: adding ${splitss.size} new paths")
            // splitLitss is not empty, replace p by its extensions
            splitss foreach { ls =>
              val newPath = p.deepClone()
              // Instead of adding nothing if ls.isEmpty we add the redundant literals, to keep exhaustion going,
              // which may be needed for COLLECT literals
              // todo: some way around this?
              if (ls.nonEmpty)
                newPath.openLits ++= ls
              else
                newPath.openLits ++= redundantLits
              if (Config.debug) {
                logln("openOrs: add path:")
                newPath.pp()
              }
              newPath +=: paths
              // Notice that stratification remains the same, no change to p.closedLits
            }
          } else if (p.currentIdx < nrStrata - 1) {
            // It holds p.openOrs.isEmptyTo(p.currentIdx) && p.openLits.isEmptyTo(p.currentIdx)

            /*
           * Stratification increase
           */

            // See if we can get new open lits by increasing the stratification level, if possible.
            // Example is in example/scripts/stratification-demo.sh :
            // @rules
            // val rules = List(
            // J(time) :- E(time),
            // K(time) :- (E(time), NOT(J(time))),
            // )
            // We have the strata, topologically sorted, from low to high: {E} → {J} → {K}
            // Say that E(0) is given and the current stratification level corresponds to {J},
            // then J(0) *has* been computed by the above but is put into p.closedLits eventually.
            // The code below increases the stratification level, corresponding to enabling {E, J, K}, and moves J(0) into the p.openLits set.

            if (Config.debug) logln(s"stratification level increase ${p.currentIdx} -> ${p.currentIdx + 1}, max is ${nrStrata - 1}".blue)
            // The new closed literals become open literals
            // p.openLits is possibly not empty because of facts, which are inserted out of order
            // but of course p.openLits.isEmptyTo(p.currentIdx) holds
            p.openLits ++= p.closedLits
            p.closedLits.clear() // We are in next stratification level now
            p.currentIdx += 1 // move on to next layer

          } else {
            // it holds p.currentIdx == nrStrata - 1
            // entails p.openLits.isEmpty && p.openOrs.isEmpty
            if (Config.debug) {
              logln(s"stratification level ${p.currentIdx} is exhausted for Ext inferences; this was the last level".blue)
              logln(s"time ${p.time} is exhausted for Ext inferences. Considering restart or time increase".blue)
            }
            if (Config.verbose) {
              val (t, s) = (p.time, p.openHeadsLater.size)
              if (lastVerbPath == null || lastVerbPathTime == BOT || p != lastVerbPath || lastVerbPathTime != t || lastVerbNrLaterEDB != s) {
                if (Config.verbosePreds.nonEmpty) {
                  // print all literals for current time as specified in Config.verbosePreds
                  for (l <- (p.closedLits) filter { l => Config.verbosePreds exists { _ matches l.atom.predName } }) {
                    //loglnt(timeFormatter(t), l)
                  }
                }
                //loglnt(timeFormatter(t), s"[$s]")
                lastVerbPath = p
                lastVerbPathTime = t
                lastVerbNrLaterEDB = s
              }
            }

            p.closedLits.clear()

            if (p.openFails.nonEmpty) {

              /*
             * Restart or Fail
             */

              // p is closed, need to remember it
              unsatEDBs += p.edb
              if (Config.debug) {
                logln("openFails loop: paths edbs:".blue)
                paths foreach { p => ppLits(p.edb) }
                logln("openFails loop: modelPaths edbs:".blue)
                modelPaths foreach { p => ppLits(p.edb) }
                logln(s"openFails loop: openFails = ${p.openFails}".blue)
              }
              // Deal with GFAILs and FAILs
              val (grouped, nonGrouped) = p.openFails partition { _.isInstanceOf[GFAIL] }
              // Collect all groups of GFAILs with the same group and turn into ordinary FAILs
              val groupedAsNonGrouped = (grouped.asInstanceOf[MSet[GFAIL]] groupBy { _.group }).values map { gfails =>
                // gfails is an MSET of GFAILs, each with the same group. Combine into one FAIL
                val allMods = gfails flatMap { _.mods } // Union of all mods
                FAIL(allMods.toSeq: _*) // Sequence in any order
              }
              // Collect all FAIL heads
              // An empty fail head FAIL() requires no explicit treatment, as the current path is just to be removed
              val restarts = groupedAsNonGrouped ++ (nonGrouped.asInstanceOf[MSet[FAIL]] filterNot { _.mods.isEmpty })
              // for (restart <- p.openFails; if restart.mods.nonEmpty) {
              for (restart <- restarts) {
                if (Config.logRestartHeads) loglnt(timeFormatter(p.time), restart.mods.mkString(", ").red)
                // construct the modified EDB
                val newEDB = p.edb.clone()
                for (mod <- restart.mods) {
                  mod match {
                    case ASSERT(lit) => newEDB += lit
                    case RETRACT(lit) => newEDB -= lit
                  }
                }
                if (unsatEDBs contains newEDB) {
                  if (Config.debug) logln(s"openFails loop:   skip UNSAT newEDB = $newEDB")
                } else if ((paths exists { q => q != p && q.edb == newEDB }) || (modelPaths exists { _.edb == newEDB })) {
                  if (Config.debug) logln(s"openFails loop:   skip redundant newEDB = $newEDB")
                } else {
                  // Execute the restart
                  // Remaining times can be empty or later than restart.earliest.time
                  newEDB.earliestTimeFrom(restart.earliest.time) match {
                    case None => ()
                    case Some(nextTime) =>
                      // build the new path q incrementally from p up to the earliest modification
                      val q = new Path() { override val edb = newEDB }
                      // Set up the new path similarly as with Jump inference
                      // Set time of q to the earliest time from which edb differs from current one
                      // and initialize, all done similarly as for path initialization with edb, cf secondary constructor
                      q.time = nextTime
                      // q.dirty = false // by default
                      q.currentIdx = 0 // restart with lowest stratum
                      // Set up openLits and openHeadsLater; openOrs must be empty
                      q.openLits += Now(nextTime)
                      q.openLits ++= newEDB.valuesAt(nextTime) // guaranteed to exist
                      q.openHeadsLater ++= newEDB.valuesAfterIterator(nextTime) map { Or(_) }
                      // openHeadsLater is obtained to processHead, but ignores earlier times
                      for (
                        rule <- factRules;
                        curriedRule = rule.rule(EmptyInterpretation);
                        head <- curriedRule.exhaustOnTrue()
                      ) {
                        head match {
                          case and: And =>
                            if (and.time == nextTime) {
                              for (or <- and.ors) {
                                if (or.elems.isEmpty)
                                  throw ERROR("empty head")
                                else if (or.elems.tail.isEmpty)
                                  q.openLits += or.elems.head
                                else q.openOrs += or
                              }
                            } else if (and.time > nextTime)
                              q.openHeadsLater ++= and.ors
                          // earlier time ignored - has been processed already
                        }
                      }
                      // Find latest time before nextTime in newEDB and add the Step instance
                      newEDB.latestTimeUntil(nextTime) match {
                        case None => ()
                        case Some(prevTime) => q.openLits += Step(nextTime, prevTime)
                      }
                      // q.closedLits ++= p.closedLits filter { _.time < nextTime }
                      // This is faster:
                      for (interp <- p.model.index.values) q.model ++= interp.valuesUntilIterator(nextTime)
                      if (Config.debug) {
                        logln(s"openFails loop:   new path:")
                        q.pp()
                      }
                      paths += q
                  }
                }
              }
              paths.removedHead() // removes p, as restart acts like fail
            } else {
              // openFails is empty - try Jump (time increase)
              // See if there are more timepoints
              val currentTime = p.time
              p.openHeadsLater.earliestTimeAfter(currentTime) match {
                case None => () // Time exhausted
                case Some(nextTime) =>

                  /*
                 * Jump (time increase)
                 */

                  // Here we know p.openLits.isEmpty && p.openOrs.isEmpty && p.openFails.isEmpty
                  // nextTime will be the next current time
                  // Adjust the Now literal and add Step literal
                  p.openLits += Now(nextTime)
                  p.openLits += Step(nextTime, currentTime)
                  p.model -= Now(currentTime)
                  if (Config.debug) {
                    // logln(s"laterEDB:   $laterLits".blue)
                    logln(s"openHeadsLater:   nextTime = $nextTime")
                  }
                  // Move elements from openHeadsLater into appropriate open bucket
                  for (or <- p.openHeadsLater.valuesAt(nextTime)) {
                    if (or.elems.tail.isEmpty)
                      p.openLits += or.elems.head
                    else p.openOrs += or
                  }
                  p.openHeadsLater.clearAt(nextTime)
                  p.currentIdx = 0 // restart with lowest stratum
                  p.time = nextTime
                  p.dirty = false
                  if (Config.debug) {
                    logln(s"openHeadsLater:   current path now:")
                    pp()
                  }
              }
            }
          }
          // p.closedLits contains the open lits for the next stratification, if any
        } catch {
          case ABORT =>
            unsatEDBs += paths.head.edb.clone()
            paths.removedHead()
        }
        // Done with openLits, i.e. paths.head.openLits(p.currentIdx) is empty
        // The newly derived literals for p.currentIdx are in p.closedLits
      }

      // After while loop. Either throw UNSAT or return a model
      if (paths.isEmpty) throw UNSAT
      else new Interpretation(paths.head.model filterNot { _.isInstanceOf[PseudoLit] })
    }

    /*
     * Scala Iterator interface
     */
    var model: Interpretation = _
    var modelDone = false // Whether model has a model
    val modelPaths = new Paths()
    // val unsatEDBs = MSet.empty[Set[Lit]]
    val unsatEDBs = MSet.empty[TimeIndexedSet[Time, TemporalAmount, Lit]]

    def hasNext = modelDone || (try {
      model = exhaustFirstPath()
      // model = paths.head.closedLitsEarlier.toInterpretation
      modelDone = true
      true
    } catch {
      case e: ERROR =>
        error(e.msg); throw e
      case UNSAT => false // must have modelDone == false
    })

    def next() = {
      if (!hasNext) throw ERROR("next on empty tableau")
      // it holds model == paths.head  Move it to modelPaths
      modelPaths += paths.removedHead()
      // pathsCache.clear()
      modelDone = false
      // model still has the model
      model
    }

    // The result models, as a List (iterable, can be re-iterated)
    private var modelsList = List.empty[Set[Lit]]
    private var modelsListIsValid = false

    /* WARNING: use either Iterator or 'models()' - mixing might confuse either */

    def models() = {
      // if modelDone holds assume modelsList has already the result
      if (!modelsListIsValid) {
        modelsList = List.empty
        while (hasNext) {
          modelsList ::= next().to(Set)
        }
        modelsListIsValid = true
      }
      modelsList
    }

    /*
     * Public methods
     */

    // todo: add a way to branch out on a given path
    
    // ++= : add the given Lits to every path in the tableau
    // The model paths so far have to be re-opened again with the new literals added
    def ++=(ls: Iterable[Lit]): Unit = {
      try {
        if (ls.nonEmpty) {
          // Bring back modelPaths by prepending to paths
          modelPaths ++=: paths
          modelPaths.clear()
          paths foreach { _ ++= ls }
          modelDone = false
          modelsListIsValid = false
        }
      } catch {
        case e: ERROR => error(e.msg); throw e
      }
    }

    def +=(l: Lit): Unit = { this ++= List(l) }

    def pp(): Unit = {
      println(s"Tableau with ${modelPaths.size} done paths and ${paths.size} open paths")
      println("Done paths")
      println("==========")
      modelPaths foreach { p =>
        println("---")
        p.pp()
      }
      println("Open paths")
      println("==========")
      paths foreach { p =>
        println("---")
        p.pp()
      }
    }
  }

  /**
   * xlog can be used in bodies for its side effect of printing its arguments.
   * @param time the time to be logged
   * @param s the data to be logged
   * @return true
   */
  def xlog(time: Time, s: Any) = {
    if (Config.xlog) loglnt(timeFormatter(time), "[xlog] ".red + s.toString)
    true
  }
}

