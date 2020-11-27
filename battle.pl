:- dynamic(curEnemyInfo/9).     /* curEnemyInfo(ID, EnemyName, EnemyType, EnemyLevel, EnemyMaxHealth, EnemyHealth, EnemyHealthRegen, EnemyBasicAttack, EnemySpecialAttack) */
:- dynamic(curBossInfo/8).      /* curBossInfo(BossName, BossType, BossLevel, BossMaxHealth, BossHealth, BossHealthRegen, BossBasicAttack, BossSpecialAttack), */
:- dynamic(playerInfo/5).       /* playerInfo(Username, Job, Xp, Level, playerStatus/11) */
:- dynamic(playerStatus/11).    /* playerStatus(Health, Stamina, Mana, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense) */
:- dynamic(inBattle/1).
:- dynamic(initBoss/1).
:- dynamic(cooldownPlayer/1).
:- dynamic(cooldownEnemy/1).

/*:- dynamic(init/1).*/

:- include('enemies.pl').
:- include('player.pl').

/*
:- include('map.pl').
:- include('command.pl').
*/

/***  ToDo  ***/ 
/** -   Integrasi peta, player, inventory, main program, dll.
    -   Mekanisme usePotion.
    -   Mekanisme lawan Boss.
    -   Atribut boss dan normal enemy di database dan di game (setelah bergantung levelling, dsb).
    -   Penyesuaian hasil action terhadap atribut musuh dan player.

/*** Flow Battle ***/
/**
    1.  start.
    2.  choose commands
    3.  player attack|special -> enemy death/alive?
    4.  stats output
    5.  enemy alive -> counterAttack -> player death/alive?
    6.  stats output
    7.  go to 2. 
**/

/*** Memulai pertarungan ***/
start :-
    /*asserta(init(1)),*/
    initFight,!.
    
initFight :-
    asserta(inBattle(1)),
    initPlayer,
    /*initMap,*/
    normalEnemyAppeared,
    curBattleStatus,
    commands,!.

/* playerInfo(Username, Job, Xp, Level, playerStatus/11) */
/* playerStatus(Health, Stamina, Mana, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense) */
initPlayer :-
    asserta(playerInfo(player, swordsman, 0, 1, playerStatus(100, 100, 50, 100, 100, 50, 3, 3, 1, 14, 4))),
    asserta(playerStatus(100, 100, 50, 100, 100, 50, 3, 3, 1, 14, 4)),!.


/*** menghasilkan ID musuh sesuai Zona pemain berada ***/
getEnemyID(X) :-
    zone(Z),
    (
        Z =:= 1 ->
        random(1,6,ID);
        Z =:= 2 ->
        random(11,16,ID);
        Z =:= 3 ->
        random(6,11,ID)
    ),
    X = ID, !.

/*** Mendatangkan satu musuh "normal" dengan status level tertentu, dll. ***/
/** 
Notes:   
    - Blm diatur terhadap zone, musuh diacak terhadap ID-nya.
    - Rentang level musuh adalah [MinLevel, Level2).
    - Basic attack, Special Attack, Max Health, bisa diliat di bawah.
    - Penyesuaian stats pemain dan normal enemy diperlukan. 
**/
normalEnemyAppeared :-
    inBattle(_),
    random(1,16,ID),
    enemyInfo(ID, EnemyName, EnemyType,_, EnemyMaxHealth, EnemyHealthRegen, EnemyBasicAttack, EnemySpecialAttack),
    playerInfo(_,_,_,Level,_),
    Level2 is Level + 1,
    MinLevel is Level2//2,
    EnemyHealth is EnemyMaxHealth + 3*Level - 3,
    random(MinLevel, Level2, EnemyLevel),
    EnemyBasicAttack2 is EnemyBasicAttack + Level - 1,
    EnemySpecialAttack2 is EnemySpecialAttack + Level - 1,
    asserta(curEnemyInfo(ID, EnemyName, EnemyType, EnemyLevel, EnemyMaxHealth, EnemyHealth, EnemyHealthRegen, EnemyBasicAttack2, EnemySpecialAttack2)),
    asserta(cooldownPlayer(0)),
    asserta(cooldownEnemy(0)),
    nl, write('Kamu bertemu '), write(EnemyName), write('. Bersiaplah!'), nl, nl.

