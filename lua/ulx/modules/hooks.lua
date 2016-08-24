
TIIP = TIIP or {}
TIIP.URM = TIIP.URM or {}
TIIP.URM.LoadTable = TIIP.URM.LoadTable or {}
if not TIIP.URM.Loaded then
	table.insert(TIIP.URM.LoadTable,"ulx/modules/hooks.lua")
	return
end

function TIIP.URM.PlayerSpawnSENT( ply, sent )
	local value = TIIP.URM.CheckRestrictions(ply,sent,"entity")
	if (value == TIIP.URM.DENY) then
		ply:RestrictionHit("This entity has been restricted from your usergroup!")
		return false
	elseif (value == TIIP.URM.OVERRIDE) then
		return true
	end
	
	if !ply:CheckLimit(sent,true) then
		return false
	end		
end
hook.Add( "PlayerSpawnSENT", "TIIPURMPlayerSpawnSENT", TIIP.URM.PlayerSpawnSENT, -1 )

function TIIP.URM.PlayerSpawnedSENT( ply, ent )
	local haslimit,limit = TIIP.URM.HasURMLimit(ply,ent:GetClass())
	if haslimit then
		if (type(limit) == "string") then
			ply:AddCount(limit,ent)
		end
	
		ply:AddCount(haslimit,ent)
	end
end
hook.Add( "PlayerSpawnedSENT", "TIIPURMPlayerSpawnedProp", TIIP.URM.PlayerSpawnedSENT, -1 )

function TIIP.URM.PlayerSpawnProp( ply, mdl )
	local value = TIIP.URM.CheckRestrictions(ply,mdl,"prop")
	if (value == TIIP.URM.DENY) then
		ply:RestrictionHit("This prop has been restricted from your usergroup!")
		return false
	elseif (value == TIIP.URM.OVERRIDE) then
		return true
	end
	
	if !ply:CheckLimit(mdl,true) then
		return false
	end		
end
hook.Add( "PlayerSpawnProp", "TIIPURMPlayerSpawnProp", TIIP.URM.PlayerSpawnProp, -1 )

function TIIP.URM.PlayerSpawnedProp( ply, model, ent )
	local haslimit, limit = TIIP.URM.HasURMLimit(ply,model)
	if haslimit then
		if (type(limit) == "string") then
			ply:AddCount(limit,ent)
		end
	
		ply:AddCount(haslimit,ent)
	end
end
hook.Add( "PlayerSpawnedProp", "TIIPURMPlayerSpawnedProp", TIIP.URM.PlayerSpawnedProp, -1 )


function TIIP.URM.CanTool( ply, tr, tool )
	local value = TIIP.URM.CheckRestrictions(ply,tool,"tool")
	if (value == TIIP.URM.DENY) then
		ply:RestrictionHit("This tool has been restricted from your usergroup!")
		return false
	elseif (value == TIIP.URM.OVERRIDE) then
		return true
	end
	TIIPURMLog("%s(%s) used tool %s on %s",ply:Name(),ply:SteamID(),tool,tr.Entity:GetModel())
end
hook.Add( "CanTool", "TIIPURMCanTool", TIIP.URM.CanTool, -1 )

function TIIP.URM.PlayerSpawnEffect( ply, mdl )
	local value = TIIP.URM.CheckRestrictions(ply,mdl,"effect")
	if (value == TIIP.URM.DENY) then
		ply:RestrictionHit("This effect has been restricted from your usergroup!")
		return false
	elseif (value == TIIP.URM.OVERRIDE) then
		return true
	end
	
	if !ply:CheckLimit(mdl,true) then
		return false
	end		
end
hook.Add( "PlayerSpawnEffect", "TIIPURMPlayerSpawnEffect", TIIP.URM.PlayerSpawnEffect, -1 )

function TIIP.URM.PlayerSpawnedEffect( ply, model, ent )
	local haslimit, limit = TIIP.URM.HasURMLimit(ply,model)
	if haslimit then
		if (type(limit) == "string") then
			ply:AddCount(limit,ent)
		end
	
		ply:AddCount(haslimit,ent)
	end
end
hook.Add( "PlayerSpawnedEffect", "TIIPURMPlayerSpawnedEffect", TIIP.URM.PlayerSpawnedEffect, -1 )

