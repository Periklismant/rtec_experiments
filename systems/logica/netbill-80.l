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

happensAt(event:"presentQuote", merchant:3, consumer:8, goods:"book", t:1);
happensAt(event:"presentQuote", merchant:1, consumer:9, goods:"book", t:2);
happensAt(event:"presentQuote", merchant:9, consumer:6, goods:"book", t:3);
happensAt(event:"acceptQuote", consumer:1, merchant:4, goods:"book", t:4);
happensAt(event:"presentQuote", merchant:4, consumer:3, goods:"book", t:5);
happensAt(event:"presentQuote", merchant:5, consumer:3, goods:"book", t:6);
happensAt(event:"presentQuote", merchant:7, consumer:9, goods:"book", t:7);
happensAt(event:"acceptQuote", consumer:8, merchant:2, goods:"book", t:8);
happensAt(event:"acceptQuote", consumer:8, merchant:7, goods:"book", t:9);
happensAt(event:"acceptQuote", consumer:5, merchant:1, goods:"book", t:10);
happensAt(event:"acceptQuote", consumer:8, merchant:2, goods:"book", t:11);
happensAt(event:"acceptQuote", consumer:6, merchant:2, goods:"book", t:12);
happensAt(event:"presentQuote", merchant:6, consumer:5, goods:"book", t:13);
happensAt(event:"acceptQuote", consumer:4, merchant:1, goods:"book", t:14);
happensAt(event:"presentQuote", merchant:3, consumer:3, goods:"book", t:15);
happensAt(event:"presentQuote", merchant:7, consumer:9, goods:"book", t:16);
happensAt(event:"presentQuote", merchant:7, consumer:7, goods:"book", t:17);
happensAt(event:"presentQuote", merchant:4, consumer:3, goods:"book", t:18);
happensAt(event:"presentQuote", merchant:3, consumer:4, goods:"book", t:19);
happensAt(event:"presentQuote", merchant:7, consumer:2, goods:"book", t:20);
happensAt(event:"presentQuote", merchant:6, consumer:8, goods:"book", t:21);
happensAt(event:"presentQuote", merchant:4, consumer:9, goods:"book", t:22);
happensAt(event:"presentQuote", merchant:1, consumer:9, goods:"book", t:23);
happensAt(event:"presentQuote", merchant:9, consumer:2, goods:"book", t:24);
happensAt(event:"presentQuote", merchant:9, consumer:4, goods:"book", t:25);
happensAt(event:"presentQuote", merchant:9, consumer:6, goods:"book", t:26);
happensAt(event:"acceptQuote", consumer:4, merchant:2, goods:"book", t:27);
happensAt(event:"acceptQuote", consumer:5, merchant:8, goods:"book", t:28);
happensAt(event:"presentQuote", merchant:2, consumer:7, goods:"book", t:29);
happensAt(event:"acceptQuote", consumer:5, merchant:4, goods:"book", t:30);
happensAt(event:"presentQuote", merchant:5, consumer:4, goods:"book", t:31);
happensAt(event:"presentQuote", merchant:2, consumer:2, goods:"book", t:32);
happensAt(event:"presentQuote", merchant:9, consumer:6, goods:"book", t:33);
happensAt(event:"presentQuote", merchant:9, consumer:5, goods:"book", t:34);
happensAt(event:"presentQuote", merchant:7, consumer:7, goods:"book", t:35);
happensAt(event:"acceptQuote", consumer:6, merchant:2, goods:"book", t:36);
happensAt(event:"acceptQuote", consumer:5, merchant:8, goods:"book", t:37);
happensAt(event:"acceptQuote", consumer:4, merchant:6, goods:"book", t:38);
happensAt(event:"acceptQuote", consumer:2, merchant:1, goods:"book", t:39);
happensAt(event:"acceptQuote", consumer:3, merchant:8, goods:"book", t:40);
happensAt(event:"presentQuote", merchant:4, consumer:8, goods:"book", t:41);
happensAt(event:"presentQuote", merchant:8, consumer:5, goods:"book", t:42);
happensAt(event:"presentQuote", merchant:6, consumer:7, goods:"book", t:43);
happensAt(event:"presentQuote", merchant:8, consumer:7, goods:"book", t:44);
happensAt(event:"acceptQuote", consumer:2, merchant:6, goods:"book", t:45);
happensAt(event:"acceptQuote", consumer:1, merchant:4, goods:"book", t:46);
happensAt(event:"acceptQuote", consumer:8, merchant:7, goods:"book", t:47);
happensAt(event:"presentQuote", merchant:2, consumer:7, goods:"book", t:48);
happensAt(event:"presentQuote", merchant:5, consumer:9, goods:"book", t:49);
happensAt(event:"presentQuote", merchant:8, consumer:1, goods:"book", t:50);
happensAt(event:"acceptQuote", consumer:2, merchant:3, goods:"book", t:51);
happensAt(event:"acceptQuote", consumer:4, merchant:5, goods:"book", t:52);
happensAt(event:"acceptQuote", consumer:9, merchant:7, goods:"book", t:53);
happensAt(event:"acceptQuote", consumer:5, merchant:7, goods:"book", t:54);
happensAt(event:"acceptQuote", consumer:5, merchant:3, goods:"book", t:55);
happensAt(event:"presentQuote", merchant:4, consumer:2, goods:"book", t:56);
happensAt(event:"presentQuote", merchant:6, consumer:3, goods:"book", t:57);
happensAt(event:"presentQuote", merchant:2, consumer:2, goods:"book", t:58);
happensAt(event:"acceptQuote", consumer:1, merchant:4, goods:"book", t:59);
happensAt(event:"presentQuote", merchant:4, consumer:2, goods:"book", t:60);
happensAt(event:"presentQuote", merchant:8, consumer:6, goods:"book", t:61);
happensAt(event:"acceptQuote", consumer:3, merchant:1, goods:"book", t:62);
happensAt(event:"acceptQuote", consumer:9, merchant:3, goods:"book", t:63);
happensAt(event:"presentQuote", merchant:8, consumer:6, goods:"book", t:64);
happensAt(event:"presentQuote", merchant:9, consumer:9, goods:"book", t:65);
happensAt(event:"presentQuote", merchant:4, consumer:1, goods:"book", t:66);
happensAt(event:"presentQuote", merchant:2, consumer:2, goods:"book", t:67);
happensAt(event:"acceptQuote", consumer:8, merchant:6, goods:"book", t:68);
happensAt(event:"presentQuote", merchant:1, consumer:8, goods:"book", t:69);
happensAt(event:"presentQuote", merchant:2, consumer:8, goods:"book", t:70);
happensAt(event:"acceptQuote", consumer:6, merchant:7, goods:"book", t:71);
happensAt(event:"acceptQuote", consumer:9, merchant:2, goods:"book", t:72);
happensAt(event:"presentQuote", merchant:5, consumer:9, goods:"book", t:73);
happensAt(event:"presentQuote", merchant:3, consumer:4, goods:"book", t:74);
happensAt(event:"presentQuote", merchant:7, consumer:8, goods:"book", t:75);
happensAt(event:"acceptQuote", consumer:7, merchant:2, goods:"book", t:76);
happensAt(event:"presentQuote", merchant:2, consumer:4, goods:"book", t:77);
happensAt(event:"presentQuote", merchant:8, consumer:9, goods:"book", t:78);
happensAt(event:"presentQuote", merchant:4, consumer:5, goods:"book", t:79);
happensAt(event:"acceptQuote", consumer:2, merchant:8, goods:"book", t:80);