/*** Boss Triggered ***/
/** 
Notes:   
    - Penyesuaian stats pemain dan boss pada database diperlukan. 
**/
bossAppeared :-
    inBattle(_),
    asserta(initBoss(1))),
    playerInfo(Username,_,_,_,_),
    bossInfo(BossName, BossType, BossLevel, BossMaxHealth, BossHealthRegen, BossBasicAttack, BossSpecialAttack),
    BossHealth is BossMaxHealth,
    asserta(curBossInfo(BossName, BossType, BossLevel, BossMaxHealth, BossHealth, BossHealthRegen, BossBasicAttack, BossSpecialAttack)),
    asserta(cooldownPlayer(0)),
    asserta(cooldownEnemy(0)),
    nl, write('Persiapkanlah dirimu '), write(Username), write('!'), nl,
    write('Puncak kejayaan sudah di depan mata.'), nl,
    write('Kalahkan '), write(BossName), write(' dan raihlah puncak kejayaan. Bersiaplah!'), nl, nl.

/*** Battle Screen Commands ***/
commands :-
    inBattle(_),
    write('::::: Your turn :::::'), nl,
    write('> attack.'), nl,
    write('> specialAttack.'), nl,
    write('> usePotion.'), nl,
    write('> run.'),nl,
    write('Masukkan perintah yang sesuai. Misal, ketik "attack." untuk melakukan basic attack.'), nl, !.

/*** Menampilkan status player dan musuh saat ini ***/
curBattleStatus :-
    inBattle(_),
    playerStatus(Health, Stamina, Mana,_,_,_,_,_,_, Attack, Defense),
    (
        initBoss(_) ->  curBossInfo(BossName, BossType, BossLevel, BossMaxHealth, BossHealth, BossHealthRegen, BossBasicAttack, BossSpecialAttack),
                        EnemyName is BossName,
                        EnemyHealth is BossHealth,
                        EnemyLevel is BossLevel,
                        EnemyType is BossType;

        curEnemyInfo(_,NormalEnemyName, NormalEnemyType, NormalEnemyLevel,_,NormalEnemyHealth,_,_,_),
        EnemyName is NormalEnemyName,
        EnemyHealth is NormalEnemyHealth,
        EnemyLevel is NormalEnemyLevel,
        EnemyType is NormalEnemyType
    ),

    write('*** Enemy status ***'), nl,
    write('~ Name: '), write(EnemyName), nl,
    write('~ Health: '), write(EnemyHealth), nl,
    write('~ Level: '), write(EnemyLevel), nl,
    write('~ Type: '), write(EnemyType), nl, nl,
    write('*** Your status ***'), nl,
    write('~ Health: '), write(Health), nl,
    write('~ Stamina: '), write(Stamina), nl,
    write('~ Mana: '), write(Mana), nl,
    write('~ Attack: '), write(Attack), nl,
    write('~ Defense: '), write(Defense), nl,
    (
        (EnemyHealth =:= 0, Health > 0, initBoss(_)) ->     nl, write('Kamu berhasil kalahkan '), write(EnemyName), write('!'), nl,
                                                            removeEnemy,
                                                            ;

        (Health =:= 0) ->   playerInfo(Username,_,_,_,_), nl,
                            write('     ...........................................................    '), nl,
                            write('Perjuanganmu kali ini hanya sampai di sini '), write(Username), write('.'), nl, nl,
                            write('Sampai jumlah pada lain waktu.'), nl,    
                            removePlayerEnemy;
        nl       
    ),    

/*** Player melakukan basic attack terhadap musuh ***/
/** 
Notes:
    - Basic attack menghabiskan Stamina tertentu. 
    - Stamina blm disesuaikan.
    - Health, Stamina, dan Mana berubah.
**/
playerAttack :-
    inBattle(_),
    validateBattleStatus(1),!.

/*** Enemy melakukan basic attack terhadap player ***/
/** 
Notes:
    - Health, Stamina, dan Mana berubah.
**/
enemyAttack :-
    inBattle(_),
    validateBattleStatus(2),!.

