--50 cal mk3 Gconbat rc 3 rework I have removed the old gcombat system used by paradukes and instaled the default hollow chage hit -LightDemon
--This file was created by paradukes he gets all the design credit i just removed some broken code and set it up to run off muntions  -LightDemon  <OLD>
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

function ENT:Initialize()
	self.Entity:SetModel( "models/weapons/w_rocket_launcher.mdl" ) 	
	--self.Entity:SetModel( "models/gibs/gunship_gibs_nosegun.mdl" ) 
	self.Entity:SetName("GAU-12")
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

	
	
end

function ENT:SpawnFunction( ply, tr )

	if ( !tr.Hit ) then return end
	
	local SpawnPos = tr.HitPos + tr.HitNormal * 16
	
	local ent = ents.Create( "gau12" )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()
	ent.SPL = ply
	
	return ent
	
end

function ENT:TriggerInput(key, value)
	if (key == "Fire") then
		if (value > 0) then
			self.Firing = true
		else
			self.Firing = false
		end 

	end
end

function ENT:PhysicsUpdate()

end

function ENT:Think()
	if FIELDS == nil and COMBATDAMAGEENGINE == nil then return end 		
	

	if (self.Firing == true ) then
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
			local  gdmg = math.random(5,52)
		local attack = cbt_dealhcghit( tr.Entity, gdmg, 5000, tr.HitPos, tr.HitPos)
		end
		
		local Position = vStart - tr.HitPos
		Position = Position:Normalize()
		local Bullet = {}
		Bullet.Num = 1
		Bullet.Src = self.Entity:GetPos() + (self.Entity:GetForward() * 20)
		Bullet.Dir = Position * -1
		Bullet.Spread = Vector( 0, 0, 0 )
		Bullet.Tracer = 3
		Bullet.Force = 100
		Bullet.TracerName = "Tracer"
		Bullet.Attacker = self.SPL
		Bullet.Damage = 75

		
		self.Entity:FireBullets(Bullet)
		local effectdata = EffectData()
			effectdata:SetOrigin( self.Entity:GetPos() )
			effectdata:SetAngle( Angle( 0,90,0 ) )
		util.Effect( "particles/smokey", effectdata )
		
		self.Entity:EmitSound("arty/gau.wav")
	end

	self.Entity:NextThink( CurTime() + .01 ) 
	return true
end

function ENT:PhysicsCollide( data, physobj )
	
end

function ENT:OnTakeDamage( dmginfo )
	
end

function ENT:Use( activator, caller )

end

 function PrintMessage( message )
   Msg( message .. "\n" )
  end 