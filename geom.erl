-module(geom).
-export([povrsina_kruga/1, 
        povrsina_pravougaonika/2,
        povrsina_trougla/3, izraz/4, s/3]).
-import(math, [pow/2, pi/0, sqrt/1]).

%13. Napisati funkciju povrsina koja prima poluprečnik kruga i računa njegovu površinu. Koristitifunkciju math:pi().
povrsina_kruga(R) -> pow(R, 2) * pi().

%14. Napisati funkciju povrsina koja prima dva parametra koja predstavljaju stranice pravougaonika 
%    i računa porvšinu pravougaonika.
povrsina_pravougaonika(A, B) -> A * B.

%15. Napisati funkciju povrsina koja prima tri parametra i računa površinu trougla. (Heronov obrazac)
povrsina_trougla(A, B, C) -> sqrt(izraz(A,B,C, s(A,B,C))).
izraz(A, B, C, S) -> S*(S-A)*(S-B)*(S-C).
s(A, B, C) -> (A + B + C) / 2. %poluobim