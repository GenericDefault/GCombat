
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')


/*---------------------------------------------------------
   Name: Initialize
---------------------------------------------------------*/
function ENT:Initialize()

	self.Entity:SetModel( "models/combatmodels/tank_gun.mdl" )
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	
	self.Entity:DrawShadow( false )
	self.Entity:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	
	util.PrecacheSound("ambient/explosions/explode_5.wav")
	
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:SetMass( 1 )
	end
	
	self.Firing 	= false
	self.NextShot 	= 0
	self.Delay 	= 6
	self.val1 = 0
	self.val2 = 0
	LS_RegisterEnt( self.Entity )
	
end

/*---------------------------------------------------------
	Here are some accessor functions for the different
	things you can change!
---------------------------------------------------------*/

// Damage

function ENT:SetPower( f )
	self.Power = f
end

function ENT:GetPower()
	return self.Power
end

function ENT:SetOn( b )
	self.Firing=b
end

function ENT:GetOn()
	return self.Firing
end


/*---------------------------------------------------------
	Name: FireShot

	Fire a bullet.
---------------------------------------------------------*/

function ENT:FireShot()

	if ( self.NextShot > CurTime() ) then return end
	
	self.NextShot = CurTime() + self.Delay
	

	self.Entity:EmitSound( "ambient/explosions/explode_5.wav", 100, 100 )
	
	local pos = self.Entity:GetPos()
	
	// Get the shot angles and stuff.
	local shootOrigin = (pos + (self.Entity:GetForward() *10))
	local shootVector = (self.Entity:GetForward() * 20000)
	
	local cball = ents.Create( "prop_physics" )
	cball:SetPos( shootOrigin )
	cball:SetAngles( self.Entity:GetAngles())
	cball:Activate()
	cball:Spawn()
	local phyz = cball:GetPhysicsObject()
	if (phyz:IsValid()) then
	
	phyz:Wake()
	phyz:ApplyForceCenter( shootVector )
	
	end
	
	// Make a muzzle flash
	local effectdata = EffectData()
		effectdata:SetOrigin( shootOrigin )
		effectdata:SetAngle( shootVector:Angle() )
		effectdata:SetScale( 10 )
	util.Effect( "MuzzleEffect", effectdata )
	
end

/*---------------------------------------------------------
   Name: OnTakeDamage
---------------------------------------------------------*/
function ENT:OnTakeDamage( dmginfo )
	self.Entity:TakePhysicsDamage( dmginfo )
end

/*---------------------------------------------------------
   Numpad control functions
   These are layed out like this so it'll all get saved properly
---------------------------------------------------------*/

local function On( pl, ent )
	if ( !ent || ent == NULL ) then return end
	local etab = ent:GetTable()
	
		etab:SetOn(true)
	
end

local function Off( pl, ent )

	if ( !ent || ent == NULL ) then return end
	local etab = ent:GetTable()
	
	
	etab:SetOn(false)
	
end

function ENT:Think()

	if( self.Firing ) then
		self:FireShot()
	end
	
	// Note: If you're overriding the next think time you need to return true
	self.Entity:NextThink(CurTime() + self.Delay / 4)
	return true
	
end

numpad.Register( "Cannon_On", 	On )
numpad.Register( "Cannon_Off", Off )