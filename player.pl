:- dynamic(inventory/14).
:- dynamic(playerInfo/5).
:- dynamic(playerStatus/11).
:- dynamic(equippedWeapon/1).
:- dynamic(equippedArmor/1).
:- dynamic(equippedAccessory/1).

/*:- include('items.pl').*/

/* playerInfo(Username, Job, Xp, Level, playerStatus/11) */
/* playerStatus(Health, Stamina, Mana, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense) */

/* STATUS */
status :-
    init(_),
    playerInfo(Username, Job, Xp, Level, playerStatus(Health, Stamina, Mana, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense)),
    nl, write('*** Your status ***'),nl,
    format('> ~w (~w)', [Username, Job]), nl,
    gold(X),
    format('> Gold      : ~d', [X]), nl,
    requiredXp(Level, LevelXp),
    format('> Level     : ~d (~d / ~d)', [Level, Xp, LevelXp]), nl, nl,
    format('> Attack    : ~d', [Attack]), nl,
    format('> Defense   : ~d', [Defense]), nl,
    format('> Health    : ~d / ~d (+~d per turn)', [Health, MaxHealth, HealthRegen]), nl,
    format('> Stamina   : ~d / ~d (+~d per turn)', [Stamina, MaxStamina, StaminaRegen]), nl,
    format('> Mana      : ~d / ~d (+~d per turn)', [Mana, MaxMana, ManaRegen]), nl.

/* LEVEL */
/* Required Xp untuk naik dari level n ke level n+1:  15 + 5*n Xp
   */
requiredXp(Level, LevelXp) :-
    LevelXp is (15 + 5 * Level).
updateLevel :-
    playerInfo(_, _, Xp, Level, _),
    requiredXp(Level, LevelXp), !,
    Xp < LevelXp, !.
updateLevel :-      /* bisa dipake juga waktu minum potion */
    playerInfo(_, _, Xp, Level, _),
    requiredXp(Level, LevelXp), !,
    Xp >= LevelXp,
    NewXp is Xp - LevelXp,
    NewLevel is Level + 1,
    retract(playerInfo(Username, Job, Xp, Level, playerStatus(Health, Stamina, Mana, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense))),
    retract(playerStatus(Health, Stamina, Mana, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense)),
    asserta(playerInfo(Username, Job, NewXp, NewLevel, playerStatus(Health, Stamina, Mana, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense))),
    asserta(playerStatus(Health, Stamina, Mana, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense)),
    updateLevel.


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
    updateLevel,
    updateBaseStats,
    updateBonusStats.


updateBaseStats :-
    playerInfo(Username, Job, Xp, Level, playerStatus(Health, Stamina, Mana, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense)),
    N is Level-1,
    (
        Job = swordsman ->
            NewMaxHealth is 100 + N * 12,
            NewHealthRegen is 3 + N * 1,
            NewMaxStamina is 100 + N * 10,
            NewStaminaRegen is 2 + N * 1,
            NewMaxMana is 50 + N * 4,
            NewManaRegen is 1 + N * 0,
            NewAttack is 14 + N * 3,
            NewDefense is 4 + N * 3;
        (
            Job = archer ->
                NewMaxHealth is 90 + N * 10,
                NewHealthRegen is 4 + N * 1,
                NewMaxStamina is 100 + N * 12,
                NewStaminaRegen is 3 + N * 1,
                NewMaxMana is 50 + N * 6,
                NewManaRegen is 1 + N * 0,
                NewAttack is 14 + N * 3,
                NewDefense is 4 + N * 2;
            (
                Job = sorcerer ->
                    NewMaxHealth is 100 + N * 8,
                    NewHealthRegen is 3 + N * 1,
                    NewMaxStamina is 50 + N * 8,
                    NewStaminaRegen is 1 + N * 1,
                    NewMaxMana is 100 + N * 12,
                    NewManaRegen is 4 + N * 1,
                    NewAttack is 12 + N * 4,
                    NewDefense is 2 + N * 2
            )
        )
    ),
    retract(playerInfo(Username, Job, Xp, Level, playerStatus(Health, Stamina, Mana, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense))),
    retract(playerStatus(Health, Stamina, Mana, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense)),
    asserta(playerInfo(Username, Job, Xp, Level, playerStatus(Health, Stamina, Mana, NewMaxHealth, NewMaxStamina, NewMaxMana, NewHealthRegen, NewStaminaRegen, NewManaRegen, NewAttack, NewDefense))),
    asserta(playerStatus(Health, Stamina, Mana, NewMaxHealth, NewMaxStamina, NewMaxMana, NewHealthRegen, NewStaminaRegen, NewManaRegen, NewAttack, NewDefense)).

