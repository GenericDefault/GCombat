
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')


function ENT:Initialize()   

math.randomseed(CurTime())
self.launched = false
self.fuelleft = 10
self.Fires = false
self.coward = nil
self.Entity:SetModel( "models/Combine_Helicopter/helicopter_bomb01.mdl" ) 	
self.Entity:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,  	
self.Entity:SetMoveType( MOVETYPE_VPHYSICS )   --after all, gmod is a physics  	
self.Entity:SetSolid( SOLID_VPHYSICS )        -- Toolbox  
local phys = self.Entity:GetPhysicsObject()  	
if (phys:IsValid()) then  		
phys:Wake() 
phys:SetDragCoefficient( 0 ) 
end 

local basemodel = "models/props_wasteland/kitchen_counter001b.mdl"
local wheelmodel = "models/Roller.mdl"
self.chassis = ents.Create( "prop_physics" )
self.chassis:SetPos( self.Entity:GetPos() )
self.chassis:SetModel( basemodel )
self.chassis:SetAngles( Angle( 0, -90 , 0))
self.chassis:Spawn()
self.wheel1 = ents.Create( "prop_physics" )
self.wheel1:SetPos( self.Entity:GetPos() + Vector( 30, 0, -10 ))
self.wheel1:SetModel( wheelmodel )
self.wheel1:Spawn()
self.wheel2 = ents.Create( "prop_physics" )
self.wheel2:SetPos( self.Entity:GetPos() + Vector( -30, 0, -10 ))
self.wheel2:SetModel( wheelmodel )
self.wheel2:Spawn()
self.wheel3 = ents.Create( "prop_physics" )
self.wheel3:SetPos( self.Entity:GetPos() + Vector( 30, 40, -10 ))
self.wheel3:SetModel( wheelmodel )
self.wheel3:Spawn()
self.wheel4 = ents.Create( "prop_physics" )
self.wheel4:SetPos( self.Entity:GetPos() + Vector( -30, 40, -10 ))
self.wheel4:SetModel( wheelmodel )
self.wheel4:Spawn()

local wheelb1 = constraint.Ballsocket( self.chassis, self.wheel1, 0, 0, Vector( 0, 0, 0 ), 0, 0, 1 )
local wheelb2 = constraint.Ballsocket( self.chassis, self.wheel2, 0, 0, Vector( 0, 0, 0 ), 0, 0, 1 )
local wheelb3 = constraint.Ballsocket( self.chassis, self.wheel3, 0, 0, Vector( 0, 0, 0 ), 0, 0, 1 )
local wheelb4 = constraint.Ballsocket( self.chassis, self.wheel4, 0, 0, Vector( 0, 0, 0 ), 0, 0, 1 )
local weld = constraint.Weld(self.Entity, self.chassis, 0, 0, 0)


 
end   

function ENT:SpawnFunction( ply, tr)

	local SpawnPos = tr.HitPos + tr.HitNormal * 100
	
	local ent = ents.Create( "Armoredcar" )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()
	
	return ent

end

function ENT:Use(act, cal)
if (!self.launched) then

self.launched = true
self.coward = act
act:Spectate( OBS_MODE_CHASE  )
act:SpectateEntity( self.Entity )
act:DrawViewModel(false)
act:DrawWorldModel(false)
act:StripWeapons()
self.Fires = true

end

end

 function ENT:Think()
 
 if (self.launched) then
 
 if ( self.fuelleft > 0 ) then
 
 self.Entity:GetPhysicsObject():ApplyForceCenter( (self.Entity:GetForward()) * 300000 )
 self.fuelleft = self.fuelleft - 1

 end
 
 if ( self.coward:KeyDown( IN_ATTACK ) ) then 
 self.coward:UnSpectate()
 self.coward:DrawViewModel(true)
 self.coward:DrawWorldModel(true)
 self.coward:Spawn()
 self.coward:SetPos(self.Entity:GetPos())
 end
 
 if ( self.coward:KeyDown( IN_FORWARD ) ) then 
 local phys = self.wheel1:GetPhysicsObject()  	
	if (phys:IsValid()) then  		
	phys:ApplyForceOffset( self.Entity:GetForward() * 100, self.Entity:GetUp() * 100)
	end 
local phys2 = self.wheel2:GetPhysicsObject()  	
	if (phys2:IsValid()) then  		
	phys2:ApplyForceOffset( self.Entity:GetForward() * 100, self.Entity:GetUp() * 100)
	end 
 local phys3 = self.wheel3:GetPhysicsObject()  	
	if (phys3:IsValid()) then  		
	phys3:ApplyForceOffset( self.Entity:GetForward() * 100, self.Entity:GetUp() * 100)
	end 
local phys3 = self.wheel4:GetPhysicsObject()  	
	if (phys3:IsValid()) then  		
	phys3:ApplyForceOffset( self.Entity:GetForward() * 100, self.Entity:GetUp() * 100)
	end 
 
 if ( self.coward:KeyDown( IN_BACKWARD ) ) then 
 self.Entity:GetPhysicsObject():ApplyForceCenter( (self.coward:GetAimVector()) * 6000 )
 end
 
 end

 
 end
 end
 
 
