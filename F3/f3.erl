-module(f3).
-compile(export_all).

blaa(X) ->
	case X of
		{a, P} ->
			P + 2;
		{b, Q} ->
			Q*10
	end.
			
			
%%Annat sätt att göra case:

blaa1(X) ->
	grump(X).
	
grump({a,P}) ->
	P + 2;
grump({b,Q}) ->
	Q * 10.
	
%% if expressions: Har alltid ett värde till skillnad från andra språk!!!

weekday(Day) -> 
	if
		Day ==  monday ->
			true;
		Day == sunday ->
			true;
		true ->
			false
	end.	
	
 %%returns a function!
double() ->
	fun(N) ->
		N * 2
	end.
	
%%for-loop!!
for(Max, Max, F) -> [F(Max)];
for(I, Max, F) -> [F(I) | for(I+1, Max, F)].

%Summa
sum([]) -> 0;
sum([H|T]) -> H + sum(T).

%%svansrekursiv
sum2(L) -> sum_helper(L,0).
sum_helper([],N) -> N;
sum_helper([H|T], N) -> N1 = N + H, sum_helper(T,N1).

rev(L) -> rev(L,[]).
rev([], L) -> L;
rev([H|T], L) -> rev(T,[H|L]).
		



%% ||  betyder "such as"










6