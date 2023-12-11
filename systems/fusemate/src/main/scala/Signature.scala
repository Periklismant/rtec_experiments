package fm6

import fm6.util.Logging._
import fm6.Config._

import java.time.OffsetDateTime
import collection.immutable.Set
import collection.mutable.{ HashSet => MSet }
import collection.mutable.Queue
import collection.mutable.UnrolledBuffer


/** Signature represents the basic syntactic objects of the 
  * model computation calculus. These objects are atoms, literals, default negated literals, and
  * inference rules.
  * 
  * @param Time the type of the time. Useful concrete types are `Int` or `java.util.OffsetDateTime`.
  * @param TemporalAmount the type of temporal duration that can be added to Time instances time. 
  * @param BOT a value of type `Time` representing "beginning of time".
  * @param Epsilon a small temporal amount representing the time between successor time points
  * @param plus adds a temporal amount to a time.
  * @param TimeOrdering an `Ordering[Time]` used to process timed expressions from earlier to later ones.
  *        Useful types for `Time` often come with a readily defined such ordering
  */
class Signature[Time, TemporalAmount](val BOT: Time, val Epsilon: TemporalAmount, val plus: (Time, TemporalAmount) => Time)(implicit val TimeOrdering: Ordering[Time]) {

  /*
   *  Definitions related to Time
   */

  type Timed = HasTime[Time]

  implicit class MyTime(self: Time) {
    def <(other: Time) = TimeOrdering.compare(self, other) < 0
    def <=(other: Time) = TimeOrdering.compare(self, other) <= 0
    def ===(other: Time) = TimeOrdering.compare(self, other) == 0
    def >(other: Time) = TimeOrdering.compare(self, other) > 0
    def >=(other: Time) = TimeOrdering.compare(self, other) >= 0
  }

  implicit object LaterOrderingForTimed extends Ordering[Timed] {
    def compare(e1: Timed, e2: Timed) = TimeOrdering.compare(e1.time, e2.time)
  }

  /*
   *  Basic building blocks: atoms and literals 
   */

  abstract class Atom extends Timed {
    val predName = this.toString takeWhile { _ != '(' }
    def toLit = Lit(true, this)
  }

  case object TRUE extends Atom { val time = BOT }


  /** Lit is the type of logical literals, i.e. atoms or their (classical) negation.
    * sign: true means positive (of course)
    */

  case class Lit(sign: Boolean, atom: Atom) extends Timed {
    def compl = Lit(! sign, atom)
    def time = atom.time
    def predName = atom.predName
    // override def toString = if (sign) atom.toString else "¬" + atom.toString
    override def toString = if (sign) atom.toString else s"NEG(${atom.toString})" 
  }

  val TRUELit = Lit(true, TRUE)


  /** The canonical (pre-)`Ordering` on literals by time
    */ 
  implicit object LaterOrderingForLit extends Ordering[Lit] {
    def compare(l1: Lit, l2: Lit) = TimeOrdering.compare(l1.time, l2.time)
  }

  object NEG {
    def apply(a: Atom) = Lit(false, a)
    def unapply(l: Lit) = l match {
      case Lit(true, _) => None
      case Lit(false, a) => Some(a)
    }
  }

  object POS {
    def apply(a: Atom) = Lit(true, a)
    def unapply(l: Lit) = l match {
      case Lit(false, _) => None
      case Lit(true, a) => Some(a)
    }
  }

  implicit def atomToLit(a: Atom) = a.toLit

  // Pretty printer for collections of literals
  def ppLits(m: Iterable[Lit]): Unit = {
    println(m.toList.sorted.mkString("", "\n", "\n==="))
  }
  
  /* 
   * Description logic interface
   */

  import extensions.dl.Sig.{Individual, Concept, Role, Assertion, IsA, HasA}
  // import dl.DLIE

  case class IsAAt(time: Time, x: Individual, c: Concept) extends Atom 
  case class HasAAt(time: Time, x: Individual, r: Role, y: Individual) extends Atom

  implicit class MyLitIterable(lits: Iterable[Lit]) {
    // Collect all ABox elements from a collection of literals, for a given fixed time
    def aboxAt(time: Time): Set[Assertion] = lits collect {
      case POS(IsAAt(t, x, c)) if t == time || t == BOT => IsA(x, c)
      case POS(HasAAt(t, x, r, y)) if t == time || t == BOT => HasA(x, r, y)
    } toSet
  }
}

