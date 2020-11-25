:- dynamic(mission/4).
:- dynamic(initQuest/1).

/* mission(Slime,Wolf,Goblin,AccEXP) */
/* jadi nanti AccEXP tuh total EXP yg diterima pemain setelah selesai quest 
    AccEXP = Slime*1 + Wolf*2 + Goblin*3 (Opsional) */

quest :-
    initQuest(_),
    print('Anda sudah menerima sebuah quest.'),!.
    mission(Num1,Num2,Num3),
    print('Slime  : '), write(Num1),nl,
    print('Wolf   : '), write(Num2),nl,
    print('Goblin : '), write(Num3),nl,!.
    
quest :-
    positionX(PosX),
    positionY(PosY),
    isQuest(PosX,PosY),
    asserta(initQuest(1)),
    random(5,10,Num1),
    random(5,10,Num2),
    random(5,10,Num3),
    asserta(mission(Num1,Num2,Num3,0)),!.

quest :-
    init(_),
    print('Anda tidak berada di lokasi quest!'),!.

cekQuest :-
    mission(0,0,0,AccEXP),
    /* Selanjutnya, Exp Pemain naik sebesar AccEXP 
    tapi implementasinya belum tau gmn */

/* buat slime */
questDo(1) :-
    mission(Num1,Num2,Num3,EXP),
    New is Num1 - 1,
    New >= 0,
    NewEXP is EXP + 1,
    retract(mission(_,_,_,_))
    asserta(mission(New,Num2,Num3,NewEXP)),
    cekQuest,!.

/* buat wolf*/
questDo(2) :-
    mission(Num1,Num2,Num3,EXP),
    New is Num2 - 1,
    New >= 0,
    NewEXP is EXP + 2,
    retract(mission(_,_,_,_))
    asserta(mission(Num1,New,Num3,NewEXP)),
    cekQuest,!.

/* buat goblin*/
questDo(3) :-
    mission(Num1,Num2,Num3,EXP),
    New is Num3 - 1,
    New >= 0,
    NewEXP is EXP + 3,
    retract(mission(_,_,_,_))
    asserta(mission(Num1,Num2,New,NewEXP)),
    cekQuest,!.

questDo :-
    zone(Z),
    questDo(Z),!.