
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('entities/base_wire_entity/init.lua'); 
include('shared.lua')

local fuse = 10
local blrad = 100
local blpow = 100
local stickradius = 100


function ENT:Initialize()   

math.randomseed(CurTime())
self.ammomodel = "models/props_c17/canister01a.mdl"
self.ammo = {}
self.ammos = 6
self.armed = false
self.loading = false
self.tox = 0
self.toy = 0
self.reloadtime = 0
self.shelltype = 42
self.infire = false
self.Entity:SetModel( "models/props_c17/consolebox01a.mdl" ) 	
self.Entity:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,  	
self.Entity:SetMoveType( MOVETYPE_VPHYSICS )   --after all, gmod is a physics  	
self.Entity:SetSolid( SOLID_VPHYSICS )        -- Toolbox     
self.Entity:SetColor( 255, 40, 40, 255)

	self.val1 = 0
	self.val2 = 0
	RD_AddResource(self.Entity, "Munitions", 100)
          
local phys = self.Entity:GetPhysicsObject()  	
if (phys:IsValid()) then  		
phys:Wake() 
phys:SetMass( 3 ) 
end 
 
self.Inputs = Wire_CreateInputs( self.Entity, { "Supply drop" , "Torpedo strike" , "Bombing run" , "X" , "Y" } )
self.Outputs = Wire_CreateOutputs( self.Entity, { "Can Fire" , "Shots Remaining" })
end   

function ENT:SpawnFunction( ply, tr)
	
	if ( !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 60
	
	
	local ent = ents.Create( "TANK_GUN" )
		ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()
	
	
	
	return ent

end

function ENT:drop_supplies()

if (self.ammos > 0) then

local trg = ents.Create( "bombar" )
		local pos = self.Entity:GetPos()
		local pnormal = Vector(self.tox - pos.x, self.toy - pos.y, 0):GetNormalized()
		local porigin = self.Entity:GetPos() + Vector(0,0,4000)
		 local trace = {}
		 trace.start = porigin
		 trace.endpos = porigin + pnormal * -10000
		 trace.filter = self.Entity 
		 local tr = util.TraceLine( trace ) 
		if (tr.Hit) then
		trg:SetPos( tr.HitPos + pnormal * 1000 )
		else
		trg:SetPos( trace.endpos + pnormal * 1000 )
		end
		trg:SetAngles( pnormal:Angle() )
		trg:Spawn()
		trg.payload = "supply_box" 
		trg.dst = Vector(self.tox, self.toy, 0)

self.armed = false
self.reloadtime = CurTime() + 12

end

end

function ENT:drop_torpz()

if (self.ammos > 0) then

local trg = ents.Create( "bombar" )
		local pos = self.Entity:GetPos()
		local pnormal = Vector(self.tox - pos.x, self.toy - pos.y, 0):GetNormalized()
		local porigin = self.Entity:GetPos() + Vector(0,0,4000)
		 local trace = {}
		 trace.start = porigin
		 trace.endpos = porigin + pnormal * -10000
		 trace.filter = self.Entity 
		 local tr = util.TraceLine( trace ) 
		if (tr.Hit) then
		trg:SetPos( tr.HitPos + pnormal * 1000 )
		else
		trg:SetPos( trace.endpos + pnormal * 1000 )
		end
		trg:SetAngles( pnormal:Angle() )
		trg:Spawn()
		trg.dst = Vector(self.tox, self.toy, 0)
		trg.payload = "torpedo"

self.armed = false
self.reloadtime = CurTime() + 12

end

end

function ENT:drop_bombz()

if (self.ammos > 0) then

local trg = ents.Create( "bombar" )
		local pos = self.Entity:GetPos()
		local pnormal = Vector(self.tox - pos.x, self.toy - pos.y, 0):GetNormalized()
		local porigin = self.Entity:GetPos() + Vector(0,0,4000)
		 local trace = {}
		 trace.start = porigin
		 trace.endpos = porigin + pnormal * -10000
		 trace.filter = self.Entity 
		 local tr = util.TraceLine( trace ) 
		if (tr.Hit) then
		trg:SetPos( tr.HitPos + pnormal * 1000 )
		else
		trg:SetPos( trace.endpos + pnormal * 1000 )
		end
		trg:SetAngles( pnormal:Angle() )
		trg:Spawn()
		trg.dst = Vector(self.tox, self.toy, 0)
		trg.payload = "aircraft_bomb"

self.armed = false
self.reloadtime = CurTime() + 12

end

end

function ENT:Think()

local ammo = RD_GetResourceAmount(self, "Munitions")
local remain = math.Round(ammo / 600)
Wire_TriggerOutput(self.Entity, "Shots Remaining", remain)

if (self.reloadtime > CurTime()) then
self.armed = false
Wire_TriggerOutput(self.Entity, "Can Fire", 0)
end

if (self.armed == true) then
if (ammo >= 100) then
if (self.shelltype == 1) then
self:drop_supplies()
elseif (self.shelltype == 2) then
self:drop_torpz()
else
self:drop_bombz()
end
RD_ConsumeResource(self, "Munitions", 600)
end
elseif (self.reloadtime < CurTime()) then
Wire_TriggerOutput(self.Entity, "Can Fire", 1)
if (self.infire == true) then self.armed = true end
end

end

function ENT:TriggerInput(iname, value)

if (iname == "Supply drop") then
if (value == 1 && self.infire == false) then self.infire = true end
if (value == 0 && self.infire == true) then self.infire = false end
self.shelltype=1
self.Entity:NextThink( CurTime() )
return true
end

if (iname == "Torpedo strike") then
if (value == 1 && self.infire == false) then self.infire = true end
if (value == 0 && self.infire == true) then self.infire = false end
self.shelltype=2
self.Entity:NextThink( CurTime() )
return true
end

if (iname == "Bombing run") then
if (value == 1 && self.infire == false) then self.infire = true end
if (value == 0 && self.infire == true) then self.infire = false end
self.shelltype=3
self.Entity:NextThink( CurTime() )
return true
end

if (iname == "X") then
self.tox = value
end

if (iname == "Y") then
self.toy = value
end

end
 
 
