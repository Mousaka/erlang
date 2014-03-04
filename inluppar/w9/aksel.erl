pmap_max(F, L, MaxWorkers) ->
 Length = length(L),
 Pids = for(1, MaxWorkers, fun(X) -> io:format("worker nr: ~p~n", [X]),spawn(fun worker_max/0) end),
 for(1, Length, fun(X) -> compute_max(X, F, L, Pids, MaxWorkers) end),
 Result = gather_max(Length,Length,[]),
 lists:foreach(fun(Pid) -> exit(Pid,kill) end, Pids),
 Result.

worker_max() ->
 receive
  {From, Tag, F, V} ->
   From ! {self(),Tag, F(V)},
   worker_max()
 end.

compute_max(X, F, L, Pids, MaxWorkers) -> 
 Val = lists:nth(X, L),
 Pid = lists:nth((X rem MaxWorkers)+1, Pids),
 Pid ! {self(), X, F, Val}.

gather_max(0, Max,_) ->
 reducer_max(Max,[]);

gather_max(I,Max,[H|T]) ->
 receive
  {From,Tag,Val} ->
   From ! {self(), I, H},
   self() ! {Tag,Val},
   gather_max(I-1,Max,T)
 end;

gather_max(I,Max,[]) ->
 receive
  {_From,Tag,Val} ->
   self() ! {Tag, Val},
   gather_max(I-1,Max,[])
 end.

reducer_max(0, Result) ->
 Result;

reducer_max(Tag, Ack) ->
 receive 
  {Tag, Val} -> reducer_max(Tag-1, [Val|Ack])
 end.