--[[
    █▀█ █ █▀▄▀█ █▀ ▀█▀ █▀█ █▀█ █ █▀▀ █▀▄
    █▀▄ █ █░▀░█ ▄█ ░█░ █▄█ █▀▄ █ ██▄ █▄▀

    🔥 RIVALS ZENITH 🔥
    Made by aspan666
    Версия: 4.0.0 | ULTIMATE
    Стиль: Kiciahook Legacy | Полный Matcha-функционал
--]]

-- =============================================
-- 🛡️ АНТИ-БАН + ГЛУШИТЕЛЬ
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
end)

-- =============================================
-- ⚙️ КОНФИГУРАЦИЯ (MATCHA SPEC)
-- =============================================
getgenv().Config = {
    -- Aimbot Core
    Aimbot = false,
    AimMode = "Silent",
    Hitbox = "Head",
    HitboxExpand = 2.5,
    FOV = 169,
    ShowFOV = true,
    FOVColor = Color3.fromRGB(255, 80, 80),
    
    -- Smoothness
    SmoothEnabled = true,
    SmoothX = 1.0,
    SmoothY = 20.0,
    
    -- Prediction
    Prediction = true,
    PredX = 1.0,
    PredY = 20.0,
    Resolver = true,
    
    -- Trigger Bot
    Triggerbot = false,
    TriggerDelay = 1,
    TriggerRelease = 1,
    
    -- ESP
    ESP = false,
    ESPBox = true,
    ESPName = true,
    ESPDistance = true,
    ESPHealth = true,
    ESPColor = Color3.fromRGB(255, 80, 80),
    
    -- Movement
    Speed = 16,
    Jump = 50,
    Fly = false,
    FlySpeed = 50,
    Noclip = false,
    
    -- Skins
    SkinChanger = false,
    CurrentSkin = nil,
}

