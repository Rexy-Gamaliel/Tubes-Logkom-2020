:- dynamic(curEnemyInfo/9).
:- dynamic(playerInfo/5).
:- dynamic(playerStatus/11).
:- dynamic(inBattle/1).
:- dynamic(cooldownPlayer/1).
:- dynamic(cooldownEnemy/1).

:- include('test1.pl').

/*enemyInfo(ID, EnemyName, EnemyType, EnemyLevel, EnemyMaxHealth, EnemyHealthRegen, EnemyBasicAttack, EnemySpecialAttack)*/

/*  Masalah cooldown

*/

/*** Memulai pertarungan ***/
initFight :-
    asserta(inBattle(1)),
    initPlayer,
    enemyAppeared,
    curBattleStatus,
    commands,!.

/*** Mendatangkan satu musuh dengan status level tertentu, dll. ***/
/** Notes:   
        - Blm diatur terhadap zone, musuh diacak terhadap ID-nya.
        - Rentang level musuh adalah [MinLevel, Level2).
        - Basic attack, Special Attack, Max Health, bisa diliat di bawah.
        - Penyesuaian stats diperlukan. **/

initPlayer :-
    asserta(playerInfo(player, swordsman, 0, 1, playerStatus(100, 100, 50, 100, 100, 50, 3, 3, 1, 14, 4))),
    asserta(playerStatus(100, 100, 50, 100, 100, 50, 3, 3, 1, 14, 4)),!.

enemyAppeared :-
    inBattle(_),
    random(1, 16, ID),
    enemyInfo(ID, EnemyName, EnemyType,_, EnemyMaxHealth, EnemyHealthRegen, EnemyBasicAttack, EnemySpecialAttack),
    playerInfo(_,_,_,Level,_),
    Level2 is Level + 1,
    MinLevel is Level2//2,
    EnemyHealth2 is EnemyMaxHealth + 3*Level - 3,
    random(MinLevel, Level2, EnemyLevel),
    EnemyBasicAttack2 is EnemyBasicAttack + Level - 1,
    EnemySpecialAttack2 is EnemySpecialAttack + Level - 1,
    asserta(curEnemyInfo(ID, EnemyName, EnemyType, EnemyLevel, EnemyMaxHealth, EnemyHealth2, EnemyHealthRegen, EnemyBasicAttack2, EnemySpecialAttack2)),
    asserta(cooldownPlayer(0)),
    asserta(cooldownEnemy(0)),
    write('Kamu bertemu '), write(EnemyName), write('. Bersiaplah!'), nl, nl.

commands :-
    inBattle(_),
    write('*** Apa yang akan kamu lakukan? ***'), nl,
    write('> attack.'), nl,
    write('> specialAttack.'), nl,
    write('> usePotion.'), nl,
    write('> run.'),nl,
    write('Masukkan perintah yang sesuai. Misal, ketik "attack." untuk melakukan basic attack.'), nl, !.

/*** Menampilkan status player dan musuh saat ini selama pertarungan ***/
curBattleStatus :-
    inBattle(_),
    curEnemyInfo(_,EnemyName, EnemyType, EnemyLevel,_,EnemyHealth,_,_,_),
    playerStatus(Health, Stamina, Mana,_,_,_,_,_,_, Attack, Defense),
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
    write('~ Defense: '), write(Defense), nl, nl,!.    

/*** Player melakukan basic attack terhadap musuh ***/
/** Asumsi:
        - Basic attack menghabiskan Stamina tertentu. 
        - Stamina blm disesuaikan **/
playerAttack :-
    inBattle(_),
    playerInfo(Username, Job, Xp, Level,_), 
    playerStatus(Health, Stamina, Mana, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense),
    curEnemyInfo(ID, EnemyName, EnemyType, EnemyLevel, EnemyMaxHealth, EnemyHealth, EnemyHealthRegen, EnemyBasicAttack, EnemySpecialAttack),
    EnemyHealth2 is EnemyHealth - Attack + EnemyHealthRegen,
    EnemyHealth2 =< EnemyMaxHealth,
    PlayerHealth is Health + HealthRegen,
    PlayerStamina is Stamina + StaminaRegen - 5,
    PlayerMana is Mana + ManaRegen,
    PlayerHealth =< MaxHealth,
    PlayerStamina =< MaxStamina,
    PlayerMana =< MaxMana,
    retract(playerStatus(_,_,_,_,_,_,_,_,_,_,_)),
    retract(playerInfo(_,_,_,_)),
    asserta(playerStatus(PlayerHealth, PlayerStamina, PlayerMana, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense)),
    asserta(playerInfo(Username, Job, Xp, Level, playerStatus(PlayerHealth, PlayerStamina, PlayerMana, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense))),
    retract(curEnemyInfo(_,_,_,_,_,_,_,_,_)),
    asserta(curEnemyInfo(ID, EnemyName, EnemyType, EnemyLevel, EnemyMaxHealth, EnemyHealth2, EnemyHealthRegen, EnemyBasicAttack, EnemySpecialAttack)),!.

