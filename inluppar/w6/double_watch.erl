-module(double_watch).
-compile(export_all).

start_and_watch() ->
	Pid = spawn(double, loop, []),
	spawn(double_watch, watch, [Pid]),
	register(double, Pid).
	
watch(Pid) ->
	link(Pid),
	process_flag(trap_exit, true),
	print({watching, Pid}),
	receive
		{'EXIT', Pid, stop} ->
			exit("exit program");
		{'EXIT', Pid, Why} ->
		print({ohDear,Pid,crashed,because,Why}),
		start_and_watch()
	end.
	
	
print(X) ->
   io:format("~p~n",[X]).