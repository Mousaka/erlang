-module(week4_solutions2).
-compile(export_all).

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
count_atoms(A,L) -> 
	L1 = tuple_to_list(L),
	grump(A,L1).



grump(A, L) when is_tuple(L)->
	L1 = tuple_to_list(L),
	grump(A, L1);
	
grump(A, A) ->
	1;
	
grump(A, [H|T]) ->
	count_atoms(A, H) + count_atoms(A, T);

grump(_, _) ->
	0.
	