updateBonusStats :-
    retrieveWeaponID(IDWeapon),
    retrieveArmorID(IDArmor),
    retrieveAccessoryID(IDAccessory),
    retrieveItemEffect(IDWeapon, MaxHealth1, MaxStamina1, MaxMana1, HealthRegen1, StaminaRegen1, ManaRegen1, Attack1, Defense1), 
    retrieveItemEffect(IDArmor, MaxHealth2, MaxStamina2, MaxMana2, HealthRegen2, StaminaRegen2, ManaRegen2, Attack2, Defense2), 
    retrieveItemEffect(IDAccessory, MaxHealth3, MaxStamina3, MaxMana3, HealthRegen3, StaminaRegen3, ManaRegen3, Attack3, Defense3), 
    playerInfo(Username, Job, Xp, Level, playerStatus(Health, Stamina, Mana, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense)),
    NewHealth is MaxHealth + MaxHealth1 + MaxHealth2 + MaxHealth3,
    NewHealthRegen is HealthRegen + HealthRegen1 + HealthRegen2 + HealthRegen3,
    NewStamina is MaxStamina + MaxStamina1 + MaxStamina2 + MaxStamina3,
    NewStaminaRegen is StaminaRegen + StaminaRegen1 + StaminaRegen2 + StaminaRegen3,
    NewMana is MaxMana + MaxMana1 + MaxMana2 + MaxMana3,
    NewManaRegen is ManaRegen + ManaRegen1 + ManaRegen2 + ManaRegen3,
    NewAttack is Attack + Attack1 + Attack2 + Attack3,
    NewDefense is Defense + Defense1 + Defense2 + Defense3,
    retract(playerInfo(Username, Job, Xp, Level, playerStatus(Health, Stamina, Mana, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense))),
    retract(playerStatus(Health, Stamina, Mana, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense)),
    asserta(playerInfo(Username, Job, Xp, Level, playerStatus(Health, Stamina, Mana, NewHealth, NewStamina, NewMana, NewHealthRegen, NewStaminaRegen, NewManaRegen, NewAttack, NewDefense))),
    asserta(playerStatus(Health, Stamina, Mana, NewHealth, NewStamina, NewMana, NewHealthRegen, NewStaminaRegen, NewManaRegen, NewAttack, NewDefense)).
    
retrieveItemEffect(ID, MaxHealth1, HealthRegen1, MaxStamina1, StaminaRegen1, MaxMana1, ManaRegen1, Attack1, Defense1) :-
    \+ inventory(ID,_,_,_, _,_,_,_,_, _,_,_,_,_),
    HealthRegen1 is 0,
    MaxHealth1 is 0,
    StaminaRegen1 is 0,
    MaxStamina1 is 0,
    ManaRegen1 is 0,
    MaxMana1 is 0,
    Attack1 is 0,
    Defense1 is 0, !.

retrieveItemEffect(ID, MaxHealth1, HealthRegen1, MaxStamina1, StaminaRegen1, MaxMana1, ManaRegen1, Attack1, Defense1) :-
    inventory(ID, Nama, Tipe, Job, Level, Amount, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense),
    HealthRegen1 is HealthRegen,
    MaxHealth1 is MaxHealth,
    StaminaRegen1 is StaminaRegen,
    MaxStamina1 is MaxStamina,
    ManaRegen1 is ManaRegen,
    MaxMana1 is MaxMana,
    Attack1 is Attack,
    Defense1 is Defense, !.


retrieveWeaponID(IDResult) :-
    \+ equippedWeapon(IDWeapon), 
    IDResult is 0.
retrieveWeaponID(IDResult) :-
    equippedWeapon(IDWeapon), 
    IDResult is IDWeapon.
retrieveArmorID(IDResult) :-
    \+ equippedArmor(IDArmor), 
    IDResult is 0.
retrieveArmorID(IDResult) :-
    equippedArmor(IDArmor), 
    IDResult is IDArmor.
retrieveAccessoryID(IDResult) :-
    \+ equippedAccessory(IDAccessory), 
    IDResult is 0.
retrieveAccessoryID(IDResult) :-
    equippedAccessory(IDAccessory), 
    IDResult is IDAccessory.



/*** PLAYER INVENTORY ***/
/* inventory(ID, Nama, Tipe, Job, Level, Amount, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense). */

initItem :-
    init(_),
    item(001, Nama, Tipe, Job, Level, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense),
    assertz(inventory(001, Nama, Tipe, Job, Level, 5, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense)).

