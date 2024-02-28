-- Define your addon name
local ADDON_NAME = "AutoBuy"

-- Default items to buy
local defaultItemsToBuy = {
    {name = "Rugged Leather", desiredQuantity = 100}, -- Example item: Rugged Leather
    -- Add more items here in the same format
}

-- Saved variables
if not savedItemsToBuy then
    savedItemsToBuy = {}
end

-- Function to initialize savedItemsToBuy with defaultItemsToBuy
local function InitializeSavedItems()
    if not next(savedItemsToBuy) then
        for _, itemData in ipairs(defaultItemsToBuy) do
            table.insert(savedItemsToBuy, {name = itemData.name, desiredQuantity = itemData.desiredQuantity})
        end
    end
end


-- Create a frame to handle events
local frame = CreateFrame("FRAME", "MyAddonFrame")
frame:RegisterEvent("MERCHANT_SHOW")

-- Function to check and buy items
local function BuyItems()
    print("Test")
    --if MerchantFrame:IsVisible() then
        --print("Test2")
        for _, itemData in ipairs(savedItemsToBuy) do
            local name = itemData.name
            local desiredQuantity = itemData.desiredQuantity
            print(name)
            
            for i = 1, GetMerchantNumItems() do
                local itemName, _, price, quantity, _, _, _ = GetMerchantItemInfo(i)
                local _, _, _, _, _, _, _, itemStackCount = GetItemInfo(itemName)
                if itemStackCount then
                    cleanItemStackCount = itemStackCount
                else
                    cleanItemStackCount = "0"
                end
                local maxStack = GetMerchantItemMaxStack(i)
                local currentStock = GetItemCount(itemName, false, true)
                print(itemName .. " In Bags: " .. currentStock .. " Item stack count: " .. cleanItemStackCount .. " Max stack: " .. maxStack)
                -- Check if the item matches the one we want to buy
                if itemName == name and currentStock < desiredQuantity then
                    local remainingQuantity = desiredQuantity - currentStock
                    local numToBuy = math.min(maxStack, remainingQuantity)
                    print("Buying " .. numToBuy)
                    local totalCost = numToBuy * price
                    
                    if totalCost <= GetMoney() then
                        BuyMerchantItem(i, numToBuy)
                    else
                        print("Not enough money to buy " .. itemName)
                    end
                end
            end
        end
    --end
end

-- Event handler function
local function OnEvent(self, event, ...)
    if event == "MERCHANT_SHOW" then
        BuyItems()
    end
end

-- Register the event handler
frame:SetScript("OnEvent", OnEvent)

