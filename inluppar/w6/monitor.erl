-module(monitor).
-compile(export_all).
%%FUNKAR INTE:: VARFÖR?
start() ->
	register(count, spawn(monitor, counter, [0])).
	
counter(N) ->
	receive
		{From, {add, K}} ->
			From ! {self(), ok},
			print("I rec"),
			counter(N+K);
		stop ->
			exit(slutraknat)
	end.

stop() -> rpc(count, stop).
add(K) -> rpc(count, {add,K}).
rpc(count, Msg) ->
	count ! {self(), Msg},
	receive
		{count, stop}->
			count ! stop;
		{count, Reply} ->
			Reply
	end.
	
print(X) ->
   io:format("~p~n",[X]).