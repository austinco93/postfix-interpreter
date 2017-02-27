% Scanner.pl
% 
% example scanner
% D. Bover, WWU Computer Science, January 2004
%
% The scanner recognizes:
%	identifiers - letter (letter | digit)*
%	numbers     - digit (digit)*
%	punctuation - '(' | ')' 
%   operators   - '+' | '-' | '*' | '/'
%
% To run the scanner, use the query:
%	scan('filename', T), displayList(T).
%		filename is the input file
%		T is the list of tokens	


% scan(File, List])
%	File - input file to be scanned
%	List - list of tokens, each of the form [type, lexeme]


scan(File, Tokens) :-
	see(File),	
	getLine(Line),		
	scanTokens(Line, Tokens), !,
	seen.


% scanTokens(Line, List)
%	Line - input line
%	List - list of tokens from the remaining characters

scanTokens([], [[punctuation, 'eof']]).

scanTokens([10], Tokens) :-                       % end of line reached
	getLine(Line),
	scanTokens(Line, Tokens).

scanTokens([-1], [[punctuation, 'eof']]).		% end of file reached

scanTokens(Line, [T|List]) :-
	getToken(Line, T, RestOfLine),
	scanTokens(RestOfLine, List).	
	
scanTokens([_|Line], List) :-		% getToken() failed: skip this character
	scanTokens(Line, List).


% getToken(Line, Token, RestOfLine)
%	Line       - input line before the token is extracted
%	Token      - the token found by this predicate
%	RestOfLine - input line after the token is extracted

getToken([C|Line], [identifier, Token], RestOfLine) :-	% scan an identifier
	letter(C),
	scanIdentifier(Line, Id, RestOfLine),
	name(Token, [C | Id]).

getToken([C|Line], [number, Token], RestOfLine) :-	% scan a number
	digit(C),
	Val is C - 48,
	scanNumber(Line, Val, Token, RestOfLine).

getToken([C|Line], [punctuation, Token], Line) :-	% scan punctuation
	punctuation(C),
	name(Token, [C]).

getToken([C|Line], [operator, Token], Line) :-	% scan operator
	operator(C),
	name(Token, [C]).


% scanIdentifier(Line, Token, RestOfLine)
%	Line       - input line before the token is extracted
%	Token      - the token found by this predicate
%	RestOfLine - input line after the token is extracted

scanIdentifier([C|Line], [C|List], RestOfLine) :-
	alphanum(C), !,
	scanIdentifier(Line, List, RestOfLine).
	
scanIdentifier(Line, [], Line).


% scanNumber(Line, OldValue, Value, RestOfLine)
%	Line       - input line before the token is extracted
%	OldValue   - value of number from characters processed so far
%	Value      - the final value of the number
%	RestOfLine - input line after the token is extracted

scanNumber([C|Line], Val, Token, RestOfLine) :-
	digit(C), !,
	Val1 is Val * 10 + C - 48,
	scanNumber(Line, Val1, Token, RestOfLine).

scanNumber(Line, Val, Val, Line).


% getLine(Line)		gets the next line of input from current file

getLine(Line) :-
    get0(C),
    readLine(C, [], Line), !.
 
% readLine(Char, OldLine, NewLine)    add one character to the input line

readLine(10, Sofar, Line) :-			% end of line
    reverse([10 | Sofar], Line).
    
readLine(-1, Sofar, Line) :-			% end of file
	reverse([-1|Sofar], Line).
    
readLine(C, Sofar, Line) :-				% normal character
    get0(C1),
    readLine(C1, [C | Sofar], Line),
    !.


% Character code definitions

letter(C) :- C >= 97, C =< 122.
letter(C) :- C >= 65, C =< 90.

digit(C) :- C >= 48, C =< 57.

alphanum(C) :- letter(C).
alphanum(C) :- digit(C).

punctuation(40).	% (
punctuation(41).	% )

operator(43).		% +
operator(45).		% -
operator(42).		% *
operator(47).		% /


% displayList(List)		display a list of tokens

displayList([]).

displayList([First | Rest]) :-
	displayToken(First), nl, displayList(Rest), !.
	

% displayToken(Token)	display one token

displayToken([identifier, Value]) :-
	write('identifier  : "'), write(Value), write('"').

displayToken([number, Value]) :-
	write('number      : "'), write(Value), write('"').

displayToken([punctuation, Value]) :-
	write('punctuation : "'), write(Value), write('"').

displayToken([operator, Value]) :-
	write('operator    : "'), write(Value), write('"').
