-module(filozofi).
-compile(export_all).

filozof(Id) ->
    misli(),
    uzmi_viljuske(Id),
    jedi(),
    vrati_viljuske(Id),
    filozof(Id).

misli() ->  io:format("ja (~p) mislim!\n", [self()]),
            timer:sleep(rand:uniform(10000) +  1000),
            io:format("ja (~p) sam gladan!\n", [self()]).

jedi() ->   io:format("ja (~p) jedem!\n", [self()]),
            timer:sleep(rand:uniform(10000) + 1000),
            io:format("ja (~p) sam sit!\n", [self()]).


uzmi_viljuske(Id) ->
                        konobar ! {self(), Id, take},
                        receive
                            {hereYouGo} -> io:format("ja (~p) sam uzeo viljuske!\n", [self()]);
                            {alreadyTaken} -> uzmi_viljuske(Id)
                        end.

vrati_viljuske(Id) ->  konobar ! {self(), Id, put},
                            io:format("ja (~p) sam vratio viljuske!\n", [self()]).

konobar(Zauzete, Broj) ->
    receive
        {Pid, Pos, take} -> daj(Pid, Pos, Zauzete, Broj);
        {_, Pos, put} -> oslobodi(Pos, Zauzete, Broj)
    end.


daj(Pid, Pos, Zauzete, Broj) ->
    Taken = taken(Pos, Zauzete, Broj),
    if
        Taken -> Pid ! {alreadyTaken}, konobar(Zauzete, Broj);
        true -> Pid ! {hereYouGo}, io:format("Jedu: ~w!\n", [[Pos|Zauzete]]), konobar([Pos|Zauzete], Broj)
    end.

oslobodi(Pos, Zauzete, Broj) -> konobar(lists:delete(Pos, Zauzete), Broj).

taken(Pos, Zauzete, Broj) -> lists:member(left(Pos, Broj), Zauzete) or lists:member(right(Pos, Broj), Zauzete).

left(Pos, Broj) -> (Pos + Broj - 1) rem Broj.
right(Pos, Broj) -> (Pos + 1) rem Broj.

program(Broj) ->
    L = lists:seq(0, Broj-1),
    Konobar = spawn(fun() -> konobar([], Broj) end),
    register(konobar, Konobar),
    [spawn(?MODULE, filozof, [Y]) || Y <- L ]. % zavrsiti: pogasiti procese