/* MOVEMENT */

/*jika dalam pertarungan, tidak boleh pindah*/
d :- 
    init(_),
    inBattle(_),
    print('Anda sedang bertemu musuh, tidak boleh bergerak'),nl,!.

/*Bergerak ke kanan, temu musuh*/
d :- 
    init(_),
    positionX(TempX),
    positionY(TempY),
    NextY is (TempY+1),
    isEnemy(TempX,NextY),
    retract(positionY(_)),
    asserta(positionY(NextY)),
    map,
    print('Anda bertemu musuh'),nl,
    battle,!.

/*Bergerak ke kanan, masuk shop*/
d :- 
    init(_),
    positionX(TempX),
    positionY(TempY),
    NextY is (TempY+1),
    isShop(TempX,NextY),
    retract(positionY(_)),
    asserta(positionY(NextY)),
    map,
    print('Anda berada di shop, command "shop" untuk mengakses shop'),!.

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
    map,nl,
    write('Ada dinding!'),!.

/*jika dalam pertarungan, tidak boleh pindah*/
a :- 
    init(_),
    inBattle(_),
    print('Anda sedang bertemu musuh, tidak boleh bergerak'),nl,!.

/*Bergerak ke kiri, temu musuh*/
a :- 
    init(_),
    positionX(TempX),
    positionY(TempY),
    NextY is (TempY-1),
    isEnemy(TempX,NextY),
    retract(positionY(_)),
    asserta(positionY(NextY)),
    map,
    print('Anda bertemu musuh'),nl,
    battle,!.

/*Bergerak ke kiri, masuk shop*/
a :- 
    init(_),
    positionX(TempX),
    positionY(TempY),
    NextY is (TempY-1),
    isShop(TempX,NextY),
    retract(positionY(_)),
    asserta(positionY(NextY)),
    map,
    print('Anda berada di shop, command "shop" untuk mengakses shop'),!.

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

/*jika dalam pertarungan, tidak boleh pindah*/
s :- 
    init(_),
    inBattle(_),
    print('Anda sedang bertemu musuh, tidak boleh bergerak'),nl,!.

/*Bergerak ke bawah, temu musuh*/
s :- 
    init(_),
    positionX(TempX),
    positionY(Temp),
    Next is (TempX+1),
    isEnemy(Next,Temp),
    retract(positionX(_)),
    asserta(positionX(Next)),
    map,
    print('Anda bertemu musuh'),nl,
    battle,!.

/*Bergerak ke bawah, masuk shop*/
s :- 
    init(_),
    positionX(TempX),
    positionY(Temp),
    Next is (TempX+1),
    isShop(Next,Temp),
    retract(positionX(_)),
    asserta(positionX(Next)),
    map,
    print('Anda berada di shop, command "shop" untuk mengakses shop'),!.

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

/*jika dalam pertarungan, tidak boleh pindah*/
w :- 
    init(_),
    inBattle(_),
    print('Anda sedang bertemu musuh, tidak boleh bergerak'),nl,!.

/*Bergerak ke atas, temu musuh*/
w :- 
    init(_),
    positionX(TempX),
    positionY(TempY),
    Next is (TempX-1),
    isEnemy(Next,TempY),
    retract(positionX(_)),
    asserta(positionX(Next)),
    map,
    print('Anda bertemu musuh'),nl,
    battle,!.

/*Bergerak ke atas, masuk shop*/
w :- 
    init(_),
    positionX(TempX),
    positionY(TempY),
    Next is (TempX-1),
    isShop(Next,TempY),
    retract(positionX(_)),
    asserta(positionX(Next)),
    map,
    print('Anda berada di shop, command "shop" untuk mengakses shop'),!.

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