-module(printit).
-compile(export_all).



printit() ->  %timer:sleep(rand:uniform()),
    receive 
        {X} -> io:format(" ~w",[X])
    after 10000 -> gotovo 
    end.

f() -> 
    Pid = spawn(fun printit/0),
    receive 
        {X} -> Pid ! {X}
    after 1000 -> gotovo 
    end.

posaljiPoruke([H1], [H2]) -> H1 ! {self(), H2};
posaljiPoruke([H1|T1], [H2|T2]) -> H1 ! {self(), H2}, posaljiPoruke(T1, T2).

funkcija() -> 
    Pid1 = spawn(fun() -> f() end),
    Pid2 = spawn(fun() -> f() end),
    Pid3 = spawn(fun() -> f() end),
    Pid1 ! {lists:seq(1,40)},
    Pid2 ! {lists:seq(41, 80)},
    Pid3 ! {lists:seq(81, 120)}, ok.
