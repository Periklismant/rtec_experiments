
/****************************************************************
 *                                                              *
 * LPG DASH EC Protocol						*
 * Jeremy Pitt, Imperial College London				*
 * Event Calculus by Marek Sergot				*
 * Original Formulation by Alexander Artikis			*
 *                                                              *
 ****************************************************************/

/*****************
 * INITIAL STATE *
 *****************/
% ----- We specify the value of every simple fluent at the initial state 

initially( current_game(1) = 1 ).

initially( gameover(1,1) = false ).

initially( role( aa,1) = [] ).	
initially( role( ab,1) = [] ).	
initially( role( ac,1) = [] ).	
initially( role( ad,1) = [] ).	
initially( role( ae,1) = [] ).	

initially( bfpool(1,1) = 0 ).
initially( ifpool(1,1) = 0 ).

initially( borda_ptq(1,1) = [] ).
initially( f_weights(1) = [] ).

initially( voting(1,1) = none ).
initially( votes(fw,1,1) = [] ).
initially( voters(fw,1,1) = [] ).

initially( demanded(aa,1,1) = 0.0 ).
initially( provided(aa,1,1) = 0.0 ).
initially( demanded(ab,1,1) = 0.0 ).
initially( provided(ab,1,1) = 0.0 ).
initially( demanded(ac,1,1) = 0.0 ).
initially( provided(ac,1,1) = 0.0 ).
initially( demanded(ad,1,1) = 0.0 ).
initially( provided(ad,1,1) = 0.0 ).
initially( demanded(ae,1,1) = 0.0 ).
initially( provided(ae,1,1) = 0.0 ).

:- b_setval( voters, [] ).

/************
 * ROLES    *
 ***********/

initiates( join(A, C), role(A, C)=[prosum], T ) :-
	holdsAt( role(A, C)=[], T ),
	\+ (holdsAt( role(A, _)=Roles, T ), member( prosum, Roles )).

initiates( leave(A, C), role(A, C)=[], T ) :-
	holdsAt( role(A, C)=Roles, T ),
	member( prosum, Roles ).

initiates( appoint(A, R, C), role(A, C)=[R|Roles], T ) :-
	holdsAt( role(A, C)=Roles, T ), 
	member( prosum, Roles ).


/************
 * PROVISIONS  *
 ***********/

initiatedAt(provided(I,G,C)=Pi, T) :-
	happensAt(provide(I,Pi,G,C), T),
	holdsAt( pow(I, provide(I,Pi,G,C))=true, T).

initiatedAt(bfpool(G,C)=NewBF, T) :-
	happensAt(provide(_,Pi,G,C), T),
	holdsAt(bfpool(G,C)=BF, T),
	NewBF is BF+Pi.

initiatedAt(ifpool(G,C)=NewIF, T) :-
	happensAt(provide(_,Pi,G,C), T), 
	holdsAt(ifpool(G,C)=IF, T),
	NewIF is IF+Pi.

/************
 * DEMANDS  *
 ***********/

initiatedAt(demanded(I,G,C)=Di, T) :-
	happensAt(demand(I,Di,G,C), T),
	holdsAt(pow(demand(I,Di,G,C))=true, T).

/****************
 * ALLOCATIONS  *
 ****************/

initiatedAt(allocated(I,G,C)=Ri, T) :-
	happensAt(allocate(H,I,Ri,G,C), T),
	holdsAt(pow(allocate(H,I,Ri,G,C))=true, T).

initiates(ifpool(G,C)=NewIF, T) :-
	happensAt(allocate(H,I,Ri,G,C), T),
	holdsAt(ifpool(G,C)=IF, T),
	NewIF is IF-Ri,
	holdsAt(pow(allocate(H,I,Ri,G,C))=true, T).

initiates(borda_ptq(G,C)=Tl, T) :-
	happensAt(allocate(H,I,Ri,G,C), T),
	holdsAt(borda_ptq(G,C)=[(I,_)|Tl], T),
	holdsAt(pow(allocate(H,I,Ri,G,C))=true, T).

/*******************
 * APPROPRIATIONS  *
 *******************/

