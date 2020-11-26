:- dynamic(cooldown/1).
:- dynamic(isZero/1).
:- dynamic(ordinat/1).
:- dynamic(point/2).
:- dynamic(tesaja/1).

cooldown(2).

isZero(X) :-
    X =:= 0.

reduceCooldown :-
    cooldown(Temp),
    \+ isZero(Temp),
    CurrentCD is Temp - 1,
    retract(cooldown(_)),
    write(Temp),
    asserta(cooldown(CurrentCD)),
    write(cooldown(CurrentCD)),!.

addCooldown :-
    Temp is 3,
    retract(cooldown(_)),
    asserta(cooldown(Temp)),
    write(cooldown(Temp)),!.

succeed :-
    read(X),
    read(Y),
    asserta(ordinat(Y)),
    asserta(point(X, ordinat(Y))),
    retract(point(_,_)),
    retract(ordinat(Y)),
    asserta(point(X, ordinat(Y))),!.

attackChance :-
        random(1, 4, Chance),
        Chance =\= 2,!.

tes :- 
    asserta(tesaja(5)),
    Y is 7,
    write('Y = '), write(Y), nl,
    random(1, 4, Chance),
    write('Chance = '), write(Chance), nl,
    (
        (Chance =\= 2) ->   write('Bisa.'), nl, nl,
                            (
                                (Y =\= 8) -> write('Benar!'), nl;
                                write('Salah!'), nl
                            );
        write('Kamu gagal menyerangnya!'), nl
    ),!.

test1 :-
    asserta(tesaja(5)),
    tesaja(X), /*tes*/
    Temp is X + 2,
    (
        (Temp < 10) ->  Temp1 is 10,
                        write(Temp1), nl
    ),              
    (
        (Temp < 8) ->      Temp2 is 5,
                            write(Temp2), nl
    ),!.
    