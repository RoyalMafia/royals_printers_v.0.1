include("shared.lua")

surface.CreateFont("royals_font_1", {font = "Arial",size = 30,weight = 600,blursize = 0,scanlines = 0,antialias = false});
surface.CreateFont("royals_font_2", {font = "Arial",size = 25,weight = 600,blursize = 0,scanlines = 0,antialias = false});
surface.CreateFont("royals_font_3", {font = "Arial",size = 22,weight = 600,blursize = 0,scanlines = 0,antialias = false});

function ENT:Draw()

	Amount     = self:Getpamount()
	Maxhold    = self:Getpmaxhold()
	PerSecond  = self:Getpersecond()
	MoneyLvl   = self:Getpmoneylevel()
	HoldLvl    = self:Getpholdlevel()
	MaxLevel   = self:Getmaxlevel()

	self:DrawModel()

	local Pos = self:GetPos()
	local Ang = self:GetAngles()
	local Dist = (Pos - LocalPlayer():GetPos()):Length()
	local alpha = 360 - Dist

	local Percent = (Amount / Maxhold * 100)

	Ang:RotateAroundAxis(Ang:Up(), 90)

	cam.Start3D2D(Pos + Ang:Up() * 10.8, Ang, 0.11)
		draw.RoundedBox(0, -140, -150, 283, 40, Color(218,165,32))
		draw.RoundedBox(0, -140, -110, 283, 4, Color(153,101,21))
		draw.SimpleText("Ultimate Printer", "royals_font_1", 0, -130, Color(30,30,30), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

		draw.RoundedBox(0, -140, 112, 283, 20, Color(70,70,70))
		draw.RoundedBox(0, -140, 108, 283, 4, Color(30,30,30))

		draw.RoundedBox(0, -140, 112, math.Clamp(Percent*2.83,0,283), 20, Color(40,210,40))
		draw.SimpleText(DarkRP.formatMoney(Amount), "royals_font_2", 0, 122, Color(30,30,30), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

		if alpha > 0 then
			draw.RoundedBox(0, -120, -90, 243, 40, Color(218,165,32,alpha))
			draw.RoundedBox(0, -120, -50, 243, 30, Color(153,101,21,alpha))
			draw.SimpleText("Money P/S", "royals_font_2", -115, -70, Color(30,30,30,alpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			draw.SimpleText(DarkRP.formatMoney(PerSecond), "royals_font_2", 115, -70, Color(30,30,30,alpha), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)

			if MoneyLvl != MaxLevel then
				draw.SimpleText("Upgrade ("..DarkRP.formatMoney(pconfig.tier6.upgradecost * self:Getpmoneylevel())..") "..MoneyLvl.."/"..MaxLevel - 1, "royals_font_3", 0, -37, Color(30,30,30,alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			else
				draw.SimpleText("Max Level", "royals_font_3", 0, -37, Color(30,30,30,alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end

			draw.RoundedBox(0, -120, 20, 243, 40, Color(218,165,32,alpha))
			draw.RoundedBox(0, -120, 60, 243, 30, Color(153,101,21,alpha))
			draw.SimpleText("Max Hold", "royals_font_2", -115, 40, Color(30,30,30,alpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			draw.SimpleText(DarkRP.formatMoney(Maxhold), "royals_font_2", 115, 40, Color(30,30,30,alpha), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)

			if HoldLvl != MaxLevel then
				draw.SimpleText("Upgrade ("..DarkRP.formatMoney(pconfig.tier6.upgradecost * self:Getpholdlevel())..") "..HoldLvl.."/"..MaxLevel - 1, "royals_font_3", 0, 73, Color(30,30,30,alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			else
				draw.SimpleText("Max Level", "royals_font_3", 0, 73, Color(30,30,30,alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		end
	cam.End3D2D()

	Ang:RotateAroundAxis(Ang:Forward(), 90)

	cam.Start3D2D(Pos + Ang:Up()*16.7, Ang, 0.11)
		draw.RoundedBox(0, -131, -63, 200, 30, Color(218,165,32))

		draw.RoundedBox(0, -131, -67, 200, 4, Color(153,101,21))
		draw.RoundedBox(0, -131, -33, 200, 4, Color(153,101,21))

		draw.SimpleText("Ultimate Printer", "royals_font_1", -30, -49, Color(30,30,30), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	cam.End3D2D()
end

// Notify
net.Receive("rm_notify", function(pl, len)
	chat.AddText(Color(240,70,70), "[RM Notify] ", Color(255,255,255), net.ReadString())
end)