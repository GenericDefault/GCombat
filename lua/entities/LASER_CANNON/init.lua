
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

local fuse = 10
local blrad = 100
local blpow = 100
local stickradius = 100
local pi = 3.1415926535897932384626433832795

function ENT:Initialize()   

math.randomseed(CurTime())
self.ammomodel = "models/props_c17/canister01a.mdl"
self.ammo = {}
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
	RD_AddResource(self.Entity, "Munitions", 100)
          
local phys = self.Entity:GetPhysicsObject()  	
if (phys:IsValid()) then  		
phys:Wake() 
phys:SetMass( 3 ) 
end 
 
self.Inputs = Wire_CreateInputs( self.Entity, { "Fire laser" , "Fire HE round" } )
self.Outputs = Wire_CreateOutputs( self.Entity, { "Can Fire" , "Shots Remaining" })
end   

function ENT:SpawnFunction( ply, tr)
	
	if ( !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 60
	
	
	local ent = ents.Create( "LASER_CANNON" )
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
 trace.endpos = self.Entity:GetPos() + self.Entity:GetUp() * 10000
 trace.filter = self.Entity 
 local tr = util.TraceLine( trace ) 

 if (tr.Hit && tr.Entity:IsValid()) then
 if ( !tr.Entity:IsWorld() || !tr.Entity:IsPlayer() || !tr.Entity:IsNPC() || !tr.Entity:IsVehicle()) then
 local attack = cbt_dealnrghit( tr.Entity, 10, 6, tr.HitPos, tr.HitPos)
 end
 end
 
self.reloadtime = CurTime() + 0.3

local effectdata = EffectData()
effectdata:SetOrigin(tr.HitPos)
effectdata:SetStart(self.Entity:GetPos() +  self.Entity:GetUp() * 50)
util.Effect( "LaserTracer", effectdata )

end

end

function ENT:fireHEshell()

if (self.ammos > 0) then
local ent = ents.Create( "HEtankshell" )
	ent:SetPos( self.Entity:GetPos() +  self.Entity:GetUp() * 50)
	ent:SetAngles( self.Entity:GetAngles() )
ent:Spawn()
ent:Activate()
self.armed = false
self.reloadtime = CurTime() + 10

local phys = self.Entity:GetPhysicsObject()  	
if (phys:IsValid()) then  		
phys:ApplyForceCenter( self.Entity:GetUp() * -2000 ) 
end 

local effectdata = EffectData()
effectdata:SetOrigin(self.Entity:GetPos() +  self.Entity:GetUp() * 50)
effectdata:SetStart(self.Entity:GetPos() +  self.Entity:GetUp() * 50)
util.Effect( "Explosion", effectdata )

end

end

function ENT:Think()

local ammo = RD_GetResourceAmount(self, "Munitions")
local remain = math.Round(ammo / 100)
Wire_TriggerOutput(self.Entity, "Shots Remaining", remain)

if (self.reloadtime > CurTime()) then
self.armed = false
Wire_TriggerOutput(self.Entity, "Can Fire", 0)
end

if (self.armed == true) then
if (ammo >= 100) then
if (self.shelltype == 1) then
self:fireAPshell()
else
self:fireHEshell()
end
RD_ConsumeResource(self, "Munitions", 100)
end
elseif (self.reloadtime < CurTime()) then
Wire_TriggerOutput(self.Entity, "Can Fire", 1)
if (self.infire == true) then self.armed = true end
end

end

function ENT:TriggerInput(iname, value)

if (iname == "Fire laser") then
if (value == 1 && self.infire == false) then self.infire = true end
if (value == 0 && self.infire == true) then self.infire = false end
self.shelltype = 1
self.Entity:NextThink( CurTime() )
return true
end

if (iname == "Fire HE round") then
if (value == 1 && self.infire == false) then self.infire = true end
if (value == 0 && self.infire == true) then self.infire = false end
self.Entity:NextThink( CurTime() )
self.shelltype = 2
return true
end

end
 
 
