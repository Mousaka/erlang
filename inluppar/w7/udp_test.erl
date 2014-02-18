-module(udp_test).
-export([start_server/0, client/1]).

start_server() ->
    spawn(fun() -> server(2000) end).

%% The server 		  
server(Port) ->
    {ok, Socket} = gen_udp:open(Port, [binary]),
    io:format("server opened socket:~p~n",[Socket]),
    loop(Socket).

loop(Socket) ->
    receive
	{udp, Socket, Host, Port, Bin_crypted} = Msg ->
	    io:format("server received:~p~n",[Msg]),
		Bin = elib2_aes:decrypt("fiskmejl", Bin_crypted),
	    N = binary_to_term(Bin),
		store_email(N),
	    loop(Socket)

    end.

store_email(Msg) ->
		{email, From, Subject, Content} = Msg,
		{ok, S} = file:open("inbox", [append]),
		io:format(S, "~p.~n", [Msg]),
		file:close(S).
		
%% The client

client(Msg) ->
	{ok, Socket} = gen_udp:open(0, [binary]),
	io:format("client opened socket=~p~n", [Socket]),
	Bin = term_to_binary(Msg),
	Bin_crypt = elib2_aes:encrypt("fiskmejl", Bin),
	ok = gen_udp:send(Socket, "localhost", 2000, Bin_crypt),
	
	gen_udp:close(Socket).
	
    

