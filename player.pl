:- dynamic(inventory/14).
:- dynamic(playerInfo/5).
:- dynamic(playerStatus/11).

:- include('items.pl').

/* playerInfo(Username, Job, Xp, Level, playerStatus/11) */
/* playerStatus(Health, Stamina, Mana, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense) */

/* STATUS */
initPlayer :-.


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
updateLevel :-
    playerInfo(_, _, Xp, Level, _),
    RequiredXp(Level, LevelXp), !,
    Xp >= LevelXp,
    NewXp is Xp - LevelXp,
    NewLevel is Level + 1,
    retract(playerInfo(Username, Job, Xp, Level, playerStatus(Health, Stamina, Mana, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense))),
    asserta(playerInfo(Username, Job, NewXp, NewLevel, playerStatus(Health, Stamina, Mana, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense))),
    updateLevel, !.


/*** PLAYER STATUS ***/
/*
    Base Stats:         
        Stats = b + n * k       n = Level-1
                        Swordsman   Archer      Sorcerer
                        (n, k)      (n, k)      (n, k)
        MHealth :       (100, 12)   (90, 10)    (100,8)
        HealthR :       (3, 1)      (4, 1)      (3, 1)
        MStamina:       (100, 10)   (100,12)    (50, 8)
        StaminaR:       (2, 1)      (3, 1)      (1, 1)
        MMana   :       (50, 4)     (50, 6)     (100, 12)
        ManaR   :       (1, 0)      (1, 0)      (4, 1)
        Attack  :       (14, 3)     (14, 3)     (12, 4)
        Defense :       (4, 3)      (4, 2)      (2, 2)
    Bonus Stats:    (effects from items and accesories)
        (sesuai item)
    Immediate Effect: (potions)
    
*/
updatePlayerStatus :-
    updateBaseStats,
    updateBonusStats.


updateBaseStats :-
    playerInfo(Username, Job, Xp, Level, playerStatus(Health, Stamina, Mana, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense)),
    N is Level-1,
    (
        Job =:= swordsman ->
            NewMaxHealth is 100 + N * 12,
            NewHealthRegen is 3 + N * 1,
            NewMaxStamina is 100 + N * 10,
            NewStaminaRegen is 2 + N * 1,
            NewMaxMana is 50 + N * 4,
            NewManaRegen is 1 + N * 0,
            NewAttack is 14 + N * 3,
            NewDefense is 4 + N * 3;
        (
            Job =:= archer ->
                NewMaxHealth is 90 + N * 10,
                NewHealthRegen is 4 + N * 1,
                NewMaxStamina is 100 + N * 12,
                NewStaminaRegen is 3 + N * 1,
                NewMaxMana is 50 + N * 6,
                NewManaRegen is 1 + N * 0,
                NewAttack is 14 + N * 3,
                NewDefense is 4 + N * 2;
            (
                Job =:= sorcerer ->
                    NewMaxHealth is 100 + N * 8,
                    NewHealthRegen is 3 + N * 1,
                    NewMaxStamina is 50 + N * 8,
                    NewStaminaRegen is 1 + N * 1,
                    NewMaxMana is 100 + N * 12,
                    NewManaRegen is 4 + N * 1,
                    NewAttack is 12 + N * 4,
                    NewDefense is 2 + N * 2;
            )
        )
    )
    retract(playerInfo(Username, Job, Xp, Level, playerStatus(Health, Stamina, Mana, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense))),
    asserta(playerInfo(Username, Job, Xp, Level, playerStatus(NewHealth, NewStamina, NewMana, NewMaxHealth, NewMaxStamina, NewMaxMana, NewHealthRegen, NewStaminaRegen, NewManaRegen, NewAttack, NewDefense))).

