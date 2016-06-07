%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE          : RT0D-1.pro
% LAST REVISION : 2005-03-22
% SUBJECT       : RT_0^D example using Li/Mitchell's predicate.
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

% B.r1 <- Alice
forRole(alice, alice, b, r1).

% Alice.r2 <- Carol
forRole(carol, carol, alice, r2).

% B.r3 <- B.r1
forRole(X, Name, b, r3) :- forRole(X, Name, b, r1).

% B.r3 <- B.r1.r2
forRole(X, Name, b, r3) :-
	forRole(Z, Z, b, r1),
	forRole(X, Name, Z, r2).


% Alice --(Alice as B.r1)--> Darryl
forRole(darryl, alice, b, r1) :- forRole(alice, alice, b, r1).

% Darryl --(Alice as B.r1)--> Eric
forRole(eric, alice, b, r1) :- forRole(darryl, alice, b, r1).


% Can Eric take an action requiring role b.r3 using "Alice as B.r1"?
forRole(requestID, alice, b, r1) :- forRole(eric, alice, b, r1).
%
% forRole(requestID, X, b, r1).
% "yes"
