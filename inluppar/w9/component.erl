-module(component).
-compile(export_all).



start() ->
	PortA = spawn(component, loop, ['A']),
	PortB = spawn(component, loop, ['B']),
	register(conv, spawn(component, loop, [PortA, PortB])).

loop(A, B) ->
	receive
		{km, X} ->
			Miles = X * 0.62137,
			B ! {miles, Miles},
			loop(A,B);
		{miles, X} ->
			Km = X/0.62137,
			A ! {km, Km},
			loop(A,B)
	end.
	
	
	
	
	
loop(X) ->
	receive
		Any ->
			 io:format("~p~n",[{port, X ,Any}]),
			 loop(X)
	end.

