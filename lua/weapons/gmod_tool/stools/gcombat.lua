TOOL.Category		= "GCombat"
TOOL.Name			= "#Gcombat"
TOOL.Command		= nil
TOOL.ConfigName		= ""

TOOL.ClientConVar[ "gtype" ] = "0"
TOOL.ent = {}

if (SERVER) then
	CreateConVar('sbox_maxgcombat', 10)
end

if CLIENT then
	language.Add( "tool.gdcweapons.name", "GCombat" )
	language.Add( "Tool.gdcweapons.desc", "Puts weapons on stuff" )
	language.Add( "Tool.gdcweapons.0", "Left click to spawn and weld a weapon. Right click to spawn one unwelded. R for weapon statistics. DPS = Damage Per Second (AP Ammo only)." )
end

cleanup.Register( "gcombat" )


// Add Default Language translation (saves adding it to the txt files)
if ( CLIENT ) then

	language.Add( "Tool_gcombat_name", "Gcombat tool" )
	language.Add( "Tool_gcombat_desc", "Adds weaponry to things." )
	language.Add( "Tool_gcombat_0", "Left click to apply the selected object. Right click for a secondary placement. Reload for Info on the selection." )
	
	language.Add( "Tool_turret_type", "Type of weapon" )
	
	language.Add( "Tool_gcombat_help0", "Fires high powered antitank shots and has a secondary anti-infantry shell." )
	language.Add( "Tool_gcombat_help1", "High reload rate light cannon, perfect for fast vehicles." )
	language.Add( "Tool_gcombat_help2", "Fires a tunable high powered energy beam that fries essential components." )
	language.Add( "Tool_gcombat_help3", "Long ranged artillery, poses a serious risk of self harm at close range." )
	language.Add( "Tool_gcombat_help4", "Launches a very powerful aquatic shell. Best used at a range of 1500 - 2500 world units." )
	language.Add( "Tool_gcombat_help5", "Melee range energy weapon that deals a huge amount of damage when moved swiftly." )
	language.Add( "Tool_gcombat_help6", "Press use on it to get an infantry weapon. The choices are: sapper, rifle, and mortar gun. Sappers can be placed on enemy vehicles manually. The sapper will fall off when severely damaged. \n Note that the ammo counters on the other two weapons appear broken at a glance. The sooner you figure out what they're actually for, the better. \n Bludgeon with crowbar to select." )
	language.Add( "Tool_gcombat_help7", "Fires an extremely high-powered beam that will vaporise the toughest prop in a single hit." )
	language.Add( "Tool_gcombat_help8", "Launches a swarm of rockets that deal quite a lot of damage, but tend to be inaccurate." )
	language.Add( "Tool_gcombat_help9", "Charges up, and fires a hail of energy beams in a cone." )
	language.Add( "Tool_gcombat_help10", "Defends against incoming projectile weapons, but is fooled by the sapper and the grenade cannon." )
	language.Add( "Tool_gcombat_help11", "Melee range energy weapon that deals a huge amount of damage when moved swiftly. The beam is shorter than the beamsword, but deals significantly more damage." )
	language.Add( "Tool_gcombat_help12", "Fires remote detonated grenades. Perfect for setting ambushes and breaking through heavy point defense." )
	language.Add( "Tool_gcombat_help13", "Fires a powerful stream of fire, that you can kill it with." )
	language.Add( "Tool_gcombat_help14", "Launches a swarm of homing rockets. Warning, these rockets have serious ADD." )
	language.Add( "Tool_gcombat_help15", "Fires rapid fire energy bolts in a tight cone." )
	language.Add( "Tool_gcombat_help16", "A very powerful homing weapon. Is incapable of hitting targets less than 800 world units above the launch position." )
	language.Add( "Tool_gcombat_help17", "Artillery that fires a simple high explosive shot for indirect fire." )
	language.Add( "Tool_gcombat_help18", "Warns of incoming homing missile attacks" )
	language.Add( "Tool_gcombat_help19", "Long range missile" )
	
	language.Add( "Undone_gcombat", "Undone weapon" )
	
	language.Add( "Cleanup_gcombat", "Weapon" )
	language.Add( "Cleaned_gcombat", "Cleaned up all Weapons" )
	language.Add( "SBoxLimit_gcombat", "You've reached the Weapon limit!" )