initiates( appropriate(_, Rdashi, G, C), bfpool(G, C)=NewBF, T ) :-
	holdsAt( bfpool(G, C)=BF, T ),
	BF >= Rdashi,
	NewBF is BF - Rdashi.
initiates( appropriate(I, Rdashi, G, C), appropriated(I, G, C)=Rdashi, T ) :-
	holdsAt( bfpool(G, C)=BF, T ),
	BF >= Rdashi, 
	holdsAt( pow(I, appropriate(I, Rdashi, G, C))=true, T ).

/************
 * DECLARATIONS  *
 ***********/

% The rigid designator check is just to not have two declare actions.
% Otherwise it is just a check to see if the content of the declare is `about'
% agents or about functions... no big deal...

initiates( announce(H, BPTQ, G, C), borda_ptq(G, C)=BPTQ, T ) :-
	borda_count(G, C, BPTQ, _),
	holdsAt( pow(H, declare(H, BPTQ, G, C))=true, T ).

initiates( declare(H, FW, G, C), f_weights(C)=FW, T ) :-
	function_weights(G, C, FW, _),
	holdsAt( pow(H, declare(H, BPTQ, G, C))=true, T ).

/************
 * VOTES  *
 ***********/

initiates( cfv(H, Motion, G, C), voting(G, C)=Motion, T ) :-
	holdsAt( pow(H, cfv(H, Motion, G, C))=true, T ).

initiates( endv(H, Motion, G, C), voting(G, C)=none, T ) :-
	holdsAt( pow(H, cfv(H, Motion, G, C))=true, T ).

initiates( cfv(H, Motion, G, C), votes(Motion, G, C)=[], T ) :-
	holdsAt( pow(H, cfv(H, Motion, G, C))=true, T ).

initiates( cfv(H, Motion, G, C), voters(Motion, G, C)=[], T ) :-
	holdsAt( pow(H, cfv(H, Motion, G, C))=true, T ).

initiates( vote(I, Vote, M, G, C), votes(M, G, C)=[Vote|Votes], T ) :-
	holdsAt( votes(M, G, C)=Votes, T ),
	holdsAt( pow(I, vote(I, Vote, M, G, C))=true, T ).

initiates( vote(I, Vote, M, G, C), voters(M, G, C)=[I|Vs], T ) :-
	holdsAt( voters(M, G, C)=Vs, T ),
	b_setval( voters, Vs ),
	holdsAt( pow(I, vote(I, Vote, M, G, C))=true, T ).


/****
 * Game
 ****/

initiates( gameover(h, G, C), gameover(G, C)=true, _ ).

initiates( gameover(h, G, C), decmf_ctr(C)=F1, T ) :-
	holdsAt( decmf_ctr(C)=F, T ),
        F1 is F + 1,
	holdsAt( reported(_, ocr_a, G, C)=false, T ).

/***********************
 * INSTITUTIONAL POWER *
 ***********************/

holdsFor(pow(demand(I,_,G,C))=true, I) :-
	holdsFor(current_game(C)=G, T),
	holdsFor(demanded(I,G,C)=0.0, T),
	holdsFor(role(I, C)=Roles, T ), member(prosum, Roles).

holdsAt( pow(I, provide(I, _, G, C))=true, T ) :-
	holdsAt( current_game(C)=G, T ),
	holdsAt( provided(I,G,C)=0.0, T ),
	holdsAt( role(I, C)=Roles, T ), member(prosum, Roles).

holdsAt( pow(H, allocate(H, I, R, G, C))=true, T ) :-
	holdsAt( current_game(C)=G, T ),
	% \+ holdsAt( borda_ptq(G, C)=[], T ),
	holdsAt( borda_ptq(G, C)=[_|_], T ),
	holdsAt( role(H,C)=Roles, T ), member(allocator, Roles).

holdsAt( pow(I, appropriate(I, _, G, C))=true, T ) :-
	holdsAt( current_game(C)=G, T ),
	holdsAt( role(I, C)=Roles, T ), member(prosum, Roles).

holdsAt( pow(I, announce(I, L, G, C))=true, T ) :-
	holdsAt( current_game(C)=G, T ),
	borda_count(G, C, L, T ),
	holdsAt( role(I, C)=Roles, T ), member(allocator, Roles).

holdsAt( pow(I, declare(I, F, G, C))=true, T ) :-
	holdsAt( current_game(C)=G, T ),
	function_weights(G, C, F, T ),
	holdsAt( role(I, C)=Roles, T ), member(head, Roles).

holdsAt( pow(I, cfv(I, _, G, C))=true, T ) :-
	holdsAt( current_game(C)=G, T ),
	holdsAt( role(I, C)=Roles, T ), member(head, Roles).

holdsAt( pow(I, vote(I, _, fw, G, C))=true, T ) :-
	holdsAt( current_game(C)=G, T ),
	holdsAt( voting(G, C)=fw, T ),
	b_getval( voters, Vs ),
	\+ member( I, Vs ),
	holdsAt( role(I, C)=Roles, T ), member(prosum, Roles).
	
/**************
 * PERMISSION *
 **************/

holdsAt( per(I, demand(I, Di, G, C))=true, T ) :-
        holdsAt( pow(I, demand(I, Di, G, C))=true, T ).

holdsAt( per(I, provide(I, Di, G, C))=true, T ) :-
        holdsAt( pow(I, provide(I, Di, G, C))=true, T ).

/*
holdsAt( per(H, allocate(H, I, Ri, G, C))=true, T ) :-
        holdsAt( pow(H, allocate(H, I, Ri, G, C))=true, T ),
	holdsAt( borda_ptq(G, C)=[(I,_)|_], T ).
*/

holdsAt( per(H, allocate(H, I, Ri, G, C))=true, T ) :-
        holdsAt( pow(H, allocate(H, I, Ri, G, C))=true, T ),
	holdsAt( borda_ptq(G, C)=[(I,_)|_], T ),
	holdsAt( ifpool(G, C)=P, T ),
	holdsAt( demanded(I, G, C)=Di, T ),
	((P>=Di, Ri=Di) ; (P<Di, Ri=P) ).

holdsAt( per(I, appropriate(I, Rdashi, G, C))=true, T ) :-
	holdsAt( allocated(I, G, C)=Rdashi, T ),
	\+ holdsAt( appropriated(I, G, C)=Rdashi, T ),
        holdsAt( pow(I, appropriate(I, Rdashi, G, C))=true, T ).

holdsAt( per(I, declare(I, BPTQ, G, C))=true, T ) :-
        holdsAt( pow(I, declare(I, BPTQ, G, C))=true, T ).

holdsAt( per(I, cfv(I, M, G, C))=true, T ) :-
        holdsAt( pow(I, cfv(I, M, G, C))=true, T ).

holdsAt( per(I, vote(I, V, M, G, C))=true, T ) :-
        holdsAt( pow(I, vote(I, V, M, G, C))=true, T ).

holdsAt( per(Agent, Action) = false, T ) :-
	\+ holdsAt( per(Agent, Action) = true, T ).


/**************
 * OBLIGATION *
 **************/


/************************ 

 * AUXILIARY PREDICATES *

 ************************/


/*************
 * NARRATIVE *
 *************/

/******************
 * SAMPLE QUERIES *
 *****************/

dump_fromto( Agents, StartClock, EndClock ) :-
	StartClock > EndClock,
	dump_list( Agents, StartClock ), nl.

dump_fromto( Agents, StartClock, EndClock ) :-
	write( 'Clock Time ' ), write( StartClock ), nl,
		holdsAt( ifpool(1,1)=IF, StartClock ), write( 'IFPool = ' ), write( IF ), nl,
		holdsAt( bfpool(1,1)=BF, StartClock ), write( 'BFPool = ' ), write( BF ), nl,
		holdsAt( voting(1,1)=M, StartClock ), write( 'Motion = ' ), write( M ), nl,
		holdsAt( votes(fw,1,1)=V, StartClock ), write( 'Votes = ' ), write( V ), nl,
		holdsAt( voters(fw,1,1)=E, StartClock ), write( 'Electorate = ' ), write( E ), nl,
		b_setval( voters, E ),
	dump_list( Agents, StartClock ),
	nl, happens( Event, StartClock ), write( Event ), nl,
	NextClock is StartClock + 1, nl,
	dump_fromto( Agents, NextClock, EndClock ).
