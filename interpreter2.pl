% Interpreter2.pl
% 
% Interpreter2
% Austin Corotan, February 2017
% 
% Compile using: [interpreter].
%
% To run the interpreter, use the query:
%	scan('filename', T), parse(T, AST), interpret(AST, [Input]).
%		filename is the input file (PostFix expression in this case)
%		T is the list of tokens
%		AST is the abstract syntax tree expressed as a list of the form [Num, [Commands]]
%		Num is the number of arguments for the program interpreter
%	    [Commands] is a prolog list of commands. 
%		[Input] is a list of arguments provided by the user

:- include('parser.pl').


%List of commands to query
commandlist(['pop','add','sub','div','mul','rem','lt','gt','eq','swap','sel','nget','exec']).

%List Processing
intersects([H|_],List) :- member(H,List),!.
intersects([_|T],List) :- intersects(T,List).

indexOf([Element|_], Element, 0):- !.
indexOf([_|Tail], Element, Index):- indexOf(Tail, Element, Index1), !, Index is Index1+1.

elementOf(Element, List) :- intersects([Element], List).

deleteEle([_|List],1,List):-!.
deleteEle([H|List],Index,[H|New]):- Index > 1, Ele is Index - 1, !, deleteEle(List,Ele,New).

insertEle(T, 1, X, [X|T]).
insertEle([H|T], Index, X, [H|R]):- Index > 1, Ele is Index - 1, !, insertEle(T, Ele, X, R).

len([], LenResult):- LenResult is 0.
len([X|Y], LenResult):- len(Y, L), LenResult is L + 1.

remove_at([], Y, _, Y) :- !.       
remove_at(X, X, _, []) :- !.      
remove_at([X|T], [X|Xs], 1, L) :- remove_at(T, Xs, 1, L).
remove_at(X, [Y|Xs], K, [Y|Ys]) :- K > 0, K1 is K - 1, remove_at(X, Xs, K1, Ys).
insert_at(X, L, K, R) :- remove_at(X, R, K, L).

% push entire list to stack
pushlist([H|T],A,R):- pushlist(T,[H|A],R). 
pushlist([],A,A).
% Main (Push Arguments onto Command Sequence Tree)
interpret([H|[Tree]], Arguments) :- length(Arguments,H), pushlist(Arguments, Tree, Tree1), 
									write('IF ---> '), write(Tree1), nl, write('==> '), write(Tree1), nl, processCommands(Tree1, 1).

% Base Case(ending case scenario) only numbers left on tree (or command sequences), no more commands left, grab last element on list and print (OF)
processCommands(Tree, Index) :- commandlist(L), intersects(Tree,L), getleftcommand(Tree, Index),!.
processCommands(Tree, Index) :- len(Tree,Length), nth(Length,Tree, Answer), number(Answer), write('OF ---> '), write(Answer),!.

getleftcommand(Tree, Index) :- nth(Index, Tree, Command), commandexec(Command, Tree, Index),!.
getleftcommand(Tree,Index) :-  write('OF ---> '), write('Error!').

commandexec('pop', Tree, Index) :- deleteEle(Tree, Index, Tree1), deleteEle(Tree1, Index - 1, Tree2), write('==> '), write(Tree2), nl, Index1 is Index - 2, processCommands(Tree2,Index1).
commandexec('add', Tree, Index) :- Index1 is Index - 1, Index2 is Index - 2, Index1 > 0, Index2 > 0, nth(Index1, Tree, Val1), 
								   nth(Index2, Tree, Val2), number(Val1), number(Val2), Val3 is Val2 + Val1, 
								   deleteEle(Tree, Index, Tree1), deleteEle(Tree1, Index1, Tree2), deleteEle(Tree2, Index2, Tree3),
								   insertEle(Tree3, Index2, Val3, Tree4),
								   write('==> '), write(Tree4), nl, processCommands(Tree4,1). %Index1
commandexec('sub', Tree, Index) :- Index1 is Index - 1, Index2 is Index - 2, Index1 > 0, Index2 > 0, 
								   nth(Index1, Tree, Val1), nth(Index2, Tree, Val2), number(Val1), number(Val2), Val3 is Val2 - Val1, 
								   deleteEle(Tree, Index, Tree1), deleteEle(Tree1, Index1, Tree2), deleteEle(Tree2, Index2, Tree3),
								   insertEle(Tree3, Index2, Val3, Tree4),
								   write('==> '), write(Tree4), nl, processCommands(Tree4,1).
commandexec('mul', Tree, Index) :- Index1 is Index - 1, Index2 is Index - 2, Index1 > 0, Index2 > 0, 
								   nth(Index1, Tree, Val1), nth(Index2, Tree, Val2), number(Val1), number(Val2), Val3 is Val2 * Val1, 
								   deleteEle(Tree, Index, Tree1), deleteEle(Tree1, Index1, Tree2), deleteEle(Tree2, Index2, Tree3),
								   insertEle(Tree3, Index2, Val3, Tree4),
								   write('==> '), write(Tree4), nl, processCommands(Tree4,1).
