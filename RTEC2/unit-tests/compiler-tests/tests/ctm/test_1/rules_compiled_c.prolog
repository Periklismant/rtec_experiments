:-dynamic initiatedAt/4, holdsForSDFluent/2, initiatedAt/2, terminatedAt/2, terminatedAt/4, maxDuration/3, maxDurationUE/3.
initiatedAt(punctuality(_197951,_197952)=punctual, _197957, -1, _197961) :-
     _197957=< -1,
     -1<_197961.

initiatedAt(passenger_density(_197951,_197952)=low, _197957, -1, _197961) :-
     _197957=< -1,
     -1<_197961.

initiatedAt(noise_level(_197951,_197952)=low, _197957, -1, _197961) :-
     _197957=< -1,
     -1<_197961.

initiatedAt(internal_temperature(_197951,_197952)=normal, _197957, -1, _197961) :-
     _197957=< -1,
     -1<_197961.

initiatedAt(punctuality(_197959,_197960)=punctual, _197965, -1, _197969) :-
     _197965=< -1,
     -1<_197969.

initiatedAt(passenger_density(_197959,_197960)=low, _197965, -1, _197969) :-
     _197965=< -1,
     -1<_197969.

initiatedAt(noise_level(_197959,_197960)=low, _197965, -1, _197969) :-
     _197965=< -1,
     -1<_197969.

initiatedAt(internal_temperature(_197959,_197960)=normal, _197965, -1, _197969) :-
     _197965=< -1,
     -1<_197969.

initiatedAt(punctuality(_131565,_131566)=punctual, _131578, _131548, _131580) :-
     user:happensAt(stop_enter(_131565,_131566,_131576,scheduled),_131548).

initiatedAt(punctuality(_131565,_131566)=punctual, _131578, _131548, _131580) :-
     user:happensAt(stop_enter(_131565,_131566,_131576,early),_131548).

initiatedAt(punctuality(_131565,_131566)=non_punctual, _131578, _131548, _131580) :-
     user:happensAt(stop_enter(_131565,_131566,_131576,late),_131548).

initiatedAt(punctuality(_131565,_131566)=non_punctual, _131578, _131548, _131580) :-
     user:happensAt(stop_leave(_131565,_131566,_131576,early),_131548).

initiatedAt(internal_temperature(_131565,_131566)=_131551, _131577, _131548, _131579) :-
     user:happensAt(internal_temperature_change(_131565,_131566,_131551),_131548).

initiatedAt(passenger_density(_131557,_131558)=_131552, _131569, _131549, _131571) :-
     happensAtIE(passenger_density_change(_131557,_131558,_131552),_131549),_131569=<_131549,_131549<_131571.

initiatedAt(noise_level(_131557,_131558)=_131552, _131569, _131549, _131571) :-
     happensAtIE(noise_level_change(_131557,_131558,_131552),_131549),_131569=<_131549,_131549<_131571.

holdsForSDFluent(punctuality(_131565,_131566)=non_punctual,_131548) :-
     user:holdsFor(punctuality(_131565,_131566)=punctual,_131575),
     user:complement_all([_131575],_131548).

holdsForSDFluent(driving_style(_131565,_131566)=unsafe,_131548) :-
     user:holdsFor(sharp_turn(_131565,_131566)=very_sharp,_131575),
     user:holdsFor(abrupt_acceleration(_131565,_131566)=very_abrupt,_131590),
     user:holdsFor(abrupt_deceleration(_131565,_131566)=very_abrupt,_131605),
     user:union_all([_131575,_131590,_131605],_131548).

holdsForSDFluent(driving_style(_131565,_131566)=uncomfortable,_131548) :-
     user:holdsFor(sharp_turn(_131565,_131566)=sharp,_131575),
     user:holdsFor(abrupt_acceleration(_131565,_131566)=very_abrupt,_131590),
     user:holdsFor(abrupt_deceleration(_131565,_131566)=very_abrupt,_131605),
     user:relative_complement_all(_131575,[_131590,_131605],_131621),
     user:holdsFor(abrupt_acceleration(_131565,_131566)=abrupt,_131634),
     user:holdsFor(abrupt_deceleration(_131565,_131566)=abrupt,_131649),
     user:union_all([_131621,_131634,_131649],_131548).

holdsForSDFluent(driving_quality(_131565,_131566)=high,_131548) :-
     user:holdsFor(punctuality(_131565,_131566)=punctual,_131575),
     user:holdsFor(driving_style(_131565,_131566)=unsafe,_131590),
     user:holdsFor(driving_style(_131565,_131566)=uncomfortable,_131605),
     user:relative_complement_all(_131575,[_131590,_131605],_131548).

holdsForSDFluent(driving_quality(_131565,_131566)=medium,_131548) :-
     user:holdsFor(punctuality(_131565,_131566)=punctual,_131575),
     \+_131575=[],
     user:!,
     user:holdsFor(driving_style(_131565,_131566)=uncomfortable,_131604),
     user:intersect_all([_131575,_131604],_131548).

holdsForSDFluent(driving_quality(_131556,_131557)=medium,[]).

