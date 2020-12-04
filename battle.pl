:- dynamic(curEnemyInfo/9).     /* curEnemyInfo(ID, EnemyName, EnemyType, EnemyLevel, EnemyMaxHealth, EnemyHealth, EnemyHealthRegen, EnemyBasicAttack, EnemySpecialAttack) */
:- dynamic(curBossInfo/8).      /* curBossInfo(BossName, BossType, BossLevel, BossMaxHealth, BossHealth, BossHealthRegen, BossBasicAttack, BossSpecialAttack), */
:- dynamic(inBattle/1).
:- dynamic(initBoss/1).
:- dynamic(cooldownPlayer/1).
:- dynamic(cooldownEnemy/1).

:- include('enemies.pl').

/*** Player di lokasi musuh berada ***/
initFight :-
    init(_),
    asserta(inBattle(1)),
    enemyAppeared,
    curBattleStatus,
    commands,!.

/*** Menghasilkan ID musuh sesuai zona pemain berada ***/
getEnemyID(X) :-
    zone(Z),
    (
        Z =:= 1 ->
        random(1,6,ID);
        Z =:= 2 ->
        random(11,16,ID);
        Z =:= 3 ->
        random(6,11,ID);
        Z =:= 0 ->
        random(1,16,ID)
    ),
    X = ID, !.

/*** Mendatangkan satu musuh dengan status level tertentu, dll. ***/
enemyAppeared :- 
    inBattle(_),
    positionX(X),
    positionY(Y),
    isBoss(X,Y),
    bossTriggered, !.

enemyAppeared :-
    inBattle(_),
    getEnemyID(ID),
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
    nl, write('Kamu bertemu '), write(EnemyName), write('. Bersiaplah!'), nl, nl,!.

/*** Boss Triggered ***/
bossTriggered :-
    inBattle(_),
    asserta(initBoss(1)),
    playerInfo(Username,_,_,_,_),
    bossInfo(BossName, BossType, BossLevel, BossMaxHealth, BossHealthRegen, BossBasicAttack, BossSpecialAttack),
    BossHealth is BossMaxHealth,
    asserta(curBossInfo(BossName, BossType, BossLevel, BossMaxHealth, BossHealth, BossHealthRegen, BossBasicAttack, BossSpecialAttack)),
    asserta(cooldownPlayer(0)),
    asserta(cooldownEnemy(0)),
    nl, write('Persiapkanlah dirimu, '), write(Username), write('!'), nl, nl,
    write('Puncak kejayaan sudah di depan mata.'), nl, nl,
    write('Kalahkan '), write(BossName), write(' dan raihlah puncak kejayaan!'), nl, nl.

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
        initBoss(_) ->  curBossInfo(BossName, BossType, BossLevel,_,BossHealth,_,_,_),
                        EnemyName = BossName,
                        EnemyHealth = BossHealth,
                        EnemyLevel = BossLevel,
                        EnemyType = BossType;

        curEnemyInfo(_,NormalEnemyName, NormalEnemyType, NormalEnemyLevel,_,NormalEnemyHealth,_,_,_),
        EnemyName = NormalEnemyName,
        EnemyHealth = NormalEnemyHealth,
        EnemyLevel = NormalEnemyLevel,
        EnemyType = NormalEnemyType
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
        (EnemyHealth =:= 0, Health > 0, initBoss(_)) ->     nl, write('Kamu berhasil kalahkan '), write(EnemyName), write('!'), nl, nl,
                                                            write('Tamat.'), nl,
                                                            removeEnemy,
                                                            quit;
        
        (EnemyHealth =:= 0, Health > 0, \+ initBoss(_)) ->      nl, write('Kamu berhasil kalahkan '), write(EnemyName), write('!'), nl,
                                                                gold(CurGold),
                                                                random(200, 401, GoldGained),
                                                                write('~ Gold Gained: '), write(GoldGained), write('.'), nl,
                                                                NewGold is GoldGained + CurGold,
                                                                retract(gold(_)),
                                                                asserta(gold(NewGold)),
                                                                removeEnemy;

        (Health =:= 0) ->   playerInfo(Username,_,_,_,_), nl,
                            write('     ...........................................................    '), nl,
                            write('     ...........................................................    '), nl,
                            write('     ...........................................................    '), nl, nl,
                            write('Perjuanganmu kali ini hanya sampai di sini, '), write(Username), write('.'), nl, nl,
                            write('Sampai jumlah pada lain waktu.'), nl,
                            removeEnemy,    
                            quit;
        nl
    ),!.

