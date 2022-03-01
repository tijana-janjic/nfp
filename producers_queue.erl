-module(producers_queue).
-export([run/3, stop/0]).

buffer(Bound, Items, WaitingProducers, WaitingConsumers) ->
    io:format(" Buffer: ~w \n Producers: ~w \n Consumers: ~w \n\n", [Items, WaitingProducers, WaitingConsumers]),
    Curr = length(Items),
    receive
        {put, _, Producer} when Curr == Bound -> 
            Producer ! waitForSpace,  
            buffer(Bound, Items, [Producer|WaitingProducers], WaitingConsumers);

        {put, Item, Producer} when Curr < Bound-> 
            Producer ! ok,  
            tellCosumer(WaitingConsumers),
            buffer(Bound, putAtEnd(Item, Items), WaitingProducers, withoutLastOne(WaitingConsumers));
        
        {take, Consumer} when Curr == 0 -> 
            Consumer ! waitForItem, 
            buffer(Bound, Items, WaitingProducers, [Consumer|WaitingConsumers]);

        {take, Consumer} when Curr > 0 -> 
            [Item|OtherItems] = Items, 
            Consumer ! {ok, Item},
            tellProducer(WaitingProducers),
            buffer(Bound, OtherItems, withoutLastOne(WaitingProducers), WaitingConsumers);
        
        stop -> 
            io:format("I killed waiting processes: ~w\n", [WaitingProducers++WaitingConsumers]),
            killWaiting(WaitingProducers ++ WaitingConsumers), 
            kill(), 
            io:format("End!\n", [])
    end.

putAtEnd(Item, L) -> L ++ [Item].

withoutLastOne([]) -> [];
withoutLastOne(List) -> lists:droplast(List).

tellProducer([]) -> noOneIsWaiting; 
tellProducer(WaitingProducers) -> 
            Producer = lists:last(WaitingProducers),
            Producer ! nowYouCanProduce.

tellCosumer([]) -> noOneIsWaiting; 
tellCosumer(WaitingConsumers) -> 
            Consumer = lists:last(WaitingConsumers),
            Consumer ! nowYouCanConsume.

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
            io:format("~p I put item ~w into buffer.\n", [self(), Item]),       
            producer();
        waitForSpace ->
            io:format("~p: I have to wait for space...\n", [self()]), 
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
                nowYouCanConsume -> consumer()
            end
    end.

consume(Item) -> 
    io:format("~p I consumed item ~w.\n\n", [self(), Item]),
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

stop() -> buffer ! stop.