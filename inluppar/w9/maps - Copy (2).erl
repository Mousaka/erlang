-module(maps).
-compile(export_all).

%smap(F, L) -> [F(I) || I <- L].

smap(_, []) -> [];
smap(F, [H|T]) -> [F(H) | smap(F, T)].

pmap(F, L, W) -> 
	S = self(),
	N = length(L),
	register(stack, spawn(maps, stackloop, [L])),
	Pids = makeworkers(S, F, W, []),
	gather_replies(W, N, Pids).

gather_replies(_W, 0, _Pids) ->
	[];
gather_replies(W, N, Pids) ->
	Pid = lists:nth((N rem W)+1, Pids),
	receive
		{Pid, Val} -> [Val|gather_replies(W, N-1, Pids)]
	end.
	

	

makeworkers(_Parent, _F, 0, Pids) ->
	lists:reverse(Pids);
makeworkers(Parent, F, N, Pids) ->
	P = spawn(fun() -> worker(Parent, F) end),
	makeworkers(Parent, F, N-1, [P|Pids]).
	
worker(Parent, F) ->
	case whereis(stack) of
		undefined ->
			void;
			%print([self(), workerdone]);
		 _ ->
			stack ! {self(), pop},
			receive	
				{ok, X} ->
					%print(F(X)),
					Parent ! {self(), F(X)},
					worker(Parent, F);
				done ->
				print([self(), workerdone])
			end
	end.
	
stackloop([]) ->
		%[fun() -> P ! done end || P <- Pids],
		%print("Slut pa stack"),
		loopdone;
		
stackloop([H|T]) ->
	
	receive
		{From, pop} ->
			From ! {ok, H},
			stackloop(T)	
	end.
	
	
print(X) ->
    io:format("~p~n",[X]).