-- [[ الخدمات الأساسية ]] --
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local LP = Players.LocalPlayer

-- [[ المتغيرات العامة ]] --
_G.CachedZombies = {} 
_G.WallhackEnabled = false
_G.HitboxEnabled = false
_G.HeadSize = 1
_G.ZombieBodyESP = false
_G.ZombieBox = false
_G.ZombieName = false
_G.ZombieHealth = false
_G.ZombieTracker = false
_G.DeathNotify = false 
_G.FriendBodyESP = false
_G.FriendBox = false
_G.FriendName = false
_G.FriendHealth = false
_G.FriendTracker = false
_G.NPCAimbot = false
_G.AimbotSmoothness = 0.5
_G.HoldingV = false
_G.BringToggle = false
_G.HoldingF = false
_G.BoxBring = false
_G.FullBrightEnabled = false

-- [[ نظام الإشعارات المتطور ]] --
local NotifyGui = Instance.new("ScreenGui")
NotifyGui.Name = "CoreX_Notify"
if gethui then NotifyGui.Parent = gethui() else NotifyGui.Parent = game.CoreGui end

local function CreatePlayerNotify(TargetPlayer, Mode)
    if not _G.DeathNotify then return end
    
    local Config = {
        ["Death"] = {Text = "HAS BEEN ELIMINATED", Color = Color3.fromRGB(255, 50, 50)},
        ["LowHealth"] = {Text = "LOW HEALTH WARNING", Color = Color3.fromRGB(255, 215, 0)}
    }
    
    local Current = Config[Mode]
    local Frame = Instance.new("Frame")
    Frame.Name = "NotifyFrame"
    Frame.Parent = NotifyGui
    Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Frame.BackgroundTransparency = 0.1
    Frame.BorderSizePixel = 0
    -- مكان الإشعارات المحدث (مرفوع)
    Frame.Position = UDim2.new(1, 20, 0.6, 0)
    Frame.Size = UDim2.new(0, 280, 0, 70)
    
    local UICorner = Instance.new("UICorner", Frame)
    UICorner.CornerRadius = UDim.new(0, 10)
    
    local UIStroke = Instance.new("UIStroke", Frame)
    UIStroke.Color = Current.Color
    UIStroke.Thickness = 1.5
    UIStroke.Transparency = 0.5

    local PlayerIcon = Instance.new("ImageLabel", Frame)
    PlayerIcon.Size = UDim2.new(0, 50, 0, 50)
    PlayerIcon.Position = UDim2.new(0, 10, 0.5, -25)
    PlayerIcon.BackgroundTransparency = 1
    local content, isReady = Players:GetUserThumbnailAsync(TargetPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
    PlayerIcon.Image = content
    Instance.new("UICorner", PlayerIcon).CornerRadius = UDim.new(1, 0)

    local Title = Instance.new("TextLabel", Frame)
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 70, 0, 15)
    Title.Size = UDim2.new(1, -80, 0, 20)
    Title.Font = Enum.Font.GothamBold
    Title.Text = TargetPlayer.DisplayName
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 16
    Title.TextXAlignment = Enum.TextXAlignment.Left

    local Status = Instance.new("TextLabel", Frame)
    Status.BackgroundTransparency = 1
    Status.Position = UDim2.new(0, 70, 0, 35)
    Status.Size = UDim2.new(1, -80, 0, 15)
    Status.Font = Enum.Font.Gotham
    Status.Text = Current.Text
    Status.TextColor3 = Current.Color
    Status.TextSize = 12
    Status.TextXAlignment = Enum.TextXAlignment.Left

    local BarBg = Instance.new("Frame", Frame)
    BarBg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    BarBg.Position = UDim2.new(0, 0, 1, -5)
    BarBg.Size = UDim2.new(1, 0, 0, 5)
    Instance.new("UICorner", BarBg)

    local Bar = Instance.new("Frame", BarBg)
    Bar.BackgroundColor3 = Current.Color
    Bar.Size = UDim2.new(1, 0, 1, 0)
    Instance.new("UICorner", Bar)

    TweenService:Create(Frame, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Position = UDim2.new(1, -300, 0.6, 0)}):Play()
    TweenService:Create(Bar, TweenInfo.new(4, Enum.EasingStyle.Linear), {Size = UDim2.new(0, 0, 1, 0)}):Play()

    task.delay(4, function()
        TweenService:Create(Frame, TweenInfo.new(0.5), {Position = UDim2.new(1, 20, 0.6, 0), BackgroundTransparency = 1}):Play()
        task.wait(0.5)
        Frame:Destroy()
    end)
