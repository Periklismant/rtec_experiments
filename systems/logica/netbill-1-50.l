holdsAt(fluent:f, t:timepoint):-
	isTimepoint(timepoint),
	isTimepoint(timepoint2),
	initiatedAt(fluent:f, t:timepoint2),
	timepoint2<timepoint,
	~broken(fluent:f, ts:timepoint2, te:timepoint);

broken(fluent:f, ts:timepoint2, te:timepoint):-
	terminatedAt(fluent:f, t:timepoint3),
	timepoint2<timepoint3, 
	timepoint3<timepoint,
	isTimepoint(timepoint), isTimepoint(timepoint2);

initiatedAt(fluent:{fluentName:"quote", merchant:, consumer:, goods:}, t:) :-
	happensAt(event:"presentQuote", merchant: ,consumer:, goods:, t:);

terminatedAt(fluent:{fluentName:"quote", merchant:, consumer:, goods:}, t:) :-
	happensAt(event:"acceptQuote", consumer:, merchant:, goods:, t:);

isTimepoint(t) :- t in Range(50);

