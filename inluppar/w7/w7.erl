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
	
reverse_bytes(File) ->
	Len = filelib:file_size(File),
	{ok, S} = file:open(File, [read, binary, raw]),
	{ok, Bin} = file:pread(S, 0, Len),
	Reversed = binary:list_to_bin(lists:reverse(binary:bin_to_list(Bin))),
	file:close(S),
	{ok, W} = file:open(File, [write, binary, raw]),
	file:pwrite(W, 0 , Reversed),
	file:close(W).	

compute_digest(File, Blocksize) ->
	Len = filelib:file_size(File),
	X = {size, Len, blocksize, Blocksize, cheksums, make_blocks(0, File, Blocksize, [])},
	{ok, S} = file:open(File ++ ".digest", [write]),
	io:format(S, "~p.~n", [X]),
	file:close(S).
	
check_digest(File) ->
	[L] = consult(File++".digest"),
	{_, _, blocksize, Blocksize, _ , _} = L,
	Len = filelib:file_size(File),
	X = {size, Len, blocksize, Blocksize, cheksums, make_blocks(0, File, Blocksize, [])},
	
	case X==L of
		true ->
			checks_out;
		false ->
			wrong_file
	end.
	
make_blocks(N, File, Blocksize, R) ->
	Len = filelib:file_size(File),
	case N+1>Len of
		false ->
			{ok, S} = file:open(File, [read, binary, raw]),
			{ok, Bin} = file:pread(S, N, Blocksize),
			file:close(S),
			make_blocks(N+Blocksize, File, Blocksize,[erlang:md5(Bin)|R]);
		true ->
			R
	end.
		
print(X) ->
   io:format("~p~n",[X]).