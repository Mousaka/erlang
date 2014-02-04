-module(f5).
-compile(export_all).

f(X, Y) ->
	X + Y.
	
	
	
rmv_atindex(1, [_|T]) -> T;
rmv_atindex(I, [H|T]) -> [H| rmv_atindex(I-1, T)];
rmv_atindex(_,[]) -> throw(indexOutofBounds).