/*** Fakta-fakta di bawah belum terlalu disesuaikan terhadap perkembangkan status player. ***/

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

/* enemyInfo(ID, EnemyName, EnemyType, EnemyLevel, EnemyMaxHealth, EnemyHealthRegen, EnemyBasicAttack, EnemySpecialAttack, GoldBounty) */
enemyInfo(1, 'Slimeling', slime, 1, 80, 3, 11, 19).
enemyInfo(2, 'Slimegun', slime, 1, 90, 3, 9, 19).
enemyInfo(3, 'Slime C', slime, 1, 100, 3, 9, 17).
enemyInfo(4, 'Slym', slime, 1, 105, 3, 8, 16).
enemyInfo(5, 'Slime Dunk', slime, 1, 110, 3, 8, 15).

enemyInfo(6, 'Goblin A', goblin, 1, 50, 3, 13, 25).
enemyInfo(7, 'Goblin B', goblin, 1, 60, 3, 13, 23).
enemyInfo(8, 'Goblin C', goblin, 1, 70, 3, 11, 22).
enemyInfo(9, 'Goblin D', goblin, 1, 75, 3, 10, 21).
enemyInfo(10, 'Goblartar', goblin, 1, 80, 3, 10, 20).

enemyInfo(11, 'Wolfran Alpha', wolf, 1, 80, 3, 15, 15).
enemyInfo(12, 'Wolf B', wolf, 1, 85, 3, 14, 14).
enemyInfo(13, 'Wolf C', wolf, 1, 90, 3, 13, 14).
enemyInfo(14, 'Wolf D', wolf, 1, 95, 3, 12, 14).
enemyInfo(15, 'Golf', wolf, 1, 100, 3, 12, 13).

/* bossInfo(BossName, BossType, BossLevel, BossMaxHealth, BossHealthRegen, BossBasicAttack, BossSpecialAttack), */
bossInfo(dungeonBoss, boss, 20, 750, 15, 45, 60).