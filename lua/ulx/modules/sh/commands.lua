local CATAGORY = "URM"

TIIP = TIIP or {}
TIIP.URM = TIIP.URM or {}

TIIP.URM.RestrictTypes = {entity = {"entity"},prop = {"prop"},npc = {"npc"},vehicle = {"vehicle"},swep = "weapon",pickup = "pickup",effect = {"effect"}, tool = {"tool"},ragdoll = {"ragdoll"}}
TIIP.URM.RestrictTypesKeys = {"entity","prop","npc","vehicle","swep","pickup","effect","tool","ragdoll"}
TIIP.URM.Functions = {}

TIIP.URM.Weapons = {
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
	table.insert(TIIP.URM.Weapons,k)
end

function ulx.restrict( calling_ply, groups, typ, strs, edit )
	if not TIIP then return false end
	if not TIIP.URM then return false end
	if (edit == "0") then edit = false end
	if string.find(groups,",") then
		groups = string.Explode(",",groups)
	end 
	if string.find(strs,",") then
		strs = string.Explode(",",strs)
	end
	if (string.lower(type(strs)) != "table") then strs = {strs} end
	if (string.lower(type(groups)) != "table") then groups = {groups} end
	for _,group in pairs(groups) do	
		for _,str in pairs(strs) do	
			TIIP.URM.AddRestriction(group,str,typ)
		end
	end
	if not edit then
		ulx.fancyLogAdmin( calling_ply, "#A restricted #s from #s", string.Implode(", ",strs), string.Implode(", ",groups) )
	end
end
local restrict = ulx.command( CATAGORY, "ulx restrict", ulx.restrict, "!restrict")
restrict:addParam{ type=ULib.cmds.StringArg, completes=ulx.group_names_no_user, hint="group", error="invalid group \"%s\" specified" }
restrict:addParam{ type=ULib.cmds.StringArg, completes=TIIP.URM.RestrictTypesKeys, hint="type", error="invalid type \"%s\" specified", ULib.cmds.restrictToCompletes }
restrict:addParam{ type=ULib.cmds.StringArg, hint="string" }
restrict:addParam{ type=ULib.cmds.BoolArg, invisible=true, ULib.cmds.optional }
restrict:defaultAccess( ULib.ACCESS_SUPERADMIN )
restrict:help( "Restricts weapon or entity/prop/vehicle from group." )
TIIP.URM.Functions["ulx restrict"] = ulx.restrict

function ulx.unrestrict( calling_ply, groups, typ, strs, edit )
	if not TIIP then return false end
	if not TIIP.URM then return false end
	if (edit == "0") then edit = false end
	if string.find(groups,",") then
		groups = string.Explode(",",groups)
	end 
	if string.find(strs,",") then
		strs = string.Explode(",",strs)
	end
	if (string.lower(type(strs)) != "table") then strs = {strs} end
	if (string.lower(type(groups)) != "table") then groups = {groups} end
	for _,group in pairs(groups) do	
		for _,str in pairs(strs) do	
			TIIP.URM.RemoveRestriction(group,str,typ)
		end
	end
	if not edit then
		ulx.fancyLogAdmin( calling_ply, "#A unrestricted #s from #s", string.Implode(", ",strs), string.Implode(", ",groups) )
	end
end
local unrestrict = ulx.command( CATAGORY, "ulx unrestrict", ulx.unrestrict, "!unrestrict")
unrestrict:addParam{ type=ULib.cmds.StringArg, completes=ulx.group_names_no_user, hint="group", error="invalid group \"%s\" specified"}
unrestrict:addParam{ type=ULib.cmds.StringArg, completes=TIIP.URM.RestrictTypesKeys, hint="type", error="invalid type \"%s\" specified", ULib.cmds.restrictToCompletes }
unrestrict:addParam{ type=ULib.cmds.StringArg, hint="string" }
unrestrict:addParam{ type=ULib.cmds.BoolArg, invisible=true, ULib.cmds.optional }
unrestrict:defaultAccess( ULib.ACCESS_SUPERADMIN )
unrestrict:help( "Unrestricts weapon or entity/prop/vehicle from group." )
TIIP.URM.Functions["ulx unrestrict"] = ulx.unrestrict

function ulx.setlimit( calling_ply, groups, strs, limit, edit )
	if not TIIP then return false end
	if not TIIP.URM then return false end
	if (edit == "0") then edit = false end
	if string.find(groups,",") then
		groups = string.Explode(",",groups)
	end 
	if string.find(strs,",") then
		strs = string.Explode(",",strs)
	end
	if (string.lower(type(strs)) != "table") then strs = {strs} end
	if (string.lower(type(groups)) != "table") then groups = {groups} end
	for _,group in pairs(groups) do	
		for _,str in pairs(strs) do	
			TIIP.URM.AddLimit(group,str,limit)
		end
	end
	if not edit then
		if (string.lower(type(limit)) == "string") then
			ulx.fancyLogAdmin( calling_ply, "#A set #s limit to #s for #s", string.Implode(", ",strs), limit, string.Implode(", ",groups) )
		else
			ulx.fancyLogAdmin( calling_ply, "#A set #s limit to #i for #s", string.Implode(", ",strs), limit, string.Implode(", ",groups) )
		end
	end
end
local setlimit = ulx.command( CATAGORY, "ulx setlimit", ulx.setlimit, "!setlimit")
setlimit:addParam{ type=ULib.cmds.StringArg, completes=ulx.group_names_no_user, hint="group", error="invalid group \"%s\" specified" }
setlimit:addParam{ type=ULib.cmds.StringArg, hint="string" }
setlimit:addParam{ type=ULib.cmds.StringArg, hint="limit" }
setlimit:addParam{ type=ULib.cmds.BoolArg, invisible=true, ULib.cmds.optional }
setlimit:defaultAccess( ULib.ACCESS_SUPERADMIN )
setlimit:help( "Sets limit custom limit." )
TIIP.URM.Functions["ulx setlimit"] = ulx.setlimit

function ulx.removelimit( calling_ply, groups, strs, edit )
	if not TIIP then return false end
	if not TIIP.URM then return false end
	if (edit == "0") then edit = false end
	if string.find(groups,",") then
		groups = string.Explode(",",groups)
	end 
	if string.find(strs,",") then
		strs = string.Explode(",",strs)
	end
	if (string.lower(type(strs)) != "table") then strs = {strs} end
	if (string.lower(type(groups)) != "table") then groups = {groups} end
	for _,group in pairs(groups) do	
		for _,str in pairs(strs) do	
			TIIP.URM.RemoveLimit(group,str)
		end
	end
	if not edit then
		ulx.fancyLogAdmin( calling_ply, "#A removed #s limit from #s", string.Implode(", ",strs), string.Implode(", ",groups) )
	end
end
local removelimit = ulx.command( CATAGORY, "ulx removelimit", ulx.removelimit, "!removelimit")
removelimit:addParam{ type=ULib.cmds.StringArg, completes=ulx.group_names_no_user, hint="group", error="invalid group \"%s\" specified" }
removelimit:addParam{ type=ULib.cmds.StringArg, hint="string" }
removelimit:addParam{ type=ULib.cmds.BoolArg, invisible=true, ULib.cmds.optional }
removelimit:defaultAccess( ULib.ACCESS_SUPERADMIN )
removelimit:help( "Removes custom limit!" )
TIIP.URM.Functions["ulx removelimit"] = ulx.removelimit

function ulx.addloadout( calling_ply, groups, strs, pri, sec, edit )
	if not TIIP then return false end
	if not TIIP.URM then return false end
	if (edit == "0") then edit = false end
	if string.find(groups,",") then
		groups = string.Explode(",",groups)
	end 
	if string.find(strs,",") then
		strs = string.Explode(",",strs)
	end
	if (string.lower(type(strs)) != "table") then strs = {strs} end
	if (string.lower(type(groups)) != "table") then groups = {groups} end
	for _,group in pairs(groups) do	
		for _,str in pairs(strs) do	
			TIIP.URM.AddLoadoutWeapon(group,str,pri,sec)
		end
	end
	if not edit then
		ulx.fancyLogAdmin( calling_ply, "#A added #s to the loadout of #s", string.Implode(", ",strs), string.Implode(", ",groups) )
	end
end
local addloadout = ulx.command( CATAGORY, "ulx addloadout", ulx.addloadout, "!addloadout")
addloadout:addParam{ type=ULib.cmds.StringArg, completes=ulx.group_names_no_user, hint="group", error="invalid group \"%s\" specified", ULib.cmds.restrictToCompletes }
addloadout:addParam{ type=ULib.cmds.StringArg, completes=TIIP.URM.Weapons, hint="weapon", error="invalid weapon \"%s\" specified" }
addloadout:addParam{ type=ULib.cmds.NumArg, min=0,max=1000, default=200, hint="primary", ULib.cmds.round }
addloadout:addParam{ type=ULib.cmds.NumArg, min=0,max=1000, default=10, hint="secondary", ULib.cmds.round }
addloadout:addParam{ type=ULib.cmds.BoolArg, invisible=true, ULib.cmds.optional }
addloadout:defaultAccess( ULib.ACCESS_SUPERADMIN )
addloadout:help( "Add a weapon to a groups loadout" )
TIIP.URM.Functions["ulx addloadout"] = ulx.addloadout

function ulx.removeloadout( calling_ply, groups, strs, edit )
	if not TIIP then return false end
	if not TIIP.URM then return false end
	if (edit == "0") then edit = false end
	if string.find(groups,",") then
		groups = string.Explode(",",groups)
	end 
	if string.find(strs,",") then
		strs = string.Explode(",",strs)
	end
	if (string.lower(type(strs)) != "table") then strs = {strs} end
	if (string.lower(type(groups)) != "table") then groups = {groups} end
	for _,group in pairs(groups) do	
		for _,str in pairs(strs) do	
			TIIP.URM.RemoveLoadoutWeapon(group,str)
		end
	end
	if not edit then
		ulx.fancyLogAdmin( calling_ply, "#A removed #s from the loadout of #s", string.Implode(", ",strs), string.Implode(", ",groups) )
	end
end
local removeloadout = ulx.command( CATAGORY, "ulx removeloadout", ulx.removeloadout, "!removeloadout")
removeloadout:addParam{ type=ULib.cmds.StringArg, completes=ulx.group_names_no_user, hint="group", error="invalid group \"%s\" specified", ULib.cmds.restrictToCompletes, completes=TIIP.URM.Weapons }
removeloadout:addParam{ type=ULib.cmds.StringArg, hint="weapon" }
removeloadout:addParam{ type=ULib.cmds.BoolArg, invisible=true, ULib.cmds.optional }
removeloadout:defaultAccess( ULib.ACCESS_SUPERADMIN )
removeloadout:help( "Remove a weapon from a groups loadout." )
TIIP.URM.Functions["ulx removeloadout"] = ulx.removeloadout

function ulx.setprimary( calling_ply, groups, str, edit )
	if not TIIP then return false end
	if not TIIP.URM then return false end
	if (edit == "0") then edit = false end
	if string.find(groups,",") then
		groups = string.Explode(",",groups)
	end 
	if (string.lower(type(groups)) == "string") then groups = {groups} end
	for _,group in pairs(groups) do	
		TIIP.URM.SetLoadoutPrimary(group,str)
	end
	if not edit then
		ulx.fancyLogAdmin( calling_ply, "#A set #s as the primary weapon for #s", str, string.Implode(", ",groups) )
	end
end
local setprimary = ulx.command( CATAGORY, "ulx setprimary", ulx.setprimary, "!setprimary")
setprimary:addParam{ type=ULib.cmds.StringArg, completes=ulx.group_names_no_user, hint="group", error="invalid group \"%s\" specified", ULib.cmds.restrictToCompletes, completes=TIIP.URM.Weapons }
setprimary:addParam{ type=ULib.cmds.StringArg, hint="weapon" }
setprimary:addParam{ type=ULib.cmds.BoolArg, invisible=true, ULib.cmds.optional }
setprimary:defaultAccess( ULib.ACCESS_SUPERADMIN )
setprimary:help( "Set a weapon as the primary weapon of the group(s) loadout." )
TIIP.URM.Functions["ulx setprimary"] = ulx.setprimary

function ulx.deleteloadout( calling_ply, group )
	if not TIIP then return false end
	if not TIIP.URM then return false end
	TIIP.URM.DeleteLoadout(group)
	ulx.fancyLogAdmin( calling_ply, "#A removed the custom loadout of #s", group )
end
local deleteloadout = ulx.command( CATAGORY, "ulx deleteloadout", ulx.deleteloadout, "!deleteloadout")
deleteloadout:addParam{ type=ULib.cmds.StringArg, completes=ulx.group_names_no_user, hint="group", error="invalid group \"%s\" specified", ULib.cmds.restrictToCompletes }
deleteloadout:defaultAccess( ULib.ACCESS_SUPERADMIN )
deleteloadout:help( "Delete the cuto loadout of a group" )
TIIP.URM.Functions["ulx deleteloadout"] = ulx.deleteloadout

function ulx.urm_print( calling_ply, tbl )
	calling_ply:SendLua("TIIP.URM.PrintTable("..tbl..")")
end
local urm_print = ulx.command( CATAGORY, "ulx urm_print", ulx.urm_print, "!urm_print")
urm_print:addParam{ type=ULib.cmds.StringArg, completes={"restrictions","limits","loadouts"}, hint="table", error="invalid table \"%s\" specified", ULib.cmds.restrictToCompletes }
urm_print:defaultAccess( ULib.ACCESS_SUPERADMIN )
urm_print:help( "Print table" )
TIIP.URM.Functions["ulx urm_print"] = ulx.urm_print

