initially(punctuality(_131445,_131446)=punctual).

initiatedAt(punctuality(_131139,_131140)=punctual, _131149, _131124, _131151) :-
     happensAtIE(stop_enter(_131139,_131140,_131147,scheduled),_131124),
     _131149=<_131124,
     _131124<_131151.

initiatedAt(punctuality(_131139,_131140)=punctual, _131149, _131124, _131151) :-
     happensAtIE(stop_enter(_131139,_131140,_131147,early),_131124),
     _131149=<_131124,
     _131124<_131151.

initiatedAt(punctuality(_131139,_131140)=non_punctual, _131149, _131124, _131151) :-
     happensAtIE(stop_enter(_131139,_131140,_131147,late),_131124),
     _131149=<_131124,
     _131124<_131151.

initiatedAt(punctuality(_131139,_131140)=non_punctual, _131149, _131124, _131151) :-
     happensAtIE(stop_leave(_131139,_131140,_131147,early),_131124),
     _131149=<_131124,
     _131124<_131151.

holdsForSDFluent(punctuality(_131139,_131140)=non_punctual,_131124) :-
     holdsForProcessedSimpleFluent(_131139,punctuality(_131139,_131140)=punctual,_131146),
     complement_all([_131146],_131124).

holdsForSDFluent(driving_style(_131139,_131140)=unsafe,_131124) :-
     holdsForProcessedIE(_131139,sharp_turn(_131139,_131140)=very_sharp,_131146),
     holdsForProcessedIE(_131139,abrupt_acceleration(_131139,_131140)=very_abrupt,_131158),
     holdsForProcessedIE(_131139,abrupt_deceleration(_131139,_131140)=very_abrupt,_131170),
     union_all([_131146,_131158,_131170],_131124).

holdsForSDFluent(driving_style(_131139,_131140)=uncomfortable,_131124) :-
     holdsForProcessedIE(_131139,sharp_turn(_131139,_131140)=sharp,_131146),
     holdsForProcessedIE(_131139,abrupt_acceleration(_131139,_131140)=very_abrupt,_131158),
     holdsForProcessedIE(_131139,abrupt_deceleration(_131139,_131140)=very_abrupt,_131170),
     relative_complement_all(_131146,[_131158,_131170],_131183),
     holdsForProcessedIE(_131139,abrupt_acceleration(_131139,_131140)=abrupt,_131193),
     holdsForProcessedIE(_131139,abrupt_deceleration(_131139,_131140)=abrupt,_131205),
     union_all([_131183,_131193,_131205],_131124).

happensAtEv(punctuality_change(_131133,_131134,punctual),_131124) :-
     happensAtProcessedSDFluent(_131133,end(punctuality(_131133,_131134)=non_punctual),_131124).

happensAtEv(punctuality_change(_131133,_131134,non_punctual),_131124) :-
     happensAtProcessedSimpleFluent(_131133,end(punctuality(_131133,_131134)=punctual),_131124).

cachingOrder2(_131123, punctuality(_131123,_131124)=punctual) :-
     vehicle(_131123,_131124).

cachingOrder2(_131123, punctuality(_131123,_131124)=non_punctual) :-
     vehicle(_131123,_131124).

cachingOrder2(_131123, driving_style(_131123,_131124)=unsafe) :-
     vehicle(_131123,_131124).

cachingOrder2(_131123, driving_style(_131123,_131124)=uncomfortable) :-
     vehicle(_131123,_131124).

cachingOrder2(_131120, punctuality_change(_131120,_131121,punctual)) :-
     vehicle(_131120,_131121).

cachingOrder2(_131120, punctuality_change(_131120,_131121,non_punctual)) :-
     vehicle(_131120,_131121).

collectIntervals2(_131123, abrupt_acceleration(_131123,_131124)=abrupt) :-
     vehicle(_131123,_131124).

collectIntervals2(_131123, abrupt_acceleration(_131123,_131124)=very_abrupt) :-
     vehicle(_131123,_131124).

collectIntervals2(_131123, abrupt_deceleration(_131123,_131124)=abrupt) :-
     vehicle(_131123,_131124).

collectIntervals2(_131123, abrupt_deceleration(_131123,_131124)=very_abrupt) :-
     vehicle(_131123,_131124).

collectIntervals2(_131123, sharp_turn(_131123,_131124)=sharp) :-
     vehicle(_131123,_131124).

collectIntervals2(_131123, sharp_turn(_131123,_131124)=very_sharp) :-
     vehicle(_131123,_131124).