enemyAttack :-
    inBattle(_),
    playerInfo(Username, Job, Xp, Level,_), 
    playerStatus(Health, Stamina, Mana, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense),
    curEnemyInfo(ID, EnemyName, EnemyType, EnemyLevel, EnemyMaxHealth, EnemyHealth, EnemyHealthRegen, EnemyBasicAttack, EnemySpecialAttack),
    PlayerHealth is Health + HealthRegen + Defense - EnemyBasicAttack,
    PlayerStamina is Stamina + StaminaRegen,
    PlayerMana is Mana + ManaRegen,
    EnemyHealth2 is EnemyHealth + EnemyHealthRegen,
    EnemyHealth2 =< EnemyMaxHealth,
    PlayerHealth =< MaxHealth,
    PlayerStamina =< MaxStamina,
    PlayerMana =< MaxMana,
    retract(playerStatus(_,_,_,_,_,_,_,_,_,_,_)),
    retract(playerInfo(_,_,_,_)),
    asserta(playerStatus(PlayerHealth, PlayerStamina, PlayerMana, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense)),
    asserta(playerInfo(Username, Job, Xp, Level, playerStatus(PlayerHealth, PlayerStamina, PlayerMana, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense))),
    retract(curEnemyInfo(_,_,_,_,_,_,_,_,_)),
    asserta(curEnemyInfo(ID, EnemyName, EnemyType, EnemyLevel, EnemyMaxHealth, EnemyHealth2, EnemyHealthRegen, EnemyBasicAttack, EnemySpecialAttack)),!.

specialAttackPlayer :-
    inBattle(_),
    playerInfo(Username, Job, Xp, Level,_), 
    playerStatus(Health, Stamina, Mana, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense),
    curEnemyInfo(ID, EnemyName, EnemyType, EnemyLevel, EnemyMaxHealth, EnemyHealth, EnemyHealthRegen, EnemyBasicAttack, EnemySpecialAttack),
    EnemyHealth2 is EnemyHealth + EnemyHealthRegen - 1.5*Attack,
    PlayerHealth is Health + HealthRegen,
    PlayerStamina is Stamina + StaminaRegen - 5,
    PlayerMana is Mana + ManaRegen - 8,
    EnemyHealth2 =< EnemyMaxHealth,
    PlayerHealth =< MaxHealth,
    PlayerStamina =< MaxStamina,
    PlayerMana =< MaxMana,
    retract(playerStatus(_,_,_,_,_,_,_,_,_,_,_)),
    retract(playerInfo(_,_,_,_)),
    asserta(playerStatus(PlayerHealth, PlayerStamina, PlayerMana, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense)),
    asserta(playerInfo(Username, Job, Xp, Level, playerStatus(PlayerHealth, PlayerStamina, PlayerMana, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense))),
    retract(curEnemyInfo(_,_,_,_,_,_,_,_)),
    asserta(curEnemyInfo(ID, EnemyName, EnemyType, EnemyLevel, EnemyMaxHealth, EnemyHealth2, EnemyHealthRegen, EnemyBasicAttack, EnemySpecialAttack)),!.

