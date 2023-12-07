:-dynamic initiatedAt/4, holdsForSDFluent/2, initiatedAt/2, terminatedAt/2, terminatedAt/4, maxDuration/3, maxDurationUE/3.
initiatedAt(person(_131566)=true, _131593, _131549, _131595) :-
     user:happensAt(startI(walking(_131566)=true),_131549),
     \+user:happensAt(disappear(_131566),_131549).

initiatedAt(person(_131566)=true, _131593, _131549, _131595) :-
     user:happensAt(startI(running(_131566)=true),_131549),
     \+user:happensAt(disappear(_131566),_131549).

initiatedAt(person(_131566)=true, _131593, _131549, _131595) :-
     user:happensAt(startI(active(_131566)=true),_131549),
     \+user:happensAt(disappear(_131566),_131549).

initiatedAt(person(_131566)=true, _131593, _131549, _131595) :-
     user:happensAt(startI(abrupt(_131566)=true),_131549),
     \+user:happensAt(disappear(_131566),_131549).

initiatedAt(person(_131566)=false, _131575, _131549, _131577) :-
     user:happensAt(disappear(_131566),_131549).

initiatedAt(leaving_object(_131566,_131567)=true, _131620, _131549, _131622) :-
     user:happensAt(appear(_131567),_131549),
     user:holdsAt(inactive(_131567)=true,_131549),
     user:holdsAt(person(_131566)=true,_131549),
     user:holdsAt(closeSymmetric(_131566,_131567,30)=true,_131549).

initiatedAt(leaving_object(_131566,_131567)=false, _131576, _131549, _131578) :-
     user:happensAt(disappear(_131567),_131549).

initiatedAt(meeting(_131566,_131567)=true, _131608, _131549, _131610) :-
     user:happensAt(startI(greeting1(_131566,_131567)=true),_131549),
     \+user:happensAt(disappear(_131566),_131549),
     \+user:happensAt(disappear(_131567),_131549).

initiatedAt(meeting(_131566,_131567)=true, _131608, _131549, _131610) :-
     user:happensAt(startI(greeting2(_131566,_131567)=true),_131549),
     \+user:happensAt(disappear(_131566),_131549),
     \+user:happensAt(disappear(_131567),_131549).

initiatedAt(meeting(_131566,_131567)=false, _131581, _131549, _131583) :-
     user:happensAt(startI(running(_131566)=true),_131549).

initiatedAt(meeting(_131566,_131567)=false, _131581, _131549, _131583) :-
     user:happensAt(startI(running(_131567)=true),_131549).

initiatedAt(meeting(_131566,_131567)=false, _131581, _131549, _131583) :-
     user:happensAt(startI(abrupt(_131566)=true),_131549).

initiatedAt(meeting(_131566,_131567)=false, _131581, _131549, _131583) :-
     user:happensAt(startI(abrupt(_131567)=true),_131549).

initiatedAt(meeting(_131566,_131567)=false, _131583, _131549, _131585) :-
     user:happensAt(startI(close(_131566,_131567,34)=false),_131549).

holdsForSDFluent(close(_131566,_131567,24)=true,_131549) :-
     user:holdsFor(distance(_131566,_131567,24)=true,_131549).

holdsForSDFluent(close(_131566,_131567,25)=true,_131549) :-
     user:holdsFor(close(_131566,_131567,24)=true,_131577),
     user:holdsFor(distance(_131566,_131567,25)=true,_131593),
     user:union_all([_131577,_131593],_131549).

holdsForSDFluent(close(_131566,_131567,30)=true,_131549) :-
     user:holdsFor(close(_131566,_131567,25)=true,_131577),
     user:holdsFor(distance(_131566,_131567,30)=true,_131593),
     user:union_all([_131577,_131593],_131549).

holdsForSDFluent(close(_131566,_131567,34)=true,_131549) :-
     user:holdsFor(close(_131566,_131567,30)=true,_131577),
     user:holdsFor(distance(_131566,_131567,34)=true,_131593),
     user:union_all([_131577,_131593],_131549).

holdsForSDFluent(close(_131566,_131567,_131568)=false,_131549) :-
     user:holdsFor(close(_131566,_131567,_131568)=true,_131577),
     user:complement_all([_131577],_131549).

holdsForSDFluent(closeSymmetric(_131566,_131567,_131568)=true,_131549) :-
     user:holdsFor(close(_131566,_131567,_131568)=true,_131577),
     user:holdsFor(close(_131567,_131566,_131568)=true,_131593),
     user:union_all([_131577,_131593],_131549).

holdsForSDFluent(greeting1(_131566,_131567)=true,_131549) :-
     user:holdsFor(activeOrInactivePerson(_131566)=true,_131576),
     \+_131576=[],
     user:holdsFor(person(_131567)=true,_131598),
     \+_131598=[],
     user:holdsFor(close(_131566,_131567,25)=true,_131620),
     \+_131620=[],
     user:intersect_all([_131576,_131620,_131598],_131644),
     \+_131644=[],
     user:!,
     user:holdsFor(running(_131567)=true,_131673),
     user:holdsFor(abrupt(_131567)=true,_131687),
     user:relative_complement_all(_131644,[_131673,_131687],_131549).