function TIIP.URM.PlayerSpawnNPC( ply, npc, weapon )
	local value = TIIP.URM.CheckRestrictions(ply,npc,"npc")
	if (value == TIIP.URM.DENY) then
		ply:RestrictionHit("This npc has been restricted from your usergroup!")
		return false
	elseif (value == TIIP.URM.OVERRIDE) then
		return true
	end
	
	if !ply:CheckLimit(npc,true) then
		return false
	end		
end
hook.Add( "PlayerSpawnNPC", "TIIPURMPlayerSpawnNPC", TIIP.URM.PlayerSpawnNPC, -1 )

function TIIP.URM.PlayerSpawnedNPC( ply, ent )
	local haslimit,limit = TIIP.URM.HasURMLimit(ply,ent:GetClass())
	
	-- Make sure that restricted weapons that are dropped by NPCs won't be abled to be picked up.
	if ent:GetActiveWeapon() then
		ent:GetActiveWeapon().TIIPURMHasSpawned = true
	end
	
	if haslimit then
		if (type(limit) == "string") then
			ply:AddCount(limit,ent)
		end
	
		ply:AddCount(haslimit,ent)
	end
end
hook.Add( "PlayerSpawnedNPC", "TIIPURMPlayerSpawnedNPC", TIIP.URM.PlayerSpawnedNPC, -1 )

function TIIP.URM.PlayerSpawnRagdoll( ply, mdl )
	local value = TIIP.URM.CheckRestrictions(ply,mdl,"ragdoll")
	if (value == TIIP.URM.DENY) then
		ply:RestrictionHit("This ragdoll has been restricted from your usergroup!")
		return false
	elseif (value == TIIP.URM.OVERRIDE) then
		return true
	end
	
	if !ply:CheckLimit(mdl,true) then
		return false
	end		
end
hook.Add( "PlayerSpawnRagdoll", "TIIPURMPlayerSpawnRagdoll", TIIP.URM.PlayerSpawnRagdoll, -1 )

function TIIP.URM.PlayerSpawnedRagdoll( ply, model, ent )
	local haslimit,limit = TIIP.URM.HasURMLimit(ply,model)
	if haslimit then
		if (type(limit) == "string") then
			ply:AddCount(limit,ent)
		end
	
		ply:AddCount(haslimit,ent)
	end
end
hook.Add( "PlayerSpawnedRagdoll", "TIIPURMPlayerSpawnedRagdoll", TIIP.URM.PlayerSpawnedRagdoll, -1 )

function TIIP.URM.PlayerSpawnSWEP( ply, class, weapon )
	local value = TIIP.URM.CheckRestrictions(ply,class,"swep")
	if (value == TIIP.URM.DENY) then
		ply:RestrictionHit("This weapon has been restricted from your usergroup!")
		return false
	elseif (value == TIIP.URM.OVERRIDE) then 
		return true 
	end

	if !ply:CheckLimit(class,true) then
		return false
	end		
end
hook.Add( "PlayerSpawnSWEP", "TIIPURMPlayerSpawnSWEP", TIIP.URM.PlayerSpawnSWEP, -1 )
hook.Add( "PlayerGiveSWEP", "TIIPURMPlayerSpawnSWEP", TIIP.URM.PlayerSpawnSWEP, -1 )

function TIIP.URM.PlayerSpawnedSWEP( ply, ent )
	local haslimit,limit = TIIP.URM.HasURMLimit(ply,ent:GetClass())
	if haslimit then
		if (type(limit) == "string") then
			ply:AddCount(limit,ent)
		end
		
		ply:AddCount(haslimit,ent)
	end
end
hook.Add( "PlayerSpawnedSWEP", "TIIPURMPlayerSpawnedSWEP", TIIP.URM.PlayerSpawnedSWEP, -1 )

function TIIP.URM.PlayerCanPickupWeapon( ply, weapon )
	if not weapon then return end
	if not weapon:GetClass() then return end

	if (not weapon.TIIPURMHasSpawned) then 
		TIIP.URM.PlayerSpawnSWEP(ply,weapon:GetClass(),weapon)
		return 
	end
	
	local value = TIIP.URM.CheckRestrictions(ply,weapon:GetClass(),"pickup")
	if (value == TIIP.URM.DENY) then
		return false
	elseif (value == TIIP.URM.OVERRIDE) then 
		return true 
	end