/*** Player melakukan special attack terhadap musuh ***/
/** 
Notes:
    - Special attack menghabiskan Mana dan Stamina tertentu. 
    - Stamina dan Mana blm disesuaikan.
    - Health, Stamina, dan Mana berubah.
**/
specialAttackPlayer :-
    inBattle(_),
    validateBattleStatus(3),!.

/*** Enemy melakukan special attack terhadap player ***/
/** 
Notes:
    - Health, Stamina, dan Mana bertambah.
**/
specialAttackEnemy :-
    inBattle(_),
    validateBattleStatus(4),!.

/*** Validasi apakah attack berupa playerAttack, enemyAttack, specialAttackPlayer, atau specialAttackEnemy ***/
validateBattleStatus(Mode) :-
    playerInfo(Username, Job, Xp, Level,_), 
    playerStatus(Health, Stamina, Mana, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense),
    curEnemyInfo(ID, EnemyName, EnemyType, EnemyLevel, EnemyMaxHealth, EnemyHealth, EnemyHealthRegen, EnemyBasicAttack, EnemySpecialAttack),
    (
        (Mode =:= 1) ->    EnemyHealth2 is EnemyHealth - Attack + EnemyHealthRegen,
                        PlayerHealth is Health + HealthRegen,
                        PlayerStamina is Stamina + StaminaRegen - 5,
                        PlayerMana is Mana + ManaRegen;

        (Mode =:= 2) ->    PlayerHealth is Health + HealthRegen + Defense - EnemyBasicAttack,
                        PlayerStamina is Stamina + StaminaRegen,
                        PlayerMana is Mana + ManaRegen,
                        EnemyHealth2 is EnemyHealth + EnemyHealthRegen; 

        (Mode =:= 3) ->    EnemyHealth2 is EnemyHealth + EnemyHealthRegen - 1.5*Attack,
                        PlayerHealth is Health + HealthRegen,
                        PlayerStamina is Stamina + StaminaRegen - 5,
                        PlayerMana is Mana + ManaRegen - 8;

        (Mode =:= 4) ->    PlayerHealth is Health + HealthRegen + Defense - EnemySpecialAttack,
                        PlayerStamina is Stamina + StaminaRegen,
                        PlayerMana is Mana + ManaRegen,
                        EnemyHealth2 is EnemyHealth + EnemyHealthRegen
    ),

    (
        (EnemyHealth2 >= EnemyMaxHealth) -> EnemyHealth3 is EnemyMaxHealth;
        (EnemyHealth2 =< 0) -> EnemyHealth3 is 0;
        EnemyHealth3 is EnemyHealth2
    ),
    (        
        (PlayerHealth >= MaxHealth) -> PlayerHealth1 is MaxHealth;
        (PlayerHealth =< 0) -> PlayerHealth1 is 0;
        PlayerHealth1 is PlayerHealth        
    ),
    (
        (PlayerMana >= MaxMana) -> PlayerMana1 is MaxMana;
        (PlayerMana =< 0) -> PlayerMana1 is 0;
        PlayerMana1 is PlayerMana 
    ),
    (
        (PlayerStamina >= MaxStamina) -> PlayerStamina1 is MaxStamina;
        (PlayerStamina =< 0) -> PlayerStamina1 is 0;
        PlayerStamina1 is PlayerStamina 
    ),
    retract(playerStatus(_,_,_,_,_,_,_,_,_,_,_)),
    retract(playerInfo(_,_,_,_,_)),
    asserta(playerStatus(PlayerHealth1, PlayerStamina1, PlayerMana1, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense)),
    asserta(playerInfo(Username, Job, Xp, Level, playerStatus(PlayerHealth1, PlayerStamina1, PlayerMana1, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense))),
    retract(curEnemyInfo(_,_,_,_,_,_,_,_,_)),
    asserta(curEnemyInfo(ID, EnemyName, EnemyType, EnemyLevel, EnemyMaxHealth, EnemyHealth3, EnemyHealthRegen, EnemyBasicAttack, EnemySpecialAttack)),!.

