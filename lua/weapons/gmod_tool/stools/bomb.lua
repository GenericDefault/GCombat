
TOOL.Category		= "GCombat"
TOOL.Name			= "#GCX Bombs"
TOOL.Command		= nil
TOOL.ConfigName		= ""

TOOL.ClientConVar[ "bombindex" ] = "0"
TOOL.ent = {}


cleanup.Register( "bomb" )


// Add Default Language translation (saves adding it to the txt files)
if ( CLIENT ) then

	language.Add( "Tool_bomb_name", "GCX Bombs" )
	language.Add( "Tool_bomb_desc", "Adds bombs to things." )
	language.Add( "Tool_bomb_0", "Left click to weld the selected object. Right click to spawn." )
	
	language.Add( "Tool_turret_type", "Type of weapon" )
	
	language.Add( "Undone_bomb", "Undone weapon" )
	
	language.Add( "Cleanup_bomb", "Weapon" )
	language.Add( "Cleaned_bomb", "Cleaned up all Weapons" )
	language.Add( "SBoxLimit_gcombats", "You've reached the Weapon limit!" )

end

function TOOL:LeftClick( trace )

if ( !trace.Hit ) then return end
	
	if ( SERVER && !util.IsValidPhysicsObject( trace.Entity, trace.PhysicsBone ) ) then return false end
	if (CLIENT) then return true end
	
	local bombindex	= self:GetClientNumber( "bombindex" ) 
	
	local SpawnPos = trace.HitPos + trace.HitNormal * 4
	if (bombindex == 0) then
	self.ent = ents.Create( "bigbombrack" )
		self.ent:SetPos( SpawnPos )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0))
	self.ent:Spawn()
	self.ent:Activate()
	elseif (bombindex == 1) then
	self.ent = ents.Create( "medbombrack" )
		self.ent:SetPos( SpawnPos )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0))
	self.ent:Spawn()
	self.ent:Activate()
	elseif (bombindex == 2) then
	self.ent = ents.Create( "smbombrack" )
		self.ent:SetPos( SpawnPos )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0))
	self.ent:Spawn()
	self.ent:Activate()
	end
	
	
	local phys = self.ent:GetPhysicsObject()  	
	if (phys:IsValid()) then  		
		local weld = constraint.Weld(self.ent, trace.Entity, 0, trace.PhysicsBone, 0)
		local nocollide = constraint.NoCollide(self.ent, trace.Entity, 0, trace.PhysicsBone)
	end 
	local ply = self:GetOwner()
	
	undo.Create("bomb")
		undo.AddEntity( self.ent )
		undo.AddEntity( weld )
		undo.AddEntity( nocollide )
		undo.SetPlayer( ply )
	undo.Finish()
	return true

end

function TOOL:RightClick( trace )
	
if ( !trace.Hit ) then return end
	
	if ( SERVER && !util.IsValidPhysicsObject( trace.Entity, trace.PhysicsBone ) ) then return false end
	if (CLIENT) then return true end
	
	local bombindex	= self:GetClientNumber( "bombindex" ) 
	
	local SpawnPos = trace.HitPos + trace.HitNormal * 4
	if (bombindex == 0) then
	self.ent = ents.Create( "bigbombrack" )
		self.ent:SetPos( SpawnPos )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0))
	self.ent:Spawn()
	self.ent:Activate()
	elseif (bombindex == 1) then
	self.ent = ents.Create( "medbombrack" )
		self.ent:SetPos( SpawnPos )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0))
	self.ent:Spawn()
	self.ent:Activate()
	elseif (bombindex == 2) then
	self.ent = ents.Create( "smbombrack" )
		self.ent:SetPos( SpawnPos )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0))
	self.ent:Spawn()
	self.ent:Activate()
	end
	
	local ply = self:GetOwner()
	
	undo.Create("bomb")
		undo.AddEntity( self.ent )
		undo.SetPlayer( ply )
	undo.Finish()
	return true

end

function TOOL.BuildCPanel( CPanel )

	// HEADER
	CPanel:AddControl( "Header", { Text = "#Tool_bomb_name", Description	= "#Tool_bomb_desc" }  )
	
	
	// the pertenent bomb
	local Ctype = {Label = "#Tool_turret_type", MenuButton = 0, Options={}}
		Ctype["Options"]["#Heavy Bomb Rack"]	= { bomb_bombindex = "0" }
		Ctype["Options"]["#Medium Bomb Rack"]	= { bomb_bombindex = "1" }
		Ctype["Options"]["#Light Bomb Rack"]	= { bomb_bombindex = "2" }
							
	CPanel:AddControl("ComboBox", Ctype )
	

end
