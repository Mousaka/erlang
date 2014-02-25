-module(country).
-compile(export_all).

start_ETS() ->
	ETS = ets:new(country_codes, [set, named_table]),
	read_data(ETS, "country_codes.txt"),
	ETS.
	
read_data(ETS, File) ->
	{ok, L} = file:consult(File),
	insert(ETS, L).
	
insert(_ETS, []) -> ok;
insert(ETS, [H|T]) ->
	B = ets:insert(ETS, H),
	print([ETS, H, B]),
	insert(ETS, T).

lookup(ETS, Code) ->
	case ets:lookup(ETS, Code) of
		[] -> error;
		[X] -> X
	end.

time_make_rand_DETS() ->
	{X,_} = timer:tc(country, make_rand_DETS, []),
	print(["Time in sec", X/1000000]).
	
make_rand_DETS() ->

	{ok, DETS} = dets:open_file(rand_table, [{type, bag}]),
	N = 1000000,
	make_rand_DETS(DETS, N).
	
make_rand_DETS(_DETS, 0) -> done;
make_rand_DETS(DETS, N) ->
	dets:insert(DETS, rand_tuple()),
	make_rand_DETS(DETS, N-1).
	
rand_tuple() ->
	{random_name(), random_phone()}.
	
random_name() ->
	N = crypto:rand_uniform(4, 10),
	random_name(N,[]).

random_name(0, R) -> [crypto:rand_uniform(65,91)|R];
random_name(N, R) ->
	random_name(N-1, [crypto:rand_uniform(97, 123)|R]).
	
random_phone() ->
	N = crypto:rand_uniform(6,13),
	random_phone(N, []).
	
random_phone(0, R) ->
	R;
random_phone(N, R) ->
	random_phone(N-1, [crypto:rand_uniform(48, 58)|R]).
	
	
print(X) ->
   io:format("~p~n",[X]).