package fm6

import fm6.util.Logging._
import fm6.Config._

import java.time.OffsetDateTime
import collection.immutable.Set
import collection.mutable.Queue
import collection.mutable.UnrolledBuffer
import scala.annotation.StaticAnnotation

class RuleFramework[Time, TemporalAmount](val signature: Signature[Time, TemporalAmount]) {

  import collection.mutable.{ HashSet => MSet }

  import signature._
  implicit val sig = signature

  type Interpretation = fm6.Interpretation[Time, TemporalAmount, Lit]

  // The time windows for each predicate symbols
  val timeWindow = collection.mutable.AnyRefMap.empty[String, TemporalAmount]

  /*
   * Logic programming style rules
   */

  /* The annotation `@rules` is implemented by the compiler plugin as a transformation into Scala partial functions.
   * A rule annotation `@rules` can currently by used only in conjunction with a val definition and lists, e.g.
   * @rules
   * val rules = List(
   *   World(time) :- Hello(time)
   * )
   */
  class rules(args: Any*) extends StaticAnnotation

  /*
   * CurriedRule is a Head or a ProperCurriedRule
   */

  trait CurriedRule

  /*
   *  Rule head:
   * - And-or structure of ordinary literals, or
   * - FAIL head
   */


  trait Head extends CurriedRule

  /*
   * Ordinary heads are "and of ors"
   */

  case class Or(elems: Lit*) extends Timed { // with HasIndex {
    assume(elems.nonEmpty)
    val time = elems.head.time
    assume(elems forall { _.time == time })
    // Infix operators as syntactic sugar
    def OR(elem: Lit) = Or((elems :+ elem): _*)
    def AND(or: Or) = And(this, or)
    def AND(a: Lit) = And(this, Or(a))

    override def toString() =
      elems.length match {
        case 0 => "FALSE"
        case 1 => elems(0).toString()
        case _ => elems.mkString("(", " OR ", ")")
      }
  }

  case class And(ors: Or*) extends Head with Timed {
    val time = ors.head.time
    assume(ors forall { _.time == time })

    // Infix operators as syntactic sugar
    // def AND(a: Lit) = And((ors :+ Or(a)): _*)
    // def AND(or: Or) = And((ors :+ or): _*)

    override def toString() =
      ors.length match {
        case 0 => "TRUE"
        case _ => ors.mkString(" AND ")
      }
  }

  // Handy abbreviations
  def And(lits: Lit*) = if (lits.isEmpty) new And(Or(TRUE)) else new And((lits map { Or(_) }): _*)
  def AndOf(lits: Iterable[Lit]) = new And((lits.to(Seq) map { Or(_) }): _*)

  // DNF combinations of literals are needed to form ordinary heads
  implicit def litToOr(a: Lit) = Or(a)
  implicit def atomToCNF(a: Atom) = And(Or(a.toLit))
  implicit def litToCNF(l: Lit) = And(Or(l))
  implicit def orToCNF(or: Or) = And(or)
  implicit class MyIDBLit(l: Lit) {
    // Should not be neceessary, wiyth implicit conversion atom -> lit
    // def OR(elem: Atom) = Or(l, elem.toLit)
    def OR(elem: Lit) = Or(l, elem)
    def AND(elem: Lit) = And(Or(l), Or(elem))
    // def AND(elem: Atom) = And(Or(l), Or(elem.toLit))
    def AND(or: Or) = And(Or(l), or)
  }

  implicit class MyIDBAtom(a: Atom) {
    // Should not be neceessary, wiyth implicit conversion atom -> lit
    // def OR(elem: Atom) = Or(l, elem.toLit)
    def OR(elem: Lit) = Or(a.toLit, elem)
    def AND(elem: Lit) = And(Or(a.toLit), Or(elem))
    // def AND(elem: Atom) = And(Or(l), Or(elem.toLit))
    def AND(or: Or) = And(Or(a.toLit), or)

  // For enbaling syntax +lit and -lit in FAIL heads
    def unary_+ = ASSERT(a.toLit)
    def unary_- = RETRACT(a.toLit)

  }


  /*
   *  Fail heads
   */


  /**
   * EDBMod is the base class of modifications (assert/retract)
   */
  abstract class EDBMod {
    def applyTo(edb: Set[Lit]): Set[Lit] // Executing this mod on a given set of literals
    def time: Time // The time of the literal of this mod
  }
  case class ASSERT(f: Lit) extends EDBMod {
    def applyTo(edb: Set[Lit]) = edb + f
    def time = f.time
    def :| (group: Int) = GFAIL(group, this)
  }

  case class RETRACT(f: Lit) extends EDBMod {
    def applyTo(edb: Set[Lit]) = edb - f
    def time = f.time
  }

