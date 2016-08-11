
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

local fuse = 10
local blrad = 100
local blpow = 100

function ENT:Initialize()   

math.randomseed(CurTime())
self.model = "models/Roller.mdl"
self.exploded = false
self.armed = true
self.ticking = true
self.smoking = false
self.damage = 100
self.pierce = 4
self.flightvector = self.Entity:GetUp()
self.Entity:SetModel( "models/Roller.mdl" ) 	
self.Entity:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,  	
self.Entity:SetMoveType( MOVETYPE_VPHYSICS )   --after all, gmod is a physics  	
self.Entity:SetSolid( SOLID_VPHYSICS )        -- Toolbox               
self.Entity:SetColor(0,255,0,255)
local phys = self.Entity:GetPhysicsObject()  	
if (phys:IsValid()) then  		
phys:Wake()  
phys:SetDragCoefficient( 0 )
end 
 
end   

function ENT:setstuff( dmg, prc) 

self.damage = dmg
self.pierce = prc

end

function ENT:OnTakeDamage( dmginfo )
	
	self.Entity:TakePhysicsDamage( dmginfo )
	
end

function ENT:SpawnFunction( ply, tr)

	if ( !tr.Hit ) then return end
	
	local SpawnPos = tr.HitPos + tr.HitNormal * 16
	
	local ent = ents.Create( "HEtankshell" )
		ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()
	
	return ent

end

function ENT:PhysicsCollide( data, physobj )
 if ( self.exploded == false && self.ticking == true ) then
 util.BlastDamage(self.Entity, self.Entity, self.Entity:GetPos(), 300, 100)
 cbt_hcgexplode( self.Entity:GetPos(), 600, 50, 5)
local effectdata = EffectData()
effectdata:SetOrigin(self.Entity:GetPos())
effectdata:SetStart(self.Entity:GetPos())
util.Effect( "Explosion", effectdata )
 self.exploded = true
 self.Entity:Remove()
 return true
 end
end

 function ENT:Think()
if (self.smoking == false) then
self.smoking = true

FireTrail = ents.Create("env_fire_trail")
FireTrail:SetKeyValue("spawnrate","3")
FireTrail:SetKeyValue("firesprite","sprites/firetrail.spr" )
FireTrail:SetPos(self.Entity:GetPos())
FireTrail:SetParent(self.Entity)
FireTrail:Spawn()
FireTrail:Activate()

end 
self.Entity:NextThink( CurTime() + 0.1 )
return true
end
 
 
