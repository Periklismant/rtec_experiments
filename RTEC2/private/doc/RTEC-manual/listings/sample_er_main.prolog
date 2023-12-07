:- ['RTEC.prolog'].					% RTEC ENGINE
:- ['sample_declarations.prolog'].			% ENTITY DECLARATIONS
:- ['sample_compiled_event_description.prolog'].	% COMPILED SET OF RULES
:- ['sample_event_stream.prolog'].			% EVENT NARRATIVE
:- ['sample_variable_domain.prolog'].			% VARIABLE/GROUNDING DOMAIN

performFullER :-
	initialiseRecognition( unordered,nopreprocessing,1 ),
	updateSDE( reveal_toy,1,3 ),
	eventRecognition( 3,3 ).
