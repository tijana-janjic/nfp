-module(sesija6).
-compile(export_all).


ping() -> io:format( "~p~n", [self()]),
    Pid = spawn(?MODULE, pong, []), Pid ! {0, self()},
    primiPoruke(Pid),
    Pid ! stop.
    

primiPoruke(Pid) -> 
    receive
        {X} when X < 6 -> Pid ! {X+1, self()}, io:format( "---~p~p~n", [Pid,X]), primiPoruke(Pid)
    after 1000 -> bilosta
    end.

pong() ->
    receive
        {X, From} ->  io:format( "~p~n", [X]), From ! {X+1}, pong();
        stop -> exit
    end.

funkcija() -> L = lists:seq(1, 28, 2), pmap(L, fun sub1/1).

pmap(L, F) -> 
    map(L, F),
    Length = length(L),
    io:format("duzina: ~w~n", [Length]),
    primiPoruke([], Length).

map([], _) -> [];
map([H|T], F) -> Pid = self(), [spawn(fun() -> worker(F, H, Pid) end) | map(T, F)].
    
worker(F, E, Pid) -> timer:sleep(10), Pid ! F(E). 

sub1(X) -> [X, X-1].

primiPoruke(L, 0) -> L;
primiPoruke(L, Br) -> 
    receive
        X -> primiPoruke(X ++ L, Br-1)
    end.



