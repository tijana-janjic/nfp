-module(proba).
-compile(export_all).

f() -> 
    receive
        {From, X} -> From ! {X}
    end.

posaljiPoruke([H1], [H2]) -> H1 ! {self(), H2};
posaljiPoruke([H1|T1], [H2|T2]) -> H1 ! {self(), H2}, posaljiPoruke(T1, T2).

primiPoruke(L) -> 
    receive
        {X} -> primiPoruke([X|L])
        after 100 -> L
    end.

funkcija() -> 
    L = lists:seq(1,25),
    Pids = [spawn(fun() -> f() end) || X <- L ],
    posaljiPoruke(Pids, L),
    Lista = primiPoruke([]).