/*** Player melakukan basic attack terhadap musuh ***/
/** 
    - Basic attack menghabiskan Stamina tertentu. 
    - Health, Stamina, dan Mana berubah.
**/
playerAttack :-
    inBattle(_),
    validateBattleStatus(1),!.

/*** Enemy melakukan basic attack terhadap player ***/
/** 
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
    inBattle(_),
    playerInfo(Username, Job, Xp, Level,_), 
    playerStatus(Health, Stamina, Mana, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense),
    (
        initBoss(_) ->  curBossInfo(BossName, BossType, BossLevel, BossMaxHealth, BossHealth, BossHealthRegen, BossBasicAttack, BossSpecialAttack),
                        EnemyName = BossName,
                        EnemyHealth = BossHealth,
                        EnemyLevel = BossLevel,
                        EnemyType = BossType,
                        EnemyMaxHealth = BossMaxHealth,
                        EnemyHealthRegen = BossHealthRegen, 
                        EnemyBasicAttack = BossBasicAttack,
                        EnemySpecialAttack = BossSpecialAttack;

        curEnemyInfo(ID, NormalEnemyName, NormalEnemyType, NormalEnemyLevel, NormalEnemyMaxHealth, NormalEnemyHealth, NormalEnemyHealthRegen, NormalEnemyBasicAttack, NormalEnemySpecialAttack),
        EnemyName = NormalEnemyName,
        EnemyHealth = NormalEnemyHealth,
        EnemyLevel = NormalEnemyLevel,
        EnemyType = NormalEnemyType,
        EnemyMaxHealth = NormalEnemyMaxHealth,
        EnemyHealthRegen = NormalEnemyHealthRegen, 
        EnemyBasicAttack = NormalEnemyBasicAttack,
        EnemySpecialAttack = NormalEnemySpecialAttack
    ),
    (
        (Mode =:= 1) -> EnemyHealth2 is EnemyHealth - Attack + EnemyHealthRegen,
                        PlayerHealth is Health + HealthRegen,
                        PlayerStamina is Stamina + StaminaRegen - 5,
                        PlayerMana is Mana + ManaRegen;

        (Mode =:= 2) -> PlayerHealth is Health + HealthRegen + Defense - EnemyBasicAttack,
                        PlayerStamina is Stamina + StaminaRegen,
                        PlayerMana is Mana + ManaRegen,
                        EnemyHealth2 is EnemyHealth + EnemyHealthRegen; 

        (Mode =:= 3) -> EnemyHealth2 is EnemyHealth + EnemyHealthRegen - 1.5*Attack,
                        PlayerHealth is Health + HealthRegen,
                        PlayerStamina is Stamina + StaminaRegen - 5,
                        PlayerMana is Mana + ManaRegen - 8;

        (Mode =:= 4) -> PlayerHealth is Health + HealthRegen + Defense - EnemySpecialAttack,
                        PlayerStamina is Stamina + StaminaRegen,
                        PlayerMana is Mana + ManaRegen,
                        EnemyHealth2 is EnemyHealth + EnemyHealthRegen
    ),

    (
        (EnemyHealth2 >= EnemyMaxHealth) -> EnemyHealth3 = EnemyMaxHealth;
        (EnemyHealth2 =< 0) -> EnemyHealth3 = 0;
        EnemyHealth3 = EnemyHealth2
    ),

    (
        (PlayerHealth >= MaxHealth) -> PlayerHealth1 = MaxHealth;
        (PlayerHealth =< 0) -> PlayerHealth1 = 0;
        PlayerHealth1 = PlayerHealth        
    ),

    (
        (PlayerMana >= MaxMana) -> PlayerMana1 = MaxMana;
        (PlayerMana =< 0) -> PlayerMana1 = 0;
        PlayerMana1 = PlayerMana 
    ),

    (
        (PlayerStamina >= MaxStamina) -> PlayerStamina1 = MaxStamina;
        (PlayerStamina =< 0) -> PlayerStamina1 = 0;
        PlayerStamina1 = PlayerStamina 
    ),

    retract(playerStatus(_,_,_,_,_,_,_,_,_,_,_)),
    retract(playerInfo(_,_,_,_,_)),
    asserta(playerStatus(PlayerHealth1, PlayerStamina1, PlayerMana1, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense)),
    asserta(playerInfo(Username, Job, Xp, Level, playerStatus(PlayerHealth1, PlayerStamina1, PlayerMana1, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense))),
    (
        initBoss(_) ->  retract(curBossInfo(_,_,_,_,_,_,_,_)),
                        asserta(curBossInfo(EnemyName, EnemyType, EnemyLevel, EnemyMaxHealth, EnemyHealth3, EnemyHealthRegen, EnemyBasicAttack, EnemySpecialAttack));
        retract(curEnemyInfo(_,_,_,_,_,_,_,_,_)),
        asserta(curEnemyInfo(ID, EnemyName, EnemyType, EnemyLevel, EnemyMaxHealth, EnemyHealth3, EnemyHealthRegen, EnemyBasicAttack, EnemySpecialAttack))
    ),!.
    
/*** Enemy melakukan counter attack ***/
enemyCounterAttack :-
    (
        initBoss(_) ->  curBossInfo(BossName,_,_,_,_,_,_,_),
                        EnemyName = BossName;

        curEnemyInfo(_,NormalEnemyName,_,_,_,_,_,_,_),
        EnemyName = NormalEnemyName
    ),
    write('::::: '), write(EnemyName), write(' turn :::::'), nl, nl,
    random(1, 11, EnemyChance),
    (
        (EnemyChance =\= 5) ->  (   
                                    cooldownEnemy(CD),
                                    (CD =:= 0) ->   specialAttackEnemy,
                                                    addCooldownEnemy,
                                                    sleep(1.5),
                                                    write(EnemyName), write(' menggunakan special attack-nya!'), nl, nl,
                                                    sleep(1.5);
                                    enemyAttack,
                                    decreaseCooldownEnemy,
                                    sleep(1.5),
                                    write(EnemyName), write(' mengeluarkan basic attack.'), nl, nl,
                                    sleep(1.5)
                                );
        sleep(1.5), write('Yeay, serangan musuh meleset!'), nl, sleep(1.5), nl
    ),
    decreaseCooldownPlayer,!.
    
