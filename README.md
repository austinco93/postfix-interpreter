# PostFix Interpreter
Prolog program to parse and interpret a made-up language called _Postfix_. _Postfix_ is a stack-based language defined in 
_Design Concepts in Programming Languages_, by Franklyn Turbak and David Gifford.

`interpreter.pl` simply returns the result of the command provided in 'input.txt'

`interpreter2.pl` will display the stack after each command execution.

## Usage
```
? - [interpreter|interpreter2].  
? - scan('<filename>', T),parse(T, AST),interpret(AST,[<arguments>]).  
```

### Example
`input.txt` contains the an example PostFix program that will calculate b - a*b². `<arguments>` will contain a and b respectively.

```
? - [interpreter]. 
?- scan('input.txt', Tokens),parse(Tokens, AST),interpret(AST,[5,2]).       
-18

```

```
? - [interpreter2]. 
?- scan('input.txt', Tokens),parse(Tokens, AST),interpret(AST,[5,2]).       
IF ---> [2,5,[mul,sub],[1,nget,mul],4,nget,swap,exec,swap,exec]
==> [2,5,[mul,sub],[1,nget,mul],4,nget,swap,exec,swap,exec]
==> [2,5,[mul,sub],[1,nget,mul],2,swap,exec,swap,exec]
==> [2,5,[mul,sub],2,[1,nget,mul],exec,swap,exec]
==> [2,5,[mul,sub],2,1,nget,mul,swap,exec]
==> [2,5,[mul,sub],2,2,mul,swap,exec]
==> [2,5,[mul,sub],4,swap,exec]
==> [2,5,4,[mul,sub],exec]
==> [2,5,4,mul,sub]
==> [2,20,sub]
==> [-18]
OF ---> -18
```
