-module(sesija4).
-export([hanojske_kule/1, hanojske_kule/4, zameni/3, sadrziX/2, 
    fakt/1, rep_fakt/1, rep_fakt/2, fib/1, rep_fib/1, rep_fib/3, step/2, rep_step/2,
    broj_listi/1, je_lista/1, iste/2, nti_element/2, minEl/1, minEl/2, izbaci_prvu/2, izbaci_sve/2,
    je_element/2, podskup/2, sadrzi/2, jednaki/2, unija/2,
    nadr/2, nadr/3, nadrTuple/2, nadrTuple/3]).

%16. Resiti problem Hanojskih kula
% prenos sa a na b, gdje je c pomocni stap
hanojske_kule(N) -> hanojske_kule(N, a, b, c).

hanojske_kule(1, Sa, Na, _) -> io:fwrite("prebaciti sa ~w na ~w.\n",[Sa, Na]);
hanojske_kule(N, Sa, Na, Pom) -> hanojske_kule(N-1, Sa, Pom, Na), 
                                    io:fwrite("prebaciti sa ~w na ~w.\n", [Sa, Na]), 
                                    hanojske_kule(N-1, Pom, Na, Sa).


%17. Odabrati tri proizvoljna zadatka (a koji se resavaju rekurzijom) i svaki od njih
%    resiti 'prirodnom' rekurzijom i 'repnom' rekurzijom.
%Faktorijel
fakt(0) -> 1;
fakt(N) when N > 0 -> N * fakt(N - 1).

rep_fakt(N) -> rep_fakt(N, 1).

rep_fakt(0, Acc) -> Acc;
rep_fakt(N, Acc) when N > 0 -> rep_fakt(N - 1, N * Acc).

%Fibonaci
fib(0) -> 0;
fib(1) -> 1;
fib(N) when N > 1 -> fib(N - 2) + fib(N - 1).

rep_fib(0) -> 0;
rep_fib(1) -> 1;
rep_fib(N) when N > 1 -> rep_fib(N - 1, 0, 1).

rep_fib(0, _, V) -> V;
rep_fib(N, PP, P) when N > 0 -> rep_fib(N - 1, P, P + PP).

%Dizanje na stepen iterativno
step(0, 0) -> 'nije definisano 0^0';
step(_, 0) -> 1;
step(P, N) when N > 0 -> P * step(P, N - 1). 

rep_step(0, 0) -> 'nije definisano 0^0';
rep_step(P, N) -> rep_step(P, N, 1).

rep_step(_, 0, Acc) -> Acc;
rep_step(P, N, Acc) when N > 0 -> rep_step(P, N - 1, Acc * P).

%18. Pronaci bar jedan problem koji se prirodno resava repnom rekurzijom
%    (bez eksplicitne upotrebe akumulatora). 
sadrziX([],_) -> false;

sadrziX([X|_], X) -> true;
sadrziX([_|T], X) -> sadrziX(T, X).

%19. Prebrojati koliko u listi ima listi (samo prvi nivo)
broj_listi([]) -> 0;
broj_listi([H|T]) -> je_lista(H) + broj_listi(T).

je_lista([]) -> 1;
je_lista([_|_]) -> 1;
je_lista(_) -> 0.

%20. Funkcija koja ce ispitati da li su dve liste jednake?
iste(A, A) -> true;
iste(_, _) -> false.

%21. Izracunati n-ti element liste.

nti_element([], _) -> 'nema tog elementa';
nti_element([H|_], 0) -> H;
nti_element([_|T], N) when N > 0 -> nti_element(T, N - 1).

%22. Minimalni element liste.
minEl([]) -> 'prazna lista nema najmanji element';
minEl([H|T]) -> minEl(H, T).

minEl(CurrMin, []) -> CurrMin;
minEl(CurrMin, [H|T]) when CurrMin > H -> minEl(H, T);
minEl(CurrMin, [H|T]) when CurrMin =< H -> minEl(CurrMin, T).

%23. Lista iz koje su izbacena prva pojava zadatog x.
izbaci_prvu([], _) -> [];
izbaci_prvu([E|T], E) -> T;
izbaci_prvu([H|T], E) -> [H|izbaci_prvu(T, E)].

%24. Isto kao gore ali sve pojave.
izbaci_sve([], _) -> [];
izbaci_sve([E|T], E) -> izbaci_sve(T, E);
izbaci_sve([H|T], E) -> [H|izbaci_sve(T, E)].

%25. Lista u kojoj su sve pojave x-a yamenjene y-om.
zameni([], _, _) -> [];
zameni([X|T], X, Y) -> [Y|zameni(T, X, Y)];
zameni([H|T], X, Y) -> [H|zameni(T, X, Y)].

%       Listom predstaviti binarano stablo, a potom:

%26. Da li je x element zadatog binarnog stabla.

je_element([], _) -> false;
je_element([K, _, _], K) -> true;
je_element([_, L, D], K) -> je_element(L, K) orelse je_element(D, K).

%27. Pronaci nadredjenog za zadatati element x u zadatom binarnom stablu.
 
% list binarno stablo  [Koren, Levi, Desni] 
% [5, [2, [1, [], []], [4, [3, [], []], []] ], [7, [6, [], []], [8, [], [9, [], []] ]]]
nadr([], _) -> 'slablo je prazno';
nadr([K, _, _], K) -> 'nalazi se u korenu';
nadr([K, L, D], E) -> nadr(null, [K, L, D], E).

nadr(N, [K, _, _], K) -> N;
nadr(_, [K, _, D], E) when E > K -> nadr(K, D, E);
nadr(_, [K, L, _], E) when E < K -> nadr(K, L, E);
nadr(_, [], _) -> 'ne postoji u stablu'.

% tuple stablo  {Koren, Levi, Desni} 
% {5, {2, {1, null, null}, {4, {3, null, null}, null}}, {7, {6, null, null}, {8, null, {9, null, null}}}}

nadrTuple(null, _) -> 'slablo je prazno';
nadrTuple({K, _, _}, K) -> 'nalazi se u korenu';
nadrTuple({K, L, D}, E) -> nadrTuple(null, {K, L, D}, E).

nadrTuple(N, {K, _, _}, K) -> N;
nadrTuple(_, {K, _, D}, E) when E > K -> nadrTuple(K, D, E);
nadrTuple(_, {K, L, _}, E) when E < K -> nadrTuple(K, L, E);
nadrTuple(_, null, _) -> 'ne postoji u stablu'.

%28. Ako su listama predstavljeni skupovi:
% proveriti da li je jedan skup podksup drugog.
podskup([], A) when is_list(A) -> true;
podskup([H|T], L) -> sadrzi(H, L) and podskup(T, L).

sadrzi([], _) -> false;
sadrzi([H|_], H) -> true;
sadrzi([_|T], E) -> sadrzi(T, E).

%29. Da li su dva skupa jednaka.
jednaki(L1, L2) -> podskup(L1, L2) and podskup(L2, L1).

%30. Napraviti uniju dva skupa.
unija([], L2) -> L2;
unija(L1, []) -> L1;
unija([H1|T1], L) -> 
    case sadrzi(L, H1) of
        true -> unija(T1, L);
        false -> [H1|unija(T1, L)]
    end.
 