
TOOL.Category		= "GCombat"
TOOL.Name			= "#GCX Cannons"
TOOL.Command		= nil
TOOL.ConfigName		= ""

TOOL.ClientConVar[ "cannonindex" ] = "0"
TOOL.ent = {}


cleanup.Register( "cannons" )


// Add Default Language translation (saves adding it to the txt files)
if ( CLIENT ) then

	language.Add( "Tool_cannons_name", "GCX Cannons" )
	language.Add( "Tool_cannons_desc", "Adds cannons to things." )
	language.Add( "Tool_cannons_0", "Left click to weld the selected object. Right click to spawn." )
	
	language.Add( "Tool_cannons_help0", "Large howitzer with AP and HE rounds. " )
	language.Add( "Tool_cannons_help1", "Multi-shot howitzer that fires 6 shots in a row. " )
	language.Add( "Tool_cannons_help2", "Cannon that automatically puts 2 shots down range. " )
	language.Add( "Tool_cannons_help3", "Long Range homing missile launcher that firs a barrage of 12. " )
	language.Add( "Tool_cannons_help4", "Large howitzer capable of firing the dreaded Breach shell. " )
	language.Add( "Tool_cannons_help5", "Short Range homing missile launcher that fires a barrage of 6. " )
	language.Add( "Tool_cannons_help6", "High speed dumb fire rocket launcher. " )
	language.Add( "Tool_cannons_help7", "Mounted 50cal machine gun. " )
	language.Add( "Tool_cannons_help8", "Light damage rapid fire energy weapon. " )
	language.Add( "Tool_cannons_help9", "Single shot autocannon. " )
	language.Add( "Tool_cannons_help10", "Rapid fire autocannon " )
	language.Add( "Tool_cannons_help11", "Medium damage medium fire rate energy weapon. " )
	language.Add( "Tool_cannons_help12", "Heavy damage slow fire rate energy weapon. " )
	language.Add( "Tool_cannons_help13", "When you absolutely have to kill it in one barrage. " )
	language.Add( "Tool_cannons_help14", "Large cannon designed to take out tanks has AP and HE. " )
	language.Add( "Tool_cannons_help15", "High velocity energy fired cannon large damage. " )
	language.Add( "Tool_cannons_help16", "Extreme velocity large sniper rifle. " )
	language.Add( "Tool_cannons_help17", "Large Navel artillery cannon. " )
	language.Add( "Tool_cannons_help18", "10 shot magazine rapid fire cannon. " )
	language.Add( "Tool_cannons_help19", "Short range ZAP!! " )
	language.Add( "Tool_cannons_help20", "12 shot dumb fire rocket pod. " )
	language.Add( "Tool_cannons_help21", "Large tank mounted cannon. " )
	language.Add( "Tool_cannons_help22", "V2 Rocket....need I say more? " )
	language.Add( "Tool_cannons_help23", "40mm Anti-infantry/light target" )
	language.Add( "Tool_cannons_help24", "40mm grenade launcher" )
	language.Add( "Tool_cannons_help25", "RAAAAAAPE " )

	
	
	language.Add( "Tool_turret_type", "Type of weapon" )
	
	language.Add( "Undone_cannons", "Undone weapon" )
	
	language.Add( "Cleanup_cannons", "Weapon" )
	language.Add( "Cleaned_cannons", "Cleaned up all Weapons" )
	language.Add( "SBoxLimit_gcombats", "You've reached the Weapon limit!" )

end

function TOOL:LeftClick( trace )
local ply = self:GetOwner()
if FIELDS == nil and COMBATDAMAGEENGINE == nil then
	ply:PrintMessage( HUD_PRINTCENTER, "You need Gcombat Core to use GCX" )  
	return 
