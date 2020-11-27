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

/* enemyInfo(ID, EnemyName, EnemyType, EnemyLevel, EnemyMaxHealth, EnemyHealthRegen, EnemyBasicAttack, EnemySpecialAttack, GoldBounty, XpBounty) */
enemyInfo(1, 'Slimeling', slime, 1, 80, 3, 11, 19).
enemyInfo(2, 'Slime B', slime, 1, 90, 3, 9, 19).
enemyInfo(3, 'Slime C', slime, 1, 100, 3, 9, 17).
enemyInfo(4, 'Slime D', slime, 1, 105, 3, 8, 16).
enemyInfo(5, 'Slime Dunk', slime, 1, 110, 3, 8, 15).

enemyInfo(6, 'GoblinA', goblin, 1, 50, 3, 13, 25).
enemyInfo(7, 'goblinB', goblin, 1, 60, 3, 13, 23).
enemyInfo(8, 'goblinC', goblin, 1, 70, 3, 11, 22).
enemyInfo(9, 'goblinD', goblin, 1, 75, 3, 10, 21).
enemyInfo(10, 'goblinE', goblin, 1, 80, 3, 10, 20).

enemyInfo(11, 'wolfA', wolf, 1, 80, 3, 15, 15).
enemyInfo(12, 'wolfB', wolf, 1, 85, 3, 14, 14).
enemyInfo(13, 'wolfC', wolf, 1, 90, 3, 13, 14).
enemyInfo(14, 'wolfD', wolf, 1, 95, 3, 12, 14).
enemyInfo(15, 'wolfE', wolf, 1, 100, 3, 12, 13).

/* bossInfo(BossName, BossType, BossLevel, BossMaxHealth, BossHealthRegen, BossBasicAttack, BossSpecialAttack), */
bossInfo(dungeonBoss, boss, 20, 750, 15, 45, 60).