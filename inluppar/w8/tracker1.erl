-module(client).
-compile(export_all).

start() -> gen_tracker:start(client, 0).

tick(N) -> gen_tracker:rpc(client, {tick, N}).
read() -> gen_tracker:rpc(client, read).
clear() -> gen_tracker:rpc(client, clear).

handle({tick, N}, State) -> {ack, State+N};
handle(read, State) -> {State, State};
handle(clear,_) -> {ok, 0}.