  // For enbaling syntax +lit and -lit in FAIL heads
  implicit class MyLit(lit: Lit) {
    def unary_+ = ASSERT(lit)
    def unary_- = RETRACT(lit)
  }

  abstract class FAILType {
    val mods: Seq[EDBMod]
  }

  /**
   *  Fail heads as defined in the paper
   */
  case class FAIL(mods: EDBMod*) extends FAILType with Head {
    override def toString = "FAIL" + mods.mkString("(", ", ", ")")
    // Apply elems to a given set of EDB Literals
    // todo: is it worth considering intermediate mutable data structures?
    // Currently not needed
    /*
    def applyTo(edb: Set[Lit]) = {
      var res = edb
      for (mod <- mods) { res = mod.applyTo(edb) }
      res
    }
     */
    def earliest = mods minBy { _.time }
  }

  // "Grouped" fail
  case class GFAIL(group: Int, mods: EDBMod*) extends FAILType with Head {
    assume(mods.nonEmpty)
    override def toString = s"CFAIL($group, " + mods.mkString("", ", ", "") + ")"
    // Apply elems to a given set of EDB Literals
    // todo: is it worth considering intermediate mutable data structures?
    // Currently not needed
    /*
    def applyTo(edb: Set[Lit]) = {
      var res = edb
      for (mod <- mods) { res = mod.applyTo(edb) }
      res
    }
     */
    // def earliest = mods minBy { _.time }
  }

  case class COLLECTResult(result: Any) extends Head
  case class CHOOSEResult(result: Any) extends Head


  case object SUCCESS extends Exception with Head 
  /** ABORT fails a model construction immediately, without possibility of restart, e.g. for complementary literals */
  case object ABORT extends Exception with Head // 
  /** FAIL without a restart, as defined in the paper */
  case object FAIL extends Head


  /*
   * ProperCurriedRule
   */

  abstract class PCRSubcase
  object PCRSubcase {

    // Can only be used with Literal
    case class TimeBound(timeOf: PartialFunction[Lit, Time], op: String, bound: Time)

    case class Literal(timeBound: Option[TimeBound], pf: PartialFunction[Lit, CurriedRule]) extends PCRSubcase
    case class Pivot(time: Time, predName: String, pf: PartialFunction[Lit, CurriedRule]) extends PCRSubcase
    //case class PosBodyPred(predName: String, pf: PartialFunction[Lit, CurriedRule]) extends PCRSubcase
    // todo: can we have Rule parametric in the result type, which would allow type inference in the next two cases
    case class COLLECT(rule: Rule, pf: PartialFunction[List[Any], CurriedRule]) extends PCRSubcase
    case class CHOOSE[T](code: () => Iterable[T], pf: PartialFunction[T, CurriedRule]) extends PCRSubcase
    case class LET[T](code: () => T, pf: PartialFunction[T, CurriedRule]) extends PCRSubcase
    case class MATCH(code: () => Lit, pf: PartialFunction[Lit, CurriedRule]) extends PCRSubcase
  }


  // Applicability conditions for ProperCurriedRules
  abstract class OPRCond
  case object OPRNone extends OPRCond
  case class OPRTimeBound(timeOf: PartialFunction[Lit, Time], op: String, bound: Time) extends OPRCond

