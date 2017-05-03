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
[1] = 118, --"Minor Healing Potion",
[3] = 858, --"Lesser Healing Potion",
[5] = 929, --"Healing Potion",
[7] = 1710, --"Greater Healing Potion",
[9] = 3928, --"Superior Healing Potion",
[11] = 13446, --"Major Healing Potion",
[13] = 22829, --"Super Healing Potion",
[15] = 39671, --"Resurgent Healing Potion",
[17] = 33447, --"Runic Healing Potion",
[19] = 57191, --"Mythical Healing Potion",
[21] = 76097, --"Master Healing Potion",
[23] = 109223, --"Healing Tonic",
[25] = 127834, --"Ancient Healing Potion",
[2] = 2455, --"Minor Mana Potion",
[4] = 3385, --"Lesser Mana Potion",
[6] = 3827, --"Mana Potion",
[8] = 6149, --"Greater Mana Potion",
[10] = 13443, --"Superior Mana Potion",
[12] = 13444, --"Major Mana Potion",
[14] = 22832, --"Super Mana Potion",
[16] = 40067, --"Icy Mana Potion",
[18] = 33448, --"Runic Mana Potion",
[20] = 57192, --"Mythical Mana Potion",
[22] = 76098, --"Master Mana Potion",
[24] = 109222, --"Draenic Mana Potion",
[26] = 127835, --"Ancient Mana Potion"
}

local itemset = {}
local what_to_do = "Darkmoon"
--local what_to_do = "Potions"
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

local private = {}
private.defaults = {}
private.defaults.DarkmoonFlasksCheckboxes = {
	hide_if_none_at_bag = true,
	but_show_if_there_are_in_bank = true,
	frame_visible = true,
}
private.db = {}
private.db.DarkmoonFlasksCheckboxes = {}


local loader = CreateFrame("Frame")
loader:RegisterEvent("ADDON_LOADED")
	loader:SetScript("OnEvent", function(self, event, arg1)
		if event == "ADDON_LOADED" and arg1 == addonname then
			local function initDB(db, defaults)
				if type(db) ~= "table" then db = {} end
				if type(defaults) ~= "table" then return db end
				for k, v in pairs(defaults) do
					if type(v) == "table" then
						db[k] = initDB(db[k], v)
					elseif type(v) ~= type(db[k]) then
						db[k] = v
					end
				end
				return db
			end
			DarkmoonFlasksDB = initDB(DarkmoonFlasksDB, private.defaults)
			private.db = DarkmoonFlasksDB
			self:UnregisterEvent(event)
		end
	end)


if false then
--Open Categaories Fix --why it's needed, let it  remain just in case
do
	local function get_panel_name(panel)
		local tp = type(panel)
		local cat = INTERFACEOPTIONS_ADDONCATEGORIES
		if tp == "string" then
			for i = 1, #cat do
				local p = cat[i]
				if p.name == panel then
					if p.parent then
						return get_panel_name(p.parent)
					else
						return panel
					end
				end
			end
		elseif tp == "table" then
			for i = 1, #cat do
				local p = cat[i]
				if p == panel then
					if p.parent then
						return get_panel_name(p.parent)
					else
						return panel.name
					end
				end
			end
		end
	end

	local function InterfaceOptionsFrame_OpenToCategory_Fix(panel)
		if doNotRun or InCombatLockdown() then return end
		local panelName = get_panel_name(panel)
		if not panelName then return end -- if its not part of our list return early
		local noncollapsedHeaders = {}
		local shownpanels = 0
		local mypanel
		local t = {}
		local cat = INTERFACEOPTIONS_ADDONCATEGORIES
		for i = 1, #cat do
			local panel = cat[i]
			if not panel.parent or noncollapsedHeaders[panel.parent] then
				if panel.name == panelName then
					panel.collapsed = true
					t.element = panel
					InterfaceOptionsListButton_ToggleSubCategories(t)
					noncollapsedHeaders[panel.name] = true
					mypanel = shownpanels + 1
				end
				if not panel.collapsed then
					noncollapsedHeaders[panel.name] = true
				end
				shownpanels = shownpanels + 1
			end
		end
		local Smin, Smax = InterfaceOptionsFrameAddOnsListScrollBar:GetMinMaxValues()
		if shownpanels > 15 and Smin < Smax then 
		  local val = (Smax/(shownpanels-15))*(mypanel-2)
		  InterfaceOptionsFrameAddOnsListScrollBar:SetValue(val)
		end
		doNotRun = true
		InterfaceOptionsFrame_OpenToCategory(panel)
		doNotRun = false
	end

	hooksecurefunc("InterfaceOptionsFrame_OpenToCategory", InterfaceOptionsFrame_OpenToCategory_Fix)
