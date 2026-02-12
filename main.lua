--[[
    ░█▀█░█▀▀░█▀█░█▀▀░█▀▄░█▀█░▀█▀░█▀▀
    ░█▀█░█▀▀░█░█░█▀▀░█▀▄░█▀█░░█░░█▀▀
    ░▀░▀░▀▀▀░▀░▀░▀▀▀░▀░▀░▀░▀░░▀░░▀▀▀

    🔥 RIVALS INFERNO 🔥
    Made by aspan666
    Версия: ULTIMATE | Kiciahook UI
    GitHub: https://github.com/твой-ник/rivals-inferno
--]]

-- =============================================
-- 🛡️ АНТИ-БАН + ГЛУШИТЕЛЬ ОШИБОК
-- =============================================
pcall(function()
    local m = game:GetService("ReplicatedStorage"):FindFirstChild("Modules")
    if m then local b = m:FindFirstChild("BetterDebris") if b then b.Parent = nil end end
    
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
-- 📦 ЗАГРУЗКА БИБЛИОТЕКИ KICIAHOOK
-- =============================================
loadstring(game:HttpGet("https://raw.githubusercontent.com/kiciahook/kiciahook/refs/heads/main/loader.luau"))()
repeat wait() until _G.LibLoaded

-- =============================================
-- 🎨 СОЗДАНИЕ ОКНА
-- =============================================
local Window = _G.Lib:Window({
    Title = "RIVALS INFERNO",
    SubTitle = "made by aspan666 | premium",
    Bind = "RightShift",
    Startup = true,
    Theme = {
        Accent = Color3.fromRGB(255, 50, 100),
        Background = Color3.fromRGB(18, 18, 22),
        Glow = true,
        Blur = true
    }
})

-- =============================================
-- ⚙️ ГЛОБАЛЬНЫЕ НАСТРОЙКИ
-- =============================================
getgenv().Settings = {
    -- Aimbot
    Aimbot = false,
    AimMode = "Silent",
    Hitbox = "Head",
    FOV = 120,
    Smooth = 25,
    
    -- ESP
    ESP = false,
    ESPColor = Color3.fromRGB(255, 80, 80),
    ESPBox = true,
    ESPName = true,
    ESPDistance = true,
    ESPHealth = true,
    
    -- Movement
    Speed = 16,
    Jump = 50,
    Fly = false,
    FlySpeed = 50,
    Noclip = false,
    
    -- Skin Changer
    SkinChanger = false,
    CurrentSkin = nil,
}

getgenv().Skins = {
    ["❄️ Ice Dragon"] = 16789012345,
    ["🔥 Phoenix"] = 16789012346,
    ["👻 Shadow Reaper"] = 16789012347,
    ["🐯 Golden Tiger"] = 16789012348,
    ["🤖 Cyberpunk"] = 16789012349,
}

-- =============================================
-- 🎯 AIMBOT (SILENT + VISIBLE)
-- =============================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LP = Players.LocalPlayer
local Mouse = LP:GetMouse()

-- Silent Aim Hook
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if method == "FireServer" and tostring(self):find("Weapon") and getgenv().Settings.Aimbot and getgenv().Settings.AimMode == "Silent" then
        local closest, dist = nil, getgenv().Settings.FOV
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LP and p.Character and p.Character:FindFirstChild("Head") then
                local pos, vis = Camera:WorldToViewportPoint(p.Character.Head.Position)
                local d = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(pos.X, pos.Y)).Magnitude
                if d < dist and vis then
                    dist = d
                    closest = p
                end
            end
        end
        if closest then
            local hitPos
            if getgenv().Settings.Hitbox == "Head" then
                hitPos = closest.Character.Head.Position
            elseif getgenv().Settings.Hitbox == "Torso" then
                hitPos = (closest.Character:FindFirstChild("UpperTorso") or closest.Character:FindFirstChild("HumanoidRootPart")).Position
            elseif getgenv().Settings.Hitbox == "Legs" then
                hitPos = (closest.Character:FindFirstChild("LowerTorso") or closest.Character:FindFirstChild("Left Leg")).Position
            else -- Random
                local parts = {"Head", "UpperTorso", "HumanoidRootPart"}
                hitPos = closest.Character:FindFirstChild(parts[math.random(1, #parts)]).Position
            end
            args[2] = hitPos
            args[3] = hitPos
            return oldNamecall(self, unpack(args))
        end
    end
    return oldNamecall(self, ...)
end)

-- Visible Aim (Camera Smooth)
RunService.RenderStepped:Connect(function()
    if getgenv().Settings.Aimbot and getgenv().Settings.AimMode == "Visible" then
        local closest, dist = nil, getgenv().Settings.FOV
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LP and p.Character and p.Character:FindFirstChild("Head") then
                local pos, vis = Camera:WorldToViewportPoint(p.Character.Head.Position)
                local d = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(pos.X, pos.Y)).Magnitude
                if d < dist and vis then
                    dist = d
                    closest = p
                end
            end
        end
        if closest then
            Camera.CFrame = Camera.CFrame:Lerp(
                CFrame.new(Camera.CFrame.Position, closest.Character.Head.Position),
                getgenv().Settings.Smooth / 100
            )
        end
    end
end)

-- =============================================
-- 👁️ ESP (ПОЛНАЯ ВЕРСИЯ)
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
        ESP[p].Name.Size = 16
        ESP[p].Name.Center = true
        ESP[p].Name.Outline = true
        ESP[p].Name.Font = 3
        ESP[p].Dist.Size = 14
        ESP[p].Dist.Center = true
        ESP[p].Dist.Outline = true
        ESP[p].Dist.Font = 3
        ESP[p].Box.Thickness = 1.5
        ESP[p].Box.Filled = false
        ESP[p].HealthBg.Filled = true
        ESP[p].Health.Filled = true
        ESP[p].HealthBg.Color = Color3.new(0.2, 0.2, 0.2)
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
        ESP[p].Name.Size = 16
        ESP[p].Name.Center = true
        ESP[p].Name.Outline = true
        ESP[p].Name.Font = 3
        ESP[p].Dist.Size = 14
        ESP[p].Dist.Center = true
        ESP[p].Dist.Outline = true
        ESP[p].Dist.Font = 3
        ESP[p].Box.Thickness = 1.5
        ESP[p].Box.Filled = false
        ESP[p].HealthBg.Filled = true
        ESP[p].Health.Filled = true
        ESP[p].HealthBg.Color = Color3.new(0.2, 0.2, 0.2)
    end
end)

