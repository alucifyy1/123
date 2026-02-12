--[[
    █▀▀ █ █▀▄▀█ █▀▀ █ █▀ ▀█▀ █ █▀█ █▄░█ █▀▀ █▀▄
    █▀░ █ █░▀░█ ██▄ █ ▄█ ░█░ █ █▄█ █░▀█ ██▄ █▄▀

    🔥 RIVALS ZENITH: KICIAHOOK LEGACY 🔥
    Made by aspan666
    Версия: 5.1.0 | XButton Support
--]]

-- =============================================
-- 🛡️ АНТИ-БАН / СПУФИНГ / ГЛУШИТЕЛЬ
-- =============================================
pcall(function()
    if getconnections then
        for _, con in pairs(getconnections(game:GetService("LogService").MessageOut)) do
            pcall(function() con:Disable() end)
        end
    end
    if getexecutorname then
        hookfunction(getexecutorname, function() return "RobloxPlayerBeta" end)
    end
    local m = game:GetService("ReplicatedStorage"):FindFirstChild("Modules")
    if m then local b = m:FindFirstChild("BetterDebris") if b then b.Parent = nil end end
    getgenv().ZENITH_ID = string.format("%x", math.random(100000, 999999))
end)

-- =============================================
-- ⚙️ ГЛОБАЛЬНЫЙ КОНФИГ
-- =============================================
getgenv().Config = {
    Aimbot = false,
    AimMode = "Silent",
    Hitbox = "Head",
    HitboxExpand = 2.5,
    FOV = 169,
    ShowFOV = true,
    FOVColor = Color3.fromRGB(255, 80, 80),
    FOVStyle = "Smooth",
    
    SmoothEnabled = true,
    SmoothX = 1.0,
    SmoothY = 20.0,
    
    Prediction = true,
    PredX = 1.0,
    PredY = 20.0,
    Resolver = true,
    
    Triggerbot = false,
    TriggerDelay = 1,
    TriggerRelease = 1,
    TriggerDeadzone = 15,
    TriggerKey = "MouseButton2",
    TriggerKeyEnabled = true,
    
    ESP = false,
    ESPBox = true,
    ESPName = true,
    ESPDistance = true,
    ESPHealth = true,
    ESPSkeleton = false,
    ESPColor = Color3.fromRGB(255, 80, 80),
    
    Speed = 16,
    Jump = 50,
    Fly = false,
    FlySpeed = 50,
    Noclip = false,
    
    SkinChanger = false,
    CurrentSkin = nil,
    
    Binds = {
        Aimlock = { Key = "E", Enabled = true, Mode = "Hold", ToggleState = false },
        Trigger = { Key = "MouseButton2", Enabled = true, Mode = "Hold", ToggleState = false },
        Menu = { Key = "RightShift", Enabled = true }
    }
}

getgenv().Skins = {
    ["❄️ Ice Dragon"] = 16789012345,
    ["🔥 Phoenix"] = 16789012346,
    ["👻 Shadow Reaper"] = 16789012347,
    ["🐯 Golden Tiger"] = 16789012348,
    ["🤖 Cyberpunk"] = 16789012349,
    ["⚡ Season 1 Elite"] = 16789012350,
    ["💎 Void Walker"] = 16789012351,
    ["🌀 Distortion"] = 16789012352,
    ["🔮 Warper"] = 16789012353,
    ["💀 Reaper"] = 16789012354,
    ["🔴 Crimson"] = 16789012355,
    ["💚 Neon"] = 16789012356,
    ["⚫ Carbon"] = 16789012357,
    ["🐅 Tiger Stripe"] = 16789012358,
    ["💠 Digital"] = 16789012359,
}

-- =============================================
-- 🎯 AIMBOT ENGINE
-- =============================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LP = Players.LocalPlayer
local Mouse = LP:GetMouse()

-- FOV Circle
local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = false
FOVCircle.Thickness = 1.8
FOVCircle.NumSides = 72
FOVCircle.Filled = false
FOVCircle.Transparency = 1
FOVCircle.Color = getgenv().Config.FOVColor

local FOVGlow = Drawing.new("Circle")
FOVGlow.Visible = false
FOVGlow.Thickness = 3.5
FOVGlow.NumSides = 72
FOVGlow.Filled = false
FOVGlow.Transparency = 0.6
FOVGlow.Color = Color3.fromRGB(255, 50, 100)

RunService.RenderStepped:Connect(function()
    if getgenv().Config.ShowFOV and getgenv().Config.Aimbot then
        local pos = Vector2.new(Mouse.X, Mouse.Y)
        FOVCircle.Visible = true
        FOVCircle.Radius = getgenv().Config.FOV
        FOVCircle.Color = getgenv().Config.FOVColor
        FOVCircle.Position = pos
        if getgenv().Config.FOVStyle == "Glow" then
            FOVGlow.Visible = true
            FOVGlow.Radius = getgenv().Config.FOV + 2
            FOVGlow.Color = getgenv().Config.FOVColor
            FOVGlow.Position = pos
        else
            FOVGlow.Visible = false
        end
    else
        FOVCircle.Visible = false
        FOVGlow.Visible = false
    end
end)

