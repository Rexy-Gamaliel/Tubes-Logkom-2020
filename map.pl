:- dynamic(positionX/1).
:- dynamic(positionY/1).

panjang(15).
lebar(15).

/* 
        Y
      ################
    X # 1,1     1,14 #
      #              #
      #              #
      #              #
      # 14,1   14,14 #
      ################
*/

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
    print('#'),nl.

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
    isPlayer(X,Y),
    print('P'),
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
    \+ isKiri(X,Y),
    \+ isAtas(X,Y),
    \+ isKanan(X,Y),
    \+ isBawah(X,Y),
    print('-'),
    NewY is Y+1,
    printX(X,NewY).

map :-
    init(_),
    printX(0,0),!.