end

function TOOL:LeftClick( trace )
if (CLIENT) then return true end
if ( !trace.Hit ) then return end
local ply = self:GetOwner()
if (!ply:CheckLimit( "gcombat" )) then return end
	
	if ( SERVER && !util.IsValidPhysicsObject( trace.Entity, trace.PhysicsBone ) ) then return false end
	
	
	local gtype	= self:GetClientNumber( "gtype" ) 
	
	local SpawnPos = trace.HitPos + trace.HitNormal * 4
	if (gtype == 0) then
	self.ent = ents.Create( "TANK_GUN" )
		self.ent:SetPos( SpawnPos )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0))
	self.ent:Spawn()
	self.ent:Activate()
	elseif (gtype == 1) then
	self.ent = ents.Create( "2PDR" )
		self.ent:SetPos( SpawnPos )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0))
	self.ent:Spawn()
	self.ent:Activate()
	elseif (gtype == 2) then
	self.ent = ents.Create( "FLAK_88" )
		self.ent:SetPos( SpawnPos )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0))
	self.ent:Spawn()
	self.ent:Activate()
	elseif (gtype == 3) then
	self.ent = ents.Create( "NEBELWERFER" )
		self.ent:SetPos( SpawnPos )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0))
	self.ent:Spawn()
	self.ent:Activate()
	elseif (gtype == 4) then
	self.ent = ents.Create( "TORPEDO_LAUNCHER" )
		self.ent:SetPos( SpawnPos )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0))
	self.ent:Spawn()
	self.ent:Activate()
	elseif (gtype == 5) then
	self.ent = ents.Create( "BEAMSWORD" )
		self.ent:SetPos( SpawnPos )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0))
	self.ent:Spawn()
	self.ent:Activate()
	elseif (gtype == 6) then
	self.ent = ents.Create( "sapper_crate" )
		self.ent:SetPos( SpawnPos )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0))
	self.ent:Spawn()
	self.ent:Activate()
	elseif (gtype == 7) then
	self.ent = ents.Create( "DEATHRAY" )
		self.ent:SetPos( SpawnPos )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0))
	self.ent:Spawn()
	self.ent:Activate()
	elseif (gtype == 8) then
	self.ent = ents.Create( "AAROCKETS" )
		self.ent:SetPos( SpawnPos )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0))
	self.ent:Spawn()
	self.ent:Activate()
	elseif (gtype == 9) then
	self.ent = ents.Create( "PLASMACANNON" )
		self.ent:SetPos( SpawnPos )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0))
	self.ent:Spawn()
	self.ent:Activate()
	elseif (gtype == 10) then
	self.ent = ents.Create( "POINT_DEFENSE" )
		self.ent:SetPos( SpawnPos )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0))
	self.ent:Spawn()
	self.ent:Activate()
	elseif (gtype == 11) then
	self.ent = ents.Create( "BEAMDAGGER" )
		self.ent:SetPos( SpawnPos )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0))
	self.ent:Spawn()
	self.ent:Activate()
	elseif (gtype == 12) then
	self.ent = ents.Create( "HEAVY_GRENADE" )
		self.ent:SetPos( SpawnPos )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0))
	self.ent:Spawn()
	self.ent:Activate()
	elseif (gtype == 13) then
	self.ent = ents.Create( "FLAMETHROWER" )
		self.ent:SetPos( SpawnPos )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0))
	self.ent:Spawn()
	self.ent:Activate()
	elseif (gtype == 14) then
	self.ent = ents.Create( "SWARMERROCKET" )
		self.ent:SetPos( SpawnPos )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0))
	self.ent:Spawn()
	self.ent:Activate()
	elseif (gtype == 15) then
	self.ent = ents.Create( "PEWPEW" )
		self.ent:SetPos( SpawnPos )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0))
	self.ent:Spawn()
	self.ent:Activate()
	elseif (gtype == 16) then
	self.ent = ents.Create( "SAMLAUNCH" )
		self.ent:SetPos( SpawnPos )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0))
	self.ent:Spawn()
	self.ent:Activate()
	elseif (gtype == 17) then
	self.ent = ents.Create( "MORTAR" )
		self.ent:SetPos( SpawnPos )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0))
	self.ent:Spawn()
	self.ent:Activate()
	elseif (gtype == 18) then
	self.ent = ents.Create( "LOCK_WARN" )
		self.ent:SetPos( SpawnPos )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0))
	self.ent:Spawn()
	self.ent:Activate()
	elseif (gtype == 19) then
	self.ent = ents.Create( "LONGRANGEMISSILE" )
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
	
	undo.Create("gcombat")
		undo.AddEntity( self.ent )
		undo.AddEntity( weld )
		undo.AddEntity( nocollide )
		undo.SetPlayer( ply )
	undo.Finish()
	return true

