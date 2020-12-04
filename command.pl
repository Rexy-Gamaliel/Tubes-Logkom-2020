/* MOVEMENT */

/* MOVE D (KANAN) */
/*jika dalam pertarungan, tidak boleh pindah*/
d :- 
    init(_),
    inBattle(_),
    writerint('Kamu sedang bertemu musuh, tidak boleh bergerak.'),nl,!.

/*Bergerak ke kanan, tapi ada dinding*/
d :- 
    init(_),
    positionX(TempX),
    positionY(TempY),
    NextY is (TempY+1),
    isKanan(TempX,NextY),
    map,nl,
    nl, nl, write('Ada dinding nl, !'), nl, !.

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
        write('*** Kamu berada di Shop ***'), nl, nl,
        write('Ketik shop untuk mengakses shop: '), nl;
        isQuest(TempX,NextY) ->
        write('*** Kamu berada di lokasi Quest ***'), nl, nl,
        write('Ketik quest untuk menerima atau melihat quest: '), nl,nl;
        isEnemy(TempX,NextY) ->
        initFight;
        print('')
    ),!.
    

/* MOVE A. (KIRI) */
/*jika dalam pertarungan, tidak boleh pindah*/
a :- 
    init(_),
    inBattle(_),
    writerint('Kamu sedang bertemu musuh, tidak boleh bergerak.'),nl,!.

/*Bergerak ke kiri, tapi ada dinding*/
a :- 
    init(_),
    positionX(TempX),
    positionY(TempY),
    NextY is (TempY-1),
    isKiri(TempX,NextY),
    nl, nl, write('Ada dinding nl, !'), nl ,
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
        write('*** Kamu berada di Shop ***'), nl, nl,
        write('Ketik "shop" untuk mengakses shop: '),nl;
        isQuest(TempX,NextY) ->
        write('*** Kamu berada di lokasi Quest ***'), nl, nl,
        write('Ketik "quest" untuk menerima atau melihat quest: '), nl,nl;
        isEnemy(TempX,NextY) ->
        initFight;
        print('')
    ),!.


/* MOVE S (BAWAH) */
/*jika dalam pertarungan, tidak boleh pindah*/
s :- 
    init(_),
    inBattle(_),
    writerint('Kamu sedang bertemu musuh, tidak boleh bergerak'),nl,!.

/*Bergerak ke bawah, tapi ada dinding*/
s :- 
    init(_),
    positionX(TempX),
    positionY(TempY),
    NextX is (TempX+1),
    isBawah(NextX, TempY),
    nl, writerite('Ada dinding nl, !'), nl, 
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
        write('*** Kamu berada di Shop ***'), nl, nl,
        write('Ketik "shop" untuk mengakses shop: '),nl,nl;
        isQuest(Next,Temp) ->
        write('*** Kamu berada di lokasi Quest ***'), nl, nl,
        write('Ketik "quest" untuk menerima atau melihat quest: '),nl,nl;
        isEnemy(Next,Temp) ->
        initFight;
        print('')
    ),!.

/*jika dalam pertarungan, tidak boleh pindah*/
w :- 
    init(_),
    inBattle(_),
    writerint('Kamu sedang bertemu musuh, tidak boleh bergerak.'),nl,!.

/*Bergerak ke atas, tapi ada dinding*/
w :- 
    init(_),
    positionX(TempX),
    positionY(TempY),
    NextX is (TempX-1),
    isAtas(NextX, TempY),
    nl, nl, write('Ada dinding nl,!'), nl, 
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
        write('*** Kamu berada di Shop ***'), nl, nl,
        write('Ketik "shop" untuk mengakses : shop.'),nl;
        isQuest(Next,TempY) ->
        write('*** Kamu berada di lokasi Quest ***'), nl, nl,
        write('Ketik "quest" untuk menerima atau melihat q: uest.'),nl;
        isEnemy(Next,TempY) ->
        initFight;
        print(''), int('')
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
        write('*** Kamu berada di Shop ***'), nl, nl,
        write('Ketik "shop" untuk mengakses shop: '),nl,
        isQuest(X,Y) ->
        write('*** Kamu berada di lokasi Quest ***'), nl, nl,
        write('Ketik "quest" untuk menerima atau melihat quest: '),nl,nl;
        isEnemy(X,Y) ->
        writerint('Kamu bertemu musuh'),nl,
        initFight;
        print('');
        print('')
    ),!.
showItem :-
    init(_),
    write('******************************'), nl,
    write('         INVENTORY            '), nl,
    showUsableItemList, nl,
    write('------------------------------'), nl,
    showUnusableItemList,nl, !.

equip(ItemName) :-  % item name dari input user
    % Cek apakah ada di inventory
    \+inventory(_, ItemName, _, _, _, _, _, _, _, _, _, _, _, _),
    write('Kamu tidak punya item ini'), nl, !.
equip(ItemName) :-
    inventory(ID, ItemName, _, _, _, _, _, _, _, _, _, _, _, _),
    useItem(ID),
    updatePlayerStatus. 

throwItem(ItemName) :-
    % Cek apakah ada di inventory
    \+inventory(_, ItemName, _, _, _, _, _, _, _, _, _, _, _, _),
    write('Kamu tidak punya item ini'), nl, !.
throwItem(ItemName) :-
    inventory(ID, ItemName, _, _, _, _, _, _, _, _, _, _, _, _),
    delItem(ID),
    updatePlayerStatus.

  /* Show Items Status */
infoItem(NamaItem) :-
    \+ inventory(_, NamaItem, _, _, _, _, _, _, _, _, _, _, _, _),
    write('Kamu tidak punya item ini'), nl, !.
infoItem(NamaItem) :-
    write('>>> Item Detail <<<'), nl,
    inventory(ID, NamaItem, _, _, _, _, _, _, _, _, _, _, _, _),
    format('Nama Item       : ~w', [NamaItem]), nl,
    showItemHealthRegen(ID),
    showItemStaminaRegen(ID),
    showItemHealthRegen(ID),
    showItemMaxHealth(ID),
    showItemMaxStamina(ID),
    showItemMaxMana(ID),
    showItemAttack(ID),
    showItemDefense(ID).