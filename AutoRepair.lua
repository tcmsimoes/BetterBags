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

local myFrame = CreateFrame("frame")
myFrame:RegisterEvent("MERCHANT_SHOW")
myFrame:RegisterEvent("MERCHANT_CLOSED")
myFrame:SetScript("OnEvent", function(self, event)
    if event == "MERCHANT_SHOW" then
        repair()
    end
end)