end

local LowHealthTriggered = {}
local function MonitorPlayer(plr)
    local function ConnectHum(char)
        local hum = char:WaitForChild("Humanoid")
        hum.Died:Connect(function() CreatePlayerNotify(plr, "Death") end)
        hum.HealthChanged:Connect(function(health)
            if health <= 40 and health > 0 and not LowHealthTriggered[plr.UserId] then
                LowHealthTriggered[plr.UserId] = true
                CreatePlayerNotify(plr, "LowHealth")
            elseif health > 40 then
                LowHealthTriggered[plr.UserId] = false
            end
        end)
    end
    plr.CharacterAdded:Connect(ConnectHum)
    if plr.Character then ConnectHum(plr.Character) end
end
for _, p in pairs(Players:GetPlayers()) do MonitorPlayer(p) end
Players.PlayerAdded:Connect(MonitorPlayer)

local function GetRoot(char) return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso") end
local function ClearESP(Tag) for _, obj in pairs(game.Workspace:GetDescendants()) do if obj.Name == Tag then obj:Destroy() end end end
local function CreateSimpleLabel(Parent, Text, Color)
    local label = Instance.new("TextLabel", Parent)
    label.Size = UDim2.new(1, 0, 1, 0); label.BackgroundTransparency = 1; label.TextColor3 = Color; label.Font = Enum.Font.SourceSansBold; label.TextSize = 14; label.Text = Text; label.TextStrokeTransparency = 0.5
    return label
end
local function CreateHighlight(Parent, Color)
    local hl = Instance.new("Highlight", Parent); hl.Name = "BodyHighlight"; hl.FillColor = Color; hl.OutlineColor = Color3.fromRGB(255, 255, 255); hl.FillTransparency = 0.5; hl.OutlineTransparency = 0; hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    return hl
end

-- [[ واجهة المستخدم Rayfield ]] --
local Window = Rayfield:CreateWindow({
   Name = "Core-X | 100 Waves Later", 
   LoadingTitle = "Core-X System Loading...", 
   LoadingSubtitle = "Developed by _M3lm_",
   ConfigurationSaving = { Enabled = true, FolderName = "CoreXConfig", FileName = "AutoSave", AutoLoad = true },
})

