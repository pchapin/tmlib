%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE          : RT0-Example.pro
% LAST REVISION : 2005-01-03
% SUBJECT       : RT_0 example translated into Datalog rules.
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

% Policy: Only allow access to UVM students or their parents.
member(ws, uvm-student, X) :- member(uvm, student, X).
member(ws, read, X) :- member(ws, uvm-student, X).
member(ws, read, X) :- member(ws, uvm-student, Y), member(Y, parent, X).

% Credentials submitted with John's request for access.
member(uvm, student, X) :- member(uvmregistrar, student, X).
member(uvmregistrar, student, alice).
member(alice, parent, john).

% Query: member(ws, read, john).