updateBonusStats :-
    equippedWeapon(IDWeapon),
    equippedArmor(IDArmor),
    equippedAccessory(IDAccessory),
    item(IDWeapon, Nama, Tipe, Job, Level, MaxHealth1, MaxStamina1, MaxMana1, HealthRegen1, StaminaRegen1, ManaRegen1, Attack1, Defense1), 
    item(IDArmor, Nama, Tipe, Job, Level, MaxHealth2, MaxStamina2, MaxMana2, HealthRegen2, StaminaRegen2, ManaRegen2, Attack2, Defense2), 
    item(IDAccessory, Nama, Tipe, Job, Level, MaxHealth3, MaxStamina3, MaxMana3, HealthRegen3, StaminaRegen3, ManaRegen3, Attack3, Defense3), 
    playerInfo(Username, Job, Xp, Level, playerStatus(Health, Stamina, Mana, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense)),
    NewHealth is MaxHealth1 + MaxHealth1 + MaxHealth2 + MaxHealth3,
    NewHealthRegen is HealthRegen + HealthRegen1 + HealthRegen2 + HealthRegen3,
    NewStamina is MaxStamina + MaxStamina1 + MaxStamina2 + MaxStamina3,
    NewStaminaRegen is StaminaRegen + StaminaRegen1 + StaminaRegen2 + StaminaRegen3,
    NewMana is MaxMana + MaxMana1 + MaxMana2 + MaxMana3,
    NewManaRegen is ManaRegen + ManaRegen1 + ManaRegen2 + ManaRegen3,
    NewAttack is Attack + Attack1 + Attack2 + Attack3,
    NewDefense is Defense + Defense1 + Defense2 + Defense3,
    retract(playerInfo(Username, Job, Xp, Level, playerStatus(Health, Stamina, Mana, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense))),
    asserta(playerInfo(Username, Job, Xp, Level, playerStatus(Health, Stamina, Mana, NewHealth, NewStamina, NewMana, NewHealthRegen, NewStaminaRegen, NewManaRegen, NewAttack, NewDefense))).
    
    



/*** PLAYER STATUS ***/
/*
    Base Stats:         
        Stats = b + n * k       n = Level-1
                        Swordsman   Archer      Sorcerer
                        (n, k)      (n, k)      (n, k)
        Health  :       (100, 12)   (90, 10)    (100,8)
        HealthR :       (3, 1)      (4, 1)      (3, 1)
        Stamina :       (100, 10)   (100,12)    (50, 8)
        StaminaR:       (2, 1)      (3, 1)      (1, 1)
        Mana    :       (50, 6)     (50,8)      (100, 12)
        ManaR   :       (1, 0)      (1, 0)      (4, 1)
        Attack  :       (14, 3)     (14, 3)     (12, 4)
        Defense :       (4, 3)      (4, 2)      (2, 2)
    Bonus Stats:    (effects from items and accesories)
        (sesuai item)
    Immediate Effect: (potions)
    
*/
updatePlayerStatus :-



updateBaseStats :-
    playerInfo(Username, Job, Xp, Level, playerStatus(Health, Stamina, Mana, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense)),
    N is Level -1,
    (
        Job =:= Swordsman ->
            NewHealth is 100 + N * 12,
            HealthRegen,
            Stamina,
            StaminaRegen,
            Mana,
            ManaRegen,
            Att

    )




/*** PLAYER INVENTORY ***/
/* inventory(ID, Nama, Tipe, Job, Level, Amount, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense). */
showItem :-
    init(_),
    write('Your Items: '), nl,
    showUsableItemList,
    write('..and some junks'), nl,
    showUnusableItemList.

printItemList([], Num).
printItemList([H|T]) :-
    format('> ~w (x ~d)', [H, Num]), nl,
    printItemList(T).

showUsableItemList :-

/* sub fungsi dari showUsableItemList */
    /* Weapons */
showWeapons(ListWeapons) :-     % show equipped
    write('Your Weapons: '), nl,
    showEquippedWeapon,
    playerInfo(_, Job, _, _, _),
    findall(Nama, inventory(_, Nama, weapon, Job, _, _, _, _, _, _, _, _, _, _), ListWeapons),
    findall(Nama, inventory(_, Nama, weapon, Job, _, Amount, _, _, _, _, _, _, _, _), ListAmount),
    printItemList(ListWeapons).
showEquippedWeapon :-
    equippedWeapon(ID),
    inventory(ID, Nama, _, _, _, _, _, _, _, _, _, _, _, _),
    format('~w (equipped)', Nama), nl, !.
showEquippedWeapon :-
    write('(No weapons equipped)'), nl.

    /* Armors */
showArmors(ListArmors) :-
    write('Your Armors: '), nl,
    showEquippedArmor,
    playerInfo(_, Job, _, _, _),
    findall(Nama, inventory(_, Nama, armor, Job, _, _, _, _, _, _, _, _, _, _), ListArmors).
    printItemList(ListArmors).
showEquippedArmor :-
    equippedArmor(ID),
    inventory(ID, Nama, _, _, _, _, _, _, _, _, _, _, _, _),
    format('~w (equipped)', Nama), nl, !.
showEquippedArmor :-
    write('(No armors equipped)'), nl.

    /* Accessories */
showAccessories(ListAccessories) :-
    write('Your Accessories: '), nl,
    showEquippedAccessory,
    playerInfo(_, Job, _, _, _),
    findall(Nama, inventory(_, Nama, accessory, Job, _, _, _, _, _, _, _, _, _, _), ListAccessories).
    printItemList(ListAccessories).
