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
/* Zone Bound */
/* getBound(NomorZona, LowerBoundX, UpperBoundX, LowerBoundY, UpperBoundY) */
getBound(0,1,7,1,7).
getBound(1,8,14,1,7).
getBound(2,1,7,8,14).
getBound(3,8,14,8,14).

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

generateEnemy(_,0) :- !.

generateEnemy(Zone,N) :-
    getBound(Zone,LowerX,UpperX,LowerY,UpperY),
    UpY is UpperY+1,
    UpX is UpperX+1,
    random(LowerY,UpY,TempY),
    random(LowerX,UpX,TempX),
    (
        isEnemy(TempX,TempY) ->
        generateEnemy(Zone,N);
        assertz(isEnemy(TempX,TempY)),
        Next is N - 1,
        generateEnemy(Zone,Next)
    ),!.

zone(Zone) :-
    positionX(X),
    positionY(Y),
    cekZone(X,Y,Zone),!.

cekZone(X,Y,Z) :-
    getBound(Zone,LowerX,UpperX,LowerY,UpperY),
    X >= LowerX,
    X =< UpperX,
    Y >= LowerY,
    Y =< UpperY,
    Z = Zone,!.

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
    isEnemy(X,Y),
    print('X'),
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

