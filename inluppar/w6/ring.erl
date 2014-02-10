-module(ring).
-compile(export_all).

time(N,M) ->
	{X,Y} = timer:tc(ring, start, [N,M]),
	{X/1000000,Y}.

start(N,M) ->
	register(thestart, self()),
	PidList = create_ring(N, []),
	[Start | _] = PidList,
	connect_pids(Start, PidList),
	Itterations = N * M,
	Start ! {num, 1, Itterations},
	receive
		X when is_integer(X) ->
			Start!stop,
			unregister(thestart),
			X
	end.
	
killpids([]) ->
	print("All Pids stopped");
killpids([H|T]) ->
	H!stop,
	killpids(T).
create_ring(0, L) ->
	lists:reverse(L);
create_ring(N, L) ->
	create_ring(N-1, [spawn(ring, loop, [])|L]).

connect_pids(Start, [A,B]) ->
	A ! {next, B},
	B ! {next, Start};
	
connect_pids(Start, [A,B|T]) ->
	A!{next, B},
	connect_pids(Start, [B|T]).


loop() ->
	receive
		{next, Next} ->
			wait(Next)
	end.
	
wait(Next) ->
	receive
		{num, N, 1} ->
			thestart! N;
		{num, N, M} when M>0 ->
%%		%	print("Wait: "),
%%		%	print(N),
			Next!{num, N+1, M-1},
			wait(Next);
		stop -> 
			Next!stop,
			exit(self(), kill)
	end.
	
print(X) ->
    io:format("~p~n",[X]).