RunService.RenderStepped:Connect(function()
    if not getgenv().Settings.ESP then
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
            local rootPos, rootVis = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
            local headPos, headVis = Camera:WorldToViewportPoint(p.Character.Head.Position + Vector3.new(0, 0.5, 0))
            
            if rootVis and headVis then
                local height = math.abs((headPos.Y - rootPos.Y) * 1.5)
                local width = height * 0.6
                local boxPos = Vector2.new(rootPos.X - width/2, rootPos.Y - height/4)
                
                -- Box
                if getgenv().Settings.ESPBox then
                    e.Box.Visible = true
                    e.Box.Color = getgenv().Settings.ESPColor
                    e.Box.Position = boxPos
                    e.Box.Size = Vector2.new(width, height)
                else
                    e.Box.Visible = false
                end
                
                -- Name
                if getgenv().Settings.ESPName then
                    e.Name.Visible = true
                    e.Name.Position = Vector2.new(rootPos.X, rootPos.Y - height/2 - 20)
                    e.Name.Text = p.Name
                    e.Name.Color = getgenv().Settings.ESPColor
                else
                    e.Name.Visible = false
                end
                
                -- Distance
                if getgenv().Settings.ESPDistance then
                    e.Dist.Visible = true
                    e.Dist.Position = Vector2.new(rootPos.X, rootPos.Y - height/2 - 5)
                    e.Dist.Text = math.floor((LP.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude) .. "m"
                    e.Dist.Color = Color3.new(1, 1, 1)
                else
                    e.Dist.Visible = false
                end
                
                -- Health
                if getgenv().Settings.ESPHealth then
                    local health = p.Character.Humanoid.Health
                    local maxHealth = p.Character.Humanoid.MaxHealth
                    local healthPercent = health / maxHealth
                    
                    e.HealthBg.Visible = true
                    e.HealthBg.Position = Vector2.new(boxPos.X - 6, boxPos.Y)
                    e.HealthBg.Size = Vector2.new(3, height)
                    
                    e.Health.Visible = true
                    e.Health.Position = Vector2.new(boxPos.X - 6, boxPos.Y + (height * (1 - healthPercent)))
                    e.Health.Size = Vector2.new(3, height * healthPercent)
                    e.Health.Color = Color3.fromRGB(255 - (255 * healthPercent), 255 * healthPercent, 0)
                else
                    e.HealthBg.Visible = false
                    e.Health.Visible = false
                end
            else
                e.Box.Visible = false
                e.Name.Visible = false
                e.Dist.Visible = false
                e.Health.Visible = false
                e.HealthBg.Visible = false
            end
        end
    end
end)

-- =============================================
-- 🚀 FLY + NOCLIP
-- =============================================
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
        if not getgenv().Settings.Fly then
            flyConnection:Disconnect()
            return
        end
        local moveDir = h.MoveDirection
        local velocity = (Camera.CFrame.RightVector * moveDir.X +
                         Camera.CFrame.UpVector * moveDir.Y +
                         Camera.CFrame.LookVector * -moveDir.Z) * getgenv().Settings.FlySpeed
        r.Velocity = velocity
    end)
