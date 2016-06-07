%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE          : TbV-Example.pro
% LAST REVISION : 2005-02-09
% SUBJECT       : Trust-but-Verify example using separate mem/del.
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

% mem(A, Role, Name, E, R)
%     A    = Owner of role being defined.
%     Role = Role being defined.
%     Member role activation is "Name as E.R"
%

% del(A, B, Name, E, R)
%     A  = Source of delegation (issuer).
%     B  = Target of delegation (subject).
%     Delegated role activation is "Name as E.R"
%

% Generic rule: direct role members can activate a role.
mem(A, Role, X, A, Role) :- mem(A, Role, X, nobody, norole).

% MDB.doctor <- Joe
mem(mdb, doctor, joe, nobody, norole).

% M.priv_1 <- MDB.doctor
mem(m, priv_1, Name, E, R) :- mem(mdb, doctor, Name, E, R).

% MDB.priv_2 <- MDB.doctor
mem(mdb, priv_1, Name, E, R) :- mem(mdb, doctor, Name, E, R).

% Joe --(Joe as MDB.doctor)--> M
del(joe, m, joe, mdb, doctor).

% Generic rule: delegation is transitive.
del(A, C, Name, E, R) :-
	del(A, B, Name, E, R),
	del(B, C, Name, E, R).

% Can M take an action requiring MDB.doctor using "Joe as MDB.doctor"?
% mem(mdb, doctor, joe, mdb, doctor), del(joe, m, joe, mdb, doctor).
%
% "yes"

