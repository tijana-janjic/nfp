-module(producers).
-export([run/3, stop/0]).

buffer(Bound, Items, WaitingProducers, WaitingConsumers) ->
    Curr = length(Items),
            io:format(" Buffer: ~w \n Producers: ~w \n Consumers: ~w \n", [Items, WaitingProducers, WaitingConsumers]),

    receive

        {put, _, Producer} when Curr == Bound -> 
            Producer ! waitForSpace,  
            AlreadyIn = lists:member(Producer,WaitingProducers),
            if 
                AlreadyIn -> buffer(Bound, Items, WaitingProducers, WaitingConsumers);
                true -> buffer(Bound, Items, WaitingProducers ++ [Producer], WaitingConsumers)
            end;

        {put, Item, Producer} when Curr < Bound -> 
            CurrItems = putAtEnd(Item, Items),
            Producer ! ok,  
            if 
                WaitingConsumers == [] ->
                    buffer(Bound, CurrItems, WaitingProducers, WaitingConsumers);
                true -> 
                    Consumer = tellCosumers(WaitingConsumers),
                    io:format(" --- consumer: ~w\n", [Consumer]),
                    buffer(Bound, CurrItems, WaitingProducers, lists:delete(Consumer, WaitingConsumers)) % izbaciti Consumer-a
            end;

        {take, Consumer} when Curr == 0 -> 
            Consumer ! waitForItem, 
            AlreadyIn = lists:member(Consumer, WaitingConsumers),
            if 
                AlreadyIn -> buffer(Bound, Items, WaitingProducers, WaitingConsumers);
                true -> buffer(Bound, Items, WaitingProducers, WaitingConsumers ++ [Consumer])
            end;

        {take, Consumer} when Curr > 0 -> 
            [Item|OtherItems] = Items, 
            Consumer ! {ok, Item}, 
            if
                WaitingProducers == [] -> 
                    buffer(Bound, OtherItems, WaitingProducers, WaitingConsumers);
                true ->
                    Producer = tellProducers(WaitingProducers),
                    io:format("Producer: ~w\n", [Producer]),
                    buffer(Bound, OtherItems, lists:delete(Producer, WaitingProducers), WaitingConsumers) % izbaciti Producer-a
            end;

        stop -> 
            io:format("I'm killing waiting processes: ~w\n", [WaitingProducers++WaitingConsumers]),
            killWaiting(WaitingProducers ++ WaitingConsumers), 
            kill(), 
            io:format("End!\n", [])
    end.



putAtEnd(Item, []) -> [Item];
putAtEnd(Item, [H|T]) -> [H|putAtEnd(Item, T)].

killWaiting([]) -> ok;
killWaiting([Curr|Processes]) -> exit(Curr, normal), killWaiting(Processes).

kill() -> 
    receive
        {put, _, Producer} -> 
            io:format("~w: Goodbye!\n", [Producer]), exit(Producer, normal), kill();
        {take, Consumer} -> 
            io:format("~w: Goodbye!\n", [Consumer]), exit(Consumer, normal), kill()
    after 4000 -> stopped
    end.

tellProducers([]) -> 
    receive
        {Pid, put_in_buffer} -> Pid
    end; 
tellProducers([H|T]) -> 
            H ! nowYouCanProduce,
            tellProducers(T).

tellCosumers([]) -> 
    receive
        {Pid, taken} -> Pid
    end; 
tellCosumers([H|T]) -> 
            H ! nowYouCanConsume,
            tellCosumers(T).

producer() ->
    Item = produce(), 
    put_in_buffer(Item).

produce() ->
    timer:sleep(rand:uniform(1000) + 2500),
    Item = rand:uniform(1000),            
    io:format("~p I produced item ~w.~n", [self(), Item]), 
    Item.

put_in_buffer(Item) -> 
    buffer ! {put, Item, self()},
    receive
        ok ->             
            io:format("\n~p I put item ~w into buffer.\n", [self(), Item]),
            buffer ! {self(), put_in_buffer},
            producer();
        waitForSpace ->
        io:format("\n~p: I have to wait for space...\n", [self()]), 
            receive
                nowYouCanProduce -> put_in_buffer(Item);
                stop -> stopped
            end;
        stop -> stopped
    end.

consumer() ->
    buffer ! {take, self()},
    receive
        {ok, Item} -> consume(Item), consumer();
        waitForItem -> 
            io:format("~p: I have to wait for item...\n\n", [self()]), 
            receive
                nowYouCanConsume -> buffer ! {self(), taken}, consumer()
            end
    end.

consume(Item) -> 
    io:format("~p I am consuming item ~w.\n\n", [self(), Item]),
    timer:sleep(rand:uniform(1000) + 2500).


run(0, _, _) -> io:format("Number of consumers must be greater than 0!\n");
run(_, 0, _) -> io:format("Number of producers must be greater than 0!\n");
run(_, _, 0) -> io:format("Size of buffer must be greater than 0!\n");
run(Np, Nc, Bound)  ->
    Lp = lists:seq(0, Np-1),
    Lc = lists:seq(0, Nc-1),
    Buffer = spawn(fun() -> buffer(Bound, [], [], []) end), 
% gornja granica, itemi u baferu, proizvodjaci koji cekaju, potrosaci koji cekaju
    register(buffer, Buffer),
    [spawn(fun() -> producer() end) || _ <- Lp],
    [spawn(fun() -> consumer() end) || _ <- Lc],
    start.

stop() -> buffer ! stop.