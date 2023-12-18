test:-
	update([happens(presentQuote(3,8,book),1),happens(presentQuote(1,9,book),2),happens(presentQuote(9,6,book),3),happens(acceptQuote(4,1,book),4),happens(presentQuote(4,3,book),5),happens(presentQuote(5,3,book),6),happens(presentQuote(7,9,book),7),happens(acceptQuote(2,8,book),8),happens(acceptQuote(7,8,book),9),happens(acceptQuote(1,5,book),10),happens(acceptQuote(2,8,book),11),happens(acceptQuote(2,6,book),12),happens(presentQuote(6,5,book),13),happens(acceptQuote(1,4,book),14),happens(presentQuote(3,3,book),15),happens(presentQuote(7,9,book),16),happens(presentQuote(7,7,book),17),happens(presentQuote(4,3,book),18),happens(presentQuote(3,4,book),19),happens(presentQuote(7,2,book),20),happens(presentQuote(6,8,book),21),happens(presentQuote(4,9,book),22),happens(presentQuote(1,9,book),23),happens(presentQuote(9,2,book),24),happens(presentQuote(9,4,book),25),happens(presentQuote(9,6,book),26),happens(acceptQuote(2,4,book),27),happens(acceptQuote(8,5,book),28),happens(presentQuote(2,7,book),29),happens(acceptQuote(4,5,book),30),happens(presentQuote(5,4,book),31),happens(presentQuote(2,2,book),32),happens(presentQuote(9,6,book),33),happens(presentQuote(9,5,book),34),happens(presentQuote(7,7,book),35),happens(acceptQuote(2,6,book),36),happens(acceptQuote(8,5,book),37),happens(acceptQuote(6,4,book),38),happens(acceptQuote(1,2,book),39),happens(acceptQuote(8,3,book),40),happens(presentQuote(4,8,book),41),happens(presentQuote(8,5,book),42),happens(presentQuote(6,7,book),43),happens(presentQuote(8,7,book),44),happens(acceptQuote(6,2,book),45),happens(acceptQuote(4,1,book),46),happens(acceptQuote(7,8,book),47),happens(presentQuote(2,7,book),48),happens(presentQuote(5,9,book),49),happens(presentQuote(8,1,book),50),happens(acceptQuote(3,2,book),51),happens(acceptQuote(5,4,book),52),happens(acceptQuote(7,9,book),53),happens(acceptQuote(7,5,book),54),happens(acceptQuote(3,5,book),55),happens(presentQuote(4,2,book),56),happens(presentQuote(6,3,book),57),happens(presentQuote(2,2,book),58),happens(acceptQuote(4,1,book),59),happens(presentQuote(4,2,book),60),happens(presentQuote(8,6,book),61),happens(acceptQuote(1,3,book),62),happens(acceptQuote(3,9,book),63),happens(presentQuote(8,6,book),64),happens(presentQuote(9,9,book),65),happens(presentQuote(4,1,book),66),happens(presentQuote(2,2,book),67),happens(acceptQuote(6,8,book),68),happens(presentQuote(1,8,book),69),happens(presentQuote(2,8,book),70),happens(acceptQuote(7,6,book),71),happens(acceptQuote(2,9,book),72),happens(presentQuote(5,9,book),73),happens(presentQuote(3,4,book),74),happens(presentQuote(7,8,book),75),happens(acceptQuote(2,7,book),76),happens(presentQuote(2,4,book),77),happens(presentQuote(8,9,book),78),happens(presentQuote(4,5,book),79),happens(acceptQuote(8,2,book),80)]),
	status.

merchant(2).
merchant(6).
merchant(1).
merchant(4).
merchant(3).
merchant(7).
merchant(8).
merchant(9).
merchant(5).
consumer(2).
consumer(1).
consumer(7).
consumer(4).
consumer(3).
consumer(6).
consumer(8).
consumer(9).
consumer(5).
goods(book).

initiates(presentQuote(M,C,GD), quote(M,C,GD), _):-
	merchant(M), consumer(C), goods(GD).

terminates(acceptQuote(M,C,GD), quote(M,C,GD), _):-
	merchant(M), consumer(C), goods(GD).
