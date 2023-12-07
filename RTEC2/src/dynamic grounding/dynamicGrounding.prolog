
% ordered lists and set operations
:-use_module(library(ordsets)).

% dynamicGrounding(+Ts,+Te)
% perform dynamic grounding in (Ts,Te]
dynamicGrounding(_Ts,_Te) :-
	noDynamicGrounding, !.

dynamicGrounding(Ts,Te) :-
    % fetch groundTermOverlapThreshold from db
    groundTermOverlapThreshold(OverlapThreshold),
	% collectGrounds is defined in the declarations 
    forall(collectGrounds(InputEvents,GroundTerm),(
        %write(GroundTerm), nl,
        % all old terms 
        findall(GroundTerm,GroundTerm,AllOldTermsDup),
        % convert to set, ie remove duplicates and order
        list_to_ord_set(AllOldTermsDup,AllOldTerms),

        % old terms that remain
        % find the terms that should remain, ie the ones starting in the previous window and have open intervals
        findRemainingTerms(GroundTerm,RemainingTermsDup),
        list_to_ord_set(RemainingTermsDup,RemainingTerms),

        % terms from input events from current window
        findInputTerms(InputEvents,GroundTerm,Ts,Te,[],InputTermsDup),
        list_to_ord_set(InputTermsDup,InputTerms),

        % All terms required for the next window(AllNewTerms)
        ord_union(RemainingTerms,InputTerms,AllNewTerms,_),
        % CommonTerms is the intersection of AllNewTerms and AllOldTerms
        % TermsToRetract is AllOldTerms - AllNewTerms
        ord_intersection(AllNewTerms, AllOldTerms, CommonTerms, TermsToRetract), % ord_union to find TermsToRetract is redundant now.
        % NewTermsToAdd is AllNewTerms - AllOldTerms
        ord_union(AllOldTerms,AllNewTerms,_,NewTermsToAdd), 

        % Number of CommonTerms and AllOldTerms. 
        length(CommonTerms, CommonTermsNo),
        length(AllOldTerms, OldTermsNo),

            updateVariable(dgold_number, OldTermsNo),
            length(InputTerms, InputTermsNo),
        %write('Input Terms No: '), write(InputTermsNo), nl,
            updateVariable(dginp_number, InputTermsNo),
            length(RemainingTerms, RemainingTermsNo),
        %write('Remaining Terms No: '), write(RemainingTermsNo), nl,
            updateVariable(dgrem_number, RemainingTermsNo),
            length(TermsToRetract, TermsToRetractNo),
        %write('Terms To Retract No: '), write(TermsToRetract), nl,
            updateVariable(dgrm_number, TermsToRetractNo),
            length(NewTermsToAdd, NewTermsToAddNo),
        %write('New Terms To Add No: '), write(NewTermsToAdd), nl,
            updateVariable(dgadd_number, NewTermsToAddNo),



        CommonTermsNoThreshold is OverlapThreshold*OldTermsNo,
        (   
            % If number of common terms> number of old terms * threshold ratio, then do not retract-assert the terms in the intersection.
            % retract_grouding retracts the terms of a list one by one.  
            CommonTermsNo>CommonTermsNoThreshold,
            %write('Dynamic Grounding: Retract one by one...'), nl,
                getCPUtime(Time1Retract),
            retract_grounding(TermsToRetract),
                getCPUtime(Time2Retract),
                updateTime(dg_retract_time, Time1Retract, Time2Retract),  
            assert_grounding(NewTermsToAdd)
            ;
            % Else, the number of common terms is not greater than the threshold number of terms, then retract all old terms and assert all new terms.
            % This method may decrease computational cost, because retractall is much faster compared it many single retracts. 
            CommonTermsNo=<CommonTermsNoThreshold,
            %write('Dynamic Grounding: Retractall...'), nl,
                getCPUtime(Time1Retract),
            retractall(GroundTerm), 
                getCPUtime(Time2Retract),
                updateTime(dg_retract_time, Time1Retract, Time2Retract),  
            assert_grounding(AllNewTerms)
        )
    )),
        getCPUtime(Time1Remove),
    removeOutdated,
        getCPUtime(Time2Remove),
        updateTime(dg_remove_outdated_time, Time1Remove, Time2Remove).


