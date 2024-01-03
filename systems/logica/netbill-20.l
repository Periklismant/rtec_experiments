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

happensAt(event:"presentQuote", merchant:4, consumer:2, goods:"book", t:1);
happensAt(event:"acceptQuote", consumer:2, merchant:1, goods:"book", t:2);
happensAt(event:"acceptQuote", consumer:2, merchant:1, goods:"book", t:3);
happensAt(event:"presentQuote", merchant:3, consumer:2, goods:"book", t:4);
happensAt(event:"presentQuote", merchant:3, consumer:3, goods:"book", t:5);
happensAt(event:"presentQuote", merchant:1, consumer:3, goods:"book", t:6);
happensAt(event:"acceptQuote", consumer:2, merchant:1, goods:"book", t:7);
happensAt(event:"acceptQuote", consumer:4, merchant:2, goods:"book", t:8);
happensAt(event:"presentQuote", merchant:1, consumer:3, goods:"book", t:9);
happensAt(event:"acceptQuote", consumer:2, merchant:1, goods:"book", t:10);
happensAt(event:"acceptQuote", consumer:1, merchant:4, goods:"book", t:11);
happensAt(event:"presentQuote", merchant:1, consumer:1, goods:"book", t:12);
happensAt(event:"presentQuote", merchant:2, consumer:1, goods:"book", t:13);
happensAt(event:"presentQuote", merchant:3, consumer:4, goods:"book", t:14);
happensAt(event:"acceptQuote", consumer:1, merchant:3, goods:"book", t:15);
happensAt(event:"acceptQuote", consumer:3, merchant:4, goods:"book", t:16);
happensAt(event:"acceptQuote", consumer:2, merchant:2, goods:"book", t:17);
happensAt(event:"presentQuote", merchant:2, consumer:3, goods:"book", t:18);
happensAt(event:"presentQuote", merchant:2, consumer:2, goods:"book", t:19);
happensAt(event:"presentQuote", merchant:3, consumer:1, goods:"book", t:20);