holdsForSDFluent(driving_quality(_131565,_131566)=low,_131548) :-
     user:holdsFor(punctuality(_131565,_131566)=non_punctual,_131575),
     user:holdsFor(driving_style(_131565,_131566)=unsafe,_131590),
     user:union_all([_131575,_131590],_131548).

holdsForSDFluent(passenger_comfort(_131565,_131566)=reducing,_131548) :-
     user:holdsFor(driving_style(_131565,_131566)=uncomfortable,_131575),
     user:holdsFor(driving_style(_131565,_131566)=unsafe,_131590),
     user:holdsFor(passenger_density(_131565,_131566)=high,_131605),
     user:holdsFor(noise_level(_131565,_131566)=high,_131620),
     user:holdsFor(internal_temperature(_131565,_131566)=very_warm,_131635),
     user:holdsFor(internal_temperature(_131565,_131566)=very_cold,_131650),
     user:union_all([_131575,_131590,_131605,_131620,_131635,_131650],_131548).

holdsForSDFluent(driver_comfort(_131565,_131566)=reducing,_131548) :-
     user:holdsFor(driving_style(_131565,_131566)=uncomfortable,_131575),
     user:holdsFor(driving_style(_131565,_131566)=unsafe,_131590),
     user:holdsFor(noise_level(_131565,_131566)=high,_131605),
     user:holdsFor(internal_temperature(_131565,_131566)=very_warm,_131620),
     user:holdsFor(internal_temperature(_131565,_131566)=very_cold,_131635),
     user:union_all([_131575,_131590,_131605,_131620,_131635],_131548).

holdsForSDFluent(passenger_satisfaction(_131565,_131566)=reducing,_131548) :-
     user:holdsFor(punctuality(_131565,_131566)=non_punctual,_131575),
     user:holdsFor(passenger_comfort(_131565,_131566)=reducing,_131590),
     user:union_all([_131575,_131590],_131548).

happensAtEv(punctuality_change(_131559,_131560,punctual),_131548) :-
     user:happensAt(end(punctuality(_131559,_131560)=non_punctual),_131548).

happensAtEv(punctuality_change(_131559,_131560,non_punctual),_131548) :-
     user:happensAt(end(punctuality(_131559,_131560)=punctual),_131548).

cachingOrder2(_131547, punctuality(_131547,_131548)=punctual) :-
     user:vehicle(_131547,_131548).

cachingOrder2(_131547, punctuality(_131547,_131548)=non_punctual) :-
     user:vehicle(_131547,_131548).

cachingOrder2(_131544, punctuality_change(_131544,_131545,punctual)) :-
     user:vehicle(_131544,_131545).

cachingOrder2(_131544, punctuality_change(_131544,_131545,non_punctual)) :-
     user:vehicle(_131544,_131545).

cachingOrder2(_131547, passenger_density(_131547,_131548)=high) :-
     user:vehicle(_131547,_131548).

cachingOrder2(_131547, noise_level(_131547,_131548)=high) :-
     user:vehicle(_131547,_131548).

cachingOrder2(_131547, internal_temperature(_131547,_131548)=very_warm) :-
     user:vehicle(_131547,_131548).

cachingOrder2(_131547, internal_temperature(_131547,_131548)=very_cold) :-
     user:vehicle(_131547,_131548).

cachingOrder2(_131547, driving_style(_131547,_131548)=unsafe) :-
     user:vehicle(_131547,_131548).

cachingOrder2(_131547, driving_style(_131547,_131548)=uncomfortable) :-
     user:vehicle(_131547,_131548).

cachingOrder2(_131547, driving_quality(_131547,_131548)=high) :-
     user:vehicle(_131547,_131548).

cachingOrder2(_131547, driving_quality(_131547,_131548)=medium) :-
     user:vehicle(_131547,_131548).

cachingOrder2(_131547, driving_quality(_131547,_131548)=low) :-
     user:vehicle(_131547,_131548).

cachingOrder2(_131547, passenger_comfort(_131547,_131548)=reducing) :-
     user:vehicle(_131547,_131548).

cachingOrder2(_131547, driver_comfort(_131547,_131548)=reducing) :-
     user:vehicle(_131547,_131548).

cachingOrder2(_131547, passenger_satisfaction(_131547,_131548)=reducing) :-
     user:vehicle(_131547,_131548).

collectIntervals2(_131547, abrupt_acceleration(_131547,_131548)=abrupt) :-
     user:vehicle(_131547,_131548).

collectIntervals2(_131547, abrupt_acceleration(_131547,_131548)=very_abrupt) :-
     user:vehicle(_131547,_131548).

collectIntervals2(_131547, abrupt_deceleration(_131547,_131548)=abrupt) :-
     user:vehicle(_131547,_131548).

collectIntervals2(_131547, abrupt_deceleration(_131547,_131548)=very_abrupt) :-
     user:vehicle(_131547,_131548).

collectIntervals2(_131547, sharp_turn(_131547,_131548)=sharp) :-
     user:vehicle(_131547,_131548).

collectIntervals2(_131547, sharp_turn(_131547,_131548)=very_sharp) :-
     user:vehicle(_131547,_131548).
