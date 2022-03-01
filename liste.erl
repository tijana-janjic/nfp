-module(liste).
-export([element_na_poziciji/2,
    rep_repa/1,
    dodaj_na_pocetak/2,
    dodaj_na_kraj/2,
    parni/1,
    duzina_neparni/1,
    najmanji_tri_deljiv/1,
    suma_listi/2
]).

% 5. Napisati funkciju element_na_poziciji koja za prosleđenu listu i broj, vraća element napoziciji prosleđenog broja. 
% Koristiti funkciju nth iz modula lists. 
% Primer: lists:nth(3, [a,b, c, d, e]).
element_na_poziciji(N, L) -> lists:nth(N, L).

% 6. Napisati funkciju repovi koja računa rep od repa liste sa najmanje 2 elementa. 
% Ukoliko je lista prazna ili ima jedan element napisati odgovarajuću poruku.
rep_repa([]) -> io:fwrite("Lista je prazna!~n", []);
rep_repa([_]) -> io:fwrite("Lista ima samo jedan element!~n", []);
rep_repa(L) -> lists:nthtail(2, L).

% 7. Napisati funkciju dodaj_na_pocetak koja kao parametre prima element i listu i dodaje prosleđeni element na početak liste.
dodaj_na_pocetak(E, L) -> [E|L].

% 8. Napisati funkciju dodaj_na_kraj koja kao parametre prima element i listu i dodaje prosleđeni elment na kraj liste.
dodaj_na_kraj(E, L) -> L ++ [E].

% 9. Napisati funkciju parni koja za prosleđenu listu ispisuje samo parne elemente. 
% Ukoliko je lista prazna ispisati odgovarajuću poruku.
parni([]) -> io:fwrite("Lista je prazna!\n", []);
parni(L) -> [X || X <- L, X rem 2 == 0].

% 10. Napisati funkciju broj_neprarnih koja za prosleđenu listu filtrira neprne elemente, a potom vraća dužinu isfiltrirane liste.
% Koristiti funkciju length (primer length([1,2,3]))
duzina_neparni(L) -> length([X || X <- L, X rem 2 /= 0]).

% 11. Napisati funkciju najmanji_tri_deljiv koji za prosleđenu listu filtrira sve elemente koji su deljivi sa 3 
% i zatim pronalazi njihov minimum. Koristiti funkciju min iz modula lists. Primer:lists:min[1,2,3]
najmanji_tri_deljiv(L) -> lists:min([X || X <- L, X rem 3 == 0]).

% 12. Napisati funkciju suma_listi koja kao parametra prima dve liste i vraća novu listu čiji elementi predstavljaju 
% zbir svakog elementra prve liste sa svakim elementrom druge. 
% Primer: za listu L1 = [1, 2, 3] i listu L2 = [4, 5, 6] dobijamo 
% L3 = [1 + 4, 1 + 5, 1 + 6,2 + 4, 2 + 5, 2 + 6, 3 + 4, 3 + 5, 3 + 6 ] 
% (za dodatnu vežbu napisati međusobni zbir elemenata 3 liste).
suma_listi(L1, L2) -> [(X+Y) || X <- L1, Y <- L2].