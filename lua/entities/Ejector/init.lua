
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')


function ENT:Initialize()   

math.randomseed(CurTime())
self.launched = false
self.fuelleft = 10
self.Fires = false
self.coward = nil
self.armz = {}
self.Entity:SetModel( "models/props_combine/headcrabcannister01a.mdl" ) 	
self.Entity:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,  	
self.Entity:SetMoveType( MOVETYPE_VPHYSICS )   --after all, gmod is a physics  	
self.Entity:SetSolid( SOLID_VPHYSICS )        -- Toolbox  
local phys = self.Entity:GetPhysicsObject()  	
if (phys:IsValid()) then  		
phys:Wake() 
phys:SetDragCoefficient( 0 ) 
end 
 
end   

function ENT:SpawnFunction( ply, tr)

	local SpawnPos = tr.HitPos + tr.HitNormal * 100
	
	local ent = ents.Create( "Ejector" )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()
	
	return ent

end

function ENT:Use(act, cal)
if (!self.launched) then

constraint.RemoveConstraints( self.Entity, "Weld")
self.Entity:GetPhysicsObject():EnableMotion( true )

self.launched = true
self.coward = act
act:Spectate( OBS_MODE_CHASE  )
act:SpectateEntity( self.Entity )
act:DrawViewModel(false)
act:DrawWorldModel(false)
act:StripWeapons()

smoke = ents.Create("env_smoketrail")
smoke:SetKeyValue("startsize","30")
smoke:SetKeyValue("endsize","50")
smoke:SetKeyValue("minspeed","2")
smoke:SetKeyValue("maxspeed","4")
smoke:SetKeyValue("startcolor","0 0 0")
smoke:SetKeyValue("endcolor","0 0 0")
smoke:SetKeyValue("spawnrate","10")
smoke:SetKeyValue("lifetime","10")
smoke:SetPos(self.Entity:GetPos())
smoke:SetParent(self.Entity)
smoke:Spawn()

FireTrail = ents.Create("env_fire_trail")
FireTrail:SetKeyValue("spawnrate","3")
FireTrail:SetKeyValue("firesprite","sprites/firetrail.spr" )
FireTrail:SetPos(self.Entity:GetPos())
FireTrail:SetParent(self.Entity)
FireTrail:Spawn()
FireTrail:Activate()
FireTrail:Fire("Kill", "", 2)

self.Fires = true

end

end

function ENT:PhysicsCollide( data )
if (self.launched && self.fuelleft < 1) then

 util.BlastDamage(self.Entity, self.Entity, self.Entity:GetPos(), 100, 100)
 self.coward:UnSpectate()
 self.coward:DrawViewModel(true)
 self.coward:DrawWorldModel(true)
 self.coward:Spawn()
 
 while (self.coward:GetPos() != self.Entity:GetPos()) do
 self.coward:SetPos(self.Entity:GetPos())
 end
 
 brokedshell = ents.Create("prop_physics")
 brokedshell:SetPos(self.Entity:GetPos())
 brokedshell:SetAngles(self.Entity:GetAngles())
 brokedshell:SetKeyValue( "model", "models/props_combine/headcrabcannister01b.mdl" )
 brokedshell:PhysicsInit( SOLID_VPHYSICS )
 brokedshell:SetMoveType( MOVETYPE_VPHYSICS )
 brokedshell:SetSolid( SOLID_VPHYSICS )
 brokedshell:Activate()
 brokedshell:Spawn()
 brokedshell:Fire("Kill", "", 20)
 
local effectdata = EffectData()
effectdata:SetOrigin(self.Entity:GetPos())
effectdata:SetStart(self.Entity:GetPos())
effectdata:SetScale( 1 )
util.Effect( "Explosion", effectdata )
util.Effect( "HelicopterMegaBomb", effectdata )


self.Entity:Remove()
end
end
 
 function ENT:Think()
 
 if (self.launched) then
 
 if ( self.fuelleft > 0 ) then
 
 self.Entity:GetPhysicsObject():ApplyForceCenter( (self.Entity:GetForward()) * 300000 )
 self.fuelleft = self.fuelleft - 1

 end
 
 if not (self.coward == nil) then
 if ( self.coward:KeyDown( IN_ATTACK ) ) then 
 self.fuelleft = 0
 end
 
 if ( self.coward:KeyDown( IN_FORWARD ) ) then 
 self.Entity:GetPhysicsObject():ApplyForceCenter( (self.coward:GetAimVector()) * 6000 )
 end
 
 if ( self.coward:KeyDown( IN_BACKWARD ) ) then 
 self.Entity:GetPhysicsObject():ApplyForceCenter( (self.coward:GetAimVector()) * 6000 )
 end
 end
 end

 
 end
 
 
