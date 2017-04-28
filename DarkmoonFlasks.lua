--TODO: seems like registering in Interface options probably will be needed
	--checbox for hiding the icon elixir if hat elixir isn't in bag
		--checkbox for showing the icon of elixir if combined count of that elixir in bank and bag is nonzero
	--ability to toggle movability of DarkmoonFlasksDragFrame
	--ability to set "arbitrary" order for icons - swap of tinctures and draughts, and change of order of different stats
	--itemIDs for potions
local darkmoonflasks = {}
darkmoonflasks = {
	[1] = 124642, --"Darkmoon Draught of Supremacy",
	[2] = 124659, --"Darkmoon Tincture of Supremacy",
	[3] = 124646, --"Darkmoon Draught of Flexibility",
	[4] = 124658, --"Darkmoon Tincture of Flexibility",
	[5] = 124645, --"Darkmoon Draught of Precision",
	[6] = 124657, --"Darkmoon Tincture of Precision",
	[7] = 124648, --"Darkmoon Draught of Divergence",
	[8] = 124655, --"Darkmoon Tincture of Divergence",
	[9] = 124647, --"Darkmoon Draught of Alacrity",
	[10] = 124656, --"Darkmoon Tincture of Alacrity",
	[11] = 124650, --"Darkmoon Draught of Deftness",
	[12] = 124653, --"Darkmoon Tincture of Deftness",
	[13] = 124651, --"Darkmoon Draught of Deflection",
	[14] = 124652, --"Darkmoon Tincture of Deflection",
	[15] = 124649, --"Darkmoon Draught of Defense",
	[16] = 124654, --"Darkmoon Tincture of Defense",
}

local potions = {}
potions = {
[1] = "Minor Healing Potion",
[2] = "Lesser Healing Potion",
[3] = "Healing Potion",
[4] = "Greater Healing Potion",
[5] = "Superior Healing Potion",
[6] = "Major Healing Potion",
[7] = "Super Healing Potion",
[8] = "Minor Mana Potion",
[9] = "Lesser Mana Potion",
[10] = "Mana Potion",
[11] = "Greater Mana Potion",
[12] = "Superior Mana Potion",
[13] = "Major Mana Potion",
[14] = "Super Mana Potion",
}

local itemset = {}
local what_to_do = "Darkmoon"
--local what_to_do = "Potions" -- not updated yet
if (what_to_do == "Darkmoon") then
	itemset = darkmoonflasks
else
	itemset = potions
end
local numIte = #itemset

local stage = {}
local which = {}

local addonname="DarkmoonFlasks"

local function reset_position()
	DarkmoonFlasksDragFrame:Hide() -- for some reason needs to be hidden
	DarkmoonFlasksDragFrame:ClearAllPoints()
	DarkmoonFlasksDragFrame:SetPoint("CENTER", UIParent,"CENTER", 0, 0)
	DarkmoonFlasksDragFrame:Show()
end

local function reset_position_reload()
	reset_position()
	ReloadUI();
end

local DarkmoonFlasks
DarkmoonFlasks = {};

local DarkmoonFlasksDragFrame = CreateFrame("Frame", "DarkmoonFlasksDragFrame", UIParent)
DarkmoonFlasksDragFrame:ClearAllPoints()
DarkmoonFlasksDragFrame:SetPoint("CENTER", 0, 0)
DarkmoonFlasksDragFrame:SetScale(1)
DarkmoonFlasksDragFrame:SetWidth(350)
DarkmoonFlasksDragFrame:SetHeight(150)
DarkmoonFlasksDragFrame:Show()
--Basic draggable frames
DarkmoonFlasksDragFrame:RegisterForDrag("LeftButton")
DarkmoonFlasksDragFrame:EnableMouse(true)
DarkmoonFlasksDragFrame:SetClampedToScreen(true)
DarkmoonFlasksDragFrame:SetMovable(true)
DarkmoonFlasksDragFrame:SetScript("OnDragStart", DarkmoonFlasksDragFrame.StartMoving)
DarkmoonFlasksDragFrame:SetScript("OnDragStop", DarkmoonFlasksDragFrame.StopMovingOrSizing)

