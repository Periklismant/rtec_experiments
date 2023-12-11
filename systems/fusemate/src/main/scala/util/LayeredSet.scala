package fm6.util

import fm6.ERROR

/**
 * `LayeredSet[T]` represents a set of `T`'s stored in an a priori fixed number of layers.
 *  The layeres are integer indexed, starting from 0.
 *  The elements are stored according to their index given by an indexFn.
 *  Layered sets acts like other mutable sets but offer layered access to its elements.
 *  @param T    the type of the elements, a subtype of `HasIndex`.
 *  @param nrLayeres the number of layers.
 *  @param indexFn a function that returns for a given T its index in the range [0 .. nrLayeres-1]
 */

class LayeredSet[T](nrLayers: Int, indexFn: (T => Int)) extends collection.mutable.Set[T] {

  import collection.mutable.{ HashSet => MSet }

  val layer = new Array[MSet[T]](nrLayers)
  def clear(): Unit = {
    for (idx <- 0 until nrLayers) layer(idx) = MSet.empty
  }
  clear() // otherwise have array of nulls

  def apply(idx: Int) = layer(idx)

  def isEmptyTo(idx: Int): Boolean = (0 to idx) forall { layer(_).isEmpty }
  @inline def nonEmptyTo(idx: Int) = !isEmptyTo(idx)

  def addOne(el: T) = {
    layer(indexFn(el)) += el
    this
  }

  def subtractOne(el: T) = {
    layer(indexFn(el)) += el
    this
  }

  def contains(el: T) = (0 until nrLayers) exists { layer(_) contains el }

  def iteratorTo(idx: Int) = ((0 to idx).iterator map { layer(_).iterator }).flatten
  @inline def iterator = iteratorTo(nrLayers - 1)

  // all elemens up to ids
  // def elemsTo(idx: Int) = {
  //   var res = MSet.empty[T]
  //   (0 to idx) foreach { res ++= layer(_) }
  //   res
  // }

  /* not needed - use iterator, or clone() if a copy is needed
   */
  // @inline def elems = elemsTo(nrLayers - 1)

  // This is not a deep clone, i.e. the T's are not cloned
  override def clone() = {
    val res = new LayeredSet[T](nrLayers, indexFn)
    for (idx <- 0 until nrLayers) res.layer(idx) ++= layer(idx)
    res
  }

  def lowestRemoved(idx: Int): T = {
    for (i <- 0 to idx) {
      if (layer(i).nonEmpty) {
        val res = layer(i).head
        layer(i) -= res
        return res
      }
    }
    throw ERROR("removeEarliast on empty LayeredSet")
  }
}

