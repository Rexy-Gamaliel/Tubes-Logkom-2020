
/* playerInfo(Username, Job, Xp, Level, playerStatus/11) */
/* playerStatus(Health, Stamina, Mana, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense) */

/* STATUS */
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


/* PLAYER INVENTORY */
/* inventory(ID, Nama, Tipe, Job, Level, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense). */
bag :-
    init(_),

showItemList :-
    findall(Nama, )

  /* Show Item's Buffs */
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