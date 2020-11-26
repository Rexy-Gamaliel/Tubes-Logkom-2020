:- dynamic(inventory/13).

:- include('items.pl').

/* playerInfo(Username, Job, Xp, Level, playerStatus/11) */
/* playerStatus(Health, Stamina, Mana, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense) */

/* STATUS */
initPlayer :-


status :-
    init(_),
    playerInfo(Username, Job, Xp, Level, playerStatus(Health, Stamina, Mana, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense)),
    write('Your status: '),nl,
    format('> ~w (~w)', [Username, Job]), nl,
    RequiredXp(Level, LevelXp),
    format('> Level: ~d (~d / ~d)', [Level, Xp, LevelXp]), nl, nl,
    format('> Attack: ~d', Attack), nl,
    format('> Defense: ~d', Defense), nl,
    format('> Health: ~d / ~d (+~d per turn)', [Health, MaxHealth, HealthRegen]), nl,
    format('> Stamina: ~d / ~d (+~d per turn)', [Stamina, MaxStamina, StaminaRegen]), nl,
    format('> Mana: ~d / ~d (+~d per turn)', [Mana, MaxMana, ManaRegen]), nl,

/* LEVEL */
/* Required Xp untuk naik dari level n ke level n+1:  15 + 5*n Xp
   */
RequiredXp(Level, LevelXp) :-
    LevelXp is (15 + 5 * Level).


/*** PLAYER INVENTORY ***/

/* SHOW ITEM */
/* inventory(ID, Nama, Tipe, Job, Level, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense). */
showItem :-
    init(_),

printItemList([]).
printItemList([H|T]) :-
    format('> ~w', H), nl,
    printItemList(T).

showUsableItemList :-

/* sub fungsi dari showUsableItemList */
    /* Weapons */
showWeapons(ListWeapons) :-     % show equipped
    write('Your Weapons: '), nl,
    showEquippedWeapon,
    playerInfo(_, Job, _, _, _),
    findall(Nama, inventory(_, Nama, weapon, Job, _, _, _, _, _, _, _, _, _), ListWeapons),
    printItemList(ListWeapons).
showEquippedWeapon :-
    equippedWeapon(ID),
    inventory(ID, Nama, _, _, _, _, _, _, _, _, _, _, _),
    format('~w (equipped)', Nama), nl, !.
showEquippedWeapon :-
    write('No weapons equipped.'), nl.

    /* Armors */
showArmors(ListArmors) :-
    write('Your Armors: '), nl,
    showEquippedArmor,
    playerInfo(_, Job, _, _, _),
    findall(Nama, inventory(_, Nama, armor, Job, _, _, _, _, _, _, _, _, _), ListArmors).
    printItemList(ListArmors).
showEquippedArmor :-
    equippedArmor(ID),
    inventory(ID, Nama, _, _, _, _, _, _, _, _, _, _, _),
    format('~w (equipped)', Nama), nl, !.
showEquippedArmor :-
    write('No armors equipped.'), nl.

    /* Accessories */
showAccessories(ListAccessories) :-
    write('Your Accessories (auto equip): '), nl,
    playerInfo(_, Job, _, _, _),
    findall(Nama, inventory(_, Nama, accessory, Job, _, _, _, _, _, _, _, _, _), ListAccessories).
    printItemList(ListAccessories).


showPotions :- 
    write('Your Potions: '), nl,
    findall(Nama, inventory(_, Nama, potion, _, _, _, _, _, _, _, _, _, _), ListPotions).
    countPotions(healthPotion, ListPotions, NumHealthPotion), 
    countPotions(staminaPotion, ListPotions, NumStaminaPotion), 
    countPotions(manaPotion, ListPotions, NumManaPotion), 
    countPotions(xpPotion, ListPotions, NumXpPotion), 
    showHealthPotions(NumHealthPotion),
    showStaminaPotions(NumHealthPotion),
    showManaPotions(NumHealthPotion),
    showXpPotions(NumXpPotion).

showHealthPotions(0), !.
showHealthPotions(NumHealthPotion) :-
    format('healthPotion (x~d)', NumHealthPotion), nl.
showStaminaPotions(0), !.
showStaminaPotions(NumHealthPotion) :-
    format('staminaPotion (x~d)', NumStaminaPotion), nl.
showManaPotions(0), !.
showManaPotions(NumHealthPotion) :-
    format('manaPotion (x~d)', NumManaPotion), nl.
