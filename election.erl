-module(election).
-compile(export_all).


start(Votes) ->
	register(elec, spawn(election, loop, [Votes, []])).
	


loop(Votes, Pids) ->
	receive
		{itsover, Pid} -> Pid ! Votes;
		{vote, Pid, Party} ->
			case lists:member(Pid, Pids) of
				true -> 
					Pid ! rejected,
					loop(Votes, Pids);
				false -> 
					Pid ! accepted,
					loop(update(Votes, Party), [Pid|Pids])
			end
		
	end.
					
					
update([H|T], Party) ->
	case H of
		{Party, Votes} -> [{Party, Votes+1}|T];
		Any -> [Any|update(T,Party)]
	end.
client(Pid, itsover) ->
	Pid ! {itsover, self()},
	receive
		Votes -> Votes
	end.
vote(Party) ->
	elec ! {vote, self(), Party},
	receive
		accepted -> accepted;
		rejected -> rejected
	end.
