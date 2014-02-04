-module(bar).
-compile(export_all).

start() ->
	spawn(bar, loop, []).
	
loop() ->
	receive
			
		Any ->
			io:format("Any:~p~n", [Any]),
			loop()
	end.
	
	
	%%	P = bar:start().
	%%	P ! hej.
	%%  Any: hej
	%%  hej