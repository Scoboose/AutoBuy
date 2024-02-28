-- Define your addon name
local ADDON_NAME = "AutoBuy"

-- Default items to buy
local defaultItemsToBuy = {
    {name = "Recipe: Frost Oil", desiredQuantity = 10},
    {name = "Schematic: Gnomish Cloaking Device", desiredQuantity = 10},
    {name = "Recipe: Frost Protection Potion", desiredQuantity = 10},
    {name = "Pattern: Raptor Hide Harness", desiredQuantity = 10},
    {name = "Pattern: Raptor Hide Belt", desiredQuantity = 10},
    {name = "Formula: Enchant Bracer - Lesser Strength", desiredQuantity = 10},
    {name = "Schematic: Deepdive Helmet", desiredQuantity = 10},
    {name = "Recipe: Elixir of Demonslaying", desiredQuantity = 10},
    {name = "Shadowskin Gloves", desiredQuantity = 10},
    {name = "Pattern: Gem-studded Leather Belt", desiredQuantity = 10},
    {name = "Recipe: Frost Protection Potion", desiredQuantity = 10},
    {name = "Plans: Moonsteel Broadsword", desiredQuantity = 10},
    {name = "Recipe: Great Rage Potion", desiredQuantity = 10},
    {name = "Recipe: Superior Mana Potion", desiredQuantity = 10},
    {name = "Formula: Enchant Bracer - Deflection", desiredQuantity = 10},
    {name = "Formula: Enchant Shield - Greater Stamina", desiredQuantity = 10},
    {name = "Pattern: Mooncloth Robe", desiredQuantity = 10},
    {name = "Recipe: Holy Protection Potion", desiredQuantity = 10},
    {name = "Schematic: Goblin Jumper Cables", desiredQuantity = 10},
    {name = "Recipe: Nature Protection Potion", desiredQuantity = 10},
    {name = "Recipe: Transmute Mithril to Truesilver", desiredQuantity = 10},
    {name = "Plans: Golden Scale Coif", desiredQuantity = 10},
    {name = "Pattern: Earthen Leather Shoulders", desiredQuantity = 10},
    {name = "Pattern: Red Woolen Bag", desiredQuantity = 10},
    {name = "Pattern: Green Leather Armor", desiredQuantity = 10},
    {name = "Schematic: Gnomish Universal Remote", desiredQuantity = 10},
    {name = "Formula: Runed Arcanite Rod", desiredQuantity = 10},
    {name = "Formula: Enchant Chest - Lesser Mana", desiredQuantity = 10},
    {name = "Recipe: Great Rage Potion", desiredQuantity = 10},
    {name = "Recipe: Elixir of Superior Defense", desiredQuantity = 10},
    {name = "Pattern: Pink Mageweave Shirt", desiredQuantity = 10},
    {name = "Pattern: Lavender Mageweave Shirt", desiredQuantity = 10},
    {name = "Pattern: Blue Overalls", desiredQuantity = 10},
    {name = "Pattern: Black Whelp Cloak", desiredQuantity = 10},
    {name = "Pattern: Heavy Scorpid Bracers", desiredQuantity = 10},
    {name = "Pattern: Heavy Scorpid Helm", desiredQuantity = 10},
    {name = "Formula: Enchant Chest - Lesser Mana", desiredQuantity = 10},
    {name = "Pattern: Tuxedo Shirt", desiredQuantity = 10},
    {name = "Pattern: Tuxedo Jacket", desiredQuantity = 10},
    {name = "Pattern: Tuxedo Pants", desiredQuantity = 10},
    {name = "Pattern: Pink Mageweave Shirt", desiredQuantity = 10},
    {name = "Pattern: Lavender Mageweave Shirt", desiredQuantity = 10},
    {name = "Pattern: Blue Overalls", desiredQuantity = 10},
    {name = "Pattern: Admiral's Hat", desiredQuantity = 10},
    {name = "Plans: Hardened Iron Shortsword", desiredQuantity = 10},
    {name = "Plans: Massive Iron Axe", desiredQuantity = 10},
    {name = "Recipe: Elixir of Demonslaying", desiredQuantity = 10},
    {name = "Plans: Mithril Scale Bracers", desiredQuantity = 10},
    {name = "Formula: Enchant Bracer - Deflection", desiredQuantity = 10},
    {name = "Pattern: Green Dragonscale Breastplate", desiredQuantity = 10},
    {name = "Recipe: Elixir of Shadow Power", desiredQuantity = 10},
    {name = "Recipe: Rage Potion", desiredQuantity = 10},
    {name = "Pattern: Azure Silk Gloves", desiredQuantity = 10},
    {name = "Pattern: Red Whelp Gloves", desiredQuantity = 10},
    {name = "Pattern: Mooncloth", desiredQuantity = 10},
    {name = "Formula: Enchant Chest - Major Health", desiredQuantity = 10},
    {name = "Pattern: Runecloth Bag", desiredQuantity = 10},
    {name = "Recipe: Major Healing Potion", desiredQuantity = 10},
    {name = "Schematic: Delicate Arcanite Converter", desiredQuantity = 10},
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
        -- Create options frame
    local optionsPanel = CreateFrame("Frame")
    optionsPanel:RegisterEvent("ADDON_LOADED")
    optionsPanel.name = "Auto Buy"

    -- Create the scrolling parent frame and size it to fit inside the texture
    local optionsScrollFrame = CreateFrame("ScrollFrame", nil, optionsPanel, "UIPanelScrollFrameTemplate")
    optionsScrollFrame:SetPoint("TOPLEFT", 3, -4)
    optionsScrollFrame:SetPoint("BOTTOMRIGHT", -27, 4)

    -- Create the scrolling child frame, set its width to fit, and give it an arbitrary minimum height (such as 1)
    local optionsScrollChild = CreateFrame("Frame")
    optionsScrollFrame:SetScrollChild(optionsScrollChild)
    optionsScrollChild:SetWidth(InterfaceOptionsFramePanelContainer:GetWidth()-18)
    optionsScrollChild:SetHeight(1)

    -- Add widgets to the scrolling child frame as desired
    local optionsTitle = optionsScrollChild:CreateFontString("ARTWORK", nil, "GameFontNormalLarge")
    optionsTitle:SetPoint("TOP")
    optionsTitle:SetText("Auto Buy")
    
    -- Description
    local optionsDesc = optionsScrollChild:CreateFontString("ARTWORK", nil, "GameFontNormal")
    optionsDesc:SetPoint("TOP", 0, -15)
    optionsDesc:SetText("Set the items and desired quantities to automatically buy from vendors.")

      -- Footer text
      --local optionsFooter = optionsScrollChild:CreateFontString("ARTWORK", nil, "GameFontNormalSmall")
      --optionsFooter:SetPoint("TOP", 60, -5)
      --optionsFooter:SetText("by |cFF69CCF0Pokey|r")
    
    -- Create a button to add a new item
    local addButton = CreateFrame("Button", nil, optionsScrollChild, "UIPanelButtonTemplate")
    addButton:SetText("Add Item")
    addButton:SetSize(100, 25)
    addButton:SetPoint("TOPLEFT", 0, -25)
    addButton:Hide()
    
    -- Function to add a new item
    local function AddNewItem()
        table.insert(savedItemsToBuy, {name = "New Item", desiredQuantity = 1})
        RefreshConfigPanel(optionsScrollChild)
    end
    
    -- Set the action for the add button
    addButton:SetScript("OnClick", AddNewItem)

    -- Create a button to show items
    local showButton = CreateFrame("Button", nil, optionsScrollChild, "UIPanelButtonTemplate")
    showButton:SetText("Show list")
    showButton:SetSize(100, 25)
    showButton:SetPoint("TOPLEFT", 0, -25)

    -- Function to show
    local function showItems()
        RefreshConfigPanel(optionsScrollChild)
    end

    -- Set the action for the show button
    showButton:SetScript("OnClick", showItems)

    -- Create a button to Clear items
    local clearButton = CreateFrame("Button", nil, optionsScrollChild, "UIPanelButtonTemplate")
    clearButton:SetText("Clear Items")
    clearButton:SetSize(100, 25)
    clearButton:SetPoint("TOPRIGHT", 0, -25)

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
                    RefreshConfigPanel(optionsScrollChild)
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
                local nameEditBox = optionsScrollChild[ADDON_NAME.."NameEditBox"..index]
                if nameEditBox then
                    nameEditBox:Hide()  -- Hide the name edit box
                    optionsScrollChild[ADDON_NAME.."NameEditBox"..index] = nil  -- Remove reference from the panel
                end
        
                local quantityEditBox = optionsScrollChild[ADDON_NAME.."QuantityEditBox"..index]
                if quantityEditBox then
                    quantityEditBox:Hide()  -- Hide the quantity edit box
                    optionsScrollChild[ADDON_NAME.."QuantityEditBox"..index] = nil  -- Remove reference from the panel
                end
        
                local removeButton = optionsScrollChild[ADDON_NAME.."RemoveButton"..index]
                if removeButton then
                    removeButton:Hide()  -- Hide the remove button
                    optionsScrollChild[ADDON_NAME.."RemoveButton"..index] = nil  -- Remove reference from the panel
                end
            end
            
            table.remove(savedItemsToBuy, index)
            RefreshConfigPanel(optionsScrollChild)
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

    -- Register the panel with the Interface Options
    --InterfaceOptions_AddCategory(scrollFrame) -- OLD
    InterfaceOptions_AddCategory(optionsPanel)
end

-- Load Addon
InitializeSavedItems()
--print("Saved items initialized.")
InitializeConfig()
--print("Config initialized.")