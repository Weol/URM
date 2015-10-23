
TIIP = TIIP or {}
TIIP.URM = TIIP.URM or {}
TIIP.URM.LoadTable = TIIP.URM.LoadTable or {}
if not TIIP.URM.Loaded then
	table.insert(TIIP.URM.LoadTable,"ulx/modules/duplicator.lua")
	return
end

local weapons = {
	"weapon_357",
	"weapon_slam",
	"weapon_ar2",
	"weapon_bugbait",
	"weapon_crossbow",
	"weapon_crowbar",
	"weapon_frag",
	"weapon_physcannon",
	"weapon_physgun",
	"weapon_pistol",
	"weapon_rpg",
	"weapon_shotgun",
	"weapon_smg1",
	"weapon_stunstick",
	"weapon_annabelle"
}
for k, v in pairs(list.Get( "Weapon" )) do
	table.insert(weapons,k)
end
local vehicles = table.GetKeys(list.Get( "Vehicles" ))	
local npcs = table.GetKeys(list.Get( "NPC" ))
local entities = table.GetKeys(list.Get( "SpawnableEntities" ))

if AdvDupe then
	function TIIP.CheckPlayerSpawn(ply, Ent, EntTable) 
		if (Ent == "prop_physics") then return true end

		local ret = true
		
		--Check if ent is restricted in all the different types
		if (table.HasValue(weapons,Ent)) and not(TIIP.URM.PlayerSpawnSWEP( ply, Ent )) then ret = false end 
		
		if (table.HasValue(vehicles,Ent)) and not(TIIP.URM.PlayerSpawnVehicle( ply, _, Ent )) then ret = false end
		
		if (table.HasValue(entities,Ent)) and not(TIIP.URM.PlayerSpawnSENT( ply, Ent )) then ret = false end
		
		if (table.HasValue(npcs,Ent)) and not(TIIP.URM.PlayerSpawnNPC( ply, Ent )) then ret = false  end
		
		return ret
		
	end
	AdvDupe.AdminSettings.AddEntCheckHook( "TIIPURMCheckPlayerDuplicate", TIIP.CheckPlayerSpawn )
end