local function getClosestPlayer(ignoreFOV)
    local closest, shortest = nil, ignoreFOV and 9999 or getgenv().Config.FOV
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Character and p.Character:FindFirstChild("Head") and 
           p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
            local pos, vis = Camera:WorldToViewportPoint(p.Character.Head.Position)
            local d = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(pos.X, pos.Y)).Magnitude
            if d < shortest and vis then
                shortest = d
                closest = p
            end
        end
    end
    return closest
end

local function getHitboxPosition(p)
    if not p or not p.Character then return nil end
    local hitbox = getgenv().Config.Hitbox
    local expand = getgenv().Config.HitboxExpand
    local part
    if hitbox == "Head" then
        part = p.Character:FindFirstChild("Head")
    elseif hitbox == "Torso" then
        part = p.Character:FindFirstChild("UpperTorso") or p.Character:FindFirstChild("HumanoidRootPart")
    elseif hitbox == "Legs" then
        part = p.Character:FindFirstChild("LowerTorso") or p.Character:FindFirstChild("Left Leg")
    else
        local parts = {"Head", "UpperTorso", "HumanoidRootPart"}
        part = p.Character:FindFirstChild(parts[math.random(1, #parts)])
    end
    if part then
        return part.Position + Vector3.new(
            math.random(-10, 10) * (expand - 1) / 2,
            math.random(-10, 10) * (expand - 1) / 2,
            math.random(-10, 10) * (expand - 1) / 2
        )
    end
    return nil
end

-- Visible Aim
RunService.RenderStepped:Connect(function()
    if getgenv().Config.Aimbot and getgenv().Config.AimMode == "Visible" then
        local bind = getgenv().Config.Binds.Aimlock
        local shouldAim = true
        if bind.Enabled then
            if bind.Mode == "Hold" then
                if bind.Key == "MouseButton2" then
                    shouldAim = UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
                elseif bind.Key == "XButton1" then
                    shouldAim = UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton4)
                elseif bind.Key == "XButton2" then
                    shouldAim = UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton5)
                else
                    shouldAim = UIS:IsKeyDown(Enum.KeyCode[bind.Key])
                end
            elseif bind.Mode == "Toggle" then
                shouldAim = bind.ToggleState
            end
        end
        if shouldAim then
            local target = getClosestPlayer(false)
            if target then
                local hitPos = getHitboxPosition(target)
                if hitPos then
                    local sx = getgenv().Config.SmoothEnabled and getgenv().Config.SmoothX or 1
                    local sy = getgenv().Config.SmoothEnabled and getgenv().Config.SmoothY or 1
                    local goal = CFrame.new(Camera.CFrame.Position, hitPos)
                    Camera.CFrame = Camera.CFrame:Lerp(goal, (sx + sy) / 200)
                end
            end
        end
    end
end)

-- Silent Aim Hook
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    if method == "FireServer" and tostring(self):find("Weapon") and getgenv().Config.Aimbot then
        local shouldSilent = getgenv().Config.AimMode == "Silent" or getgenv().Config.AimMode == "Rage"
        if shouldSilent then
            local bind = getgenv().Config.Binds.Aimlock
            local shouldAim = true
            if bind.Enabled then
                if bind.Mode == "Hold" then
                    if bind.Key == "MouseButton2" then
                        shouldAim = UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
                    elseif bind.Key == "XButton1" then
                        shouldAim = UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton4)
                    elseif bind.Key == "XButton2" then
                        shouldAim = UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton5)
                    else
                        shouldAim = UIS:IsKeyDown(Enum.KeyCode[bind.Key])
                    end
                elseif bind.Mode == "Toggle" then
                    shouldAim = bind.ToggleState
                end
            end
            if shouldAim then
                local target = getClosestPlayer(false)
                if target then
                    local hitPos = getHitboxPosition(target)
                    if getgenv().Config.Prediction and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                        local vel = target.Character.HumanoidRootPart.Velocity
                        hitPos = hitPos + Vector3.new(
                            vel.X * (getgenv().Config.PredX / 20),
                            vel.Y * (getgenv().Config.PredY / 20),
                            vel.Z * (getgenv().Config.PredX / 20)
                        )
                    end
                    if hitPos then
                        args[2] = hitPos
                        args[3] = hitPos
                        return oldNamecall(self, unpack(args))
                    end
                end
            end
        end
    end
    return oldNamecall(self, ...)
end)

