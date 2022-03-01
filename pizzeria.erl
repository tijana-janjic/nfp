-module(pizzeria).
-export([open/0, close/0, order/1, where_is_my_pizza/0]).

cook(margherita) -> timer:sleep(500),
                    io:format("~p: Margherita is ready!\n", [self()]);

cook(calzone) ->    timer:sleep(600),
                    io:format("~p: Calzone is ready!\n", [self()]).

pizzeria(Orders) ->
    receive
        {order, Client, Pizza} when (Pizza == calzone orelse Pizza == margherita)->
            {_, Ref} = spawn_monitor(fun() -> cook(Pizza) end),
            pizzeria([{Ref, Client, Pizza}|Orders]);
        {order, _, _} -> 
            io:format("That's not on menu!\n"),
            pizzeria(Orders);
        {'DOWN', Ref, _, _, _} ->
            Client = element(2, element(2, lists:keysearch(Ref, 1, Orders))),
            Pizza  = element(3, element(2, lists:keysearch(Ref, 1, Orders))),
            Client ! {delivered, Pizza},
            pizzeria(lists:delete({Ref, Client, Pizza}, Orders));
        {what_takes_so_long, Client} ->
            Cooking = lists:keymember(Client, 2, Orders),
            if
                Cooking ->
                    Pizza = element(3, element(2, lists:keysearch(Client, 2, Orders))),
                    Client ! {cooking, Pizza};
                true -> Client ! nothing_was_ordered
            end,
            pizzeria(Orders);
        close -> closed
    end.

open() ->
    Pid = spawn(fun() -> pizzeria([]) end),
    io:format("Pizzeria (~p) is open!\n", [Pid]),
    register(pizzeria, Pid).

close() ->
    pizzeria ! close,
    io:format("~p: Pizzeria is closed!\n", [self()]), 
    close.

order(Pizza) when not is_atom(Pizza) -> invalidOrder;
order(Pizza) ->
    pizzeria ! {order, self(), Pizza},
    io:format("~p: I ordered ~w!\n", [self(), Pizza]).

where_is_my_pizza() ->
    pizzeria ! {what_takes_so_long, self()}.
