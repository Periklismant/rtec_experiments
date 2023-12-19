package fm6.plugin

import scala.tools.nsc
import nsc.Global
import nsc.Phase
import nsc.plugins.Plugin
import nsc.plugins.PluginComponent
import nsc.transform.Transform


// Another one:
/*

package com.softwaremill

import scala.tools.nsc.{Global, Phase}
import scala.tools.nsc.plugins.{Plugin, PluginComponent}

class ScalaCompilerPlugin(override val global: Global) extends Plugin {

  override val name: String = "scala-compiler-plugin"
  override val description: String = "scala compiler plugin simple example"

  override val components: List[PluginComponent] = List(new ScalaCompilerPluginComponent(global))
}

class ScalaCompilerPluginComponent(val global: Global) extends PluginComponent {
  override val phaseName: String = "compiler-plugin-phase"
  override val runsAfter: List[String] = List("parser")

  override def newPhase(prev: Phase): Phase = new StdPhase(prev) {
    override def apply(unit: global.CompilationUnit): Unit = {
      global.reporter.echo("implement me ")
    }
  }
}

 */

class Fusemate(val global: Global) extends Plugin {
  import global._

  val name = "fusemate"
  val description = "provides logic-programming style rules"
  val components = List[PluginComponent](Component)

  // Modelled after https://github.com/mkubala/stringmask/blob/scalac-plugin/scalacPlugin/src/main/scala/com/softwaremill/stringmask/components/StringMaskComponent.scala
  private object Component extends PluginComponent with Transform {

    val global: Fusemate.this.global.type = Fusemate.this.global // Why is this needed?
    val runsAfter = List[String]("parse")
    val phaseName = Fusemate.this.name

    // When runs after typer phase, might have problems with accessing ValDefs' annotations.
    override val runsRightAfter: Option[String] = Some("parser")

    protected def newTransformer(unit: global.CompilationUnit): global.Transformer = RuleTransformer

    object RuleTransformer extends Transformer {

