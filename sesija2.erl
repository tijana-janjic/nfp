-module(sesija2).

%-export([prvi/0, brojSekundiUDanu/0, drugi/0, djeljivost/2]).
-export([jePrazna/1, imaTacnoJedan/1, hello/0]).
%

% Definisati funkciju, koja:
% 8. uzima listu kao argument i vraca true ako je lista prazna
% 9. uzima listu kao argument i vraca true ako lista ima tacno jedan element

jePrazna([]) -> true;
jePrazna(_) -> false.


imaTacnoJedan([]) -> false;
imaTacnoJedan([_|T]) -> T == [].


hello() -> io:format("Hello world").