commandexec('div', Tree, Index) :- Index1 is Index - 1, Index2 is Index - 2, Index1 > 0, Index2 > 0, 
								   nth(Index1, Tree, Val1), nth(Index2, Tree, Val2), number(Val1), number(Val2), Val3 is Val2 // Val1, 
								   deleteEle(Tree, Index, Tree1), deleteEle(Tree1, Index1, Tree2), deleteEle(Tree2, Index2, Tree3),
								   insertEle(Tree3, Index2, Val3, Tree4),
								   write('==> '), write(Tree4), nl, processCommands(Tree4,1).
commandexec('rem', Tree, Index) :- Index1 is Index - 1, Index2 is Index - 2, Index1 > 0, Index2 > 0, 
								   nth(Index1, Tree, Val1), nth(Index2, Tree, Val2), number(Val1), number(Val2), Val3 is rem(Val2,Val1), 
								   deleteEle(Tree, Index, Tree1), deleteEle(Tree1, Index1, Tree2), deleteEle(Tree2, Index2, Tree3),
								   insertEle(Tree3, Index2, Val3, Tree4),
								   write('==> '), write(Tree4), nl, processCommands(Tree4,1).
commandexec('lt', Tree, Index) :- Index1 is Index - 1, Index2 is Index - 2, Index1 > 0, Index2 > 0, 
								   nth(Index1, Tree, Val1), nth(Index2, Tree, Val2), number(Val1), number(Val2), 
								   deleteEle(Tree, Index, Tree1), deleteEle(Tree1, Index1, Tree2), deleteEle(Tree2, Index2, Tree3),
								   (Val2 < Val1 -> insertEle(Tree3, Index2, 1, Tree4); insertEle(Tree3, Index2, 0, Tree4)),
								   write('==> '), write(Tree4), nl, processCommands(Tree4,1).
commandexec('gt', Tree, Index) :- Index1 is Index - 1, Index2 is Index - 2, Index1 > 0, Index2 > 0, 
								   nth(Index1, Tree, Val1), nth(Index2, Tree, Val2), number(Val1), number(Val2), 
								   deleteEle(Tree, Index, Tree1), deleteEle(Tree1, Index1, Tree2), deleteEle(Tree2, Index2, Tree3),
								   (Val2 > Val1 -> insertEle(Tree3, Index2, 1, Tree4); insertEle(Tree3, Index2, 0, Tree4)),
								   write('==> '), write(Tree4), nl, processCommands(Tree4,1).	
commandexec('eq', Tree, Index) :- Index1 is Index - 1, Index2 is Index - 2, Index1 > 0, Index2 > 0, 
								   nth(Index1, Tree, Val1), nth(Index2, Tree, Val2), number(Val1), number(Val2), 
								   deleteEle(Tree, Index, Tree1), deleteEle(Tree1, Index1, Tree2), deleteEle(Tree2, Index2, Tree3),
								   (Val2 =:= Val1 -> insertEle(Tree3, Index2, 1, Tree4); insertEle(Tree3, Index2, 0, Tree4)),
								   write('==> '), write(Tree4), nl, processCommands(Tree4,1).
commandexec('swap', Tree, Index) :- Index1 is Index - 1, Index2 is Index - 2, Index1 > 0, Index2 > 0, 
								   nth(Index1, Tree, Val1), nth(Index2, Tree, Val2), deleteEle(Tree, Index, Tree1), deleteEle(Tree1, Index1, Tree2), 
								   deleteEle(Tree2, Index2, Tree3), insertEle(Tree3, Index2, Val1, Tree4), insertEle(Tree4, Index1, Val2, Tree5),
								   write('==> '), write(Tree5), nl, processCommands(Tree5,1).	
commandexec('sel', Tree, Index) :- Index1 is Index - 1, Index2 is Index - 2, Index3 is Index - 3, Index1 > 0, Index2 > 0, Index3 > 0,
								   nth(Index1, Tree, Val1), nth(Index2, Tree, Val2), nth(Index3, Tree, Val3), deleteEle(Tree, Index, Tree1), deleteEle(Tree1, Index1, Tree2), 
								   deleteEle(Tree2, Index2, Tree3), deleteEle(Tree3, Index3, Tree4),
								   (Val3 =:= 0 -> insertEle(Tree4, Index3, Val1, Tree5); insertEle(Tree4, Index3, Val2, Tree5)),
								   write('==> '), write(Tree5), nl, processCommands(Tree5,1).	%Index2
commandexec('nget', Tree, Index) :- Index1 is Index - 1, Index1 > 0, nth(Index1, Tree, Val1), Index2 is Index1 - Val1, nth(Index2, Tree, Val2), deleteEle(Tree, Index, Tree1), 
									deleteEle(Tree1, Index1, Tree2), insertEle(Tree2, Index1, Val2, Tree3),
								    write('==> '), write(Tree3), nl, processCommands(Tree3,1).
commandexec('exec', Tree, Index) :- Index1 is Index - 1, Index1 > 0, nth(Index1, Tree, Val1), deleteEle(Tree, Index, Tree1), 
									deleteEle(Tree1, Index1, Tree2), insert_at(Val1,Tree2,Index1,Tree3),
								    write('==> '), write(Tree3), nl, processCommands(Tree3,1).								    						   								   							   
commandexec(_, Tree, Index) :- Index1 is Index + 1, processCommands(Tree, Index1).