/*** Membuat Cooldown Special Attack Player Menjadi 4 ***/
addCooldownPlayer :-
    inBattle(_),
    New = 4,
    retract(cooldownPlayer(_)),
    asserta(cooldownPlayer(New)),!.

/*** Membuat Cooldown Special Attack Musuh Menjadi 4 ***/
addCooldownEnemy :-
    inBattle(_),
    New = 4,
    retract(cooldownEnemy(_)),
    asserta(cooldownEnemy(New)),!.

/*** Membuat Cooldown Special Attack Player Berkurang 1 ***/
decreaseCooldownPlayer :-
    inBattle(_),
    cooldownPlayer(Temp),
    (
        Temp =:= 0 -> New = Temp;
        New is Temp - 1
    ),
    retract(cooldownPlayer(_)),
    asserta(cooldownPlayer(New)),!.

/*** Membuat Cooldown Special Attack Musuh berkurang 1 ***/
decreaseCooldownEnemy :-
    inBattle(_),
    cooldownEnemy(Temp),
    (
        Temp =:= 0 -> New = Temp;
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
                                (
                                    initBoss(_) ->  curBossInfo(BossName,_,_,_,BossHealth,_,_,_),
                                                    EnemyName = BossName,
                                                    EnemyHealth = BossHealth;

                                    curEnemyInfo(_,NormalEnemyName,_,_,_,NormalEnemyHealth,_,_,_),
                                    EnemyName = NormalEnemyName,
                                    EnemyHealth = NormalEnemyHealth
                                ), sleep(1.5), nl, write(EnemyName), write(' terkena basic attack mu.'), nl, sleep(1.5), nl;
                                
        sleep(1.5), nl, write('Ah, seranganmu meleset!'), nl, sleep(1.5), nl,
        (
            initBoss(_) ->  curBossInfo(_,_,_,_,BossHealth,_,_,_),
                            EnemyHealth = BossHealth;

            curEnemyInfo(_,_,_,_,_,NormalEnemyHealth,_,_,_),
            EnemyHealth = NormalEnemyHealth
        )
    ),
    decreaseCooldownEnemy,
    (
        (EnemyHealth =:= 0) -> curBattleStatus;
        curBattleStatus,
        enemyCounterAttack,
        playerStatus(Health,_,_,_,_,_,_,_,_,_,_),
        (
            (Health =\= 0) ->   curBattleStatus,
                                commands;
            curBattleStatus
        )
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
                                                        (
                                                            initBoss(_) ->  curBossInfo(BossName,_,_,_,BossHealth,_,_,_),
                                                                            EnemyName = BossName,
                                                                            EnemyHealth = BossHealth;

                                                            curEnemyInfo(_,NormalEnemyName,_,_,_,NormalEnemyHealth,_,_,_),
                                                            EnemyName = NormalEnemyName,
                                                            EnemyHealth = NormalEnemyHealth
                                                        ), sleep(1.5), nl, write(EnemyName), write(' terkena special attack-mu!'), nl, sleep(1.5), nl;

                            sleep(1.5), nl, write('Ah, seranganmu meleset!'), nl, sleep(1.5), nl,
                            (
                                initBoss(_) ->  curBossInfo(_,_,_,_,BossHealth,_,_,_),
                                                EnemyHealth = BossHealth;

                                curEnemyInfo(_,_,_,_,_,NormalEnemyHealth,_,_,_),
                                EnemyHealth = NormalEnemyHealth
                            )
                        ),  
                        (
                            (EnemyHealth =\= 0) ->  addCooldownPlayer,
                                                    decreaseCooldownEnemy,
                                                    curBattleStatus,
                                                    enemyCounterAttack,
                                                    playerStatus(Health,_,_,_,_,_,_,_,_,_,_),
                                                    (
                                                        (Health =\= 0) ->   curBattleStatus,
                                                                            commands;
                                                        curBattleStatus
                                                    );
                            curBattleStatus
                        );
        nl, write('Special attack-mu masih cooldown!'), nl, nl,
        commands
    ),!.