end
end
	
local DarkmoonFlasks
DarkmoonFlasks = {};

DarkmoonFlasks.panel = CreateFrame( "Frame", "DarkmoonFlasksPanel", UIParent );
-- Register in the Interface Addon Options GUI
-- Set the name for the Category for the Options Panel
DarkmoonFlasks.panel.name = "DarkmoonFlasks";
-- Add the panel to the Interface Options
InterfaceOptions_AddCategory(DarkmoonFlasks.panel);

-- Make a child panel
-- DarkmoonFlasks.childpanel = CreateFrame( "Frame", "DarkmoonFlasksChild", DarkmoonFlasks.panel);
-- DarkmoonFlasks.childpanel.name = "MyChild";
-- Specify childness of this panel (this puts it under the little red [+], instead of giving it a normal AddOn category)
-- DarkmoonFlasks.childpanel.parent = DarkmoonFlasks.panel.name;
-- Add the child to the Interface Options
-- InterfaceOptions_AddCategory(DarkmoonFlasks.childpanel);

--Panel Title
local DarkmoonFlasksDtitle=CreateFrame("Frame", "DarkmoonFlasksDtitle", DarkmoonFlasksPanel)
	DarkmoonFlasksDtitle:SetPoint("TOPLEFT", 5, -5)
	DarkmoonFlasksDtitle:SetScale(2.0)
	DarkmoonFlasksDtitle:SetWidth(150)
	DarkmoonFlasksDtitle:SetHeight(50)
	DarkmoonFlasksDtitle:Show()

local DarkmoonFlasksDtitleFS = DarkmoonFlasksDtitle:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	DarkmoonFlasksDtitleFS:SetText('|cff00c0ffDarkmoonFlasks|r')
	DarkmoonFlasksDtitleFS:SetPoint("TOPLEFT", 0, 0)
	DarkmoonFlasksDtitleFS:SetFont("Fonts\\FRIZQT__.TTF", 10)
	
local DarkmoonFlasksDresetcheck = CreateFrame("Button", "DarkmoonFlasksDResetButton", DarkmoonFlasksPanel, "UIPanelButtonTemplate")
	DarkmoonFlasksDresetcheck:ClearAllPoints()
	DarkmoonFlasksDresetcheck:SetPoint("BOTTOMLEFT", 5, 5)
	DarkmoonFlasksDresetcheck:SetScale(1.25)
	DarkmoonFlasksDresetcheck:SetWidth(125)
	DarkmoonFlasksDresetcheck:SetHeight(30)
	_G[DarkmoonFlasksDresetcheck:GetName() .. "Text"]:SetText("Reset to Default")
	DarkmoonFlasksDresetcheck:SetScript("OnClick", function (self, button, down)
 		--BeamMeUpDejaDBPC = private.defaults;
		--ReloadUI();
		DarkmoonFlasksDB = private.defaults
		reset_position_reload()
end)

local w = 36
local w1 = w * 1.1
local h = 36
local h1 = h * 1.1
local x
local y

local DarkmoonFlasksDragFrame = CreateFrame("Frame", "DarkmoonFlasksDragFrame", UIParent)
DarkmoonFlasksDragFrame:ClearAllPoints()
DarkmoonFlasksDragFrame:SetPoint("CENTER", 0, 0)
DarkmoonFlasksDragFrame:SetScale(1)
DarkmoonFlasksDragFrame:SetWidth(floor(w1*numIte/2+17))
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

local button_Count = 0

