
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('entities/base_wire_entity/init.lua'); 
include('shared.lua')

function ENT:Initialize()   

	math.randomseed(CurTime())
	self.ammo = {}
	self.ammos = 6
	self.armed = false
	self.loading = false
	self.reloadtime = 0
	self.shelltype = 42
	self.infire = false
	self.Entity:SetModel( "models/props_c17/FurnitureWashingMachine001a.mdl" ) 	
	self.Entity:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,  	
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )   --after all, gmod is a physics  	
	self.Entity:SetSolid( SOLID_VPHYSICS )        -- Toolbox     

	self.val1 = 0
	self.val2 = 0
          
	local phys = self.Entity:GetPhysicsObject()  	
	if (phys:IsValid()) then  		
		phys:Wake() 
		phys:SetMass( 3 ) 
	
	end 
 
	self.Inputs = Wire_CreateInputs( self.Entity, { "Launch" } )
	self.Outputs = Wire_CreateOutputs( self.Entity, { "Can Fire" , "Shots Remaining" })
end   

function ENT:SpawnFunction( ply, tr)
	
	if ( !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 60
	
	
	local ent = ents.Create( "TORPEDO_LAUNCHER" )
		ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()
	
	
	
	return ent

end

function ENT:firetorp()

	if (self.ammos > 0) then
	local ent = ents.Create( "torpedo" )
		ent:SetPos( self.Entity:GetPos() +  self.Entity:GetUp() * 50)
		ent:SetAngles( self.Entity:GetAngles() )
		ent:Spawn()
		ent:Activate()
	self.armed = false
	self.reloadtime = CurTime() + 5

	local phys = ent:GetPhysicsObject()  	
	if (phys:IsValid()) then  		
		phys:ApplyForceCenter( self.Entity:GetUp() * 500 ) 
	end 

	local effectdata = EffectData()
		effectdata:SetOrigin(self.Entity:GetPos() +  self.Entity:GetUp() * 50)
		effectdata:SetStart(self.Entity:GetPos() +  self.Entity:GetUp() * 50)
	util.Effect( "Explosion", effectdata )

	end

end

function ENT:Think()

	
	if (self.reloadtime > CurTime()) then
		self.armed = false
		Wire_TriggerOutput(self.Entity, "Can Fire", 0)
	end

	if (self.armed == true) then
			self:firetorp()
	elseif (self.reloadtime < CurTime()) then
		Wire_TriggerOutput(self.Entity, "Can Fire", 1)
		if (self.infire == true) then self.armed = true end
	end
	
end

function ENT:TriggerInput(iname, value)

	if (iname == "Launch") then
		if (value == 1 && self.infire == false) then self.infire = true end
		if (value == 0 && self.infire == true) then self.infire = false end
		self.Entity:NextThink( CurTime() )
		return true
	end

end
 
 
