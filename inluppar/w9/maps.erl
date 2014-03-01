-module(maps).
-compile(export_all).

%smap(F, L) -> [F(I) || I <- L].

smap(_, []) -> [];
smap(F, [H|T]) -> [F(H) | smap(F, T)].

pmap(F, L, W) -> 
	S = self(),
	N = length(L),
	
	
print(X) ->
    io:format("~p~n",[X]).