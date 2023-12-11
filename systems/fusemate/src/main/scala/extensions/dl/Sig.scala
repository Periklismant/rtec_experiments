package fm6.extensions.dl

/*
 * Description Logic Interface Signature
 * The Sig is time agnostic
 */

object Sig {

  // ALCIF signature
  abstract class Concept { def isConceptName = this.isInstanceOf[ConceptName] }
  // Boolean combinations of concepts.
  // All complex formulas must occur only positively. There are expansion rules for this only.
  case class AndConcept(c1: Concept, c2: Concept) extends Concept
  case class OrConcept(c1: Concept, c2: Concept) extends Concept
  case class Neg(c: Concept) extends Concept

  abstract class Role {
    val isFunctional: Boolean
    def isRoleName = this.isInstanceOf[RoleName]
  }

  // Declare role name. Optional field 'functional' to say that, well, this role is functional;
  // Optional field 'injective' .. you guess, which is the same as saying that the inverse role is functional
  abstract class RoleName(val functional: Boolean = false, val injective: Boolean = false) extends Role { val isFunctional = functional }
  // Inverse role. Todo: allow inverse roles to be functional
  case class Inv(r: RoleName) extends Role {
    val isFunctional = r.injective
  }

  // Named individuals: any Scala object can be an individual, "black-box"ish for description logic reasoning
  abstract class Individual { def isKnown = ! this.isInstanceOf[Succ] }
  // Unnamed individuals, by Skolemization of Exists-right
  // Functional role successors are unique per individual (t = None) otherwise unique per individual and target concept c (t = Some(c))
  case class Succ(r: Role, x: Individual, t: Option[Concept]) extends Individual

  abstract class ConceptName extends Concept

  // Not needed - expand in situ
  // case object Top extends ConceptName
  case object Bot extends ConceptName

  case class Exists(r: Role, y: Concept) extends Concept
  // Can write things like C && D => Exists R . C && D
  case class Forall(r: Role, y: Concept) extends Concept

  // These assertions are the ABox elements for the reasoning interface (isSat, DLModels) in DLIE.scala
  sealed abstract class Assertion { def isKnown: Boolean }
  case class IsA(x: Individual, c: Concept) extends Assertion {
    def isKnown = x.isKnown
    // def compl = c match {
    //   case c: ConceptName => ABoxIsA(x, Neg(c))
    //   case Neg(c: ConceptName) => ABoxIsA(x, c)
    // }
  }
  case class HasA(x: Individual, r: Role, y: Individual) extends Assertion {
    def isKnown = x.isKnown && y.isKnown
  }

}
