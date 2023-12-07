:- set_flag(all_dynamic, on). 

/* Narrative */


happens(request_floor(b3), 1).  
happens(request_floor(b2), 2).     
happens(assign_floor(b3), 3).  
happens(extend_assignment(b3), 4). 
%happens(request_floor(b1), 4).
%happens(revoke_floor, 6).
%happens(release_floor(b3), 8).

happens(release_floor(b1), 14).

happens(revoke_floor, 15).
