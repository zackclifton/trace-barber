SWEP.PrintName = "Custom Pistol"
SWEP.Author = "Butts"
SWEP.Instructions = "It's a gun, shoot it"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Primary.ClipSize = 20
SWEP.Primary.DefaultClip = 3000
SWEP.Primary.Automatic = true

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
--SWEP.Secondary.Automatic	= true
--SWEP.Secondary.Ammo		= "none"

SWEP.Weight			= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Slot			= 0
SWEP.SlotPos			= 2
SWEP.DrawAmmo			= false
SWEP.DrawCrosshair		= true

SWEP.ViewModel			= "models/weapons/v_pistol.mdl"
SWEP.WorldModel			= "models/weapons/w_pistol.mdl"
SWEP.UseHands			= false

local shotDamage = 50
local shotRof = 0.5
local shotCount = 1
local shotSpread = 0.07

CreateClientConVar( "cweapon_damage", shotDamage, true, true )
CreateClientConVar( "cweapon_count", shotCount, true, true )
CreateClientConVar( "cweapon_spread", shotSpread, true, true )
CreateClientConVar( "cweapon_rof", shotRof, true, true )

function SWEP:PrimaryAttack()
	-- For now we're using the built in ShootBullet() function.
	self.Weapon:SetNextPrimaryFire( CurTime() + GetConVarNumber( "cweapon_rof" ) )
	self:ShootBullet( GetConVarNumber( "cweapon_damage" ), GetConVarNumber( "cweapon_count" ), GetConVarNumber( "cweapon_spread" ) )
	
	-- We'll use CustomShoots() when it's more refined.
	--CustomShoots(self)
end

function CustomShoots( self )
	self:ShootEffects()
	self.Weapon:EmitSound( "Weapon_AR2.Single" )
	for var=1,shotCount,1 do
		--local tr = self.Owner:GetEyeTrace()
		local tr = util.TraceLine( util.GetPlayerTrace(self.Owner) )
		local Pos1 = tr.HitPos + tr.HitNormal
		local Pos2 = tr.HitPos - tr.HitNormal
		util.Decal( "impact.concrete", Pos1, Pos2 )
		--if ( IsValid( tr.Entity )) then print( "I saw a "..tr.Entity:GetModel() ) end
	--[[local tr = util.TraceLine( {
		start = butts,
		endpos = butts + farts:Forward() * 10000
		} )]]--
	--print( tr.Hit, tr.Entity, iteration )
	--if !(tr.Entity == self.Owner) then
		if ( SERVER ) then
			if ( tr.HitGroup == HITGROUP_HEAD ) then
				tr.Entity:TakeDamage( shotDamage*headshotMult, self.Owner, self )
			else
				tr.Entity:TakeDamage( shotDamage, self.Owner, self )
			end			
		end
	end
	--end
	
	--TakeDamage( 500, "", "" )
	--tr.Entity.TakeDamage( 500000 )
	--[[self.Weapon:SetNextPrimaryFire( CurTime() + 0.001 )	
	if ( !self:CanPrimaryAttack() ) then return end
	self.Weapon:EmitSound( "Weapon_AR2.Single" )
	self:ShootBullet( shotDamage, shotCount, 0 )
	self:TakePrimaryAmmo( 0	)
	self.Owner:ViewPunch( Angle( 0, 0, 0) )]]--
end

function SWEP:ShootBullet( damage, num_bullets, aimcone )
	
	local bullet = {}

	bullet.Num 	= num_bullets
	bullet.Src 	= self.Owner:GetShootPos() -- Source
	bullet.Dir 	= self.Owner:GetAimVector() -- Dir of bullet
	bullet.Spread 	= Vector( aimcone, aimcone, 0 )	 -- Aim Cone
	bullet.Tracer	= 2 -- Show a tracer on every x bullets 
	bullet.Force	= 1 -- Amount of force to give to phys objects
	bullet.Damage	= damage
	bullet.AmmoType = "Pistol"
	
	self.Owner:FireBullets( bullet )
	
	self:ShootEffects()
	
end

--[[function CustomDamageNPC(npc, hitgroup, dmginfo)
	dmginfo:SetDamage(0)
	if ( hitgroup == HITGROUP_HEAD ) then
	npc:TakeDamage( shotDamage*1.3, dmginfo:GetAttacker(), dmginfo:GetInflictor() )		
	else
	npc:TakeDamage( shotDamage, dmginfo:GetAttacker(), dmginfo:GetInflictor() )	
	end
end

function CustomDamagePlayers(ply, hitgroup, dmginfo)
	dmginfo:SetDamage(0)
	if ( hitgroup == HITGROUP_HEAD ) then
	ply:TakeDamage( shotDamage*1.3, dmginfo:GetAttacker(), dmginfo:GetInflictor() )		
	else
	ply:TakeDamage( shotDamage, dmginfo:GetAttacker(), dmginfo:GetInflictor() )	
	end
end

hook.Add( "ScaleNPCDamage", "CustomDamageNPC", CustomDamageNPC )
hook.Add( "ScalePlayerDamage", "CustomDamagePlayers", CustomDamagePlayers )]]--