getgenv().Skins = {
    ["❄️ Ice Dragon"] = 16789012345,
    ["🔥 Phoenix"] = 16789012346,
    ["👻 Shadow Reaper"] = 16789012347,
    ["🐯 Golden Tiger"] = 16789012348,
    ["🤖 Cyberpunk"] = 16789012349,
    ["⚡ Season 1"] = 16789012350,
    ["💎 Void Walker"] = 16789012351,
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
FOVCircle.Thickness = 1.5
FOVCircle.NumSides = 64
FOVCircle.Filled = false

RunService.RenderStepped:Connect(function()
    if getgenv().Config.ShowFOV and getgenv().Config.Aimbot then
        FOVCircle.Visible = true
        FOVCircle.Radius = getgenv().Config.FOV
        FOVCircle.Color = getgenv().Config.FOVColor
        FOVCircle.Position = Vector2.new(Mouse.X, Mouse.Y)
    else
        FOVCircle.Visible = false
    end
end)

local function getClosestPlayer()
    local closest, shortest = nil, getgenv().Config.FOV
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Character and p.Character:FindFirstChild("Head") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
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
    if hitbox == "Head" then
        return p.Character.Head.Position
    elseif hitbox == "Torso" then
        local part = p.Character:FindFirstChild("UpperTorso") or p.Character:FindFirstChild("HumanoidRootPart")
        return part and part.Position
    elseif hitbox == "Legs" then
        local part = p.Character:FindFirstChild("LowerTorso") or p.Character:FindFirstChild("Left Leg")
        return part and part.Position
    else -- Random
        local parts = {"Head", "UpperTorso", "HumanoidRootPart"}
        return p.Character:FindFirstChild(parts[math.random(1, #parts)]).Position
    end
end

-- Visible Aim
RunService.RenderStepped:Connect(function()
    if getgenv().Config.Aimbot and getgenv().Config.AimMode == "Visible" then
        local target = getClosestPlayer()
        if target then
            local hitPos = getHitboxPosition(target)
            if hitPos then
                local sx = getgenv().Config.SmoothEnabled and getgenv().Config.SmoothX or 1
                local sy = getgenv().Config.SmoothEnabled and getgenv().Config.SmoothY or 1
                local goal = CFrame.new(Camera.CFrame.Position, hitPos)
                Camera.CFrame = Camera.CFrame:Lerp(goal, (sx+sy)/200)
            end
        end
    end
end)

-- Silent Aim Hook
if getgenv().Config.AimMode == "Silent" or getgenv().Config.AimMode == "Rage" then
    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        if method == "FireServer" and tostring(self):find("Weapon") and getgenv().Config.Aimbot then
            local target = getClosestPlayer()
            if target then
                local hitPos = getHitboxPosition(target)
                if getgenv().Config.Prediction and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                    local vel = target.Character.HumanoidRootPart.Velocity
                    hitPos = hitPos + Vector3.new(vel.X * (getgenv().Config.PredX/20), vel.Y * (getgenv().Config.PredY/20), vel.Z * (getgenv().Config.PredX/20))
                end
                if hitPos then
                    args[2] = hitPos
                    args[3] = hitPos
                    return oldNamecall(self, unpack(args))
                end
            end
        end
        return oldNamecall(self, ...)
    end)
end

-- Trigger Bot
local triggerConnection
local function setupTriggerBot()
    if triggerConnection then triggerConnection:Disconnect() end
    if not getgenv().Config.Triggerbot then return end
    triggerConnection = RunService.RenderStepped:Connect(function()
        if getgenv().Config.Triggerbot then
            local target = getClosestPlayer()
            if target then
                task.wait(getgenv().Config.TriggerDelay/1000)
                mouse1press()
                task.wait(getgenv().Config.TriggerRelease/1000)
                mouse1release()
            end
        end
    end)
end

-- =============================================
-- 👁️ ESP
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
        ESP[p].Dist.Size = 14; ESP[p].Dist.Center = true; ESP[p].Dist.Outline = true; ESP[p].Dist.Font = 3
        ESP[p].Box.Thickness = 1.5; ESP[p].Box.Filled = false
        ESP[p].HealthBg.Filled = true; ESP[p].Health.Filled = true
        ESP[p].HealthBg.Color = Color3.fromRGB(20,20,20)
    end
end
Players.PlayerAdded:Connect(function(p) if p ~= LP then
    ESP[p] = {
        Box = Drawing.new("Square"),
        Name = Drawing.new("Text"),
        Dist = Drawing.new("Text"),
        Health = Drawing.new("Square"),
        HealthBg = Drawing.new("Square"),
    }
    ESP[p].Name.Size = 16; ESP[p].Name.Center = true; ESP[p].Name.Outline = true; ESP[p].Name.Font = 3
    ESP[p].Dist.Size = 14; ESP[p].Dist.Center = true; ESP[p].Dist.Outline = true; ESP[p].Dist.Font = 3
    ESP[p].Box.Thickness = 1.5; ESP[p].Box.Filled = false
    ESP[p].HealthBg.Filled = true; ESP[p].Health.Filled = true
    ESP[p].HealthBg.Color = Color3.fromRGB(20,20,20)
end end)

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
        if p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Head") then
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
        if not getgenv().Config.Fly then flyConnection:Disconnect() return end
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
-- 🎨 SKIN CHANGER HOOK
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
            return {Success = true, SkinId = a[1]}
        end
        if (rn:find("Equip") or rn:find("SelectSkin")) and getgenv().Config.SkinChanger and getgenv().Config.CurrentSkin then
            a[1] = getgenv().Config.CurrentSkin
            return oldSkinHook(self, unpack(a))
        end
    end
    return oldSkinHook(self, ...)
end)

-- =============================================
-- 🖥️ ИНТЕРФЕЙС — ПОЛНОЦЕННЫЙ ХАБ С ВКЛАДКАМИ
-- =============================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Zenith_aspan666"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 650, 0, 450)
MainFrame.Position = UDim2.new(0.5, -325, 0.5, -225)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
MainFrame.BackgroundTransparency = 0.05
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui
MainFrame.Visible = true

-- Внешний контур
local Outline1 = Instance.new("ImageLabel")
Outline1.Size = UDim2.new(1, -2, 1, -2)
Outline1.Position = UDim2.new(0, 1, 0, 1)
Outline1.BackgroundTransparency = 1
Outline1.Image = "rbxassetid://2592362371"
Outline1.ImageColor3 = Color3.fromRGB(40, 40, 45)
Outline1.ScaleType = Enum.ScaleType.Slice
Outline1.SliceCenter = Rect.new(2, 2, 62, 62)
Outline1.Parent = MainFrame

local Outline2 = Instance.new("ImageLabel")
Outline2.Size = UDim2.new(1, 0, 1, 0)
Outline2.BackgroundTransparency = 1
Outline2.Image = "rbxassetid://2592362371"
Outline2.ImageColor3 = Color3.fromRGB(8, 8, 10)
Outline2.ScaleType = Enum.ScaleType.Slice
Outline2.SliceCenter = Rect.new(2, 2, 62, 62)
Outline2.Parent = MainFrame

-- Верхняя панель
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, -10, 0, 40)
TopBar.Position = UDim2.new(0, 5, 0, 5)
TopBar.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
TopBar.BackgroundTransparency = 0.2
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 250, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "RIVALS ZENITH"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 20
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

local SubTitle = Instance.new("TextLabel")
SubTitle.Size = UDim2.new(0, 200, 1, 0)
SubTitle.Position = UDim2.new(0, 190, 0, 0)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "made by aspan666"
SubTitle.TextColor3 = Color3.fromRGB(180, 180, 180)
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
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -40, 0.5, -15)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 100)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 18
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = TopBar
CloseBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false end)

