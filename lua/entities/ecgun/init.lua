
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('entities/base_wire_entity/init.lua'); 
include('shared.lua')

function ENT:Initialize()   
	
	self.ammos = 6
	self.armed = false
	self.loading = false
	self.reloadtime = 0
	self.shelltype = 42
	self.infire = false
	self.distance = 100000
	self.Entity:SetModel( "models/combatmodels/tank_gun.mdl" ) 	
	self.Entity:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,  	
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )   --after all, gmod is a physics  	
	self.Entity:SetSolid( SOLID_VPHYSICS )        -- Toolbox     
	self.Entity:SetColor(100,40,255,255)
	dofire = 0
	
	self.val1 = 0
	self.val2 = 0
	RD_AddResource(self.Entity, "Munitions", 0)
	RD_AddResource(self.Entity, "energy", 0)
          
	local phys = self.Entity:GetPhysicsObject()  	
	if (phys:IsValid()) then  		
	phys:Wake() 
	phys:SetMass( 3 ) 
	end 
	
	self.Inputs = Wire_CreateInputs( self.Entity, { "Fire" } )
	self.Outputs = Wire_CreateOutputs( self.Entity, { "Can Fire" , "Shots Remaining" })
end   

function ENT:SpawnFunction( ply, tr)
	
	if ( !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 60
	
	
	local ent = ents.Create( "ecgun" )
		ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()
	
	
	
	return ent

end

function ENT:fireAPshell()

	if (self.ammos > 0) then
	
		local pos = self.Entity:GetPos()
				
		local trace = {}
		trace.start = self.Entity:GetPos() + self.Entity:GetUp() * 50
		trace.endpos = self.Entity:GetPos() + (self.Entity:GetUp() * self.distance + Vector( math.random( -200, 200 ), math.random( -200, 200 ), math.random( -200, 200 )))
		trace.filter = self.Entity 
		local tr = util.TraceLine( trace )
		
		if (tr.Hit && tr.Entity:IsValid()) then
			if ( !tr.Entity:IsWorld() || !tr.Entity:IsPlayer() || !tr.Entity:IsNPC() || !tr.Entity:IsVehicle()) then
				local attack = cbt_dealhcghit( tr.Entity, 12, tr.HitNormal:Dot(self.Entity:GetUp() * -1) * 12, tr.HitPos, 		tr.HitPos)
				if (attack == 0) then
					brokedshell = ents.Create("prop_physics")
					brokedshell:SetPos(tr.HitPos + tr.HitNormal*16)
					brokedshell:SetAngles(self.Entity:GetAngles())
					brokedshell:SetKeyValue( "model", "models/combatmodels/tankshell.mdl" )
					brokedshell:PhysicsInit( SOLID_VPHYSICS )
					brokedshell:SetMoveType( MOVETYPE_VPHYSICS )
					brokedshell:SetSolid( SOLID_VPHYSICS )
					brokedshell:Activate()
					brokedshell:Spawn()
					brokedshell:Fire("Kill", "", 20)
					brokedshell:SetColor(0,0,0,255)
					local phys = brokedshell:GetPhysicsObject()  	
					if (phys:IsValid()) then  
						phys:SetVelocity( self.Entity:GetUp() * 10000)
					end
				end
			end
		end
	
		util.BlastDamage(self.Entity, self.Entity, tr.HitPos, 200, 50)
		
		gcombat.hcgexplode( tr.HitPos, 25, 6, 2)
		gcombat.nrgexplode( tr.HitPos, 50, 12, 5)
		
		self.reloadtime = CurTime() + 0.05
		
		local effectdata = EffectData()
		effectdata:SetOrigin(tr.HitPos)
		effectdata:SetStart(self.Entity:GetPos() +  self.Entity:GetUp() * 50)
		util.Effect( "ecgbeam", effectdata )
	
	end

end

function ENT:Think()

	local ammo1 = RD_GetResourceAmount(self, "Munitions")
	local ammo2 = RD_GetResourceAmount(self, "energy")
	local remain = math.Round((ammo1 + ammo2) / 60)
	Wire_TriggerOutput(self.Entity, "Shots Remaining", remain)
	
	if (self.reloadtime > CurTime()) then
		self.armed = false
		Wire_TriggerOutput(self.Entity, "Can Fire", 0)
	end
	
	if (self.armed == true) then
		if (ammo1 >= 8 && ammo2 >= 52) then
			if (self.shelltype == 1) then
				if (dofire == 1) then
					self:fireAPshell()
				else return end
				RD_ConsumeResource(self, "Munitions", 8)
				RD_ConsumeResource(self, "energy", 52)				
			end
		end
	elseif (self.reloadtime < CurTime()) then
		Wire_TriggerOutput(self.Entity, "Can Fire", 1)
		if (self.infire == true) then self.armed = true end
	end

end

function ENT:TriggerInput(iname, value)

	if (iname == "Fire") then
		if (value == 1 && self.infire == false) then self.infire = true end
		if (value == 1 && dofire == 0) then dofire = 1 end
		if (value == 0 && self.infire == true) then self.infire = false end
		if (value == 0 && dofire == 1) then dofire = 0 end
		self.shelltype = 1
		self.Entity:NextThink( CurTime() + 0.01 )
		return true
	end
	
end
 
 
