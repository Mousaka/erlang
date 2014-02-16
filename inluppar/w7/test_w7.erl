-module(test_w7).
-compile(export_all).

t1() ->
	[{port, 200}, {timer, 200}] = w7:get_config("config.txt", [{port, 400}, {timer, 200}]),
	awesome.