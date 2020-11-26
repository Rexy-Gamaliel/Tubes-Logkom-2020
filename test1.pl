/*** Fakta-fakta di bawah belum terlalu disesuaikan terhadap perkembangkan status player. ***/

/* playerInfo(Username, Job, Xp, Level, playerStatus/11) */
/* playerStatus(Health, Stamina, Mana, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense) */
/*playerInfo(player, swordsman, 0, 1, playerStatus(100, 100, 50, 100, 100, 50, 3, 3, 1, 14, 4)).
playerStatus(100, 100, 50, 100, 100, 50, 3, 3, 1, 14, 4).*/

/* enemyInfo(ID, EnemyName, EnemyType, EnemyLevel, EnemyMaxHealth, EnemyHealthRegen, EnemyBasicAttack, EnemySpecialAttack) */
enemyInfo(1, slimeA, slime, 1, 80, 3, 11, 19).
enemyInfo(2, slimeB, slime, 1, 90, 3, 9, 19).
enemyInfo(3, slimeC, slime, 1, 100, 3, 9, 17).
enemyInfo(4, slimeD, slime, 1, 105, 3, 8, 16).
enemyInfo(5, slimedunk, slime, 1, 110, 3, 8, 15).

enemyInfo(6, goblinA, goblin, 1, 50, 3, 13, 25).
enemyInfo(7, goblinB, goblin, 1, 60, 3, 13, 23).
enemyInfo(8, goblinC, goblin, 1, 70, 3, 11, 22).
enemyInfo(9, goblinD, goblin, 1, 75, 3, 10, 21).
enemyInfo(10, goblinE, goblin, 1, 80, 3, 10, 20).

enemyInfo(11, wolfA, wolf, 1, 80, 3, 15, 15).
enemyInfo(12, wolfB, wolf, 1, 85, 3, 14, 14).
enemyInfo(13, wolfC, wolf, 1, 90, 3, 13, 14).
enemyInfo(14, wolfD, wolf, 1, 95, 3, 12, 14).
enemyInfo(15, wolfE, wolf, 1, 100, 3, 12, 13).

/* bossInfo(BossName, Type, EnemyLevel, MaxHealth, BasicAttack, SpecialAttack), */
bossInfo(dungeonBoss, boss, 20, 750, 45, 60).