
:-['toy_event_stream.prolog'].
:-['RTEC.prolog'].
:-['toy_var_domain.prolog'].
:-['toy_declarations.prolog'].
:-['toy_rules_compiled.prolog'].

performER :-
	initialiseRecognition(ordered, nopreprocessing, 1),
	updateSDE(story, 9, 21),
	eventRecognition(21, 21).
