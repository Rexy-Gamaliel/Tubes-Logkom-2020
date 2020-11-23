:- dynamic(positionX/1).
:- dynamic(positionY/1).

panjang(15).
lebar(15).

/* lokasi shop, masih ngasal dulu */
shopX(4).
shopY(4).

/* lokasi quest, masih ngasal dulu */
questX(4).
questY(8).

initPlayer :-
    asserta(cure(1)),
    asserta(positionX(1)),
    asserta(positionY(1)).

isKiri(_,Y) :- 
    Y =:= 0.

isKanan(_,Y) :-
    lebar(Ymax),
    Y =:= Ymax.

isAtas(X,_) :-
    X =:= 0.

isBawah(X,_) :-
    panjang(Xmax),
    X =:= Xmax.

isShop(X,Y) :-
    shopX(X),
    shopY(Y).

isQuest(X,Y) :-
    questX(X),
    questY(Y).

isPlayer(X,Y) :-
    positionX(X),
    positionY(Y).

printX(X,Y) :-
    isKanan(X,Y),
    isBawah(X,Y),
    print('#').

printX(X,Y) :-
    isBawah(X,Y),
    print('#'),
    NewY is Y+1,
    printX(X,NewY).

printX(X,Y) :-
    isKiri(X,Y),
    print('#'),
    NewY is Y+1,
    printX(X,NewY).

printX(X,Y) :-
    isKanan(X,Y),
    print('#'),nl,
    NewX is X+1,
    NewY is 0,
    printX(NewX,NewY).
    
printX(X,Y) :-
    isAtas(X,Y),
    print('#'),
    NewY is Y+1,
    printX(X,NewY).

printX(X,Y) :-
    isShop(X,Y),
    print('S'),
    NewY is Y+1,
    printX(X,NewY).

printX(X,Y) :-
    isQuest(X,Y),
    print('Q'),
    NewY is Y+1,
    printX(X,NewY).

printX(X,Y) :-
    isPlayer(X,Y),
    print('P'),
    NewY is Y+1,
    printX(X,NewY).

printX(X,Y) :-
    \+ isKiri(X,Y),
    \+ isAtas(X,Y),
    \+ isKanan(X,Y),
    \+ isBawah(X,Y),
    print('-'),
    NewY is Y+1,
    printX(X,NewY).

d :-
    init(_),
    positionX(TempX),
    positionY(Temp),
    Next is (Temp+1),
    \+isAtas(TempX,Next),
    \+isBawah(TempX,Next),
    \+isKanan(TempX,Next),
    \+isKiri(TempX,Next),
    \+isQuest(TempX,Next),
    \+isShop(TempX,Next),
    retract(positionY(_)),
    asserta(positionY(Next)),!.

a :- 
    init(_),
    positionX(TempX),
    positionY(Temp),
    Next is (Temp-1),
    \+isAtas(TempX,Next),
    \+isBawah(TempX,Next),
    \+isKanan(TempX,Next),
    \+isKiri(TempX,Next),
    \+isQuest(TempX,Next),
    \+isShop(TempX,Next),
    retract(positionY(_)),
    asserta(positionY(Next)),!.

s :-    
    init(_),
    positionX(TempX),
    positionY(Temp),
    Next is (TempX+1),
    \+isAtas(Next,Temp),
    \+isBawah(Next,Temp),
    \+isKanan(Next,Temp),
    \+isKiri(Next,Temp),
    \+isQuest(Next,Temp),
    \+isShop(Next,Temp),
    retract(positionX(_)),
    asserta(positionX(Next)),!.

w :-
    init(_),
    positionX(TempX),
    positionY(Temp),
    Next is (TempX-1),
    \+isAtas(Next,Temp),
    \+isBawah(Next,Temp),
    \+isKanan(Next,Temp),
    \+isKiri(Next,Temp),
    \+isQuest(Next,Temp),
    \+isShop(Next,Temp),
    retract(positionX(_)),
    asserta(positionX(Next)),!.


map :-
    init(_),
    printX(0,0),!.

