/* playerInfo(Username, Job, Xp, Level, playerStatus/11) */
/* playerStatus(Health, Stamina, Mana, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense) */

/* inventory(ID, Nama, Tipe, Job, Level, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense). */

save(_) :-
    \+ init(_),
    print('Game belum dimulai'),!.


save(filename) :-
    tell(filename),
        savePlayerInfo,
        saveInventory,
        saveQuest,
        savePosition,
        saveEnemyLoc,
    told,!.


savePlayerInfo :- 
    playerInfo(Username, Job, Xp, Level),
    write('playerInfo('), write(Username), write(', '), write(Job), write(', '), write(Xp),
    write(', '), write(Level), write(', '),
    savePlayerStatus,
    write(').'), !.


savePlayerStatus :-
    playerStatus(Health, Stamina, Mana, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense),
    write('playerStatus('), write(Health), write(', '), write(Stamina), write(', '), write(Mana), 
    write(', '), write(MaxHealth),  write(', '), write(MaxStamina), write(', '), write(MaxMana), 
    write(', '), write(HealthRegen), write(', '), write(StaminaRegen), write(', '), write(ManaRegen), 
    write(', '), write(Attack), write(', '), write(Defense), write(')'), !.


saveInventory :- 
    forall(inventory(ID, Nama, Tipe, Job, Level, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense),(
        write('inventory('), write(', '), write(ID), write(', ') write(Nama), write(', '), write(Tipe),
        write(', '), write(Job), write(', '), write(Level), write(', '), write(MaxHealth),  write(', '),
        write(MaxStamina), write(', '), write(MaxMana), write(', '), write(HealthRegen), write(', '),
        write(StaminaRegen), write(', '), write(ManaRegen), write(', '), write(Attack), write(', '), 
        write(Defense), write(').'), nl
    )), !.


savePosition :- 
    positionX(X),
    positionY(Y),
    write('positionX('), write(X), write(').'), nl,
    write('positionY('), write(Y), write(').'), nl,!.


saveQuest :-
    \+ initQuest(_), !.


saveQuest :- 
    mission(Num1,Num2,Num3,EXP),
    write('initQuest(1).'), nl,
    write('mission('), 
    write(Num1), write(', '), 
    write(Num2), write(', '), 
    write(Num3), write(', '), 
    write(EXP), write(').'), nl, !.


saveEnemyLoc :-
    forall(isEnemy(X,Y),(
        write('isEnemy('), write(X), write(', '), write(Y), write(').'), nl
    )), !.


loadGame(_) :-
    init(_),
    write('Tidak bisa load ketika permainan lain sedang berlangsung'), nl, !.


loadGame(FileName):-
    \+file_exists(FileName),
    write('File tidak ditemukan'), nl, !.


loadGame(FileName):-
    open(FileName, read, Stream),
    readLines(Stream,Lines),
    close(Stream),
    assertaLine(Lines), 
    asserta(init(1)), !.


assertaLine([]) :- !.


assertaLine([H|T]):-
    asserta(H),
    assertaLine(T), !.


readLines(Stream,[]) :-
    at_end_of_stream(Stream).


readLines(Stream,[H|T]) :-
    \+ at_end_of_stream(Stream),
    read(Stream,H),
    readLines(Stream,T).