printItemList([], []).
printItemList([HName|TName], [HAmount|TAmount]) :-
    format('> ~w (x ~d)', [HName, HAmount]), nl,
    printItemList(TName, TAmount).

showUsableItemList :-
    showWeapons,
    showArmors,
    showAccessories,
    showPotions.

/* sub fungsi dari showUsableItemList */
    /* Weapons */
showWeapons :-     % show equipped
    write('Your Weapons: '), nl,
    showEquippedWeapon,
    playerInfo(_, Job, _, _, _),
    findall(Nama, inventory(_, Nama, weapon, Job, _, _, _, _, _, _, _, _, _, _), ListWeapons),
    findall(Amount, inventory(_, _, weapon, Job, _, Amount, _, _, _, _, _, _, _, _), ListAmount),
    printItemList(ListWeapons, ListAmount), nl.
showEquippedWeapon :-
    \+(equippedWeapon(_)), !,
    write('     (No weapons equipped)'), nl, !.
showEquippedWeapon :-
    equippedWeapon(ID),
    inventory(ID, Nama, _, _, _, _, _, _, _, _, _, _, _, _),
    format('* ~w (equipped)', [Nama]), nl, !.

    /* Armors */
showArmors :-
    write('Your Armors: '), nl,
    showEquippedArmor,
    playerInfo(_, Job, _, _, _),
    findall(Nama, inventory(_, Nama, armor, Job, _, _, _, _, _, _, _, _, _, _), ListArmors),
    findall(Amount, inventory(_, _, armor, Job, _, Amount, _, _, _, _, _, _, _, _), ListAmount),
    printItemList(ListArmors, ListAmount), nl.
showEquippedArmor :-
    \+(equippedArmor(_)),
    write('     (No armors equipped)'), nl, !.
showEquippedArmor :-
    equippedArmor(ID),
    inventory(ID, Nama, _, _, _, _, _, _, _, _, _, _, _, _),
    format('* ~w (equipped)', [Nama]), nl, !.

    /* Accessories */
showAccessories :-
    write('Your Accessories: '), nl,
    showEquippedAccessory,
    playerInfo(_, Job, _, _, _),
    findall(Nama, inventory(_, Nama, accessory, Job, _, _, _, _, _, _, _, _, _, _), ListAccessories),
    findall(Amount, inventory(_, _, accessory, Job, _, Amount, _, _, _, _, _, _, _, _), ListAmount),
    printItemList(ListAccessories, ListAmount), nl.
showEquippedAccessory :-
    \+(equippedAccessory(_)),
    write('     (No accessory equipped)'), nl, !.
showEquippedAccessory :-
    equippedAccessory(ID),
    inventory(ID, Nama, _, _, _, _, _, _, _, _, _, _, _, _),
    format('* ~w (equipped)', [Nama]), nl, !.

showPotions :-
    nl, write('Your Potions: '), nl,
    showHealthPotions,
    showStaminaPotions,
    showManaPotions.

noPotionsExist :-
    \+ inventory(_, _, potion, _, _, _, _, _, _, _, _, _, _, _), !.

showHealthPotions :-
    \+ inventory(_, healthPotion, potion, _, _, _, _, _, _, _, _, _, _, _), !.
showHealthPotions :-
    inventory(_, healthPotion, potion, _, _, Amount, _, _, _, _, _, _, _, _), 
    format('> healthPotion      :    ~d', [Amount]), nl.

showStaminaPotions :-
    \+ inventory(_, staminaPotion, potion, _, _, _, _, _, _, _, _, _, _, _), !.
showStaminaPotions :-
    inventory(_, staminaPotion, potion, _, _, Amount, _, _, _, _, _, _, _, _), 
    format('> staminaPotion     :    ~d', [Amount]), nl.

showManaPotions :-
    \+ inventory(_, manaPotion, potion, _, _, _, _, _, _, _, _, _, _, _), !.
showManaPotions :-
    inventory(_, manaPotion, potion, _, _, Amount, _, _, _, _, _, _, _, _), 
    format('> manaPotions       :    ~d', [Amount]), nl.

/*
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
*/
/*
showHealthPotions(0), !.
showHealthPotions(NumHealthPotion) :-
    format('healthPotion (x~d)', [NumHealthPotion]), nl.
showStaminaPotions(0), !.
showStaminaPotions(NumHealthPotion) :-
    format('staminaPotion (x~d)', [NumStaminaPotion]), nl.
showManaPotions(0), !.
showManaPotions(NumHealthPotion) :-
    format('manaPotion (x~d)', [NumManaPotion]), nl.
showXpPotions(0), !.
showXpPotions(NumXpPotion) :-
    format('xpPotion (x~d)', [NumXpPotion]), nl.
*/

