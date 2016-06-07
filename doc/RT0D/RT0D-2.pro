%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE          : RT0D-2.pro
% LAST REVISION : 2005-03-22
% SUBJECT       : RT_0^D example using the Li/Mitchell predicate.
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

% C.r2 <- Alice
forRole(alice, alice, c, r2).

% C.r2 <- Bob
forRole(bob, bob, c, r2).

% D.r3 <- C.r2
% forRole(X, Name, d, r3) :- forRole(X, Name, c, r2).

% D.r3 <- intersect(B.r1, C.r2)
forRole(X, Name, d, r3) :-
	forRole(X, Name, b, r1),
	forRole(X, Name, c, r2).


% Alice --(Alice as B.r1)--> Jill
forRole(jill, alice, b, r1) :- forRole(alice, alice, b, r1).

% Alice --(Alice as C.r2)--> Tom
forRole(tom, alice, c, r2) :- forRole(alice, alice, c, r2).

% Jill --(Alice as B.r1)--> John
forRole(john, alice, b, r1) :- forRole(jill, alice, b, r1).

% Tom --(Alice as C.r2)--> John
forRole(john, alice, c, r2) :- forRole(tom, alice, c, r2).

% Can John take an action requiring d.r3 using two activations?
forRole(requestID, alice, b, r1) :- forRole(john, alice, b, r1).
forRole(requestID, alice, c, r2) :- forRole(john, alice, c, r2).
%
% forRole(requestID, X, d, r3).
% "yes"

