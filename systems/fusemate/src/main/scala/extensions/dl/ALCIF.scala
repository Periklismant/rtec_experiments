package fm6.extensions.dl

object ALCIF {

  /*
   * Description Logics ALCIF by translation to Fusemate rules.
   * 
   *  This package is obsolete. This encoding is now part of the Fusemate code itself, see fm6/src/main/scala/extensions/dl
   * 
   *  The code here is inspired by the algorithm for ALCIN in Chapter 4 of 
   *  Baader, F., Horrocks, I., Lutz, C., Sattler, U.: An Introduction to Description Logic. Cambridge
   *  University Press (2017)
   * 
   *  There is a differences between [Chapter 4] and the Fusemate code here concerning
   *  the <= number restriction vs Fusemate functional roles (i.e. <=1 restrictions, no >= restrictions):
   * 
   *  The tableau rule in [Chapter 4] does merging of individuals, if there are more role successors than sanctioned by a <= restriction.
   *  Fusemate does not do that. 
   *  In Fusemate, instead, the order of tableaux expansion rule application does matter,
   *  exists-right is applied with lowest priority only, and creates
   *  an (a single) role-successor for a functional role *only if one does not exists* yet.
   *  For example, x: exists(r,c) and x: exists(r,d) will create
   *  r: (x,y) and y:c and y:d (at time+1) which has the same effect as first creating two successors 
   *  r: (x,y), r: (x,y') and y:c and y':d and then merging y and y'
   *  Because there are no >= role restrictions, there is no need to generate role successors that would have to be merged later.
   * 
   *  Because role successors for functional roles are never generated if one is already present, violations 
   *  of functionality must be present upfront, and can be treated by a rule FAIL :- r(x,y), r(x,z). 
   *  By the just said, the rule will be applicable only to named (given) individuals.
   *  [Chapter 4] would derive an equality y=z, contradicting UNA.
   * 
   *  Correction: the code in the CADE-28 paper implements equality blocking only. This is incorrect. 
   *  The code below implements pairwise equality blocking.
   */

  // DLIE is the inference rule for DL reasoning.
  // 'Time' is Int, which serves as an iteration counter corresponing to the length of Skolemization inference chains ("Exists-right")
  import DLIE._
  import DLIE.ruleFramework._
  import DLIE.ruleFramework.signature._

  // Defines concepts, roles, etc ...
  import Sig._

  case class Neighbour(x: Individual, r: Role, y: Individual, time: Time) extends Atom

  // Auxiliary atoms, see [Chapter 4]
  // Label has all concepts true for an individual x at a given iteration
  case class Label(x: Individual, cs: Set[Concept], time: Time) extends Atom
  // x is an ancestor of y
  case class Anc(x: Individual, y: Individual, time: Time) extends Atom
  // For loop check:
  case class Blocked(y: Individual, x: Individual, time: Time) extends Atom

  @rules
  val InferrenceRules = List(

    /*
     * Clash rules
     */

    FAIL :- (
      DLIsA(x, c, time),
      DLIsA(x, Neg(c), time)
    ),

    FAIL :- (
      DLIsA(x, Bot, _),
    ),

    /*
     *  Unique name assumption, actually needed for named individuals only and for functional roles.
     */

    FAIL :- (
      Neighbour(x, r, y, time),
      Neighbour(x, r, z, time),
      r.isFunctional,
      y != z
    ),

    /*
     * Expansion rule for Exists-right
     */

    // Explicit annotation with artifical predicate name "TimePlus1" which makes sure that there is no loop in stratification graph
    // This trick is OK because the heads are from the next time point, time+1

    ((DLHasA(x, r, rSuccOfx, time+1) AND DLIsA(rSuccOfx, c, time+1)) : @preds("TimePlus1")) :- (
      DLIsA(x, Exists(r, c), time),
      ! r.isFunctional,
      // Check if role restriction is already satisfied
      NOT(
        Neighbour(x, r, y, time: @gnd),
        DLIsA(y, c, time: @gnd),
      ),
      NOT(
        Blocked(x, _, time),
      ),
      LET(rSuccOfx: Individual, Succ(r, x, Some(c))),
    ),

    // Functional roles
    ((DLHasA(x, r, rSuccOfx, time+1) AND DLIsA(rSuccOfx, c, time+1)) : @preds("TimePlus1")) :- (
      DLIsA(x, Exists(r, c), time),
      r.isFunctional,
      // Check if there is already some r-successor
      NOT(
        Neighbour(x, r, y, time: @gnd),
      ),
      NOT(
        Blocked(x, _, time: @gnd),
      ),
      // As there is no r-successor make one, with the desired properties
      LET(rSuccOfx: Individual, Succ(r, x, None)), // rSuccOfx is new, guaranteeing Invariant above
    ),

    DLIsA(y, c, time) :- (
      DLIsA(x, Exists(r, c), time),
      r.isFunctional,
      // The case that there is already a successor.
      Neighbour(x, r, y, time: @gnd),
    ),

    /*
     *  Neighbour
     */

    Neighbour(x, r, y, time) :- (
      DLHasA(x, r, y, time),
      r.isRoleName
    ),

    Neighbour(x, r, y, time) :- (
      DLHasA(y, Inv(r), x, time)
    ),

    Neighbour(x, Inv(r), y, time) :- (
      DLHasA(x, Inv(r), y, time)
    ),

    Neighbour(x, Inv(r.asInstanceOf[RoleName]), y, time) :- (
      DLHasA(y, r, x, time),
      r.isRoleName
    ),


    /*
     * Expansion rules for Forall-right
     */

    DLIsA(y, c, time) :- (
      Neighbour(x, r, y, time),
      DLIsA(x, Forall(r, c), time: @gnd),
    ),

    /*
     * Expansion rules for Boolean combinations of concepts
     */

    ((DLIsA(x, c1, time) AND DLIsA(x, c2, time)) : @preds("DLIsA")) :- DLIsA(x, AndConcept(c1, c2), time),
    ((DLIsA(x, c1, time) OR DLIsA(x, c2, time)) : @preds("DLIsA")) :- DLIsA(x, OrConcept(c1, c2), time),

    /*
     * Rules for conversion to NNF
     */
    DLIsA(x, c, time) :- DLIsA(x, Neg(Neg(c)), time),
    DLIsA(x, OrConcept(Neg(c1), Neg(c2)), time) :- DLIsA(x, Neg(AndConcept(c1, c2)), time),
    DLIsA(x, AndConcept(Neg(c1), Neg(c2)), time) :- DLIsA(x, Neg(OrConcept(c1, c2)), time),
    DLIsA(x, Forall(r, Neg(c)), time) :- DLIsA(x, Neg(Exists(r, c)), time),
    DLIsA(x, Exists(r, Neg(c)), time) :- DLIsA(x, Neg(Forall(r, c)), time),

    /*
     * Rule for Top
     */

    // Inline instead
    // DLIsA(x, Top, time) :- DLIsA(x, c, time),
    // (DLIsA(x, Top, time) AND DLIsA(y, Top, time)) :- DLHasA(x, r, y, time),
  )