specialAttackEnemy :-
    inBattle(_),
    playerInfo(Username, Job, Xp, Level,_), 
    playerStatus(Health, Stamina, Mana, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense),
    curEnemyInfo(ID, EnemyName, EnemyType, EnemyLevel, EnemyMaxHealth, EnemyHealth, EnemyHealthRegen, EnemyBasicAttack, EnemySpecialAttack),
    PlayerHealth is Health + HealthRegen + Defense - EnemySpecialAttack,
    PlayerStamina is Stamina + StaminaRegen,
    PlayerMana is Mana + ManaRegen,
    EnemyHealth2 is EnemyHealth + EnemyHealthRegen,
    EnemyHealth2 =< EnemyMaxHealth,
    PlayerHealth =< MaxHealth,
    PlayerStamina =< MaxStamina,
    PlayerMana =< MaxMana,
    retract(playerStatus(_,_,_,_,_,_,_,_,_,_,_)),
    retract(playerInfo(_,_,_,_)),
    asserta(playerStatus(PlayerHealth, PlayerStamina, PlayerMana, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense)),
    asserta(playerInfo(Username, Job, Xp, Level, playerStatus(PlayerHealth, PlayerStamina, PlayerMana, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense))),
    retract(curEnemyInfo(_,_,_,_,_,_,_,_)),
    asserta(curEnemyInfo(ID, EnemyName, EnemyType, EnemyLevel, EnemyMaxHealth, EnemyHealth2, EnemyHealthRegen, EnemyBasicAttack, EnemySpecialAttack)),!.

addCooldownPlayer :-
    inBattle(_),
    New is 3,
    retract(cooldownPlayer(_)),
    asserta(cooldownPlayer(New)),!.

addCooldownEnemy :-
    inBattle(_),
    New is 3,
    retract(cooldownEnemy(_)),
    asserta(cooldownEnemy(New)),!.

decreaseCooldownPlayer :-
    inBattle(_),
    cooldownPlayer(Temp),
    \+ isDeadZero(Temp),
    New is Temp - 1,
    retract(cooldownPlayer(_)),
    asserta(cooldownPlayer(New)),!.

decreaseCooldownEnemy :-
    inBattle(_),
    cooldownEnemy(Temp),
    \+ isDeadZero(Temp),
    New is Temp - 1,
    retract(cooldownEnemy(_)),
    asserta(cooldownEnemy(New)),!.

attack :-
    inBattle(_),
    curEnemyInfo(_,EnemyName,_,_,_,_,_,_,_),
    random(1, 11, PlayerChance),
    write('Player Chance = '), write(PlayerChance), nl, nl,        
    (
        (PlayerChance =\= 5) -> playerAttack,
                                write(EnemyName), write(' terkena basic attack mu.'), nl, nl;
        write('Ah, seranganmu meleset!'), nl, nl
    ),
    curBattleStatus,
    random(1, 11, EnemyChance),
    write('Enemy Chance = '), write(EnemyChance), nl, nl,  
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
    curBattleStatus,!.

attack :-
    \+ inBattle(_),
    write("Kamu sedang tidak bertarung dengan musuh."), nl,!.

specialAttack :-
    inBattle(_),
    curEnemyInfo(_,EnemyName,_,_,_,_,_,_,_),
    random(1, 11, PlayerChance),
    (
        (PlayerChance =\= 5) -> (
                                    cooldownPlayer(CD),
                                    (CD =:= 0) ->   specialAttackPlayer,
                                                    write(EnemyName), write(' terkena special attack mu!'), nl, nl,
                                                    addCooldownPlayer;
                                    write('Special attack mu masih cooldown!'), nl, nl,
                                    commands
                                );
        write('Ah, seranganmu meleset!'), nl, nl
    ),
    curBattleStatus,
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
    curBattleStatus,!.

specialAttack :-
    \+ inBattle(_),
    write("Kamu sedang tidak bertarung dengan musuh."), nl,!.

run :-
    inBattle(_),
    curEnemyInfo(_,EnemyName,_,_,_,_,_,_,_),
    random(1, 11, RunChance),
    (
        (RunChance =\= 5) ->    write('Kamu berhasil melarikan diri.'), nl, nl,
                                removeEnemy,
                                retract(inBattle(_));
        write('Kamu gagal kabur dari '), write(EnemyName), write('!'), nl,
        write('Giliran '), write(EnemyName), write('.'), nl,
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
        curBattleStatus
    ),!.

run :-
    \+ inBattle(_),
    write("Kamu sedang tidak bertarung dengan musuh."), nl,!.

isDeadZero(X) :-
    X =< 0,!.
    
removeEnemy :-
    inBattle(_),
    retract(curEnemyInfo(_,_,_,_,_,_,_,_,_)),
    positionX(X),
    positionY(Y),
    retract(isEnemy(X,Y)),
    generateEnemy(1),
    print('Keluar mode battle.\n\n'),!.