-- Trigger Bot
local triggerConnection
local function setupTriggerBot()
    if triggerConnection then triggerConnection:Disconnect() end
    if not getgenv().Config.Triggerbot then return end
    triggerConnection = RunService.RenderStepped:Connect(function()
        if not getgenv().Config.Triggerbot then return end
        local bind = getgenv().Config.Binds.Trigger
        local shouldTrigger = true
        if bind.Enabled then
            if bind.Mode == "Hold" then
                if bind.Key == "MouseButton2" then
                    shouldTrigger = UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
                elseif bind.Key == "XButton1" then
                    shouldTrigger = UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton4)
                elseif bind.Key == "XButton2" then
                    shouldTrigger = UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton5)
                else
                    shouldTrigger = UIS:IsKeyDown(Enum.KeyCode[bind.Key])
                end
            elseif bind.Mode == "Toggle" then
                shouldTrigger = bind.ToggleState
            end
        end
        if shouldTrigger then
            local target = getClosestPlayer(true)
            if target then
                local head = target.Character and target.Character:FindFirstChild("Head")
                if head then
                    local pos, vis = Camera:WorldToViewportPoint(head.Position)
                    local dist = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(pos.X, pos.Y)).Magnitude
                    if dist <= (getgenv().Config.TriggerDeadzone or 15) and vis then
                        task.wait(getgenv().Config.TriggerDelay / 1000)
                        mouse1press()
                        task.wait(getgenv().Config.TriggerRelease / 1000)
                        mouse1release()
                    end
                end
            end
        end
    end)
end

-- Toggle обработка
UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    local aimBind = getgenv().Config.Binds.Aimlock
    if aimBind.Enabled and aimBind.Mode == "Toggle" then
        local keyMatches = false
        if aimBind.Key == "MouseButton2" and input.UserInputType == Enum.UserInputType.MouseButton2 then
            keyMatches = true
        elseif aimBind.Key == "XButton1" and input.UserInputType == Enum.UserInputType.MouseButton4 then
            keyMatches = true
        elseif aimBind.Key == "XButton2" and input.UserInputType == Enum.UserInputType.MouseButton5 then
            keyMatches = true
        elseif input.KeyCode == Enum.KeyCode[aimBind.Key] then
            keyMatches = true
        end
        if keyMatches then
            aimBind.ToggleState = not aimBind.ToggleState
        end
    end
    local trigBind = getgenv().Config.Binds.Trigger
    if trigBind.Enabled and trigBind.Mode == "Toggle" then
        local keyMatches = false
        if trigBind.Key == "MouseButton2" and input.UserInputType == Enum.UserInputType.MouseButton2 then
            keyMatches = true
        elseif trigBind.Key == "XButton1" and input.UserInputType == Enum.UserInputType.MouseButton4 then
            keyMatches = true
        elseif trigBind.Key == "XButton2" and input.UserInputType == Enum.UserInputType.MouseButton5 then
            keyMatches = true
        elseif input.KeyCode == Enum.KeyCode[trigBind.Key] then
            keyMatches = true
        end
        if keyMatches then
            trigBind.ToggleState = not trigBind.ToggleState
        end
    end
end)

-- =============================================
-- 👁️ ESP ENGINE
-- =============================================
local ESP = {}
for _, p in pairs(Players:GetPlayers()) do
    if p ~= LP then
        ESP[p] = {
            Box = Drawing.new("Square"),
            Name = Drawing.new("Text"),
            Dist = Drawing.new("Text"),
            Health = Drawing.new("Square"),
            HealthBg = Drawing.new("Square"),
        }
        ESP[p].Name.Size = 16; ESP[p].Name.Center = true; ESP[p].Name.Outline = true; ESP[p].Name.Font = 3
        ESP[p].Name.OutlineColor = Color3.new(0,0,0)
        ESP[p].Dist.Size = 14; ESP[p].Dist.Center = true; ESP[p].Dist.Outline = true; ESP[p].Dist.Font = 3
        ESP[p].Dist.OutlineColor = Color3.new(0,0,0)
        ESP[p].Box.Thickness = 1.5; ESP[p].Box.Filled = false
        ESP[p].HealthBg.Filled = true; ESP[p].Health.Filled = true
        ESP[p].HealthBg.Color = Color3.fromRGB(20,20,20)
    end
end
Players.PlayerAdded:Connect(function(p)
    if p ~= LP then
        ESP[p] = {
            Box = Drawing.new("Square"),
            Name = Drawing.new("Text"),
            Dist = Drawing.new("Text"),
            Health = Drawing.new("Square"),
            HealthBg = Drawing.new("Square"),
        }
        ESP[p].Name.Size = 16; ESP[p].Name.Center = true; ESP[p].Name.Outline = true; ESP[p].Name.Font = 3
        ESP[p].Name.OutlineColor = Color3.new(0,0,0)
        ESP[p].Dist.Size = 14; ESP[p].Dist.Center = true; ESP[p].Dist.Outline = true; ESP[p].Dist.Font = 3
        ESP[p].Dist.OutlineColor = Color3.new(0,0,0)
        ESP[p].Box.Thickness = 1.5; ESP[p].Box.Filled = false
        ESP[p].HealthBg.Filled = true; ESP[p].Health.Filled = true
        ESP[p].HealthBg.Color = Color3.fromRGB(20,20,20)
    end
end)

