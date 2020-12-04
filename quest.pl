:- dynamic(mission/4).
:- dynamic(initQuest/1).

/* mission(Slime,Wolf,Goblin,AccEXP) */
/* jadi nanti AccEXP tuh total EXP yg diterima pemain setelah selesai quest 
    AccEXP = Slime*1 + Wolf*2 + Goblin*3 (Opsional) */

/* EXP Update + Next Level */
naikExp(AddEXP) :-
    playerInfo(Username, Job, Xp, Level, playerStatus(Health, Stamina, Mana, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense)),
    GetEXP is Xp + AddEXP,
    requiredXp(Level, LevelXp),
    (
        GetEXP >= LevelXp ->
        NewEXP is GetEXP - LevelXp,
        NewLevel is Level+1;
        NewEXP = GetEXP,
        NewLevel = Level 
    ),
    retract(playerInfo(Username, Job, Xp, Level, playerStatus(Health, Stamina, Mana, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense))),
    asserta(playerInfo(Username, Job, NewEXP, NewLevel, playerStatus(Health, Stamina, Mana, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense))), !.

/* Questing */
quest :-
    initQuest(_),
    print('Kamu sudah menerima sebuah quest.\n'),
    mission(Num1,Num2,Num3,_),
    print('Slime  : '), write(Num1),nl,
    print('Wolf   : '), write(Num2),nl,
    print('Goblin : '), write(Num3),nl,!.
    
quest :-
    positionX(PosX),
    positionY(PosY),
    isQuest(PosX,PosY),
    asserta(initQuest(1)),
    random(0,11,Num1),
    random(0,11,Num2),
    random(0,11,Num3),
    asserta(mission(Num1,Num2,Num3,0)),
    print('Kamu sudah mendapat quest baru.\n'),
    print('Slime  : '), write(Num1),nl,
    print('Wolf   : '), write(Num2),nl,
    print('Goblin : '), write(Num3),nl,!.

quest :-
    init(_),
    print('Kamu tidak berada di lokasi quest!'),!.

cekQuest :-
    \+ mission(0,0,0,_), !.

cekQuest :-
    mission(0,0,0,AccEXP),
    write('Quest berhasil. Kamu mendapat Exp sebesar '), print(AccEXP), nl,
    playerInfo(Username, Job, Xp, Level, playerStatus(Health, Stamina, Mana, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense)),
    NewEXP is Xp + AccEXP,
    retract(playerInfo(Username, Job, Xp, Level, playerStatus(Health, Stamina, Mana, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense))),
    asserta(playerInfo(Username, Job, NewEXP, Level, playerStatus(Health, Stamina, Mana, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense))),
    updatePlayerStatus,
    gold(G),
    NewG is G + 1000,
    retract(gold(G)),
    asserta(gold(NewG)),
    retract(initQuest(_)),
    retract(mission(_,_,_,_)), !.

cekQuest :- !.

/* Quest buat slime */
questDo(1) :-
    mission(Num1,Num2,Num3,EXP),
    New is Num1 - 1,
    New >= 0,
    NewEXP is EXP + 1,
    retract(mission(_,_,_,_)),
    asserta(mission(New,Num2,Num3,NewEXP)),
    cekQuest,!.

/* Quest buat wolf */
questDo(2) :-
    mission(Num1,Num2,Num3,EXP),
    New is Num2 - 1,
    New >= 0,
    NewEXP is EXP + 2,
    retract(mission(_,_,_,_)),
    asserta(mission(Num1,New,Num3,NewEXP)),
    cekQuest,!.

/* Quest buat goblin */
questDo(3) :-
    mission(Num1,Num2,Num3,EXP),
    New is Num3 - 1,
    New >= 0,
    NewEXP is EXP + 3,
    retract(mission(_,_,_,_)).
/* Quest tergantung zona */
questDo :-
    initQuest(_),
    zone(Z),
    questDo(Z).

questDo.
questDo :-
    initQuest(_),
    zone(Z),
    questDo(Z),!.

questDo :-
    \+ initQuest(_).