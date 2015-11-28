
TIIP = TIIP or {}
TIIP.URM = TIIP.URM or {}

timer.Simple(5, function() include("ulx/modules/duplicator.lua") end)

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

function TIIP.CheckPlayerSpawn(ply, Ent, EntTable) 
	if (string.lower(type(Ent)) == "table") then
		Ent = Ent.Class
	end

	if (Ent == "prop_physics") then return true end
	
	local ret = true
		
	--Check if ent is restricted in all the different types
	if (table.HasValue(weapons,Ent)) and (TIIP.URM.PlayerSpawnSWEP( ply, Ent, Ent ) == false) then ret = false end 
		
	if (table.HasValue(vehicles,Ent)) and (TIIP.URM.PlayerSpawnVehicle( ply, _, Ent ) == false) then ret = false end
		
	if (table.HasValue(entities,Ent)) and (TIIP.URM.PlayerSpawnSENT( ply, Ent ) == false) then ret = false end
		
	if (table.HasValue(npcs,Ent)) and (TIIP.URM.PlayerSpawnNPC( ply, Ent ) == false) then ret = false  end

	return ret
		
end

if AdvDupe then
	AdvDupe.AdminSettings.AddEntCheckHook( "TIIPURMCheckPlayerDuplicate", TIIP.CheckPlayerSpawn )
end

if AdvDupe2 then
	hook.Add( "PlayerSpawnEntity", "TIIPURMPlayerSpawnEntity", TIIP.CheckPlayerSpawn, -1 )
end