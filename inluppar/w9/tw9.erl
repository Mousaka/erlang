-module(tw9).
-compile(export_all).

fib(1) -> 1;
fib(2) -> 1;
fib(N) -> fib(N-1) + fib(N-2).

test(W) ->
	F = fun(X) -> fib(X) end,
	L = [10, 30, 40, 1],
	{X1,Smap} = timer:tc(maps, smap, [F,L]),
	{X2,Pmap} = timer:tc(maps, pmap, [F,L,W]),
	
	maps:print([X1/1000000, smap, X2/1000000, pmap]),
	maps:print([smap, Smap, pmap, Pmap]),
	Smap = Pmap,
	yay.