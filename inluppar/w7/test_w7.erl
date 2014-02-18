-module(test_w7).
-compile(export_all).

t3() ->
	[{port, 200}, {timer, 200}] = w7:get_config("config.txt", [{port, 400}, {timer, 200}]),
	awesome.
	
t4() ->
	[{1,<<"{port,200}.\r\n">>},
	{2,<<"{hostname,\"www.goole.com\"}.\r\n">>},
	{3,<<"{interval,10}.">>}] = w7:read_and_number_lines("config.txt"),
	 good.
	 
t6() ->
	file:write_file("abc", <<"12345">>),
	w7:reverse_bytes("abc"),
	
	{ok, B} = file:open("abc", [read, raw, binary]),
	Len = filelib:file_size("abc"),
	{ok, <<"54321">>} = file:pread(B, 0, Len),
	yay.
	
t8() ->
	file:delete("inbox"),
	Msg = {email, "Krill", "Jozef", "Hej snygging!"},
	
	udp_test:start_server(),
	
	udp_test:client(Msg),
	sleep(),
	[Msg] = w7:consult("inbox"),
	
	success.
	
	
sleep() ->
	receive
		after 500 ->
			true
	end.