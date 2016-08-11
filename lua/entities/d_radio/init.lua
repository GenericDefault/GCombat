
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
self.target = nil
self.Entity:SetModel( "models/Items/BoxMRounds.mdl" ) 	
self.Entity:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,  	
self.Entity:SetMoveType( MOVETYPE_VPHYSICS )   --after all, gmod is a physics  	
self.Entity:SetSolid( SOLID_VPHYSICS )        -- Toolbox               
local phys = self.Entity:GetPhysicsObject()  	
if (phys:IsValid()) then  		
phys:Wake()  	
end 
 
end   

function ENT:OnTakeDamage( dmg)
 local pos = self.Entity:GetPos()
 local trace = {}
 trace.start = self.Entity:GetPos() + Vector(0,0,4000)
 trace.endpos = self.Entity:GetPos() + Vector(math.Rand(-10000,10000),math.Rand(-10000,10000),4000)
 trace.filter = self.Entity 
 local tr = util.TraceLine( trace ) 
	if (tr.Hit) then
		local trg = ents.Create( "bombar" )
		local pnormal = Vector((trace.endpos.x - pos.x) * -1, (trace.endpos.y - pos.y) * -1, 0)
		trg:SetPos( tr.HitPos + tr.HitNormal * 1000)
		trg:SetAngles( pnormal:Angle() )
		trg:Spawn()
		trg.dst = self.Entity:GetPos()
		trg.payload = "torpedo"
	end
end


function ENT:SpawnFunction( ply, tr)
if ( !tr.Hit ) then return end

	local SpawnPos = tr.HitPos + tr.HitNormal * 16

	local ent = ents.Create( "d_beacon" )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()
	return ent
end

 
 
