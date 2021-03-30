# Chemical balancer

## Repo Description
this project consists of 2 parts:
1. **Python**:
   which is implemented based on guess and try method
2. **Nim**:
   which is implemented based on Guassian method

## Features:
1. **Python**:
  * nested molecule without limitation: Fe(Fe(CN)6)
2. **Nim**:
  * supports nested molecule with only 2 depth level: Fe(FeC6N6)
  * supports ions: IO3- , Fe+2

## Limitations:
1. **Python**:
  * can't balance chemical equations with balanced coefficients larger than 10
  * balancing chemical equations with more than 7 parts may takes hours
2. **Nim**:
  * can't balance if there are not attending parts in equations[like Ag in this example]: NaCl + Ag => Na+ + Cl- + Ag


### Some information about the problem:
first of all, we need to parse user entered equaiton

from something like this:
```
Fe2O3 + Al => Fe + Al2O3
```
to this:
```
[ {Fe:2, O:3}, {Al: 1} ],
[ {Fe: 1}, {Al:2, O:3} ]
```

I used 2 approaches to solve the equation:
1. **python**: it puts (1) coefficient for all parts of the equation and increase that number until 10
```
1 + 1 => 1 + 1
1 + 1 => 1 + 2
...
1 + 1 => 1 + 10
1 + 1 => 2 + 1
...
```

every time the program checks whether the equations is balanced or not

* pros:
  - is't easier for programmer to implement

* cons:
  - it can't balance equation if any of the balanced coefficients are more than 10
  - it's soooo slow for equation that have more than 6 parts ( imagine the program need to try 10^9 possibilities if the equation have 9 parts and it takes hours before it gives up) 

2. **Nim**: it creates a matrix[n*n] of coefficient [a, b, c,...] from the equation and solve it via Guassian method[a method to find n unknonws when you have n mathematical equaitons] the result would be the cofficients

```
(a)Fe2O3 +(b)Al => (c)Fe + (d)Al2O3

  Fe: 2a + 0b = 1c + 0d 
  Al: 0a + 1b = 0c + 2d 
  O : 3a + 0b = 0c + 3d 
=>
  Fe: 2a + 0b -1c  0d = 0 
  Al: 0a + 1b  0c -2d = 0 
  O : 3a + 0b  0c -3d = 0
```

I just convert these equations into a matrix:
```
 a  b  c  d | ans
[2  0 -1  0 | 0]
[0  1  0 -2 | 0]
[3  0  0 -3 | 0]
```

then we assume the last unknown is equal to 1 [it doesn't that matter which unknown we choose]

so we add this to the end of the matrix
```
[0  0  0  1 | 1]
```

now we have:
```
 a  b  c  d | ans
[2  0 -1  0 | 0]
[0  1  0 -2 | 0]
[3  0  0 -3 | 0]
[0  0  0  1 | 1]
```

the idea of the Guassion method is that we want to have something like this: [dot (`.`) means it could be any number]
```
 a  b  c  d
[1  .  .  . | .]
[0  1  .  . | .]
[0  0  1  . | .]
[0  0  0  1 | .]
```
and we can achive this by doing simple algebra between rows and swaping rows:
```
 a  b  c  d | ans
[2  0 -1  0 | 0]
[0  1  0 -2 | 0]
[3  0  0 -3 | 0]
[0  0  0  1 | 1]
```
=> swap R1 & R3
```
 a  b  c  d | ans
[3  0  0 -3 | 0]
[0  1  0 -2 | 0]
[2  0 -1  0 | 0]
[0  0  0  1 | 1]
```
R3 <- R3 + -(2/3)*R1
```
 a  b  c   d | ans
[3  0  0  -3 | 0]
[0  1  0  -2 | 0]
[0  0 -1  +2 | 0]
[0  0  0   1 | 1]
```
R1 <- R1/3
R3 <- R3*(-1)
```
 a  b  c  d | ans
[1  0  0 -1 | 0]
[0  1  0 -2 | 0]
[0  0  1 -2 | 0]
[0  0  0  1 | 1]
```

now we've got:
```
d = 1 *(I)
c + -2d = 0 => c = 2d =(I)=> c = 2 *(II)
b + -2d = 0 =(II)=> b = 2
a + -d = 0 =(I)=> a = 1  
```


I gave you a simple example, but in some cases we need to remove duplicated row and sorting it in a special way

and also some times we don't want to loose the number of digits after float point, for this reason, I implemented a fractional number system that has it's own addition(+), subtraction(-), multipication(*) and division(/) which was quite fun for me.
a fractional number would stores like this:

```
   up
 ------
  down 
```

* pros:
  - it's very fast (unlike the first approach, for a 9 parts equaiton it finds the coefficients before you even notice)
  - it solves the equations for high coefficients number

* cons:
  - it's harder to implement for programmer

