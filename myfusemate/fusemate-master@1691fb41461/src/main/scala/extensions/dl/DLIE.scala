package fm6.extensions.dl

import fm6.util.Logging._
import fm6.Config

/*
 * Desciption logic inference engine
 * While the defs in Sig are independent of time, the defs here all depend on time
 * Time is hard-coded to Int and encodes iterations in the extension steps for exists-right 
 */

object DLIE extends fm6.InferenceEngine[Int, Int](0, 1, _ + _) {

  import ruleFramework._
  import ruleFramework.signature._

  import Sig._

  /**
    * This is the interface from Fusemate to DL. 
    * Fusemate atoms in the current interpretation that are also Assertable are collected to form the current ABox
    *  The prefix "DL" is used for IE internal reasoning, it's not meant to be the external interface
    */

  abstract class DLAssertion extends Atom
  // Concept instances
  case class DLIsA(x: Individual, c: Concept, time: Time) extends DLAssertion
  // Role instances
  case class DLHasA(x: Individual, r: Role, y: Individual, time: Time) extends DLAssertion

  // todo: implement this properly
  // case class Query(x: Individual, time: Time) extends Atom
  // case class Answer(xs: List[Individual], time: Time) extends Atom

  // Returns the set of assertions. Ignores time, in anticipation of alg improvment that des not need to copy assertions along time steps
  def assertionsOf(intp: Interpretation): collection.mutable.Set[Assertion] = {
    // println("Assertions:")
    // println(intp collect {
    //   case POS(DLIsA(x, c, _)) => IsA(x, c)
    //   case POS(DLHasA(x, r, y, _)) => HasA(x, r, y)
    // })
    intp collect {
      case POS(DLIsA(x, c, _)) => IsA(x, c)
      case POS(DLHasA(x, r, y, _)) => HasA(x, r, y)
    }
  }

  def toDLAssertions(abox: Iterable[Assertion]) =
    abox map {
      _  match {
        case IsA(x, c) => POS(DLIsA(x, c, BOT))
        case HasA(x, r, y) => POS(DLHasA(x, r, y, BOT))
      }
    }

  class DLModels(tbox: Iterable[Rule], abox: Iterable[Assertion]) extends Iterable[collection.mutable.Set[Assertion]] {

    // Models are computed only once
    lazy val models = new Models(tbox ++ ALCIF.rules, toDLAssertions(abox)) map { assertionsOf(_) }

    def materialized = {
      require(models.nonEmpty)
      val start: collection.mutable.Set[Assertion] = models.head collect {
          case a @ IsA(x, c: ConceptName) if x.isKnown => a
          case a @ HasA(x, r, y) if x.isKnown && y.isKnown => a
        }
      models.tail.foldLeft(start) { _ & _ }
    }

    def iterator = models.iterator
  }

  private case class KB(abox: Iterable[Assertion], tbox: Iterable[Rule])
  private val cached = collection.mutable.HashMap.empty[KB, Boolean]

  // todo: implement query answering

  private var nrCacheHits = 0

  def printStat(): Unit = {
    println("DLIE cache usage")
    println("----------------")
    println("# caches:     " + cached.size)
    println("# cache hits: " + nrCacheHits)
  }


  def isSat(abox: Iterable[Assertion], tbox: Iterable[Rule]) = {
    // Temporarily switch off showStratification
    val cShowStratification = fm6.Config.showStratification
    fm6.Config.showStratification = false
    val kb = KB(abox, tbox)
    val res =
      if (Config.DLCaching)
        cached.get(kb) match {
        case Some(res) => nrCacheHits += 1; res
        case None =>
          val res = new DLModels(tbox, abox).nonEmpty
          cached += (kb -> res)
          res
        }
        else new DLModels(tbox, abox).nonEmpty
    fm6.Config.showStratification = cShowStratification
    res
/*
 // Debug version
    println("==== isSat =====")
    println("==== ABox =====")
    abox foreach println
    println("==== TBox =====")
    tbox foreach { r => println(r); println(r.scalaCodeString) }
    val oldDebug = fm6.Config.debug
    fm6.Config.debug = false
    val res =
      fm6.Config.debug = oldDebug
    println(s"=== res = $res ===")
    res
 */
  }
}