-- Контейнер для кнопок вкладок
local TabButtonsContainer = Instance.new("Frame")
TabButtonsContainer.Size = UDim2.new(1, -20, 0, 40)
TabButtonsContainer.Position = UDim2.new(0, 10, 0, 50)
TabButtonsContainer.BackgroundTransparency = 1
TabButtonsContainer.Parent = MainFrame

local TabButtonsLayout = Instance.new("UIListLayout")
TabButtonsLayout.FillDirection = Enum.FillDirection.Horizontal
TabButtonsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
TabButtonsLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabButtonsLayout.Padding = UDim.new(0, 10)
TabButtonsLayout.Parent = TabButtonsContainer

-- Контейнер для содержимого вкладок
local TabContentContainer = Instance.new("Frame")
TabContentContainer.Size = UDim2.new(1, -20, 1, -100)
TabContentContainer.Position = UDim2.new(0, 10, 0, 95)
TabContentContainer.BackgroundTransparency = 1
TabContentContainer.Parent = MainFrame

-- Создание вкладок
local Tabs = {}
local function createTab(name, iconId)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 110, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    btn.BackgroundTransparency = 0.2
    btn.Text = "   " .. name
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.TextSize = 15
    btn.Font = Enum.Font.GothamSemibold
    btn.BorderSizePixel = 0
    btn.Parent = TabButtonsContainer
    
    local icon = Instance.new("ImageLabel")
    icon.Size = UDim2.new(0, 18, 0, 18)
    icon.Position = UDim2.new(0, 8, 0.5, -9)
    icon.BackgroundTransparency = 1
    icon.Image = iconId or "rbxassetid://13951167659"
    icon.ImageColor3 = Color3.fromRGB(200, 200, 200)
    icon.Parent = btn
    
    local content = Instance.new("ScrollingFrame")
    content.Size = UDim2.new(1, 0, 1, 0)
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.ScrollBarThickness = 4
    content.ScrollBarImageColor3 = Color3.fromRGB(255, 50, 100)
    content.CanvasSize = UDim2.new(0, 0, 0, 0)
    content.AutomaticCanvasSize = Enum.AutomaticSize.Y
    content.Visible = false
    content.Parent = TabContentContainer
    
    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Vertical
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 15)
    layout.Parent = content
    
    btn.MouseButton1Click:Connect(function()
        for _, b in pairs(TabButtonsContainer:GetChildren()) do
            if b:IsA("TextButton") then
                b.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
                b.TextColor3 = Color3.fromRGB(200, 200, 200)
                local ic = b:FindFirstChildOfClass("ImageLabel")
                if ic then ic.ImageColor3 = Color3.fromRGB(200, 200, 200) end
            end
        end
        btn.BackgroundColor3 = Color3.fromRGB(255, 50, 100)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        icon.ImageColor3 = Color3.fromRGB(255, 255, 255)
        
        for _, c in pairs(TabContentContainer:GetChildren()) do
            if c:IsA("ScrollingFrame") then
                c.Visible = false
            end
        end
        content.Visible = true
    end)
    
    table.insert(Tabs, {Button = btn, Content = content, Layout = layout})
    return {Content = content, Layout = layout}
