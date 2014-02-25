-module(test_w8).
-compile(export_all).

test_6()->
	{ok, _} = tracker:start(),
	sleep(),
	["123.45.1.45"] = tracker:i_want(file1, "123.45.1.45"),
	sleep(),
	["123.45.1.45", "223.45.12.145"] = tracker:i_want(file1, "223.45.12.145"),
	sleep(),
	[] = tracker:who_wants(file2),
	["123.45.1.45", "223.45.12.145"] = tracker:who_wants(file1),
	tracker:i_want(file3, "123.45.1.45"),
	
	ok = tracker:i_am_leaving("123.45.1.45"),
	["223.45.12.145"] = tracker:who_wants(file1),
	
	yay.
	
	
	
sleep() ->
	receive
		after 200 ->
			true
	end.