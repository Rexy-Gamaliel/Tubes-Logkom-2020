shop :- 
    write('What do you want to buy?'),nl,
    write('1. Weapons'),nl,
    write('2. Armors'),nl,
    write('3. Accesory'),nl,
    write('4. Potions').

/*WEAPONS */
    /*Weapons Swordsman*/
weapons :-
    checkJob(Job),
    Job =:= 1,
    level(X),
    X >= 1,
    X < 5,
    write('You get ironSword'),!.

weapons :-
    checkJob(Job),
    Job =:= 1,
    level(X),
    X >= 5,
    X < 10,
    write('You get katana'),!.

weapons :-
    checkJob(Job),
    Job =:= 1,
    level(X),
    X >= 10,
    write('You get greatSword'),!.

    /*Weapons Archer*/
weapons :-
    checkJob(Job),
    Job =:= 2,
    level(X),
    X >= 1,
    X < 5,
    write('You get longBow'),!.

weapons :-
    checkJob(Job),
    Job =:= 2,
    level(X),
    X >= 5,
    X < 12,
    write('You get crossBow'),!.

weapons :-
    checkJob(Job),
    Job =:= 2,
    level(X),
    X >= 12,
    write('You get deadricBow'),!.

    /*Weapons Srcerer*/
weapons :-
    checkJob(Job),
    Job =:= 3,
    level(X),
    X >= 1,
    X < 6,
    write('You get noviceStaff'),!.

weapons :-
    checkJob(Job),
    Job =:= 3,
    level(X),
    X >= 6,
    X < 12,
    write('You get apprenticeStaff'),!.

weapons :-
    checkJob(Job),
    Job =:= 3,
    level(X),
    X >= 12,
    write('You get masterStaff'),!.

/*ARMORS*/
 
armors :-
    checkJob(Job),
    Job =:= 1,
    level(X),
    X >= 1,
    X < 6,
    write('You get lightArmor'),!.

armors :-
    checkJob(Job),
    Job =:= 1,
    level(X),
    X >= 6,
    X < 11,
    write('You get chainMailArmor'),!.

armors :-
    checkJob(Job),
    Job =:= 1,
    level(X),
    X >= 11,
    write('You get knightsArmor'),!.

armors :-
    checkJob(Job),
    Job =:= 2,
    level(X),
    X >= 1,
    X < 6,
    write('You get leatherArmor'),!.

armors :-
    checkJob(Job),
    Job =:= 2,
    level(X),
    X >= 6,
    X < 12,
    write('You get hunterArmor'),!.

armors :-
    checkJob(Job),
    Job =:= 2,
    level(X),
    X > 12,
    write('You get daedricArmor'),!.

armors :-
    checkJob(Job),
    Job =:= 3,
    level(X),
    X >= 1,
    X < 5,
    write('You get noviceRobe'),!.

armors :-
    checkJob(Job),
    Job =:= 3,
    level(X),
    X >= 5,
    X < 10,
    write('You get apprenticeRobe'),!.

armors :-
    checkJob(Job),
    Job =:= 3,
    level(X),
    X > 10,
    write('You get masterRobe'),!.

exitShop :-
    write('Thanks for coming').
