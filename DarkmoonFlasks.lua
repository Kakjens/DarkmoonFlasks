--SavedVariables Setup -- no need for saved variables
-- fix for total seling- maybe just extra line with sell all
-- in game tooltip add extra info un brackets - how many there are those items, icluding bank
-- additional addon for potions - if there are no mana and healing potions, don't create frame for them
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
local DarkmoonFlasksMMtitle=CreateFrame("Frame", "DarkmoonFlasksMMtitle", DarkmoonFlasksPanel)
	DarkmoonFlasksMMtitle:SetPoint("TOPLEFT", 5, -5)
	DarkmoonFlasksMMtitle:SetScale(2.0)
	DarkmoonFlasksMMtitle:SetWidth(150)
	DarkmoonFlasksMMtitle:SetHeight(50)
	DarkmoonFlasksMMtitle:Show()

local DarkmoonFlasksMMtitleFS = DarkmoonFlasksMMtitle:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	DarkmoonFlasksMMtitleFS:SetText('|cff00c0ffDarkmoonFlasks|r')
	DarkmoonFlasksMMtitleFS:SetPoint("TOPLEFT", 0, 0)
	DarkmoonFlasksMMtitleFS:SetFont("Fonts\\FRIZQT__.TTF", 10)
	
local DarkmoonFlasksMMresetcheck = CreateFrame("Button", "DarkmoonFlasksMMResetButton", DarkmoonFlasksPanel, "UIPanelButtonTemplate")
	DarkmoonFlasksMMresetcheck:ClearAllPoints()
	DarkmoonFlasksMMresetcheck:SetPoint("BOTTOMLEFT", 5, 5)
	DarkmoonFlasksMMresetcheck:SetScale(1.25)
	DarkmoonFlasksMMresetcheck:SetWidth(125)
	DarkmoonFlasksMMresetcheck:SetHeight(30)
	_G[DarkmoonFlasksMMresetcheck:GetName() .. "Text"]:SetText("Reset to Default")
	DarkmoonFlasksMMresetcheck:SetScript("OnClick", function (self, button, down)
		reset_position_reload()
end)



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

local DarkmoonFlasksMMlockcheck = CreateFrame("CheckButton", "DarkmoonFlasksLockAll", DarkmoonFlasksPanel, "InterfaceOptionsCheckButtonTemplate")
	DarkmoonFlasksMMlockcheck:ClearAllPoints()
	DarkmoonFlasksMMlockcheck:SetPoint("TOPLEFT", 25, -50)
	DarkmoonFlasksMMlockcheck:SetScale(1.25)
	_G[DarkmoonFlasksMMlockcheck:GetName() .. "Text"]:SetText("Lock all frames")
	DarkmoonFlasksMMlockcheck.tooltipText = 'Checked locks all DarkmoonFlasks frames. Unchecked unlocks all DarkmoonFlasks frames. Currently does not work.' --Creates a tooltip on mouseover.
	DarkmoonFlasksMMlockcheck:SetChecked(true)
	
	DarkmoonFlasksMMlockcheckframe=CreateFrame("Frame", "DarkmoonFlasksMMlockcheckframe", UIParent)
	DarkmoonFlasksMMlockcheckframe:SetClampedToScreen(1)
	DarkmoonFlasksMMlockcheckframe:SetFrameStrata(BACKGROUND)
	DarkmoonFlasksMMlockcheckframe:SetFrameLevel("1")
	DarkmoonFlasksMMlockcheckframe:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT")
	DarkmoonFlasksMMlockcheckframe:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT")
	DarkmoonFlasksMMlockcheckframe:Hide()
	
	-- Lock/Unlock Frames
	DarkmoonFlasksMMlockcheck:SetScript("OnClick", function(self,button,down) 
		if self:GetChecked(true) then
			DarkmoonFlasksMMlockcheckframe:Hide()
		else
			DarkmoonFlasksMMlockcheckframe:Show()
		end
	end)
	
--Open Categaories Fix
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

-- DarkmoonFlasks

	
-- itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, 
-- itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = 
-- GetItemInfo(itemID or "itemString" or "itemName" or "itemLink")

local function ddebug(name,context)
	local status = issecurevariable(name)
	local info = "Frame %s is %s tainted "
	local addend = ""
	if status then addend = "not" end
	info = format(info,name,addend)
	print(info,context)
end