RunService.RenderStepped:Connect(function()
    if not getgenv().Config.ESP then
        for _, e in pairs(ESP) do
            if e.Box then e.Box.Visible = false end
            if e.Name then e.Name.Visible = false end
            if e.Dist then e.Dist.Visible = false end
            if e.Health then e.Health.Visible = false end
            if e.HealthBg then e.HealthBg.Visible = false end
        end
        return
    end
    for p, e in pairs(ESP) do
        if p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Head") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
            local r, rv = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
            local h, hv = Camera:WorldToViewportPoint(p.Character.Head.Position + Vector3.new(0,0.5,0))
            if rv and hv then
                local height = math.abs((h.Y - r.Y) * 1.5)
                local width = height * 0.6
                local boxPos = Vector2.new(r.X - width/2, r.Y - height/4)
                if getgenv().Config.ESPBox then
                    e.Box.Visible = true
                    e.Box.Color = getgenv().Config.ESPColor
                    e.Box.Position = boxPos
                    e.Box.Size = Vector2.new(width, height)
                else e.Box.Visible = false end
                if getgenv().Config.ESPName then
                    e.Name.Visible = true
                    e.Name.Position = Vector2.new(r.X, r.Y - height/2 - 20)
                    e.Name.Text = p.Name
                    e.Name.Color = getgenv().Config.ESPColor
                else e.Name.Visible = false end
                if getgenv().Config.ESPDistance then
                    e.Dist.Visible = true
                    e.Dist.Position = Vector2.new(r.X, r.Y - height/2 - 5)
                    e.Dist.Text = math.floor((LP.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude) .. "m"
                    e.Dist.Color = Color3.new(1,1,1)
                else e.Dist.Visible = false end
                if getgenv().Config.ESPHealth then
                    local hp = p.Character.Humanoid.Health / p.Character.Humanoid.MaxHealth
                    e.HealthBg.Visible = true
                    e.HealthBg.Position = Vector2.new(boxPos.X - 6, boxPos.Y)
                    e.HealthBg.Size = Vector2.new(3, height)
                    e.Health.Visible = true
                    e.Health.Position = Vector2.new(boxPos.X - 6, boxPos.Y + (height * (1 - hp)))
                    e.Health.Size = Vector2.new(3, height * hp)
                    e.Health.Color = Color3.fromRGB(255 - (255 * hp), 255 * hp, 0)
                else
                    e.HealthBg.Visible = false
                    e.Health.Visible = false
                end
            end
        end
    end
end)

-- =============================================
-- 🚀 MOVEMENT
-- =============================================
LP.CharacterAdded:Connect(function(c)
    wait(0.5)
    local h = c:WaitForChild("Humanoid")
    h.WalkSpeed = getgenv().Config.Speed
    h.JumpPower = getgenv().Config.Jump
end)
if LP.Character and LP.Character:FindFirstChild("Humanoid") then
    LP.Character.Humanoid.WalkSpeed = getgenv().Config.Speed
    LP.Character.Humanoid.JumpPower = getgenv().Config.Jump
end

local flyConnection
local function toggleFly(state)
    if flyConnection then flyConnection:Disconnect() end
    if not state then
        if LP.Character and LP.Character:FindFirstChild("Humanoid") then
            LP.Character.Humanoid.PlatformStand = false
        end
        return
    end
    local c = LP.Character
    if not c then return end
    local h = c:FindFirstChild("Humanoid")
    local r = c:FindFirstChild("HumanoidRootPart")
    if not h or not r then return end
    h.PlatformStand = true
    flyConnection = RunService.RenderStepped:Connect(function()
        if not getgenv().Config.Fly then
            flyConnection:Disconnect()
            return
        end
        local md = h.MoveDirection
        r.Velocity = (Camera.CFrame.RightVector * md.X + Camera.CFrame.UpVector * md.Y + Camera.CFrame.LookVector * -md.Z) * getgenv().Config.FlySpeed
    end)
end

RunService.Stepped:Connect(function()
    if getgenv().Config.Noclip and LP.Character then
        for _, p in pairs(LP.Character:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
    end
end)

-- =============================================
-- 🎨 SKIN CHANGER (НОЛЬ ГАРАНТИЙ, НО ХУК ЕСТЬ)
-- =============================================
local oldSkinHook
oldSkinHook = hookmetamethod(game, "__namecall", function(self, ...)
    local m, a = getnamecallmethod(), {...}
    local rn = tostring(self)
    if m == "FireServer" then
        if (rn:find("HasSkin") or rn:find("Inventory")) and getgenv().Config.SkinChanger then
            return true
        end
        if (rn:find("Purchase") or rn:find("BuySkin")) and getgenv().Config.SkinChanger then
            return {Success = true, SkinId = a[1], Message = "Purchase successful"}
        end
        if (rn:find("Equip") or rn:find("SelectSkin")) and getgenv().Config.SkinChanger and getgenv().Config.CurrentSkin then
            a[1] = getgenv().Config.CurrentSkin
            return oldSkinHook(self, unpack(a))
        end
    end
    return oldSkinHook(self, ...)
end)

-- =============================================
-- 🖥️ UI — KICIAHOOK LEGACY
-- =============================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Zenith_Kiciahook_" .. (getgenv().ZENITH_ID or "aspan666")
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 780, 0, 520)
MainFrame.Position = UDim2.new(0.5, -390, 0.5, -260)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
MainFrame.BackgroundTransparency = 0.08
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui
MainFrame.Visible = true

local Blur = Instance.new("ImageLabel")
Blur.Size = UDim2.new(1, 0, 1, 0)
Blur.BackgroundTransparency = 1
Blur.Image = "rbxassetid://3570695787"
Blur.ImageColor3 = Color3.fromRGB(0, 0, 0)
Blur.ImageTransparency = 0.85
Blur.ScaleType = Enum.ScaleType.Slice
Blur.SliceCenter = Rect.new(10, 10, 180, 180)
Blur.Parent = MainFrame

local Outline1 = Instance.new("ImageLabel")
Outline1.Size = UDim2.new(1, -2, 1, -2)
Outline1.Position = UDim2.new(0, 1, 0, 1)
Outline1.BackgroundTransparency = 1
Outline1.Image = "rbxassetid://2592362371"
Outline1.ImageColor3 = Color3.fromRGB(45, 45, 55)
Outline1.ScaleType = Enum.ScaleType.Slice
Outline1.SliceCenter = Rect.new(2, 2, 62, 62)
Outline1.Parent = MainFrame

local Outline2 = Instance.new("ImageLabel")
Outline2.Size = UDim2.new(1, 0, 1, 0)
Outline2.BackgroundTransparency = 1
Outline2.Image = "rbxassetid://2592362371"
Outline2.ImageColor3 = Color3.fromRGB(6, 6, 10)
Outline2.ScaleType = Enum.ScaleType.Slice
Outline2.SliceCenter = Rect.new(2, 2, 62, 62)
Outline2.Parent = MainFrame

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, -16, 0, 48)
TopBar.Position = UDim2.new(0, 8, 0, 8)
TopBar.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
TopBar.BackgroundTransparency = 0.2
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TitleIcon = Instance.new("ImageLabel")
TitleIcon.Size = UDim2.new(0, 28, 0, 28)
TitleIcon.Position = UDim2.new(0, 12, 0.5, -14)
TitleIcon.BackgroundTransparency = 1
TitleIcon.Image = "rbxassetid://13951167659"
TitleIcon.ImageColor3 = Color3.fromRGB(255, 50, 100)
TitleIcon.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 240, 1, 0)
Title.Position = UDim2.new(0, 48, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "RIVALS ZENITH"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 22
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

local SubTitle = Instance.new("TextLabel")
SubTitle.Size = UDim2.new(0, 240, 1, 0)
SubTitle.Position = UDim2.new(0, 220, 0, 2)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "made by aspan666"
SubTitle.TextColor3 = Color3.fromRGB(180, 180, 190)
SubTitle.TextSize = 14
SubTitle.Font = Enum.Font.Gotham
SubTitle.TextXAlignment = Enum.TextXAlignment.Left
SubTitle.Parent = TopBar

local AccentLine = Instance.new("Frame")
AccentLine.Size = UDim2.new(1, 0, 0, 2)
AccentLine.Position = UDim2.new(0, 0, 1, -2)
AccentLine.BackgroundColor3 = Color3.fromRGB(255, 50, 100)
AccentLine.BorderSizePixel = 0
AccentLine.Parent = TopBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 32, 0, 32)
CloseBtn.Position = UDim2.new(1, -44, 0.5, -16)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 100)
CloseBtn.BackgroundTransparency = 0.2
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 20
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = TopBar
CloseBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false end)

