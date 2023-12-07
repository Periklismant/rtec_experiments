% -----------------------------------------------
% INPUT ENTITIES
% -----------------------------------------------

event(stop_enter(_,_,_,_)).				inputEntity(stop_enter(_,_,_,_)).			index(stop_enter(Id,_,_,_), 			Id).
event(stop_leave(_,_,_,_)).				inputEntity(stop_leave(_,_,_,_)).			index(stop_leave(Id,_,_,_), 			Id).

sDFluent(abrupt_acceleration(_,_)=abrupt).		inputEntity(abrupt_acceleration(_,_)=abrupt).		index(abrupt_acceleration(Id,_)=abrupt, 	Id).
sDFluent(abrupt_acceleration(_,_)=very_abrupt).		inputEntity(abrupt_acceleration(_,_)=very_abrupt).	index(abrupt_acceleration(Id,_)=very_abrupt, 	Id).
sDFluent(abrupt_deceleration(_,_)=abrupt).		inputEntity(abrupt_deceleration(_,_)=abrupt).		index(abrupt_deceleration(Id,_)=abrupt, 	Id).
sDFluent(abrupt_deceleration(_,_)=very_abrupt).		inputEntity(abrupt_deceleration(_,_)=very_abrupt).	index(abrupt_deceleration(Id,_)=very_abrupt, 	Id).
sDFluent(sharp_turn(_,_)=sharp).			inputEntity(sharp_turn(_,_)=sharp).			index(sharp_turn(Id,_)=sharp, 			Id).
sDFluent(sharp_turn(_,_)=very_sharp).			inputEntity(sharp_turn(_,_)=very_sharp).		index(sharp_turn(Id,_)=very_sharp, 		Id).

% -----------------------------------------------
% OUTPUT ENTITIES
% -----------------------------------------------

event(punctuality_change(_,_,punctual)).		outputEntity(punctuality_change(_,_,punctual)).		index(punctuality_change(Id,_,punctual),	Id).
event(punctuality_change(_,_,non_punctual)).		outputEntity(punctuality_change(_,_,non_punctual)).	index(punctuality_change(Id,_,non_punctual),	Id).

simpleFluent(punctuality(_,_)=punctual).    		outputEntity(punctuality(_,_)=punctual).    		index(punctuality(Id,_)=punctual, 		Id).

sDFluent(punctuality(_,_)=non_punctual). 	   	outputEntity(punctuality(_,_)=non_punctual).    	index(punctuality(Id,_)=non_punctual, 		Id).    
sDFluent(driving_style(_,_)=unsafe). 			outputEntity(driving_style(_,_)=unsafe). 		index(driving_style(Id,_)=unsafe, 		Id). 
sDFluent(driving_style(_,_)=uncomfortable). 		outputEntity(driving_style(_,_)=uncomfortable). 	index(driving_style(Id,_)=uncomfortable, 	Id).

% -----------------------------------------------
% COLLECT INTERVALS
% -----------------------------------------------

collectIntervals(abrupt_acceleration(_,_)=abrupt).
collectIntervals(abrupt_acceleration(_,_)=very_abrupt).
collectIntervals(abrupt_deceleration(_,_)=abrupt).
collectIntervals(abrupt_deceleration(_,_)=very_abrupt).
collectIntervals(sharp_turn(_,_)=sharp).
collectIntervals(sharp_turn(_,_)=very_sharp).

% -----------------------------------------------
% GROUNDING
% -----------------------------------------------

grounding(abrupt_acceleration(Id,VehicleType)=abrupt) 		:- vehicle(Id, VehicleType). 
grounding(abrupt_acceleration(Id,VehicleType)=very_abrupt) 	:- vehicle(Id, VehicleType). 
grounding(abrupt_deceleration(Id,VehicleType)=abrupt) 		:- vehicle(Id, VehicleType). 
grounding(abrupt_deceleration(Id,VehicleType)=very_abrupt) 	:- vehicle(Id, VehicleType). 
grounding(sharp_turn(Id,VehicleType)=sharp) 			:- vehicle(Id, VehicleType). 
grounding(sharp_turn(Id,VehicleType)=very_sharp) 		:- vehicle(Id, VehicleType).
grounding(punctuality(Id,VehicleType)=punctual) 		:- vehicle(Id, VehicleType).   
grounding(punctuality(Id,VehicleType)=non_punctual) 		:- vehicle(Id, VehicleType).
grounding(punctuality_change(Id,VehicleType,punctual)) 		:- vehicle(Id, VehicleType).
grounding(punctuality_change(Id,VehicleType,non_punctual)) 	:- vehicle(Id, VehicleType).
grounding(driving_style(Id,VehicleType)=unsafe) 		:- vehicle(Id, VehicleType).
grounding(driving_style(Id,VehicleType)=uncomfortable) 		:- vehicle(Id, VehicleType).

% -----------------------------------------------
% CACHING ORDER
% -----------------------------------------------

cachingOrder(punctuality(_,_)=punctual).    
cachingOrder(punctuality(_,_)=non_punctual).
cachingOrder(driving_style(_,_)=unsafe). 
cachingOrder(driving_style(_,_)=uncomfortable).
cachingOrder(punctuality_change(_,_,punctual)).
cachingOrder(punctuality_change(_,_,non_punctual)).