end
if (!ply:CheckLimit( "gcombat" )) then return end
if ( !trace.Hit ) then return end
	
	if ( SERVER && !util.IsValidPhysicsObject( trace.Entity, trace.PhysicsBone ) ) then return false end
	if (CLIENT) then return true end
	
	local cannonindex	= self:GetClientNumber( "cannonindex" ) 
	
	local SpawnPos = trace.HitPos + trace.HitNormal * 6
	if (cannonindex == 0) then
	self.ent = ents.Create( "155mm_howitzer" )
		self.ent:SetPos( SpawnPos )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0))
	self.ent:Spawn()
	self.ent:Activate()
	elseif (cannonindex == 1) then
	self.ent = ents.Create( "artybarrage" )
		self.ent:SetPos( SpawnPos )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0))
	self.ent:Spawn()
	self.ent:Activate()
	elseif (cannonindex == 2) then
	self.ent = ents.Create( "uac5" )
		self.ent:SetPos( SpawnPos )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0))
	self.ent:Spawn()
	self.ent:Activate()
	elseif (cannonindex == 3) then
	self.ent = ents.Create( "lrm12rack" )
		self.ent:SetPos( SpawnPos )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0))
	self.ent:Spawn()
	self.ent:Activate()
	elseif (cannonindex == 4) then
	self.ent = ents.Create( "trimodehowitzer" )
		self.ent:SetPos( SpawnPos )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0))
	self.ent:Spawn()
	self.ent:Activate()	
	elseif (cannonindex == 5) then
	self.ent = ents.Create( "cstrk6pod" )
		self.ent:SetPos( SpawnPos )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0))
	self.ent:Spawn()
	self.ent:Activate()
	elseif (cannonindex == 6) then
	self.ent = ents.Create( "hvrpod" )
		self.ent:SetPos( SpawnPos )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0))
	self.ent:Spawn()
	self.ent:Activate()	
	elseif (cannonindex == 7) then
	self.ent = ents.Create( "50cal" )
		self.ent:SetPos( SpawnPos )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0))
	self.ent:Spawn()
	self.ent:Activate()
	elseif (cannonindex == 8) then
	self.ent = ents.Create( "ecgun" )
		self.ent:SetPos( SpawnPos )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0))
	self.ent:Spawn()
	self.ent:Activate()
	elseif (cannonindex == 9) then
	self.ent = ents.Create( "ac5" )
		self.ent:SetPos( SpawnPos )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0))
	self.ent:Spawn()
	self.ent:Activate()
	elseif (cannonindex == 10) then
	self.ent = ents.Create( "rac5" )
		self.ent:SetPos( SpawnPos )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0))
	self.ent:Spawn()
	self.ent:Activate()
	elseif (cannonindex == 11) then
	self.ent = ents.Create( "medecg" )
		self.ent:SetPos( SpawnPos )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0))
	self.ent:Spawn()
	self.ent:Activate()
	elseif (cannonindex == 12) then
	self.ent = ents.Create( "lgecg" )
		self.ent:SetPos( SpawnPos )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0))
	self.ent:Spawn()
	self.ent:Activate()
	elseif (cannonindex == 13) then
	self.ent = ents.Create( "lbxac20" )
		self.ent:SetPos( SpawnPos )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0))
	self.ent:Spawn()
	self.ent:Activate()
	elseif (cannonindex == 14) then
	self.ent = ents.Create( "atc" )
		self.ent:SetPos( SpawnPos )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0))
	self.ent:Spawn()
	self.ent:Activate()
	elseif (cannonindex == 15) then
	self.ent = ents.Create( "gauss" )
		self.ent:SetPos( SpawnPos )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0))
	self.ent:Spawn()
	self.ent:Activate()	
	elseif (cannonindex == 16) then
	self.ent = ents.Create( "Railgun" )
		self.ent:SetPos( SpawnPos + Vector(0,0,100) )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,90))
	self.ent:Spawn()
	self.ent:Activate()	
	elseif (cannonindex == 17) then
	self.ent = ents.Create( "150mm" )
		self.ent:SetPos( SpawnPos )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0))
	self.ent:Spawn()
	self.ent:Activate()	
	elseif (cannonindex == 18) then
	self.ent = ents.Create( "25mm" )
		self.ent:SetPos( SpawnPos )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0))
	self.ent:Spawn()
	self.ent:Activate()	
	elseif (cannonindex == 19) then
	self.ent = ents.Create( "tesla" )
		self.ent:SetPos( SpawnPos )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0))
	self.ent:Spawn()
	self.ent:Activate()	
	elseif (cannonindex == 20) then
	self.ent = ents.Create( "Hellfire" )
		self.ent:SetPos( SpawnPos )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0))
	self.ent:Spawn()
	self.ent:Activate()	
	elseif (cannonindex == 21) then
	self.ent = ents.Create( "80mm" )
		self.ent:SetPos( SpawnPos )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0))
	self.ent:Spawn()
	self.ent:Activate()	
	elseif (cannonindex == 22) then
	self.ent = ents.Create( "V2" )
		self.ent:SetPos( SpawnPos )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0))
	self.ent:Spawn()
	self.ent:Activate()	
	elseif (cannonindex == 23) then
	self.ent = ents.Create( "40mm" )
		self.ent:SetPos( SpawnPos )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0))
	self.ent:Spawn()
	self.ent:Activate()
	elseif (cannonindex == 24) then
	self.ent = ents.Create( "mk19" )
		self.ent:SetPos( SpawnPos )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0))
	self.ent:Spawn()
	self.ent:Activate()
	elseif (cannonindex == 25) then
	self.ent = ents.Create( "gau12" )
		self.ent:SetPos( SpawnPos )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0))
	self.ent:Spawn()
	self.ent:Activate()
	end
	
	
	local phys = self.ent:GetPhysicsObject()  	
	if (phys:IsValid()) then  		
		local weld = constraint.Weld(self.ent, trace.Entity, 0, trace.PhysicsBone, 0)
		local nocollide = constraint.NoCollide(self.ent, trace.Entity, 0, trace.PhysicsBone)
	end 
	ply:AddCount( "gcombat", self.ent )
	
	undo.Create("cannons")
		undo.AddEntity( self.ent )
		undo.AddEntity( weld )
		undo.AddEntity( nocollide )
		undo.SetPlayer( ply )
	undo.Finish()
	return true

