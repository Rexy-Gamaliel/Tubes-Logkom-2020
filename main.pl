:- dynamic(init/1).  
:- dynamic(player/1).

:- include('player.pl').

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
    write('% 9. Status : menampilkan status pemain                                        %'),nl,
    write('% 8. help : menampilkan segala bantuan                                         %'),nl,
    write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'),nl,nl.

initFirst :-
    write('Welcome to Genshin Asik, Choose your job'), nl,
    write('1. Swordsman'), nl,
    write('2. Archer'), nl,
    write('3. Sorcerer'), nl,
    read(Job),
    asserta(player(Job)),
    (
        Job =:= 1 -> write('You choose Swordsman, lets explore the world'), nl;
        (
            Job =:= 2 -> write('You choose Archer, lets explore the world'), nl;
            (
                Job =:= 3 -> write('You choose Archer, lets explore the world'), nl
            )
        )
    ).

start :-
    \+init(_),
    new,
    asserta(init(1)),
    initFirst,
    initPlayer,
    !.
    