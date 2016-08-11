
COMBATDAMAGEENGINE = 1

local minhealth = 10
local maxhealth = 1000
local def = 10

function cbt_registerall()

local ncbtents = ents.FindByClass( "prop_physics" )
for _,n in pairs(ncbtents) do
n.cbt = ents.Create( "cbtproperty" )
n.cbt:Spawn()
n.cbt:SetOwner( n )
n.cbt.health = n:GetPhysicsObject():GetMass()
n.cbt.health = math.Clamp( n.cbt.health, minhealth, maxhealth)
n.cbt.healthmax = n.cbt.health
n.cbt.armor = def
n.cbt.armormax = n.cbt.armor
n.cbt.exclude = false
n.cbt.temperature = 200
n:DeleteOnRemove( n.cbt )
end
end
concommand.Add( "!nihilism", cbt_registerall )

function debeezer( entity )

local check = entity.cbt or false

if (check == false) then

entity.cbt = ents.Create( "cbtproperty" )
entity.cbt:Spawn()
entity.cbt:SetOwner( entity )
entity.cbt.health = entity:GetPhysicsObject():GetMass()
entity.cbt.health = math.Clamp( entity.cbt.health, minhealth, maxhealth)
entity.cbt.healthmax = entity.cbt.health
entity.cbt.armor = def
entity.cbt.armormax = entity.cbt.armor
entity.cbt.exclude = false
entity.cbt.temperature = 200
entity:DeleteOnRemove( entity.cbt )

end

end

--cbt_dealdevhit is a framework for custom damage types, so people won't have to mess with my code to make new damage types >:(. 0 is returned for "fail", 1 for "success", and 2 for "destroy". 
--cbt_dealdevhit DOESN'T ACTUALLY DESTROY OR REMOVE ANYTHING: IT'S FOR MAKING YOUR OWN EFFECTS.
--Weapons that use any kind of hits from this engine should DEFINATELY have 'pierce' as a constant. people are idiots, and don't need encouragement.
--the fourth argument is a boolean for if this attack ignores shields. not necessary, but you should definately ignore shields on effects which damage over time, like overheating.
function cbt_dealdevhit( entity, damage, pierce, noshield )
	local shd = {}

	local breakcase = entity.hasdamagecase or false
	if (!entity || !entity:IsValid()) then return 0 end
	if (entity:IsVehicle() || entity:GetClass() == "gmod_wheel" || entity:GetClass() == "prop_physics" || breakcase == true) then
		debeezer( entity )
		local dice = math.random( 0, 12)
		
		noshield = noshield or false
		if noshield == false then
		shd = cbt_getentityshield( entity )
		if shd.number > 0 then
			cbt_applyheat(entity, 40 * (shd.number - 1))
			dice = dice - shd.buff
			local effectdata = EffectData()
			effectdata:SetEntity( entity )
			util.Effect( "shield_ping", effectdata )
		end
		end
		
		if ((dice + pierce) > entity.cbt.armor) then
			if (entity.cbt.health < damage) then
				if (breakcase == true) then 
					entity:gcbt_breakactions(damage, pierce)
					return 3
				end
				return 2
			else
				entity.cbt.health = entity.cbt.health - damage
				if (entity.cbt.health < entity.cbt.healthmax / 4) then entity.cbt.iscritical = 1 end
			end
			return 1
		end
		return 0
	end
end

--cbt_dealhcghit deals a hollow charge style hit to the object.
function cbt_dealhcghit( entity, damage, pierce, src, dest)

local attack = cbt_dealdevhit(entity, damage, pierce)

if attack == 2 then

local wreck = ents.Create( "wreckedstuff" )
wreck:SetModel( entity:GetModel() )
wreck:SetAngles( entity:GetAngles() )
wreck:SetPos( entity:GetPos() )
wreck:Spawn()
wreck:Activate()
entity:Remove()
local effectdata1 = EffectData()
effectdata1:SetOrigin(src)
effectdata1:SetStart(dest)
effectdata1:SetScale( 10 )
effectdata1:SetRadius( 100 )
util.Effect( "Explosion", effectdata1 )

