%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE          : RT0D-TbvExample.pro
% LAST REVISION : 2005-03-22
% SUBJECT       : RT_0^D example from TbV paper.
% PROGRAMMER    : (C) Copyright 2005 by Peter C. Chapin
%
% Please send comments or bug reports to
%
%      Peter C. Chapin
%      Department of Computer Science
%      University of Vermont
%      Burlington, VT 05405
%      pchapin@cs.uvm.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Credentials held by Joe.
forRole(joe, joe, mdb, doctor).

% Intermediate web service's policy.
forRole(Immediate, Entity, wsm, priv_1) :-
	forRole(Immediate, Entity, mdb, doctor).

% Medical database policy.
forRole(Immediate, Entity, mdb, priv_2) :-
	forRole(Immediate, Entity, mdb, doctor).

% Joe's request to WS_m (Joe also sends his credential).
forRole(priv_1-request, joe, mdb, doctor) :-
	forRole(joe, joe, mdb, doctor).
forRole(wsm, joe, mdb, doctor) :-
	forRole(joe, joe, mdb, doctor).

% WS_m's request to the database (WS_m also sends Joe's credential and
% the delegation certificate Joe sent to WS_m).
forRole(priv_2-request, joe, mdb, doctor) :-
	forRole(wsm, joe, mdb, doctor).

% Query:
%
% WS_m will honor request for priv_1 if
%   forRole(priv_1-request, Entity, wsm, priv_1).
%
% Medical database will honor request for priv_2 if
%   forRole(priv_2-request, Entity, mdb, priv_2).
%
