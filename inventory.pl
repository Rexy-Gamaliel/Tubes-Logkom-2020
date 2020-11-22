:- dynamic(invetory/13).

/** Notes: 
    Gambaran skala:
      Level 1: MaxHealth, MaxStamina, MaxMana = 100
      Level 6: Kira2 tambah 80%, tergantung Job
      Level 11: Udah tambah 140% dari stat awal, tergantung Job. Effect equipmentutk level 11 ke atas otomatis dobel(?)
    */

inventory(ID, Nama, Tipe, Job, Level, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense).

/* Weapons 8 _ _ */
  /* Swordsman 8 1 _ */
inventory(811, IronSword, Weapon, Swordsman, Level, 0, 0, 0, 0, -4, 0, 10, 0).
inventory(812, Katana, Weapon, Swordsman, Level, 0, 0, 0, 0, -2, 0, 14, 8).
inventory(813, Nama, Weapon, Swordsman, Level, 0, 0, 0, 0, -8, 0, 25, 5).

  /* Archer 8 2 _ */
inventory(821, LongBow, Weapon, Archer, Level, 0, 0, 0, 0, -2, 0, 14, 0).
inventory(822, CrossBow, Weapon, Archer, Level, 0, 0, 0, 0, -4, 0, 18, 0).
inventory8123, DaedricBow, Weapon, Archer, Level, 0, 0, 0, 0, -6, 0, 30, 0).

  /* Sorcerer 8 3 _ */
inventory(831, NoviceStaff, Weapon, Sorcerer, Level, 0, 0, 0, 0, 0, -4, 12, 0).
inventory(832, ApprenticeStaff, Weapon, Sorcerer, Level, 0, 0, 0, 0, 0, -6, 20, 0).
inventory(833, MasterStaff, Weapon, Sorcerer, Level, 0, 0, 0, 0, 0, -8, 32, 0).


/* Armors 4 _ _ */
  /* inventory(ID, Nama, Tipe, Job, Level, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense). */
  /* Swordsman 4 1 _ */
inventory(411, LightArmor, Armor, Swordsman, Level, 15, -8, 0, 0, 0, 0, 0, 5).
inventory(412, ChainMailArmor, Armor, Swordsman, Level, 30, -14, 0, 0, 0, 0, 0, 12).
inventory(413, Nama, Armor, Swordsman, Level, 45, -20, 0, 0, 0, 0, 0, 18).

  /* Archer 4 2 _ */
inventory(421, LeatherArmor, Armor, Archer, Level, 10, -5, 0, 0, 0, 0, 0, 5).
inventory(422, HunterArmor, Armor, Archer, Level, 20, 0, 0, 0, 0, 0, 0, 9).
 /*inventory(423, Nama, Armor, Archer, Level, 30, MaxStamina, 0, 0, 0, 0, 0, 13).*/

  /* Sorcerer 4 3 _ */
inventory(431, NoviceRobe, Armor, Sorcerer, Level, 8, 0, MaxMana, 0, 0, 4, 0, 5).
inventory(432, ApprenticeRobe, Armor, Sorcerer, Level, 16, 0, MaxMana, 0, 0, 10, 0, 8).
inventory(433, MasterRobe, Armor, Sorcerer, Level, 24, 0, MaxMana, 0, 0, 16, 0, 11).


/* Accessory 3 _ _ */
  /* inventory(ID, Nama, Tipe, Job, Level, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense). */
  /* Swordsman 3 1 _ */
inventory(311, SwiftnessGauntlet, Accessory, Swordsman, Level, 0, 20, 0, 0, 5, 0, 0, 0).
inventory(312, RingOfRegeneration, Accessory, Swordsman, Level, 20, 0, 0, 5, 0, 0, 0, 0).
inventory(313, LegionHelmet, Accessory, Swordsman, Level, 10, 0, 0, 0, 0, 0, 0, 8).

  /* Archer 3 2 _ */
inventory(321, FieryQuiver, Accessory, Archer, Level, 0, 0, 0, 0, 0, 0, 10, 0).
inventory(322, MarksmanCape, Accessory, Archer, Level, 0, 20, 0, 0, 0, 0, 0, 8).
  /* inventory(323, Nama, Accessory, Archer, Level, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense). */

  /* Sorcerer 3 3 _ */
inventory(331, AghanimTalisman, Accessory, Sorcerer, Level, 0, 0, 30, 0, 0, 0, 0, 5).
inventory(332, SanguineClaw, Accessory, Sorcerer, Level, 12, 0, 0, 4, 0, 0, 0, 0).
inventory(333, MagnusScepter, Accessory, Sorcerer, Level, 0, 0, 0, 0, 0, 5, 10, 0).


/* Potions 0 _ _ */
  /* inventory(ID, Nama, Tipe, Job, Level, MaxHealth, MaxStamina, MaxMana, HealthRegen, StaminaRegen, ManaRegen, Attack, Defense). */
inventory(001, HealthPotion, Potion, Unrestricted, 0, 0, 0, 0, 10, 0, 0, 0, 0).
inventory(002, StaminaPotion, Potion, Unrestricted, 0, 0, 0, 0, 0, 10, 0, 0, 0).
inventory(003, ManaPotion, Potion, Unrestricted, 0, 0, 0, 0, 0, 0, 10, 0, 0).
inventory(009, XpPotion, Potion, Unrestricted, 0, 0, 0, 0, 0, 0, 0, 0, 0).  % implementasi ??