end

RunService.Stepped:Connect(function()
    if getgenv().Settings.Noclip and LP.Character then
        for _, part in pairs(LP.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- =============================================
-- 🎨 SKIN CHANGER (РАБОЧИЙ ХУК)
-- =============================================
local oldSkinHook
oldSkinHook = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    local remoteName = tostring(self)
    
    if method == "FireServer" then
        if (remoteName:find("HasSkin") or remoteName:find("Inventory")) and getgenv().Settings.SkinChanger then
            return true
        end
        if (remoteName:find("Purchase") or remoteName:find("BuySkin")) and getgenv().Settings.SkinChanger then
            return {Success = true, SkinId = args[1], Message = "OK"}
        end
        if (remoteName:find("Equip") or remoteName:find("SelectSkin")) and getgenv().Settings.SkinChanger and getgenv().Settings.CurrentSkin then
            args[1] = getgenv().Settings.CurrentSkin
            return oldSkinHook(self, unpack(args))
        end
    end
    return oldSkinHook(self, ...)
end)

-- =============================================
-- 🖥️ СОЗДАНИЕ ВКЛАДОК UI (KICIAHOOK)
-- =============================================
local AimbotTab = Window:Tab({Name = "🎯 Aimbot", Icon = "rbxassetid://13951167659"})
local ESPTab = Window:Tab({Name = "👁️ ESP", Icon = "rbxassetid://13951169214"})
local MoveTab = Window:Tab({Name = "🚀 Movement", Icon = "rbxassetid://13951164120"})
local SkinTab = Window:Tab({Name = "🎨 Skin Changer", Icon = "rbxassetid://13951167951"})

-- =============================================
-- 🎯 AIMBOT TAB
-- =============================================
local AimbotSection = AimbotTab:Section({Name = "ОСНОВНЫЕ НАСТРОЙКИ", Side = "Left"})

AimbotSection:Toggle({
    Name = "Aimbot",
    Desc = "Включить автонаведение",
    Flag = "aimbot_toggle",
    Value = getgenv().Settings.Aimbot,
    Callback = function(v) getgenv().Settings.Aimbot = v end
})

AimbotSection:Dropdown({
    Name = "Режим",
    Desc = "Silent - невидимый, Visible - плавный",
    Flag = "aim_mode",
    Options = {"Silent", "Visible"},
    Default = getgenv().Settings.AimMode,
    Callback = function(v) getgenv().Settings.AimMode = v end
})

AimbotSection:Dropdown({
    Name = "Хитбокс",
    Desc = "Часть тела для наведения",
    Flag = "hitbox",
    Options = {"Head", "Torso", "Legs", "Random"},
    Default = getgenv().Settings.Hitbox,
    Callback = function(v) getgenv().Settings.Hitbox = v end
})

AimbotSection:Slider({
    Name = "FOV",
    Desc = "Радиус захвата цели",
    Min = 30,
    Max = 360,
    Default = getgenv().Settings.FOV,
    Flag = "fov",
    Callback = function(v) getgenv().Settings.FOV = v end
})

AimbotSection:Slider({
    Name = "Smooth",
    Desc = "Плавность наведения (Visible)",
    Min = 1,
    Max = 100,
    Default = getgenv().Settings.Smooth,
    Flag = "smooth",
    Callback = function(v) getgenv().Settings.Smooth = v end
})

-- =============================================
-- 👁️ ESP TAB
-- =============================================
local ESPSection = ESPTab:Section({Name = "ВИЗУАЛЬНЫЕ УЛУЧШЕНИЯ", Side = "Left"})

ESPSection:Toggle({
    Name = "ESP",
    Desc = "Показывать врагов сквозь стены",
    Flag = "esp_toggle",
    Value = getgenv().Settings.ESP,
    Callback = function(v) getgenv().Settings.ESP = v end
})

ESPSection:Toggle({
    Name = "Box",
    Desc = "Рамка вокруг игрока",
    Flag = "esp_box",
    Value = getgenv().Settings.ESPBox,
    Callback = function(v) getgenv().Settings.ESPBox = v end
})

ESPSection:Toggle({
    Name = "Name",
    Desc = "Показывать ник",
    Flag = "esp_name",
    Value = getgenv().Settings.ESPName,
    Callback = function(v) getgenv().Settings.ESPName = v end
})

ESPSection:Toggle({
    Name = "Distance",
    Desc = "Дистанция до цели",
    Flag = "esp_dist",
    Value = getgenv().Settings.ESPDistance,
    Callback = function(v) getgenv().Settings.ESPDistance = v end
})

ESPSection:Toggle({
    Name = "Health",
    Desc = "Полоска здоровья",
    Flag = "esp_health",
    Value = getgenv().Settings.ESPHealth,
    Callback = function(v) getgenv().Settings.ESPHealth = v end
})

ESPSection:Colorpicker({
    Name = "Цвет ESP",
    Desc = "Цвет рамки и ника",
    Flag = "esp_color",
    Default = getgenv().Settings.ESPColor,
    Callback = function(v) getgenv().Settings.ESPColor = v end
})

-- =============================================
-- 🚀 MOVEMENT TAB
-- =============================================
local MoveSection = MoveTab:Section({Name = "ПЕРЕДВИЖЕНИЕ", Side = "Left"})

MoveSection:Slider({
    Name = "WalkSpeed",
    Desc = "Скорость бега",
    Min = 16,
    Max = 350,
    Default = getgenv().Settings.Speed,
    Flag = "speed",
    Callback = function(v)
        getgenv().Settings.Speed = v
        if LP.Character and LP.Character:FindFirstChild("Humanoid") then
            LP.Character.Humanoid.WalkSpeed = v
        end
    end
})

MoveSection:Slider({
    Name = "JumpPower",
    Desc = "Сила прыжка",
    Min = 50,
    Max = 200,
    Default = getgenv().Settings.Jump,
    Flag = "jump",
    Callback = function(v)
        getgenv().Settings.Jump = v
        if LP.Character and LP.Character:FindFirstChild("Humanoid") then
            LP.Character.Humanoid.JumpPower = v
        end
    end
})

MoveSection:Toggle({
    Name = "Fly",
    Desc = "Режим полёта",
    Flag = "fly",
    Value = getgenv().Settings.Fly,
    Callback = function(v)
        getgenv().Settings.Fly = v
        toggleFly(v)
    end
})

MoveSection:Slider({
    Name = "Fly Speed",
    Desc = "Скорость полёта",
    Min = 10,
    Max = 200,
    Default = getgenv().Settings.FlySpeed,
    Flag = "fly_speed",
    Callback = function(v) getgenv().Settings.FlySpeed = v end
})

MoveSection:Toggle({
    Name = "Noclip",
    Desc = "Прохождение сквозь стены",
    Flag = "noclip",
    Value = getgenv().Settings.Noclip,
    Callback = function(v) getgenv().Settings.Noclip = v end
})

-- =============================================
-- 🎨 SKIN CHANGER TAB
-- =============================================
local SkinSection = SkinTab:Section({Name = "СКИН ЧЕНДЖЕР", Side = "Left"})

SkinSection:Toggle({
    Name = "Skin Changer",
    Desc = "Активировать скин-ченджер",
    Flag = "skin_toggle",
    Value = getgenv().Settings.SkinChanger,
    Callback = function(v) getgenv().Settings.SkinChanger = v end
})

SkinSection:Label("Доступные скины:")

for name, id in pairs(getgenv().Skins) do
    SkinSection:Button({
        Name = name,
        Desc = "Asset ID: " .. id,
        Callback = function()
            getgenv().Settings.CurrentSkin = id
            _G.Lib:Notification({
                Title = "Skin Changer",
                Desc = "Выбран скин: " .. name,
                Duration = 3
            })
        end
    })
end

-- =============================================
-- 🏁 ФИНАЛЬНОЕ УВЕДОМЛЕНИЕ
-- =============================================
_G.Lib:Notification({
    Title = "RIVALS INFERNO",
    Desc = "✅ Made by aspan666\n🔥 Полная версия загружена",
    Duration = 5
})

print("========================================")
print("🔥 RIVALS INFERNO | aspan666")
print("✅ ПОЛНАЯ ВЕРСИЯ ЗАГРУЖЕНА")
print("📌 Нажми RightShift для открытия меню")
print("========================================")
