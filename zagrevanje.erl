-module(zagrevanje).
-export([paran/1,
        i/2, ili/2, eks_ili/2, ne/1,
        zameni_redosled/1,
        drugi_elem/1]).


% 1. Napisati funkciju paran koja proverava da li je prosleđeni broj paran ili ne.
paran(N) -> N rem 2 == 0.

% 2. Definisati funkciju ili (za dodatnu vežbu implementirati i ostale logičke operacije).
ili(_, true) -> true;
ili(true, _) -> true;
ili(_,_) -> false.

i(_, false) -> false;
i(false, _) -> false;
i(_,_) -> true.

ne(true) -> false;
ne(false) -> true.

eks_ili(false, true) -> true;
eks_ili(true, false) -> true;
eks_ili(_,_) -> false.

% 3. Napisati funkciju koja prima torku {x, y} i menja redosled elemenata u {y,x}. Elementi x i y su atomi.
zameni_redosled({X,Y}) when is_atom(X) and is_atom(Y) -> {Y, X};
zameni_redosled(_) -> io:fwrite("Pogresan argument\n", []).

% 4. Napisati funkciju drugi_elem koja za prosleđenu torku vraća drugi element torke koristeći funkciju element
drugi_elem(T) -> element(2, T).