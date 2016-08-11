
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

function ENT:Initialize()   

self.smoking = false
self.exploded = false
self.armed = true

self.flightvector = self.Entity:GetUp() * 200
self.Entity:SetModel( "models/combatmodels/tankshell.mdl" )
self.Entity:SetGravity( 0.5 ) 	
self.Entity:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,  	
self.Entity:SetMoveType( MOVETYPE_NONE )   --after all, gmod is a physics  	
self.Entity:SetSolid( SOLID_VPHYSICS )        -- CHEESECAKE!    >:3           
self.Entity:SetColor(255,255,0,255)
 
end   

 function ENT:Think()
	
 	if (self.smoking == false) then
		self.smoking = true
	
		FireTrail = ents.Create("env_spritetrail")
		FireTrail:SetKeyValue("lifetime","0")
		FireTrail:SetKeyValue("startwidth","0")
		FireTrail:SetKeyValue("endwidth","0")
		FireTrail:SetKeyValue("spritename","trails/smoke.vmt")
		FireTrail:SetKeyValue("rendermode","5")
		FireTrail:SetKeyValue("rendercolor","0 0 0")
		FireTrail:SetPos(self.Entity:GetPos())
		FireTrail:SetParent(self.Entity)
		FireTrail:Spawn()
		FireTrail:Activate()
	end 
 
	local trace = {}
		trace.start = self.Entity:GetPos()
		trace.endpos = self.Entity:GetPos() + self.flightvector * 1.2
		trace.filter = self.Entity 
	local tr = util.TraceLine( trace )
	
	
	if tr.Hit then
		util.BlastDamage(self.Entity, self.Entity, self.Entity:GetPos(), 250, 200)
			local effectdata = EffectData()
					effectdata:SetOrigin(self.Entity:GetPos())		
					effectdata:SetStart(self.Entity:GetPos())
					util.Effect( "!big_splosion", effectdata )
					
			if (tr.Entity:IsPlayer() || tr.Entity:IsNPC() || tr.HitSky) then
			self.Entity:Remove()
			return true
			end
			
			local attack = gcombat.hcgexplode( self.Entity:GetPos(), 300, 200, 7)
			self.Entity:Remove()
		
	end
	
	self.Entity:SetPos(self.Entity:GetPos() + self.flightvector)
	self.flightvector = self.flightvector + Vector(0,0,-0.15)
	self.Entity:SetAngles(self.flightvector:Angle() + Angle(90,0,0))
	self.Entity:NextThink( CurTime() )
	return true
end
 
 