local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, -32, 0, 44)
TabContainer.Position = UDim2.new(0, 16, 0, 64)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = MainFrame

local TabLayout = Instance.new("UIListLayout")
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabLayout.Padding = UDim.new(0, 12)
TabLayout.Parent = TabContainer

local ContentContainer = Instance.new("Frame")
ContentContainer.Size = UDim2.new(1, -32, 1, -128)
ContentContainer.Position = UDim2.new(0, 16, 0, 116)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

-- ========== ФУНКЦИИ UI ==========
local function CreateToggle(parent, text, get, set)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 36)
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 200, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 220, 230)
    label.TextSize = 15
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 60, 0, 26)
    btn.Position = UDim2.new(1, -70, 0.5, -13)
    btn.BackgroundColor3 = get() and Color3.fromRGB(255, 50, 100) or Color3.fromRGB(40, 40, 50)
    btn.Text = get() and "ON" or "OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamSemibold
    btn.BorderSizePixel = 0
    btn.Parent = frame
    btn.MouseButton1Click:Connect(function()
        local new = not get()
        set(new)
        btn.BackgroundColor3 = new and Color3.fromRGB(255, 50, 100) or Color3.fromRGB(40, 40, 50)
        btn.Text = new and "ON" or "OFF"
    end)
end

local function CreateSlider(parent, text, min, max, inc, get, set, suffix)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 50)
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 200, 0, 22)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. tostring(get()) .. (suffix or "")
    label.TextColor3 = Color3.fromRGB(220, 220, 230)
    label.TextSize = 15
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(0, 250, 0, 6)
    bg.Position = UDim2.new(0, 0, 0, 28)
    bg.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    bg.BorderSizePixel = 0
    bg.Parent = frame
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((get() - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(255, 50, 100)
    fill.BorderSizePixel = 0
    fill.Parent = bg
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 12, 0, 12)
    knob.Position = UDim2.new(fill.Size.X.Scale, -6, 0.5, -6)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BorderSizePixel = 0
    knob.Parent = bg
    local valLabel = Instance.new("TextLabel")
    valLabel.Size = UDim2.new(0, 60, 0, 22)
    valLabel.Position = UDim2.new(1, -270, 0, 28)
    valLabel.BackgroundTransparency = 1
    valLabel.Text = tostring(get()) .. (suffix or "")
    valLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    valLabel.TextSize = 14
    valLabel.Font = Enum.Font.GothamBold
    valLabel.Parent = frame
    local dragging = false
    knob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    knob.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local pos = UIS:GetMouseLocation()
            local absPos = bg.AbsolutePosition
            local absSize = bg.AbsoluteSize.X
            local rel = math.clamp((pos.X - absPos.X) / absSize, 0, 1)
            local val = min + (max - min) * rel
            if inc then val = math.round(val / inc) * inc end
            val = math.clamp(val, min, max)
            set(val)
            fill.Size = UDim2.new((val - min) / (max - min), 0, 1, 0)
            knob.Position = UDim2.new(fill.Size.X.Scale, -6, 0.5, -6)
            label.Text = text .. ": " .. tostring(val) .. (suffix or "")
            valLabel.Text = tostring(val) .. (suffix or "")
        end
    end)
