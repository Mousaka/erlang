-module(tracker).
-compile(export_all).

start() -> gen_tracker:start(tracker, dict:new()).
read() -> gen_tracker:rpc(tracker, read).

i_want(File, IP) -> gen_tracker:rpc(tracker, {i_want, File, IP}).
i_am_leaving(IP) -> gen_tracker:rpc(tracker, {leaving, IP}).

handle(read, State) -> {State, State};
handle({leaving, IP}, State) ->
	print([leaving, IP, State]),
	L = dict:to_list(State),
	{ip_left, dict:from_list(delete_from_list(IP, L, []))};
handle({i_want, File, IP}, State) -> 
	%print([{File, IP}, State]),
	case already_in(File, IP, State) of
		false ->
			State1 = dict:append(File, IP, State),
			{ok, L} = dict:find(File, State1),
			{L , State1};
		true ->
			{ok, L} = dict:find(File, State),
			{L , State}
	end.


already_in(Key, Value, Dict) ->
	case dict:find(Key, Dict) of
		{ok, L} ->
			value_in_list(Value, L);
		error ->
			false
	end.

delete_from_list(_IP, [], R) -> lists:reverse(R);
delete_from_list(IP, [H|T], R) ->
	{X , L} = H,
	L1 = lists:delete(IP, L) ,
	delete_from_list(IP, T, [{X, L1}|R]).
	
value_in_list(_,[]) -> false;
value_in_list(Value, [H|_T]) when Value == H -> true;
value_in_list(Value, [_H|T]) -> value_in_list(Value, T).
 

print(X) ->
   io:format("~p~n",[X]).