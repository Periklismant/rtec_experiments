package fm6

/*
 * The InferenceEngine class abstracts from creating the signature, rules framework and tableau framework explicitly.
 */

import fm6.Extension._

class InferenceEngine[Time, TemporalAmount](BOT: Time, Epsilon: TemporalAmount, plus: (Time, TemporalAmount) => Time, extensions: Seq[Extension] = Seq.empty)(implicit TimeOrdering: Ordering[Time]) extends TableauFramework(new RuleFramework(new Signature[Time, TemporalAmount](BOT, Epsilon, plus)), extensions) {

  /**
   * Models is the main class for computing models for a given initial edb and a set of rules.
   * It is implemented as a Scala Iterable and in a lazy way. This means that the models can be retrieved one after the other, with
   * usual Scala iteration operators, provided that each model computation terminates, which is not guaranteed per se.
   *
   * @param rules a collection of `Rule`s for the model computation
   * @param initEDB optional collection of literals serving as the initial EDB
   * @param extensions a `Seq[Extension]`, theories modulo, essentially, currently available: DL and EC
   */


  import ruleFramework._
  import ruleFramework.signature._

  class Models(rules: Iterable[Rule], initEDB: Iterable[Lit] = Iterable.empty) extends Iterable[Interpretation] {

    // todo: proper destructive versions, keeping the current tableau
    /*
       val currentEDB = MSet.empty[EDBLit] ++ initEDB
       val currentOrs = MSet.empty[Or] ++ initIDB
       // destructive operations

       def ++=(elems: Iterable[Any]): Unit = { elems foreach { this += _ } }
       def +=(elem: Any): Unit = {
       elem match {
       case or: Or => currentOrs += or
       case l => currentEDB += l.asInstanceOf[EDBLit] // assume this is an edbLit
       }
       }
       // non-destructive. Can add EDB literals out of time order
       def ++(ls: Iterable[EDBLit]) = new Models(rules, currentEDB.toSet ++ ls, currentOrs)
       def +(l: EDBLit) = new Models(rules, currentEDB.toSet + l, currentOrs)

       def --(ls: Iterable[EDBLit]) = new Models(rules, currentEDB.toSet -- ls, currentOrs)
       def -(l: EDBLit) = new Models(rules, currentEDB.toSet - l, currentOrs)

       def iterator = new Tableau(rules, currentEDB, currentOrs)
       */
    // val initEDBasSet = initEDB.toSet // do only onbce for efficiency
    def ++(ls: Iterable[Lit]) = new Models(rules, initEDB ++ ls)
    def +(l: Lit) = new Models(rules, initEDB ++ Iterable(l))

    def --(ls: Iterable[Lit]) = new Models(rules, initEDB.toSet -- ls)
    def -(l: Lit) = new Models(rules, initEDB.toSet - l)

    def iterator = new Tableau(rules, initEDB)
  }

  /*
     * saturate, saturateFirst
     * Functional programming style invocation of model computation
     */

  implicit class myLitIterable(edb: Iterable[Lit]) {
    def saturateFirst(rules: Iterable[Rule]) = new Models(rules, edb).head
    def saturate(rules: Iterable[Rule]) = new Models(rules, edb)
  }

}
object IntTimeIE extends InferenceEngine[Int, Int](0, 1, _ + _)

object Int2TimeIE extends InferenceEngine[(Int, Int), Int](
  (0, 0),
  1,
  { case ((time, a), amount) => (time + amount, a) })(Ordering.Tuple2[Int, Int])

object Int3TimeIE extends InferenceEngine[(Int, Int, Int), Int](
  (0, 0, 0),
  1,
  { case ((time, a, b), amount) => (time + amount, a, b) })(Ordering.Tuple3[Int, Int, Int])