end

local function CreateDropdown(parent, text, options, get, set)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 36)
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 200, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 220, 230)
    label.TextSize = 15
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 120, 0, 26)
    btn.Position = UDim2.new(1, -130, 0.5, -13)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    btn.Text = get()
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 14
    btn.Font = Enum.Font.Gotham
    btn.BorderSizePixel = 0
    btn.Parent = frame
    btn.MouseButton1Click:Connect(function()
        local idx = 1
        for i, opt in ipairs(options) do
            if opt == get() then idx = i break end
        end
        idx = idx % #options + 1
        local new = options[idx]
        set(new)
        btn.Text = new
    end)
end

local function CreateButton(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 36)
    btn.BackgroundColor3 = Color3.fromRGB(255, 50, 100)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 15
    btn.Font = Enum.Font.GothamSemibold
    btn.BorderSizePixel = 0
    btn.Parent = parent
    btn.MouseButton1Click:Connect(callback)
end

-- ========== СОЗДАНИЕ ВКЛАДОК ==========
local function createTab(name, iconId)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 110, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
    btn.BackgroundTransparency = 0.2
    btn.Text = "   " .. name
    btn.TextColor3 = Color3.fromRGB(200, 200, 210)
    btn.TextSize = 16
    btn.Font = Enum.Font.GothamSemibold
    btn.BorderSizePixel = 0
    btn.Parent = TabContainer
    local icon = Instance.new("ImageLabel")
    icon.Size = UDim2.new(0, 20, 0, 20)
    icon.Position = UDim2.new(0, 10, 0.5, -10)
    icon.BackgroundTransparency = 1
    icon.Image = iconId or "rbxassetid://13951167659"
    icon.ImageColor3 = Color3.fromRGB(200, 200, 210)
    icon.Parent = btn
    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 4
    page.ScrollBarImageColor3 = Color3.fromRGB(255, 50, 100)
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.Parent = ContentContainer
    page.Visible = false
    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Vertical
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 12)
    layout.Parent = page
    btn.MouseEnter:Connect(function()
        if btn.BackgroundColor3 ~= Color3.fromRGB(255, 50, 100) then
            btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        end
    end)
    btn.MouseLeave:Connect(function()
        if btn.BackgroundColor3 ~= Color3.fromRGB(255, 50, 100) then
            btn.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
        end
    end)
    btn.MouseButton1Click:Connect(function()
        for _, b in pairs(TabContainer:GetChildren()) do
            if b:IsA("TextButton") then
                b.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
                b.TextColor3 = Color3.fromRGB(200, 200, 210)
                local ic = b:FindFirstChildOfClass("ImageLabel")
                if ic then ic.ImageColor3 = Color3.fromRGB(200, 200, 210) end
            end
        end
        btn.BackgroundColor3 = Color3.fromRGB(255, 50, 100)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        icon.ImageColor3 = Color3.fromRGB(255, 255, 255)
        for _, p in pairs(ContentContainer:GetChildren()) do
            if p:IsA("ScrollingFrame") then
                p.Visible = false
            end
        end
        page.Visible = true
    end)
    return {Button = btn, Page = page, Layout = layout}
end

local aimTab = createTab("AIMBOT", "rbxassetid://13951167659")
local visTab = createTab("VISUALS", "rbxassetid://13951169214")
local movTab = createTab("MOVEMENT", "rbxassetid://13951164120")
local skinTab = createTab("SKINS", "rbxassetid://13951167951")
local setTab = createTab("SETTINGS", "rbxassetid://13951167659")

