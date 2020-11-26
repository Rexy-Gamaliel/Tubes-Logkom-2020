:- include('map.pl').
:- include('player.pl').

/*** Enemies Definitions ***/
/* enemy(Type, Level, Health, MaxHealth, Attack, Defense, SpecialAttack, GoldBounty, XpBounty) */
/* dungeonBoss */

/* Enemies Stats */
/*
    Stats = b + n * k       n = Level-1
                    Wolf        Slime       Goblin
                    (n, k)      (n, k)      (n, k)
    MHealth :       (30, 4)     (40, 4)    (100,8)
*/