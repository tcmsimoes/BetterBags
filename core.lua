local myFrame = CreateFrame("frame")
myFrame:RegisterEvent("MERCHANT_SHOW")
myFrame:RegisterEvent("MERCHANT_CLOSED")
myFrame:RegisterEvent("BAG_UPDATE_DELAYED")

local function sellJunk()
    local totalBags = NUM_BAG_SLOTS or 4
    for bagId = 0, totalBags do
        for slotId = 1, C_Container.GetContainerNumSlots(bagId) do
            local bagItem = ItemLocation:CreateFromBagAndSlot(bagId, slotId)
            if C_Item.DoesItemExist(bagItem) then
                if (C_Item.GetItemQuality(bagItem) == Enum.ItemQuality.Poor) then
                    C_Container.UseContainerItem(bagItem:GetBagAndSlot())
                end
            end
        end
    end
end

local function repair()
    if CanMerchantRepair() then
        local repairAllCost, canRepair = GetRepairAllCost();
        if canRepair then
            if repairAllCost<=GetMoney() then
                if IsInGuild() and CanGuildBankRepair() then
                    RepairAllItems(true)
                else
                    RepairAllItems(false)
                end
                DEFAULT_CHAT_FRAME:AddMessage("Repaired cost: "..GetCoinTextureString(repairAllCost), 255, 255, 0);
            else
                DEFAULT_CHAT_FRAME:AddMessage("Not enough money for repair!", 255, 0, 0);
            end
        end
    end
end

local myIsMerchantPresent = false
myFrame:SetScript("OnEvent", function(self, event)
    if event == "MERCHANT_SHOW" then
        myIsMerchantPresent = true
        sellJunk()
        repair()
    elseif event == "MERCHANT_CLOSED" then
        myIsMerchantPresent = false
    elseif event == "BAG_UPDATE_DELAYED" then
        if myIsMerchantPresent then
            sellJunk()
        end
    end
end)

local function addValue(table, key1, key2, value)
    local key1name = "k_"..key1
    local key2name = "k_"..key2

    if not table then
        table = {}
    end

    if not table[key1name] then
        table[key1name] = {}
    end

    table[key1name][key2name] = value
end

local function removeValue(table, key1, key2)
    local key1name = "k_"..key1
    local key2name = "k_"..key2

    if table and table[key1name] then
        table[key1name][key2name] = nil
    end
end


local myOldItems = {}
hooksecurefunc(ContainerFrameCombinedBags, "UpdateItems", function(self)
    local newItems = {}
    for _, itemButton in self:EnumerateValidItems() do
        local bagId = itemButton:GetBagID()
        local slotId = itemButton:GetID()
        local info = C_Container.GetContainerItemInfo(bagId, slotId)
        if info then
            if info.quality == Enum.ItemQuality.Poor then
                if not itemButton.myIcon then
                    itemButton.myIcon = itemButton:CreateTexture(nil, "OVERLAY")
                    itemButton.myIcon:SetTexture("Interface/Buttons/UI-GroupLoot-Coin-Up")
                    itemButton.myIcon:SetPoint("TOPLEFT", 2, -2)
                    itemButton.myIcon:SetSize(15, 15)
                end
                itemButton.myIcon:Show()

                addValue(newItems, bagId, slotId, itemButton.myIcon)
                removeValue(myOldItems, bagId, slotId)
            elseif itemButton.myIcon then
                itemButton.myIcon:Hide()
            end
        end
    end

    for _, v in pairs(myOldItems) do
        for _, icon in pairs(v) do
            if icon then
                icon:Hide()
            end
        end
    end

    myOldItems = newItems
end)