specialAttack :-
    \+ inBattle(_),
    nl, write('Kamu sedang tidak bertarung dengan musuh.'), nl,!.

/************************** ******************************/

/*** Player Mencoba Kabur dari Musuh ***/
/** 
Notes:
    - Jika gagal kabur, musuh melakukan counter attack.
**/
run :-
    inBattle(_),
    (
        initBoss(_) ->  curBossInfo(BossName,_,_,_,_,_,_,_),
                        EnemyName = BossName;

        curEnemyInfo(_,NormalEnemyName,_,_,_,_,_,_,_),
        EnemyName = NormalEnemyName
    ),

    random(1, 11, RunChance),
    (
        (RunChance =\= 5) ->    sleep(1.5), nl, write('Kamu berhasil melarikan diri.'), nl, sleep(1.5), nl,
                                removeEnemy;

        sleep(1.5), nl, write('Kamu gagal kabur dari '), write(EnemyName), write('!'), nl, sleep(1.5), nl,
        decreaseCooldownEnemy,
        enemyCounterAttack,
        playerStatus(Health,_,_,_,_,_,_,_,_,_,_),
        (
            (Health =\= 0) ->   curBattleStatus,
                                commands;
            curBattleStatus
        )
    ),!.

run :-
    \+ inBattle(_),
    nl,write('Kamu sedang tidak bertarung dengan musuh.'), nl,!.

