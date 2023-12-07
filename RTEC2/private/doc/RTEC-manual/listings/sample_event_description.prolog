/***********************************************************************************
This file represents the event decription written by the user.

Available predicates:
- happensAt( E,T ) represents a time-point T in which an event E occurs. 
- holdsFor( U,L ) represents the list L of the maximal intervals in which a U holds. 
- holdsAt( U,T ) representes a time-point in which U holds. holdsAt may be used only
  in the body of a rule.
- initially( U ) expresses the value of U at time 0. 
- initiatedAt( U,T ) states the conditions in which U is initiated. 
- terminatedAt( U,T ) states the conditions in which U is terminated. 

***********************************************************************************/

/********************************************************
 *			 TRUST				*
 ********************************************************/

initiatedAt( trust( Id,Topic )=true,T ) :-
	happensAt( topic( Id,Topic ),T ),
	holdsAt( hmInfluence( Id )=true,T ).

terminatedAt( trust( Id,_ )=true,T ) :-
	happensAt( start( influence( Id )=low ),T ).

holdsFor( hmInfluence( Id )=true,I ) :-
	holdsFor( influence( Id )=high,I1 ),
	holdsFor( influence( Id )=medium,I2 ),
	union_all( [I1,I2],I ).
