-module(week4_solutions).
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
	
count_atoms(A,X) -> 
	L = tuple_to_list(X),
	count_atoms(A,L,0).

count_atoms(_,[],N) -> N;
count_atoms(A, L, N) ->
	grump(A, L, N).

grump(A, L, N) when is_tuple(L)->
	L1 = tuple_to_list(L),
	grump(A, L1, N);
	
grump(A, A, N) ->
	N+1;
	
grump(A, [H|T], N) ->
	count_atoms(A, H, N) + count_atoms(A, T, 0);

grump(_, _, _) ->
	0.
	