  case class ProperCurriedRule(predSyms: List[String], subcase: PCRSubcase) extends CurriedRule {

    // A "fact rule" is a rule with an "empty" body, which is the ProperCurriedRule representation of 'head :- TRUE'
    val isFactRule = predSyms == List("TRUE")

    /** exhaust(pivot, usable) applies rule in all possible way to the
      *  literals in `usable` so that `pivot` is used at least once.
      *  Result is the collection of heads where the body is satisfied.
      *  Assume that usable contains pivot.
      */

    def exhaust(pivot: Lit, usable: Interpretation): MSet[Head] = {
      val res = MSet.empty[Head]

      // if (debug) println(s"exhaustOn($pivot, ...)".red)
      val now = usable.latestTime

      def exhaustInner(pivotUsedAlready: Boolean, cpr: CurriedRule): Unit = {
        cpr match {
          case h: Head => h match {
            case SUCCESS => throw SUCCESS
            case ABORT => throw ABORT
            case other => res += other
          }
          case ProperCurriedRule(predSyms, subcase) =>
            subcase match {
              case PCRSubcase.Literal(timeBound, pf) =>
                val p = predSyms.head
                // u is the relevant subset of usable to match the rule premise against
                // filter u further by time and conditions. uIsSound means that u contains only elements that satisfy all constraints
                val (u, uIsSound) =
                  if (p == TRUE.predName) {
                    if (pf.isDefinedAt(TRUE)) (MSet[Lit](TRUE), true) else (MSet.empty[Lit], true)
                  } else {
                    val usableForP = usable.forPred(p)
                    val windowForP = timeWindow.get(p) map { amount => (amount, now) } // replace Some(amount) by Some((amount, now)) if nonEmpty
                    timeBound match {
                      case None =>
                        val timesIterator = usableForP.timesIterator(windowForP)
                        // Constructing a set does not seem to incur a performance penalty
                        val res = MSet.empty[Lit]
                        for (t <- timesIterator) res ++= usableForP.valuesAt(t)
                        (res, false)

                      case Some(PCRSubcase.TimeBound(timeOf, op, bound)) =>
                        // Note: this works in presence of both positive and negative literals because, because of test pf.isDefinedAt(l) which matches only usable elements of same sign as current body literals
                        val timesIterator =
                          op match {
                            case "$eq$eq" => usableForP.timesAtIterator(bound, windowForP) // At most one element
                            case "$less" => usableForP.timesUntilIterator(bound, windowForP)
                            case "$less$eq" => usableForP.timesToIterator(bound, windowForP)
                            case "$greater" => usableForP.timesAfterIterator(bound, windowForP)
                            case "$greater$eq" => usableForP.timesFromIterator(bound, windowForP)
                          }
                        var res = MSet.empty[Lit]
                        while (res.isEmpty && timesIterator.hasNext) {
                          val t = timesIterator.next()
                          res = usableForP.valuesAt(t) collect { case l if pf.isDefinedAt(l) => l }
                        }
                        (res, true)
                    }
                  }

                if (pivotUsedAlready) {
                  // Need to consider all elements from usable
                  if (uIsSound)
                    for (k <- u) exhaustInner(true, pf(k))
                  else
                    for (k <- u) if (pf.isDefinedAt(k)) exhaustInner(true, pf(k))
                } else {
                  val restHasPivotMaybe = (predSyms.tail contains pivot.atom.predName)
                    (uIsSound, restHasPivotMaybe) match {
                    case (true, true) => for (k <- u) exhaustInner(k == pivot, pf(k))
                    case (true, false) => for (k <- u) if (k == pivot) exhaustInner(true, pf(k))
                    case (false, true) => for (k <- u) if (pf.isDefinedAt(k)) exhaustInner(k == pivot, pf(k))
                    case (false, false) => for (k <- u) if ((k == pivot) && pf.isDefinedAt(k)) exhaustInner(true, pf(k))
                  }
                }
              case PCRSubcase.Pivot(now, predName, pf) =>
                // println(s"PCRSubcase.Pivot, pivot = $pivot, predName = $predName, time = $time")
                if (pivotUsedAlready) exhaustInner(true, pf(TRUE))
                else {
                  // pivotUsedAlready is false
                  val restHasPivotMaybe = (predSyms.tail contains pivot.atom.predName)
                  val pivotIsUsable = pivot.atom.predName == predName && pivot.time == now
                  // println(s"PCRSubcase.Pivot, pivot = $pivot, predName = $predName, pivotIsUsable = $pivotIsUsable, restHasPivotMaybe = $restHasPivotMaybe")
                  (pivotIsUsable, restHasPivotMaybe) match {
                    case (true, true) =>
                      exhaustInner(true, pf(TRUE)) // use pivot here
                      // The 'false' case is subsumed by the 'true' case, the 'true' case enables strictly more cases
                      // exhaustInner(false, pf()) // use pivot it later
                    case (true, false) => exhaustInner(true, pf(TRUE)) // must use pivot here
                    case (false, true) => exhaustInner(false, pf(TRUE)) // cannot use pivot here
                    case (false, false) => () 
                  }
                }
              // case PCRSubcase.PosBodyPred(predName, pf) =>
              //   // Just ignore - only used for stratification
              //   exhaustInner(pivotUsedAlready, pf(TRUE))
              case PCRSubcase.COLLECT(rule, pf) =>
                // println(s"")
                // println(s"xxx rule " + rule.toString())
                // println(s"xxx usable " + usable)
                val allHeads = rule.exhaustOn(usable)
                val allRes = allHeads.toList collect { case COLLECTResult(res) => res }
                // println(s"xxx allRes " + allRes)
                // println(s"")
                if (pivotUsedAlready) {
                  exhaustInner(true, pf(allRes))
                } else {
                  val restHasPivotMayby = (predSyms.tail contains pivot.atom.predName) // so that there is a chance to find pivot in rest
                  if (restHasPivotMayby) exhaustInner(false, pf(allRes))
                }
              case PCRSubcase.CHOOSE(codeFn, pf) =>
                lazy val codeRes = codeFn()
                if (pivotUsedAlready) {
                  for (res <- codeRes) 
                    exhaustInner(true, pf(res))
                } else {
                  val restHasPivotMayby = (predSyms.tail contains pivot.atom.predName) // so that there is a chance to find pivot in rest
                  if (restHasPivotMayby) {
                    for (res <- codeRes)
                      exhaustInner(false, pf(res))
                  }
                }
              case PCRSubcase.LET(codeFn, pf) =>
                lazy val codeRes = codeFn()
                if (pivotUsedAlready) {
                  exhaustInner(true, pf(codeRes))
                } else {
                  val restHasPivotMayby = (predSyms.tail contains pivot.atom.predName) // so that there is a chance to find pivot in rest
                  if (restHasPivotMayby) exhaustInner(false, pf(codeRes))
                }
              case PCRSubcase.MATCH(codeFn, pf) =>
                lazy val codeRes = codeFn()
                if (pivotUsedAlready) {
                  if (pf.isDefinedAt(codeRes)) exhaustInner(true, pf(codeRes))
                } else {
                  val restHasPivotMayby = (predSyms.tail contains pivot.atom.predName) // so that there is a chance to find pivot in rest
                  if (restHasPivotMayby) {
                    if (pf.isDefinedAt(codeRes)) exhaustInner(false, pf(codeRes))
                  }
                }
            }
        }
      }
      exhaustInner(false, this)
      res
    }

    def exhaustOnTrue() = {
      // assume(! subcase.isInstanceOf[PCRSubcase.Literal], "Fact rule with unsupported body")
      val rule = subcase.asInstanceOf[PCRSubcase.Literal].pf
      if (rule.isDefinedAt(TRUE)) {
        rule(TRUE) match {
          case SUCCESS => throw SUCCESS
          case ABORT => throw ABORT
          case h: Head => MSet(h)
        }
      } else MSet.empty[Head]
    }

    // Trivialized pivot - no guidance at all.
    def exhaustNoPivot(usable: Interpretation, bodyPreds: Set[String]) = {
      val res = MSet.empty[Head]
      // for (pivot <- usable) { res ++= this.exhaustOn(pivot, usable, bodyLength) }
      for (pivot <- usable;
        if bodyPreds contains pivot.atom.predName
      ) { res ++= this.exhaust(pivot, usable) }
      res
    }

    def succeedsOn(I: Interpretation, bodyPreds: Set[String]) = {
      // Tacitly assume that the head of this rule is SUCCESS
      try {
        if (isFactRule) this.exhaustOnTrue() else this.exhaustNoPivot(I, bodyPreds)
        false
      } catch {
        case SUCCESS => true
      }
    }

    def failsOn(I: Interpretation, bodyPreds: Set[String]) = {
      // Tacitly assume that the head of this rule is ABORT
      try {
        if (isFactRule) this.exhaustOnTrue() else this.exhaustNoPivot(I, bodyPreds)
        true
      } catch {
        case ABORT => false
      }
    }
  }