/*
countPotions(PotionName, [], 0).
countPotions(PotionName, [H|T], Num) :-
    PotionName = H, !,
    count(PotionName, List, NumNext),
    Num is NumNext + 1.
countPotions(PotionName, [H|T], Num) :-
    countPotions(PotionName, T, Num) */


    /* unusable Items */

showUnusableItemList :-
    playerInfo(_, Job, _, PlayerLevel, _),
    (
        Job = swordsman ->
            showUnusableItemByJob(archer), showUnusableItemByJob(sorcerer);
        (
            Job = archer ->
                showUnusableItemByJob(swordsman), showUnusableItemByJob(sorcerer);
            (
                Job = sorcerer ->
                    showUnusableItemByJob(swordsman), showUnusableItemByJob(archer)
            )
        )
    ), nl,
    showUnusableItemByLevel(PlayerLevel).

% inventory(ID, Nama, Tipe, Job, Level, Amount, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense)
/* inventory(ID, Nama, Tipe, Job, Level, Amount, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense) */
showUnusableItemByJob(Job) :-
    \+ inventory(_, _, _, Job, _, _, _, _, _, _, _, _, _, _), !.
showUnusableItemByJob(Job) :-
    nl, write('Job-mu tidak sesuai untuk menggunakan item ini: '), nl,
    forall(inventory(_, Nama, _, Job, _, Amount, _, _, _, _, _, _, _, _),
        (
            format('> ~w (x ~d)', [Nama, Amount]), nl
        )
    ), nl.

showUnusableItemByLevel(PlayerLevel) :-
    forall(inventory(_, _, _, _, ItemLevel, _, _, _, _, _, _, _, _, _),
        (
            PlayerLevel > ItemLevel
        )
    ),
    !.
showUnusableItemByLevel(PlayerLevel) :-
    write('Levelmu tidak cukup untuk menggunakan item ini: '), nl,
    forall(inventory(_, Nama, _, _, ItemLevel, Amount, _, _, _, _, _, _, _, _),
        (
            ItemLevel > PlayerLevel ->
                format('> ~w (x ~d)', [Nama, Amount]), nl
        )
    ), !.

/*** Validasi ITEM ***/
/*
    playerInfo(Username, Job, Xp, Level, playerStatus/11)
    playerStatus(Health, Stamina, Mana, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense)
*/
isItemEquipable(ID, Result) :-
    playerInfo(_, JobPlayer, _, LevelPlayer, _),
    inventory(ID, _, _, JobItem, LevelItem, _, _, _, _, _, _, _, _, _),
    \+ JobPlayer = JobItem,
    LevelPlayer < LevelItem,
    Result = no, !.
isItemEquipable(ID, Result) :-
    playerInfo(_, _, _, _, _),
    inventory(ID, _, Tipe, _, _, _, _, _, _, _, _, _, _, _),
    Tipe = unrestricted,
    Result = no, !.
isItemEquipable(ID, yes).



/* Use Item (ID) */
useItem(ID) :-
    inventory(ID, _, Tipe, JobItem, LevelItem, _, _, _, _, _, _, _, _, _),
    playerInfo(_, JobPlayer, _, LevelPlayer, _), !,
    LevelPlayer >= LevelItem, !,
    JobItem = JobPlayer,
    (
        Tipe = weapon -> useWeapon(ID);
        (
            Tipe = armor -> useArmor(ID);
            (
                Tipe = accessory -> useAccessory(ID)
            )
        )
    ), !.
useItem(ID) :-      /*cek prasyarat Item*/
    write('Kamu tidak bisa menggunakan item ini'), !.
    /* untuk use dibawah, Player dapat memakai itemnya (level dan job valid) */
useWeapon(ID) :-       
    \+ equippedWeapon(_),
    asserta(equippedWeapon(ID)), !.
useWeapon(ID) :-       
    retract(equippedWeapon(_)),
    asserta(equippedWeapon(ID)), !.

useArmor(ID) :-       
    \+ equippedArmor(_),
    asserta(equippedArmor(ID)), !.
useArmor(ID) :-       
    retract(equippedArmor(_)),
    asserta(equippedArmor(ID)), !.

useAccessory(ID) :-       
    \+ equippedAccessory(_),
    asserta(equippedAccessory(ID)), !.
useAccessory(ID) :-       
    retract(equippedAccessory(_)),
    asserta(equippedAccessory(ID)), !.


