
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

function ENT:Initialize()   

math.randomseed(CurTime())
self.model = "models/Roller.mdl"
self.exploded = false
self.armed = false
self.ticking = false
self.fuseleft = 0
self.hasdamagecase = true
self.target = nil
self.payload = self.payload or "supply_box" 
self.Entity:SetModel( "models/combatmodels/bomber_cheap.mdl" ) 	
self.Entity:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,  	
self.Entity:SetMoveType( MOVETYPE_VPHYSICS )   --after all, gmod is a physics  	
self.Entity:SetSolid( SOLID_VPHYSICS )        -- Toolbox       
self.Entity:SetCollisionGroup( 0 )
self.dst = self.dst or Vector(0,0,0)        

self.targ = ents.Create( "gmod_wire_locator" )
self.targ:SetPos( self.Entity:GetPos() + Vector(0,0,20))
self.targ:SetAngles( self.Entity:GetAngles() )
self.targ:Spawn()
self.targ:SetParent(self.Entity)

local phys = self.Entity:GetPhysicsObject()  	
if (phys:IsValid()) then  		
phys:Wake()	
phys:SetMass( 3000 )
end 
 
end   

function ENT:SpawnFunction( ply, tr)

	return false

end

function ENT:gcbt_breakactions(damage, pierce)
self.hasdamagecase = false
self.exploded = true
self.targ:Remove()
end

function ENT:PhysicsCollide( data, physobj )

if (self.exploded == true) then
util.BlastDamage(self.Entity, self.Entity, self.Entity:GetPos(), 500, 100)
cbt_hcgexplode( self.Entity:GetPos(), 500, 25, 2)

local effectdata = EffectData()
effectdata:SetOrigin(self.Entity:GetPos())
util.Effect( "artillery_exp", effectdata )

self.Entity:EmitSound( self.expl[ math.random(0,3) ], 500, 100 )

self.exploded = true


end
self.Entity:Remove()
end

function ENT:Think()
local pos = self.Entity:GetPos()
if (self.exploded == false) then
local phys = self.Entity:GetPhysicsObject()  	
if (phys:IsValid()) then  		
phys:SetVelocity(self.Entity:GetForward() * 1000) 	
end 
end

if (math.abs(pos.x - self.dst.x) < 1000 && math.abs(pos.y - self.dst.y) < 1000 && CurTime() > self.fuseleft) then
self.fuseleft = CurTime() + 0.5
local trg = ents.Create( self.payload )
trg:SetPos( self.Entity:GetPos() + self.Entity:GetUp() * -80)

if (self.payload == "torpedo") then
	trg:SetAngles( self.Entity:GetAngles() + Angle(90,0,0) )
else
	trg:SetAngles( self.Entity:GetAngles() )
end
trg:Spawn()
end

self.Entity:NextThink(CurTime())
return true
end
 
