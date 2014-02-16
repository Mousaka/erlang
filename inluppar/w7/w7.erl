-module(w7).
-compile(export_all).

file_to_list(File) ->
	{ok, Bin} = file:read_file(File),
	binary_to_list(Bin).
	
read_and_number_lines(File) ->
	Text = file_to_list(File),
	make_row_tuples(1, Text, [], []).
	
make_row_tuples(N, "\n"++T, R, BigR) ->
	make_row_tuples(N+1, T, [], [{N, list_to_binary(lists:reverse("\n"++R))}|BigR]);
	
make_row_tuples(N, [H|T], R, BigR) ->
	make_row_tuples(N, T, [H|R], BigR);

make_row_tuples(N, [], R, BigR) ->
	lists:reverse([{N, list_to_binary(lists:reverse(R))}|BigR]).
	

	
get_config(F, Args) -> 
	L = consult(F),
	get_config(L, Args, []).
	

get_config(_, [], R) ->
	lists:reverse(R);
	
get_config(L, [Tuple|T],  R) ->
	Term = match(L, Tuple),
	get_config(L, T, [Term|R]).
	
match([], {Key, Value}) ->
	{Key, Value}; %default value returned
	
match([{K, V}|_], {Key, _}) when K == Key ->
	{K,V};

match([_|T], Tuple) ->
	match(T, Tuple).

consult(File) ->
	{ok, L} = file:consult(File),
	L.
	
list_dir(Dir) ->
	{ok, L} = file:list_dir(Dir),
	make_file_tuples(L, []).
	
make_file_tuples([], R) ->
	lists:reverse(R);
make_file_tuples([H|T], R) ->
	case filelib:is_dir(H) of 
		false ->
			make_file_tuples(T, [{file, H, filelib:file_size(H)}|R]);
		true ->
			 make_file_tuples(T, [{dir, H}|R])
	end.
	
	
	