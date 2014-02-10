-module(f7).
-compile(export_all).

start_and_watch() ->
	Pid = bar:start(),