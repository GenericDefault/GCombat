AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:Initialize()   

self.health = 10
self.armor = 7
self.isdead = false
self.exclude = false
end

function ENT:GetPos()
	local res = self.Entity:GetOwner():GetPos()
	return res
end

function ENT:Think()

	local own = self.Entity:GetOwner()
	
		local normtemp = 200
		if (own:WaterLevel() == 0) then
				wr = 0
		else
				wr = 80
		end
		
		if self.temperature > self.armor * 75 then
			if (!own:IsOnFire() && wr == 0) then own:Ignite( 30, (self.temperature - 200) / 10) end
			local fire = cbt_dealdevhit( own, 5, self.armor, true )
			if fire == 2 then
				local wreck = ents.Create( "wreckedstuff" )
				wreck:SetModel(own:GetModel() )
				wreck:SetAngles( own:GetAngles() )
				wreck:SetPos( own:GetPos() )
				wreck:Spawn()
				wreck:Activate()
				
				local effectdata1 = EffectData()
				effectdata1:SetOrigin(own:GetPos())
				effectdata1:SetStart(own:GetPos())
				util.Effect( "Explosion", effectdata1 )
				
				own:Remove()
				return true
			end
		else
			if (own:IsOnFire()) then own:Extinguish() end
		end
		if self.temperature != normtemp then
			
			
			
			
			if self.temperature - normtemp > normtemp then
				self.temperature = self.temperature - (20 + wr) 
			else 
				self.temperature = self.temperature + (20 + wr)
			end
			if (math.abs((wr+20) - normtemp) < (wr + 20)) then self.temperature = normtemp end
			
			local r, g, b, a = own:GetColor()
			local pff = math.Clamp((self.temperature - 200) / 10, 0, 255)
			own:SetColor(255 - pff,255 - pff,255 - pff, a)
			
			end
			
	
	self.iscritical = self.iscritical or 0
	if self.iscritical == 1 then
			local fire1 = cbt_dealdevhit( own, 10, self.armor )
			if fire1 == 2 then
				local wreck = ents.Create( "wreckedstuff" )
				wreck:SetModel( own:GetModel() )
				wreck:SetAngles( own:GetAngles() )
				wreck:SetPos( own:GetPos() )
				wreck.deathtype = 1
				wreck:Spawn()
				wreck:Activate()
				own:Remove()
			end
			local effectdata1 = EffectData()
			effectdata1:SetOrigin(own:GetPos())
			effectdata1:SetStart(own:GetPos())
			util.Effect( "Explosion", effectdata1 )
	end
	self.Entity:NextThink( CurTime() + 2)
	return true
end