end
hook.Add( "PlayerCanPickupWeapon", "TIIPURMPlayerCanPickupWeapon", TIIP.URM.PlayerCanPickupWeapon, -1 )

function TIIP.URM.PlayerSpawnVehicle( ply, mdl, name, vehicle_table )
	local value = TIIP.URM.CheckRestrictions(ply,name,"vehicle")
	if (value == TIIP.URM.DENY) then
		ply:RestrictionHit("This vehicle has been restricted from your usergroup!")
		return false
	elseif (value == TIIP.URM.OVERRIDE) then
		return true
	end
	
	if !ply:CheckLimit(name,true) then
		return false
	end	
end
hook.Add( "PlayerSpawnVehicle", "TIIPURMPlayerSpawnVehicle", TIIP.URM.PlayerSpawnVehicle, -1 )

function TIIP.URM.PlayerSpawnedVehicle( ply, ent )
	local haslimit, limit = TIIP.URM.HasURMLimit(ply,ent:GetTable().VehicleName)
	if haslimit then
		if (type(limit) == "string") then
			ply:AddCount(limit,ent)
		end
	
		ply:AddCount(haslimit,ent)
	end
end
hook.Add( "PlayerSpawnedVehicle", "TIIPURMPlayerSpawnedVehicle", TIIP.URM.PlayerSpawnedVehicle, -1 )

function TIIP.URM.PlayerLoadout( ply )
	return TIIP.URM.SetPlayerLoadout(ply) 
end
hook.Add( "PlayerLoadout", "TIIPURMPlayerLoadout", TIIP.URM.PlayerLoadout, -1 )

function TIIP.URM.PlayerAuthed( ply )
	if ULib.ucl.query( ply, "xgui_urm" ) then
		TIIP.URM.SendCompressedTable(ply,TIIP.URM.DATA["TIIPURMRestrictions"](), "TIIPURMRestrictions")
		TIIP.URM.SendCompressedTable(ply,TIIP.URM.DATA["TIIPURMLimits"](), "TIIPURMLimits")
		TIIP.URM.SendCompressedTable(ply,TIIP.URM.DATA["TIIPURMLoadouts"](), "TIIPURMLoadouts")
	end
end
hook.Add( "UCLAuthed", "TIIPURMPlayerAuthed", TIIP.URM.PlayerAuthed, -1 )

timer.Simple(5, function()	
		
	--Override ents.Create
	if not TIIP.URM.hasEntsCreate then
		TIIP.URM.oldEntsCreate = ents.Create
		function ents.Create( class )
			local ent = TIIP.URM.oldEntsCreate(class)
			ent.TIIPURMHasSpawned = true
			return ent
		end
	end
	TIIP.URM.hasEntsCreate = true

	--Override CheckLimit function
	local meta = FindMetaTable( "Player" )
	if not meta then return end

	function meta:CheckLimit( id, limit )
		local v = TIIP.URM.HasURMLimit(self,id)
		if v then return TIIP.URM.CheckLimit(self,v) end
		if not id or id == "" then return true end
		if limit then return true end
		
		--PLAYER_EXTENSION FROM GAMEMODE BELOW
		
		-- No limits in single player
		if (game.SinglePlayer()) then return true end

		local c = cvars.Number( "sbox_max"..id, 0 )
		
		if ( c < 0 ) then return true end
		if ( self:GetCount( id ) > c-1 ) then self:LimitHit( id ) return false end

		return true
	end
	
	function meta:RestrictionHit( str )

		self:SendLua(string.format([[
			notification.AddLegacy("%s",NOTIFY_ERROR,3)
		]],str))
		self:SendLua( [[surface.PlaySound( "buttons/button10.wav" )]] )

	end
	
	function meta:LimitHit( str, limit )

		if limit then
			self:SendLua(string.format([[
				notification.AddLegacy("You've hit the %s limit!",NOTIFY_ERROR,3)
			]],str))
			self:SendLua( [[surface.PlaySound( "buttons/button10.wav" )]] )
			return
		end
		self:SendLua( 'hook.Run("LimitHit","' .. str .. '")' )

	end

end)