-- ========== ВКЛАДКА AIMBOT ==========
do
    local p = aimTab.Page
    CreateToggle(p, "Aimbot Enabled", function() return getgenv().Config.Aimbot end, function(v) getgenv().Config.Aimbot = v end)
    CreateDropdown(p, "Aim Mode", {"Silent", "Visible", "Rage"}, function() return getgenv().Config.AimMode end, function(v) getgenv().Config.AimMode = v end)
    CreateDropdown(p, "Hitbox", {"Head", "Torso", "Legs", "Random"}, function() return getgenv().Config.Hitbox end, function(v) getgenv().Config.Hitbox = v end)
    CreateSlider(p, "Hitbox Expand", 1.0, 2.5, 0.1, function() return getgenv().Config.HitboxExpand end, function(v) getgenv().Config.HitboxExpand = v end, "x")
    CreateSlider(p, "Aimbot FOV", 0, 500, 5, function() return getgenv().Config.FOV end, function(v) getgenv().Config.FOV = v end, "")
    CreateToggle(p, "Show FOV Circle", function() return getgenv().Config.ShowFOV end, function(v) getgenv().Config.ShowFOV = v end)
    CreateDropdown(p, "FOV Style", {"Smooth", "Glow", "Outline"}, function() return getgenv().Config.FOVStyle end, function(v) getgenv().Config.FOVStyle = v end)
    CreateToggle(p, "Smooth Enabled", function() return getgenv().Config.SmoothEnabled end, function(v) getgenv().Config.SmoothEnabled = v end)
    CreateSlider(p, "Smoothness X", 1, 100, 1, function() return getgenv().Config.SmoothX end, function(v) getgenv().Config.SmoothX = v end, "")
    CreateSlider(p, "Smoothness Y", 1, 100, 1, function() return getgenv().Config.SmoothY end, function(v) getgenv().Config.SmoothY = v end, "")
    CreateToggle(p, "Prediction", function() return getgenv().Config.Prediction end, function(v) getgenv().Config.Prediction = v end)
    CreateSlider(p, "Prediction X", 1, 20, 0.5, function() return getgenv().Config.PredX end, function(v) getgenv().Config.PredX = v end, "")
    CreateSlider(p, "Prediction Y", 1, 20, 0.5, function() return getgenv().Config.PredY end, function(v) getgenv().Config.PredY = v end, "")
    CreateToggle(p, "Resolver", function() return getgenv().Config.Resolver end, function(v) getgenv().Config.Resolver = v end)
    CreateToggle(p, "Triggerbot", function() return getgenv().Config.Triggerbot end, function(v) getgenv().Config.Triggerbot = v; setupTriggerBot() end)
    CreateSlider(p, "Trigger Delay (ms)", 1, 100, 1, function() return getgenv().Config.TriggerDelay end, function(v) getgenv().Config.TriggerDelay = v end, "ms")
    CreateSlider(p, "Trigger Release (ms)", 1, 100, 1, function() return getgenv().Config.TriggerRelease end, function(v) getgenv().Config.TriggerRelease = v end, "ms")
    CreateSlider(p, "Trigger Deadzone", 5, 50, 1, function() return getgenv().Config.TriggerDeadzone end, function(v) getgenv().Config.TriggerDeadzone = v end, "px")
end

-- ========== ВКЛАДКА VISUALS ==========
do
    local p = visTab.Page
    CreateToggle(p, "ESP Enabled", function() return getgenv().Config.ESP end, function(v) getgenv().Config.ESP = v end)
    CreateToggle(p, "Box", function() return getgenv().Config.ESPBox end, function(v) getgenv().Config.ESPBox = v end)
    CreateToggle(p, "Name", function() return getgenv().Config.ESPName end, function(v) getgenv().Config.ESPName = v end)
    CreateToggle(p, "Distance", function() return getgenv().Config.ESPDistance end, function(v) getgenv().Config.ESPDistance = v end)
    CreateToggle(p, "Health", function() return getgenv().Config.ESPHealth end, function(v) getgenv().Config.ESPHealth = v end)
    
    local colorFrame = Instance.new("Frame")
    colorFrame.Size = UDim2.new(1, -10, 0, 36)
    colorFrame.BackgroundTransparency = 1
    colorFrame.Parent = p
    local colorLabel = Instance.new("TextLabel")
    colorLabel.Size = UDim2.new(0, 200, 1, 0)
    colorLabel.BackgroundTransparency = 1
    colorLabel.Text = "ESP Color"
    colorLabel.TextColor3 = Color3.fromRGB(220, 220, 230)
    colorLabel.TextSize = 15
    colorLabel.Font = Enum.Font.Gotham
    colorLabel.TextXAlignment = Enum.TextXAlignment.Left
    colorLabel.Parent = colorFrame
    local colorBtn = Instance.new("TextButton")
    colorBtn.Size = UDim2.new(0, 60, 0, 26)
    colorBtn.Position = UDim2.new(1, -70, 0.5, -13)
    colorBtn.BackgroundColor3 = getgenv().Config.ESPColor
    colorBtn.Text = "RAND"
    colorBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    colorBtn.TextSize = 14
    colorBtn.Font = Enum.Font.GothamSemibold
    colorBtn.BorderSizePixel = 0
    colorBtn.Parent = colorFrame
    colorBtn.MouseButton1Click:Connect(function()
        local r = math.random(50, 255)
        local g = math.random(50, 255)
        local b = math.random(50, 255)
        local col = Color3.fromRGB(r, g, b)
        getgenv().Config.ESPColor = col
        colorBtn.BackgroundColor3 = col
    end)
