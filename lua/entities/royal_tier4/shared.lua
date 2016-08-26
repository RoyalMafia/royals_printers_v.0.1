ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Royal Tier IV"
ENT.Author = "RoyalMafia"
ENT.Category = "Royals Printers"
ENT.Spawnable = true
ENT.AdminSpawnable = true

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "t1price")
	self:NetworkVar("Entity", 0, "t1owning_ent")
	self:NetworkVar("Int", 1, "pamount") -- Amount
	self:NetworkVar("Int", 2, "pmaxhold") -- Max Hold
	self:NetworkVar("Int", 3, "persecond") -- Per Second
	self:NetworkVar("Int", 4, "pholdlevel") -- Hold Level
	self:NetworkVar("Int", 5, "maxlevel") -- Max Level
	self:NetworkVar("Int", 6, "pmoneylevel") -- Money Level
end
