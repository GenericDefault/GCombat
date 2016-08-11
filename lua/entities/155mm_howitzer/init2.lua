
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('entities/base_wire_entity/init.lua'); 
include('shared.lua')

util.PrecacheSound("arty/artyfire.wav")

function ENT:Initialize()   
	
	math.randomseed(CurTime())
	self.ammomodel = "models/props_c17/canister01a.mdl"
	self.ammos = 6
	self.armed = false
	self.loading = false
	self.reloadtime = 0
	self.shelltype = 42
	self.infire = false
	self.Entity:SetModel( "models/combatmodels/tank_gun.mdl" ) 	
	self.Entity:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,  	
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )   --after all, gmod is a physics  	
	self.Entity:SetSolid( SOLID_VPHYSICS )        -- Toolbox     

	
	self.val1 = 0
	self.val2 = 0
	--RD_AddResource(self.Entity, "Munitions", 0)
          
	local phys = self.Entity:GetPhysicsObject()  	
	if (phys:IsValid()) then  		
		phys:Wake() 
		phys:SetMass( 3 ) 
	end 
 
	self.Inputs = Wire_CreateInputs( self.Entity, { "Fire Artillery AP" , "Fire Artillery HE" } )
	self.Outputs = Wire_CreateOutputs( self.Entity, { "AP Ready" , "HE Ready" , "Shots Remaining" })
end   

function ENT:SpawnFunction( ply, tr)
	
	if ( !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 60
	
	
	local ent = ents.Create( "155mm_howitzer" )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()
	
	
	
	return ent

end

function ENT:fireAPshell()
	
	if (self.ammos > 0) then
		local ent = ents.Create( "artyapshell" )
		ent:SetPos( self.Entity:GetPos() +  self.Entity:GetUp() * 60)
		ent:SetAngles( self.Entity:GetAngles() )
		ent:Spawn()
		ent:Activate()
		self.armed = false
		self.reloadtime = CurTime() + 10
		
		local phys = self.Entity:GetPhysicsObject()  	
		if (phys:IsValid()) then  		
			phys:ApplyForceCenter( self.Entity:GetUp() * -12000 ) 
		end 
		
		local effectdata = EffectData()
		effectdata:SetOrigin(self.Entity:GetPos() +  self.Entity:GetUp() * 50)
		effectdata:SetStart(self.Entity:GetPos() +  self.Entity:GetUp() * 50)
		util.Effect( "artyfire", effectdata )
		self.Entity:EmitSound( "arty/artyfire.wav", 500, 100 )
		
	end
	
end

function ENT:fireHEshell()

	if (self.ammos > 0) then
		local ent = ents.Create( "artyshell" )
		ent:SetPos( self.Entity:GetPos() +  self.Entity:GetUp() * 60)
		ent:SetAngles( self.Entity:GetAngles() )
		ent:Spawn()
		ent:Activate()
		self.armed = false
		self.reloadtime = CurTime() + 15
		
		local phys = self.Entity:GetPhysicsObject()  	
		if (phys:IsValid()) then  		
			phys:ApplyForceCenter( self.Entity:GetUp() * -12000 ) 
		end 
		
		local effectdata = EffectData()
		effectdata:SetOrigin(self.Entity:GetPos() +  self.Entity:GetUp() * 50)
		effectdata:SetStart(self.Entity:GetPos() +  self.Entity:GetUp() * 50)
		util.Effect( "artyfire", effectdata )
		self.Entity:EmitSound( "arty/artyfire.wav", 500, 100 )
	end

end

function ENT:Think()
	
	local ammo = 500 --RD_GetResourceAmount(self, "Munitions")
	-local remain = math.Round(ammo / 500)
	Wire_TriggerOutput(self.Entity, "Shots Remaining", remain)
	
	if (self.reloadtime > CurTime()) then
		self.armed = false
		Wire_TriggerOutput(self.Entity, "AP Ready", 0)
		Wire_TriggerOutput(self.Entity, "HE Ready", 0)
	end
	
	if (self.armed == true) then
		if (ammo >= 500) then
			if (self.shelltype == 1) then
				self:fireAPshell()
			else
				self:fireHEshell()
			end
			--RD_ConsumeResource(self, "Munitions", 500)
		end
	elseif (self.reloadtime < CurTime()) then
		Wire_TriggerOutput(self.Entity, "AP Ready", 1)
		Wire_TriggerOutput(self.Entity, "HE Ready", 1)
		if (self.infire == true) then self.armed = true end
	end

end

function ENT:TriggerInput(iname, value)

	if (iname == "Fire Artillery AP") then
		if (value == 1 && self.infire == false) then self.infire = true end
		if (value == 0 && self.infire == true) then self.infire = false end
		self.shelltype = 1
		self.Entity:NextThink( CurTime() )
		return true
	end

	if (iname == "Fire Artillery HE") then
		if (value == 1 && self.infire == false) then self.infire = true end
		if (value == 0 && self.infire == true) then self.infire = false end
		self.Entity:NextThink( CurTime() )
		self.shelltype = 2
		return true
	end
end
 
 