showXpPotions(0), !.
showXpPotions(NumXpPotion) :-
    format('xpPotion (x~d)', NumXpPotion), nl.


countPotions(PotionName, [], 0).
countPotions(PotionName, [H|T], Num) :-
    PotionName = H, !,
    count(PotionName, List, NumNext),
    Num is NumNext + 1.
countPotions(PotionName, [H|T], Num) :-
    countPotions(PotionName, T, Num)



    /* unusable Items */
showUnusableItemList :-


/* Init Items */
initItem(Job) :-


/* Use Item */
useItem(ID) :-      % untuk potion
    inventory(ID, Nama, potion, JobItem, LevelItem, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense),
    usePotion(ID).
useItem(ID) :-      % cek prasyarat Item
    inventory(ID, Nama, Tipe, JobItem, LevelItem, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense),
    playerInfo(_, JobPlayer, _, LevelPlayer, _), !
    LevelPlayer < LevelItem, !,
    JobItem =/= JobPlayer, !, fail.
useItem(ID) :-
    inventory(ID, Nama, Tipe, JobItem, LevelItem, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense),
    (
        Tipe =:= weapon -> useWeapon(ID);
        (
            Tipe =:= armor -> useArmor(ID);
            (
                Tipe =:= accessory -> useAccessory(ID)
            )
        )
    )
    /* untuk use dibawah, Player dapat memakai itemnya (level dan job valid) */
useWeapon(ID) :-       
    equippedWeapon(_),
    retract(equippedWeapon(_)),
    asserta(equippedWeapon(ID)), !.
useWeapon(ID) :-       
    asserta(equippedWeapon(ID)), !.

useArmor(ID) :-       
    equippedArmor(_),
    retract(equippedArmor(_)),
    asserta(equippedArmor(ID)), !.
useArmor(ID) :-       
    asserta(equippedArmor(ID)), !.

useAccessory(ID) :-       
    equippedAccessory(_),
    retract(equippedAccessory(_)),
    asserta(equippedAccessory(ID)), !.
useAccessory(ID) :-       
    asserta(equippedAccessory(ID)), !.


/* Delete and Add Player Item */
addItem(ID) :-
    item(ID, Nama, Tipe, Job, Level, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense),
    asserta(inventory(ID, Nama, Tipe, Job, Level, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense)).
delItem(ID) :-
    inventory(ID, _, _, _, _, _, _, _, _, _, _, _, _),
    retract(inventory(ID, _, _, _, _, _, _, _, _, _, _, _, _)).


  /* Show Items Status */
    /* Regen */
showItemHealthRegen(ID) :-
    inventory(ID, _, _, _, _, _, _, _, HealthRegen, _, _, _, _),
    HealthRegen =/= 0,
    format('    HealthRegen   : ~d per turn', HealthRegen), !.
showItemStaminaRegen(ID) :-
    inventory(ID, _, _, _, _, _, _, _, _, StaminaRegen, _, _, _),
    StaminaRegen =/= 0,
    format('    StaminaRegen  : ~d per turn', StaminaRegen), !.
showItemManaRegen(ID) :-
    inventory(ID, _, _, _, _, _, _, _, _, _, ManaRegen, _, _),
    ManaRegen =/= 0,
    format('    ManaRegen     : ~d per turn', ManaRegen), !.

    /* Max */
showItemMaxHealth(ID) :-
    inventory(ID, Nama, Tipe, Job, Level, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense),
    MaxHealth =/= 0,
    format('    MaxHealth     : +~d', MaxHealth), !.
showItemMaxStamina(ID) :-
    inventory(ID, Nama, Tipe, Job, Level, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense),
    MaxStamina =/= 0,
    format('    MaxStamina    : +~d', MaxStamina), !.
showItemMaxMana(ID) :-
    inventory(ID, Nama, Tipe, Job, Level, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense),
    MaxMana =/= 0,
    format('    MaxMana       : +~d', MaxMana), !.

    /* Attack and defense */
showItemAttack(ID) :-
    inventory(ID, Nama, Tipe, Job, Level, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense),
    Attack =/= 0,
    format('    Attack          : +~d', Attack), !.
showItemDefense(ID) :-
    inventory(ID, Nama, Tipe, Job, Level, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense),
    Defense =/= 0,
    format('    Defense         : +~d', Defense), !.