-module(w6_test).
-compile(export_all).

test_simple() ->
	double:start(),
	32.12 =  double! 32.12,
	horray.
	
test_ring() ->
	8= ring:start(4,2),
	2= ring:start(2,1),
	8= ring:start(8,1),
	yeeew.
	
test_ring_time() ->
	{X,Y} = ring:time(1000,1000),   %%X is time in seconds
	
	1000000 = Y,
	
	[{X,Y}, goodie].
	
test_double_server() ->
	double_server:start_ALL().