end

function TOOL:RightClick( trace )
local ply = self:GetOwner()
if FIELDS == nil and COMBATDAMAGEENGINE == nil then
	ply:PrintMessage( HUD_PRINTCENTER, "You need Gcombat Core to use GCX" )  
	return 
end
if (!ply:CheckLimit( "gcombat" )) then return end	
if ( !trace.Hit ) then return end
	
	if ( SERVER && !util.IsValidPhysicsObject( trace.Entity, trace.PhysicsBone ) ) then return false end
	if (CLIENT) then return true end
	
	local cannonindex	= self:GetClientNumber( "cannonindex" ) 
	
	local SpawnPos = trace.HitPos + trace.HitNormal * 4
	if (cannonindex == 0) then
	self.ent = ents.Create( "155mm_howitzer" )
		self.ent:SetPos( SpawnPos )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0))
	self.ent:Spawn()
	self.ent:Activate()
	elseif (cannonindex == 1) then
	self.ent = ents.Create( "artybarrage" )
		self.ent:SetPos( SpawnPos )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0))
	self.ent:Spawn()
	self.ent:Activate()
	elseif (cannonindex == 2) then
	self.ent = ents.Create( "uac5" )
		self.ent:SetPos( SpawnPos )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0))
	self.ent:Spawn()
	self.ent:Activate()
	elseif (cannonindex == 3) then
	self.ent = ents.Create( "lrm12rack" )
		self.ent:SetPos( SpawnPos )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0))
	self.ent:Spawn()
	self.ent:Activate()
	elseif (cannonindex == 4) then
	self.ent = ents.Create( "trimodehowitzer" )
		self.ent:SetPos( SpawnPos )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0))
	self.ent:Spawn()
	self.ent:Activate()	
	elseif (cannonindex == 5) then
	self.ent = ents.Create( "cstrk6pod" )
		self.ent:SetPos( SpawnPos )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0))
	self.ent:Spawn()
	self.ent:Activate()
	elseif (cannonindex == 6) then
	self.ent = ents.Create( "hvrpod" )
		self.ent:SetPos( SpawnPos )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0))
	self.ent:Spawn()
	self.ent:Activate()	
	elseif (cannonindex == 7) then
	self.ent = ents.Create( "50cal" )
		self.ent:SetPos( SpawnPos )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0))
	self.ent:Spawn()
	self.ent:Activate()
	elseif (cannonindex == 8) then
	self.ent = ents.Create( "ecgun" )
		self.ent:SetPos( SpawnPos )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0))
	self.ent:Spawn()
	self.ent:Activate()
	elseif (cannonindex == 9) then
	self.ent = ents.Create( "ac5" )
		self.ent:SetPos( SpawnPos )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0))
	self.ent:Spawn()
	self.ent:Activate()
	elseif (cannonindex == 10) then
	self.ent = ents.Create( "rac5" )
		self.ent:SetPos( SpawnPos )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0))
	self.ent:Spawn()
	self.ent:Activate()
	elseif (cannonindex == 11) then
	self.ent = ents.Create( "medecg" )
		self.ent:SetPos( SpawnPos )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0))
	self.ent:Spawn()
	self.ent:Activate()
	elseif (cannonindex == 12) then
	self.ent = ents.Create( "lgecg" )
		self.ent:SetPos( SpawnPos )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0))
	self.ent:Spawn()
	self.ent:Activate()
	elseif (cannonindex == 13) then
	self.ent = ents.Create( "lbxac20" )
		self.ent:SetPos( SpawnPos )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0))
	self.ent:Spawn()
	self.ent:Activate()
	elseif (cannonindex == 14) then
	self.ent = ents.Create( "atc" )
		self.ent:SetPos( SpawnPos )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0))
	self.ent:Spawn()
	self.ent:Activate()
	elseif (cannonindex == 15) then
	self.ent = ents.Create( "gauss" )
		self.ent:SetPos( SpawnPos )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0))
	self.ent:Spawn()
	self.ent:Activate()	
	elseif (cannonindex == 16) then
	self.ent = ents.Create( "Railgun" )
		self.ent:SetPos( SpawnPos + Vector(0,0,100) )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,90))
	self.ent:Spawn()
	self.ent:Activate()	
		elseif (cannonindex == 17) then
	self.ent = ents.Create( "150mm" )
		self.ent:SetPos( SpawnPos )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0))
	self.ent:Spawn()
	self.ent:Activate()	
	elseif (cannonindex == 18) then
	self.ent = ents.Create( "25mm" )
		self.ent:SetPos( SpawnPos )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0))
	self.ent:Spawn()
	self.ent:Activate()	
	elseif (cannonindex == 19) then
	self.ent = ents.Create( "tesla" )
		self.ent:SetPos( SpawnPos )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0))
	self.ent:Spawn()
	self.ent:Activate()	
	elseif (cannonindex == 20) then
	self.ent = ents.Create( "Hellfire" )
		self.ent:SetPos( SpawnPos )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0))
	self.ent:Spawn()
	self.ent:Activate()	
	elseif (cannonindex == 21) then
	self.ent = ents.Create( "80mm" )
		self.ent:SetPos( SpawnPos )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0))
	self.ent:Spawn()
	self.ent:Activate()	
	elseif (cannonindex == 22) then
	self.ent = ents.Create( "V2" )
		self.ent:SetPos( SpawnPos )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0))
	self.ent:Spawn()
	self.ent:Activate()	
	elseif (cannonindex == 23) then
	self.ent = ents.Create( "40mm" )
		self.ent:SetPos( SpawnPos )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0))
	self.ent:Spawn()
	self.ent:Activate()
	elseif (cannonindex == 24) then
	self.ent = ents.Create( "mk19" )
		self.ent:SetPos( SpawnPos )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0))
	self.ent:Spawn()
	self.ent:Activate()
	elseif (cannonindex == 25) then
	self.ent = ents.Create( "gau12" )
		self.ent:SetPos( SpawnPos )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0))
	self.ent:Spawn()
	self.ent:Activate()
	end

	ply:AddCount( "gcombat", self.ent )
	undo.Create("cannons")
		undo.AddEntity( self.ent )
		undo.AddEntity( weld )
		undo.AddEntity( nocollide )
		undo.SetPlayer( ply )
	undo.Finish()
	return true

