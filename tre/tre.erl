-module(tre).
-compile(export_all).




doList([H|T]) ->
	blip.
	


match(<<A, T2/binary>>, <<A,T/binary>>) ->
	case T2 of
		<<>> -> no;
		Any -> match(T2, T)
	end;
	
match(_A, _B) -> 
	yes.