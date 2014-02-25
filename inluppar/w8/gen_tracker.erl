-module(gen_tracker).
-compile(export_all).

start(Mod, State) ->
	register(Mod, spawn(gen_tracker, loop, [Mod, State])).
	
loop(Mod, State) ->
	receive
		{From, Tag, Query} ->
			{Reply, State1} = Mod:handle(Query, State),
			From ! {Tag, Reply},
			loop(Mod, State1)
		end.
		
rpc(Mod, Query) ->
	Tag = make_ref(),
	Mod ! {self(), Tag, Query},
	receive
		{Tag, Reply} ->
			Reply
	end.