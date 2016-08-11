AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )


include('shared.lua')

util.PrecacheSound( "ambient/explosions/explode_1.wav" )
util.PrecacheSound( "ambient/explosions/explode_2.wav" )
util.PrecacheSound( "ambient/explosions/explode_3.wav" )
util.PrecacheSound( "ambient/explosions/explode_4.wav" )


function ENT:Initialize()

self.expl = {}
	self.expl[0] = "ambient/explosions/explode_1.wav"
	self.expl[1] = "ambient/explosions/explode_2.wav"
	self.expl[2] = "ambient/explosions/explode_3.wav"
	self.expl[3] = "ambient/explosions/explode_4.wav"
	
	self.hasdamagecase = true

	
	self.Entity:SetModel( "models/items/boxmrounds.mdl" )
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	local phys = self.Entity:GetPhysicsObject()
	self.NextThink = CurTime() +  1
	if (phys:IsValid()) then
		phys:Wake()
	end
	
	self.val1 = 0
	self.val2 = 0
	RD_AddResource(self.Entity, "Munitions", 1000)
	
	RD_SupplyResource(self.Entity, "Munitions", 1000)
	
end

function ENT:SpawnFunction( ply, tr )

	if ( !tr.Hit ) then return end

	local SpawnPos = tr.HitPos + tr.HitNormal * 16

	local ent = ents.Create( "smcrate" )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()
	return ent
end

function ENT:gcbt_breakactions(damage, pierce)
	util.BlastDamage(self.Entity, self.Entity, self.Entity:GetPos(), self.val1/4, self.val1 / 100)
	
	local effectdata = EffectData()
	effectdata:SetOrigin(self.Entity:GetPos())
	util.Effect( "big_splosion", effectdata )
	
	self.Entity:EmitSound( self.expl[ math.random(0,3) ], 500, 100 )
	
	self.Entity:Remove()
end

function ENT:Touch(act)

if (act:GetClass() == "supply_box") then
act:Remove()
RD_SupplyResource(self.Entity, "Munitions", 500)
end

end

function ENT:Think()
	self:SetOverlayText( "Munitions: " .. self.val1)
	self.val1 = RD_GetResourceAmount(self.Entity, "Munitions")
	self.Entity:NextThink( CurTime() +  1 )
	RD_SupplyResource(self.Entity, "Munitions", 100)
	return true
end


function ENT:PreEntityCopy()
	RD_BuildDupeInfo(self.Entity)
end

function ENT:PostEntityPaste( Player, Ent, CreatedEntities )
	RD_ApplyDupeInfo(Ent, CreatedEntities)
end
