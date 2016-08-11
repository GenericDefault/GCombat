
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

function ENT:Initialize()

	self.Entity:SetModel( "models/weapons/w_missile_launch.mdl" )
	self.Entity:SetName("Laser")
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )

	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:EnableGravity(true)
		phys:EnableDrag(true)
		phys:EnableCollisions(true)
	end

    	self.Entity:SetKeyValue("rendercolor", "255 255 255 0")
	self.PhysObj = self.Entity:GetPhysicsObject()
	self.STime = CurTime()
	self.LTime = self.STime + self.ParL.LTime


end

function ENT:PhysicsUpdate()

	if(self.Exploded) then
		self.Entity:Remove()
		return
	end


	if(self.FuelAmount > 0) then
		local vectorMoved = self.Entity:GetPos() - self.LastPosition
		local amountMoved = vectorMoved:Length()
		self.FuelAmount = self.FuelAmount - amountMoved	

		if (self.Locked == true) then
			self.Target = Vector((self.XCo + math.Rand(-50,50)), (self.YCo + math.Rand(-50,50)), (self.ZCo + math.Rand(-50,50)))
			AimVec = ( self.Target - self.LastPosition ):Angle() 
			self.Entity:SetAngles( AimVec )
		end
	
		self.PhysObj:SetVelocity(self.Entity:GetForward()*3100)

		if(self.FuelAmount < 0) then
			local phys = self.Entity:GetPhysicsObject()
			phys:EnableGravity(true)
			phys:EnableDrag(true)
			self.Locked = false
		end

		self.LastPosition = self.Entity:GetPos()
	end
end

function ENT:Think()
	
	if (self.PreLaunch == false) then
		self.PreLaunch = true
		local phys = self.Entity:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:Wake()
			phys:EnableGravity(false)
			phys:EnableDrag(false)
			phys:EnableCollisions(true)
			phys:EnableMotion(true)
		end

		util.SpriteTrail( self.Entity,  //Entity 
 											0,  //iAttachmentID 
 											Color(255,50,255,255),  //Color 
 											true, // bAdditive 
 											30, //fStartWidth 
 											0, //fEndWidth 
 											1, //fLifetime 
 											1, //fTextureRes 
 											"trails/neon.vmt" ) //strTexture          

 
   
		self.PreLaunch = true
	end

	self.XCo = self.ParL.XCo
	self.YCo = self.ParL.YCo
	self.ZCo = self.ParL.ZCo
	
	if (self.ParL.Locked == true) then
		self.Locked = true
	end
	if (CurTime() > self.LTime) then
		self.Locked = true
	end

end

function ENT:PhysicsCollide( data, physobj )

	if(!self.Exploded) then
		local expl=ents.Create("env_explosion")
		
		expl:SetPos(self.Entity:GetPos())
		expl:SetName("Laser")
		expl:SetParent(self.Entity)
		expl:SetOwner(self.Entity:GetOwner())
		expl:SetKeyValue("iMagnitude","150");
		expl:SetKeyValue("iRadiusOverride", 150)
		expl:Spawn()
		expl:Activate()
		expl:Fire("explode", "", 0)
		expl:Fire("kill","",0)
		cbt_nrgexplode( self.Entity:GetPos(), 150, 100, 5)
		self.Exploded = true
	end
end

function ENT:OnTakeDamage( dmginfo )

	--[[if(!self.Exploded) then
		local expl=ents.Create("env_explosion")
		expl:SetPos(self.Entity:GetPos())
		expl:SetName("Missile")
		expl:SetParent(self.Entity)
		expl:SetOwner(self.Entity:GetOwner())
		expl:SetKeyValue("iMagnitude","300");
		expl:SetKeyValue("iRadiusOverride", 250)
		expl:Spawn()
		expl:Activate()
		expl:Fire("explode", "", 0)
		expl:Fire("kill","",0)
		self.Exploded = true
	end]]	
end

function ENT:Use( activator, caller )

end