local darkmoonflasks = {}
darkmoonflasks = {
[1] = "Darkmoon Draught of Supremacy",
[2] = "Darkmoon Tincture of Supremacy",
[3] = "Darkmoon Draught of Flexibility",
[4] = "Darkmoon Tincture of Flexibility",
[5] = "Darkmoon Draught of Precision",
[6] = "Darkmoon Tincture of Precision",
[7] = "Darkmoon Draught of Divergence",
[8] = "Darkmoon Tincture of Divergence",
[9] = "Darkmoon Draught of Alacrity",
[10] = "Darkmoon Tincture of Alacrity",
[11] = "Darkmoon Draught of Deftness",
[12] = "Darkmoon Tincture of Deftness",
[13] = "Darkmoon Draught of Deflection",
[14] = "Darkmoon Tincture of Deflection",
[15] = "Darkmoon Draught of Defense",
[16] = "Darkmoon Tincture of Defense",
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

local string0, string1, string2
local itemset = {}
local what_to_do = "Darkmoon"
--local what_to_do = "Potions"
if (what_to_do == "Darkmoon") then
	string0 = "Darkmoon"
	string1 = "Draught"
	string2 = "Tincture"
	itemset = darkmoonflasks
else
	string0 = "Potion"
	string1 = "Healing"
	string2 = "Mana"
	itemset = potions
end
local numIte = #itemset

local function darkmoon_reseter()
	--print("reseting frames")
	--pairs don't preserve order
	for index =1, numIte, 1 do
		local itemname = itemset[index]
		--print(index,itemname,"loop")
		local something = _G["DarkmoonDButton"..itemname]
		--print(something)
		if something:IsShown() then something:Hide() end
		_G["DarkmoonDButton"..itemname]=something
	end
end
local frames_need = true
local function darkmoon_frame_create()
	--Most probably darkmoon_frame_create and dosomething will need to be merged because GetItemInfo gets info only from previosuly seen items
	--Easy fix might be commenting out frames_need = false in next line. A check if ~_G["DarkmoonDButton"..itemname] then before creation of frame could also be involved.
	--Would prefer to use seperate fucntions for creation and update
	--frames_need = false
	--print("creating frames")
	local Rcount = 0
	local Ucount = 0
	local w = 36
	local w1 = w * 1.1
	local h = 36
	local h1 = h * 1.1
	local x = 0
	local y = 0
	for index = 1, numIte, 1 do
		local itemname = itemset[index]
		local _, itemLink, _,_,_,_,_,_,_,itemTexture,_ = GetItemInfo(itemname)
		--local texture = select(10,GetItemInfo(itemname))
		if string.find(itemname,string1) then
			x = Rcount * w1
			y = h1
			Rcount = Rcount+1
		end
		if string.find(itemname,string2) then
			x = Ucount * w1
			y = 0
			Ucount = Ucount + 1
		end
		--print(itemname,itemName)
		if not _G["DarkmoonDButton"..itemname] then
		local DarkmoonFlasksDButton = CreateFrame("Button", "DarkmoonDButton"..itemname, DarkmoonFlasksDragFrame, "SecureActionButtonTemplate");
			DarkmoonFlasksDButton:RegisterForClicks("AnyUp")
			DarkmoonFlasksDButton:ClearAllPoints()
			DarkmoonFlasksDButton:SetPoint("BOTTOMLEFT", x+20, y+52)
			DarkmoonFlasksDButton:SetSize(w, h)
			DarkmoonFlasksDButton:SetNormalTexture(itemTexture)
			DarkmoonFlasksDButton:SetPushedTexture(itemTexture)
			DarkmoonFlasksDButton:SetHighlightTexture(itemTexture)
			DarkmoonFlasksDButton:SetAttribute("type", "item")
			DarkmoonFlasksDButton:SetAttribute("item",itemname)
			--DarkmoonFlasksDButton:HookScript("OnMouseUp", function(self) 
				--print(name)
				--self:SetScale(1)
				--print("what is this?")
			--end)
		local function OnEnter(self)
			GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
			--local text = self.Count
			--text:SetText(itemcount);
			print("will this be visible?")
			if itemLink then
				GameTooltip:SetHyperlink(itemLink)
			end
			--GameTooltip:AddLine(itemcount)
			GameTooltip:Show()
		end

		local function OnLeave(self)
			--print("onleave")
			GameTooltip:Hide()
		end
		DarkmoonFlasksDButton.DarkmoonFlasksDButtonFSD = DarkmoonFlasksDButton:CreateFontString("FontString", "OVERLAY", "GameTooltipText")
			--DarkmoonFlasksDButtonFSD:Hide()
			--DarkmoonFlasksDButtonFSD:ClearAllPoints()
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
		DarkmoonFlasksDButton:SetScript("OnEnter", OnEnter)
		DarkmoonFlasksDButton:SetScript("OnLeave", OnLeave)
		_G["DarkmoonDButton"..itemname] = DarkmoonFlasksDButton
		end
	end
end

local DarkmoonFlasksShowHideButtontooltipText
local flask_State
local function set_showhide__state(state)
	if state then
		DarkmoonFlasksShowHideButtontooltipText = "Show buttons for Darkmoon Draughts and Tinctures in your bags." --Creates a tooltip on mouseover.
		_G[DarkmoonFlasksShowHideButton:GetName() .. "Text"]:SetText("Show")
	else
		DarkmoonFlasksShowHideButtontooltipText = "Hide buttons for Darkmoon Draughts and Tinctures." --Creates a tooltip on mouseover.
		_G[DarkmoonFlasksShowHideButton:GetName() .. "Text"]:SetText("Hide")
	end
	flask_State = not state
end
local function toggle_showhide__state()
	--print(flask_State,"flask state")
	set_showhide__state(flask_State)
	--flask_State = not flask_State
end

local updater = CreateFrame("Frame")
local change = true
local function darkmoon_frame_update()
	if InCombatLockdown() then
		updater:RegisterEvent("PLAYER_REGEN_ENABLED")
		print("buttons will be create after exiting the combat")
	else
		if frames_need then darkmoon_frame_create() end
		darkmoon_reseter()
		if change then toggle_showhide__state() end
		change = true
		--set_showhide__state(false)
		--DarkmoonFlasksShowHideButtontooltipText = "Hide buttons for Darkmoon Draughts and Tinctures." --Creates a tooltip on mouseover.
		--_G[DarkmoonFlasksShowHideButton:GetName() .. "Text"]:SetText("Hide")
		--flask_State = true
		for index = 1, numIte, 1 do
			local itemname = itemset[index]
			local _, itemLink = GetItemInfo(itemname)
			if itemLink then -- on unseen items error
				local something = _G["DarkmoonDButton"..itemname]
				local function real_OnEnter(self)
					--local itemcount=GetItemCount(name,false,false)
					GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
					GameTooltip:SetHyperlink(itemLink)
					--print("for some reason it gets printed")
					--GameTooltip:AddLine(itemcount)
					GameTooltip:Show()
				end
				local itemcount = GetItemCount(itemname, false, false)
				--print(itemname, itemcount)
				local itemcount_bank = GetItemCount(itemname, true, false)
				something.DarkmoonFlasksDButtonFSD:SetFormattedText("%.0f", itemcount)
				something.DarkmoonFlasksDButtonFSD:Show()
				something.DarkmoonFlasksDButtonFSU:Hide()
				if itemcount ~= itemcount_bank then
					something.DarkmoonFlasksDButtonFSU:SetFormattedText("%.0f", itemcount_bank)
					something.DarkmoonFlasksDButtonFSU:Show()
				end
				something:SetScript("OnEnter", real_OnEnter)
				something:Show()
				_G["DarkmoonDButton"..itemname] = something
			end
		end
	end
end

--updater:RegisterEvent("LOOT_CLOSED")
--updater:RegisterEvent("BAG_UPDATE")
updater:RegisterEvent("BAG_UPDATE_DELAYED")
updater:SetScript("OnEvent", function(self, event,arg1)
	if flask_State then
		change = false
		darkmoon_frame_update()
	end
	if event == "PLAYER_REGEN_ENABLED" then self:UnregisterEvent(event) end
end)				


local function DarkmoonFlasksShowHideButton_OnEnter(self)
	--print("showhideon enter")
	GameTooltip:SetOwner(DarkmoonFlasksShowHideButton, "ANCHOR_RIGHT");
	GameTooltip:SetText(DarkmoonFlasksShowHideButtontooltipText, 1, 1, 1, 1, true)
	GameTooltip:Show()
end

local function DarkmoonFlasksShowHideButton_OnLeave(self)
	GameTooltip_Hide()
end

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
		set_showhide__state(true)
		--DarkmoonFlasksShowHideButtontooltipText = "Show buttons for Darkmoon Draughts and Tinctures in your bags." --Creates a tooltip on mouseover.
		--_G[DarkmoonFlasksShowHideButton:GetName() .. "Text"]:SetText("Show")
	end
end)

DarkmoonFlasksShowHideButton:SetScript("OnClick", function(self, button, up)
	--print(flask_State,"flask_State on click")
	if flask_State then
		if InCombatLockdown() then 
			print("can't hide during combat")
		else
			darkmoon_reseter()
			toggle_showhide__state()
			--DarkmoonFlasksShowHideButtontooltipText = "Show buttons for Darkmoon Draughts and Tinctures in your bags." --Creates a tooltip on mouseover.
			--_G[DarkmoonFlasksShowHideButton:GetName() .. "Text"]:SetText("Show")
			--flask_State = false
			--print("Hide")
		end
	else
		--print("onclick")
		darkmoon_frame_update()
	end
	DarkmoonFlasksShowHideButton_OnEnter()
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
