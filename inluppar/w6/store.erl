-module(store).
-compile(export_all).

start() ->
	register(master, spawn(store, loop, [])),
	register(replica, spawn(store, loop, [])).

crash(Pid) ->
	Pid ! {self(), stop},
	receive
		{From, crashed} ->
			[From, crashed]
	end.
	
store(Key, Value) -> 
	M = whereis(master),
	R = whereis(replica),
	if
		is_pid(M) ->
			master ! {self(), {store, Key, Value}},
			receive
				{M, Reply} ->
					print([master_store,Reply]),
					Return = Reply
			end;
		true ->
			print([no_master_exists]),
			Return = false
	end,
			
	if
		is_pid(R) ->
			replica ! {self(), {store, Key, Value}},
				receive	
					{R, Reply2} ->
						print([replica_store, Reply2]),
						[Return, Reply2]
				end;
		true ->
			print([no_replica_exists]),
			[nothing_stored]
	end.


fetch(Key) -> 
	M = whereis(master),
	R = whereis(replica),
	%print([M,R]),
	if
		is_pid(M) ->
			%print([inM]),
			master ! {self(), {fetch, Key}},
			receive
				{M, {ok,Reply}} ->
					Reply
			end;
		is_pid(R) ->
			%print([inR]),
			replica ! {self(), {fetch, Key}},
			receive
				{R, {ok,Reply}} ->
					Reply
			end;
		true ->
			exit("No store processes exits!")
	end.
	
loop() ->
	receive
		{From,stop} ->
			From ! {self(), crashed},
			exit([self(), crashed]);
		{From, {store, Key, Value}} ->
			put(Key, {ok, Value}),
			From ! {self(), true},
			loop();
		{From, {fetch, Key}} ->
			From ! {self(), get(Key)},
			loop()
end.

print(X) ->
   io:format("~p~n",[X]).