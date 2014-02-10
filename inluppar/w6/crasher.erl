-module(crasher).
-compile(export_all).

start() ->
	spawn(crasher, loop, [100]).

loop(0) -> print(doneCrashing);
loop(N) ->
	T = crypto:rand_uniform(1000, 2000),
	sleep(T),
	double !{self, atom},
	loop(N-1).
	

sleep(T) ->
	%%sleep for T millisecs
	receive
		after T ->
			true
	end.
	
print(X) ->
   io:format("~p~n",[X]).