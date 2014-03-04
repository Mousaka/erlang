-module(maps).
-compile(export_all).

%smap(F, L) -> [F(I) || I <- L].

smap(_, []) -> [];
smap(F, [H|T]) -> [F(H) | smap(F, T)].

pmap_timout_any_tagged_max_time(F, L, T) ->
	timer:start(),
	S = self(),
	Len= length(L),
	Pids = makeworkers(F, Len, []),
	for2(1, Len, fun(X) -> get_next_pid(X, Len, Pids) ! {S, lists:nth(X, L)} end),
	lists:foreach(fun(X)-> X ! donefortheday end, Pids),
	sleep(T),
	gather(Pids, Len).

gather(Pids, Len) ->
	Pids_killed = timeisup(Pids, 0),
%	print(Pids_killed),
	for(1, (Len-Pids_killed), fun(X) ->  %Gathers anwers without order
						receive
							{_Pid, {Element, Ans}}  ->
								{Element, Ans}
						end
				end).
				
timeisup([], R) ->
	R;
timeisup([H|T], R) ->
	case is_process_alive(H) of
		true -> 
			exit(H, kill),
			timeisup(T, R+1);
		false ->
			timeisup(T, R)
	end.
				
pmap_timeout(F, L, T, W) ->
	S = self(),
	Len= length(L),
	Pids = makeworkers(F, W, []),
	for2(1, Len, fun(X) -> get_next_pid(X, W, Pids) ! {S, lists:nth(X, L)} end),
	lists:foreach(fun(X)-> X ! donefortheday end, Pids), %Stops workers
	for(1, Len, fun(X) ->  %Gathers anwers in order
					Pid = get_next_pid(X, W, Pids),
					receive
						{Pid, {_Element, Ans}} ->
							Ans
					after T ->
						timeout
					end
				end).

pmap_any(F, L) ->
	S = self(),
	Len= length(L),
	Pids = makeworkers(F, Len, []),
	for2(1, Len, fun(X) -> get_next_pid(X, Len, Pids) ! {S, lists:nth(X, L)} end),
	lists:foreach(fun(X)-> X ! donefortheday end, Pids),
	for(1, Len, fun(X) ->  %Gathers anwers without order
						receive
							{_Pid, {_Element, Ans}} ->
								Ans
						end
				end).

pmap_any_tagged(F, L) ->
	S = self(),
	Len= length(L),
	Pids = makeworkers(F, Len, []),
	for2(1, Len, fun(X) -> get_next_pid(X, Len, Pids) ! {S, lists:nth(X, L)} end),
	lists:foreach(fun(X)-> X ! donefortheday end, Pids),
	for(1, Len, fun(X) ->  %Gathers anwers without order
						receive
							{_Pid, {Element, Ans}}  ->
								{Element, Ans}
						end
				end).
				

pmap_max(F, L, W) -> 
	S = self(),
	Len= length(L),
	Pids = makeworkers(F, W, []),
	for2(1, Len, fun(X) -> get_next_pid(X, W, Pids) ! {S, lists:nth(X, L)} end),
	lists:foreach(fun(X)-> X ! donefortheday end, Pids), %Stops workers
	for(1, Len, fun(X) ->  %Gathers anwers in order
					Pid = get_next_pid(X, W, Pids),
					receive
						{Pid, {_Element, Ans}} ->
							Ans
					end
				end).
				
get_next_pid(N, W, Pids) ->
	Rem = ((N-1) rem W) + 1,
	%print([Rem, Pids]),
	lists:nth(Rem, Pids).

worker(F) ->
	receive
		{From, Element} ->
			Ans = try F(Element)
			catch
				_:_ -> error
			end,
			%print([self(), F(Element)]),
			From ! {self(), {Element, Ans}},
			worker(F);
		donefortheday ->
			void
			%print({self(), cya})
	end.



makeworkers(_F, 0, Pids) ->
	lists:reverse(Pids);
makeworkers(F, N, Pids) ->
	P = spawn(fun() -> worker(F) end),
	makeworkers(F, N-1, [P|Pids]).

for(Max, Max, F) -> [F(Max)];
for(I, Max, F) -> [F(I) | for(I+1, Max, F)].

for2(Max, Max, F) -> F(Max);
for2(I, Max, F) -> F(I), for(I+1, Max, F).

sleep(T) ->
	receive
		after T ->
			true
	end.
	
print(X) ->
    io:format("~p~n",[X]).