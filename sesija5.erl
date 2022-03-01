-module(sesija5).
-export([map/3, map/2, filter/2, kvadrat/1, kvadriraj_listu/1, 
    samo_parni/1, paran/1, fold/3, sumiraj/1, sum/2,
    sumiraj2/1, sumiraj2/2, distinct/1, ubaci/2, jedinstven/2, maxEl/1]).
-import(lists, [reverse/1]).


% 31. Realizovati 'map' (funkciju viseg reda) kao tail-recursion (sa akumulatorom)
map(F, L) -> map(F,L,[]).

map(_, [], L) -> reverse(L);
map(F, [H|T], L) -> map(F,T,[F(H)|L]).

% 32. Primeniti 'map' na jednom primeru.
kvadrat(X) -> X*X.
kvadriraj_listu(L) -> map(fun kvadrat/1, L).

% 33. Realizovati 'filter' (funkciju viseg reda) kao obicniu rekurziju (bez akumulatora)
filter(_, []) -> [];
filter(F, [H|T]) -> 
    case F(H) of 
        false -> filter(F,T);
        true -> [H|filter(F,T)]
    end.

% 34. Primeniti 'filter' na jednom primeru.
samo_parni(L) -> filter(fun paran/1, L).
paran(X) ->  X rem 2 == 0.

% 35. Realizovati 'fold' (funkciju viseg reda) i primeniti je na nekom primeru (npr. sumiranje elemenata liste)
fold(_, Acc, []) -> Acc;
fold(F, Acc, [H|T]) -> fold(F, F(Acc, H), T).

sum(X, Y) -> X+Y.

sumiraj(L) -> fold(fun sum/2, 0, L).

% 36. Uzeti realizaciju 'fold'-a kao obrazac i na analogan nacin direktno realizovati sumiranje elemenata liste.
sumiraj2(L) -> sumiraj2(0, L).

sumiraj2(Acc, []) -> Acc;
sumiraj2(Acc, [H|T]) -> sumiraj2(sum(Acc, H), T).

maxEl([H|T]) -> fold(fun max/2, H, [H|T]).

% 37. 'Fold' na osnovu liste generise 1 element (npr. sumu elemenata, maksimum elemenata, ...).
%  Rekli smo da ne postoji restrikcija sta taj 1 element moze da bude, pa prema tome moze da
%  bude i nova lista (ili torka/tuple)...

% Ilustrovati (smislenim) primerom kako 'fold' moze da proizvede kao svoj rezultat neku listu.
distinct(L) -> fold(fun ubaci/2, [], L).

ubaci(L, X) -> 
    case jedinstven(L, X) of
        false -> [X|L];
        true -> L
    end.

jedinstven([], _) -> false;
jedinstven([X|_], X) -> true;
jedinstven([_|T], X) -> jedinstven(T, X).