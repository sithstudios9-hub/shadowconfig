-- scripts/WeaponSystem.lua
local WeaponSystem = {}

-- Weapon data
local weapons = {
    Sword = { damage = 50, range = 10, cooldown = 1 },
    Bow = { damage = 30, range = 50, cooldown = 2 },
    Magic = { damage = 100, range = 30, cooldown = 5 }
}

local currentWeapon = "Sword"

function WeaponSystem.GetCurrentWeapon()
    return currentWeapon
end

function WeaponSystem.SetWeapon(weaponName)
    if weapons[weaponName] then
        currentWeapon = weaponName
        print("Equipped: " .. weaponName)
        return true
    end
    return false
end

function WeaponSystem.GetDamage()
    return weapons[currentWeapon].damage
end

function WeaponSystem.SetDamage(weaponName, damage)
    if weapons[weaponName] then
        weapons[weaponName].damage = damage
        print(weaponName .. " damage set to " .. damage)
    end
end

function WeaponSystem.GetAllWeapons()
    return weapons
end

return WeaponSystem
