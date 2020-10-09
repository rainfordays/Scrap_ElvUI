local R,G,B = GetItemQualityColor(0)
local Scrap_ElvUI = {}
Scrap_ElvUI.ElvUIHookTries = 0

local ElvUIBags = ElvUI[1]:GetModule("Bags")


local function UpdateContainerElvUI(bag)
	local frame = _G['ElvUI_ContainerFrameBag' .. bag]
	local name = frame:GetName()
	local size = frame.numSlots

	if not size then return end
	for i = 1, size do
		local slot = i
		local button = _G[name .. 'Slot' .. slot]
		local id = GetContainerItemID(bag, i)

		local isJunk = id and Scrap:IsJunk(id, bag, slot)
		local glow = button.ScrapAddonGlow or self:NewGlow(button)
		local icon = button.ScrapAddonIcon or self:NewIcon(button)

		glow:SetShown(isJunk and Scrap.sets.glow)
		icon:SetShown(isJunk and Scrap.sets.icons)
	end
end

-- Update bags
local function UpdateAll()
  for i = 0, NUM_BAG_SLOTS do
		UpdateContainerElvUI(i)
  end
end




local function UpdateSlot(_, self, bagID, slotID)
	if not self.Bags[bagID] or not self.Bags[bagID][slotID] then
		return
	end
	local button = self.Bags[bagID][slotID]
	local id = GetContainerItemID(bagID, slotID)

	local isJunk = id and Scrap:IsJunk(id, bagID, slotID)
	local glow = button.ScrapAddonGlow or Scrap_ElvUI:NewGlow(button)
	local icon = button.ScrapAddonIcon or Scrap_ElvUI:NewIcon(button)

	button.ScrapAddonGlow:SetShown(isJunk and glow)
	button.ScrapAddonIcon:SetShown(isJunk and icon)
end






function Scrap_ElvUI:NewGlow(button)
	button.ScrapAddonGlow = button:CreateTexture(button:GetName().."ScrapAddonGlow", 'OVERLAY', nil, 3)
	button.ScrapAddonGlow:SetTexture('Interface/Buttons/UI-ActionButton-Border')
	button.ScrapAddonGlow:SetVertexColor(R,G,B, .7)
	button.ScrapAddonGlow:SetBlendMode('ADD')
	button.ScrapAddonGlow:SetAllPoints(button.ExtendedSlot)

	return button.ScrapAddonGlow
end

function Scrap_ElvUI:NewIcon(button)
	button.ScrapAddonIcon = button:CreateTexture(button:GetName().."ScrapAddonIcon", 'OVERLAY', nil, 3)
	button.ScrapAddonIcon:SetTexture('Interface/Buttons/UI-GroupLoot-Coin-Up')
	button.ScrapAddonIcon:SetPoint('TOPLEFT', 2, -2)
	button.ScrapAddonIcon:SetSize(15, 15)

	return button.ScrapAddonIcon
end







-- Hooks
local function SetHooks()
	hooksecurefunc(Scrap, 'ToggleJunk', UpdateAll)
	hooksecurefunc(ElvUIBags, "UpdateSlot", UpdateSlot)

	UpdateAll()
end
hooksecurefunc(ElvUIBags, "Initialize", SetHooks)