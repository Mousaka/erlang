-module(double_server).
-compile(export_all).

start_server() ->
	P = spawn(double, loop, []),
	register(double, P).
	
stop() ->
	double ! stop.
loop() ->
	receive
		{From, A} when is_integer(A) ->
			%io:format("Double:~p~n", [A*2]),
			From ! {self(), [A*2]},
			loop();
		stop ->
		%%	From ! {self(), ["Server stopped"]},
			exit(stop);
		_ -> 
			exit(not_integer)
	end.
	

start_and_watch() ->
	Pid = spawn(double_server, loop, []),
	spawn(double_server, watch, [Pid]),
	register(double, Pid).

	%Starts server, client, watcher, crasher
start_ALL() ->
	start_and_watch(),
	start_client(),
	start_crasher().
	
watch(Pid) ->
	link(Pid),
	process_flag(trap_exit, true),
	print({watching, Pid}),
	receive
		{'EXIT', Pid, stop} ->
			exit("exit program");
		{'EXIT', Pid, Why} ->
		print({ohDear,Pid,crashed,because,Why}),
		sleep(crypto:rand_uniform(1000, 6000)),
		start_and_watch()
	end.
	
	
print(X) ->
   io:format("~p~n",[X]).
   
   %%CLIENT


start_client() ->
	spawn(double_server, loop2, [10]).
	

loop2(0) -> crasher:print(done);
loop2(N) ->
	sleep(1000),
	X = request(N),
	print(X),
	loop2(N-1).
	

	
request(N) ->
	request(N,10).
request(N,0) ->
	noresponsefromserver;
request(N,Tries) ->
	R = crypto:rand_uniform(500,2000),
	try 
		double ! {self(), N},
		receive
			{From, D} ->
				D
		end
	catch
		error:_ ->
			sleep(R),
			print(["Reconnecting.."]),
			request(N, Tries-1)
	end.

	%%CRASHER
	
start_crasher() ->
	spawn(double_server, loop3, [100]),
	sleep(50),
	double ! {self(), atom}.

loop3(0) -> print(doneCrashing);
loop3(N) ->
	T = crypto:rand_uniform(0, 3000),
	sleep(T),
	try
		double !{self, atom},
		loop3(N-1)
	catch
		error:_ ->
			loop3(N)
	end.
	

sleep(T) ->
	%%sleep for T millisecs
	receive
		after T ->
			true
	end.