-- Configuration Interface
local function InitializeConfig()
    -- Create a configuration panel
    local panel = CreateFrame("FRAME", ADDON_NAME.."ConfigPanel", UIParent)
    panel.name = ADDON_NAME
    panel:RegisterEvent("ADDON_LOADED")

    panel:SetScript("OnEvent", function(self, event, ...)
        panel[event](self, ...) -- call event handlers
    end)

    function panel:ADDON_LOADED(AddOn)
        if AddOn ~= ADDON_NAME then
            return -- not my AddOn
        end
        -- do stuff because this is your AddOn
        -- usually, the first thing you do here is Unregister ADDON_LOADED
        -- because you no longer need it
        -- now set up your saved variables and other "run once" stuff
        --RefreshConfigPanel(panel)
    end

    -- Title
    local title = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 16, -16)
    title:SetText("Auto Buy Configuration")
    
    -- Description
    local desc = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    desc:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
    desc:SetPoint("RIGHT", -32, 0)
    desc:SetJustifyH("LEFT")
    desc:SetText("Set the items and desired quantities to automatically buy from vendors.")
    
    -- Create a button to add a new item
    local addButton = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
    addButton:SetText("Add Item")
    addButton:SetSize(100, 25)
    addButton:SetPoint("TOPLEFT", 200, -10)
    addButton:Hide()
    
    -- Function to add a new item
    local function AddNewItem()
        table.insert(savedItemsToBuy, {name = "New Item", desiredQuantity = 1})
        RefreshConfigPanel(panel)
    end
    
    -- Set the action for the add button
    addButton:SetScript("OnClick", AddNewItem)

    -- Create a button to show items
    local showButton = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
    showButton:SetText("Show list")
    showButton:SetSize(100, 25)
    showButton:SetPoint("TOPLEFT", 200, -10)

    -- Function to show
    local function showItems()
        RefreshConfigPanel(panel)
    end

    -- Set the action for the show button
    showButton:SetScript("OnClick", showItems)

    -- Create a button to Clear items
    local clearButton = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
    clearButton:SetText("Clear Items")
    clearButton:SetSize(100, 25)
    clearButton:SetPoint("TOPLEFT", 550, -10)

    -- Function to clear items
    local function ClearItems()
        if next(savedItemsToBuy) ~= nil then
            StaticPopupDialogs["CLEAR_RITEMS"] = {
                text = "Are you sure you want to remove all items and reload?",
                button1 = "Accept",
                button2 = "Decline",
                OnAccept = function()
                    wipe(savedItemsToBuy)
                    for _, itemData in ipairs(defaultItemsToBuy) do
                        table.insert(savedItemsToBuy, {name = itemData.name, desiredQuantity = itemData.desiredQuantity})
                    end
                    RefreshConfigPanel(panel)
                    ReloadUI()
                end,
                timeout = 0,
                whileDead = true,
                hideOnEscape = true,
                preferredIndex = 3,
            }
            StaticPopup_Show("CLEAR_RITEMS")
        end
    end

    -- Set the action for the clear button
    clearButton:SetScript("OnClick", ClearItems)

    -- Create a button to remove an item
    local function CreateRemoveButton(parent, index)
        local removeButton = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
        removeButton:SetText("Remove")
        removeButton:SetSize(70, 25)
        removeButton:SetPoint("LEFT", parent[ADDON_NAME.."QuantityEditBox"..index], "RIGHT", 10, 0)
        
        removeButton:SetScript("OnClick", function()
            
            for index, _ in ipairs(savedItemsToBuy) do
                local nameEditBox = panel[ADDON_NAME.."NameEditBox"..index]
                if nameEditBox then
                    nameEditBox:Hide()  -- Hide the name edit box
                    panel[ADDON_NAME.."NameEditBox"..index] = nil  -- Remove reference from the panel
                end
        
                local quantityEditBox = panel[ADDON_NAME.."QuantityEditBox"..index]
                if quantityEditBox then
                    quantityEditBox:Hide()  -- Hide the quantity edit box
                    panel[ADDON_NAME.."QuantityEditBox"..index] = nil  -- Remove reference from the panel
                end
        
                local removeButton = panel[ADDON_NAME.."RemoveButton"..index]
                if removeButton then
                    removeButton:Hide()  -- Hide the remove button
                    panel[ADDON_NAME.."RemoveButton"..index] = nil  -- Remove reference from the panel
                end
            end
            
            table.remove(savedItemsToBuy, index)
            RefreshConfigPanel(panel)
        end)
        
        return removeButton
    end
    
    -- Refresh the configuration panel
    function RefreshConfigPanel(panel)
        addButton:Show()
        showButton:Hide()
        local yOffset = -50
        for index, itemData in ipairs(savedItemsToBuy) do
            -- Name EditBox
            local nameEditBox = panel[ADDON_NAME.."NameEditBox"..index]
            if not nameEditBox then
                nameEditBox = CreateFrame("EditBox", ADDON_NAME.."NameEditBox"..index, panel, "InputBoxTemplate")
                nameEditBox:SetSize(200, 20)
                nameEditBox:SetPoint("TOPLEFT", 40, yOffset)
                nameEditBox:SetAutoFocus(false)
                nameEditBox:SetScript("OnEnterPressed", function(self) self:ClearFocus() end)
                nameEditBox:SetScript("OnEditFocusLost", function(self)
                    savedItemsToBuy[index].name = self:GetText()
                end)
                panel[ADDON_NAME.."NameEditBox"..index] = nameEditBox
            end
            nameEditBox:SetText(itemData.name)
            
            -- Quantity EditBox
            local quantityEditBox = panel[ADDON_NAME.."QuantityEditBox"..index]
            if not quantityEditBox then
                quantityEditBox = CreateFrame("EditBox", ADDON_NAME.."QuantityEditBox"..index, panel, "InputBoxTemplate")
                quantityEditBox:SetSize(50, 20)
                quantityEditBox:SetPoint("LEFT", nameEditBox, "RIGHT", 10, 0)
                quantityEditBox:SetAutoFocus(false)
                quantityEditBox:SetScript("OnEnterPressed", function(self) self:ClearFocus() end)
                quantityEditBox:SetScript("OnEditFocusLost", function(self)
                    savedItemsToBuy[index].desiredQuantity = tonumber(self:GetText()) or 0
                end)
                panel[ADDON_NAME.."QuantityEditBox"..index] = quantityEditBox
            end
            quantityEditBox:SetText(tostring(itemData.desiredQuantity))

             -- Add Remove Button
            local removeButton = panel[ADDON_NAME.."RemoveButton"..index]
            if not removeButton then
                removeButton = CreateRemoveButton(panel, index)
                panel[ADDON_NAME.."RemoveButton"..index] = removeButton
            end
            removeButton:SetPoint("LEFT", panel[ADDON_NAME.."QuantityEditBox"..index], "RIGHT", 10, 0)
            
            yOffset = yOffset - 30
        end
    end
    -- Show the panel
    InterfaceOptions_AddCategory(panel)
end

-- Load Addon
InitializeSavedItems()
--print("Saved items initialized.")
InitializeConfig()
--print("Config initialized.")