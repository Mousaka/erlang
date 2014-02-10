-module(d_client).
-compile(export_all).

start() ->
	spawn(d_client, loop, [10]).
	

loop(0) -> crasher:print(done);
loop(N) ->
	X = request(N),
	crasher:print(X),
	loop(N-1).
	

	
request(N) ->
	request(N,10).
request(N,0) ->
	noresponsefromserver;
request(N,Tries) ->
	R = crypto:rand_uniform(500,2000),
	try 
		double ! {self(), N},
		receive
			{From, D} ->
				D
		end
	catch
		error:_ ->
			crasher:sleep(R),
			crasher:print(["Reconnecting.."]),
			request(N, Tries-1)
	end.