local function createOneButton(itemID)
	local name, itemLink, _,_,_,_,_,_,_,itemTexture,_ = GetItemInfo(itemID)
	--print("create",itemLink)
	if not _G["DarkmoonFlasksDButton"..itemID] then
	button_Count = button_Count + 1
	local DarkmoonFlasksDButton = CreateFrame("Button", "DarkmoonFlasksDButton"..itemID, DarkmoonFlasksDragFrame, "SecureActionButtonTemplate")
	if stage[itemID] then y = h1 else y = 0 end
	--x = (which[itemID] -1) * w1
	x = (which[itemID]) * w1
	--print(itemname,itemName)
	DarkmoonFlasksDButton:RegisterForClicks("AnyUp")
	DarkmoonFlasksDButton:ClearAllPoints()
	DarkmoonFlasksDButton:SetPoint("BOTTOMLEFT", x-30, y+52)
	DarkmoonFlasksDButton:SetSize(w, h)
	DarkmoonFlasksDButton:SetNormalTexture(itemTexture)
	DarkmoonFlasksDButton:SetPushedTexture(itemTexture)
	DarkmoonFlasksDButton:SetHighlightTexture(itemTexture)
	DarkmoonFlasksDButton:SetAttribute("type", "item")
	DarkmoonFlasksDButton:SetAttribute("item",name)
	
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
	else
		print("trying to recreate",itemID)
	end
end

local warning = true
local updater1 = CreateFrame("Frame")

local flask_State

local function updateCount()
	if InCombatLockdown() then
		updater1:RegisterEvent("PLAYER_REGEN_ENABLED")
	else
	if button_Count == numIte then --is this check needed?
		--print("flask state", flask_State)
		if flask_State then
			local hide_if_none_at_bag = private.db.DarkmoonFlasksCheckboxes.hide_if_none_at_bag
			local but_show_if_there_are_in_bank = private.db.DarkmoonFlasksCheckboxes.but_show_if_there_are_in_bank
			for index = 1, numIte, 1 do
				local itemID = itemset[index]
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
				if not InCombatLockdown() then
					something:Show()
					if hide_if_none_at_bag then
						if itemcount == 0 then something:Hide() end
					end
				end
				if itemcount_bank == 0 then
					something:GetNormalTexture():SetDesaturated(true);
				else
					something:GetNormalTexture():SetDesaturated(false);
				end
				if but_show_if_there_are_in_bank then
					if itemcount_bank > 0 then something:Show() end
					if itemcount == 0 then
						something:GetNormalTexture():SetDesaturated(true);
					else
						something:GetNormalTexture():SetDesaturated(false);
					end
				end
			
				--if hide_if_none_at_bag and but_show_if_there_are_in_bank then
				--	if itemcount == 0 then
				--		if itemcount_bank == 0 then
				--			something:Hide()
				--		else
				--		end
				--	end
				--end
				--end
				_G["DarkmoonFlasksDButton"..itemID] = something
			end
		end
	end
	end
end

updater1:SetScript("OnEvent", function(self, event,arg1)
	if event == "PLAYER_REGEN_ENABLED" then
		warning = true
		updateCount()
		self:UnregisterEvent(event)
	end
end)				

local DarkmoonFlasksHideCheck = CreateFrame("CheckButton", "DarkmoonFlasksHideCheck", DarkmoonFlasksPanel, "InterfaceOptionsCheckButtonTemplate")
	DarkmoonFlasksHideCheck:RegisterEvent("ADDON_LOADED")
	DarkmoonFlasksHideCheck:ClearAllPoints()
	DarkmoonFlasksHideCheck:SetPoint("TOPLEFT", 25, -50)
	DarkmoonFlasksHideCheck:SetScale(1.25)
	_G[DarkmoonFlasksHideCheck:GetName() .. "Text"]:SetText("Hide icon for Darkmoon elixir if none in bag")
	DarkmoonFlasksHideCheck.tooltipText = 'Checked hides icons for Darkmoon elixirs which are not in bag. Unchecked shows all possible Darkmoon elixirs.' --Creates a tooltip on mouseover.
	
	DarkmoonFlasksHideCheck:SetScript("OnEvent", function(self, button, up)
		local checked = private.db.DarkmoonFlasksCheckboxes.hide_if_none_at_bag
		self:SetChecked(checked)
		--private.db.DarkmoonFlasksCheckboxes.hide_if_none_at_bag = checked --???
	end)

	DarkmoonFlasksHideCheck:SetScript("OnClick", function(self, button, up)
		local checked = self:GetChecked()
		if InCombatLockdown() then
			print("Can't chenge during combat")
			self:SetChecked(not state)
		else
			private.db.DarkmoonFlasksCheckboxes.hide_if_none_at_bag = checked
			updateCount()
		end
	end)
		
		


	