end

-- ========== СОЗДАНИЕ ВКЛАДОК ==========
local AimTab = createTab("AIMBOT", "rbxassetid://13951167659")
local VisualsTab = createTab("VISUALS", "rbxassetid://13951169214")
local MoveTab = createTab("MOVEMENT", "rbxassetid://13951164120")
local SkinsTab = createTab("SKINS", "rbxassetid://13951167951")

-- ========== ФУНКЦИИ ДЛЯ СОЗДАНИЯ ЭЛЕМЕНТОВ ==========
local function createToggle(parent, name, get, set)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 35)
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 200, 1, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.TextSize = 15
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 60, 0, 26)
    btn.Position = UDim2.new(1, -70, 0.5, -13)
    btn.BackgroundColor3 = get() and Color3.fromRGB(255, 50, 100) or Color3.fromRGB(40, 40, 45)
    btn.Text = get() and "ON" or "OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamSemibold
    btn.BorderSizePixel = 0
    btn.Parent = frame
    btn.MouseButton1Click:Connect(function()
        local new = not get()
        set(new)
        btn.BackgroundColor3 = new and Color3.fromRGB(255, 50, 100) or Color3.fromRGB(40, 40, 45)
        btn.Text = new and "ON" or "OFF"
    end)
end

local function createSlider(parent, name, min, max, inc, get, set, suffix)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 45)
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 200, 0, 20)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name .. ": " .. tostring(get())
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.TextSize = 15
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(0, 300, 0, 6)
    bg.Position = UDim2.new(0, 0, 0, 28)
    bg.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
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
    valLabel.Size = UDim2.new(0, 60, 0, 20)
    valLabel.Position = UDim2.new(1, -320, 0, 28)
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
            label.Text = name .. ": " .. tostring(val)
            valLabel.Text = tostring(val) .. (suffix or "")
        end
    end)
end

local function createDropdown(parent, name, options, get, set)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 35)
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 200, 1, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.TextSize = 15
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 120, 0, 26)
    btn.Position = UDim2.new(1, -130, 0.5, -13)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
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