/************************** ******************************/

/*** Use Available Potions ***/ 
usePotion :-
    init(_),
    playerInfo(Username, Job, Xp, Level,_), 
    playerStatus(Health, Stamina, Mana, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense),
    queryPotion(IDPotion),
    (
        (IDPotion =:= 001)  ->  (
                                    Health =:= MaxHealth    ->  nl, write('Health is already maximal.'), nl, nl,
                                                                Next = 0
                                                            ;   Next = 1,
                                                                potionEffect(Health, MaxHealth, NewHealth),
                                                                inventory(ID, healthPotion, potion, JobIn, LevelIn, Amount, MaxHealthIn, MaxStaminaIn, MaxManaIn, HealthRegenIn, StaminaRegenIn, ManaRegenIn, AttackIn, DefenseIn),
                                                                New is Amount - 1,
                                                                retract(inventory(_,_,_,_,_,_,_,_,_,_,_,_,_,_)),
                                                                asserta(inventory(ID, healthPotion, potion, JobIn, LevelIn, New, MaxHealthIn, MaxStaminaIn, MaxManaIn, HealthRegenIn, StaminaRegenIn, ManaRegenIn, AttackIn, DefenseIn)),
                                                                retract(playerInfo(_,_,_,_,_)), 
                                                                retract(playerStatus(_,_,_,_,_,_,_,_,_,_,_)),
                                                                asserta(playerStatus(NewHealth, Stamina, Mana, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense)),
                                                                asserta(playerInfo(Username, Job, Xp, Level, playerStatus(NewHealth, Stamina, Mana, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense))),
                                                                (
                                                                    \+ inBattle(_) ->   nl, write('Health-mu telah bertambah.'), nl, nl
                                                                                    ;   sleep(1.5), nl, write('Health-mu telah bertambah.'), nl, sleep(1.5), nl
                                                                )
                                )
                            
                            ;   (
                                    (IDPotion =:= 002)  ->  (
                                                                Stamina =:= MaxStamina ->   nl, write('Stamina is already maximal.'), nl, nl,
                                                                                            Next = 0
                                                                                        ;   Next = 1,
                                                                                            inventory(ID, staminaPotion, potion, JobIn, LevelIn, Amount, MaxHealthIn, MaxStaminaIn, MaxManaIn, HealthRegenIn, StaminaRegenIn, ManaRegenIn, AttackIn, DefenseIn),
                                                                                            New is Amount - 1,
                                                                                            retract(inventory(_,_,_,_,_,_,_,_,_,_,_,_,_,_)),
                                                                                            asserta(inventory(ID, staminaPotion, potion, JobIn, LevelIn, New, MaxHealthIn, MaxStaminaIn, MaxManaIn, HealthRegenIn, StaminaRegenIn, ManaRegenIn, AttackIn, DefenseIn)),
                                                                                            potionEffect(Stamina, MaxStamina, NewStamina),
                                                                                            retract(playerInfo(_,_,_,_,_)), 
                                                                                            retract(playerStatus(_,_,_,_,_,_,_,_,_,_,_)),
                                                                                            asserta(playerStatus(Health, NewStamina, Mana, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense)),
                                                                                            asserta(playerInfo(Username, Job, Xp, Level, playerStatus(Health, NewStamina, Mana, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense))),
                                                                                            (
                                                                                                \+ inBattle(_) ->   nl, write('Stamina-mu telah bertambah.'), nl, nl
                                                                                                               ;    sleep(1.5), nl, write('Stamina-mu telah bertambah.'), nl, sleep(1.5), nl
                                                                                            )
                                                                                                              
                                                            )
                                                            
                                                        ;   ( 
                                                                (IDPotion =:= 003)  ->  ( 
                                                                                            (Mana =:= MaxMana)  ->  nl, write('Mana is already maximal.'), nl, nl,
                                                                                                                    Next = 0
                                                                                                                ;   Next = 1,
                                                                                                                    inventory(ID, manaPotion, potion, JobIn, LevelIn, Amount, MaxHealthIn, MaxStaminaIn, MaxManaIn, HealthRegenIn, StaminaRegenIn, ManaRegenIn, AttackIn, DefenseIn),
                                                                                                                    New is Amount - 1,
                                                                                                                    retract(inventory(_,_,_,_,_,_,_,_,_,_,_,_,_,_)),
                                                                                                                    asserta(inventory(ID, manaPotion, potion, JobIn, LevelIn, New, MaxHealthIn, MaxStaminaIn, MaxManaIn, HealthRegenIn, StaminaRegenIn, ManaRegenIn, AttackIn, DefenseIn)),
                                                                                                                    potionEffect(Mana, MaxMana, NewMana),
                                                                                                                    retract(playerInfo(_,_,_,_,_)), 
                                                                                                                    retract(playerStatus(_,_,_,_,_,_,_,_,_,_,_)),
                                                                                                                    asserta(playerStatus(Health, Stamina, NewMana, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense)),
                                                                                                                    asserta(playerInfo(Username, Job, NewXp, Level, playerStatus(Health, Stamina, NewMana, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense))),
                                                                                                                    (
                                                                                                                        \+ inBattle(_) ->   nl, write('Mana-mu telah bertambah.'), nl, nl
                                                                                                                                        ;   sleep(1.5), nl, write('Mana-mu telah bertambah.'), nl, sleep(1.5), nl
                                                                                                                    )               
                                                                                        )
                                                                                    
                                                                                    ;   (
                                                                                         (IDPotion =:= 009, \+ inBattle(_)) ->  NewXp is Xp + 25,
                                                                                                                                New is Amount - 1,
                                                                                                                                retract(inventory(_,_,_,_,_,_,_,_,_,_,_,_,_,_)),
                                                                                                                                asserta(inventory(ID, xpPotion, potion, JobIn, LevelIn, New, MaxHealthIn, MaxStaminaIn, MaxManaIn, HealthRegenIn, StaminaRegenIn, ManaRegenIn, AttackIn, DefenseIn)),
                                                                                                                                retract(playerInfo(_,_,_,_,_)), 
                                                                                                                                retract(playerStatus(_,_,_,_,_,_,_,_,_,_,_)),
                                                                                                                                asserta(playerStatus(Health, Stamina, Mana, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense)),
                                                                                                                                asserta(playerInfo(Username, Job, NewXp, Level, playerStatus(Health, Stamina, Mana, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense))),
                                                                                                                                nl, write('Xp-mu telah bertambah.'), nl,
                                                                                                                                updatePlayerStatus
                                                                                                                            
                                                                                                                            ;   (
                                                                                                                                    (IDPotion =:= 009, inBattle(_)) ->  sleep(1.5), nl, write('Tidak dapat menggunakan Xp potion selama pertarungan.'), nl, sleep(1.5), nl,
                                                                                                                                                                        commands
                                                                                                                                                                    ;   nl, write('Kamu tidak memiliki potion tersebut.'), nl
                                                                                                                                ),
                                                                                                                                Next = 0
                                                                                        )         
                                                            )
                                )                                                             
    ),
    (
        (inBattle(_), Next =:= 0)   ->  nl, commands
                                    ;   (
                                            (inBattle(_), Next =:= 1)   ->  curBattleStatus,
                                                                            decreaseCooldownEnemy,
                                                                            enemyCounterAttack,
                                                                            curBattleStatus,
                                                                            commands
                                                                        ;   nl   
                                        )
         
    ),!.

