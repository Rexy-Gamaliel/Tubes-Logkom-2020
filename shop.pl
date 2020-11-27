:- dynamic(gold/1).

shop :- 
    isShop(X,Y),
    isPlayer(X,Y),
    write('What do you want to buy?'),nl,
    write('1. Gacha (1000 gold) -- gacha.'),nl,
    write('2. Health Potion (100 gold) -- potion.'),nl,!.   

gacha :-
    isShop(X,Y),
    isPlayer(X,Y),
    gold(M),
    N is M-1000,
    N >= 0,
    retract(gold(M)),
    asserta(gold(N)),
    random(1,19,Index),
    buyItem(Index).

gacha :-
    isShop(X,Y),
    isPlayer(X,Y),
    gold(M),
    N is M-1000,
    N < 0,
    write('You do not have enough money'),!.

/*WEAPONS */
    /*Weapons Swordsman*/

buyItem(Index) :-
    isShop(X,Y),
    isPlayer(X,Y),
    Index = 1,
    addItem(811),
    write('You get ironSword'),!.

buyItem(Index) :-
    isShop(X,Y),
    isPlayer(X,Y),
    Index = 2,
    addItem(812),
    write('You get katana'),!.

buyItem(Index) :-
    isShop(X,Y),
    isPlayer(X,Y),
    Index = 3,
    addItem(813),
    write('You get greatSword'),!.

    /*Weapons Archer*/
buyItem(Index) :-
    isShop(X,Y),
    isPlayer(X,Y),
    Index = 4,
    addItem(821),
    write('You get longBow'),!.

buyItem(Index) :-
    isShop(X,Y),
    isPlayer(X,Y),
    Index = 5,
    addItem(822),
    write('You get crossBow'),!.

buyItem(Index) :-
    isShop(X,Y),
    isPlayer(X,Y),
    Index = 6,
    addItem(823),
    write('You get deadricBow'),!.

    /*Weapons Sorcerer*/
buyItem(Index) :-
    isShop(X,Y),
    isPlayer(X,Y),
    Index = 7,
    addItem(831),
    write('You get noviceStaff'),!.

buyItem(Index) :-
    isShop(X,Y),
    isPlayer(X,Y),
    Index = 8,
    addItem(832),
    write('You get apprenticeStaff'),!.

buyItem(Index) :-
    isShop(X,Y),
    isPlayer(X,Y),
    Index = 9,
    addItem(833),
    write('You get masterStaff'),!.

/*ARMORS*/
    /*Armors Swordsman*/
buyItem(Index) :-
    isShop(X,Y),
    isPlayer(X,Y),
    Index = 10,
    addItem(411),
    write('You get lightArmor'),!.

buyItem(Index) :-
    isShop(X,Y),
    isPlayer(X,Y),
    Index = 11,
    addItem(412),
    write('You get chainMailArmor'),!.

buyItem(Index) :-
    isShop(X,Y),
    isPlayer(X,Y),
    Index = 12,
    addItem(413),
    write('You get knightsArmor'),!.

    /*Armors Archer*/
buyItem(Index) :-
    isShop(X,Y),
    isPlayer(X,Y),
    Index = 13,
    addItem(421),
    write('You get leatherArmor'),!.

buyItem(Index) :-
    isShop(X,Y),
    isPlayer(X,Y),
    Index = 14,
    addItem(422),
    write('You get hunterArmor'),!.

buyItem(Index) :-
    isShop(X,Y),
    isPlayer(X,Y),
    Index = 15,
    addItem(423),
    write('You get daedricArmor'),!.

    /*Weapons Sorcerer*/
buyItem(Index) :-
    isShop(X,Y),
    isPlayer(X,Y),
    Index = 16,
    addItem(431),
    write('You get noviceRobe'),!.

buyItem(Index) :-
    isShop(X,Y),
    isPlayer(X,Y),
    Index = 17,
    addItem(432),
    write('You get apprenticeRobe'),!.

buyItem(Index) :-
    isShop(X,Y),
    isPlayer(X,Y),
    Index = 18,
    addItem(433),
    write('You get masterRobe'),!.

/* Potion */
potion :- 
    isShop(X,Y),
    isPlayer(X,Y),
    gold(M),
    N is M-100,
    N >= 0,
    retract(gold(M)),
    asserta(gold(N)),
    write('What do you want to buy?'),
    write('1. healthPotion -- healthPotion.'),nl,
    write('2. staminaPotion -- staminaPotion.'),nl,
    write('3. manaPotion -- manaPotion.'),nl,
    write('4. xpPotion -- xpPotion.'),!.

potion :-
    isShop(X,Y),
    isPlayer(X,Y),
    gold(M),
    N is M-100,
    N < 0,
    write('You do not have enough money'),!.

healthPotion :-
    isShop(X,Y),
    isPlayer(X,Y),
    addItem(001),
    write('You get healthPotion'),!.

staminaPotion :-
    isShop(X,Y),
    isPlayer(X,Y),
    addItem(002),
    write('You get staminaPotion'),!.

manaPotion :-
    isShop(X,Y),
    isPlayer(X,Y),
    addItem(003),
    write('You get manaPotion'),!.

xpPotion :-
    isShop(X,Y),
    isPlayer(X,Y),
    addItem(009),
    write('You get xpPotion'),!.
 
exitShop :-
    isShop(X,Y),
    isPlayer(X,Y),
    write('Thanks for coming'),!.

                        