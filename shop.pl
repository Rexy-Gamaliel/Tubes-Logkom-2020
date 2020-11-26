:- use_module(library(random)).

shop :- 
    write('What do you want to buy?'),nl,
    write('1. Gacha (1000 gold)'),nl,
    write('2. Health Potion (100 gold)'),nl,   

gatcha :-
    random(1,19,index),
    buyItem(index).

/*WEAPONS */
    /*Weapons Swordsman*/

buyItem(index) :-
    index = 1,
    addItem(811),
    write('You get ironSword'),!.

buyItem(index) :-
    index = 2,
    addItem(812),
    write('You get katana'),!.

buyItem(index) :-
    index = 3,
    addItem(813),
    write('You get greatSword'),!.

    /*Weapons Archer*/
buyItem(index) :-
    index = 4,
    addItem(821),
    write('You get longBow'),!.

buyItem(index) :-
    index = 5,
    addItem(822),
    write('You get crossBow'),!.

buyItem(index) :-
    index = 6,
    addItem(823),
    write('You get deadricBow'),!.

    /*Weapons Sorcerer*/
buyItem(index) :-
    index = 7,
    addItem(831),
    write('You get noviceStaff'),!.

buyItem(index) :-
    index = 8,
    addItem(832),
    write('You get apprenticeStaff'),!.

buyItem(index) :-
    index = 9,
    addItem(833),
    write('You get masterStaff'),!.

/*ARMORS*/
    /*Armors Swordsman*/
buyItem(index) :-
    index = 10,
    addItem(411),
    write('You get lightArmor'),!.

buyItem(index) :-
    index = 11,
    addItem(412),
    write('You get chainMailArmor'),!.

buyItem(index) :-
    index = 12,
    addItem(413),
    write('You get knightsArmor'),!.

    /*Armors Archer*/
buyItem(index) :-
    index = 13,
    addItem(421),
    write('You get leatherArmor'),!.

buyItem(index) :-
    index = 14,
    addItem(422),
    write('You get hunterArmor'),!.

buyItem(index) :-
    index = 15,
    addItem(423),
    write('You get daedricArmor'),!.

    /*Weapons Sorcerer*/
buyItem(index) :-
    index = 16,
    addItem(431),
    write('You get noviceRobe'),!.

buyItem(index) :-
    index = 17,
    addItem(432),
    write('You get apprenticeRobe'),!.

buyItem(index) :-
    index = 18,
    addItem(433),
    write('You get masterRobe'),!.

/* Potion */
potion :- 
    random(1,5,index),
    buyPotion(index).

buyPotion(index) :-
    index = 1,
    addItem(001),
    write('You get healthPotion'),!.

buyPotion(index) :-
    index = 2,
    addItem(002),
    write('You get staminaPotion'),!.

buyPotion(index) :-
    index = 2,
    addItem(002),
    write('You get staminaPotion'),!.

buyPotion(index) :-
    index = 3,
    addItem(003),
    write('You get manaPotion'),!.

buyPotion(index) :-
    index = 4,
    addItem(009),
    write('You get xpPotion'),!.
 
exitShop :-
    write('Thanks for coming').
