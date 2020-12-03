/* playerInfo(Username, Job, Xp, Level, playerStatus/11) */
/* playerStatus(Health, Stamina, Mana, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense) */

/* inventory(ID, Nama, Tipe, Job, Level, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense). */

save(_) :-
    \+ init(_),
    print('Game belum dimulai'),!.


save(Filename) :-
    tell(Filename),
        savePlayerInfo,
        savePlayerStatus, write('.'), nl,
        saveInventory,
        saveQuest,
        savePosition,
        saveEnemyLoc,
        saveEquipped,
        saveGold,
    told,!.


savePlayerInfo :- 
    playerInfo(Username, Job, Xp, Level, _),
    write('playerInfo('), write(Username), write(', '), write(Job), write(', '), write(Xp),
    write(', '), write(Level), write(', '),
    savePlayerStatus,
    write(').'), nl, !.


savePlayerStatus :-
    playerStatus(Health, Stamina, Mana, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense),
    write('playerStatus('), write(Health), write(', '), write(Stamina), write(', '), write(Mana), 
    write(', '), write(MaxHealth),  write(', '), write(MaxStamina), write(', '), write(MaxMana), 
    write(', '), write(HealthRegen), write(', '), write(StaminaRegen), write(', '), write(ManaRegen), 
    write(', '), write(Attack), write(', '), write(Defense), write(')'), !.


saveInventory :- 
    forall(inventory(ID, Nama, Tipe, Job, Level, Amount, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense),(
        write('inventory('), write(ID), write(', '), write(Nama), write(', '), write(Tipe),
        write(', '), write(Job), write(', '), write(Level), write(', '), write(Amount), write(', '),
        write(MaxHealth),  write(', '),
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

saveEquipped :-
    saveEquippedWeapon,
    saveEquippedArmor,
    saveEquippedAccessory,!.

saveEquippedWeapon :-
    \+ equippedWeapon(_),!.

saveEquippedWeapon :-
    equippedWeapon(X),
    write('equippedWeapon('), write(X), write(').'), nl,!.

saveEquippedArmor :-
    \+ equippedArmor(_),!.

saveEquippedArmor :-
    equippedArmor(Y),
    write('equippedArmor('), write(Y), write(').'), nl,!.

saveEquippedAccessory :-
    \+ equippedAccessory(_),!.

saveEquippedAccessory :-
    equippedAccessory(Z),
    write('equippedAccessory('), write(Z), write(').'), nl, !.

saveGold :-
    gold(G),
    write('gold('), write(G), write(').'), nl, !.


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
