-module(tenta).
-compile(export_all).


people(L) ->
	[ {N,O,A} || {N,O,A} <- L, A > 50, A < 59].
	
	
deleteif([], F) -> [];

deleteif([H|T], F) ->
	case F(H) of
		false -> [H|deleteif(T, F)];
		true -> deleteif(T, F)
	end.