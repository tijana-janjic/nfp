-module(philosophers).
-export([pokreni/1, stop/0]).

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
                        konobar ! {take, self(), Id},
                        receive
                            hereYouGo -> io:format("~p: Ja sam uzeo viljuske!\n", [Id]);
                            alreadyTaken -> uzmi_viljuske(Id);
                            stop -> io:format("~p: iskljucen!\n", [Id]), exit(normal)
                        end.

vrati_viljuske(Id) ->  konobar ! {put, self(), Id},
                            io:format("~p: Ja sam vratio viljuske!\n", [Id]).

konobar(Zauzete, Broj) ->
    receive
        {take, Pid, Id} -> dodeli(Pid, Id, Zauzete, Broj);
        {put, _, Id} -> oslobodi(Id, Zauzete, Broj);
        stop -> zaustavi(), io:format("Konobar ~p: Svi filozofi su otisli, idem i ja!\n", [self()])
    end.

dodeli(Pid, Id, Zauzete, Broj) ->
    Taken = taken(Id, Zauzete, Broj),
    if
        Taken -> Pid ! alreadyTaken, konobar(Zauzete, Broj);
        true -> Pid ! hereYouGo, io:format("Jedu: ~w!\n", [[Id|Zauzete]]), konobar([Id|Zauzete], Broj)
    end.

oslobodi(Id, Zauzete, Broj) -> konobar(lists:delete(Id, Zauzete), Broj).

taken(Id, Zauzete, Broj) -> lists:member(left(Id, Broj), Zauzete) or lists:member(right(Id, Broj), Zauzete).

left(Id, Broj) -> (Id + Broj - 1) rem Broj.

right(Id, Broj) -> (Id + 1) rem Broj.

zaustavi() ->
    receive
        {_, Pid, _}  -> Pid ! stop, zaustavi()
    after 20000 -> stopped
    end.

stop() -> konobar ! stop, zatvaranje.

pokreni(Broj) ->
    Ids = lists:seq(0, Broj-1),
    [spawn(fun() -> filozof(Id) end) || Id <- Ids],
    Konobar = spawn(fun() -> konobar([], Broj) end),
    register(konobar, Konobar).
