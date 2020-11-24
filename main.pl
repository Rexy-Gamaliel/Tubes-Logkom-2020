:- dynamic(init/1).  
:- dynamic(player/1).

:- include('player.pl').
:- include('map.pl').
:- include('command.pl').

new :-
    write('                  '),nl,
    write('Good isekai game!!'),nl,
    write('Lets play and be a programmer'),nl,
    write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'),nl,
    write('%                               ~Genshin Asik~                                 %'), nl,
    write('% 1. start : untuk memulai petualanganmu                                       %'),nl,
    write('% 2. map : menampilkan peta                                                    %'),nl,
    write('% 3. status : menampilkan kondisimu terkini                                    %'),nl,
    write('% 4. w : gerak ke utara 1 langkah                                              %'),nl,
    write('% 5. s : gerak ke selatan 1 langkah                                            %'),nl,
    write('% 6. d : gerak ke ke timur 1 langkah                                           %'),nl,
    write('% 7. a : gerak ke barat 1 langkah                                              %'),nl,
    write('% 8. help : menampilkan segala bantuan                                         %'),nl,
    write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'),nl,nl.

initFirst :-
    write('Welcome to Genshin Asik, Adventurer.'), nl,
    write('What is your name?'), nl,
    read(Username), nl
    format('Welcome, ~w !', Username), nl, nl,
    repeat,
    write('Choose your job (1, 2, 3)'), nl,
    write('1. Swordsman'), nl,
    write('2. Archer'), nl,
    write('3. Sorcerer'), nl,
    read(Job),
    asserta(player(Job)),
    (
        Job =:= 1 -> write('You chose Swordsman, lets explore the world'), nl;
        (
            Job =:= 2 -> write('You chose Archer, lets explore the world'), nl;
            (
                Job =:= 3 -> write('You chose Sorcerer, lets explore the world'), nl;
                (
                  write ('Please input valid number'), nl
                )
            )
        )
    ),
    checkJob(Job),
    initJob(Username, Job),
    showStatus.

checkJob(Job) :-
    Job >= 1,
    Job =< 3, !.
checkJob(_) :-
  write('Pilih job yang valid!'), nl.

initJob(Username, Job) :-
    /* playerInfo(Username, Job, Xp, Level, playerStatus/11) */
    /* playerStatus(Health, Stamina, Mana, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense) */
    (
        % Swordsman starter 
        Job =:= 1 ->
            asserta(playerStatus(100, 100, 50, 100, 100, 50, 3, 3, 1, 14, 4)),
            playerInfo(Username, 1, 0, 1, playerStatus(_, _, _, _, _, _, _, _, _, _, _))
        ;
        (
            % Archer starter
            Job =:= 2 ->
                asserta(playerStatus(90, 100, 50, 90, 100, 50, 4, 3, 1, 14, 2)),
                playerInfo(Username, 2, 0, 1, playerStatus(_, _, _, _, _, _, _, _, _, _, _))
            ;
            (
                % Sorcerer starter
                Job =:= 3 ->
                    asserta(playerStatus(100, 50, 100, 100, 50, 100, 3, 1, 4, 14, 2)),
                    playerInfo(Username, 3, 0, 1, playerStatus(_, _, _, _, _, _, _, _, _, _, _))
            )
        )
    )

start :-
    \+init(_),
    new,
    asserta(init(1)),
    initFirst,
    initPlayer,
    !.
    
help :-
    write('Perintah Bantuan: '),nl,
    write('     start   --      untuk memulai petualanganmu'),nl,
    write('     map     --      menampilkan peta'),nl,
    write('     status  --      menampilkan kondisimu terkini '),nl,
    write('     w       --      gerak ke atas 1 langkah'),nl,
    write('     a       --      gerak ke kiri 1 langkah'),nl,
    write('     s       --      gerak ke bawah 1 langkah'),nl,
    write('     d       --      gerak ke kanan 1 langkah'),nl,
    write('     help    --      menampilkan segala bantuan'),nl. 

quit :-
    /* playerInfo(Username, Job, Xp, Level, playerStatus/11) */
    /* playerStatus(Health, Stamina, Mana, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense) */
    retract(init(_)),
    retract(positionX(_)),
    retract(positionY(_)),
    forall(playerStatus(_, _, _, _, _, _, _, _, _, _, _)) (
      retract(playerStatus(_, _, _, _, _, _, _, _, _, _, _))
    ),
    forall(playerInfo(_, _, _, _, playerStatus(_, _, _, _, _, _, _, _, _, _, _)) (
      retract(playerinfo(_, _, _, _, playerStatus(_, _, _, _, _, _, _, _, _, _, _)))
    ).