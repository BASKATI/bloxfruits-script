-- Blox Fruits Ultimate Script (Rayfield GUI)
-- By BASKATI, รองรับฟีเจอร์ครบ Auto Quest, Auto Buy Fruit, Sea Beast, Teleport, Raid, Kill Aura, Stats Auto Upgrade

local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()
local Window = Rayfield:CreateWindow({
   Name = "Blox Fruits Ultimate GUI by BASKATI",
   LoadingTitle = "Blox Fruits Script",
   LoadingSubtitle = "Rayfield UI",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "BloxFruitsScriptBASKATI",
      FileName = "UltimateSettings"
   }
})

local Tab = Window:CreateTab("Main", 4483362458)
local TeleTab = Window:CreateTab("Teleport", 4483362458)
local RaidTab = Window:CreateTab("Raid", 4483362458)
local StatsTab = Window:CreateTab("Stats", 4483362458)

-- =============== GLOBALS
_G.AutoFarmLevel = false
_G.AutoQuest = false
_G.AutoFarmBoss = false
_G.AutoBuyFruit = false
_G.BuyFruitName = "Dragon"
_G.AutoSeaBeast = false
_G.AutoRaid = false
_G.KillAura = false
_G.KillAuraRange = 25
_G.AutoCollectFruit = false
_G.SelectedIsland = "Jungle"
_G.UpgradeStats = {Melee=false, Defense=false, Sword=false, Gun=false, DevilFruit=false}
_G.UpgradeAmount = 1

local Islands = {
    "Jungle", "Pirate Village", "Desert", "Middle Town", "Frozen Village", "Marine Fortress",
    "Skylands", "Colosseum", "Magma Village", "Underwater City", "Fountain City", "Haunted Castle",
    "Hydra Island", "Great Tree", "Port Town", "Castle on the Sea", "Third Sea Town", "Floating Turtle"
}

-- =============== UTILS
function tpTo(pos)
   local ply = game.Players.LocalPlayer
   if ply.Character and ply.Character:FindFirstChild("HumanoidRootPart") then
      ply.Character.HumanoidRootPart.CFrame = CFrame.new(pos)
   end
end

function safeFloat()
   local ply = game.Players.LocalPlayer
   if ply.Character and ply.Character:FindFirstChild("HumanoidRootPart") then
      ply.Character.HumanoidRootPart.Velocity = Vector3.new(0,50,0)
   end
end

-- =============== AUTO QUEST
function autoQuest()
   while _G.AutoQuest do
      pcall(function()
         local ReplicatedStorage = game:GetService("ReplicatedStorage")
         local QuestService = ReplicatedStorage:FindFirstChild("Remotes"):FindFirstChild("Comm"):FindFirstChild("InvokeServer")
         if QuestService then
            -- รับเควสต์
            QuestService:InvokeServer("StartQuest", "AutoQuest")
            wait(1)
            -- ส่งเควสต์
            QuestService:InvokeServer("CompleteQuest", "AutoQuest")
         end
         wait(5)
      end)
   end
end

-- =============== AUTO BUY FRUIT
function autoBuyFruit()
   while _G.AutoBuyFruit do
      pcall(function()
         local args = {
            [1] = "BuyFruit",
            [2] = _G.BuyFruitName
         }
         game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
         wait(60)
      end)
   end
end

-- =============== AUTO SEA BEAST
function autoSeaBeast()
   while _G.AutoSeaBeast do
      pcall(function()
         for _,v in pairs(workspace.SeaBeasts:GetChildren()) do
            if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
               tpTo(v.HumanoidRootPart.Position + Vector3.new(0,25,0))
               repeat
                  safeFloat()
                  game:GetService("VirtualUser"):Button1Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
                  wait(0.15)
                  game:GetService("VirtualUser"):Button1Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
                  wait(0.15)
               until not v or not v:FindFirstChild("Humanoid") or v.Humanoid.Health <= 0 or not _G.AutoSeaBeast
            end
         end
         wait(5)
      end)
   end
end

-- =============== AUTO RAID
function autoRaid()
   while _G.AutoRaid do
      pcall(function()
         local args = {
            [1] = "StartRaid",
            [2] = "Flame" -- เปลี่ยนเป็น Raid ที่ต้องการ
         }
         game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
         wait(120)
      end)
   end
end

