
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

function ENT:Initialize()   

math.randomseed(CurTime())
self.exploded = false
self.armed = true
self.ticking = true
self.smoking = false
self.flightvector = self.Entity:GetUp() * 270
self.Entity:SetModel( "models/combatmodels/tankshell.mdl" ) 	
self.Entity:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,  	
self.Entity:SetMoveType( MOVETYPE_NONE )   --after all, gmod is a physics  	
self.Entity:SetSolid( SOLID_VPHYSICS )        -- CHEESECAKE!    >:3            

self:Think()
 
end   

function ENT:Think()
	local trace = {}
		trace.start = self.Entity:GetPos()
		trace.endpos = self.Entity:GetPos() + self.flightvector *3
		trace.filter = self.Entity 
	local tr = util.TraceLine( trace )
	
	if (tr.Hit) then
		if ( self.exploded == false ) then
			if ( self.exploded == false && self.ticking == true ) then
				util.BlastDamage(self.Entity, self.Entity, self.Entity:GetPos(), 100, 50)
				if (tr.Entity:IsWorld() || tr.Entity:IsPlayer() || tr.Entity:IsNPC() || tr.HitSky) then
					local effectdata = EffectData()
					effectdata:SetOrigin(self.Entity:GetPos())
					effectdata:SetStart(self.Entity:GetPos())
					util.Effect( "Explosion", effectdata )
					self.exploded = true
					self.Entity:Remove()
					return true
				end
			if (tr.Entity:IsValid()) then
				
					local attack = cbt_dealhcghit( tr.Entity, 200, 400, tr.HitPos , tr.HitPos)
						if (attack == 0) then
						brokedshell = ents.Create("prop_physics")
						brokedshell:SetPos(self.Entity:GetPos())
						brokedshell:SetAngles(self.Entity:GetAngles())
						brokedshell:SetKeyValue( "model", "models/combatmodels/tankshell.mdl" )
						brokedshell:PhysicsInit( SOLID_VPHYSICS )
						brokedshell:SetMoveType( MOVETYPE_VPHYSICS )
						brokedshell:SetSolid( SOLID_VPHYSICS )
						brokedshell:Activate()
						brokedshell:Spawn()
						brokedshell:Fire("Kill", "", 20)
						local phys = brokedshell:GetPhysicsObject()  	
						if (phys:IsValid()) then  
						phys:SetVelocity(self.flightvector * 600000)
						end
						end
				
			end

				self.exploded = true
				self.Entity:Remove()
			end
		end
	end

	self.Entity:SetPos(self.Entity:GetPos() + self.flightvector)
	self.flightvector = self.flightvector + Vector(0,0,-.045)
	self.Entity:SetAngles(self.flightvector:Angle() + Angle(90,0,0))
	self.Entity:NextThink( CurTime() )
	return true
	end
 
 
