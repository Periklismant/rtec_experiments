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

happensAt(event:"presentQuote", merchant:0, consumer:1, goods:"book", t:1);
happensAt(event:"presentQuote", merchant:0, consumer:4, goods:"book", t:1);
happensAt(event:"presentQuote", merchant:0, consumer:2, goods:"book", t:1);
happensAt(event:"presentQuote", merchant:0, consumer:8, goods:"book", t:1);
happensAt(event:"presentQuote", merchant:0, consumer:4, goods:"book", t:1);
happensAt(event:"presentQuote", merchant:0, consumer:9, goods:"book", t:1);
happensAt(event:"presentQuote", merchant:9, consumer:2, goods:"book", t:1);
happensAt(event:"acceptQuote", consumer:7, merchant:0, goods:"book", t:6);
happensAt(event:"acceptQuote", consumer:5, merchant:0, goods:"book", t:6);
happensAt(event:"acceptQuote", consumer:1, merchant:0, goods:"book", t:6);
happensAt(event:"acceptQuote", consumer:2, merchant:0, goods:"book", t:6);
happensAt(event:"acceptQuote", consumer:2, merchant:0, goods:"book", t:6);
happensAt(event:"acceptQuote", consumer:5, merchant:0, goods:"book", t:6);
happensAt(event:"acceptQuote", consumer:1, merchant:0, goods:"book", t:6);
happensAt(event:"acceptQuote", consumer:5, merchant:0, goods:"book", t:6);
happensAt(event:"acceptQuote", consumer:1, merchant:0, goods:"book", t:6);
happensAt(event:"acceptQuote", consumer:4, merchant:0, goods:"book", t:6);
happensAt(event:"acceptQuote", consumer:4, merchant:0, goods:"book", t:6);
happensAt(event:"acceptQuote", consumer:1, merchant:0, goods:"book", t:6);
happensAt(event:"acceptQuote", consumer:9, merchant:0, goods:"book", t:6);
happensAt(event:"presentQuote", merchant:0, consumer:7, goods:"book", t:11);
happensAt(event:"presentQuote", merchant:0, consumer:7, goods:"book", t:11);
happensAt(event:"presentQuote", merchant:0, consumer:7, goods:"book", t:11);
happensAt(event:"presentQuote", merchant:0, consumer:1, goods:"book", t:11);
happensAt(event:"presentQuote", merchant:0, consumer:8, goods:"book", t:11);
happensAt(event:"presentQuote", merchant:0, consumer:9, goods:"book", t:11);
happensAt(event:"presentQuote", merchant:9, consumer:5, goods:"book", t:11);
happensAt(event:"acceptQuote", consumer:5, merchant:0, goods:"book", t:16);
happensAt(event:"acceptQuote", consumer:2, merchant:0, goods:"book", t:16);
happensAt(event:"acceptQuote", consumer:5, merchant:0, goods:"book", t:16);
happensAt(event:"acceptQuote", consumer:4, merchant:0, goods:"book", t:16);
happensAt(event:"acceptQuote", consumer:7, merchant:0, goods:"book", t:16);
happensAt(event:"acceptQuote", consumer:4, merchant:0, goods:"book", t:16);
happensAt(event:"acceptQuote", consumer:4, merchant:0, goods:"book", t:16);
happensAt(event:"acceptQuote", consumer:1, merchant:0, goods:"book", t:16);
happensAt(event:"acceptQuote", consumer:8, merchant:0, goods:"book", t:16);
happensAt(event:"acceptQuote", consumer:5, merchant:0, goods:"book", t:16);
happensAt(event:"acceptQuote", consumer:2, merchant:0, goods:"book", t:16);
happensAt(event:"acceptQuote", consumer:4, merchant:0, goods:"book", t:16);
happensAt(event:"acceptQuote", consumer:6, merchant:0, goods:"book", t:16);
happensAt(event:"presentQuote", merchant:0, consumer:4, goods:"book", t:21);
happensAt(event:"presentQuote", merchant:0, consumer:4, goods:"book", t:21);
happensAt(event:"presentQuote", merchant:0, consumer:4, goods:"book", t:21);
happensAt(event:"presentQuote", merchant:0, consumer:4, goods:"book", t:21);
happensAt(event:"presentQuote", merchant:0, consumer:8, goods:"book", t:21);
happensAt(event:"presentQuote", merchant:0, consumer:9, goods:"book", t:21);
happensAt(event:"presentQuote", merchant:3, consumer:4, goods:"book", t:21);
happensAt(event:"acceptQuote", consumer:7, merchant:0, goods:"book", t:26);
happensAt(event:"acceptQuote", consumer:4, merchant:0, goods:"book", t:26);
happensAt(event:"acceptQuote", consumer:4, merchant:0, goods:"book", t:26);
happensAt(event:"acceptQuote", consumer:8, merchant:0, goods:"book", t:26);
happensAt(event:"acceptQuote", consumer:4, merchant:0, goods:"book", t:26);
happensAt(event:"acceptQuote", consumer:2, merchant:0, goods:"book", t:26);
happensAt(event:"acceptQuote", consumer:4, merchant:0, goods:"book", t:26);
happensAt(event:"acceptQuote", consumer:4, merchant:0, goods:"book", t:26);
happensAt(event:"acceptQuote", consumer:7, merchant:0, goods:"book", t:26);
happensAt(event:"acceptQuote", consumer:5, merchant:0, goods:"book", t:26);
happensAt(event:"acceptQuote", consumer:8, merchant:0, goods:"book", t:26);
happensAt(event:"acceptQuote", consumer:1, merchant:0, goods:"book", t:26);
happensAt(event:"acceptQuote", consumer:9, merchant:0, goods:"book", t:26);
happensAt(event:"presentQuote", merchant:0, consumer:2, goods:"book", t:31);
happensAt(event:"presentQuote", merchant:0, consumer:1, goods:"book", t:31);
happensAt(event:"presentQuote", merchant:0, consumer:8, goods:"book", t:31);
happensAt(event:"presentQuote", merchant:0, consumer:7, goods:"book", t:31);
happensAt(event:"presentQuote", merchant:0, consumer:7, goods:"book", t:31);
happensAt(event:"presentQuote", merchant:0, consumer:9, goods:"book", t:31);
happensAt(event:"presentQuote", merchant:3, consumer:7, goods:"book", t:31);
happensAt(event:"acceptQuote", consumer:4, merchant:0, goods:"book", t:36);
happensAt(event:"acceptQuote", consumer:4, merchant:0, goods:"book", t:36);
happensAt(event:"acceptQuote", consumer:4, merchant:0, goods:"book", t:36);
happensAt(event:"acceptQuote", consumer:4, merchant:0, goods:"book", t:36);
happensAt(event:"acceptQuote", consumer:4, merchant:0, goods:"book", t:36);
happensAt(event:"acceptQuote", consumer:2, merchant:0, goods:"book", t:36);
happensAt(event:"acceptQuote", consumer:2, merchant:0, goods:"book", t:36);
happensAt(event:"acceptQuote", consumer:1, merchant:0, goods:"book", t:36);
happensAt(event:"acceptQuote", consumer:1, merchant:0, goods:"book", t:36);
happensAt(event:"acceptQuote", consumer:2, merchant:0, goods:"book", t:36);
happensAt(event:"acceptQuote", consumer:5, merchant:0, goods:"book", t:36);
happensAt(event:"acceptQuote", consumer:2, merchant:0, goods:"book", t:36);
happensAt(event:"acceptQuote", consumer:6, merchant:0, goods:"book", t:36);
happensAt(event:"presentQuote", merchant:0, consumer:1, goods:"book", t:41);
happensAt(event:"presentQuote", merchant:0, consumer:4, goods:"book", t:41);
happensAt(event:"presentQuote", merchant:0, consumer:7, goods:"book", t:41);
happensAt(event:"presentQuote", merchant:0, consumer:2, goods:"book", t:41);
happensAt(event:"presentQuote", merchant:0, consumer:2, goods:"book", t:41);
happensAt(event:"presentQuote", merchant:0, consumer:3, goods:"book", t:41);
happensAt(event:"presentQuote", merchant:6, consumer:5, goods:"book", t:41);
happensAt(event:"acceptQuote", consumer:2, merchant:0, goods:"book", t:46);
happensAt(event:"acceptQuote", consumer:4, merchant:0, goods:"book", t:46);
happensAt(event:"acceptQuote", consumer:5, merchant:0, goods:"book", t:46);
happensAt(event:"acceptQuote", consumer:4, merchant:0, goods:"book", t:46);
happensAt(event:"acceptQuote", consumer:4, merchant:0, goods:"book", t:46);
happensAt(event:"acceptQuote", consumer:5, merchant:0, goods:"book", t:46);
happensAt(event:"acceptQuote", consumer:4, merchant:0, goods:"book", t:46);
happensAt(event:"acceptQuote", consumer:1, merchant:0, goods:"book", t:46);
happensAt(event:"acceptQuote", consumer:5, merchant:0, goods:"book", t:46);
happensAt(event:"acceptQuote", consumer:7, merchant:0, goods:"book", t:46);
happensAt(event:"acceptQuote", consumer:7, merchant:0, goods:"book", t:46);
happensAt(event:"acceptQuote", consumer:7, merchant:0, goods:"book", t:46);
happensAt(event:"acceptQuote", consumer:6, merchant:0, goods:"book", t:46);