holdsForSDFluent(greeting1(_131557,_131558)=true,[]).

holdsForSDFluent(greeting2(_131566,_131567)=true,_131549) :-
     user:holdsFor(walking(_131566)=true,_131576),
     \+_131576=[],
     user:holdsFor(activeOrInactivePerson(_131567)=true,_131598),
     \+_131598=[],
     user:holdsFor(close(_131567,_131566,25)=true,_131620),
     \+_131620=[],
     user:!,
     user:intersect_all([_131576,_131598,_131620],_131549).

holdsForSDFluent(greeting2(_131557,_131558)=true,[]).

holdsForSDFluent(activeOrInactivePerson(_131566)=true,_131549) :-
     user:holdsFor(active(_131566)=true,_131575),
     user:holdsFor(inactive(_131566)=true,_131589),
     user:holdsFor(person(_131566)=true,_131603),
     user:intersect_all([_131589,_131603],_131617),
     user:union_all([_131575,_131617],_131549).

holdsForSDFluent(moving(_131566,_131567)=true,_131549) :-
     user:holdsFor(walking(_131566)=true,_131576),
     user:holdsFor(walking(_131567)=true,_131590),
     user:intersect_all([_131576,_131590],_131604),
     \+_131604=[],
     user:holdsFor(close(_131566,_131567,34)=true,_131625),
     \+_131625=[],
     user:!,
     user:intersect_all([_131604,_131625],_131549).

holdsForSDFluent(moving(_131557,_131558)=true,[]).

holdsForSDFluent(fighting(_131566,_131567)=true,_131549) :-
     user:holdsFor(abrupt(_131566)=true,_131576),
     user:holdsFor(abrupt(_131567)=true,_131590),
     user:union_all([_131576,_131590],_131604),
     \+_131604=[],
     user:holdsFor(close(_131566,_131567,24)=true,_131625),
     \+_131625=[],
     user:intersect_all([_131604,_131625],_131649),
     \+_131649=[],
     user:!,
     user:holdsFor(inactive(_131566)=true,_131676),
     user:holdsFor(inactive(_131567)=true,_131690),
     user:union_all([_131676,_131690],_131704),
     user:relative_complement_all(_131649,[_131704],_131549).

holdsForSDFluent(fighting(_131557,_131558)=true,[]).

cachingOrder2(_131548, close(_131548,_131549,24)=true) :-
     user:id_pair(_131548,_131549).

cachingOrder2(_131548, close(_131548,_131549,25)=true) :-
     user:id_pair(_131548,_131549).

cachingOrder2(_131548, close(_131548,_131549,30)=true) :-
     user:id_pair(_131548,_131549).

cachingOrder2(_131548, close(_131548,_131549,34)=true) :-
     user:id_pair(_131548,_131549).

cachingOrder2(_131548, close(_131548,_131549,34)=false) :-
     user:id_pair(_131548,_131549).

cachingOrder2(_131548, closeSymmetric(_131548,_131549,30)=true) :-
     user:id_pair(_131548,_131549).

cachingOrder2(_131548, person(_131548)=true) :-
     user:list_of_ids(_131548).

cachingOrder2(_131548, activeOrInactivePerson(_131548)=true) :-
     user:list_of_ids(_131548).

cachingOrder2(_131548, greeting1(_131548,_131549)=true) :-
     user:id_pair(_131548,_131549).

cachingOrder2(_131548, greeting2(_131548,_131549)=true) :-
     user:id_pair(_131548,_131549).

cachingOrder2(_131548, leaving_object(_131548,_131549)=true) :-
     user:id_pair(_131548,_131549).

cachingOrder2(_131548, leaving_object(_131548,_131549)=true) :-
     user:symmetric_id_pair(_131548,_131549).

cachingOrder2(_131548, meeting(_131548,_131549)=true) :-
     user:id_pair(_131548,_131549).

cachingOrder2(_131548, moving(_131548,_131549)=true) :-
     user:id_pair(_131548,_131549).

cachingOrder2(_131548, fighting(_131548,_131549)=true) :-
     user:id_pair(_131548,_131549).

buildFromPoints2(_131548, walking(_131548)=true) :-
     user:list_of_ids(_131548).

buildFromPoints2(_131548, active(_131548)=true) :-
     user:list_of_ids(_131548).

buildFromPoints2(_131548, inactive(_131548)=true) :-
     user:list_of_ids(_131548).

buildFromPoints2(_131548, running(_131548)=true) :-
     user:list_of_ids(_131548).

buildFromPoints2(_131548, abrupt(_131548)=true) :-
     user:list_of_ids(_131548).
