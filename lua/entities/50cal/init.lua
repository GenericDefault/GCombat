--This file was created by paradukes he gets all the design credit i just removed some broken code and set it up to run off muntions -LightDemon
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

function ENT:Initialize()
	self.Entity:SetModel( "models/weapons/W_BHM_1960_M-60.mdl" ) 	
	--self.Entity:SetModel( "models/gibs/gunship_gibs_nosegun.mdl" ) 
	self.Entity:SetName("50. Cal Badass")
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	self.Entity:SetMaterial("models/props_combine/combinethumper002");
	self.Inputs = Wire_CreateInputs( self.Entity, { "Fire"} )

	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:EnableGravity(true)
		phys:EnableDrag(true)
		phys:EnableCollisions(true)
	end

	self.Entity:SetKeyValue("rendercolor", "255 255 255")
	self.PhysObj = self.Entity:GetPhysicsObject()

	self.val1 = 0
end

function ENT:SpawnFunction( ply, tr )

	if ( !tr.Hit ) then return end
	
	local SpawnPos = tr.HitPos + tr.HitNormal * 16
	
	local ent = ents.Create( "50cal" )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()
	ent.SPL = ply
	
	return ent
	
end

function ENT:TriggerInput(iname, value)
	if (iname == "Fire") then
		if (value > 0) then
			self.Firing = true
		else
			self.Firing = false
		end

	elseif (iname == "EjectClip" ) then
		if (value > 0) then
			if (self.Clip != nil && self.Clip:IsValid()) then
				if (self.Clip.AWeld:IsValid()) then
					self.Clip.AWeld:Remove()	
				end
				local Physy = self.Clip:GetPhysicsObject()
				if (Physy:IsValid()) then
					Physy:EnableCollisions(true)
				end
				Dev_Unlink(self.Entity, self.Clip)
				self.Clip:GetPhysicsObject():ApplyForceCenter( self.Clip.Entity:GetUp() * 3000 + Vector( math.random( -200, 200 ), math.random( -200, 200 ), math.random( -200, 200 ) ) )
				self.Entity:EmitSound("weapons/physcannon/superphys_launch1.wav")
			end
			self.Clip = nil
		end

	end
end

function ENT:PhysicsUpdate()

end

function ENT:Think()
	local ccons = 0

			
	if (self.Firing == true && self.val1 >= 1) then
		local trace = {}
		local vStart = self.Entity:GetPos()
		local vForward = self.Entity:GetForward()
		trace.start = vStart
		trace.endpos = vStart + (vForward * 20000 + Vector( math.random( -200, 200 ), math.random( -200, 200 ), math.random( -200, 200 ) ) )
		trace.filter = self.Entity
		local tr = util.TraceLine( trace ) 
		local CAVec = tr.HitPos
		local TAng = vStart - CAVec
		
		if ( tr.Entity and tr.Entity:IsValid() ) then
			local  gdmg = math.random(15,25)
			attack = cbt_dealdevhit(tr.Entity, gdmg, 5)
			if (attack != nil) then
				if (attack == 2) then
					local wreck = ents.Create( "wreckedstuff" )
					wreck:SetModel( tr.Entity:GetModel() )
					wreck:SetAngles( tr.Entity:GetAngles() )
					wreck:SetPos( tr.Entity:GetPos() )
					wreck:Spawn()
					wreck:Activate()
					tr.Entity:Remove()
					local effectdata1 = EffectData()
					effectdata1:SetOrigin(tr.Entity:GetPos())
					effectdata1:SetStart(tr.Entity:GetPos())
					effectdata1:SetScale( 10 )
					effectdata1:SetRadius( 100 )
					util.Effect( "Explosion", effectdata1 )
				end
			end
		end
		
		local Position = vStart - tr.HitPos
		Position = Position:Normalize()
		local Bullet = {}
		Bullet.Num = 1
		Bullet.Src = self.Entity:GetPos() + (self.Entity:GetForward() * 20)
		Bullet.Dir = Position * -1
		Bullet.Spread = Vector( 0, 0, 0 )
		Bullet.Tracer = 1
		Bullet.Force = 10
		Bullet.TracerName = "Tracer"
		Bullet.Attacker = self.SPL
		Bullet.Damage = 10

		
		self.Entity:FireBullets(Bullet)
		local effectdata = EffectData()
			effectdata:SetOrigin( self.Entity:GetPos() )
			effectdata:SetAngle( Angle( 0,90,0 ) )
		util.Effect( "RifleShellEject", effectdata )
		

		self.Entity:EmitSound("Weapon_AR2.Single")
		
		if (self.Clip != nil && self.Clip:IsValid()) then
			local ClAmmo = RD_GetResourceAmount(self.Entity, "Munitions")
			if (ClAmmo <= 0) then
				if (self.Clip.AWeld:IsValid()) then
					self.Clip.AWeld:Remove()	
				end
				local Physy = self.Clip:GetPhysicsObject()
				if (Physy:IsValid()) then
					Physy:EnableCollisions(true)
				end
				Dev_Unlink(self.Entity, self.Clip)
				self.Clip:GetPhysicsObject():ApplyForceCenter( self.Clip.Entity:GetUp() * 3000 + Vector( math.random( -200, 200 ), math.random( -200, 200 ), math.random( -200, 200 ) ) )
				self.Entity:EmitSound("weapons/physcannon/superphys_launch1.wav")
				local ANoc = constraint.NoCollide(self.Entity, self.Clip.Entity, 0, 0)
				self.Clip = nil
			end
		end
	end
	self.Entity:NextThink( CurTime() + 0.13 ) 
	return true
end

function ENT:PhysicsCollide( data, physobj )
	
end

function ENT:OnTakeDamage( dmginfo )
	
end

function ENT:Use( activator, caller )

end

function ENT:Touch( activator )
		
	if (activator.FiveOhCalClip == true && activator.AWeld == nil && self.Clip == nil) then
		if (activator.val1 <= 0) then 
			return 
		end
		local NClip = activator
		local NSAng = self.Entity:GetAngles()
		NClip:SetAngles( NSAng )
		NClip:SetPos( self.Entity:GetPos() )
		NClip.AWeld = constraint.Weld(self.Entity, NClip.Entity, 0, 0, 0)
		--NClip.ANoc = constraint.NoCollide(self.Entity, NClip.Entity, 0, 0)
		local phys = NClip:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:EnableCollisions(false)
		end
		Dev_Link(self.Entity, NClip)
		self.Clip = NClip
	end
	
end

function ENT:gcbt_breakactions(damage, pierce)
	local wreck = ents.Create( "wreckedstuff" )
	wreck:SetModel( self.Entity:GetModel() )
	wreck:SetAngles( self.Entity:GetAngles() )
	wreck:SetPos( self.Entity:GetPos() )
	wreck:Spawn()
	wreck:Activate()
	self.Entity:Remove()
	local effectdata1 = EffectData()
	effectdata1:SetOrigin(self.Entity:GetPos())
	effectdata1:SetStart(self.Entity:GetPos())
	effectdata1:SetScale( 10 )
	effectdata1:SetRadius( 100 )
	util.Effect( "Explosion", effectdata1 )
end