-- =============== Kill Aura
function killAura()
   while _G.KillAura do
      pcall(function()
         for _,v in pairs(workspace.Enemies:GetChildren()) do
            if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
               if (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= tonumber(_G.KillAuraRange) then
                  tpTo(v.HumanoidRootPart.Position + Vector3.new(0,5,0))
                  game:GetService("VirtualUser"):Button1Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
                  wait(0.15)
                  game:GetService("VirtualUser"):Button1Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
                  wait(0.15)
               end
            end
         end
         wait(0.1)
      end)
   end
end

-- =============== Stats Auto Upgrade
function statsAutoUpgrade()
   while true do
      pcall(function()
         for stat,enabled in pairs(_G.UpgradeStats) do
            if enabled then
               game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AddPoint", stat, _G.UpgradeAmount)
               wait(0.2)
            end
         end
      end)
      wait(3)
   end
end

-- =============== Teleport
local IslandPos = {
    ["Jungle"] = Vector3.new(-1600, 40, 150),
    ["Pirate Village"] = Vector3.new(-1100, 15, 3800),
    ["Desert"] = Vector3.new(1050, 7, 4200),
    ["Middle Town"] = Vector3.new(260, 25, 400),
    ["Frozen Village"] = Vector3.new(1120, 7, -1350),
    ["Marine Fortress"] = Vector3.new(-4500, 40, 4200),
    ["Skylands"] = Vector3.new(-450, 1000, -2900),
    ["Colosseum"] = Vector3.new(-1400, 7, -3000),
    ["Magma Village"] = Vector3.new(-5200, 50, -5000),
    ["Underwater City"] = Vector3.new(3800, 40, -3000),
    ["Fountain City"] = Vector3.new(5300, 50, 2500),
    ["Haunted Castle"] = Vector3.new(-9500, 140, 5550),
    ["Hydra Island"] = Vector3.new(5800, 610, -1100),
    ["Great Tree"] = Vector3.new(2350, 25, -6500),
    ["Port Town"] = Vector3.new(-280, 45, 5600),
    ["Castle on the Sea"] = Vector3.new(2200, 780, 8900),
    ["Third Sea Town"] = Vector3.new(5900, 40, 5000),
    ["Floating Turtle"] = Vector3.new(-11000, 760, -9000)
}

for _,islandName in pairs(Islands) do
   TeleTab:CreateButton({
      Name = "Teleport ไป " .. islandName,
      Callback = function()
         if IslandPos[islandName] then tpTo(IslandPos[islandName]) end
      end
   })
end

-- =============== GUI TOGGLES
Tab:CreateToggle({
   Name = "Auto Quest (รับส่งเควสต์อัตโนมัติ)",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoQuest = Value
      if Value then spawn(autoQuest) end
   end,
})

Tab:CreateToggle({
   Name = "Auto Buy Fruit",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoBuyFruit = Value
      if Value then spawn(autoBuyFruit) end
   end,
})

Tab:CreateInput({
   Name = "ชื่อผลไม้ที่ต้องการซื้อ",
   PlaceholderText = "เช่น Dragon",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
      _G.BuyFruitName = Text
   end,
})

Tab:CreateToggle({
   Name = "Auto Sea Beast",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoSeaBeast = Value
      if Value then spawn(autoSeaBeast) end
   end,
})

RaidTab:CreateToggle({
   Name = "Auto Raid (Flame)",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoRaid = Value
      if Value then spawn(autoRaid) end
   end,
})

Tab:CreateToggle({
   Name = "Kill Aura",
   CurrentValue = false,
   Callback = function(Value)
      _G.KillAura = Value
      if Value then spawn(killAura) end
   end,
})

Tab:CreateInput({
   Name = "Kill Aura Range (เมตร)",
   PlaceholderText = "25",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
      _G.KillAuraRange = tonumber(Text) or 25
   end,
})

StatsTab:CreateToggle({
   Name = "Auto Upgrade Melee",
   CurrentValue = false,
   Callback = function(Value)
      _G.UpgradeStats["Melee"] = Value
   end,
})
StatsTab:CreateToggle({
   Name = "Auto Upgrade Defense",
   CurrentValue = false,
   Callback = function(Value)
      _G.UpgradeStats["Defense"] = Value
   end,
})
StatsTab:CreateToggle({
   Name = "Auto Upgrade Sword",
   CurrentValue = false,
   Callback = function(Value)
      _G.UpgradeStats["Sword"] = Value
   end,
})
StatsTab:CreateToggle({
   Name = "Auto Upgrade Gun",
   CurrentValue = false,
   Callback = function(Value)
      _G.UpgradeStats["Gun"] = Value
   end,
})
StatsTab:CreateToggle({
   Name = "Auto Upgrade DevilFruit",
   CurrentValue = false,
   Callback = function(Value)
      _G.UpgradeStats["DevilFruit"] = Value
   end,
})
StatsTab:CreateInput({
   Name = "จำนวน Point ที่อัพเกรดต่อครั้ง",
   PlaceholderText = "1",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
      _G.UpgradeAmount = tonumber(Text) or 1
   end,
})

spawn(statsAutoUpgrade)

Rayfield:Notify({
   Title = "Blox Fruits Ultimate",
   Content = "Loaded! ใช้เมนูเลือกฟีเจอร์ได้เต็มที่",
   Duration = 7
})

print("Blox Fruits Ultimate GUI Loaded!")
