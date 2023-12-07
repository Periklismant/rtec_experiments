package fm6

import fm6.util.Logging._
import fm6.Config._

import java.time.OffsetDateTime
import collection.immutable.Set
import collection.mutable.Queue
import collection.mutable.UnrolledBuffer

/**
 * An interpretation is a set of literals, those with an explicitly given truth value as per the literal signs.
 * The subset for a given predicate name can be accessby the forPred method.
 * This is a form of indexing and may help speed up the computation cosiderably
 */

class Interpretation[Time, TemporalAmount, Lit <: Signature[Time,TemporalAmount]#Lit](implicit val signature: Signature[Time, TemporalAmount]) extends collection.mutable.Set[Lit] {

  import signature.{BOT, MyTime}

  def this(lits: Iterable[Lit])(implicit signature: Signature[Time, TemporalAmount]) = {
    this()
    lits foreach { addOne(_) }
  }

  val index = collection.mutable.AnyRefMap.empty[String, TimeIndexedSet[Time, TemporalAmount, Lit]] // For accessing the literals by predicate name
  var latestTime = BOT

  // Abstract set
  def clear(): Unit = {
    index.clear()
    latestTime = BOT
  }

  // def contains(l: Lit) = lits contains l
  def contains(l: Lit) = index.get(l.atom.predName) match {
    case None => false
    case Some(s) => s contains l
  }

  def addOne(l: Lit) = {
    index.get(l.atom.predName) match {
      case None =>
        // No index for this predicate yet
        index += (l.atom.predName -> TimeIndexedSet(l))
      case Some(lits) => lits += l
    }
    if (l.time > latestTime) latestTime = l.time
    this
  }

  def subtractOne(l: Lit) = {
    index.get(l.atom.predName) match {
      case None => () // Definitely not contained
      case Some(lits) =>
        lits -= l
        if (lits.isEmpty) index -= l.atom.predName
        // set latestTime
        if (l.time == latestTime) {
          // recompute latest, as latestTime might be earlier now
          latestTime = BOT
          for (t <- index.values map { _.latestTime }) if (t > latestTime) latestTime = t
        }
    }
    this
  }

  def iterator = index.valuesIterator.flatten

  def forPred(s: String) = index.getOrElse(s, TimeIndexedSet.empty)

  override def clone() = {
    val res = new Interpretation[Time, TemporalAmount, Lit](toIterable)
    res.latestTime = latestTime
    res
  }

  override def canEqual(a: Any) = a.isInstanceOf[this.type]

  override def equals(that: Any): Boolean =
    that match  {
      case that: this.type =>
        (this eq that) || (
          that.canEqual(this) &&
            latestTime == that.latestTime && // cheap test
            hashCode() == that.hashCode() && // cheap test
            index == that.index
        )
      case _ => false
    }

  // Optionally get the latest time
  // no - use latestTime instead
  /*
def now() = index.get("Now") match {
      case None => None
      case Some(lits) => lits collectFirst { case signature.POS(a) if a.predName == "Now" => a.time }
    }
   */

  override def hashCode = 31 * index.hashCode() + latestTime.hashCode()

  override def toString() = this.toList.sorted(signature.LaterOrderingForTimed).mkString("{", ", ", "}")

  def pp(): Unit = {
    signature.ppLits(this.toList.asInstanceOf[List[signature.Lit]])
  }
}

