-module(f4).
-compile(export_all).

f1({do,X}, F) ->
	F(X);
f1([H|T], F) ->
	[f1(H,F) | f1(T,F)];
f1(T,F) when is_tuple(T) ->
	L = tuple_to_list(T),
	L1 = f1(L,F),
	list_to_tuple(L1);
f1(X,_) ->
	X.