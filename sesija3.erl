-module(sesija3).
-export([
    duzina_liste1/1, duzina_liste2/1, duzina_liste3/1, duzina_liste4/1, 
    prvihNPrirodnih/1, 
    lista2N/1, parN/2, 
    listaNN/1, listaKN/2, 
    jeProst/1, brojDjelilaca/3]).
-import(lists, [head/1, tail/1]).

% 10. izracunava duzinu liste na 4 nacina: 

% pattern matching
duzina_liste1([]) -> 0;
duzina_liste1([_|T]) -> 1 + duzina_liste1(T).

% guards
duzina_liste2(L) when L == [] -> 0;
duzina_liste2(L) -> 1 + duzina_liste2(tail(L)).

% if
duzina_liste3(L) ->
    if  
        L == [] -> 0;
        true    -> (1 + duzina_liste3(tail(L)))
    end.

% case

duzina_liste4(L) ->
    case L of
       [] -> 0;
       _  -> 1 + duzina_liste4(L)
    end. 

% 11. izracunava zbir prvih N prirodnih brojeva, pri tome vracajuci i odgovarajuce
%       poruke (atome) u slucaju pogresnog argumenta  
prvihNPrirodnih(N) when not is_integer(N) -> nije_broj;
prvihNPrirodnih(N) when N < 1             -> nije_pozitivan;
prvihNPrirodnih(N)                        -> N * (N+1) div 2.

% 12. uzima broj N i generise listu [1, 1, 2, 2, 3, 3, ... N, N]
lista2N(0) -> [];
lista2N(N) -> parN(1, N).
parN(N, N) -> [N,N];
parN(N, K) -> [K,K] ++ parN(N, K+1).

% 13. uzima broj N i generise listu [1, 2, 2, 3, 3, 3, 4, 4, 4, 4, ... N, N, N, ...N]
listaNN(0) -> [];
listaNN(N) -> listaNN(N-1) ++ listaKN(N, N).
listaKN(_, 0) -> []; 
listaKN(N, K) -> [N | listaKN(N, K-1)].

% 14. uzima broj N i generise listu od N alternativnih vrednosti false i true.  ???

% 15. uzima broj N i vraca true ako je broj prost.
jeProst(N) -> brojDjelilaca(N, 1, 0) == 2.
brojDjelilaca(N, N, Broj) -> Broj + 1;
brojDjelilaca(N, Tr, Broj) -> 
    if 
        N rem Tr == 0 -> brojDjelilaca(N, Tr+1, Broj+1); 
        true          -> brojDjelilaca(N, Tr+1, Broj) 
    end.