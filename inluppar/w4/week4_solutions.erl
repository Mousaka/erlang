-module(week4_solutions).
-export([rotate/2,factorial/1,expand_markup/1,count_atoms/2]).

rotate(_, []) -> [];
rotate(0, L) -> L;
rotate(N, L) -> 
	[H|T] = L,
	N1 = N rem length(L),
	if
		N > 0 ->
			rotate(N1-1, T++[H]);
		N < 0 ->
			rotate(N1+length(L), L)
	end.
	
factorial(1) -> 1;
factorial(N) -> 
	N * factorial(N-1).
	
count_atoms(_,[]) -> 0;
	
count_atoms(A, L) when is_tuple(L)->
	L1 = tuple_to_list(L),
	count_atoms(A, L1);
	
count_atoms(A, A) ->
	1;
	
count_atoms(A, [H|T]) ->
	count_atoms(A, H) + count_atoms(A, T);

count_atoms(_, _) -> 0.
	

expand_markup([]) -> '';
expand_markup(L) ->
	exp_help(L, 0,0, []).
	
exp_help([], _, _, R) -> lists:reverse(R);
exp_help([42,42|T], 0, 0, R) ->
	exp_help(T, 1, 0, [$>,$b,$<|R]);
	
exp_help([42,42|T], 0, 1, R) ->
	exp_help(T, 1, 2, [$>,$b,$<|R]);
	
exp_help([42,42|T], 2, 1, R) ->
	exp_help(T, 0, 1, [$>,$i,$<,$>,$b,$/,$<,$>,$i,$/,$<|R]);

exp_help([42,42|T], 1, 2, R) ->
	exp_help(T, 0, 1, [$>,$b,$/,$<|R]);

exp_help([42,42|T], 1, 0, R) ->
	exp_help(T, 0, 0, [$>,$b,$/,$<|R]);
	
exp_help([$_,$_|T], 0, 0, R) ->
	exp_help(T, 0, 1, [$>,$i,$<|R]);

exp_help([$_,$_|T], 1, 0, R) ->	
	exp_help(T, 2, 1, [$>,$i,$<|R]);
	
exp_help([$_,$_|T], 2, 1, R) ->	
	exp_help(T, 1, 0, [$>,$i,$/,$<|R]);
	
exp_help([$_,$_|T], 1, 2, R) ->	
	exp_help(T, 1, 0, [$>,$b,$<,$>,$i,$/,$<,$>,$b,$/,$<|R]);
	
exp_help([$_,$_|T], 0, 1, R) ->
	exp_help(T, 0, 0, [$>,$i,$/,$<|R]);
	
exp_help([H|T], Bo,It, R) ->
	exp_help(T, Bo,It, [H|R]).

	