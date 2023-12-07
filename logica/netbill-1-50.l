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

happensAt(event:"presentQuote", merchant:10, consumer:10, goods:"book", t:1);
happensAt(event:"acceptQuote", consumer:10, merchant:10, goods:"book", t:6);
happensAt(event:"acceptQuote", consumer:10, merchant:10, goods:"book", t:16);
happensAt(event:"presentQuote", merchant:10, consumer:10, goods:"book", t:31);
happensAt(event:"acceptQuote", consumer:10, merchant:10, goods:"book", t:36);
happensAt(event:"presentQuote", merchant:10, consumer:10, goods:"book", t:41);
happensAt(event:"acceptQuote", consumer:10, merchant:10, goods:"book", t:46);
