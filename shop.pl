:- dynamic(gold/1).

shop :- 
    isShop(X,Y),
    isPlayer(X,Y),
    write('What do you want to buy?'),nl,
    write('1. Gacha (1000 gold) -- gacha.'),nl,
    write('2. Potion (100 gold) -- potion.'),nl,!.   

gacha :-
    isShop(X,Y),
    isPlayer(X,Y),
    gold(M),
    N is M-1000,
    N >= 0,
    retract(gold(M)),
    asserta(gold(N)),
    random(1,19,Index),
    buyItem(Index),!.

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
    nl, write('You get ironSword.'), nl, !.

buyItem(Index) :-
    isShop(X,Y),
    isPlayer(X,Y),
    Index = 2,
    addItem(812),
    nl, write('You get katana.'), nl, !.

buyItem(Index) :-
    isShop(X,Y),
    isPlayer(X,Y),
    Index = 3,
    addItem(813),
    nl, write('You get greatSword.'),nl, !.

    /*Weapons Archer*/
buyItem(Index) :-
    isShop(X,Y),
    isPlayer(X,Y),
    Index = 4,
    addItem(821),
    nl, write('You get longBow.'),nl, !.

buyItem(Index) :-
    isShop(X,Y),
    isPlayer(X,Y),
    Index = 5,
    addItem(822),
    nl, write('You get crossBow.'), nl, !.

buyItem(Index) :-
    isShop(X,Y),
    isPlayer(X,Y),
    Index = 6,
    addItem(823),
    nl, write('You get deadricBow.'), nl, !.

    /*Weapons Sorcerer*/
buyItem(Index) :-
    isShop(X,Y),
    isPlayer(X,Y),
    Index = 7,
    addItem(831),
    nl, write('You get noviceStaff.'), nl, !.

buyItem(Index) :-
    isShop(X,Y),
    isPlayer(X,Y),
    Index = 8,
    addItem(832),
    nl, write('You get apprenticeStaff.'), nl, !.

buyItem(Index) :-
    isShop(X,Y),
    isPlayer(X,Y),
    Index = 9,
    addItem(833),
    nl, write('You get masterStaff.'), nl, !.

/*ARMORS*/
    /*Armors Swordsman*/
buyItem(Index) :-
    isShop(X,Y),
    isPlayer(X,Y),
    Index = 10,
    addItem(411),
    nl, write('You get lightArmor.'), nl, !.

buyItem(Index) :-
    isShop(X,Y),
    isPlayer(X,Y),
    Index = 11,
    addItem(412),
    nl, write('You get chainMailArmor.'), nl, !.

buyItem(Index) :-
    isShop(X,Y),
    isPlayer(X,Y),
    Index = 12,
    addItem(413),
    nl, write('You get knightsArmor.'), nl, !.

    /*Armors Archer*/
buyItem(Index) :-
    isShop(X,Y),
    isPlayer(X,Y),
    Index = 13,
    addItem(421),
    nl, write('You get leatherArmor.'), nl, !.

buyItem(Index) :-
    isShop(X,Y),
    isPlayer(X,Y),
    Index = 14,
    addItem(422),
    nl, write('You get hunterArmor.'), nl, !.

buyItem(Index) :-
    isShop(X,Y),
    isPlayer(X,Y),
    Index = 15,
    addItem(423),
    nl, write('You get daedricArmor.'), nl, !.

    /*Weapons Sorcerer*/
buyItem(Index) :-
    isShop(X,Y),
    isPlayer(X,Y),
    Index = 16,
    addItem(431),
    nl, write('You get noviceRobe.'), nl, !.

buyItem(Index) :-
    isShop(X,Y),
    isPlayer(X,Y),
    Index = 17,
    addItem(432),
    nl, write('You get apprenticeRobe.'), nl, !.

buyItem(Index) :-
    isShop(X,Y),
    isPlayer(X,Y),
    Index = 18,
    addItem(433),
    nl, write('You get masterRobe.'), nl, !.

/* Potion */
potion :- 
    isShop(X,Y),
    isPlayer(X,Y),
    gold(M),
    N is M-100,
    N >= 0,
    retract(gold(M)),
    asserta(gold(N)),
    write('Potion: '), nl, 
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
    nl, write('You do not have enough money.'),nl, !.

healthPotion :-
    isShop(X,Y),
    isPlayer(X,Y),
    addItem(001),
    nl, write('You get healthPotion.'), nl, !.

staminaPotion :-
    isShop(X,Y),
    isPlayer(X,Y),
    addItem(002),
    nl, write('You get staminaPotion.'), nl, !.

manaPotion :-
    isShop(X,Y),
    isPlayer(X,Y),
    addItem(003),
    nl, write('You get manaPotion.'), nl, !.

xpPotion :-
    isShop(X,Y),
    isPlayer(X,Y),
    addItem(009),
    nl, write('You get xpPotion.'), nl, !.
 
exitShop :-
    isShop(X,Y),
    isPlayer(X,Y),
    nl, write('Thanks for coming.'), nl, !.

                        