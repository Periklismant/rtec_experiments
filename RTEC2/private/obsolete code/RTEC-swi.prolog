

%%%%%%%%%% FOR SWI PROLOG:

% The predicates below may or may not appear in the declarations of an application;
% thus they must be declared dynamic; if they do not appear in the declarations, SWI will fail
%:- dynamic collectIntervals/1, collectIntervals2/2, buildFromPoints/1, buildFromPoints2/2, cyclic/1.

:- discontiguous updateSDE/4, happensAtProcessedIE/3, happensAtProcessedIE/3, happensAtProcessedSDFluent/3, event/1, inputEntity/1, index/2, outputEntity/1, simpleFluent/1, sDFluent/1, happensAtProcessedSimpleFluent/3, holdsForSDFluent/2, deadlines1/3, initiatedAt/2, terminatedAt/2, initiatedAt/4, terminatedAt/4, compileHoldsAtTree/3, findChildren/3, maxDuration/3, maxDurationUE/3. 

% updateSDE are application-specific predicates loading datasets
:- multifile holdsFor/2, initiatedAt/4, terminatedAt/4, maxDuration/3, updateSDE/2, updateSDE/3, updateSDE/4.

:- ['RTEC.prolog'].
