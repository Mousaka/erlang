-module(ops).
-export([pow/2]).

mul(X, Y) ->
	X * Y.

pow(_, 0) ->    %%_ dont care about value
	1;
pow(X, N) ->
	mul(X, pow(X, N - 1)).