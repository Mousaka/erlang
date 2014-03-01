-module(tracker).

-export([start/0, init/1, i_want/2, i_am_leaving/1, who_wants/1, handle_call/3, ping/1]).

start() ->
	Dict = dict:new(),
	gen_server:start_link({local, tracker}, tracker, Dict, []).

init(Dict) -> {ok, Dict}.

i_want(File, IP) ->
	ping(IP),
	gen_server:call(tracker, {i_want, File, IP}).

i_am_leaving(IP) ->
	case whereis(list_to_atom(IP)) of
		undefined ->
			'not registered';
		Pid ->
			exit(Pid, kill)
		end,
	gen_server:call(tracker, {i_am_leaving, IP}).

who_wants(File) ->
	gen_server:call(tracker, {who_wants, File}).

ping(IP) ->
	gen_server:call(tracker, {ping, IP}).

handle_call({i_want, File, IP}, _From, Dict) ->
	case dict:find(File, Dict) of
		{ok, L} ->
			L1 = [IP|lists:delete(IP, L)],
			NewDict = dict:store(File, L1, Dict);
		error ->
			NewDict = dict:append(File, IP, Dict)
	end,
	case dict:find(File, NewDict) of
		{ok, Result} ->
			{reply, Result, NewDict};
		error ->
			{reply, [], NewDict}
	end;

handle_call({i_am_leaving, IP}, _From, Dict) ->
	F = fun(_,V) -> lists:delete(IP, V) end,
	NewDict = dict:map(F, Dict),
	{reply, ok, NewDict};

handle_call({who_wants, File}, _From, Dict) ->
	case dict:find(File, Dict) of
		{ok, Result} ->
			{reply, Result, Dict};
		error ->
			{reply, [], Dict}
	end;	

handle_call({ping, IP}, _From, Dict) ->
	case whereis(list_to_atom(IP)) of
		undefined ->
			register(list_to_atom(IP), spawn(fun() -> handle_connected(IP) end));
		_ ->
			list_to_atom(IP) ! {ping}
	end,
	{reply, ok, Dict}.

handle_connected(IP) ->
	receive
		{ping} ->
			io:format("ping!~n"),
			handle_connected(IP)
	after 
		10000 ->
		io:format("ping timeout~n"),
		gen_server:call(tracker, {i_am_leaving, IP})
	end.