/* Delete and Add Player Item */
checkCapacity(Result) :-
    findall(Amount, inventory(_, _, _, _, _, Amount, _, _, _, _, _, _, _, _), ListAmountAll),
    countCurrentCapacity(ListAmountAll, CurrentCapacity),
    (
        CurrentCapacity > 100 -> Result = full;
        Result = available
    ).

countCurrentCapacity([], 0).
countCurrentCapacity([H|T], Result) :-
    countCurrentCapacity(T, NextResult),
    Result is NextResult + H.

addItem(ID) :-
    item(ID, Nama, Tipe, Job, Level, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense),
    \+(inventory(ID, Nama, Tipe, Job, Level, Amount, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense)),
    asserta(inventory(ID, Nama, Tipe, Job, Level, 1, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense)), !.
addItem(ID) :-
    inventory(ID, Nama, Tipe, Job, Level, Amount, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense),
    NewAmount is Amount + 1,
    retract(inventory(ID, Nama, Tipe, Job, Level, Amount, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense)),
    asserta(inventory(ID, Nama, Tipe, Job, Level, NewAmount, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense)).
delItem(ID) :-
    \+(inventory(ID, _, _, _, _, _, _, _, _, _, _, _, _, _)),
    nl, write('Tidak ada item di inventory'), nl, !.

delItem(ID) :-
    equippedWeapon(ID), 
    inventory(ID, _, _, _, _, Amount, _, _, _, _, _, _, _, _), 
    Amount =:= 1,
    write('Kamu masih menggunakan item ini'), nl,
    !.
delItem(ID) :-
    equippedArmor(ID), 
    inventory(ID, _, _, _, _, Amount, _, _, _, _, _, _, _, _), !,
    Amount =:= 1,
    write('Kamu masih menggunakan item ini'), nl,
    !.
delItem(ID) :-
    equippedAccessory(ID), 
    inventory(ID, _, _, _, _, Amount, _, _, _, _, _, _, _, _), 
    Amount =:= 1,
    write('Kamu masih menggunakan item ini'), nl,
    !.
delItem(ID) :-
    inventory(ID, _, _, _, _, Amount, _, _, _, _, _, _, _, _),
    Amount =:= 1,
    retract(inventory(ID, _, _, _, _, _, _, _, _, _, _, _, _, _)),
    nl, write('You dropped an item!'), nl, !.
delItem(ID) :-
    inventory(ID, Nama, Tipe, Job, Level, Amount, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense),
    NewAmount is Amount - 1,
    retract(inventory(ID, Nama, Tipe, Job, Level, Amount, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense)),
    asserta(inventory(ID, Nama, Tipe, Job, Level, NewAmount, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense)),
    nl, write('You dropped an item!'), nl, !.



    /* Regen */
showItemHealthRegen(ID) :-
    inventory(ID, _, _, _, _, _, _, _, _, HealthRegen, _, _, _, _),
    HealthRegen =\= 0,
    format('    HealthRegen   : ~d per turn', [HealthRegen]), nl, !.
showItemStaminaRegen(ID) :-
    inventory(ID, _, _, _, _, _, _, _, _, _, StaminaRegen, _, _, _),
    StaminaRegen =\= 0,
    format('    StaminaRegen  : ~d per turn', [StaminaRegen]), nl, !.
showItemManaRegen(ID) :-
    inventory(ID, _, _, _, _, _, _, _, _, _, _, ManaRegen, _, _),
    ManaRegen =\= 0,
    format('    ManaRegen     : ~d per turn', [ManaRegen]), nl, !.

    /* Max */
showItemMaxHealth(ID) :-
    inventory(ID, _, _, _, _, _, MaxHealth, _, _, _, _, _, _, _),
    MaxHealth =\= 0,
    format('    MaxHealth     : +~d', [MaxHealth]), nl, !.
showItemMaxStamina(ID) :-
    inventory(ID, _, _, _, _, _, _, MaxStamina, _, _, _, _, _, _),
    MaxStamina < 0,
    format('    MaxStamina    : ~d', [MaxStamina]), nl, !.
showItemMaxMana(ID) :-
    inventory(ID, _, _, _, _, _, _, _, MaxMana, _, _, _, _, _),
    MaxMana =\= 0,
    format('    MaxMana       : +~d', [MaxMana]), nl, !.

    /* Attack and defense */
showItemAttack(ID) :-
    inventory(ID, _, _, _, _, _, _, _, _, _, _, _, Attack, _),
    Attack =\= 0,
    format('    Attack          : +~d', [Attack]), nl, !.
showItemDefense(ID) :-
    inventory(ID, _, _, _, _, _, _, _, _, _, _, _, _, Defense),
    Defense =\= 0,
    format('    Defense         : +~d', [Defense]), nl, !.