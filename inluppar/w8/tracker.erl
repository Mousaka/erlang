-module(tracker).
-compile(export_all).

start() -> 
	
	gen_server:start_link({local, gen_tracker}, tracker, {[], dict:new()}, []).
	
	%print(["hm"]),
	%%loop().

%%loop() ->              Förstår inte hur man ska lösa ping-grejen!!!
%%	sleep(1000),
%%	print([ping]),
%%	gen_server:call(gen_tracker, {i_want, file, "123"}),
%%	loop().
	
read() -> gen_server:call(gen_tracker, read).
init(N) ->
	{ok, N}.

	
i_want(File, IP) -> gen_server:call(gen_tracker, {i_want, File, IP}).
i_am_leaving(IP) -> gen_server:call(gen_tracker, {leaving, IP}).
who_wants(File) -> gen_server:call(gen_tracker, {who_wants, File}).
ping(IP) -> gen_server:call(gen_tracker, {ping, IP}).

handle_cast(Msg, State) ->
	{noreply, State}.

handle_call(read, _From, {Active,State}) -> {reply, {Active,State}, {Active,State}};
handle_call({who_wants, File}, _From, {Active,State}) ->
%	print(["In who wants", dict:find(File, State)]),
	case dict:find(File, State) of
		{ok, L} ->	{reply, L, {Active,State}};
		error -> {reply,[], {Active,State}}
	end;
handle_call({leaving, IP}, _From, {Active,State}) ->
	
	L = dict:to_list(State),
	X =  dict:from_list(delete_from_list(IP, L, [])),
	Active1 = lists:delete(IP, Active),
	%print([leaving, X]),
	{reply, ok, {Active1, X}};
	
handle_call({i_want, File, IP}, _From, {Active,State}) -> 
	%print([{File, IP}, State]),
	case already_in(File, IP, State) of
		false ->
			State1 = dict:append(File, IP, State),
			{ok, L} = dict:find(File, State1),
			{reply, L , {[IP,Active],State1}};
		true ->
			{ok, L} = dict:find(File, State),
			{reply, L , {Active,State}}
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
 
sleep(X) ->
	receive
		after X ->
			true
	end.
print(X) ->
   io:format("~p~n",[X]).