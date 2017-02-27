% Parser.pl
% 
% Parser
% Austin Corotan, February 2017
% 
% Compile using: [parser].
%
% To run the parser, use the query:
%	scan('filename', T), parse(T, Tree).
%		filename is the input file (PostFix expression in this case)
%		T is the list of tokens
%		Tree is the AST expressed as a list of the form [Num, [Commands]]
%		where Num is the number of arguments for the program interpreter and
%		[Commands] are a prolog list of commands. 
%		(note that executable command sequences are output as a sublist in [Commands])

:- include('scanner.pl').

% Main 
parse([[punctuation,'('],[identifier,'postfix'],[number,X]|L1],[X|[Tree]]) :- commandseq(L1,[[punctuation,')'],[punctuation,'eof']],Tree).

commandseq(L1,L2,[Tree1|Tree]) :- command(L1,L3,Tree1),commandseq(L3,L2,Tree).
commandseq(L,L,[]).

command([[punctuation,'(']|L1], L2, Tree) :- commandseq(L1,[[punctuation,')']|L2],Tree).
command([[identifier,'add']|L1], L1,'add').
command([[identifier,'sub']|L1], L1,'sub').
command([[identifier,'mul']|L1], L1,'mul').
command([[identifier,'div']|L1], L1,'div').
command([[identifier,'rem']|L1], L1,'rem').
command([[identifier,'lt']|L1], L1,'lt').
command([[identifier,'gt']|L1], L1,'gt').
command([[identifier,'eq']|L1], L1,'eq').
command([[identifier,'pop']|L1], L1,'pop').
command([[identifier,'swap']|L1], L1,'swap').
command([[identifier,'sel']|L1], L1,'sel').
command([[identifier,'nget']|L1], L1,'nget').
command([[identifier,'exec']|L1], L1,'exec').
command([[operator,'-']|L1], L2, Val1) :- command(L1, L2, Val2), number(Val2), Val1 is -1*Val2.
command([[number,X]|L1], L1,X).