local texture=DarkmoonFlasksDragFrame:CreateTexture(nil,"ARTWORK")
texture:SetAllPoints(DarkmoonFlasksDragFrame)
texture:SetColorTexture(0, 0.75, 1, 0.7)

local w = 36
local w1 = w * 1.1
local h = 36
local h1 = h * 1.1
local x
local y

local function createOneButton(itemID)
	local _, itemLink, _,_,_,_,_,_,_,itemTexture,_ = GetItemInfo(itemID)
	--print("create",itemLink)
	local DarkmoonFlasksDButton = CreateFrame("Button", "DarkmoonFlasksDButton"..itemID, DarkmoonFlasksDragFrame, "SecureActionButtonTemplate")
	if stage[itemID] then y = h1 else y = 0 end
	--x = (which[itemID] -1) * w1
	x = (which[itemID]) * w1
	--print(itemname,itemName)
	DarkmoonFlasksDButton:RegisterForClicks("AnyUp")
	DarkmoonFlasksDButton:ClearAllPoints()
	DarkmoonFlasksDButton:SetPoint("BOTTOMLEFT", x+20, y+52)
	DarkmoonFlasksDButton:SetSize(w, h)
	DarkmoonFlasksDButton:SetNormalTexture(itemTexture)
	DarkmoonFlasksDButton:SetPushedTexture(itemTexture)
	DarkmoonFlasksDButton:SetHighlightTexture(itemTexture)
	DarkmoonFlasksDButton:SetAttribute("type", "item")
	DarkmoonFlasksDButton:SetAttribute("item",itemID)
	
	DarkmoonFlasksDButton.DarkmoonFlasksDButtonFSD = DarkmoonFlasksDButton:CreateFontString("FontString", "OVERLAY", "GameTooltipText")
	DarkmoonFlasksDButton.DarkmoonFlasksDButtonFSD:SetPoint("BOTTOMRIGHT", DarkmoonFlasksDButton)
	DarkmoonFlasksDButton.DarkmoonFlasksDButtonFSD:SetFont("Fonts\\FRIZQT__.TTF", 14, "THINOUTLINE")
	--DarkmoonFlasksDButtonFSD:SetShadowOffset(1, -1)--Optional
	DarkmoonFlasksDButton.DarkmoonFlasksDButtonFSD:SetTextColor(1, 1, 1);
	
	DarkmoonFlasksDButton.DarkmoonFlasksDButtonFSU = DarkmoonFlasksDButton:CreateFontString("FontString", "OVERLAY", "GameTooltipText")
	DarkmoonFlasksDButton.DarkmoonFlasksDButtonFSU:SetPoint("TOPRIGHT", DarkmoonFlasksDButton)
	DarkmoonFlasksDButton.DarkmoonFlasksDButtonFSU:SetFont("Fonts\\FRIZQT__.TTF", 14, "THINOUTLINE")
	--DarkmoonFlasksDButtonFSU:SetShadowOffset(1, -1)--Optional
	DarkmoonFlasksDButton.DarkmoonFlasksDButtonFSU:SetTextColor(1, 1, 1);
	DarkmoonFlasksDButton:Hide()
	DarkmoonFlasksDButton:HookScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
		GameTooltip:SetHyperlink(itemLink)
		GameTooltip:Show()
	end)
	DarkmoonFlasksDButton:HookScript("OnLeave", GameTooltip_Hide)
end

local cache_writer = CreateFrame('Frame')
local wait = {}

cache_writer:SetScript('OnEvent', function(self, event, ...)
	if event == 'GET_ITEM_INFO_RECIEVED' then
		-- the info is now downloaded and cached
		local itemID = ...
		if wait[itemID] then
			--print(itemID,"received")
			createOneButton(itemID)
			wait[itemID] = nil
		end
	end
end)

cache_writer:RegisterEvent('GET_ITEM_INFO_RECIEVED')