local function createButton(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(255, 50, 100)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 15
    btn.Font = Enum.Font.GothamSemibold
    btn.BorderSizePixel = 0
    btn.Parent = parent
    btn.MouseButton1Click:Connect(callback)
end

-- ========== ЗАПОЛНЕНИЕ ВКЛАДКИ AIMBOT ==========
do
    local content = AimTab.Content
    local layout = AimTab.Layout
    
    createToggle(content, "Aimbot Enabled", 
        function() return getgenv().Config.Aimbot end,
        function(v) getgenv().Config.Aimbot = v end)
    
    createDropdown(content, "Aim Type", {"Silent", "Visible", "Rage"},
        function() return getgenv().Config.AimMode end,
        function(v) getgenv().Config.AimMode = v end)
    
    createDropdown(content, "Hitbox", {"Head", "Torso", "Legs", "Random"},
        function() return getgenv().Config.Hitbox end,
        function(v) getgenv().Config.Hitbox = v end)
    
    createSlider(content, "Hitbox Expand", 1.0, 2.5, 0.1,
        function() return getgenv().Config.HitboxExpand end,
        function(v) getgenv().Config.HitboxExpand = v end, "x")
    
    createSlider(content, "Aimbot FOV", 0, 500, 5,
        function() return getgenv().Config.FOV end,
        function(v) getgenv().Config.FOV = v end, "")
    
    createToggle(content, "Show FOV Circle",
        function() return getgenv().Config.ShowFOV end,
        function(v) getgenv().Config.ShowFOV = v end)
    
    -- Разделитель
    local sep = Instance.new("Frame")
    sep.Size = UDim2.new(1, -10, 0, 1)
    sep.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    sep.BorderSizePixel = 0
    sep.Parent = content
    
    createToggle(content, "Smooth Enabled",
        function() return getgenv().Config.SmoothEnabled end,
        function(v) getgenv().Config.SmoothEnabled = v end)
    
    createSlider(content, "Smoothness X", 1, 100, 1,
        function() return getgenv().Config.SmoothX end,
        function(v) getgenv().Config.SmoothX = v end, "")
    
    createSlider(content, "Smoothness Y", 1, 100, 1,
        function() return getgenv().Config.SmoothY end,
        function(v) getgenv().Config.SmoothY = v end, "")
    
    sep = Instance.new("Frame")
    sep.Size = UDim2.new(1, -10, 0, 1)
    sep.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    sep.BorderSizePixel = 0
    sep.Parent = content
    
    createToggle(content, "Prediction",
        function() return getgenv().Config.Prediction end,
        function(v) getgenv().Config.Prediction = v end)
    
    createSlider(content, "Prediction X", 1, 20, 0.5,
        function() return getgenv().Config.PredX end,
        function(v) getgenv().Config.PredX = v end, "")
    
    createSlider(content, "Prediction Y", 1, 20, 0.5,
        function() return getgenv().Config.PredY end,
        function(v) getgenv().Config.PredY = v end, "")
    
    createToggle(content, "Resolver",
        function() return getgenv().Config.Resolver end,
        function(v) getgenv().Config.Resolver = v end)
    
    sep = Instance.new("Frame")
    sep.Size = UDim2.new(1, -10, 0, 1)
    sep.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    sep.BorderSizePixel = 0
    sep.Parent = content
    
    createToggle(content, "Triggerbot",
        function() return getgenv().Config.Triggerbot end,
        function(v) getgenv().Config.Triggerbot = v; setupTriggerBot() end)
    
    createSlider(content, "Trigger Delay (ms)", 1, 100, 1,
        function() return getgenv().Config.TriggerDelay end,
        function(v) getgenv().Config.TriggerDelay = v end, "ms")
    
    createSlider(content, "Trigger Release (ms)", 1, 100, 1,
        function() return getgenv().Config.TriggerRelease end,
        function(v) getgenv().Config.TriggerRelease = v end, "ms")
end

-- ========== ЗАПОЛНЕНИЕ ВКЛАДКИ VISUALS ==========
do
    local content = VisualsTab.Content
    local layout = VisualsTab.Layout
    
    createToggle(content, "ESP Enabled",
        function() return getgenv().Config.ESP end,
        function(v) getgenv().Config.ESP = v end)
    
    createToggle(content, "Box",
        function() return getgenv().Config.ESPBox end,
        function(v) getgenv().Config.ESPBox = v end)
    
    createToggle(content, "Name",
        function() return getgenv().Config.ESPName end,
        function(v) getgenv().Config.ESPName = v end)
    
    createToggle(content, "Distance",
        function() return getgenv().Config.ESPDistance end,
        function(v) getgenv().Config.ESPDistance = v end)
    
    createToggle(content, "Health",
        function() return getgenv().Config.ESPHealth end,
        function(v) getgenv().Config.ESPHealth = v end)
    
    -- Простой ColorPicker (случайный цвет)
    local colorBtn = Instance.new("TextButton")
    colorBtn.Size = UDim2.new(1, -10, 0, 35)
    colorBtn.BackgroundColor3 = getgenv().Config.ESPColor
    colorBtn.Text = "ESP Color (click to randomize)"
    colorBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    colorBtn.TextSize = 15
    colorBtn.Font = Enum.Font.Gotham
    colorBtn.BorderSizePixel = 0
    colorBtn.Parent = content
    colorBtn.MouseButton1Click:Connect(function()
        local r = math.random(50, 255)
        local g = math.random(50, 255)
        local b = math.random(50, 255)
        local col = Color3.fromRGB(r, g, b)
        getgenv().Config.ESPColor = col
        colorBtn.BackgroundColor3 = col
    end)
end

-- ========== ЗАПОЛНЕНИЕ ВКЛАДКИ MOVEMENT ==========
do
    local content = MoveTab.Content
    local layout = MoveTab.Layout
    
    createSlider(content, "WalkSpeed", 16, 350, 5,
        function() return getgenv().Config.Speed end,
        function(v) 
            getgenv().Config.Speed = v
            if LP.Character and LP.Character:FindFirstChild("Humanoid") then
                LP.Character.Humanoid.WalkSpeed = v
            end
        end, "")
    
    createSlider(content, "JumpPower", 50, 200, 5,
        function() return getgenv().Config.Jump end,
        function(v)
            getgenv().Config.Jump = v
            if LP.Character and LP.Character:FindFirstChild("Humanoid") then
                LP.Character.Humanoid.JumpPower = v
            end
        end, "")
    
    createToggle(content, "Fly",
        function() return getgenv().Config.Fly end,
        function(v) getgenv().Config.Fly = v; toggleFly(v) end)
    
    createSlider(content, "Fly Speed", 10, 200, 5,
        function() return getgenv().Config.FlySpeed end,
        function(v) getgenv().Config.FlySpeed = v end, "")
    
    createToggle(content, "Noclip",
        function() return getgenv().Config.Noclip end,
        function(v) getgenv().Config.Noclip = v end)
end

-- ========== ЗАПОЛНЕНИЕ ВКЛАДКИ SKINS ==========
do
    local content = SkinsTab.Content
    local layout = SkinsTab.Layout
    
    createToggle(content, "Skin Changer",
        function() return getgenv().Config.SkinChanger end,
        function(v) getgenv().Config.SkinChanger = v end)
    
    for name, id in pairs(getgenv().Skins) do
        createButton(content, name, function()
            getgenv().Config.CurrentSkin = id
            -- уведомление
            local notif = Instance.new("Frame")
            notif.Size = UDim2.new(0, 250, 0, 40)
            notif.Position = UDim2.new(1, -270, 0, 10)
            notif.BackgroundColor3 = Color3.fromRGB(18,18,22)
            notif.BackgroundTransparency = 0.1
            notif.BorderSizePixel = 0
            notif.Parent = ScreenGui
            local txt = Instance.new("TextLabel")
            txt.Size = UDim2.new(1, 0, 1, 0)
            txt.BackgroundTransparency = 1
            txt.Text = "✅ Skin: " .. name
            txt.TextColor3 = Color3.fromRGB(255,255,255)
            txt.TextSize = 14
            txt.Font = Enum.Font.Gotham
            txt.Parent = notif
            task.delay(3, function() notif:Destroy() end)
        end)
    end
end

-- Активируем первую вкладку
if #Tabs > 0 then
    Tabs[1].Button.BackgroundColor3 = Color3.fromRGB(255, 50, 100)
    Tabs[1].Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    local ic = Tabs[1].Button:FindFirstChildOfClass("ImageLabel")
    if ic then ic.ImageColor3 = Color3.fromRGB(255, 255, 255) end
    Tabs[1].Content.Visible = true
end

-- Открытие/закрытие по RightShift
UIS.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightShift then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

print("========================================")
print("🔥 RIVALS ZENITH by aspan666")
print("✅ ULTIMATE EDITION LOADED")
print("📌 Press RightShift for menu")
print("========================================")