end

function TOOL:RightClick( trace )
if (CLIENT) then return true end
if ( !trace.Hit ) then return end
local ply = self:GetOwner()
if (!ply:CheckLimit( "gcombat" )) then return end

	if ( SERVER && !util.IsValidPhysicsObject( trace.Entity, trace.PhysicsBone ) ) then return false end
	
	
	local gtype	= self:GetClientNumber( "gtype" ) 
	
	local SpawnPos = trace.HitPos + trace.HitNormal * 4
	if (gtype == 0) then
	self.ent = ents.Create( "TANK_GUN" )
		self.ent:SetPos( SpawnPos )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0))
	self.ent:Spawn()
	self.ent:Activate()
	elseif (gtype == 1) then
	self.ent = ents.Create( "2PDR" )
		self.ent:SetPos( SpawnPos )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0))
	self.ent:Spawn()
	self.ent:Activate()
	elseif (gtype == 2) then
	self.ent = ents.Create( "FLAK_88" )
		self.ent:SetPos( SpawnPos )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0))
	self.ent:Spawn()
	self.ent:Activate()
	elseif (gtype == 3) then
	self.ent = ents.Create( "NEBELWERFER" )
		self.ent:SetPos( SpawnPos )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0))
	self.ent:Spawn()
	self.ent:Activate()
	elseif (gtype == 4) then
	self.ent = ents.Create( "TORPEDO_LAUNCHER" )
		self.ent:SetPos( SpawnPos )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0))
	self.ent:Spawn()
	self.ent:Activate()
	elseif (gtype == 5) then
	self.ent = ents.Create( "BEAMSWORD" )
		self.ent:SetPos( SpawnPos )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0))
	self.ent:Spawn()
	self.ent:Activate()
	elseif (gtype == 6) then
	self.ent = ents.Create( "sapper_crate" )
		self.ent:SetPos( SpawnPos )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0))
	self.ent:Spawn()
	self.ent:Activate()
	elseif (gtype == 7) then
	self.ent = ents.Create( "DEATHRAY" )
		self.ent:SetPos( SpawnPos )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0))
	self.ent:Spawn()
	self.ent:Activate()
	elseif (gtype == 8) then
	self.ent = ents.Create( "AAROCKETS" )
		self.ent:SetPos( SpawnPos )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0))
	self.ent:Spawn()
	self.ent:Activate()
	elseif (gtype == 9) then
	self.ent = ents.Create( "PLASMACANNON" )
		self.ent:SetPos( SpawnPos )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0))
	self.ent:Spawn()
	self.ent:Activate()
	elseif (gtype == 10) then
	self.ent = ents.Create( "POINT_DEFENSE" )
		self.ent:SetPos( SpawnPos )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0))
	self.ent:Spawn()
	self.ent:Activate()
	elseif (gtype == 11) then
	self.ent = ents.Create( "BEAMDAGGER" )
		self.ent:SetPos( SpawnPos )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0))
	self.ent:Spawn()
	self.ent:Activate()
	elseif (gtype == 12) then
	self.ent = ents.Create( "HEAVY_GRENADE" )
		self.ent:SetPos( SpawnPos )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0))
	self.ent:Spawn()
	self.ent:Activate()
	elseif (gtype == 13) then
	self.ent = ents.Create( "FLAMETHROWER" )
		self.ent:SetPos( SpawnPos )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0))
	self.ent:Spawn()
	self.ent:Activate()
	elseif (gtype == 14) then
	self.ent = ents.Create( "SWARMERROCKET" )
		self.ent:SetPos( SpawnPos )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0))
	self.ent:Spawn()
	self.ent:Activate()
	elseif (gtype == 15) then
	self.ent = ents.Create( "PEWPEW" )
		self.ent:SetPos( SpawnPos )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0))
	self.ent:Spawn()
	self.ent:Activate()
	elseif (gtype == 16) then
	self.ent = ents.Create( "SAMLAUNCH" )
		self.ent:SetPos( SpawnPos )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0))
	self.ent:Spawn()
	self.ent:Activate()
	elseif (gtype == 17) then
	self.ent = ents.Create( "MORTAR" )
		self.ent:SetPos( SpawnPos )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0))
	self.ent:Spawn()
	self.ent:Activate()
	elseif (gtype == 18) then
	self.ent = ents.Create( "LOCK_WARN" )
		self.ent:SetPos( SpawnPos )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0))
	self.ent:Spawn()
	self.ent:Activate()
	elseif (gtype == 19) then
	self.ent = ents.Create( "LONGRANGEMISSILE" )
		self.ent:SetPos( SpawnPos )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0))
	self.ent:Spawn()
	self.ent:Activate()
	end
	
	ply:AddCount( "gcombat", self.ent ) 
	undo.Create("gcombat")
		undo.AddEntity( self.ent )
		undo.SetPlayer( ply )
	undo.Finish()
	return true

