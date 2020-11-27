/* MOVEMENT */

/* MOVE D (KANAN) */
/*jika dalam pertarungan, tidak boleh pindah*/
d :- 
    init(_),
    inBattle(_),
    nl, print('Kamu sedang bertemu musuh, tidak boleh bergerak.'),nl,!.

/*Bergerak ke kanan, tapi ada dinding*/
d :- 
    init(_),
    positionX(TempX),
    positionY(TempY),
    NextY is (TempY+1),
    isKanan(TempX,NextY),
    map,nl,
    nl, write('Ada dinding!'), nl, !.

/* Bergerak ke kanan */
d :- 
    init(_),
    positionX(TempX),
    positionY(TempY),
    NextY is (TempY+1),
    retract(positionY(_)),
    asserta(positionY(NextY)),
    map,nl,
    (
        isShop(TempX,NextY) -> 
        nl, print('Kamu berada di shop, command "shop" untuk mengakses shop.'),nl;
        isQuest(TempX,NextY) ->
        nl, print('Kamu berada di lokasi quest, command "quest" untuk menerima atau melihat quest.'),nl;
        isEnemy(TempX,NextY) ->
        initFight;
        nl
    ),!.
    

/* MOVE A. (KIRI) */
/*jika dalam pertarungan, tidak boleh pindah*/
a :- 
    init(_),
    inBattle(_),
    nl, print('Kamu sedang bertemu musuh, tidak boleh bergerak.'),nl,!.

/*Bergerak ke kiri, tapi ada dinding*/
a :- 
    init(_),
    positionX(TempX),
    positionY(TempY),
    NextY is (TempY-1),
    isKiri(TempX,NextY),
    nl, write('Ada dinding!'), nl ,
    map,!.

/*Bergerak ke kiri*/
a :- 
    init(_),
    positionX(TempX),
    positionY(TempY),
    NextY is (TempY-1),
    retract(positionY(_)),
    asserta(positionY(NextY)),
    map,nl,
    (
        isShop(TempX,NextY) -> 
        nl, print('Kamu berada di shop, command "shop" untuk mengakses shop'),nl;
        isQuest(TempX,NextY) ->
        nl, print('Kamu berada di lokasi quest, command "quest" untuk menerima atau melihat quest'),nl;
        isEnemy(TempX,NextY) ->
        initFight;
        nl
    ),!.


/* MOVE S (BAWAH) */
/*jika dalam pertarungan, tidak boleh pindah*/
s :- 
    init(_),
    inBattle(_),
    nl, print('Kamu sedang bertemu musuh, tidak boleh bergerak'),nl,!.

/*Bergerak ke bawah, tapi ada dinding*/
s :- 
    init(_),
    positionX(TempX),
    positionY(TempY),
    NextX is (TempX+1),
    isBawah(NextX, TempY),
    nl, write('Ada dinding!'), nl, 
    map,!.

/*Bergerak ke bawah*/
s :- 
    init(_),
    positionX(TempX),
    positionY(Temp),
    Next is (TempX+1),
    retract(positionX(_)),
    asserta(positionX(Next)),
    map,nl,
    (
        isShop(Next,Temp) -> 
        nl, print('Kamu berada di shop, command "shop" untuk mengakses shop.'),nl;
        isQuest(Next,Temp) ->
        nl, print('Kamu berada di lokasi quest, command "quest" untuk menerima atau melihat quest.'),nl;
        isEnemy(Next,Temp) ->
        initFight;
        nl
    ),!.

/*jika dalam pertarungan, tidak boleh pindah*/
w :- 
    init(_),
    inBattle(_),
    nl, print('Kamu sedang bertemu musuh, tidak boleh bergerak.'),nl,!.

/*Bergerak ke atas, tapi ada dinding*/
w :- 
    init(_),
    positionX(TempX),
    positionY(TempY),
    NextX is (TempX-1),
    isAtas(NextX, TempY),
    nl, write('Ada dinding!'), nl, 
    map,!.

/*Bergerak ke atas*/
w :- 
    init(_),
    positionX(TempX),
    positionY(TempY),
    Next is (TempX-1),
    retract(positionX(_)),
    asserta(positionX(Next)),
    map,
    (
        isShop(Next,TempY) -> 
        nl, print('Kamu berada di shop, command "shop" untuk mengakses shop.'),nl;
        isQuest(Next,TempY) ->
        nl, print('Kamu berada di lokasi quest, command "quest" untuk menerima atau melihat quest.'),nl;
        isEnemy(Next,TempY) ->
        initFight;
        print('')
    ),!.

/* command teleport */
/* rencananya biar si player gk op, kita bikin aja si teleport ini
cuma bisa dipake kalo si player punya item teleporter*/
teleport(X,Y) :-
    init(_),
    \+ inBattle(_),
    \+ isAtas(X,Y),
    \+ isBawah(X,Y),
    \+ isKanan(X,Y),
    \+ isKiri(X,Y),
    retract(positionX(_)),
    retract(positionY(_)),
    asserta(positionX(X)),
    asserta(positionY(Y)),
    map,
    (
        isShop(X,Y) ->
        nl, print('Kamu berada di shop, command "shop" untuk mengakses shop.');
        isQuest(X,Y) ->
        nl, print('Kamu berada di lokasi quest, command "quest" untuk menerima atau melihat quest.'),nl;
        isEnemy(X,Y) ->
        nl, print('Kamu bertemu musuh'),nl,
        initFight;
        print('')
    ),!.

showItem :-
    init(_),
    nl, write('Your Items: '), nl,
    showUsableItemList, nl,
    nl, write('..and some junks'), nl,
    showUnusableItemList.