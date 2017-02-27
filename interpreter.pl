% Interpreter.pl
% 
% Interpreter
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

% stack implementation
pops([Val|Stack], Val, Stack).
pushs(Stack, Val, [Val|Stack]).

% push entire list to stack
pushlist([H|T],A,R):- pushlist(T,[H|A],R). 
pushlist([],A,A).

% Main 
interpret([H|[Tree]], Stack) :- length(Stack,H), processCommands(Tree,Stack).

processCommands([], [H|_]) :- number(H), write(H).
processCommands(Tree, Stack) :- command(Tree,Stack).

command(['pop'|Tree], Stack) :- pops(Stack, _, Stack1), processCommands(Tree, Stack1).
command(['add'|Tree], Stack) :- pops(Stack, Val1, Stack1), pops(Stack1, Val2, Stack2), number(Val2), number(Val1), Val3 is Val2 + Val1, 
									pushs(Stack2,Val3, Stack3), processCommands(Tree, Stack3).
command(['sub'|Tree], Stack) :- pops(Stack, Val1, Stack1), pops(Stack1, Val2, Stack2), number(Val2), number(Val1), Val3 is Val2 - Val1, 
									pushs(Stack2,Val3, Stack3), processCommands(Tree, Stack3).
command(['div'|Tree], Stack) :- pops(Stack, Val1, Stack1), pops(Stack1, Val2, Stack2), number(Val2), number(Val1), Val3 is Val2 // Val1, 
								    pushs(Stack2,Val3, Stack3), processCommands(Tree, Stack3).
command(['mul'|Tree], Stack) :- pops(Stack, Val1, Stack1), pops(Stack1, Val2, Stack2), number(Val2), number(Val1), Val3 is Val2*Val1, 
									pushs(Stack2,Val3, Stack3), processCommands(Tree, Stack3).
command(['rem'|Tree], Stack) :- pops(Stack, Val1, Stack1), pops(Stack1, Val2, Stack2), number(Val2), number(Val1), Val3 is rem(Val2,Val1), 
									pushs(Stack2,Val3, Stack3), processCommands(Tree, Stack3).
command(['lt'|Tree], Stack) :- pops(Stack, Val1, Stack1), pops(Stack1, Val2, Stack2), number(Val2), number(Val1), (Val2 < Val1 -> 
									pushs(Stack2, 1, Stack3); pushs(Stack2, 0, Stack3)), processCommands(Tree, Stack3).
command(['gt'|Tree], Stack) :- pops(Stack, Val1, Stack1), pops(Stack1, Val2, Stack2), number(Val2), number(Val1), (Val2 > Val1 -> 
									pushs(Stack2, 1, Stack3); pushs(Stack2, 0, Stack3)), processCommands(Tree, Stack3).
command(['eq'|Tree], Stack) :- pops(Stack, Val1, Stack1), pops(Stack1, Val2, Stack2), number(Val2), number(Val1), (Val2 =:= Val1 -> 
									pushs(Stack2, 1, Stack3); pushs(Stack2, 0, Stack3)), processCommands(Tree, Stack3).
command(['swap'|Tree], Stack) :- pops(Stack, Val1, Stack1), pops(Stack1, Val2, Stack2), pushs(Stack2,Val1, Stack3), 
									pushs(Stack3,Val2, Stack4), processCommands(Tree, Stack4).
command(['sel'|Tree], Stack) :- pops(Stack, Val1, Stack1), pops(Stack1, Val2, Stack2), pops(Stack2, Val3, Stack3), number(Val3), 
									(Val3 =:= 0 -> pushs(Stack3,Val1, Stack4); pushs(Stack3,Val2, Stack4)), processCommands(Tree, Stack4).
command(['nget'|Tree], Stack) :- pops(Stack, Vindex, Stack1), number(Vindex), nth(Vindex,Stack1,Val), 
									pushs(Stack1,Val,Stack4), processCommands(Tree, Stack4).
command(['exec'|Tree], Stack) :- pops(Stack, Val1, Stack1), is_list(Val1), reverse(Val1,Val2), pushlist(Val2,Tree,Tree1), processCommands(Tree1, Stack1).

% All other options (numbers, executable command sequences, etc.)
command([H|Tree], Stack) :- pushs(Stack,H,Stack1), processCommands(Tree, Stack1).







