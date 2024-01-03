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

isTimepoint(t) :- t in Range(80);

happensAt(event:"acceptQuote", consumer:3, merchant:4, goods:"book", t:1);
happensAt(event:"presentQuote", merchant:4, consumer:3, goods:"book", t:3);
happensAt(event:"acceptQuote", consumer:3, merchant:1, goods:"book", t:5);
happensAt(event:"presentQuote", merchant:4, consumer:2, goods:"book", t:7);
happensAt(event:"acceptQuote", consumer:3, merchant:2, goods:"book", t:9);
happensAt(event:"acceptQuote", consumer:1, merchant:2, goods:"book", t:11);
happensAt(event:"acceptQuote", consumer:4, merchant:1, goods:"book", t:13);
happensAt(event:"acceptQuote", consumer:3, merchant:1, goods:"book", t:15);
happensAt(event:"presentQuote", merchant:3, consumer:3, goods:"book", t:17);
happensAt(event:"acceptQuote", consumer:1, merchant:1, goods:"book", t:19);
