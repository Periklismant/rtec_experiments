:- dynamic person_pair/2.

initiatedAt(quote(_11380,_11382,_11384)=true, _11406, _11350, _11412) :-
     happensAtIE(present_quote(_11380,_11382,_11384,_11394),_11350),
     _11406=<_11350,
     _11350<_11412.

terminatedAt(quote(_11380,_11382,_11384)=true, _11404, _11350, _11410) :-
     happensAtIE(accept_quote(_11382,_11380,_11384),_11350),
     _11404=<_11350,
     _11350<_11410.

grounding(present_quote(_11616,_11618,_11620,_11622)) :- 
     person_pair(_11616,_11618),goods(_11620).

grounding(accept_quote(_11616,_11618,_11620)) :- 
     person_pair(_11618,_11616),goods(_11620).

grounding(quote(_11622,_11624,_11626)=true) :- 
     person_pair(_11622,_11624),goods(_11626).

grounding(quote(_11622,_11624,_11626)=false) :- 
     person_pair(_11622,_11624),goods(_11626).

inputEntity(present_quote(_11410,_11412,_11414,_11416)).
inputEntity(accept_quote(_11410,_11412,_11414)).
inputEntity(quote(_11416,_11418,_11420)=false).

outputEntity(quote(_11496,_11498,_11500)=true).

event(present_quote(_11558,_11560,_11562,_11564)).
event(accept_quote(_11558,_11560,_11562)).

simpleFluent(quote(_11638,_11640,_11642)=true).

sDFluent(quote(_11706,_11708,_11710)=false).

index(present_quote(_11714,_11774,_11776,_11778),_11714).
index(accept_quote(_11714,_11774,_11776),_11714).
index(quote(_11714,_11780,_11782)=true,_11714).
index(quote(_11714,_11780,_11782)=false,_11714).


cachingOrder2(_11990, quote(_11990,_11992,_11994)=true) :- % level in dependency graph: 1, processing order in component: 1
     person_pair(_11990,_11992),goods(_11994).

collectGrounds([present_quote(_11610,_11612,_11628,_11630), accept_quote(_11612,_11610,_11628), quote(_11610,_11612,_11634)=false],person_pair(_11610,_11612)).

dgrounded(quote(_11708,_11710,_11712)=true, person_pair(_11708,_11710)).
