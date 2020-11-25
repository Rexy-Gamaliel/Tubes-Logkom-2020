:- dynamic(positionX/1).
:- dynamic(positionY/1).
:- dynamic(isEnemy/2).

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


    Sistem Zona Kira2 kayak gini

        Y         7   8
      ############################
    X # 1,1    1,7  | 1,8   1,14 #
      #             |            #
      #  Safe Zone  |  Zone # 2  #
      #  ada S & Q  |    Wolf    #
      #  disini     |            #
    7 #             |            # 7
      # ------------|----------- # 
    8 #             |            # 8
      #             |            #
      #  Zone #1    |  Zone #3   #
      #   Slime     |   Goblin   #
      #             |            #
   14 # 14,1        |          D # 14
      ############################
                              14
        D : dragon
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

generateEnemy(0) :- !.

generateEnemy(N) :-
    random(8,15,TempY),
    random(1,8,TempX),
    (
        isEnemy(TempX,TempY) ->
        generateEnemy(N);
        assertz(isEnemy(TempX,TempY)),
        Next is N - 1,
        generateEnemy(Next),
    ),!.

zone(Zone) :-
    positionX(X),
    positionY(Y),
    cekZone(X,Y,Zone),!.

/* Safe Zone */
cekZone(X,Y,Zone) :-
    X >= 1,
    X =< 7,
    Y >= 1,
    Y =< 7,
    Zone = 0,!.

/* Zone # 1*/
cekZone(X,Y,Zone) :-
    X >= 8,
    X =< 14,
    Y >= 1,
    Y =< 7,
    Zone = 1,!.

/* Zone # 2*/
cekZone(X,Y,Zone) :-
    X >= 1,
    X =< 7,
    Y >= 8,
    Y =< 14,
    Zone = 2,!.

/* Zone # 3*/
cekZone(X,Y,Zone) :-
    X >= 8,
    X =< 14,
    Y >= 8,
    Y =< 14,
    Zone = 3,!.

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

