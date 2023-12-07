% Information about all our events and fluents.
% - Is each entity an event or a fluent?
% - Is it an input or an output entity?
% - Choose an argument to be used as index for quicker access.

event(go_to(_,_)).	
inputEntity(go_to(_,_)).	
index(go_to(Person,_), Person).

event(lose_wallet(_)).	
inputEntity(lose_wallet(_)).	
index(lose_wallet(Person), Person).

event(win_lottery(_)).	
inputEntity(win_lottery(_)).	
index(win_lottery(Person), Person).

event(drinks(_,_)).	
inputEntity(drinks(_,_)).	
index(drinks(Person,_), Person).


simpleFluent(has_won_lottery(_)=true).	
outputEntity(has_won_lottery(_)=true).	
index(has_won_lottery(Person)=true, Person).

simpleFluent(has_won_lottery(_)=false).	
outputEntity(has_won_lottery(_)=false).	
index(has_won_lottery(Person)=false, Person).

simpleFluent(rich(_)=true).	
outputEntity(rich(_)=true).	
index(rich(Person)=true, Person).

simpleFluent(rich(_)=false).	
outputEntity(rich(_)=false).	
index(rich(Person)=false, Person).

simpleFluent(location(_)=home).	
outputEntity(location(_)=home).	
index(location(Person)=home, Person).

simpleFluent(location(_)=pub).	
outputEntity(location(_)=pub).	
index(location(Person)=pub, Person).

simpleFluent(location(_)=work).
outputEntity(location(_)=work).	
index(location(Person)=work, Person).

simpleFluent(drunk_alcohol(_)=true).	
outputEntity(drunk_alcohol(_)=true).	
index(drunk_alcohol(Person)=true, Person).

simpleFluent(drunk_alcohol(_)=false).	
outputEntity(drunk_alcohol(_)=false).	
index(drunk_alcohol(Person)=false, Person).

simpleFluent(drunk(_)=true).	
outputEntity(drunk(_)=true).	
index(drunk(Person)=true, Person).

simpleFluent(drunk(_)=false).	
outputEntity(drunk(_)=false).	
index(drunk(Person)=false, Person).

% How are the fluents grounded?
% Define the domain of the variables.

grounding(has_won_lottery(Person)=true) :- person(Person).
grounding(has_won_lottery(Person)=false) :- person(Person).
grounding(rich(Person)=true)      :- person(Person).
grounding(rich(Person)=false)     :- person(Person).
grounding(location(Person)=Place) :- person(Person), place(Place).
grounding(drunk_alcohol(Person)=true) :- person(Person).
grounding(drunk_alcohol(Person)=false) :- person(Person).
grounding(drunk(Person)=true) :- person(Person).
grounding(drunk(Person)=false) :- person(Person).

% In what order will the output entities be processed by RTEC?

cachingOrder(has_won_lottery(_)=true).
cachingOrder(has_won_lottery(_)=false).
cachingOrder(rich(_)=true).
cachingOrder(rich(_)=false).
cachingOrder(location(_)=home).
cachingOrder(location(_)=pub).
cachingOrder(location(_)=work).
cachingOrder(drunk_alcohol(_)=true).
cachingOrder(drunk_alcohol(_)=false).
cachingOrder(drunk(_)=true).
cachingOrder(drunk(_)=false).
