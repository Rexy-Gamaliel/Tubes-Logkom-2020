/** Notes: 
    Gambaran skala: (?) ngasal wkwk
      Level 1: MaxHealth, MaxStamina, MaxMana = 100
      Level 6: Kira2 tambah 80%, tergantung Job
      Level 11: Udah tambah 140% dari stat awal, tergantung Job. Effect equipmentutk level 11 ke atas otomatis dobel(?)
    */

/*  item/13
    item(ID, Nama, Tipe, Job, Level, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense). */

/* Weapons 8 _ _ */
  /* Swordsman 8 1 _ */
item(811, ironSword, weapon, swordsman, 1, 0, 0, 0, 0, -4, 0, 10, 0).
item(812, katana, weapon, swordsman, 5, 0, 0, 0, 0, -2, 0, 14, 8).
item(813, greatSword, weapon, swordsman, 10, 0, 0, 0, 0, -8, 0, 25, 5).

  /* Archer 8 2 _ */
item(821, longBow, weapon, archer, 1, 0, 0, 0, 0, -2, 0, 14, 0).
item(822, crossBow, weapon, archer, 5, 0, 0, 0, 0, -4, 0, 18, 0).
item(823, daedricBow, weapon, archer, 12, 0, 0, 0, 0, -6, 0, 30, 0).

  /* Sorcerer 8 3 _ */
item(831, noviceStaff, weapon, sorcerer, 1, 0, 0, 0, 0, 0, -4, 12, 0).
item(832, apprenticeStaff, weapon, sorcerer, 6, 0, 0, 0, 0, 0, -6, 20, 0).
item(833, masterStaff, weapon, sorcerer, 12, 0, 0, 0, 0, 0, -8, 32, 0).


/* Armors 4 _ _ */
  /* item(ID, Nama, Tipe, Job, Level, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense). */
  /* Swordsman 4 1 _ */
item(411, lightArmor, armor, swordsman, 1, 15, -8, 0, 0, 0, 0, 0, 5).
item(412, chainMailArmor, armor, swordsman, 6, 30, -14, 0, 0, 0, 0, 0, 12).
item(413, knightsArmor, armor, swordsman, 11, 45, -20, 0, 0, 0, 0, 0, 18).

  /* Archer 4 2 _ */
item(421, leatherArmor, armor, archer, 1, 10, -5, 0, 0, 0, 0, 0, 5).
item(422, hunterArmor, armor, archer, 6, 20, 0, 0, 0, 0, 0, 0, 9).
item(423, daedricArmor, armor, archer, 12, 30, 15, 0, 0, 0, 0, 0, 13).

  /* Sorcerer 4 3 _ */
item(431, noviceRobe, armor, sorcerer, 1, 8, 0, MaxMana, 0, 0, 4, 0, 5).
item(432, apprenticeRobe, armor, sorcerer, 5, 16, 0, MaxMana, 0, 0, 10, 0, 8).
item(433, masterRobe, armor, sorcerer, 10, 24, 0, MaxMana, 0, 0, 16, 0, 11).


/* Accessory 3 _ _ */
  /* item(ID, Nama, Tipe, Job, Level, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense). */
  /* Swordsman 3 1 _ */
item(311, swiftnessGauntlet, accessory, swordsman, 5, 0, 20, 0, 0, 5, 0, 0, 0).
item(312, ringOfRegeneration, accessory, swordsman, 5, 20, 0, 0, 5, 0, 0, 0, 0).
item(313, legionHelmet, accessory, swordsman, 10, 10, 0, 0, 0, 0, 0, 0, 8).

  /* Archer 3 2 _ */
item(321, fieryQuiver, accessory, archer, 5, 0, 0, 0, 0, 0, 0, 10, 0).
item(322, marksmanCape, accessory, archer, 7, 0, 20, 0, 0, 0, 0, 0, 8).
item(323, daedalus, accessory, archer, 12, 0, 0, 0, 0, 3, 0, 6, 0).

  /* Sorcerer 3 3 _ */
item(331, aghanimTalisman, accessory, sorcerer, 5, 0, 0, 30, 0, 0, 0, 0, 5).
item(332, sanguineClaw, accessory, sorcerer, 8, 12, 0, 0, 4, 0, 0, 0, 0).
item(333, magnusScepter, accessory, sorcerer, 5, 0, 0, 0, 0, 0, 5, 10, 0).


/* Potions 0 _ _ */
  /* item(ID, Nama, Tipe, Job, Level, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense). */
item(001, healthPotion, potion, unrestricted, 0, 0, 0, 0, 20, 0, 0, 0, 0).
item(002, staminaPotion, potion, unrestricted, 0, 0, 0, 0, 0, 10, 0, 0, 0).
item(003, manaPotion, potion, unrestricted, 0, 0, 0, 0, 0, 0, 10, 0, 0).
item(009, xpPotion, potion, unrestricted, 0, 0, 0, 0, 0, 0, 0, 0, 0). 