local function createButtons()
	local where_stage = true
	--local temp = 1
	for index = 1, numIte, 1 do
		local itemID = itemset[index]
		stage[itemID] = where_stage
		where_stage = not where_stage
		--which[itemID] = floor(index+temp)/2
		which[itemID] = floor(index/2)
		--if temp == 1 then temp = 0 else temp = 1 end
		local name = GetItemInfo(itemID)
		if name then
			createOneButton(itemID)
		else
			--add item to wait list
			wait[itemID] = {}
			
		end
	end
end

local function updateCount()
	for index = 1, numIte, 1 do
		local itemID = itemset[index]
		--local _, itemLink = GetItemInfo(itemID)
		--print(itemLink)
		--if itemLink then -- on unseen items error
		if _G["DarkmoonFlasksDButton"..itemID] then
			local something = _G["DarkmoonFlasksDButton"..itemID]
			local itemcount = GetItemCount(itemID, false, false)
			--print(itemID, itemcount)
			local itemcount_bank = GetItemCount(itemID, true, false)
			something.DarkmoonFlasksDButtonFSD:SetFormattedText("%.0f", itemcount)
			something.DarkmoonFlasksDButtonFSD:Show()
			something.DarkmoonFlasksDButtonFSU:Hide()
			if itemcount ~= itemcount_bank then
				something.DarkmoonFlasksDButtonFSU:SetFormattedText("%.0f", itemcount_bank)
				something.DarkmoonFlasksDButtonFSU:Show()
			end
			--something:Show()
			if itemcount_bank == 0 then
				something:GetNormalTexture():SetDesaturated(true);
			else
				something:GetNormalTexture():SetDesaturated(false);
			end
			_G["DarkmoonFlasksDButton"..itemID] = something
		end
	end
end

local DarkmoonFlasksInitFrame = CreateFrame("Frame", "DarkmoonFlasksInitFrame", DarkmoonFlasksDragFrame)
DarkmoonFlasksInitFrame:RegisterEvent("PLAYER_LOGIN")
DarkmoonFlasksInitFrame:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_LOGIN" then
		createButtons()
		--print("Darkmoon flasks init login")
		updateCount()
		--self:RegisterEvent("BAG_UPDATE")
		self:RegisterEvent("BAG_UPDATE_DELAYED")
	end
	--if event == "BAG_UPDATE" then
	if event == "BAG_UPDATE_DELAYED" then
		--print("Darkmoon flasks init BAG_UPDATE_DELAYED")
		updateCount()
	end
end)

--DarkmoonFlasksMM Slash Setup
local RegisteredEvents = {};
local DarkmoonFlasksMMslash = CreateFrame("Frame", "DarkmoonFlasksSlash", UIParent)

DarkmoonFlasksMMslash:SetScript("OnEvent", function (self, event, ...) 
	if (RegisteredEvents[event]) then 
		return RegisteredEvents[event](self, event, ...) 
	end
end)

function RegisteredEvents:ADDON_LOADED(event, addon, ...)
	if (addon == addonname) then
		SLASH_DarkmoonFlasks1 = '/dmflasks'
		SlashCmdList["DarkmoonFlasks"] = function (msg, editbox)
			DarkmoonFlasks.SlashCmdHandler(msg, editbox)	
		end
		DEFAULT_CHAT_FRAME:AddMessage("DarkmoonFlasks loaded. Type /dmflasks for usage",0, 0.75, 1)
	end
end

for k, v in pairs(RegisteredEvents) do
	DarkmoonFlasksMMslash:RegisterEvent(k)
end

function DarkmoonFlasks.ShowHelp()
	print("DarkmoonFlasks Slash commands (/dmflasks):")
	print("  /dmflasks lock: Locks all DarkmoonFlasks movable frames.")
	print("  /dmflasks unlock: Unlocks all DarkmoonFlasks movable frames.")
	print("  /dmflasks config: Open the DarkmoonFlasks addon config menu.")
	print("  /dmflasks reset:  Resets DarkmoonFlasks frames to default positions.")
end

function DarkmoonFlasks.SetConfigToDefaults()
	print("Resetting config to defaults")
	reset_position_reload()
end

