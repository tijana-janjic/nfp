-module(fil).
-compile(export_all).

filozof(Id) ->
    misli(Id),
    uzmi_viljuske(Id),
    jedi(Id),
    vrati_viljuske(Id),
    filozof(Id).

misli(Id) ->  io:format("~p: Ja mislim!\n", [Id]),
            timer:sleep(rand:uniform(10000) +  1000),
            io:format("~p: Ja sam gladan!\n", [Id]).

jedi(Id) ->   io:format("~p: Ja jedem!\n", [Id]),
            timer:sleep(rand:uniform(10000) + 1000),
            io:format("~p: Ja sam sit!\n", [Id]).


uzmi_viljuske(Id) ->
                        konobar ! {self(), Id, take},
                        receive
                            hereYouGo -> io:format("~p: Ja sam uzeo viljuske!\n", [Id]);
                            alreadyTaken -> uzmi_viljuske(Id);
                            stop -> io:format("~p: iskljucen!\n", [Id]), exit(normal)
                        end.

vrati_viljuske(Id) ->  konobar ! {self(), Id, put},
                            io:format("~p: Ja sam vratio viljuske!\n", [Id]).

konobar(Filozofi, Zauzete, Broj) ->
    receive
        {Pid, Id, take} -> daj(Filozofi, Pid, Id, Zauzete, Broj);
        {_, Id, put} -> oslobodi(Filozofi, Id, Zauzete, Broj);
        stop -> zaustavi(Filozofi), 
                        io:format("Konobar ~p: Svi filozofi su otisli, idem i ja!\n", [self()]), 
                        exit(normal)
    end.


zaustavi([]) -> filozofiSuOtisli;
zaustavi(Filozofi) ->
    receive
        {Pid, _, _}  -> Pid ! stop, zaustavi(lists:delete(Pid, Filozofi))
    end.

daj(Filozofi, Pid, Id, Zauzete, Broj) ->
    Taken = taken(Id, Zauzete, Broj),
    if
        Taken -> Pid ! alreadyTaken, konobar(Filozofi, Zauzete, Broj);
        true -> Pid ! hereYouGo, io:format("Jedu: ~w!\n", [[Id|Zauzete]]), konobar(Filozofi, [Id|Zauzete], Broj)
    end.

oslobodi(Filozofi, Id, Zauzete, Broj) -> konobar(Filozofi, lists:delete(Id, Zauzete), Broj).

taken(Id, Zauzete, Broj) -> lists:member(left(Id, Broj), Zauzete) or lists:member(right(Id, Broj), Zauzete).

left(Id, Broj) -> (Id + Broj - 1) rem Broj.
right(Id, Broj) -> (Id + 1) rem Broj.

problem(Broj) ->
    Ids = lists:seq(0, Broj-1),
    Filozofi = [spawn(?MODULE, filozof, [Id]) || Id <- Ids],
    Konobar = spawn(fun() -> konobar(Filozofi, [], Broj) end),
    register(konobar, Konobar).

stop() -> konobar ! stop, zatvaranje.