potionEffect(CurrentStatus, MaxStatus, NewStatus) :-
    TempStatus is CurrentStatus + 15,
    (
        (TempStatus > MaxStatus)    ->  NewStatus is MaxStatus
                                    ;   NewStatus is TempStatus    
    ),!.

queryPotion(ID) :-
    showPotions,
    nl, write('Pilih potion yang ingin dipakai (masukkan nama potion yang sesuai): '), nl,
    write('| '), read(InputPotionName),
    (
        (InputPotionName == healthPotion)   ->  (
                                                    \+  inventory(ID, healthPotion, potion, _, _, _, _, _, _, _, _, _, _, _)    ->  ID = -1
                                                                                                                                ;   inventory(ID, healthPotion, potion, Job, Level, Amount, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense)                                
                                                )

                                            ;   (
                                                    (InputPotionName == staminaPotion)  ->  (
                                                                                                \+ inventory(ID, staminaPotion, potion, _, _, _, _, _, _, _, _, _, _, _)    ->  ID = -1
                                                                                                                                                                            ;   inventory(ID, staminaPotion, potion, Job, Level, Amount, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense),
                                                                                                                                                                                New is Amount - 1,
                                                                                                                                                                                retract(inventory(_,_,_, _, _, _, _, _, _, _, _, _, _, _)),
                                                                                                                                                                                asserta(inventory(ID, staminaPotion, potion, Job, Level, New, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense)) 
                                                                                            )

                                                                                        ;   (
                                                                                                (InputInputPotionName == manaPotion)    ->  (
                                                                                                                                                \+ inventory(ID, manaPotion, potion, _, _, _, _, _, _, _, _, _, _, _)   ->  ID = -1
                                                                                                                                                                                                                        ;   inventory(ID, manaPotion, potion, Job, Level, Amount, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense),
                                                                                                                                                                                                                            New is Amount - 1,
                                                                                                                                                                                                                            retract(inventory(_,_,_, _, _, _, _, _, _, _, _, _, _, _)),
                                                                                                                                                                                                                            asserta(inventory(ID, manaPotion, potion, Job, Level, New, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense))
                                                                                                                                            )
                                                                                                                                        
                                                                                                                                        ;   (
                                                                                                                                                (InputInputPotionName == xpPotion)  ->  (
                                                                                                                                                                                            \+ inventory(ID, xpPotion, potion, _, _, _, _, _, _, _, _, _, _, _) ->  ID = -1
                                                                                                                                                                                                                                                                ;   inventory(ID, xpPotion, potion, Job, Level, Amount, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense),
                                                                                                                                                                                                                                                                    New is Amount - 1,
                                                                                                                                                                                                                                                                    retract(inventory(_,_,_, _, _, _, _, _, _, _, _, _, _, _)),
                                                                                                                                                                                                                                                                    asserta(inventory(ID, xpPotion, potion, Job, Level, New, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense))
                                                                                                                                                                                        )

                                                                                                                                                                                   ;    ID = -1
                                                                                                                                            )
                                                                                            )
                                                )
    ),!.                                            

/*** Remove Triggered Enemy -Mati- ***/
removeEnemy :-
    inBattle(_),
    (
        initBoss(_) 
        ->  retract(curBossInfo(_,_,_,_,_,_,_,_)),
            retract(initBoss(_))

        ;   retract(curEnemyInfo(_,_,_,_,_,_,_,_,_))
    ),
    retract(cooldownEnemy(_)),
    retract(cooldownPlayer(_)),
    retract(inBattle(_)),
    positionX(X),
    positionY(Y),
    retract(isEnemy(X,Y)),
    questDo,
    generateEnemy,!.