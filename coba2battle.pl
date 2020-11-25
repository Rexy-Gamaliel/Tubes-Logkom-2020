:- dynamic(init/1).
:- dynamic(level/1).
:- dynamic(job/1).
:- dynamic(health/1).
:- dynamic(pattack/1).
:- dynamic(inBattle/1).
:- dynamic(exper/1).
:- dynamic(enemyHealth/1).
:- dynamic(enemyAttack/1).
:- dynamic(cooldown/1).

:- include('map.pl').
:- include('command.pl').
:- include('quest.pl').

start :-
    \+ init(_),
    print('Memulai Permainan'),
    asserta(init(1)),
    asserta(level(1)),
    asserta(job(swordsman)),
    asserta(exper(0)),
    asserta(pattack(50)),
    asserta(health(300)),
    asserta(positionX(1)),
    asserta(positionY(1)),!.


/* playerInfo(Username, Job, Xp, Level, playerStatus(Health, Stamina, Mana, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense)) */

start :-
    init(_),
    print('Permainan sudah dimulai!'),
    generateEnemy(7),!.


level :-
    \+ init(_),
    print('Permainan belum dimulai'),!.


tulislevel :-
    init(_),
    level(X),
    print('level : '),
    write(X),nl,!.


tulisEXP :-
    init(_),
    exper(EXP),
    print('EXP : '),
    write(EXP),nl,!.


tulisjob :-
    init(_),
    job(X),
    print('job : '),
    write(X),nl,!.


tulisHealth :-
    init(_),
    health(X),
    print('Health : '),
    write(X),nl,!.


tulisattack :- 
    init(_),
    pattack(X),
    print('Attack : '),
    write(X),nl,!.


status :-
    init(_),
    print('Status Pemain\n'),
    tulislevel,
    tulisEXP,
    tulisjob,
    tulisHealth,
    tulisattack,!.


generateEnemy :-
    init(_),
    level(LevelPlayer),
    NewHealth is ((LevelPlayer)*200),
    asserta(enemyHealth(NewHealth)),
    NewAttack is ((LevelPlayer)*25),
    asserta(enemyAttack(NewAttack)),!.


enemyStatus :-
    battle(_),
    enemyHealth(EHlt),
    enemyAttack(EAtk),
    print('Status Musuh\n'),
    print('Health : '),
    write(EHlt),nl,
    print('Attack : '),
    write(EAtk),nl,!.


isDead(X) :-
    X =< 0,!.


battle :- 
    init(_),
    \+ inBattle(_),
    asserta(inBattle(_)),
    print('Memasuki mode battle!\n'),
    generateEnemy,
    print('Masukkan pilihan\n'),
    print('1. Attack\n'),
    print('2. Run\n'),!.


battle :- 
    inBattle(_),
    print('Masukkan pilihan\n'),
    print('1. Attack\n'),
    print('2. Run\n'),!.


removeEnemy :-
    retract(enemyHealth(_)),
    retract(enemyAttack(_)),
    retract(inBattle(_)),
    positionX(X),
    positionY(Y),
    retract(isEnemy(X,Y)),
    generateEnemy(1),
    print('Keluar mode battle\n').


run :- 
    removeEnemy,!.


enemyCounterAttack(EnemyAttack, PlayerHealth) :-
    NewHlt is PlayerHealth - EnemyAttack,
    retract(health(_)),
    asserta(health(NewHlt)).


attack :-
    inBattle(_),
    pattack(PAtk),
    enemyAttack(EAtk),
    health(PHlt),
    enemyHealth(EHlt),
    NewEHLT is EHlt - PAtk,
    retract(enemyHealth(_)),
    asserta(enemyHealth(NewEHLT)),
    (
        cooldown(_) ->
        cooldown(Temp),
        Next is Temp + 1,
        retract(cooldown(_)),
        asserta(cooldown(Next))
    ),
    (
        isDead(NewEHLT) -> 
        print('Anda berhasil kalahkan musuh\n'),
        removeEnemy
        ;
        enemyCounterAttack(EAtk,PHlt),
        status,nl,
        enemyStatus,nl,
        battle
    ),!.


specialattack :- 
    inBattle(_),
    cooldown(_),
    print('Tidak bisa menggunakan skill. Skill sedang cooldown!'),nl,
    battle,!.


specialattack :- 
    inBattle(_),
    \+ cooldown(_),
    asserta(cooldown(3)),
    pattack(PAtk),
    enemyAttack(EAtk),
    health(PHlt),
    enemyHealth(EHlt),
    NewEHLT is EHlt - 3*PAtk,
    retract(enemyHealth(_)),
    asserta(enemyHealth(NewEHLT)),
    (
        isDead(NewEHLT) -> 
        print('Anda berhasil kalahkan musuh\n'),
        removeEnemy
        ;
        enemyCounterAttack(EAtk,PHlt),
        status,nl,
        enemyStatus,nl,
        battle
    ),!.
