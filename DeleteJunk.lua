if WOW_PROJECT_ID ~= WOW_PROJECT_MAINLINE then return end

local ADDON_NAME, T = ...

--- @class DeleteHearthstone
local DeleteHearthstone = CreateFrame("Frame", ADDON_NAME)
DeleteHearthstone:RegisterEvent("ADDON_LOADED")
DeleteHearthstone:RegisterEvent("PLAYER_LOGIN")
DeleteHearthstone:RegisterEvent("PLAYER_ENTERING_WORLD")



local Toys = {
   54452,  -- Ethereal Portal
   93672,  -- Dark Portal
   162973, -- Greatfather Winter's Hearthstone
   163045, -- Headless Horseman's Hearthstone
   165669, -- Lunar Elder's Hearthstone
   165670, -- Peddlefeet's Lovely Hearthstone
   165802, -- Noble Gardener's Hearthstone
   166746, -- Fire Eater's Hearthstone
   166747, -- Brewfest Reveler's Hearthstone
   168907, -- Holographic Digitalization Hearthstone
   172179, -- Eternal Traveler's Hearthstone
   180290, -- Night Fae Hearthstone
   182773, -- Necrolord Hearthstone
   183716, -- Venthyr Sinstone
   184353, -- Kyrian Hearthstone
   190196, -- Enlightened Hearthstone
   193588, -- Timewalker's Hearthstone
   200630, -- Ohn'ir Windsage's Hearthstone
   208704, -- Deepdweller's Earthen Hearthstone
   209035, -- Hearthstone of the Flame
}

local Items = {
   6948,  --Hearthstone

   44601, --Heavy Copper Racer

   -- Weihnachten
   21215,  --Graccu's Mince Meat Fruitcake
   44482,  --Trusty Copper Racer
   50446,  --Toxic Wasteling
   128650, --"Merry Munchkin" Costume
   21213,  --Preserved Holly
   21254,  --Winter Veil Cookie
   34498,  --Paper Zeppelin Kit

   --Halloween
   20399, --hallowedwand-leper gnome
   34068, --Weighted Jack-o'-Lantern
   20414, --Hallowed Wand - Wisp

   --MogItem
   49715,  --Forever-Lovely Rose
   50741,  --Vile Fumigator's Mask
   211355, --Eternal Pink Rose
}

local MogItem = {
   49715,  --Forever-Lovely Rose
   50741,  --Vile Fumigator's Mask
   211355, --Eternal Pink Rose
}

local debugPrint = function(msg)
   -- print(msg)
end

DeleteHearthstone:SetScript("OnEvent", function(self, event, ...)
   if (event == "PLAYER_LOGIN") then
      -- debugPrint("testa: " .. tostring(testa))
      -- debugPrint("testb: " .. tostring(testb))
      -- debugPrint("testc: " .. tostring(testc))
      -- debugPrint("testd: " .. tostring(testd))
      return
   end


   if (event == "PLAYER_LOGIN") or (event == "PLAYER_ENTERING_WORLD") then
      if event == "PLAYER_ENTERING_WORLD" then
         local isInitialLogin, isReloadingUi = ...

         if not (isInitialLogin or isReloadingUi) then
            debugPrint("isInitialLogin: " .. tostring(isInitialLogin))
            debugPrint("isReloadingUi: " .. tostring(isReloadingUi))
            return
         end
      end

      for i = 1, #Toys do
         if PlayerHasToy(Toys[i]) then
            self.hasToy = true
            break
         end
      end

      for i = 1, #MogItem do
         if C_TransmogCollection.PlayerHasTransmog(MogItem[i]) then
            self.hasMog = true
            break
         end
      end

      if not self.hasToy then return end
      if not self.hasMog then return end

      self:RegisterEvent("HEARTHSTONE_BOUND")

      WorldFrame:HookScript("OnMouseDown", function()
         -- if self.isBound then
         for bagID = BACKPACK_CONTAINER, NUM_BAG_SLOTS do
            for slotIndex = 1, C_Container.GetContainerNumSlots(bagID) do
               local itemLink = C_Container.GetContainerItemLink(bagID, slotIndex)
               local itemID = itemLink and GetItemInfoInstant(itemLink)
               for _, itemJunkId in ipairs(Items) do
                  if itemID and itemID == itemJunkId then
                     C_Container.PickupContainerItem(bagID, slotIndex)
                     DeleteCursorItem()
                     ClearCursor()
                     print("|cffEEE4AEDelete Junk:|r Deleted " .. itemLink)
                     self.isBound = false
                     return
                  end
               end
            end
         end
         -- end
      end)
   elseif event == "HEARTHSTONE_BOUND" and self.hasToy then
      self.isBound = true
   end
end)

-- function Test()
--    local panel = CreateFrame("Frame", "djOptionsPanel");
--    panel.name = "DeleteJunk";
--    local category, layout = Settings.RegisterCanvasLayoutCategory(panel, panel.name, panel.name);
--    category.ID = panel.name;
--    Settings.RegisterAddOnCategory(category);
-- end
