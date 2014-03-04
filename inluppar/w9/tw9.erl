-module(tw9).
-compile(export_all).

fib(1) -> 1;
fib(2) -> 1;
fib(N) -> fib(N-1) + fib(N-2).

all_tests() ->
	yay = test1(4),
	good = test2(),
	ok = test4(),
	all_tests_ok.

test1(W) ->
	F = fun(X) -> fib(X) end,
	L = [10, 30, 40, 1, 22, 32, 14, 37],
	{X1,Smap} = timer:tc(maps, smap, [F,L]),
	{X2,Pmap} = timer:tc(maps, pmap_max, [F,L,W]),
	
	maps:print([X1/1000000, smap, X2/1000000, pmap_max]),
	maps:print([smap, Smap, pmap_max, Pmap]),
	Smap = Pmap,
	yay.
	
test2() ->
	F = fun(X) -> fib(X) end,
	L = [35,2,20],
	
	[1,6765,9227465] = maps:pmap_any(F, L),
	
	[{2,1}, {20,6765}, {35, 9227465}] = maps:pmap_any_tagged(F,L),
	good.
	
test3(W) ->            %%Not done yet.
	F = fun(X) -> fib(X) end,
	L = [10, 30, 40, 1, 22, 32, 14, 37],
	{X2,Pmap} = timer:tc(maps, pmap_timeout, [F,L, 1000, W]),
	
	maps:print([X2/1000000, pmap_timeout]),
	maps:print([pmap_timeout, Pmap]).

test4() ->
	F = fun(X) -> fib(X) end,
	L = [35,2,456,20],
	{X2,Pmap} = timer:tc(maps, pmap_timout_any_tagged_max_time, [F,L, 2000]),
	
	maps:print([X2/1000000, pmap_timout_any_tagged_max_time]),
	maps:print([pmap_timeout, Pmap]),
	
	[{2,1},{20,6765},{35, 9227465}] = Pmap,
	
	ok.
	