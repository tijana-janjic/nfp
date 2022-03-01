-module(proizvodjaci).
-compile(export_all).

buffer(Curr, Bound) ->
    io:format("Buffer: ~w \n", [Curr]),
    receive
        {put, Pid} when (Curr + 1) =< Bound  -> Pid ! {ok}, buffer(Curr+1, Bound);
        {put, Pid} -> 
            receive 
                {take, _} -> Pid ! {ok}, buffer(Curr+1, Bound)
            end;
        {take, Pid} when (Curr - 1) >= 0 -> Pid ! {ok}, buffer(Curr-1, Bound);
        {take, Pid} ->
            receive 
                {put, _} -> Pid ! {ok}, buffer(Curr+1, Bound)
            end
    end.

producer() ->
    timer:sleep(rand:uniform(1000) +  1000),
    buffer ! {put, self()},
    receive
        {ok} -> producer();
        stop -> stopped
    end.


consumer() ->
    timer:sleep(rand:uniform(1000) +  1000),
    buffer ! {take, self()},
    receive
        {ok} -> consumer();
        stop -> stopped
    end.

problem(Nc, Np, Bound) ->
    Lc = lists:seq(0, Nc-1),
    Lp = lists:seq(0, Np-1),
    [spawn(?MODULE, consumer, []) || Y <- Lc],
    [spawn(?MODULE, producer, []) || Y <- Lp],
    Buffer = spawn(?MODULE, buffer, [0, Bound]),
    register(buffer, Buffer).
