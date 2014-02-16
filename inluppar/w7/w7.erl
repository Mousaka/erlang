-module(w7).
-compile(export_all).

file_to_list(File) ->
	{ok, Bin} = file:read_file(File),
	binary_to_list(Bin).
	
	
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
	
	