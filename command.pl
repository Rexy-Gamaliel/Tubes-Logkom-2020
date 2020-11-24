/* MOVEMENT */
    /*Bergerak ke kanan*/
d :-
    init(_),
    positionX(TempX),
    positionY(TempY),
    NextY is (TempY+1),
    \+isKanan(TempX,NextY),
    \+isQuest(TempX,NextY),
    \+isShop(TempX,NextY),
    retract(positionY(_)),
    asserta(positionY(NextY)),
    map,!.
    /*Bergerak ke kanan, tapi ada dinding*/
d :- 
    init(_),
    positionX(TempX),
    positionY(TempY),
    NextY is (TempY+1),
    isKanan(TempX,NextY),
    write('Ada dinding!'),
    map,!.

    /*Bergerak ke kiri*/
a :- 
    init(_),
    positionX(TempX),
    positionY(TempY),
    NextY is (TempY-1),
    \+isKiri(TempX,NextY),
    \+isQuest(TempX,NextY),
    \+isShop(TempX,NextY),
    retract(positionY(_)),
    asserta(positionY(NextY)),
    map,!.
    /*Bergerak ke kiri, tapi ada dinding*/
a :- 
    init(_),
    positionX(TempX),
    positionY(TempY),
    NextY is (TempY-1),
    isKiri(TempX,NextY),
    write('Ada dinding!'),
    map,!.

    /*Bergerak ke bawah*/
s :-    
    init(_),
    positionX(TempX),
    positionY(Temp),
    Next is (TempX+1),
    \+isBawah(Next,Temp),
    \+isQuest(Next,Temp),
    \+isShop(Next,Temp),
    retract(positionX(_)),
    asserta(positionX(Next)),
    map,!.
    /*Bergerak ke bawah, tapi ada dinding*/
s :- 
    init(_),
    positionX(TempX),
    positionY(TempY),
    NextX is (TempX+1),
    isBawah(NextX, TempY),
    write('Ada dinding!'),
    map,!.

    /*Bergerak ke atas*/
w :-
    init(_),
    positionX(TempX),
    positionY(Temp),
    Next is (TempX-1),
    \+isAtas(Next,Temp),
    \+isQuest(Next,Temp),
    \+isShop(Next,Temp),
    retract(positionX(_)),
    asserta(positionX(Next)),
    map,!.
    /*Bergerak ke atas, tapi ada dinding*/
w :- 
    init(_),
    positionX(TempX),
    positionY(TempY),
    NextX is (TempX-1),
    isAtas(NextX, TempY),
    write('Ada dinding!'),
    map,!.