
package object fm6 {

  case class ERROR(msg: String) extends Exception
  // val tb = universe.runtimeMirror(scala.reflect.runtime.universe.getClass.getClassLoader).mkToolBox()

  trait PrettyPrintable {
    def pretty: String
  }

  /** HasTime is a trait for flagging that its instances have a `time` field of type `Time`.
    * It is typically used for literals and other logical expressions.
    * Instances of `Timed` are implicitly partially ordered by `LaterOrderingForTimed` in the natural way.
    */

  trait HasTime[Time] {
    def time: Time
  }


  /*
   * Compiling, loading, evaluating
   */
/*
  def eval(s: String) = tb.eval(tb.parse(s))
  def compile(file: String) = {
    import tb.u._
    import io.Source

    val fileContents = Source.fromFile(file).getLines.mkString("\n")
    println(fileContents)

    val tree = tb.parse(fileContents)
    println(tree)
    val compiledCode = tb.compile(tree)
    println(compiledCode)
    compiledCode()
    // def make(): Greenhouse = compiledCode().asInstanceOf[Greenhouse]
  }
 */
}