% findInputTerms(+InputEvents,+GroundTerm,+Ts,+Te,+OldTerms,-NewTerms).
findInputTerms([],_,_,_,Terms,Terms).
findInputTerms([Event|Other],GroundTerm,Ts,Te,OldTerms,NewTerms):-
    event(Event),
    findall(GroundTerm,(happensAtIE(Event,T),T>Ts,T=<Te),CurrentTerms),
    append(OldTerms,CurrentTerms,TermsSoFar),
    findInputTerms(Other,GroundTerm,Ts,Te,TermsSoFar,NewTerms).
findInputTerms([Event|Other],GroundTerm,Ts,Te,OldTerms,NewTerms):-
    sDFluent(Event),
%    findall(GroundTerm,(index(Event,Index),holdsForProcessedIE(Index,Event,_)),CurrentTerms),
    findall(GroundTerm,(holdsForIESI(Event,_)),CurrentTerms),
    append(OldTerms,CurrentTerms,TermsSoFar),
    findInputTerms(Other,GroundTerm,Ts,Te,TermsSoFar,NewTerms).


% findRemainingTerms(+GroundTerm, -RemainingTerms)
% find terms that should remain
findRemainingTerms(GroundTerm,RemainingTerms):-
    findall((Event,GroundTerm),dgrounded(Event,GroundTerm),Events),
    findRemainingTerms(Events,[],RemainingTerms).

findRemainingTerms([],Terms,Terms).
findRemainingTerms([(Event,GroundTerm)|Other],OldTerms,NewTerms):-
    % check the corresponding lists for open intervals
    % if there are the term must stay
    findall(GroundTerm, (
                            index(Event,I),
                            (
				(sDFluent(Event),
				 outputEntity(Event),
                                 sdFPList(I,Event,L,_))
                                 %fetchKey(Event, Key),
                                 %recorded(Key, sdFPList(Event, L, _), _))
                                ;
				(simpleFluent(Event), 
                                simpleFPList(I,Event,L,_))
                                %fetchKey(Event, Key),
                                %recorded(Key, simpleFPList(Event,L,_), _))
				                ;
				(sDFluent(Event),
				 inputEntity(Event),
                		 iePList(I,Event,L,_))
                            ),
                            L\=[],
                            append(_,[(_,inf)],L)
                        ),
            CurrentTerms),
    append(OldTerms,CurrentTerms,TermsSoFar),
    findRemainingTerms(Other,TermsSoFar,NewTerms).

removeOutdated:-
    % find all fluent value pairs whose arguments are dynamic-grounded in this window.
    % FVPs who had a open interval are not retracted because they were dynamic-grounded in this window by findRemainingTerms.
    %findall((Index, F=V), simpleFPList(Index, F=V, RestrictedList, Extension), AllSimpleFluentList),
    findall((Index, F=V), (simpleFPList(Index, F=V, RestrictedList, Extension), \+cachingOrder2(Index, F=V), 
                           retract(simpleFPList(Index, F=V, RestrictedList, Extension))), SimpleFluentList),
    %
    findall((Index, F=V), (sdFPList(Index, F=V, RestrictedList, Extension), \+cachingOrder2(Index, F=V), 
                           retract(sdFPList(Index, F=V, RestrictedList, Extension))), _SDFluentList), 
    %
    findall((Index, F=V), (iePList(Index, F=V, RestrictedList, Extension), \+cachingOrder2(Index, F=V), 
                           retract(iePList(Index, F=V, RestrictedList, Extension))), _InputSDFluentList),

    %length(AllSimpleFluentList, ASFLLen),
    %updateVariable(dg_all_sf_number, ASFLLen),
    length(SimpleFluentList, SFLLen), 
    updateVariable(dg_outdated_sf_number,SFLLen).
    %write('Number of simpleFPLists Before: '), write(ASFLLen), nl,
    %write('Number of deleted simpleFPLists: '), write(SFLLen), nl.

% assert_grounding(+Term)
assert_grounding([]).
assert_grounding([Term|Other]):-
    assert(Term),
    assert_grounding(Other).


% retract_grounding(+Term)
retract_grounding([]).
retract_grounding([Term|Other]):-
    retract(Term),
    retract_grounding(Other).