end

function TOOL:Reload()
	local ply = self:GetOwner()
	local cannonindex	= self:GetClientNumber( "cannonindex" ) 
	ply:PrintMessage( HUD_PRINTTALK, "#Tool_cannons_help" .. cannonindex )
end



function TOOL.BuildCPanel( CPanel )

	// HEADER
	CPanel:AddControl( "Header", { Text = "#Tool_cannons_name", Description	= "#Tool_cannons_desc" }  )
	
	
	// the pertenent cannon
	local Ctype = {Label = "#Tool_turret_type", MenuButton = 0, Options={}}
		Ctype["Options"]["#155mm Howitzer"]	= { cannons_cannonindex = "0" }
		Ctype["Options"]["#Artillery Barrage"]	= { cannons_cannonindex = "1" }
		Ctype["Options"]["#Ultra AutoCannon 5"]	= { cannons_cannonindex = "2" }
		Ctype["Options"]["#LRM-12"]	= { cannons_cannonindex = "3" }
		Ctype["Options"]["#Tri-Mode Howitzer"]	= { cannons_cannonindex = "4" }
		Ctype["Options"]["#Clan Streak 6 pod"]	= { cannons_cannonindex = "5" }
		Ctype["Options"]["#High Velocity Rocket pod"]	= { cannons_cannonindex = "6" }
		Ctype["Options"]["#M2 HB 50cal"]	= { cannons_cannonindex = "7" }
		Ctype["Options"]["#Light Electro-Chemical Gun"]	= { cannons_cannonindex = "8" }
		Ctype["Options"]["#AutoCannon 5"]	= { cannons_cannonindex = "9" }
		Ctype["Options"]["#Rotary AutoCannon 5"]	= { cannons_cannonindex = "10" }
		Ctype["Options"]["#Medium Electro-Chemical Gun"]	= { cannons_cannonindex = "11" }
		Ctype["Options"]["#Heavy Electro-Chemical Gun"]	= { cannons_cannonindex = "12" }
		Ctype["Options"]["#LBXAC-20"]	= { cannons_cannonindex = "13" }
		Ctype["Options"]["#120mm Anti-Tank Cannon"]	= { cannons_cannonindex = "14" }
		Ctype["Options"]["#Gauss Cannon"]	= { cannons_cannonindex = "15" }
		Ctype["Options"]["#Railgun"]	= { cannons_cannonindex = "16" }
		Ctype["Options"]["#150mm Cannon"]	= { cannons_cannonindex = "17" }
		Ctype["Options"]["#25mm Cannon"]	= { cannons_cannonindex = "18" }
		Ctype["Options"]["#Tesla Cannon"]	= { cannons_cannonindex = "19" }
		Ctype["Options"]["#FFAR Rocket Pod"]	= { cannons_cannonindex = "20" }
		Ctype["Options"]["#80mm"]	= { cannons_cannonindex = "21" }
		Ctype["Options"]["#V2"]	= { cannons_cannonindex = "22" }
		Ctype["Options"]["#Bofors 40mm"]	= { cannons_cannonindex = "23" }
		Ctype["Options"]["#MK19"]	= { cannons_cannonindex = "24" }
		Ctype["Options"]["#GAU-12"]	= { cannons_cannonindex = "25" }
	CPanel:AddControl("ComboBox", Ctype )
	

end