function DarkmoonFlasks.PrintPerformanceData()
	UpdateAddOnMemoryUsage()
	local mem = GetAddOnMemoryUsage("DarkmoonFlasks")
	print("DarkmoonFlasks is currently using " .. mem .. " kbytes of memory")
	collectgarbage(collect)
	UpdateAddOnMemoryUsage()
	mem = GetAddOnMemoryUsage("DarkmoonFlasks")
	print("DarkmoonFlasks is currently using " .. mem .. " kbytes of memory after garbage collection")
end

function DarkmoonFlasks.SlashCmdHandler(msg, editbox)
	--print("command is " .. msg .. "\n")
	if (string.lower(msg) == "config") then
		InterfaceOptionsFrame_OpenToCategory("DarkmoonFlasks");
	elseif (string.lower(msg) == "lock") then
		dvMMlockcheckframe:Hide()
		dvMMlockcheck:SetChecked(true)
	elseif (string.lower(msg) == "unlock") then
		dvMMlockcheckframe:Show()
		dvMMlockcheck:SetChecked(false)
	elseif (string.lower(msg) == "reset") then
		reset_position_reload()
	elseif (string.lower(msg) == "perf") then
		DarkmoonFlasks.PrintPerformanceData()
	else
		DarkmoonFlasks.ShowHelp()
	end
end
SlashCmdList["DarkmoonFlasks"] = DarkmoonFlasks.SlashCmdHandler;

-- itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, 
-- itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = 
-- GetItemInfo(itemID or "itemString" or "itemName" or "itemLink")

local DarkmoonFlasksShowHideButtontooltipText
local flask_State
local function set_showhide_state(state)
	if state then
		DarkmoonFlasksShowHideButtontooltipText = "Shows buttons for Darkmoon Draughts and Tinctures in your bags." --Creates a tooltip on mouseover.
		_G[DarkmoonFlasksShowHideButton:GetName() .. "Text"]:SetText("Show")
	else
		DarkmoonFlasksShowHideButtontooltipText = "Hides buttons for Darkmoon Draughts and Tinctures." --Creates a tooltip on mouseover.
		_G[DarkmoonFlasksShowHideButton:GetName() .. "Text"]:SetText("Hide")
	end
	flask_State = not state
end
local function toggle_showhide_state()
	--print(flask_State,"flask state")
	set_showhide_state(flask_State)
	--flask_State = not flask_State
end

local function darkmoon_hide()
	--print("reseting frames")
	--pairs don't preserve order
	for index =1, numIte, 1 do
		local itemID = itemset[index]
		--print(index,itemname,"loop")
		local something = _G["DarkmoonFlasksDButton"..itemID]
		--print(something)
		if something:IsShown() then something:Hide() end
		_G["DarkmoonFlasksDButton"..itemID]=something
	end
end

local function darkmoon_show()
	--print("showing frames")
	--pairs don't preserve order
	for index =1, numIte, 1 do
		local itemID = itemset[index]
		--print(index,itemname,"loop")
		local something = _G["DarkmoonFlasksDButton"..itemID]
		--print(something)
		something:Show()
		_G["DarkmoonFlasksDButton"..itemID]=something
	end
end

local updater = CreateFrame("Frame")

local function DarkmoonFlasksShowHideButton_OnEnter(self)
	--print("showhideon enter")
	GameTooltip:SetOwner(DarkmoonFlasksShowHideButton, "ANCHOR_RIGHT");
	GameTooltip:SetText(DarkmoonFlasksShowHideButtontooltipText, 1, 1, 1, 1, true)
	GameTooltip:Show()
end

local function DarkmoonFlasksShowHideButton_OnLeave(self)
	GameTooltip_Hide()
end

local function darkmoon_visibility_change()
	if InCombatLockdown() then
		updater:RegisterEvent("PLAYER_REGEN_ENABLED")
		if flask_State then
			print("buttons will be hidden after exiting the combat")
		else
			print("buttons will be displayed after exiting the combat")
		end
	else
		if flask_State then darkmoon_hide() else darkmoon_show() end
		toggle_showhide_state()
		DarkmoonFlasksShowHideButton_OnEnter()
	end
end