elseif attack == 1 then

local effectdata1 = EffectData()
effectdata1:SetOrigin(src)
effectdata1:SetStart(dest)
effectdata1:SetScale( 10 )
effectdata1:SetRadius( 100 )
util.Effect( "HelicopterMegaBomb", effectdata1 )

elseif attack == 0 then

local effectdata1 = EffectData()
effectdata1:SetOrigin(src)
effectdata1:SetStart(dest)
effectdata1:SetScale( 10 )
effectdata1:SetRadius( 100 )
util.Effect( "RPGShotDown", effectdata1 )

end

return attack
end

--cbt_dealnrghit deals an energy weapon hit to the object.
function cbt_dealnrghit( entity, damage, pierce, src, dest)

local attack = cbt_dealdevhit( entity, damage, pierce )

if attack == 2 then

local wreck = ents.Create( "wreckedstuff" )
wreck:SetModel( entity:GetModel() )
wreck:SetAngles( entity:GetAngles() )
wreck:SetPos( entity:GetPos() )
wreck:Spawn()
wreck:Activate()
wreck.deathtype = 1
entity:Remove()
local effectdata1 = EffectData()
effectdata1:SetOrigin(src)
effectdata1:SetStart(dest)
effectdata1:SetScale( 10 )
effectdata1:SetRadius( 100 )
util.Effect( "cball_bounce", effectdata1 )

elseif attack == 1 then

local effectdata1 = EffectData()
effectdata1:SetOrigin(src)
effectdata1:SetStart(dest)
effectdata1:SetScale( 10 )
effectdata1:SetRadius( 100 )
util.Effect( "ImpactGunship", effectdata1 )

elseif attack == 0 then

local effectdata1 = EffectData()
effectdata1:SetOrigin(src)
effectdata1:SetStart(dest)
effectdata1:SetScale( 10 )
effectdata1:SetRadius( 100 )
util.Effect( "AR2Impact", effectdata1 )

end

return attack

end

--this is how you d explosions, and is in here more as an example than anything else.
function cbt_hcgexplode( position, radius, damage, pierce)

local targets = ents.FindInSphere( position, radius)

for _,i in pairs(targets) do
local hitat = i:NearestPoint( position )
cbt_dealhcghit( i, damage, pierce, hitat, hitat)

end
end

--this is new, lol. It is what you should be using to heat things up.
function cbt_applyheat(ent, temp)
	local breakcase = ent.hasdamagecase or false
	if (ent:IsVehicle() || ent:GetClass() == "gmod_wheel" || ent:GetClass() == "prop_physics" || breakcase == true) then
		debeezer( ent )
		local temper = ent.cbt.temperature or 200
		temper = temper + temp
		ent.cbt.temperature = temper
	end
end

--Use this function to emit area heat. Input 0 to the fourth argument to have it heat up the prop emitting it as well.
function cbt_emitheat( position, radius, temp, own)

	local targets = ents.FindInSphere( position, radius)

	for _,f in pairs(targets) do
		if (f != own) then
			cbt_applyheat(f, temp)
		end
	end
end


local shields = {}

function cbt_registershield( ent )
	shields[0] = ent
	shields[#shields+1] = ent
end

function cbt_getentityshield( ent )
	local all = {}
	local rel = {}
	local th = 0
	local total = 0
	local pos = ent:GetPos()
	
		for _,u in pairs(shields) do
			local active = u.shd_active or 0
			if (active == 1 && pos:Distance(u:GetPos()) < u.shd_radius) then
				th = th + 1
				total = total + u.shd_buff
			end
		end

	rel.buff = total
	rel.number = th
	
	return rel
end

--This allows you to set a prop's armor, and whether or not it is included in the system.
function cbt_modifyarmor( propid, armor, excludeprop )

debeezer( propid )
propid.cbt.armor = def
propid.cbt.exclude = excludeprop

end
