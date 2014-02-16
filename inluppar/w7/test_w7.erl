-module(test_w7).
-compile(export_all).

t1() ->
	[{port, 200}, {timer, 200}] = w7:get_config("config.txt", [{port, 400}, {timer, 200}]),
	awesome.
	
t2() ->
	[{1,<<"{port,200}.\r\n">>},
	{2,<<"{hostname,\"www.goole.com\"}.\r\n">>},
	{3,<<"{interval,10}.">>}] = w7:read_and_number_lines("config.txt"),
	 good.
	 
