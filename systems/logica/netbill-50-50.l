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

happensAt(event:"presentQuote", merchant:30, consumer:5, goods:"book", t:5);
happensAt(event:"presentQuote", merchant:40, consumer:1, goods:"book", t:5);
happensAt(event:"acceptQuote", consumer:1, merchant:10, goods:"book", t:5);
happensAt(event:"acceptQuote", consumer:4, merchant:20, goods:"book", t:5);
happensAt(event:"acceptQuote", consumer:1, merchant:30, goods:"book", t:5);
happensAt(event:"acceptQuote", consumer:1, merchant:40, goods:"book", t:5);
happensAt(event:"acceptQuote", consumer:5, merchant:40, goods:"book", t:5);
happensAt(event:"presentQuote", merchant:10, consumer:7, goods:"book", t:15);
happensAt(event:"presentQuote", merchant:30, consumer:5, goods:"book", t:15);
happensAt(event:"acceptQuote", consumer:2, merchant:20, goods:"book", t:15);
happensAt(event:"acceptQuote", consumer:7, merchant:20, goods:"book", t:15);
happensAt(event:"acceptQuote", consumer:2, merchant:30, goods:"book", t:15);
happensAt(event:"acceptQuote", consumer:2, merchant:40, goods:"book", t:15);
happensAt(event:"acceptQuote", consumer:5, merchant:50, goods:"book", t:15);
happensAt(event:"presentQuote", merchant:10, consumer:1, goods:"book", t:25);
happensAt(event:"presentQuote", merchant:20, consumer:4, goods:"book", t:25);
happensAt(event:"presentQuote", merchant:30, consumer:7, goods:"book", t:25);
happensAt(event:"acceptQuote", consumer:1, merchant:30, goods:"book", t:25);
happensAt(event:"acceptQuote", consumer:5, merchant:30, goods:"book", t:25);
happensAt(event:"acceptQuote", consumer:7, merchant:30, goods:"book", t:25);
happensAt(event:"acceptQuote", consumer:2, merchant:40, goods:"book", t:25);
happensAt(event:"presentQuote", merchant:10, consumer:1, goods:"book", t:35);
happensAt(event:"presentQuote", merchant:10, consumer:5, goods:"book", t:35);
happensAt(event:"presentQuote", merchant:10, consumer:7, goods:"book", t:35);
happensAt(event:"presentQuote", merchant:20, consumer:1, goods:"book", t:35);
happensAt(event:"presentQuote", merchant:20, consumer:7, goods:"book", t:35);
happensAt(event:"presentQuote", merchant:30, consumer:4, goods:"book", t:35);
happensAt(event:"presentQuote", merchant:30, consumer:5, goods:"book", t:35);
happensAt(event:"presentQuote", merchant:40, consumer:1, goods:"book", t:35);
happensAt(event:"presentQuote", merchant:50, consumer:4, goods:"book", t:35);
happensAt(event:"acceptQuote", consumer:1, merchant:20, goods:"book", t:35);
happensAt(event:"acceptQuote", consumer:7, merchant:30, goods:"book", t:35);
happensAt(event:"acceptQuote", consumer:1, merchant:40, goods:"book", t:35);
happensAt(event:"acceptQuote", consumer:1, merchant:50, goods:"book", t:35);
happensAt(event:"acceptQuote", consumer:2, merchant:50, goods:"book", t:35);
happensAt(event:"acceptQuote", consumer:4, merchant:50, goods:"book", t:35);
happensAt(event:"acceptQuote", consumer:5, merchant:50, goods:"book", t:35);
happensAt(event:"acceptQuote", consumer:7, merchant:50, goods:"book", t:35);
happensAt(event:"presentQuote", merchant:50, consumer:5, goods:"book", t:45);
happensAt(event:"acceptQuote", consumer:7, merchant:10, goods:"book", t:45);
happensAt(event:"acceptQuote", consumer:5, merchant:30, goods:"book", t:45);
happensAt(event:"acceptQuote", consumer:7, merchant:30, goods:"book", t:45);
happensAt(event:"acceptQuote", consumer:5, merchant:40, goods:"book", t:45);
