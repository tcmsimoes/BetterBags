local function MyUpdateItems(self)
    for _, itemButton in self:EnumerateItems() do
        if itemButton.myIcon then
            itemButton.myIcon:Hide()
        end
    end

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
            end
        end
    end
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:SetScript("OnEvent", function()
    frame:UnregisterAllEvents()

    for i = 1, 5 do
        local frame = ContainerFrameContainer.ContainerFrames[i]
        hooksecurefunc(frame, "UpdateItems", MyUpdateItems)
    end
    hooksecurefunc(ContainerFrameCombinedBags, "UpdateItems", MyUpdateItems)
end)