end

-- ========== ВКЛАДКА MOVEMENT ==========
do
    local p = movTab.Page
    CreateSlider(p, "WalkSpeed", 16, 350, 5, function() return getgenv().Config.Speed end, function(v) 
        getgenv().Config.Speed = v
        if LP.Character and LP.Character:FindFirstChild("Humanoid") then LP.Character.Humanoid.WalkSpeed = v end
    end, "")
    CreateSlider(p, "JumpPower", 50, 200, 5, function() return getgenv().Config.Jump end, function(v)
        getgenv().Config.Jump = v
        if LP.Character and LP.Character:FindFirstChild("Humanoid") then LP.Character.Humanoid.JumpPower = v end
    end, "")
    CreateToggle(p, "Fly", function() return getgenv().Config.Fly end, function(v) getgenv().Config.Fly = v; toggleFly(v) end)
    CreateSlider(p, "Fly Speed", 10, 200, 5, function() return getgenv().Config.FlySpeed end, function(v) getgenv().Config.FlySpeed = v end, "")
    CreateToggle(p, "Noclip", function() return getgenv().Config.Noclip end, function(v) getgenv().Config.Noclip = v end)
end

-- ========== ВКЛАДКА SKINS ==========
do
    local p = skinTab.Page
    CreateToggle(p, "Skin Changer (BROKEN)", function() return getgenv().Config.SkinChanger end, function(v) getgenv().Config.SkinChanger = v end)
    local note = Instance.new("TextLabel")
    note.Size = UDim2.new(1, -10, 0, 30)
    note.BackgroundTransparency = 1
    note.Text = "⚠️ Public skins don't work. Find real IDs."
    note.TextColor3 = Color3.fromRGB(255, 150, 150)
    note.TextSize = 14
    note.Font = Enum.Font.Gotham
    note.TextWrapped = true
    note.Parent = p
    for name, id in pairs(getgenv().Skins) do
        CreateButton(p, name, function()
            getgenv().Config.CurrentSkin = id
            local notif = Instance.new("Frame")
            notif.Size = UDim2.new(0, 250, 0, 40)
            notif.Position = UDim2.new(1, -270, 0, 10)
            notif.BackgroundColor3 = Color3.fromRGB(18,18,24)
            notif.BackgroundTransparency = 0.1
            notif.BorderSizePixel = 0
            notif.Parent = ScreenGui
            local txt = Instance.new("TextLabel")
            txt.Size = UDim2.new(1, 0, 1, 0)
            txt.BackgroundTransparency = 1
            txt.Text = "Selected: " .. name
            txt.TextColor3 = Color3.fromRGB(255,255,255)
            txt.TextSize = 14
            txt.Font = Enum.Font.Gotham
            txt.Parent = notif
            task.delay(3, function() notif:Destroy() end)
        end)
    end
end

-- ========== ВКЛАДКА SETTINGS ==========
do
    local p = setTab.Page
    CreateToggle(p, "Aimlock Enabled", function() return getgenv().Config.Binds.Aimlock.Enabled end, function(v) getgenv().Config.Binds.Aimlock.Enabled = v end)
    CreateDropdown(p, "Aimlock Key", {"E", "Q", "MouseButton2", "XButton1", "XButton2", "LeftShift", "RightShift", "X", "C", "V", "F"},
        function() return getgenv().Config.Binds.Aimlock.Key end,
        function(v) getgenv().Config.Binds.Aimlock.Key = v end)
    CreateDropdown(p, "Aimlock Mode", {"Hold", "Toggle"},
        function() return getgenv().Config.Binds.Aimlock.Mode end,
        function(v) getgenv().Config.Binds.Aimlock.Mode = v end)
    CreateToggle(p, "Trigger Key Enabled", function() return getgenv().Config.Binds.Trigger.Enabled end, function(v) getgenv().Config.Binds.Trigger.Enabled = v end)
    CreateDropdown(p, "Trigger Key", {"E", "Q", "MouseButton2", "XButton1", "XButton2", "LeftShift", "RightShift", "X", "C", "V", "F"},
        function() return getgenv().Config.Binds.Trigger.Key end,
        function(v) getgenv().Config.Binds.Trigger.Key = v end)
    CreateDropdown(p, "Trigger Mode", {"Hold", "Toggle"},
        function() return getgenv().Config.Binds.Trigger.Mode end,
        function(v) getgenv().Config.Binds.Trigger.Mode = v end)
end

-- Активируем первую вкладку
if aimTab.Button then
    aimTab.Button.BackgroundColor3 = Color3.fromRGB(255, 50, 100)
    aimTab.Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    local ic = aimTab.Button:FindFirstChildOfClass("ImageLabel")
    if ic then ic.ImageColor3 = Color3.fromRGB(255, 255, 255) end
    aimTab.Page.Visible = true
end

setupTriggerBot()

UIS.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightShift then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

print("========================================")
print("🔥 RIVALS ZENITH by aspan666")
print("✅ KICIAHOOK LEGACY | XButton Support")
print("📌 Press RightShift for menu")
print("========================================")