showEquippedAccessory :-
    equippedAccessory(ID),
    inventory(ID, Nama, _, _, _, _, _, _, _, _, _, _, _, _),
    format('~w (equipped)', Nama), nl, !.
showEquippedAccessory :-
    write('(No accessory equipped)'), nl.


showPotions :- 
    write('Your Potions: '), nl,
    findall(Nama, inventory(_, Nama, potion, _, _, _, _, _, _, _, _, _, _, _), ListPotions).
    countPotions(healthPotion, ListPotions, NumHealthPotion), 
    countPotions(staminaPotion, ListPotions, NumStaminaPotion), 
    countPotions(manaPotion, ListPotions, NumManaPotion), 
    countPotions(xpPotion, ListPotions, NumXpPotion), 
    showHealthPotions(NumHealthPotion),
    showStaminaPotions(NumHealthPotion),
    showManaPotions(NumHealthPotion),
    showXpPotions(NumXpPotion).

/*
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
*/

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
    inventory(ID, Nama, potion, JobItem, LevelItem, Amount, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense),
    usePotion(ID).
useItem(ID) :-      % cek prasyarat Item
    inventory(ID, Nama, Tipe, JobItem, LevelItem, Amount, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense),
    playerInfo(_, JobPlayer, _, LevelPlayer, _), !
    LevelPlayer < LevelItem, !,
    JobItem =/= JobPlayer, !, fail.
useItem(ID) :-
    inventory(ID, Nama, Tipe, JobItem, LevelItem, Amount, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense),
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
    \+ inventory(ID, Nama, Tipe, Job, Level, Amount, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense),
    asserta(inventory(ID, Nama, Tipe, Job, Level, Amount, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense)), !.
addItem(ID) :-
    inventory(ID, Nama, Tipe, Job, Level, Amount, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense),
    NewAmount is Amount + 1,
    inventory(ID, Nama, Tipe, Job, Level, NewAmount, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense).
delItem(ID) :-
    \+ inventory(ID, _, _, _, _, _, _, _, _, _, _, _, _, _),
    write('Tidak ada item di inventory'), nl, !.
delItem(ID) :-
    inventory(ID, _, _, _, _, Amount, _, _, _, _, _, _, _, _),
    Amount =:= 1,
    retract(inventory(ID, _, _, _, _, _, _, _, _, _, _, _, _, _)), !.
delItem(ID) :-
    inventory(ID, _, _, _, _, Amount, _, _, _, _, _, _, _, _),
    NewAmount is Amount - 1,
    retract(inventory(ID, _, _, _, _, NewAmount, _, _, _, _, _, _, _, _)), !.


  /* Show Items Status */
    /* Regen */
showItemHealthRegen(ID) :-
    inventory(ID, _, _, _, _, _, _, _, _, HealthRegen, _, _, _, _),
    HealthRegen =/= 0,
    format('    HealthRegen   : ~d per turn', HealthRegen), !.
showItemStaminaRegen(ID) :-
    inventory(ID, _, _, _, _, _, _, _, _, _, StaminaRegen, _, _, _),
    StaminaRegen =/= 0,
    format('    StaminaRegen  : ~d per turn', StaminaRegen), !.
showItemManaRegen(ID) :-
    inventory(ID, _, _, _, _, _, _, _, _, _, _, ManaRegen, _, _),
    ManaRegen =/= 0,
    format('    ManaRegen     : ~d per turn', ManaRegen), !.

    /* Max */
showItemMaxHealth(ID) :-
    inventory(ID, Nama, Tipe, Job, Level, Amount, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense),
    MaxHealth =/= 0,
    format('    MaxHealth     : +~d', MaxHealth), !.
showItemMaxStamina(ID) :-
    inventory(ID, Nama, Tipe, Job, Level, Amount, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense),
    MaxStamina < 0,
    format('    MaxStamina    : ~d', MaxStamina), !.
showItemMaxStamina(ID) :-
    inventory(ID, Nama, Tipe, Job, Level, Amount, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense),
    MaxStamina =/= 0,
    format('    MaxStamina    : +~d', MaxStamina), !.
showItemMaxMana(ID) :-
    inventory(ID, Nama, Tipe, Job, Level, Amount, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense),
    MaxMana =/= 0,
    format('    MaxMana       : +~d', MaxMana), !.

    /* Attack and defense */
showItemAttack(ID) :-
    inventory(ID, Nama, Tipe, Job, Level, Amount, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense),
    Attack =/= 0,
    format('    Attack          : +~d', Attack), !.
showItemDefense(ID) :-
    inventory(ID, Nama, Tipe, Job, Level, Amount, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense),
    Defense =/= 0,
    format('    Defense         : +~d', Defense), !.