end

function TOOL:Reload()
	local ply = self:GetOwner()
	local gtype	= self:GetClientNumber( "gtype" ) 
	ply:PrintMessage( HUD_PRINTTALK, "#Tool_gcombat_help" .. gtype )
end


if CLIENT then
function TOOL.BuildCPanel( CPanel )
	CPanel:ClearControls()
	--CPanel:AddHeader()
	--CPanel:AddDefaultControls()
	// HEADER
	CPanel:AddControl( "Header", { Text = "#Tool_gcombat_name", Description	= "#Tool_gcombat_desc" }  )
	
	
	// the pertenent cannon
	local Ctype = {Label = "#Tool_turret_type", MenuButton = 0, Options={}}
		Ctype["Options"]["#Tank gun"]	= { gcombat_gtype = "0" }
		Ctype["Options"]["#2pdr gun"]	= { gcombat_gtype = "1" }
		Ctype["Options"]["#Ion ray"]	= { gcombat_gtype = "2" }
		Ctype["Options"]["#Nebelwerfer"]	= { gcombat_gtype = "3" }
		Ctype["Options"]["#Torpedo (dumb)"]	= { gcombat_gtype = "4" }
		Ctype["Options"]["#Beam sword"]	= { gcombat_gtype = "5" }
		Ctype["Options"]["#Supply Crate"]	= { gcombat_gtype = "6" }
		Ctype["Options"]["#Deathray"]	= { gcombat_gtype = "7" }
		Ctype["Options"]["#Dumb rocket battery"]	= { gcombat_gtype = "8" }
		Ctype["Options"]["#Plasma cannon"]	= { gcombat_gtype = "9" }
		Ctype["Options"]["#Point defense"]	= { gcombat_gtype = "10" }
		Ctype["Options"]["#Beam dagger"]	= { gcombat_gtype = "11" }
		Ctype["Options"]["#Grenade cannon"]	= { gcombat_gtype = "12" }
		Ctype["Options"]["#Flame cannon"]	= { gcombat_gtype = "13" }
		Ctype["Options"]["#Swarmer launcher"]	= { gcombat_gtype = "14" }
		Ctype["Options"]["#Vulcan laser"]	= { gcombat_gtype = "15" }
		Ctype["Options"]["#SAM launcher"]	= { gcombat_gtype = "16" }
		Ctype["Options"]["#Mortar"]	= { gcombat_gtype = "17" }
		Ctype["Options"]["#Warning system"]	= { gcombat_gtype = "18" }
		Ctype["Options"]["#LRM launcher"]	= { gcombat_gtype = "19" }
		
		
		
	CPanel:AddControl("ComboBox", Ctype )
	
	

end
end

