-module(maps).
-compile(export_all).

smap(F, L) -> [F(I) || I <- L].

mapreduce(F1, F2, Acc0, L) ->
	S = self(),
	Pid = spawn(fun() -> reduce(S, F1, F2, Acc0, L) end),
	receive
		{Pid, Result} ->
			Result
	end.
	
reduce(Parent, F1, F2, Acc0, L) ->
	process_flag(trap_exit), true),
	ReducePid = self(),
	Ans = [spawn_link(fun() -> S ! {self(), catch F(I)} end) || I <- L],
	N = length(L),
	collect_replies(N, []).
	
collect_replies(N, Res) ->
	receive
		{Key, Value} ->
			
	