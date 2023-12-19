package fm6.util

/**
  * Graph class for finding SCCs (Strongly connected components)
  * Follows https://www.youtube.com/watch?v=wUgWX0nc4NY
  * @param 	T the node type
  */
class Graph[T]() {

  import collection.immutable.Set
  import collection.mutable.{ Set => MSet }
  import collection.mutable.{ Map => MMap }
  import collection.mutable.Stack

  val g = MMap.empty[T, Set[T]]

  def addEdge(from: T, to: T): Unit = {
    g += (from -> (g.getOrElse(from, Set.empty) + to))
  }

  def addNode(node: T): Unit = {
    if (! (g contains node)) g += (node -> Set.empty)
  }


  /**
   * Returns the nodes adjacent with the given node
   * @param	from the given node
   * @return the list of nodes adjacent to `from`
   */
  def adj(from: T) = g.getOrElse(from, Set.empty)

  // The keys in these maps are the node IDs
  val ids = MMap.empty[T, Int]
  val low = MMap.empty[T, Int]
  val onStack = MSet.empty[T]
  val stack = Stack.empty[T]
  var id = 0 // Used to give each node an ID
  var sccs = List.empty[List[T]] // The result SCCs

  def reset(): Unit = {
    ids.clear(); low.clear(); onStack.clear(); stack.clear(); id = 0; sccs = List.empty
  }

  // Whether node n has been visited - this is the case if it has an id
  def visited(n: T) = ids contains n

  /**
   * dfs: depth first search Tarjan algorithm
   * @param at is the current node
   */

  def dfs(at: T): Unit = {
    stack.push(at)
    onStack += at
    // at gets a new id
    ids(at) = id
    low(at) = id
    id += 1

    // Visit all neighbours recursively and low-link on return
    for (to <- adj(at)) {
      if (!visited(to))
        dfs(to)
      if (onStack(to))
        // to does not belong to a different SCC
        low(at) = math.min(low(at), low(to))
    }
    // After having visited all neighbours of 'at',
    // if we are at the start of an SCC, empty the seen stack until back at the start of the SCC
    if (ids(at) == low(at)) {
      var n = stack.top
      var scc = List.empty[T] // The SCC found
      do {
        n = stack.pop()
        scc ::= n
        onStack -= n
        low(n) = ids(at)
      } while (n != at)
      sccs ::= scc
    }
  }

  def findSCCs(): List[List[T]] = {
    reset()
    for (n <- g.keys) {
      if (!visited(n))
        // Node n has not an id - need to start DFS
        dfs(n)
    }
    sccs
  }

  def findSCCs(n: T): List[List[T]] = {
    reset()
    dfs(n)
    sccs
  }

  override def toString = g.toString()
}