-- 1. تبويب اللاعب
local PlayerTab = Window:CreateTab("Player", 6022668888)
PlayerTab:CreateToggle({Name = "Wallhack (Chams)", CurrentValue = false, Callback = function(Value) 
    _G.WallhackEnabled = Value 
    if not Value and LP.Character then for _, p in pairs(LP.Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = true end end end
end})
local FlyToggle, isFlying, FlySpeed, lastJumpTime = false, false, 75, 0
PlayerTab:CreateToggle({Name = "Double Jump Fly (Speed 75)", CurrentValue = false, Callback = function(Value) FlyToggle = Value if not Value then isFlying = false end end})

-- 2. تبويب الزومبي
local ZombieTab = Window:CreateTab("Zombie", 4483345998)
ZombieTab:CreateLabel("⚠️ If there is a massive number of zombies, please turn off some features to avoid lag.")
ZombieTab:CreateToggle({Name = "Enable Hitbox Expansion (Head Only)", CurrentValue = false, Callback = function(Value) 
    _G.HitboxEnabled = Value 
    if not Value then for _, obj in pairs(_G.CachedZombies) do if obj:FindFirstChild("Head") then obj.Head.Size = Vector3.new(1,1,1); obj.Head.Transparency = 0; obj.Head.CanCollide = true end end end
end})
ZombieTab:CreateSlider({Name = "Head Hitbox Size", Range = {1, 7.5}, Increment = 0.5, CurrentValue = 1, Callback = function(Value) _G.HeadSize = Value end})
ZombieTab:CreateSection("ESP Settings")
ZombieTab:CreateToggle({Name = "Zombie Body ESP (3D)", CurrentValue = false, Callback = function(Value) _G.ZombieBodyESP = Value if not Value then ClearESP("BodyHighlight") end end})
ZombieTab:CreateToggle({Name = "Zombie Box ESP (2D)", CurrentValue = false, Callback = function(Value) _G.ZombieBox = Value if not Value then ClearESP("ZombieBoxGui") end end})
ZombieTab:CreateToggle({Name = "Zombie Name ESP", CurrentValue = false, Callback = function(Value) _G.ZombieName = Value if not Value then ClearESP("ZombieNameTag") end end})
ZombieTab:CreateToggle({Name = "Zombie Health ESP", CurrentValue = false, Callback = function(Value) _G.ZombieHealth = Value if not Value then ClearESP("ZombieHealthTag") end end})
ZombieTab:CreateToggle({Name = "Zombie Tracker (Tracer)", CurrentValue = false, Callback = function(Value) _G.ZombieTracker = Value if not Value then ClearESP("ZombieBeam") ClearESP("ZombieAtt") end end})

-- 3. تبويب الأصدقاء
local FriendsTab = Window:CreateTab("Friends", 6023426915)
FriendsTab:CreateToggle({Name = "Notification Death/LowHealth", CurrentValue = false, Callback = function(Value) _G.DeathNotify = Value end})
FriendsTab:CreateSection("ESP")
FriendsTab:CreateToggle({Name = "Friends Body ESP (3D)", CurrentValue = false, Callback = function(Value) _G.FriendBodyESP = Value if not Value then ClearESP("BodyHighlight") end end})
FriendsTab:CreateToggle({Name = "Friends Box ESP (2D)", CurrentValue = false, Callback = function(Value) _G.FriendBox = Value if not Value then ClearESP("FriendBoxGui") end end})
FriendsTab:CreateToggle({Name = "Friends Name ESP", CurrentValue = false, Callback = function(Value) _G.FriendName = Value if not Value then ClearESP("FriendNameTag") end end})
FriendsTab:CreateToggle({Name = "Friends Health ESP", CurrentValue = false, Callback = function(Value) _G.FriendHealth = Value if not Value then ClearESP("FriendHealthTag") end end})
FriendsTab:CreateToggle({Name = "Friends Tracker (Tracer)", CurrentValue = false, Callback = function(Value) _G.FriendTracker = Value if not Value then ClearESP("FriendBeam") ClearESP("FriendAtt") end end})

-- 4. تبويب ByPass
local ByPassTab = Window:CreateTab("ByPass", 6022668955)
ByPassTab:CreateToggle({Name = "NPC Aimbot (Hold V)", CurrentValue = false, Callback = function(Value) _G.NPCAimbot = Value end})
ByPassTab:CreateSlider({Name = "Aimbot Smoothness", Range = {0.1, 1}, Increment = 0.1, CurrentValue = 0.5, Callback = function(Value) _G.AimbotSmoothness = Value end})
ByPassTab:CreateToggle({Name = "Enable Hold (F) to Bring All Zombies", CurrentValue = false, Callback = function(Value) _G.BringToggle = Value end})
ByPassTab:CreateToggle({Name = "Auto Bring Items", CurrentValue = false, Callback = function(Value) _G.BoxBring = Value end})

-- 5. تبويب الإعدادات (التحديثات)
local SettingTab = Window:CreateTab("Settings", 6022668888)
SettingTab:CreateSection("Update : 1.10v")
SettingTab:CreateLabel("📦 | Head Hitbox expansion from 5 to 7.5")
SettingTab:CreateLabel("💛 | Added Low Health (40%) notification for friends")
SettingTab:CreateLabel("🧟‍♂️ | Zombie Head Aimbot with 360° range")
SettingTab:CreateLabel("🔔 | Notification position updated")

SettingTab:CreateSection("Graphics")
SettingTab:CreateToggle({Name = "Fullbright", CurrentValue = false, Callback = function(Value) 
    _G.FullBrightEnabled = Value 
    if not Value then game:GetService("Lighting").Brightness = 1; game:GetService("Lighting").ClockTime = 12 end
end})

-- [[ منطق العمل المستمر ]] --
task.spawn(function()
    while true do
        local list = {}
        for _, obj in pairs(game.Workspace:GetDescendants()) do if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and not Players:GetPlayerFromCharacter(obj) then table.insert(list, obj) end end
        _G.CachedZombies = list; task.wait(1)
    end
end)

UIS.InputBegan:Connect(function(input, processed) 
    if not processed then
        if input.KeyCode == Enum.KeyCode.F then _G.HoldingF = true elseif input.KeyCode == Enum.KeyCode.V then _G.HoldingV = true end
        if input.KeyCode == Enum.KeyCode.Space and FlyToggle then
            local now = tick()
            if now - lastJumpTime < 0.3 then
                isFlying = not isFlying
                local hrp = GetRoot(LP.Character)
                if isFlying and hrp then
                    local bg = hrp:FindFirstChild("FlyGyro") or Instance.new("BodyGyro", hrp); bg.Name = "FlyGyro"; bg.P = 9e4; bg.maxTorque = Vector3.new(9e9,9e9,9e9)
                    local bv = hrp:FindFirstChild("FlyVel") or Instance.new("BodyVelocity", hrp); bv.Name = "FlyVel"; bv.maxForce = Vector3.new(9e9,9e9,9e9)
                    task.spawn(function()
                        while isFlying and FlyToggle do
                            LP.Character.Humanoid.PlatformStand = true
                            local cam = workspace.CurrentCamera; local newVel = Vector3.new()
                            if UIS:IsKeyDown(Enum.KeyCode.W) then newVel = newVel + (cam.CFrame.LookVector * FlySpeed) end
                            if UIS:IsKeyDown(Enum.KeyCode.S) then newVel = newVel - (cam.CFrame.LookVector * FlySpeed) end
                            if UIS:IsKeyDown(Enum.KeyCode.A) then newVel = newVel - (cam.CFrame.RightVector * FlySpeed) end
                            if UIS:IsKeyDown(Enum.KeyCode.D) then newVel = newVel + (cam.CFrame.RightVector * FlySpeed) end
                            bv.Velocity = newVel; bg.CFrame = cam.CFrame; task.wait()
                        end
                        if hrp:FindFirstChild("FlyVel") then hrp.FlyVel:Destroy() end
                        if hrp:FindFirstChild("FlyGyro") then hrp.FlyGyro:Destroy() end
                        LP.Character.Humanoid.PlatformStand = false
                    end)
                end
            end
            lastJumpTime = now
        end
    end 
end)
UIS.InputEnded:Connect(function(input) if input.KeyCode == Enum.KeyCode.F then _G.HoldingF = false elseif input.KeyCode == Enum.KeyCode.V then _G.HoldingV = false end end)

RunService.RenderStepped:Connect(function()
    if _G.NPCAimbot and _G.HoldingV then
        local target = nil; local shortest = math.huge; local myRoot = GetRoot(LP.Character)
        if myRoot then
            for _, npc in pairs(_G.CachedZombies) do
                if npc:FindFirstChild("Head") and npc.Humanoid.Health > 0 then
                    local dist = (myRoot.Position - npc.Head.Position).Magnitude
                    if dist < shortest then shortest = dist; target = npc end
                end
            end
            if target then local cam = workspace.CurrentCamera; cam.CFrame = cam.CFrame:Lerp(CFrame.new(cam.CFrame.Position, target.Head.Position), _G.AimbotSmoothness) end
        end
    end
end)

task.spawn(function()
    while true do
        local myHrp = GetRoot(LP.Character)
        local myAtt = myHrp and (myHrp:FindFirstChild("MyTrackerAtt") or Instance.new("Attachment", myHrp))
        if myAtt then myAtt.Name = "MyTrackerAtt" end
        for _, obj in pairs(_G.CachedZombies) do
            if obj and GetRoot(obj) then
                local root = GetRoot(obj)
                if _G.HitboxEnabled and obj:FindFirstChild("Head") then
                    obj.Head.Size = Vector3.new(_G.HeadSize, _G.HeadSize, _G.HeadSize); obj.Head.Transparency = 0.8; obj.Head.CanCollide = false
                end
                if _G.ZombieBodyESP and not obj:FindFirstChild("BodyHighlight") then CreateHighlight(obj, Color3.fromRGB(255,0,0)) end
                if _G.ZombieBox and not obj:FindFirstChild("ZombieBoxGui") then
                    local b = Instance.new("BillboardGui", obj); b.Name = "ZombieBoxGui"; b.Size = UDim2.new(4.5,0,6,0); b.AlwaysOnTop = true; local f = Instance.new("Frame", b); f.Size = UDim2.new(1,0,1,0); f.BackgroundTransparency = 1; local s = Instance.new("UIStroke", f); s.Color = Color3.fromRGB(255,0,0); s.Thickness = 1.5
                end
                if _G.ZombieName and not obj:FindFirstChild("ZombieNameTag") then
                    local b = Instance.new("BillboardGui", obj); b.Name = "ZombieNameTag"; b.Size = UDim2.new(0,100,0,20); b.AlwaysOnTop = true; b.StudsOffset = Vector3.new(0,3.5,0); CreateSimpleLabel(b, obj.Name, Color3.fromRGB(255,50,50))
                end
                if _G.ZombieHealth and obj:FindFirstChild("Humanoid") then
                    local tag = obj:FindFirstChild("ZombieHealthTag") or Instance.new("BillboardGui", obj)
                    if tag.Name ~= "ZombieHealthTag" then tag.Name = "ZombieHealthTag"; tag.Size = UDim2.new(0,100,0,20); tag.AlwaysOnTop = true; tag.StudsOffset = Vector3.new(0,2.5,0); CreateSimpleLabel(tag, "", Color3.fromRGB(50,255,50)) end
                    tag.TextLabel.Text = math.floor(obj.Humanoid.Health).." HP"
                end
                if _G.ZombieTracker and myAtt and not root:FindFirstChild("ZombieBeam") then
                    local att = Instance.new("Attachment", root); att.Name = "ZombieAtt"; local beam = Instance.new("Beam", root); beam.Name = "ZombieBeam"; beam.Attachment0 = myAtt; beam.Attachment1 = att; beam.Color = ColorSequence.new(Color3.fromRGB(255,0,0)); beam.Width0 = 0.1; beam.Width1 = 0.1; beam.FaceCamera = true
                end
            end
        end
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LP and plr.Character and GetRoot(plr.Character) then
                local char = plr.Character; local root = GetRoot(char)
                if _G.FriendBodyESP and not char:FindFirstChild("BodyHighlight") then CreateHighlight(char, Color3.fromRGB(0,255,255)) end
                if _G.FriendBox and not char:FindFirstChild("FriendBoxGui") then
                    local b = Instance.new("BillboardGui", char); b.Name = "FriendBoxGui"; b.Size = UDim2.new(4.5,0,6,0); b.AlwaysOnTop = true; local f = Instance.new("Frame", b); f.Size = UDim2.new(1,0,1,0); f.BackgroundTransparency = 1; local s = Instance.new("UIStroke", f); s.Color = Color3.fromRGB(0,255,255); s.Thickness = 1.5
                end
                if _G.FriendName and not char:FindFirstChild("FriendNameTag") then
                    local b = Instance.new("BillboardGui", char); b.Name = "FriendNameTag"; b.Size = UDim2.new(0,100,0,20); b.AlwaysOnTop = true; b.StudsOffset = Vector3.new(0,3.5,0); CreateSimpleLabel(b, plr.Name, Color3.fromRGB(0,255,255))
                end
                if _G.FriendTracker and myAtt and not root:FindFirstChild("FriendBeam") then
                    local att = Instance.new("Attachment", root); att.Name = "FriendAtt"; local beam = Instance.new("Beam", root); beam.Name = "FriendBeam"; beam.Attachment0 = myAtt; beam.Attachment1 = att; beam.Color = ColorSequence.new(Color3.fromRGB(0,255,255)); beam.Width0 = 0.1; beam.Width1 = 0.1; beam.FaceCamera = true
                end
            end
        end
        if _G.BoxBring and LP.Character then
            local hrp = GetRoot(LP.Character)
            for _, obj in pairs(game.Workspace:GetChildren()) do
                if (obj:IsA("Model") or obj:IsA("BasePart")) and not obj:IsDescendantOf(LP.Character) then
                    local name = obj.Name:lower()
                    if name:find("box") or name:find("crate") or obj:FindFirstChild("TouchTransmitter") then
                        if obj:IsA("Model") then obj:PivotTo(hrp.CFrame) else obj.CFrame = hrp.CFrame end
                    end
                end
            end
        end
        if _G.BringToggle and _G.HoldingF then
            local hrp = GetRoot(LP.Character)
            if hrp then
                local targetPos = hrp.CFrame * CFrame.new(0, 0, -16) 
                for _, zombie in pairs(_G.CachedZombies) do if zombie and GetRoot(zombie) then GetRoot(zombie).CFrame = targetPos end end
            end
        end
        if _G.FullBrightEnabled then game:GetService("Lighting").Brightness = 2; game:GetService("Lighting").ClockTime = 14 end
        if _G.WallhackEnabled and LP.Character then for _, p in pairs(LP.Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end end
        task.wait(0.1)
    end
end)

Rayfield:Notify({Title = "Core-X V1.10", Content = "Updates applied successfully!", Duration = 3})