local DarkmoonFlasksShowCheck = CreateFrame("CheckButton", "DarkmoonFlasksShowCheck", DarkmoonFlasksPanel, "InterfaceOptionsCheckButtonTemplate")
	DarkmoonFlasksShowCheck:RegisterEvent("ADDON_LOADED")
	DarkmoonFlasksShowCheck:ClearAllPoints()
	DarkmoonFlasksShowCheck:SetPoint("TOPLEFT", 40, -80)
	DarkmoonFlasksShowCheck:SetScale(1.25)
	_G[DarkmoonFlasksShowCheck:GetName() .. "Text"]:SetText("But display icon for Darkmoon elixir if it's in bank")
	DarkmoonFlasksShowCheck.tooltipText = 'Checked displays icons for Darkmoon elixirs which are in bag or bank. Unchecked does nothing. Or not.' --Creates a tooltip on mouseover.
	
	DarkmoonFlasksShowCheck:SetScript("OnEvent", function(self, button, up)
		local checked = private.db.DarkmoonFlasksCheckboxes.but_show_if_there_are_in_bank
		self:SetChecked(checked)
		--private.db.DarkmoonFlasksCheckboxes.but_show_if_there_are_in_bank = checked --???
	end)

	DarkmoonFlasksShowCheck:SetScript("OnClick", function(self, button, up)
		local checked = self:GetChecked()
		if InCombatLockdown() then
			if warning then
				warning = false
				print("Can't chenge during combat")
			end
			self:SetChecked(not state)
		else
			private.db.DarkmoonFlasksCheckboxes.but_show_if_there_are_in_bank = checked
			updateCount()
		end
	
		--private.db.DarkmoonFlasksCheckboxes.but_show_if_there_are_in_bank = self:GetChecked() --previous version
		--updateCount() --previous version
	end)	
	
local DarkmoonFlasksShowHide = CreateFrame("CheckButton", "DarkmoonFlasksShowHide", DarkmoonFlasksPanel, "InterfaceOptionsCheckButtonTemplate")
	DarkmoonFlasksShowHide:RegisterEvent("ADDON_LOADED")
	DarkmoonFlasksShowHide:ClearAllPoints()
	DarkmoonFlasksShowHide:SetPoint("TOPLEFT", 25, -110)
	DarkmoonFlasksShowHide:SetScale(1.25)
	_G[DarkmoonFlasksShowHide:GetName() .. "Text"]:SetText("Toggle for displaying and hiding DarkmoonFlasks frame")
	DarkmoonFlasksShowHide.tooltipText = 'Checked shows DarkmoonFlasks. Unchecked hides DarkmoonFlasks.' --Creates a tooltip on mouseover.
	
local function setframevisibility(state)
	if InCombatLockdown() then
		if warning then
			warning = false
			print("Can't chenge during combat")
		end
		DarkmoonFlasksShowHide:SetChecked(not state)
	else
		if state then
			--DarkmoonFlasksDragFrame:Hide()
			DarkmoonFlasksDragFrame:Show()
			--DarkmoonFlasksShowHideButton:Show()
		else
			--DarkmoonFlasksDragFrame:Show()
			DarkmoonFlasksDragFrame:Hide()
			--DarkmoonFlasksShowHideButton:Hide()
		end
	end
end
	
	
	
	
	DarkmoonFlasksShowHide:SetScript("OnEvent", function(self, button, up)
		local checked = private.db.DarkmoonFlasksCheckboxes.frame_visible
		self:SetChecked(checked)
		setframevisibility(checked)
	end)
	
	DarkmoonFlasksShowHide:SetScript("OnClick", function(self, button, up)
		local checked = self:GetChecked()
		private.db.DarkmoonFlasksCheckboxes.frame_visible = checked
		setframevisibility(checked)
	end)	

	
local wait = {}

local cache_writer = CreateFrame('Frame')
cache_writer:SetScript('OnEvent', function(self, event, ...)
	if event == 'GET_ITEM_INFO_RECEIVED' then
		-- the info is now downloaded and cached
		local itemID = ...
		if wait[itemID] then
			--print(itemID,"received")
			createOneButton(itemID)
			wait[itemID] = nil
		end
	end
end)
cache_writer:RegisterEvent('GET_ITEM_INFO_RECEIVED')

