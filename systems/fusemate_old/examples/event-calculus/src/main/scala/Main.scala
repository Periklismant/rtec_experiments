package fm6.examples.eventCalculus

import fm6._
import java.time.{OffsetDateTime, ZoneId}
import java.nio.file._
import fm6.util.Logging._
import fm6.Extension
import scala.io.Source
import scala.collection.mutable.ListBuffer

/*
 * Event Calculus demo
 * The well-known door example
 */

object Main {

  object IE extends fm6.InferenceEngine[Int, Int](0, 1, _ + _, Seq(Extension.EC))
  // Use a predefined inference engine (fm6.IntTimeIE._) with Time type Int
  import IE._
  import IE.ruleFramework._
  import IE.ruleFramework.signature._
  import IE.EventCalculus.Sig._

  // Import description logic interface for IE 
  // Rename IsA and HasA away so that it does not conflict with the fluent of the same names
  import fm6.extensions.dl.Sig.{IsA => IsAAssert, HasA => HasAAssert, _}

  // The Event Calculus axioms are defined in fm6/src/main/scala/InferenceEngine.scala 

  def main(args: Array[String]): Unit = {

    fm6.Config.stratification = true
    fm6.Config.verbose = true
    fm6.Config.verbosePreds = Set(".*".r)

    /*
     *  Door example
     */

    case object merchant extends ConceptName
    case object consumer extends ConceptName
    case object goods extends ConceptName

    case class merchant(id: Int) extends Individual
    case class consumer(id: Int) extends Individual
    case class goods(id: String) extends Individual
  
    case class presentQuote(m: Individual, c: Individual, gd: Individual) extends Action
    case class acceptQuote(c: Individual, m: Individual, gd: Individual) extends Action

    case class quote(m: Individual, c: Individual, gd: Individual) extends Fluent

    val maxAgentID = 20
    
    def get_events(eventsNo: Int): List[Lit] = {
      val file_path = "../../../../../../rtec/examples/netbill_fragment/dataset/csv/"
      val file_name = file_path + "netbill-" + eventsNo + ".csv"
      println(file_name)
      var output =  new ListBuffer[Lit]()
      var merchants = new ListBuffer[Int]()
      var consumers = new ListBuffer[Int]() 
      output += (IsAAt(1, goods("book"), goods))
      for (line <- Source.fromFile(file_name).getLines()) {
        val lineSpl = line.split('|')
        val event_name = lineSpl(0)
        val timepoint = lineSpl(1).toInt
        if (event_name == "present_quote" || event_name == "accept_quote") {
          val m = lineSpl(3).toInt
          val c = lineSpl(4).toInt
          val g = lineSpl(5)
          if (m%10==0 && c%3>0){
            if (event_name == "present_quote")
              output += (Happens(timepoint, presentQuote(merchant(m),consumer(c),goods(g))))
            if (event_name == "accept_quote")
              output += (Happens(timepoint, acceptQuote(consumer(c),merchant(m),goods(g))))
            if (!merchants.contains(m) || !consumers.contains(c))
              output += (NEG(HoldsAt(1, quote(merchant(m),consumer(c),goods("book")))))
            if (!merchants.contains(m)){
              output += (IsAAt(1, merchant(m), merchant))
              merchants += m
            }
            if (!consumers.contains(c)){
              output += (IsAAt(1, consumer(c), consumer))
              consumers += c
            }

          }
        }
      }
      output.toList
    }

    val events: List[Lit] = get_events(80) //get_events(8,50) 

    @rules
    val netbillRules = List(

        Initiates(time, presentQuote(m,c,gd), quote(m,c,gd)) :- (
          // Simplification (1), see above:
          IsAAt(1, m, merchant),
          IsAAt(1, c, consumer),
          IsAAt(1, gd, goods),
          // Simplification (2):
          // The following additional goal makes sure that instantiated head literals are derived
          // only for those instances that are needed, which are just those for which the event happens:
          Happens(time, presentQuote(m,c,gd)),
        ),

        StronglyTerminates(time, acceptQuote(c,m,gd), quote(m,c,gd)) :- (
          // Simplification (1), see above:
          IsAAt(1, m, merchant),
          IsAAt(1, c, consumer),
          IsAAt(1, gd, goods),
          HoldsAt(time, quote(m,c,gd)),
          // Simplification (2) again, see above
          Happens(time, acceptQuote(c,m,gd)),
        ),
      )
    
    val models = new IE.Models(netbillRules, events)

    for (m <- models) {
      println(s"=====")
      println(s"Model")
      println(s"=====")

      for (l <- m.toList sortBy { _.time })
        l match {
          case l @ POS(Happens(_, _)) => logln(l)
          case l @ POS(HoldsAt(_, _)) => logln(l)
          case l @ NEG(HoldsAt(_, _)) => logln(l)
          case l @ POS(Initiated(_, _)) => logln(l)
          case l @ POS(Terminated(_, _)) => logln(l)
          case l @ POS(StronglyTerminated(_, _)) => logln(l)
          case _ => ()
        }
    }
  }
}
