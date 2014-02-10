-module(double).
-compile(export_all).


start() ->
	P = spawn(double, loop, []),
	register(double, P).
	
stop() ->
	double ! stop.
loop() ->
	receive
		A when is_integer(A) ->
			io:format("Double:~p~n", [A*2]),
			loop();
		stop ->
			exit(stop);
		_ -> 
			exit(not_integer)
	end.
	
	