/*** Enemy melakukan counter attack ***/
enemyCounterAttack :-
    curEnemyInfo(_,EnemyName,_,_,_,_,_,_,_),
    write('::::: '), write(EnemyName), write(' turn :::::'), nl,
    random(1, 11, EnemyChance),
    (
        (EnemyChance =\= 5) ->  (   
                                    cooldownEnemy(CD),
                                    (CD =:= 0) ->   specialAttackEnemy,
                                                    addCooldownEnemy,
                                                    write(EnemyName), write(' menggunakan special attack-nya!'), nl, nl;
                                    enemyAttack,
                                    decreaseCooldownEnemy,
                                    write(EnemyName), write(' mengeluarkan basic attack.'), nl, nl
                                );
        write('Yeay, serangan musuh meleset!'), nl, nl
    ),
    decreaseCooldownPlayer,!.
    
/*** Membuat Cooldown Special Attack Player Menjadi 4 ***/
addCooldownPlayer :-
    inBattle(_),
    New is 4,
    retract(cooldownPlayer(_)),
    asserta(cooldownPlayer(New)),!.

/*** Membuat Cooldown Special Attack Musuh Menjadi 4 ***/
addCooldownEnemy :-
    inBattle(_),
    New is 4,
    retract(cooldownEnemy(_)),
    asserta(cooldownEnemy(New)),!.

/*** Membuat Cooldown Special Attack Player Berkurang 1 ***/
decreaseCooldownPlayer :-
    inBattle(_),
    cooldownPlayer(Temp),
    (
        Temp =:= 0 -> New is Temp;
        New is Temp - 1
    ),
    retract(cooldownPlayer(_)),
    asserta(cooldownPlayer(New)),!.

/*** Membuat Cooldown Special Attack Musuh berkurang 1 ***/
decreaseCooldownEnemy :-
    inBattle(_),
    cooldownEnemy(Temp),
    (
        Temp =:= 0 -> New is Temp;
        New is Temp - 1
    ),
    retract(cooldownEnemy(_)),
    asserta(cooldownEnemy(New)),!.

/*** Player memilih basic attack ***/
/** 
Notes:
    - Player melakukan basic attack.
    - Musuh melakukan counter attack.
    - Kedua serangan memungkinkan gagal.
**/
attack :-
    inBattle(_),
    random(1, 11, PlayerChance),
    (
        (PlayerChance =\= 5) -> playerAttack,
                                curEnemyInfo(_,EnemyName,_,_,_,EnemyHealth,_,_,_),
                                nl, write(EnemyName), write(' terkena basic attack mu.'), nl, nl;
        nl, write('Ah, seranganmu meleset!'), nl, nl,
        curEnemyInfo(_,_,_,_,_,EnemyHealth,_,_,_)
    ),
    decreaseCooldownEnemy,
    (
        (EnemyHealth =:= 0) -> curBattleStatus;
        curBattleStatus,
        enemyCounterAttack,
        curBattleStatus,
        commands
    ),!.

attack :-
    \+ inBattle(_),
    nl, write('Kamu sedang tidak bertarung dengan musuh.'), nl,!.
    
/** ----------------------------------------------------- **/

/*** Player memilih special attack ***/
/** 
Notes:
    - Player melakukan special attack
    - Musuh melakukan counter attack.
    - Kedua serangan memungkinkan gagal.
**/
specialAttack :-
    inBattle(_),
    (
        cooldownPlayer(CD),
        (CD =:= 0) ->   (
                            random(1, 11, PlayerChance),
                            (PlayerChance =\= 5) ->     specialAttackPlayer,
                                                        curEnemyInfo(_,EnemyName,_,_,_,EnemyHealth,_,_,_),
                                                        nl, write(EnemyName), write(' terkena special attack-mu!'), nl, nl;
                            nl, write('Ah, seranganmu meleset!'), nl, nl,
                            curEnemyInfo(_,_,_,_,_,EnemyHealth,_,_,_)
                        ),  
                        (
                            (EnemyHealth =:= 0) -> curBattleStatus;
                            addCooldownPlayer,
                            decreaseCooldownEnemy,
                            curBattleStatus,
                            enemyCounterAttack,
                            curBattleStatus,
                            commands
                        );
        nl, write('Special attack-mu masih cooldown!'), nl, nl,
        commands
    ),!.