  /** Rule represents a logic programming rule.
    * @param rule This is the rule proper with typing `Interpretation => ProperCurriedRule`.
    *    The interpretation provides the context (current interpretation) for evaluating the partial function.
    *    The partial function is a case statement whose case-clause is a list of literals corresponding to the rule's positive body literals
    *    and whose conclusion is the head of the rule. Neagtive body literals are compiled away into the if-part of the case statement.
    * @param bodylength is the number of the positive body literals.
    * @param ruleString is a String representation of the rule 
    * @param headPreds is the set of predicate symbols appearing in the head of the rule.
    * @param bodyPreds is the set of predicate symbols appearing in the body of the rule. 
    *    These sets are needed for computing the strata of the program
   */


  case class Rule(
    // rule: Interpretation => PartialFunction[PosBody, Head],
    rule: Interpretation => ProperCurriedRule, // Interpretation is for evaluating NOT literals
    isFactRule: Boolean,
    ruleString: String,
    headPreds: Set[String],
    bodyPreds: Set[String],
    scalaCodeString: String,
    implicitBodyPreds: Set[String] //  = Set.empty
  ) { 
    override def toString() = ruleString
    // def addImplicitBodyPreds(preds: Iterable[String]) =
    //   Rule(rule, isFactRule, ruleString, headPreds, bodyPreds, scalaCodeString, implicitBodyPreds ++ preds)
    def exhaustOn(usable: Interpretation) =
      if (isFactRule)
        rule(usable).exhaustOnTrue()
      else 
        rule(usable).exhaustNoPivot(usable, bodyPreds)
  }
}