local function createButtons()
	for index = 1, numIte, 1 do
		local itemID = itemset[index]
		local name = GetItemInfo(itemID)
		if name then
			createOneButton(itemID)
		else
			--add item to wait list
			wait[itemID] = {}
		end
	end
end

local DarkmoonFlasksInitFrame = CreateFrame("Frame", "DarkmoonFlasksInitFrame", DarkmoonFlasksDragFrame)
DarkmoonFlasksInitFrame:RegisterEvent("PLAYER_LOGIN")
DarkmoonFlasksInitFrame:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_LOGIN" then
		local where_stage = true
		for index = 1, numIte, 1 do
			local itemID = itemset[index]
			local name = GetItemInfo(itemID)
			stage[itemID] = where_stage
			where_stage = not where_stage
			which[itemID] = ceil(index/2)
		end
		--self:UnregisterUvent(event)
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

local function set_showhide_state(state)
	if state then
		DarkmoonFlasksShowHideButtontooltipText = "Shows buttons for Darkmoon Draughts and Tinctures in your bags. For available ways of displaying of items check Interface Options" --Creates a tooltip on mouseover.
		_G[DarkmoonFlasksShowHideButton:GetName() .. "Text"]:SetText("Show")
	else
		DarkmoonFlasksShowHideButtontooltipText = "Hides buttons for Darkmoon Draughts and Tinctures." --Creates a tooltip on mouseover.
		_G[DarkmoonFlasksShowHideButton:GetName() .. "Text"]:SetText("Hide")
	end
	flask_State = not state
end
local function toggle_showhide_state()
	set_showhide_state(flask_State) --seems like it can be used for toggling
end

local function darkmoon_hide()
	--print("reseting frames")
	--pairs don't preserve order
	for index = 1, numIte, 1 do
		local itemID = itemset[index]
		--print(index,itemname,"loop")
		local something = _G["DarkmoonFlasksDButton"..itemID]
		if something:IsShown() then something:Hide() end
		_G["DarkmoonFlasksDButton"..itemID]=something
	end
end

local need_Buttons = true
local function darkmoon_show()
	--pairs don't preserve order
	if need_Buttons then
		createButtons()
		need_Buttons = false
		DarkmoonFlasksInitFrame:RegisterEvent("BAG_UPDATE_DELAYED")
	end
	for index = 1, numIte, 1 do
		local itemID = itemset[index]
		if not _G["DarkmoonFlasksDButton"..itemID] then
			--print("needed",itemID)
			createOneButton(itemID)
		end
		local something = _G["DarkmoonFlasksDButton"..itemID]
		something:Show()
		_G["DarkmoonFlasksDButton"..itemID]=something
	end
	--print("Darkmoon show")
	updateCount()
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
		toggle_showhide_state()
		if flask_State then darkmoon_show() else darkmoon_hide() end
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
DarkmoonFlasksShowHideButton:SetPoint("BOTTOMLEFT", DarkmoonFlasksDragFrame, "BOTTOMLEFT", 20, 12)
DarkmoonFlasksShowHideButton:SetScale(1)
DarkmoonFlasksShowHideButton:SetWidth(125)
DarkmoonFlasksShowHideButton:SetHeight(30)
DarkmoonFlasksShowHideButton:Show()
DarkmoonFlasksShowHideButton:SetScript("OnEnter", DarkmoonFlasksShowHideButton_OnEnter)
DarkmoonFlasksShowHideButton:SetScript("OnLeave", DarkmoonFlasksShowHideButton_OnLeave)
DarkmoonFlasksShowHideButton:SetScript("OnEvent", function(self, event, arg1)
	if arg1 == addonname then
		set_showhide_state(true)
	end
end)

DarkmoonFlasksShowHideButton:SetScript("OnClick", function(self, button, up)
	darkmoon_visibility_change()
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
--DarkmoonFlasksBreakButton:SetPoint("BOTTOMLEFT", DarkmoonFlasksDragFrame, "BOTTOMLEFT", 200, 15)
DarkmoonFlasksBreakButton:SetPoint("BOTTOMLEFT", DarkmoonFlasksDragFrame, "BOTTOMRIGHT", -145, 12)
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