updater:SetScript("OnEvent", function(self, event,arg1)
	if event == "PLAYER_REGEN_ENABLED" then
		darkmoon_visibility_change()
		self:UnregisterEvent(event)
	end
end)				




local DarkmoonFlasksShowHideButton = CreateFrame("Button", "DarkmoonFlasksShowHideButton", DarkmoonFlasksDragFrame, "UIPanelButtonTemplate")
DarkmoonFlasksShowHideButton:RegisterEvent("ADDON_LOADED")
DarkmoonFlasksShowHideButton:ClearAllPoints()
DarkmoonFlasksShowHideButton:SetPoint("BOTTOMLEFT", DarkmoonFlasksDragFrame, "BOTTOMLEFT", 20, 20)
DarkmoonFlasksShowHideButton:SetScale(1)
DarkmoonFlasksShowHideButton:SetWidth(125)
DarkmoonFlasksShowHideButton:SetHeight(30)
DarkmoonFlasksShowHideButton:Show()
DarkmoonFlasksShowHideButton:SetScript("OnEnter", DarkmoonFlasksShowHideButton_OnEnter)
DarkmoonFlasksShowHideButton:SetScript("OnLeave", DarkmoonFlasksShowHideButton_OnLeave)
DarkmoonFlasksShowHideButton:SetScript("OnEvent", function(self, event, arg1)
	if arg1 == addonname then
		set_showhide_state(true)
		--DarkmoonFlasksShowHideButtontooltipText = "Show buttons for Darkmoon Draughts and Tinctures in your bags." --Creates a tooltip on mouseover.
		--_G[DarkmoonFlasksShowHideButton:GetName() .. "Text"]:SetText("Show")
	end
end)

DarkmoonFlasksShowHideButton:SetScript("OnClick", function(self, button, up)
	--print(flask_State,"flask_State on click")
	darkmoon_visibility_change()
	--DarkmoonFlasksShowHideButton_OnEnter() --might change tooltips on combat despite not doing anything
	--print("showhideon enter_click")
end)

--local breaktext = "Creates error message"--Creates a tooltip on mouseover.	
local breaktext = "Resets position of frame"--Creates a tooltip on mouseover.	
local function DarkmoonFlasksBreakButton_OnEnter(self)
	GameTooltip:SetOwner(DarkmoonFlasksBreakButton, "ANCHOR_RIGHT");
	GameTooltip:SetText(breaktext, 1, 1, 1, 1, true)
	GameTooltip:Show()
end

local function DarkmoonFlasksBreakButton_OnLeave(self)
	GameTooltip_Hide()
 end

local DarkmoonFlasksBreakButton = CreateFrame("Button", "DarkmoonFlasksBreakButton", DarkmoonFlasksDragFrame, "UIPanelButtonTemplate")
DarkmoonFlasksBreakButton:RegisterEvent("ADDON_LOADED")
DarkmoonFlasksBreakButton:ClearAllPoints()
DarkmoonFlasksBreakButton:SetPoint("BOTTOMLEFT", DarkmoonFlasksDragFrame, "BOTTOMLEFT", 200, 20)
DarkmoonFlasksBreakButton:SetScale(1)
DarkmoonFlasksBreakButton:SetWidth(125)
DarkmoonFlasksBreakButton:SetHeight(30)
DarkmoonFlasksBreakButton:Show()
DarkmoonFlasksBreakButton:SetScript("OnEnter", DarkmoonFlasksBreakButton_OnEnter)
DarkmoonFlasksBreakButton:SetScript("OnLeave", DarkmoonFlasksBreakButton_OnLeave)

DarkmoonFlasksBreakButton:SetScript("OnEvent", function(self, event, arg1)
	if arg1 == addonname then
		--_G[DarkmoonFlasksBreakButton:GetName() .. "Text"]:SetText("Break me")
		_G[DarkmoonFlasksBreakButton:GetName() .. "Text"]:SetText("Reset position")
	end
end)

local function break_me()
	--would be good to make more interesting way to generate error
	print(format("%F", "error"))
end
--DarkmoonFlasksBreakButton:HookScript("OnClick", break_me)
DarkmoonFlasksBreakButton:HookScript("OnClick", reset_position)
