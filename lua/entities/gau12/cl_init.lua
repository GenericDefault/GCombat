
include('shared.lua')
--killicon.AddFont("seeker_missile", "CSKillIcons", "C", Color(255,80,0,255))


function ENT:Initialize()

end

function ENT:Draw()
	
	self.Entity:DrawModel()
	
	--render.SetMaterial( Material( "sprites/light_glow02_add" ) )	
	--local color = Color( 50, 150, 255, 255 )
	--render.DrawSprite( self.Entity:GetPos() , 10, 10, color )
end