specialAttack :-
    \+ inBattle(_),
    nl, write('Kamu sedang tidak bertarung dengan musuh.'), nl,!.

/** ----------------------------------------------------- **/

/*** Player Mencoba Kabur dari Musuh ***/
/** 
Notes:
    - Jika gagal kabur, musuh melakukan counter attack.
**/
run :-
    inBattle(_),
    curEnemyInfo(_,EnemyName,_,_,_,_,_,_,_),
    random(1, 11, RunChance),
    (
        (RunChance =\= 5) ->    nl, write('Kamu berhasil melarikan diri.'), nl, nl,
                                removeEnemy;

        nl, write('Kamu gagal kabur dari '), write(EnemyName), write('!'), nl,
        decreaseCooldownEnemy,
        enemyCounterAttack,
        curBattleStatus,
        commands
    ),!.

run :-
    \+ inBattle(_),
    nl,write('Kamu sedang tidak bertarung dengan musuh.'), nl,!.

/** ----------------------------------------------------- **/

/*** Use Potion ***/
/** 
    Belum disesuaikan terhadap inventory pemain.    
**/
    /* oke gw tambahin, sub menu pilih Potion apa */
    /* oke g
    noPotionsExist,
    write('Kamu tidak punya potion'), !.
usePotion :-w tambahin, sub menu pilih Potion apa */
usePotion :-
    inBattle(_),
    playerInfo(Username, Job, Xp, Level,_), 
    playerStatus(Health, Stamina, Mana, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense),
    queryPotion(IDPotion),
    /** Code goes here **/
    /* Temporary health */
    PlayerHealth is Health + 15,
    (
        (PlayerHealth =< MaxHealth) -> PlayerHealth1 is MaxHealth;
        PlayerHealth1 is PlayerHealth
    ),
    retract(playerInfo(_,_,_,_,_)), 
    retract(playerStatus(_,_,_,_,_,_,_,_,_,_,_)),
    asserta(playerStatus(Health1, Stamina, Mana, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense)),
    asserta(playerInfo(Username, Job, Xp, Level, playerStatus(Health1, Stamina, Mana, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense))),
    (
        \+ inBattle(_) -> write("Health-mu telah beratambah."), nl;
        write("Health-mu telah beratambah."), nl,
        curBattleStatus,
        decreaseCooldownEnemy,
        enemyCounterAttack,
        curBattleStatus,
        commands
    ),!.
    

/** Command dilakukan saat tidak dalam mode battle
    /* bisain aja dwi wkwkw */
/* Ntah apa ini bisa dipake pas ga battle juga. */
    /* bisain aja dwi wkwkw */
usePotion :-


potionEffect(CurrentStatus, MaxStatus) :-
    PlayerHealth is Health + 15,
    (
        (PlayerHealth =< MaxHealth) -> PlayerHealth1 is MaxHealth;
        PlayerHealth1 is PlayerHealth
        /* Rex, tolong cek pc dah */
    ),
queryPotion(ID) :-
    write('Pilih potion yang ingin dipakai: '),
    showPotions,
    read(InputPotionName),
    (
        InputPotionName =:= healthPotion ->
            (
                \+ inventory(ID, healthPotion, potion, _, _, _, _, _, _, _, _, _, _, _) -> write('Kamu tidak punya healthPotion');
            );
            (
                InputPotionName =:= staminaPotion ->
                    (
                        \+ inventory(ID, staminaPotion, potion, _, _, _, _, _, _, _, _, _, _, _) -> write('Kamu tidak punya staminaPotion');
                    );
                    (
                        InputInputPotionName =:= manaPotion ->
                            (
                                \+ inventory(ID, manaPotion, potion, _, _, _, _, _, _, _, _, _, _, _) -> write('Kamu tidak punya manaPotion');
                            )
                    )
            )
    ), !.



/*** Remove Player -Mati- dan Enemy ***/
    retract(playerStatus(_,_,_,_,_,_,_,_,_,_,_)),
    retract(playerInfo(_,_,_,_,_)),
    removeEnemy,!.
    
    /*** Remove Normal Enemy -Mati- ***/
