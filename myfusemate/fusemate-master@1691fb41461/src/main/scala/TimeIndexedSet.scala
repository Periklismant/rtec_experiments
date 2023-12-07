package fm6

import fm6.util.Logging._
import fm6.Config._

import java.time.OffsetDateTime
import collection.immutable.Set
import collection.mutable.Queue
import collection.mutable.UnrolledBuffer
import scala.collection.View.Iterate
import java.time.temporal.Temporal

class TimeIndexedSet[Time, TemporalAmount, Value <: HasTime[Time]](implicit val signature: Signature[Time, TemporalAmount]) extends collection.mutable.Set[Value] {

  def this(values: Iterable[Value])(implicit signature: Signature[Time, TemporalAmount]) = {
    this()
    values foreach { addOne(_) }
  }

  import collection.mutable.{ HashSet => MSet }
  import signature._
  val index = collection.mutable.SortedMap.empty[Time, MSet[Value]] // For accessing the literals by predicate time

  // Direct line to values. Notice that t must be a defined key in index
  def valuesAt(t: Time) = index(t)
  def clearAt(t: Time): Unit = index -= t


  def timesIterator(window: Option[(TemporalAmount, Time)] = None) =
    window match {
      case None => index.keysIterator
      case Some((amount, now)) => index.keysIterator dropWhile { plus(_, amount) < now }
    }

  // All time points in this set increasing from a given time point
  def timesIncIterator(from: Time, inclusive: Boolean, window: Option[(TemporalAmount, Time)] = None): Iterator[Time] = {
    // ensureTimePoints()
    new Iterator[Time] {
      val times = timesIterator(window)
      var nextTime: Option[Time] = None // The next value to be returned in this iterator, if any
      // Initialize: find start valueent, by skipping all earlier times
      while (nextTime.isEmpty && times.hasNext) {
        val t = times.next()
        if ((!inclusive && t > from) || (inclusive && t >= from))
          // found the first valueent
          nextTime = Some(t)
      }
      def hasNext = nextTime.nonEmpty
      def next() = {
        val res = nextTime.get
        if (times.hasNext) nextTime = Some(times.next()) else nextTime = None
        res
      }
    }
  }

  // All time points in this set decreasing from a given time point
  def timesDecIterator(from: Time, inclusive: Boolean, window: Option[(TemporalAmount, Time)] = None): Iterator[Time] = {
    var res = List.empty[Time] // res collects all desired time points from beginning, in reverse order
    val times = timesIterator(window)
    var done = false
    while (!done && times.hasNext) {
      val t = times.next()
      if ((!inclusive && t >= from) || (inclusive && t > from))
        done = true
      else
        // collect t in result
        res ::= t
    }
    // res is in desired order already
    res.iterator
  }

  @inline def earliestTime = index.firstKey
  @inline def latestTime = index.lastKey
  @inline def isEmptyAt(t: Time) = !index.isDefinedAt(t)
  @inline def nonEmptyAt(t: Time) = index.isDefinedAt(t)

  def timesAtIterator(t: Time, window: Option[(TemporalAmount, Time)] = None) =
    if (isEmptyAt(t)) Iterator.empty
      else window match {
        case None => Iterator(t) // Singleton iterator
        case Some((amount, now)) => if (plus(t, amount) < now) Iterator.empty else Iterator(t)
      }

  @inline def timesFromIterator(t: Time, window: Option[(TemporalAmount, Time)] = None) = timesIncIterator(t, inclusive = true)
  @inline def timesAfterIterator(t: Time, window: Option[(TemporalAmount, Time)] = None) = timesIncIterator(t, inclusive = false)
  @inline def timesToIterator(t: Time, window: Option[(TemporalAmount, Time)] = None) = timesDecIterator(t, inclusive = true)
  @inline def timesUntilIterator(t: Time, window: Option[(TemporalAmount, Time)] = None) = timesDecIterator(t, inclusive = false)

  def valuesIterator(it: Iterator[Time]) = (for (t <- it) yield index(t)).flatten

  @inline def valuesAtIterator(t: Time) = valuesIterator(timesAtIterator(t))
  @inline def valuesFromIterator(t: Time) = valuesIterator(timesFromIterator(t))
  @inline def valuesAfterIterator(t: Time) = valuesIterator(timesAfterIterator(t))
  @inline def valuesToIterator(t: Time) = valuesIterator(timesToIterator(t))
  @inline def valuesUntilIterator(t: Time) = valuesIterator(timesUntilIterator(t))


  def latestTimeTo(t: Time) = timesToIterator(t).nextOption()
  def latestTimeUntil(t: Time) = timesUntilIterator(t).nextOption()
  def earliestTimeFrom(t: Time) = timesFromIterator(t).nextOption()
  def earliestTimeAfter(t: Time) = timesAfterIterator(t).nextOption()

  // Abstract set
  def clear(): Unit = {
    index.clear()
  }

  def contains(el: Value) = {
    index.get(el.time) match {
      case None => false
      case Some(s) => s contains el
    }
  }

  def addOne(el: Value) = {
    // Get the current interpretation for l
    index.get(el.time) match {
      case None =>
        // No index for this predicate yet
        index += (el.time -> MSet(el))
      case Some(values) => values += el
    }
    this
  }

  def subtractOne(el: Value) = {
    index.get(el.time) match {
      case None => () // Definitely not contained
      case Some(values) =>
        values -= el
        if (values.isEmpty) index -= el.time
    }
    this
  }

  def iterator = index.valuesIterator.flatten

  override def clone() = {
    // Unforturtunayrly this does not worK (wrong result type)
    // new TimeIndexedSet() ++ iterator
    new TimeIndexedSet[Time, TemporalAmount, Value](toIterable)
    // val res = new TimeIndexedSet[Time, Value]
    // for (el <- iterator) res += el
    // res
  }

  override def canEqual(a: Any) = a.isInstanceOf[TimeIndexedSet[Time, TemporalAmount, Value]]

  override def equals(that: Any): Boolean =
    that match  {
      case that: TimeIndexedSet[Time, TemporalAmount, Value] =>
        (this eq that) || (
          that.canEqual(this) &&
            hashCode() == that.hashCode() &&
            index == that.index
        )
      case _ => false
    } 

  override def hashCode = index.hashCode()

  def timeWindowFilteredInPlace(now: Time, timeWindowFilter: (Time, Value) => Boolean): Unit = {
    // Prune literals that do not satisfy the criteria
    index.values foreach { _ filterInPlace { el => el.time == BOT || timeWindowFilter(now, el) } }
    // retain only non-empty bindings
    index filterInPlace { (time, values) => values.nonEmpty }
  }

}

object TimeIndexedSet {
  def empty[Time, TemporalAmount, Value <: HasTime[Time]](implicit signature: Signature[Time, TemporalAmount]) = new TimeIndexedSet[Time, TemporalAmount, Value]
  def apply[Time, TemporalAmount, Value <: HasTime[Time]](values: Value*)(implicit signature: Signature[Time, TemporalAmount]) = {
    val res = new TimeIndexedSet[Time, TemporalAmount, Value]()(signature)
    res ++= values
    res
  }
}

