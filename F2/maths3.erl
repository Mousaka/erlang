-module(maths3).
-compile(export_all). 

test() ->  %%Testprogram!
	120 = fac(5),
	100 = area({square,10}),
	1000 = volume({cube, 10,10,10}),
	goodie.
	
area({rectangle, X,Y}) -> X*Y;
area({square, X}) -> X*X.

fac(1) -> 1;
fac(N) -> N * fac(N-1).

volume({cube, X, Y, Z}) ->
	X*Y*Z;
	
volume({sphere, R}) ->
	4*math:pi()*volume({cube,R,R,R})/3.