      override def transform(tree: global.Tree): global.Tree = {

        val TRUELitTree = q"""Lit(true, TRUE)"""


        /** Normalizes a rule given by its head lits and body lits comprised of untimed IsA and and HasA
          * so that only basic IsA and HasA queries over concept names remain in the body. 
          * @param headLitsIn a disjunctive list of head literals to start with
          * @param bodyLitsIn a conjunctive list of body literals to normalize
          * @param defaultBodyLit an untimed IsA or HasA literal as default body, all given body literals be eliminated; can be `Now`
          * @result a rule representing the given one
          */
        def normalizeTBoxRule(headLitsIn: List[Tree], bodyLitsIn: List[Tree], defaultBodyLit: Tree) = {

          def headTimed(head: Tree): Tree = {
            def inner(t: Tree): Tree = {
              t match {
                case q"IsA($x, $c)" => q"DLIsA($x, $c, __time__)"
                case q"HasA($x, $r, $y)" => q"DLHasA($x, $r, $y, __time__)"
                case q"$l.OR($r)" => q"${inner(l)}.OR(${inner(r)})"
                case q"$l.AND($r)" => q"${inner(l)}.AND(${inner(r)})"
                case q"NEG($arg)" => q"NEG(${inner(arg)})"
                case q"And(..$args)" => q"And(..${args map { inner(_) }})"
                case q"Or(..$args)" => q"Or(..${args map { inner(_) }})"
                case q"Lit($sign,$arg)" => q"Lit($sign,${inner(arg)})"
                case other => other
              }
            }
            inner(head)
          }

          def bodyTimed(bodyList: List[Tree]) =
            bodyList map {
              case q"IsA($x, $c)" => q"DLIsA($x, $c, __time__)"
              case q"HasA($x, $r, $y)" => q"DLHasA($x, $r, $y, __time__)"
              case q"Now" => q"Now(__time__)"
              case other => other
            }

          var varCtr = 0
          def newVar() = { varCtr += 1; Ident(TermName(s"__x${varCtr}__")) }

          var headLits = headLitsIn match {
            case List(q"FAIL") => List.empty
            case other => other
          }
          var bodyLits = List.empty[Tree]
          var rest = bodyLitsIn
          while (rest.nonEmpty) {
            val next = rest.head
            rest = rest.tail
            next match {
              case l @ q"HasA($_, $_, $_)" => bodyLits ::= l
              case q"IsA($x, Neg(Neg($c)))" => rest ::= q"IsA($x, $c)"
              case q"IsA($x, Neg(Exists($r, $c)))" => rest ::= q"IsA($x, Forall($r, Neg($c)))"
              case q"IsA($x, Neg(Forall($r, $c)))" => rest ::= q"IsA($x, Exists($r, Neg($c)))"
              case q"IsA($x, Neg(OrConcept($c1, $c2)))" => rest ::= q"IsA($x, AndConcept(Neg($c1), Neg($c2)))"
              case q"IsA($x, Neg(AndConcept($c1, $c2)))" => rest ::= q"IsA($x, OrConcept(Neg($c1), Neg($c2)))"
              case q"IsA($x, Neg($c))" => headLits ::= q"IsA($x, $c)"
              case q"IsA($x, AndConcept($c1, $c2))" => rest :::= List(q"IsA($x, $c1)", q"IsA($x, $c2)")
              case q"IsA($x, OrConcept($c1, $c2))" => headLits ::= q"IsA($x, Neg(OrConcept($c1, $c2)))" // todo: Could be improved by splitting into multiple rules
              case q"IsA($x, Exists($r, $c))" => val v = newVar(); rest :::= List(q"HasA($x, $r, $v)", q"IsA($v, $c)")
              case q"IsA($x, Forall($r, $c))" => headLits ::= q"IsA($x, Exists($r, Neg($c)))"
              case l @ q"IsA($_, $_)" => bodyLits ::= l
            }
          }
          val finalHead = if (headLits.isEmpty) q"FAIL" else headTimed(q"And(Or(..$headLits))")
          if (bodyLits.isEmpty) bodyLits = List(defaultBodyLit) // Make sure theVar is not free in head
          val finalBodyLits = bodyTimed(bodyLits)
          q"$finalHead :- (..${finalBodyLits.reverse})"
        }


        /** Converts a cgi (concept :- concept1, ..., conceptn) into a rule. The head concept can be 'FAIL'.
          * Does, in parts, NNF conversion.
          * @param cgi the CGI
          * @returns an equivalent rule
          */
        def cgiTreeToRule(cgi: Tree) = {
          val q"$headConcept :- (..$bodyConcepts)" = cgi
          val theVar = Ident(TermName("__theInstance__"))
          normalizeTBoxRule(
            headConcept match {
              case q"FAIL" => List.empty
              case c => List(q"IsA($theVar, $c)")
            },
            bodyConcepts map { c => q"IsA($theVar, $c)" },
            q"IsA($theVar, __aConcept__)"
          )
        }

        /** Compiles the given tree `rule` into a `Rule`
          *  If asTBox is true then IsA and HasA literals receive an extra last parameter 'time' and are prefixed witg "DL"
          */
        def ruleTreeToRule(freeVars: Set[String], rule: Tree): (Tree, Set[String]) = {

          abstract class BECRSubcase
          object BECRSubcase {
            case class TimeBound(variable: Ident, op: String, bound: Tree)
            case class Pivot(predName: String) extends BECRSubcase // Used for explicit @pivots annotations
            // case class PosBodyPred(predName: String) extends BECRSubcase // Used for explicit @preds annotations
            case class Literal(timeBound: Option[TimeBound]) extends BECRSubcase
            case class COLLECT(compExp: Tree) extends BECRSubcase // Comprehension: compExp is a PartialFunction[[List[Any], CurriedRule]
            case class CHOOSE(code: Tree, typ: Tree) extends BECRSubcase // Comprehension: code is a PartialFunction[[Any, CurriedRule]
            case class LET(code: Tree, typ: Tree) extends BECRSubcase // Let binder: code to be evaluated
            case class MATCH(code: Tree) extends BECRSubcase
          }

          case class BodyElemCompileResult(pattern: Tree, cond: Tree, subcase: BECRSubcase) {
            // todo: is pattern a literal?
            def predName =
              subcase match {
                case BECRSubcase.Pivot(predName) => predName
                // case BECRSubcase.PosBodyPred(predName) => predName
                case _ => pattern match {
                  // case q"TRUELit" => "TRUE" // subsumed by following case:
                  case q"Lit($_, $pred(..$args))" => pred.toString
                  case p => // don't know ase, really
                    "TRUE" // The COLLECT/CHOOSE case, in which the pattern will be a variable type List[Any]
                }
              }
          }

          // Useful special cases
          def TRUEBodyElemCompileResultWithCond(cond: Tree) = BodyElemCompileResult(TRUELitTree, cond, BECRSubcase.Literal(None))
          val TRUEBodyElemCompileResult = TRUEBodyElemCompileResultWithCond(q"true")


          def annotationArgsStrings(annots: List[Tree]) = annots map {
              case Literal(Constant(name: String)) => name
              case other => globalError(s"annotation: not a string: $other"); "<badName>"
            }


          /** The proper preciate names in the body, i.e. all but "TRUE"  */
          def becrsPreds(becrs: Iterable[BodyElemCompileResult]) = becrs map { _.predName } filterNot { _ == "TRUE" } toSet;

          def andTrees(conds: List[Tree]) = conds.foldLeft(q"true": Tree)((l, r) => q"$l && $r")

          def toCurried(posBody: List[BodyElemCompileResult], head: Tree) = {

            // Copy a tree for no apparent reason. Binders play up - don't know why, but this fixes it
            def copy(t: Tree): Tree = t match {
              case Match(a, bs) => Match(copy(a), bs map { copyCaseDef(_) })
                // This is the important case
              case Bind(TermName(x), t) => Bind(TermName(x), copy(t))
              //case Ident(TermName(x)) => Ident(TermName(x))
              case Apply(fun, args) => Apply(fun, args map { copy })
              case i @ Ident(_) => i
              case c @ Literal(_) => c
              case other => println(s"[info] toCurried.copy: catchall case applied to ${showRaw(other)}"); other
            }
            def copyCaseDef(cd: CaseDef): CaseDef = cd match {
              case CaseDef(a, b, c) => CaseDef(copy(a), copy(b), copy(c))
            }

            def simplify(posBody: List[BodyElemCompileResult]) = {
              assume(posBody.nonEmpty) // xxx
              val res = collection.mutable.ListBuffer.empty[BodyElemCompileResult]
              var last = posBody.head
              for (next <- posBody.tail) {
                (last, next) match {
                  // todo: comprehension case?
                  case (BodyElemCompileResult(lastPattern, lastCond, BECRSubcase.Literal(None)),
                    BodyElemCompileResult(TRUELitTree, cond, BECRSubcase.Literal(None))) =>
                    // Absorb cond into lastCond
                    last = BodyElemCompileResult(lastPattern, andTrees(List(lastCond, cond)), BECRSubcase.Literal(None))
                  case (_, _) =>
                    res += last
                    last = next
                }
              }
              res += last
              res.toList
            }

            def toCurriedInner(posBody: List[BodyElemCompileResult]): Tree = {
              assume(posBody.nonEmpty) // xxx
              val BodyElemCompileResult(pattern, cond, subCase) :: restBody = posBody
              val restRes = if (restBody.isEmpty) head else toCurriedInner(restBody)
              val pcrSubcase = subCase match {
                case BECRSubcase.Literal(timeBound) =>
                  val pcrTimeBound = timeBound match {
                    case None => q"None"
                    case Some(BECRSubcase.TimeBound(bv, op, bound)) => q"Some(PCRSubcase.TimeBound({ case ${copy(pattern)} => $bv }, $op, $bound))"
                  }
                  q"PCRSubcase.Literal($pcrTimeBound, { case $pattern if $cond => $restRes })"
                case BECRSubcase.COLLECT(compExp) => q"PCRSubcase.COLLECT($compExp, { case $pattern if $cond => $restRes })"
                case BECRSubcase.CHOOSE(code, typ) => q"PCRSubcase.CHOOSE[$typ](() => $code, { case $pattern if $cond => $restRes })"
                case BECRSubcase.LET(code, typ) => q"PCRSubcase.LET[$typ](() => $code, { case $pattern if $cond => $restRes })"
                case BECRSubcase.Pivot(predName) => q"PCRSubcase.Pivot(currentI.latestTime, $predName, { case $pattern if $cond => $restRes })"
                  // case BECRSubcase.PosBodyPred(predName) => q"PCRSubcase.PosBodyPred($predName, { case $pattern if $cond => $restRes })"
                case BECRSubcase.MATCH(code) => q"PCRSubcase.MATCH(() => $code, { case $pattern if $cond => $restRes })"
              }
              val predNames: List[String] = (posBody map { _.predName })
              q"ProperCurriedRule($predNames, $pcrSubcase)"
            }

            // todo: in case of an BodyElemCompileResult with pattern == q"TRUE" and filter == OCRNone make cond part of preceeding BodyElemCompileResult's cond
            // Do this by going over tails of posBody as a preprocessing before calling toCurriedInner
            // simpBody foreach { case BodyElemCompileResult(pattern, filter, cond) => println(BodyElemCompileResult(pattern, filter, cond)) }
            if (posBody.isEmpty)
              (q"""ProperCurriedRule(List("TRUE"), PCRSubcase.Literal(None, { case Lit(true, "TRUE") => $head }) )""", true) // todo: Can use TRUELitTree instead of Lit(true, "TRUE") ?
            else {
              val simpBody = simplify(posBody)
              val isFactRule = simpBody.tail.isEmpty && (simpBody.head.predName == "TRUE") // only one body lit and it must be "TRUE"
              val res = toCurriedInner(simpBody)
              (res, isFactRule)
            }
          }

          val negBodyPreds = collection.mutable.Set.empty[String] // Predicate symbols in negative body literals
          val posBodyPreds = collection.mutable.Set.empty[String] // Predicate symbols in positive body literals
          val implicitBodyPreds = collection.mutable.Set.empty[String] // Lits with these predicate symbols that are implicitly evaluated, e.g. within DLENTAILS

          /* process a rule body, given as a list of body literals as trees so that it can be used in the case-body of a partial function.
           * @param ts is parse tree for the rule body
           * @param used is a set of variable names that have been used as a binder already or are from given set of free variables
           * @return a list of BodyElemCompileResults
           */
          def procPosBody(ts: List[Tree], used: Set[String]): List[BodyElemCompileResult] = {

            var localConds = List.empty[Tree] // The condition attached to a case; 

            var timeBound: Option[BECRSubcase.TimeBound] = None
            // var wheres = List.empty[Tree] // The where blocks, all in one. A where block WHERE { val a = b; val b = c } becomes a list containings (trees of) "val a = b" and "val b = c"
            var usedGlobal = used // The variable names that have been used so far and that are bound at the point they are referrenced
            var usedLocal = Set.empty[String] // The variable names that have been used so far and that are not bound at the point they are referrenced

            var uniqueCnt = -1
            def fresh(base: String) = {
              uniqueCnt += 1
              base + "___" + uniqueCnt.toString()
            }

            val LocalBinderOps = Set("$less", "$less$eq", "$greater", "$greater$eq")

            def isConstructor(t: Tree) = t match {
              case Ident(TermName(n)) if n(0).isUpper => true
              case _ => false
            }

            def constructorName(t: Tree) = t match { case Ident(TermName(n)) => n }

            /** Return true if the given tree represents a literal via matching P(..) or NEG(P(..)) */
            def isImplicitLiteral(t: Tree) = t match {
              case q"Lit($_, $_)" => false
              case q"NEG($_)" => true
              case q"POS($_)" => true
              case q"$pred(..$_)" if isConstructor(pred) => true
              case _ => false
            }

            /** Convert an implicit literal P(..) or NEG(P(..)) to an explicit one */
            def toExplicitLiteral(t: Tree) = {
              t match {
                // case lit @ q"Lit($_, $_)" => lit
                case q"NEG($atom)" => q"Lit(false, $atom)"
                case q"POS($atom)" => q"Lit(true, $atom)"
                case atom @ q"$pred(..$_)" if isConstructor(pred) => q"Lit(true, $atom)"
              }
            }

            def isExplicitLiteral(t: Tree) = t match {
              case q"Lit($_, $_)" => true
              case _ => false
            }

            def linearizeOuter(t: Tree): BodyElemCompileResult = {
              t match {
                case Function(_, a @ Apply(_, _)) => linearizeOuter(a)
                case q"pivot(${predName:String})" => // predName is Ident(TermName(.))
                  // val bindVar = fresh("x")
                  // BodyElemCompileResult(Bind(TermName(bindVar), Typed(Ident("Lit"), typ)), q"true", BECRSubcase.Pivot(predName))
                  BodyElemCompileResult(TRUELitTree, q"true", BECRSubcase.Pivot(predName))

                // case q"posBodyPred(${predName:String})" => // predName is Ident(TermName(.))
                //   BodyElemCompileResult(TRUELitTree, q"true", BECRSubcase.PosBodyPred(predName))

                // case of implicit body preds
                case Annotated(Apply(Select(New(Ident(TypeName("preds"))), termNames.CONSTRUCTOR), preds), tree) =>
                  implicitBodyPreds ++= annotationArgsStrings(preds)
                  linearizeOuter(tree)

                case q"($abox,$tbox).|=(..$query)" => linearizeOuter(q"DLENTAILS($abox,$tbox,List(..$query))")
                case q"$tbox.|=(..$query)" => linearizeOuter(q"DLENTAILS(currentI.aboxAt(time),$tbox,List(..$query))")

                // tbox is a list of rules representing a TBox
                case q"DLENTAILS($abox,$tbox,List(..$query))" => // query is a list of Lits
                  // val (pos, neg) = splitPosNeg(query)
                  // val head = if (neg.isEmpty) q"FAIL" else q"And(Or(..$neg))"
                  // val (r, _bodyPreds) = ruleTreeToRule(usedGlobal ++ usedLocal, q"$head :- (..$pos)", asTBox = true) // r is the query turned into a FAIL rule
                  val queryRule = normalizeTBoxRule(List.empty, query, q"Now")
                  val (r, _bodyPreds) = ruleTreeToRule(usedGlobal ++ usedLocal, queryRule) // r is the query turned into a FAIL rule
                  // println(s"yyy = " + showCode(r))
                  // todo: should we really do the filtering here? Or outside, so that we can cache the interpretation/tbox/result ?
                  // val c = q"""! dl.CoreIE.isSat($intp collect { case POS(a: dl.CoreIE.Assertable) if a.time == $time => a }, { import dl.CoreIE.ruleFramework._; import dl.CoreIE.ruleFramework.signature._; import dl.CoreIE._; List($r) ++ $tbox })"""
                  val c = q"""! fm6.extensions.dl.DLIE.isSat($abox, { import fm6.extensions.dl.DLIE.ruleFramework._; import fm6.extensions.dl.DLIE.ruleFramework.signature._; import fm6.extensions.dl.DLIE._; $r :: ${tbox}.toList })"""
                  implicitBodyPreds ++= Seq("IsAAt", "HasAAt")
                  TRUEBodyElemCompileResultWithCond(c)

                case q"DLISSAT($abox,$tbox)" =>
                  val c = q"""fm6.extensions.dl.DLIE.isSat($abox, { import fm6.extensions.dl.DLIE.ruleFramework._; import fm6.extensions.dl.DLIE.ruleFramework.signature._; import fm6.extensions.dl.DLIE._; ${tbox}.toList })"""
                  implicitBodyPreds ++= Seq("IsAAt", "HasAAt")
                  TRUEBodyElemCompileResultWithCond(c)

                case q"DLISSAT($tbox)" => linearizeOuter(q"DLISSAT(currentI.aboxAt(time),$tbox)")

                case q"DLISUNSAT($abox,$tbox)" =>
                  val c = q"""! fm6.extensions.dl.DLIE.isSat($abox, { import fm6.extensions.dl.DLIE.ruleFramework._; import fm6.extensions.dl.DLIE.ruleFramework.signature._; import fm6.extensions.dl.DLIE._; ${tbox}.toList })"""
                  implicitBodyPreds ++= Seq("IsAAt", "HasAAt")
                  TRUEBodyElemCompileResultWithCond(c)

                case q"DLISUNSAT($tbox)" => linearizeOuter(q"DLISUNSAT(currentI.aboxAt(time),$tbox)")

                  // Short form: implicit interpretation
                /// case q"DLENTAILS($tbox,List(..$query))" => linearizeOuter(q"DLENTAILS(time,currentI,$tbox,List(..$query))")

                /*
                case q"($intp,$time,$tbox).|=(..$query)" => linearizeOuter(q"DLENTAILS($intp,$time,$tbox,List(..$query))")
                case q"($time,$tbox).|=(..$query)" => linearizeOuter(q"DLENTAILS(currentI,$time,$tbox,List(..$query))")
                case q"$tbox.|=(..$query)" => linearizeOuter(q"DLENTAILS(currentI,time,$tbox,List(..$query))")

                // tboxRules is a list of rules representing a TBox
                case q"DLENTAILS($intp,$time,$tbox,List(..$query))" => // query is a list of Lits
                  val r = ruleTreeToRule(usedGlobal ++ usedLocal, q"FAIL :- ..$query", asTBox = true) // r is the query turned into a FAIL rule
                  // todo: should we really do the filtering here? Or outside, so that we can cache the interpretation/tbox/result ?
                  // val c = q"""! dl.CoreIE.isSat($intp collect { case POS(a: dl.CoreIE.Assertable) if a.time == $time => a }, { import dl.CoreIE.ruleFramework._; import dl.CoreIE.ruleFramework.signature._; import dl.CoreIE._; List($r) ++ $tbox })"""
                  val c = q"""! isDLSat($intp, $time, { import dl.CoreIE.ruleFramework._; import dl.CoreIE.ruleFramework.signature._; import dl.CoreIE._; List($r) ++ $tbox })"""
                  implicitBodyPreds ++= Seq("IsAAt", "HasAAt") // todo: Almost bug: hard-coded predicate names
                  TRUEBodyElemCompileResultWithCond(c)

                // Short form: implicit interpretation
                case q"DLENTAILS($tbox,List(..$query))" => linearizeOuter(q"DLENTAILS(time,currentI,$tbox,List(..$query))")
 */
                // MATCH(P(_), t) is given as MATCH(x => P(x), t), i.e. anonymous variables are abstracted out as a function, we don't want that in this context:
                case q"MATCH(..$_ => $matchTo, $matchFrom)" =>
                  linearizeOuter(q"MATCH($matchTo, $matchFrom)")

                case q"MATCH($lit, $code)" if isImplicitLiteral(lit) =>
                  linearizeOuter(q"MATCH(${toExplicitLiteral(lit)}, $code)")

                case q"MATCH($lit, $code)" if isExplicitLiteral(lit) =>
                  // e.g. MATCH(C(x, 5), y)
                  localConds = List.empty
                  timeBound = None
                  val q"Lit($sign, $pred(..$args))" = lit
                  val pattern = q"Lit($sign, $pred(..${linearizeArgs(args)}))"
                  // linearizeArgs computes localConds and ocrFilter as a side effect
                  if (timeBound.nonEmpty) globalError(s"MATCH: filter not allowed in pattern")
                  // Some(BodyElemCompileResult(pattern, ocrFilter, andTrees(localConds), OCRMatch(code, Ident(TypeName(n)))))
                  BodyElemCompileResult(pattern, andTrees(localConds), BECRSubcase.MATCH(code))

                case q"LET($variable, $code)" =>
                  // The bindvar can be typed, e.g. LET(x: Int, ...)
                  val (bindVar, typ) = variable match {
                    case Typed(Ident(TermName(v)), t) => (v, t) // Typed(Ident(TermName("t1")), Ident(TypeName("Int")))
                    case Ident(TermName(v)) => (v, Ident(TypeName("Any")))
                  }
                  if ((usedLocal contains bindVar) || (usedGlobal contains bindVar)) {
                    globalError(s"rule annotation: the binder variable $bindVar must be unused")
                    TRUEBodyElemCompileResult
                  } else {
                    usedLocal += bindVar
                    BodyElemCompileResult(Bind(TermName(bindVar), Typed(Ident(termNames.WILDCARD), typ)), q"true", BECRSubcase.LET(code, typ))
                  }

                // Todo: rewrite all cases with quasiquotes
                case q"COLLECT($variable, $head.STH(..$body))" =>
                  val (bindVar, typ) = variable match {
                    case Typed(Ident(TermName(v)), t) => (v, t) // Typed(Ident(TermName("t1")), AppliedTypeTree(Ident(TypeName("List")), List(AppliedTypeTree(Select(Ident(scala), TypeName("Tuple2")), List(Ident(TypeName("Int")), Ident(TypeName("Int"))))))
                    case Ident(TermName(v)) =>
                      // Maybe can find type from head of comprehension, if it is a class constructor.
                      // Normalize head as an explicit literal
                      if (isImplicitLiteral(head) || isExplicitLiteral(head))
                        (v, tq"List[Lit]")
                      else
                        (v, tq"List[Any]")
                      // todo: this is not right:
/*
                      (if (isImplicitLiteral(head)) toExplicitLiteral(head) else head) match {
                      // todo: this is not right:
                        case q"Lit($_, $pred(..$_))" if isConstructor(pred) => (v, tq"List[${Ident(TypeName(constructorName(pred)))}]")
                        case _ => (v, tq"List[Any]")
                      }
 */
                  }
                  // println(showRaw(typ))
                  if ((usedLocal contains bindVar) || (usedGlobal contains bindVar)) {
                    globalError(s"rule annotation: the binder variable $bindVar must be unused")
                    TRUEBodyElemCompileResult
                  } else {
                    // Translate the comprehension into a Rule
                    // val (expr, typ) = head match {
                    //   case Typed(e, t) => (e, t) // Typed(Ident(TermName("t1")), Ident(TypeName("Int")))
                    //   case e => (e, Ident(TypeName("Any")))
                    // }
                    val (rule, bodyPreds) = ruleTreeToRule(usedGlobal ++ usedLocal, q"COLLECTResult($head).:-(..$body)")
                    // println(s"[COLLECT] comprehension = ${showCode(comprehension)}\nvariable = ${showCode(variable)}\nrule = $rule\nrule = $rule")
                    usedLocal += bindVar
                    // The result pf is something like { case x => ... } where ... is the next body literal (if and) or head, and x will be bound to the list of the exhaustive evaluation result of rule
                    implicitBodyPreds ++= bodyPreds
                    BodyElemCompileResult(Bind(TermName(bindVar), Typed(Ident(termNames.WILDCARD), q"$typ")), q"true", BECRSubcase.COLLECT(rule))
                  }

                // shortcut
                case q"COLLECT($variable, $lit)" if isImplicitLiteral(lit) =>
                  linearizeOuter(q"COLLECT($variable, ${toExplicitLiteral(lit)})")

                case q"COLLECT($variable, $lit)" if isExplicitLiteral(lit) =>
                  linearizeOuter(q"COLLECT($variable, $lit.STH($lit))")

                case q"CHOOSE($binder, $code)" =>
                  val (bindVar, typ) = binder match {
                    case constr @ Apply(Ident(TermName(c)), _) if c(0).isUpper =>
                      globalError(s"rule annotation: CHOOSE: binding to pattern not yet implemented")
                      ("_do_not_use_", Ident(TypeName("Any")))
                      case Typed(Ident(TermName(v)), t) => (v, t) // Typed(Ident(TermName("t1")), Ident(TypeName("Int")))
                        // Typed(Ident(TermName("t1")), AppliedTypeTree(Ident(TypeName("List")), List(AppliedTypeTree(Select(Ident(scala), TypeName("Tuple2")), List(Ident(TypeName("Int")), Ident(TypeName("Int"))))))
                    case Ident(TermName(v)) => (v, Ident(TypeName("Any")))
                  }
                  if ((usedLocal contains bindVar) || (usedGlobal contains bindVar)) {
                    globalError(s"rule annotation: the binder variable $bindVar must be unused")
                    TRUEBodyElemCompileResult
                  } else {
                    usedLocal += bindVar
                    BodyElemCompileResult(Bind(TermName(bindVar), Typed(Ident(termNames.WILDCARD), typ)), q"true", BECRSubcase.CHOOSE(code, typ))
                  }

                case q"NOT(..$lits)" =>
                  val body = procPosBody(lits, usedGlobal ++ usedLocal) // usedUnbound is empty?
                  // println(s"[NOT] lits = ${showRaw(lits)}\nbody = ${showRaw(body)}\ncond = ${showRaw(cond)}\nwhere = ${showRaw(where)}")
                  val preds = becrsPreds(body)
                  negBodyPreds ++= preds
                  val (curried, _) = toCurried(body, q"ABORT")
                  // val t = BodyElemCompileResult(q"TRUE", OCRNone, q"""$curried.failsOn(currentI, $preds)""")
                  // println(s"[NOT] ocr = ${showRaw(t)}")
                  TRUEBodyElemCompileResultWithCond(q"$curried.failsOn(currentI, $preds)")

                case Ident(TermName("TRUE")) | Literal(Constant(true)) => TRUEBodyElemCompileResult // ignore
                case f @ Literal(Constant(false)) =>
                  localConds = f :: localConds
                  TRUEBodyElemCompileResult

                // STH condition
                  // todo: allow anonymous variables in lits
                // case q"$lit.STH(..$_ => $lits)" => linearizeOuter(q"$lit STH $lits")
                case q"$lit.STH(..$lits)" =>
                  val BodyElemCompileResult(p, c, l @ BECRSubcase.Literal(_)) = linearizeOuter(lit)
                  val body = procPosBody(lits, usedGlobal ++ usedLocal) // usedUnbound is empty?
                  // body foreach { x => println("xxx" + body) }
                  // "==" does not work here, hence use pattern matching
                  // if (body forall { ocr => ocr.pattern == q"TRUE" && ocr.filter == OCRNone })
                  if (body forall { case BodyElemCompileResult(TRUELitTree, _, BECRSubcase.Literal(None)) => true; case _ => false }) {
                    // optimisation: collect all conds an attach to lit result
                    val sthAsTree = andTrees(body map { _.cond })
                    BodyElemCompileResult(p, q"$c && $sthAsTree", l)
                  } else {
                    // At lest one non-builtin
                    val preds = becrsPreds(body)
                    posBodyPreds ++= preds
                    val (curried, _) = toCurried(body, q"SUCCESS")
                    val litsAsCond = q"""$curried.succeedsOn(currentI, $preds)"""
                    BodyElemCompileResult(p, q"$c && $litsAsCond", l)
                  }

                // Predefined arithmetic operators
                case cond @ Apply(Select(_, TermName(n)), _) if n(0) == '$' =>
                  TRUEBodyElemCompileResultWithCond(cond)

                // Matching against a literal
                // First, elminate functions introduced by anonynous variables
                // As e.g., P(_) becomes
                // x3 => P(x3)
                // case Function(_, a @ Apply(_, _)) => linearizeOuter(a)
                case q"(..$vars => $lit)" => linearizeOuter(lit)

                // Negative literal
                // NEG(f(_)) is given as NEG(x => f(x)), i.e. anonymous variables are abstracted out as a function, we don't want that in this context:
                case q"NEG(..$vars => $atom)" =>
                  linearizeOuter(q"NEG($atom)")

                case q"POS(..$vars => $atom)" =>
                  linearizeOuter(q"$atom")

                case q"IF($cond)" =>
                  // println("xxx " + showRaw(cond))
                  TRUEBodyElemCompileResultWithCond(cond)

                // case Apply(Ident(TermName("NEG")), List(Function(_, predApp))) =>
                //   linearizeOuter(Apply(Ident(TermName("NEG")), List(predApp)))

                  // Not sure if this case will ever come up
                // case Apply(Ident(TermName("Lit")), List(sign, Function(_, predApp))) =>
                //   linearizeOuter(Apply(Ident(TermName("Lit")), List(sign, predApp)))
                case q"Lit($sign, (..$vars => $atom))" =>
                  linearizeOuter(q"Lit($sign, $atom)")

                case lit if isImplicitLiteral(lit) => linearizeOuter(toExplicitLiteral(lit))

                  // Explicit literal
                case q"Lit($sign, $pred(..$args))" if isConstructor(pred) =>
                  timeBound = None
                  localConds = List.empty
                  val pattern = q"Lit($sign, $pred(..${linearizeArgs(args)}))"
                  // linearizeArgs computes localConds and timeBound as a side effect
                  BodyElemCompileResult(pattern, andTrees(localConds), BECRSubcase.Literal(timeBound))

                  /*
                case Apply(Ident(TermName("NEG")), List(Apply(fun @ Ident(TermName(n)), args))) if n(0).isUpper =>
                  timeBound = None
                  localConds = List.empty
                  val pattern = q"NEG($fun(..${linearizeArgs(args)}))"
                  // linearizeArgs computes localConds and timeBound as a side effect
                  BodyElemCompileResult(pattern, andTrees(localConds), BECRSubcase.Literal(timeBound))


                // Positive literal
                case Apply(fun @ Ident(TermName(n)), args) if n(0).isUpper =>
                  timeBound = None
                  localConds = List.empty
                  // val pattern = Apply(fun, linearizeArgs(args))
                  val pattern = q"$fun(..${linearizeArgs(args)})"
                  // linearizeArgs computes localConds and timeBound as a side effect
                  BodyElemCompileResult(pattern, andTrees(localConds), BECRSubcase.Literal(timeBound))
                   */

                // Scala call
                case cond @ Apply(fun, args) =>
                  TRUEBodyElemCompileResultWithCond(cond)
                  // Scala call
                case cond @ Select(_, _) =>
                  TRUEBodyElemCompileResultWithCond(cond)

                case other =>
                  println(s"[Warn] @rule annotation: linearize: cannot handle ${showCode(other)} in outer position. Ignored")
                  BodyElemCompileResult(other, q"true", BECRSubcase.Literal(None))
              }
            }

            def linearizeInner(t: Tree): Tree =
              t match {
                // not isOuter
                case Function(_, a @ Apply(_, _)) => linearizeInner(a)
                case l @ Literal(_) => l
                case i @ Ident(TermName(v)) if v(0).isUpper => i // Constants like BOT

                // A binder bv < timeVar is treated separately, here just project on bv by itself and remember in ocrFilter variable
                case Apply(Select(Ident(bv @ TermName(bindVar)), TermName(op)), List(timeVar)) if LocalBinderOps contains op =>
                  if ((usedLocal contains bindVar) || (usedGlobal contains bindVar)) {
                    globalError(s"rule annotation: the binder variable $bindVar must be unused"); q"???"
                  } else {
                    if (timeBound.isEmpty)
                      timeBound = Some(BECRSubcase.TimeBound(Ident(bv), op, timeVar))
                    else {
                      val s = s"BECRSubcase.TimeBound($bindVar, $op, ${showCode(timeVar)})"
                      println(s"[Warn] @rule annotation: linearizeInner: more than one time filters. Ignore $s")
                    } 
                    usedLocal += bindVar
                    Bind(bv, Ident(termNames.WILDCARD))
                  }

                case Annotated(Apply(Select(New(Ident(TypeName("gnd"))), termNames.CONSTRUCTOR), Nil), timeVar @ Ident(bv @ TermName(v))) =>
                  if ((usedGlobal contains v) || (usedLocal contains v)) {
                    // v has already been used, need to rename and remember the mapping as an equality constraint
                    // Foo(v) becomes Foo(v___1 @ _) with a condition v__1 == v
                    val newV = fresh(v)
                    localConds ::= q"${Ident(TermName(v))} == ${Ident(TermName(newV))}"
                    if (timeBound.isEmpty)
                      timeBound = Some(BECRSubcase.TimeBound(Ident(TermName(newV)), "$eq$eq", timeVar))
                    else {
                      val s = s"BECRSubcase.TimeBound(${Ident(TermName(newV))}, "==", ${showCode(timeVar)})"
                      println(s"[Warn] @rule annotation: linearizeInner: more than one time filter (stemming from @gnd annotation). Ignore $s")
                    } 
                        
                    Bind(TermName(newV), Ident(termNames.WILDCARD))
                  } else {
                    globalError(s"rule annotation: the annotation @gnd can only be used for bound variables, however $v is not bound")
                    q"???"
                  }

                case Apply(Select(Ident(TermName("scala")), TermName("Tuple2")), args) =>
                  Apply(Select(Ident(TermName("scala")), TermName("Tuple2")), linearizeArgs(args))
                case Apply(Select(Ident(TermName("scala")), TermName("Tuple3")), args) =>
                  Apply(Select(Ident(TermName("scala")), TermName("Tuple3")), linearizeArgs(args))
                case Apply(Select(Ident(TermName("scala")), TermName("Tuple4")), args) =>
                  Apply(Select(Ident(TermName("scala")), TermName("Tuple4")), linearizeArgs(args))
                case Apply(Select(Ident(TermName("scala")), TermName("Tuple5")), args) =>
                  Apply(Select(Ident(TermName("scala")), TermName("Tuple5")), linearizeArgs(args))
                case Apply(Select(Ident(TermName("scala")), TermName("Tuple6")), args) =>
                  Apply(Select(Ident(TermName("scala")), TermName("Tuple6")), linearizeArgs(args))
                case Apply(fun @ Ident(TermName(n)), args) if n(0).isUpper => // Works for case classes
                  Apply(fun, linearizeArgs(args))

                // Function application e.g. bar(x) in Foo(bar(x)), which becomes Foo(x__1 @ _) ... if x__1 == bar(x)
                case Apply(Ident(TermName(n)), args) if !n(0).isUpper =>
                  val newV = fresh("x")
                  localConds ::= q"${Apply(Ident(TermName(n)), args)} == ${Ident(TermName(newV))}"
                  Bind(TermName(newV), Ident(termNames.WILDCARD))

                //  Variable v in e.g. Foo(v)
                case Ident(TermName(v)) =>
                  if ((usedGlobal contains v) || (usedLocal contains v)) {
                    // v has already been used, need to rename and remember the mapping as an equality constraint
                    // Foo(v) becomes Foo(v___1 @ _) with a condition v__1 == v
                    val newV = fresh(v)
                    localConds ::= q"${Ident(TermName(v))} == ${Ident(TermName(newV))}"
                    Bind(TermName(newV), Ident(termNames.WILDCARD))
                  } else {
                    // Foo(v) becomes Foo(v @ _)
                    usedLocal += v // remember that the name v has occurred
                    Bind(TermName(v), Ident(termNames.WILDCARD))
                  }
                case s @ Select(_, _) => // any a.b expression
                  val newV = fresh("macroVar")
                  localConds ::= q"$s == ${Ident(TermName(newV))}"
                  Bind(TermName(newV), Ident(termNames.WILDCARD))
                case a @ Apply(_, _) => // Assume this is a Scala boolean expressn
                  val newV = fresh("macroVar")
                  localConds ::= a
                  Bind(TermName(newV), Ident(termNames.WILDCARD))
                case other =>
                  println(s"[Warn] @rule annotation: linearize: cannot handle $other in inner position. Ignored")
                  other
              }

            // Linearize the arguments of a Lit
            def linearizeArgs(ts: List[Tree]): List[Tree] = ts map { linearizeInner(_) }
            // Linearize a list of Lits, i.e. a positive body
            def linearizeList(ts: List[Tree]): List[BodyElemCompileResult] = {
              // Iterate over ts and collect non-None results, thereby maintain usedBound / usedUnbound variables
              var res = List.empty[BodyElemCompileResult]
              var open = ts
              while (open.nonEmpty) {
                val next = open.head
                open = open.tail
                next match {
                  case Annotated(Apply(Select(New(Ident(TypeName("pivots"))), termNames.CONSTRUCTOR), pivots), t) =>
                    open ::= t
                    // The pivots are treated as ordinary positive body literals
                    open :::= pivots
                  // case Annotated(Apply(Select(New(Ident(TypeName("pivots"))), termNames.CONSTRUCTOR), preds), t) =>
                  //   // push back the goal that was annotated 
                  //   open ::= t
                  //   // push the annotations as pivot(predName) for each pred in preds as pivot pseudo goals
                  //   open :::= annotationArgsStrings(preds) map { predName => q"pivot($predName)" }
/*                  case Annotated(Apply(Select(New(Ident(TypeName("preds"))), termNames.CONSTRUCTOR), preds), t) =>
                    // Analogously to previous
                    open ::= t
                    open :::= annotationArgsStrings(preds) map { predName => q"posBodyPred($predName)" }
 */
                  case t =>
                    usedLocal = Set.empty
                    res ::= linearizeOuter(t)
                    usedGlobal ++= usedLocal // new unbound variable are bound from now on
                }
              }
              res.reverse
            }

             def linearizeListNew(ts: List[Tree]): List[BodyElemCompileResult] = {
              // Iterate over ts and collect non-None results, thereby maintain usedBound / usedUnbound variables
              var res = List.empty[BodyElemCompileResult]
              for (t <- ts) {
                usedLocal = Set.empty
                res ::= linearizeOuter(t)
                usedGlobal ++= usedLocal // new unbound variable are bound from now on
              }
              res.reverse
            }

            linearizeList(ts)
          } // procPosBody

          // Break the rule proper apart into head and body
          // Get rid of a anonymous function by Eta reduction
          val ruleCore =
            rule match {
              case q"(..$_ => $r)" => r
              case _ => rule
          }
          val q"$ahead :- (..$body)" = ruleCore

          // Head can be annotated head : @preds("a", "b", "c") to indicate the head predicates to be used (for stratification) are actuall these explicitly given ones.
          // This is necessary occasionally if, e.g., head is computed by a scala expression and it is impossible to know the predicate names at compile time.
          // Hence the little help by the annotation
          val (head, givenHeadPredsOpt) = ahead match {
            case Annotated(Apply(Select(New(Ident(TypeName("preds"))), termNames.CONSTRUCTOR), preds), realHead) =>
              // println(s"headannot: $preds, ${showRaw(preds)}")
              (realHead, Some(annotationArgsStrings(preds).toSet))
            case realHead => (realHead, None)
          }

          /* returns the predicate symbols occuring in a head
           * @param	head the head of the rule, may use OR and AND as infic operators
           * @return a set of strings, the predicate symbols in the head
           */
          def headPreds(head: Tree): Set[String] = {
            var res = Set.empty[String]
            def inner(t: Tree): Unit = {
              t match {
                // case q"$g.:::($a)" =>
                //   println(g)
                //   println(a)
                //   res += "GFAIL"
                case q"$g.:|($a)" => res += "GFAIL"
                case q"FAIL" => res += "FAIL"
                case q"GFAIL($_,..$_)" => res += "GFAIL"
                case q"COLLECTResult($_)" => res += "COLLECTResult" // Doesn't mean much, actually. Don't need to care because program consists of one rule only
                case q"CHOOSEResult($_)" => res += "CHOOSEResult" // Doesn't mean much, actually. Don't need to care because program consists of one rule only
                case q"ABORT" => res += "ABORT"
                case q"$l.OR($r)" =>
                  inner(l); inner(r)
                case q"$l.AND($r)" =>
                  inner(l); inner(r)
                case q"NEG($arg)" => inner(arg)
                case q"And(..$args)" => args foreach { inner(_) }
                case q"Or(..$args)" => args foreach { inner(_) }
                case q"$pred(..$_)" =>
                  pred match {
                    case Ident(TermName(name)) if name(0).isUpper => res += name
                    case TypeApply(Ident(TermName(name)), _) => res += name
                    case x =>
                      globalError(s"@rule annotation: bad predicate in head element: ${showRaw(x)}")
                  }
                case x => globalError(s"@rule annotation: bad predicate in head element: $x")
              }
            }
            inner(head)
            res
          }

          val posBody = procPosBody(body, freeVars)
          posBodyPreds ++= becrsPreds(posBody)

          // Turn the negative body lits into Scala conditions

          // val finalCond = q"{ ..${posBodyWheres} }"
          // val finalHead = q"{ ..${posBodyWheres :+ head} }"
          // val (curried, isFactRule) = toCurried(posBody, finalCond, finalHead)
          // val finalHead = if (asTBox) headTimed(head) else head
          // val (curried, isFactRule) = toCurried(posBody, finalHead)
          val (curried, isFactRule) = toCurried(posBody, head)
          val f = q"(currentI : Interpretation) => {lazy val I = currentI.toSet; $curried}"
          val allPreds = (posBodyPreds ++ negBodyPreds).toSet
          // val realHeadPreds = givenHeadPredsOpt.getOrElse(headPreds(finalHead))
          val realHeadPreds = givenHeadPredsOpt.getOrElse(headPreds(head))
          val ruleRes = q"""Rule($f, $isFactRule, ${showCode(rule)}, $realHeadPreds, $allPreds, ${showCode(f)}, ${implicitBodyPreds.toSet})"""
          // println("@rule transformation of " + showCode(rule) + " is " + showCode(res))
          // println("@rule curried transformation of " + showCode(rule) + " is " + showCode(curried))
          (ruleRes, allPreds ++ implicitBodyPreds)
        }

        def argsSet(args: List[Tree]) = args map {
          case Ident(TermName(v)) => v
          case other => globalError(s"@rule annotation: argument is not an identifier: $other"); "???"
        } toSet;

        tree match {
          case q"$mods val $lhs = List(..$rhsEls)" =>
            // println(showRaw(tree))
            var freeVars = Set.empty[String]
            var success = false
            var asTBox = false // Whether to parse the rules as CGI's. 
            mods.annotations match {
              case List(q"new rules(..$fvs)") =>
                success = true
                freeVars = argsSet(fvs)
              case List(q"new rules") => success = true
              case List(q"new tbox(..$fvs)") =>
                success = true; asTBox = true
                freeVars = argsSet(fvs)
              case List(q"new tbox") => success = true; asTBox = true
              case _ => success = false
            }
            if (success) {
              val rhs = if (asTBox) {
                  val rules = rhsEls map { ruleTree => ruleTreeToRule(freeVars, cgiTreeToRule(ruleTree))._1 } // ignore bodyPreds result
                  q"import fm6.extensions.dl.DLIE.ruleFramework._; import fm6.extensions.dl.DLIE.ruleFramework.signature._; import fm6.extensions.dl.DLIE.{DLIsA, DLHasA}; $rules"
                } else {
                  val rules = rhsEls map { ruleTree => ruleTreeToRule(freeVars, ruleTree)._1 } // ignore bodyPreds result
                  q"$rules"
                }
              val res = q"val $lhs = $rhs"
              // println("=====================================")
              // println("Transform rule: " +  showCode(tree))
              // println("=====================================")
              // println("Transform input: " +  showRaw(tree))
              // println("=====================================")
              // println("result code: " + showCode(res))
              // println("=====================================")
              // println("result raw: " + showRaw(res))
              // println("=====================================")
              super.transform(res)
            } else
              super.transform(tree)
          case _ => super.transform(tree)
        }

      }
    }

  }

}
