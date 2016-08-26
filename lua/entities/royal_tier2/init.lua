AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.SeizeReward = 950

function ENT:Initialize()

	util.AddNetworkString( "rm_pinfo" )
	util.AddNetworkString( "rm_notify" )

	self:SetModel("models/props_c17/consolebox01a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetColor( Color(40,40,40) )
	self:SetMaterial("models/debug/debugwhite", true)

	local phys = self:GetPhysicsObject()
	phys:Wake()

	self:Sett1owning_ent(self:GetOwner())

	self.sparking = false
	self.damage = 100
	self.IsMoneyPrinter = true
	self.timer = CurTime()
	interval = 1

	self:Setpamount(0)
	self:Setpmoneylevel(1)
	self:Setpholdlevel(1)
	self:Setpmaxhold(pconfig.tier2.maxhold)
	self:Setpersecond(pconfig.tier2.persecond)
	self:Setmaxlevel(pconfig.tier2.maxlevel)
	self.maxincrease = pconfig.tier2.mincrease
	self.pincrease = pconfig.tier2.pincrease

end

local wait = false
function ENT:Use(activator, caller)
	
	local localTrace
	if caller:GetEyeTrace().Entity then
		if caller:GetEyeTrace().Entity == self then
			localTrace = self:WorldToLocal( caller:GetEyeTrace().HitPos ) 
		end
	end

	if localTrace and wait == false then
		if localTrace.y > -13.5 and localTrace.y < 13.5 and localTrace.x < -2 and localTrace.x > -6 then
			if activator:canAfford(pconfig.tier2.upgradecost * self:Getpmoneylevel()) then
				if self:Getpmoneylevel() < self:Getmaxlevel() then
					activator:addMoney(-pconfig.tier2.upgradecost * self:Getpmoneylevel())
					self:Setpmoneylevel(self:Getpmoneylevel() + 1)
					if self:Getpersecond() >= (self.pincrease*self:Getpmoneylevel()) then
						self:Setpersecond(self:Getpersecond() + self.pincrease )
					else
						self:Setpersecond(self.pincrease*self:Getpmoneylevel())
					end
				elseif self:Getpmoneylevel() == self:Getmaxlevel() then
					net.Start("rm_notify")
						net.WriteString("Reached max uprade level!")
					net.Send(activator)
				end
			else
				net.Start("rm_notify")
					net.WriteString("You don't have enough money to do this upgrade!")
				net.Send(activator)
			end
		elseif localTrace.y > -13.5 and localTrace.y < 13.5 and localTrace.x < 10 and localTrace.x > 6 then
			if activator:canAfford(pconfig.tier2.upgradecost * self:Getpholdlevel()) then
				if self:Getpholdlevel() < self:Getmaxlevel() then
					activator:addMoney(-pconfig.tier2.upgradecost * self:Getpholdlevel())
					self:Setpholdlevel(self:Getpholdlevel() + 1)
					self:Setpmaxhold(math.Round(self.maxincrease*self:Getpmaxhold()))
				elseif self:Getpholdlevel() == self:Getmaxlevel() then
					net.Start("rm_notify")
						net.WriteString("Reached max uprade level!")
					net.Send(activator)
				end
			else
				net.Start("rm_notify")
					net.WriteString("You don't have enough money to do this upgrade!")
				net.Send(activator)
			end
		else
			if self:Getpamount() > 0 then
				activator:addMoney(self:Getpamount())
				net.Start("rm_notify")
					net.WriteString("You have collected ".. DarkRP.formatMoney(self:Getpamount()).." from your printer!")
				net.Send(activator)
				self:Setpamount(0)
			end
		end
		wait = true
		timer.Simple(1, function() wait = false end)
	end
end

function ENT:OnTakeDamage(dmg)
	if self.burningup then return end

	self.damage = (self.damage or 100) - dmg:GetDamage()
	if self.damage <= 0 then
		self:Destruct()
		self:Remove()
	end
end

function ENT:Destruct()
	local vPoint = self:GetPos()
	local effectdata = EffectData()
	effectdata:SetStart(vPoint)
	effectdata:SetOrigin(vPoint)
	effectdata:SetScale(1)
	util.Effect("Explosion", effectdata)
end

function ENT:Think()
	if self:WaterLevel() > 0 then
		self:Destruct()
		self:Remove()
		return
	end

	if CurTime() > self.timer + interval then
		local Diff = self:Getpmaxhold() - self:Getpamount()
		if self:Getpamount() <= self:Getpmaxhold() then 
			if Diff < self:Getpersecond() then
				self:Setpamount(self:Getpamount() + Diff)
			else
				self:Setpamount(self:Getpamount() + self:Getpersecond())
			end
		end
		
		self.timer = CurTime()
	end
	
end

function ENT:OnRemove()
	if self.sound then
		self.sound:Stop()
	end
end