  @rules
  val BlockingRules = List(

    /*
     * Auxiliary definitions
     */

      // Collect all concepts that an individual x isA, at a given stage time
      Label(x, cs.toSet, time) :- (
        DLIsA(x, _, time), // At least one
        COLLECT(cs: List[Concept], c STH DLIsA(x, c, time: @gnd))
      ),

      Anc(x, Succ(r, x, t), time) :- (
        DLHasA(x, r, Succ(r, x, t), time),
      ),

      Anc(x, Succ(r, z, t), time) :- (
        DLHasA(z, r, Succ(r, z, t), time),
        Step(time: @gnd, prev),
        Anc(x, z, prev: @gnd),
      ),

      // Definition of blocked

      // Case 1: y is blocked by some individual x

      // Equality blocking - not usable for inverse roles and functional roles
      /*
       Blocked(y, x, time) :- (
       Label(y, yIsAs, time),
       Anc(x, y, time: @gnd),
       // The 'Label' pred could be dispensed of by a NOT-NOT call
       Label(x, xIsAs, time: @gnd),
       // Subset blocking
       // yIsAs subsetOf xIsAs
       // Equality blocking
       yIsAs == xIsAs
       ),
       */
      // Pairwise blocking
      // y is blocked by x if ...
      Blocked(y, x, time) :- (
        // ... x is an ancestor of y,
        Anc(x, y, time),
        // ... the labels of y and x are the same
        Label(y, yIsAs, time: @gnd),
        Label(x, xIsAs, time: @gnd),
        yIsAs == xIsAs,
        // ... y and x are r-successors of some y1 and x1, for some r, 
        DLHasA(y1, r, y, time: @gnd),
        DLHasA(x1, r, x, time: @gnd),
        // ... the labels of y1 and x1 are the same
        Label(y1, y1IsAs, time: @gnd),
        Label(x1, x1IsAs, time: @gnd),
        y1IsAs == x1IsAs,
      ),

      // Case 2: y is blocked by some ancestor
      Blocked(y, x, time) :- (
        Anc(x, y, time),
        Blocked(x, _, time: @gnd)
      ),
  )

  @rules
  val FrameAxioms = List(

      DLIsA(x, c, time) :- (
        Step(time, prev),
        DLIsA(x, c, prev: @gnd)
      ),

      DLHasA(x, r, y, time) :- (
        Step(time, prev),
        DLHasA(x, r, y, prev: @gnd)
      ),

    // Frame axioms for Neighbour are not needed as Neighbour is derived from DLHasA alone
  )

/*
 // This is wrong, query answering needs entailment (validity in all models), not just a single one
  @rules
  val QueryAnswer = List(
      // Domain-independent rule
      Answer(xs, time) :- (
        Query(_, time), // at least one - also forces stratification to COLLECT after Q has been computed
        COLLECT(xs: List[NamedIndividual], xn STH (
          Query(x, time),
          IF( x.isInstanceOf[NamedIndividual] ),
          LET(xn, x.asInstanceOf[NamedIndividual])
        )
      )
    )
  )
 */
   
  val rules = InferrenceRules ++ BlockingRules ++ FrameAxioms // ++ QueryAnswer

}
