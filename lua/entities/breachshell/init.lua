
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

function ENT:Initialize()   

self.smoking = false
self.exploded = false
self.armed = true

self.flightvector = self.Entity:GetUp() * 175
self.Entity:SetModel( "models/combatmodels/tankshell.mdl" )
self.Entity:SetGravity( 0.5 ) 	
self.Entity:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,  	
self.Entity:SetMoveType( MOVETYPE_NONE )   --after all, gmod is a physics  	
self.Entity:SetSolid( SOLID_VPHYSICS )        -- CHEESECAKE!    >:3           
self.Entity:SetColor(255,255,0,255)
self.nerf = 350
 
end   

 function ENT:Think()
	
 	if (self.smoking == false) then
		self.smoking = true
	
		FireTrail = ents.Create("env_spritetrail")
		FireTrail:SetKeyValue("lifetime","5")
		FireTrail:SetKeyValue("startwidth","15")
		FireTrail:SetKeyValue("endwidth","0.1")
		FireTrail:SetKeyValue("spritename","trails/plasma.vmt")
		FireTrail:SetKeyValue("rendermode","5")
		FireTrail:SetKeyValue("rendercolor","255 50 255")
		FireTrail:SetPos(self.Entity:GetPos())
		FireTrail:SetParent(self.Entity)
		FireTrail:Spawn()
		FireTrail:Activate()
	end 
 
	local trace = {}
		trace.start = self.Entity:GetPos()
		trace.endpos = self.Entity:GetPos() + self.flightvector * 2.5 
		trace.filter = self.Entity 
	local tr = util.TraceLine( trace )
	
	if (tr.Hit && !tr.HitSky) then
		if ( self.exploded == false ) then
			util.BlastDamage(self.Entity, self.Entity, self.Entity:GetPos(), 2048, 500)
			gcombat.hcgexplode( self.Entity:GetPos(), 2048, self.nerf, 10)
			
			local effectdata = EffectData()
			effectdata:SetOrigin(self.Entity:GetPos())
			effectdata:SetStart(self.Entity:GetPos())
			util.Effect( "breachsplode", effectdata )
			self.exploded = true
			self.Entity:Remove()
			return true
		end
		
		//gcombat.hcgexplode( position, radius, damage, pierce)		
				
		local attack = gcombat.hcgexplode( self.Entity:GetPos(), 2048, self.nerf, 10)
				
				if (attack <= 4) then
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
				elseif (attack >= 5) then
					gcombat.hcgexplode( self.Entity:GetPos(), 2048, self.nerf, 10)
					util.BlastDamage(self.Entity, self.Entity, self.Entity:GetPos(), 2048, 500)
					
					local effectdata = EffectData()
					effectdata:SetOrigin(self.Entity:GetPos())
					effectdata:SetStart(self.Entity:GetPos())
					util.Effect( "breachsplode", effectdata )
				end
					local phys = brokedshell:GetPhysicsObject()  	
					if (phys:IsValid()) then  
						phys:SetVelocity(self.flightvector * 10000)
					end
				
		
	end
	self.Entity:SetPos(self.Entity:GetPos() + self.flightvector)
	self.flightvector = self.flightvector + Vector(0,0,-1)
	self.Entity:SetAngles(self.flightvector:Angle() + Angle(90,0,0))
	self.Entity:NextThink( CurTime() )
	return true
end
 
 
