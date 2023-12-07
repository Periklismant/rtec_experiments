/********************************** DECLARATIONS ***********************************
 - Declare the entities of the event description: events,simple and statically
   determined fluents.
 - For each entity state if it is input or output (simple fluents are by
   definition output entities).
 - For each input/output entity state its index.
 - For input entities/statically determined fluents state whether the intervals
   will be collected into a list or built from time-points.
 - Declare the groundings of the fluents and output entities/events.
 - Declare the order of caching of output entities.
 **********************************************************************************/
:- dynamic grounding/1.

event( topic( _,_ ) ).			
inputEntity( topic( _,_ ) ).			
index( topic( Id,_ ),Id ).

sDFluent( influence( _ )=high ).	
inputEntity( influence( _ )=high ).		
index( influence( Id )=high,Id ).

sDFluent( influence( _ )=medium ).	
inputEntity( influence( _ )=medium ).		
index( influence( Id )=medium,Id ).

sDFluent( influence( _ )=low ).		
inputEntity( influence( _ )=low ).		
index( influence( Id )=low,Id ).

sDFluent( hmInfluence( _ )=true ).	
outputEntity( hmInfluence( _ )=true ).		
index( hmInfluence( Id )=true,Id ).

simpleFluent( trust( _,_ )=true ).	
outputEntity( trust( _,_ )=true ).		
index( trust( Id,_ )=true,Id ).

% for input entities/statically determined fluents state whether 
% the intervals will be collected into a list or built from given time-points

collectIntervals( influence( _ )=high ).
collectIntervals( influence( _ )=medium ).
collectIntervals( influence( _ )=low ).

% define the groundings of the fluents and output entities/events

grounding( influence( Id )=high )		:- id( Id ).
grounding( influence( Id )=medium )		:- id( Id ).
grounding( influence( Id )=low )		:- id( Id ).
grounding( hmInfluence( Id )=true )		:- id( Id ).
grounding( trust( Id,Topic )=true )		:- pair( Id,Topic ).

% cachingOrder should be defined for all output entities

cachingOrder( hmInfluence( _ )=true ).
cachingOrder( trust( _,_ )=true ).
