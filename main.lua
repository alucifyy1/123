--[[
    ░█▀█░█▀▀░█▀█░█▀▀░█▀▄░█▀█░▀█▀░█▀▀
    ░█▀█░█▀▀░█░█░█▀▀░█▀▄░█▀█░░█░░█▀▀
    ░▀░▀░▀▀▀░▀░▀░▀▀▀░▀░▀░▀░▀░░▀░░▀▀▀

    🔥 RIVALS INFERNO 🔥
    Made by aspan666
    Версия: RAYFIELD EDITION | 100% СТАБИЛЬНО
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
-- 📦 ЗАГРУЗКА RAYFIELD (РАБОТАЕТ ВСЕГДА)
-- =============================================
local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source"))()
wait(0.5)

-- =============================================
-- ⚙️ ГЛОБАЛЬНЫЕ НАСТРОЙКИ
-- =============================================
getgenv().Settings = {
    Aimbot = false,
    AimMode = "Silent",
    Hitbox = "Head",
    FOV = 120,
    Smooth = 25,
    ESP = false,
    ESPColor = Color3.fromRGB(255, 80, 80),
    ESPBox = true,
    ESPName = true,
    ESPDistance = true,
    ESPHealth = true,
    Speed = 16,
    Jump = 50,
    Fly = false,
    FlySpeed = 50,
    Noclip = false,
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
                if d < dist and vis then dist = d; closest = p end
            end
        end
        if closest then
            local hitPos
            if getgenv().Settings.Hitbox == "Head" then hitPos = closest.Character.Head.Position
            elseif getgenv().Settings.Hitbox == "Torso" then hitPos = (closest.Character:FindFirstChild("UpperTorso") or closest.Character:FindFirstChild("HumanoidRootPart")).Position
            elseif getgenv().Settings.Hitbox == "Legs" then hitPos = (closest.Character:FindFirstChild("LowerTorso") or closest.Character:FindFirstChild("Left Leg")).Position
            else local parts = {"Head", "UpperTorso", "HumanoidRootPart"}; hitPos = closest.Character:FindFirstChild(parts[math.random(1, #parts)]).Position end
            args[2] = hitPos; args[3] = hitPos
            return oldNamecall(self, unpack(args))
        end
    end
    return oldNamecall(self, ...)
end)

-- Visible Aim
RunService.RenderStepped:Connect(function()
    if getgenv().Settings.Aimbot and getgenv().Settings.AimMode == "Visible" then
        local closest, dist = nil, getgenv().Settings.FOV
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LP and p.Character and p.Character:FindFirstChild("Head") then
                local pos, vis = Camera:WorldToViewportPoint(p.Character.Head.Position)
                local d = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(pos.X, pos.Y)).Magnitude
                if d < dist and vis then dist = d; closest = p end
            end
        end
        if closest then
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, closest.Character.Head.Position), getgenv().Settings.Smooth / 100)
        end
    end
end)

-- =============================================
-- 👁️ ESP
-- =============================================
local ESP = {}
for _, p in pairs(Players:GetPlayers()) do if p ~= LP then
    ESP[p] = {Box = Drawing.new("Square"), Name = Drawing.new("Text"), Dist = Drawing.new("Text"), Health = Drawing.new("Square"), HealthBg = Drawing.new("Square")}
    ESP[p].Name.Size, ESP[p].Name.Center, ESP[p].Name.Outline, ESP[p].Name.Font = 16, true, true, 3
    ESP[p].Dist.Size, ESP[p].Dist.Center, ESP[p].Dist.Outline, ESP[p].Dist.Font = 14, true, true, 3
    ESP[p].Box.Thickness, ESP[p].Box.Filled = 1.5, false
    ESP[p].HealthBg.Filled, ESP[p].Health.Filled, ESP[p].HealthBg.Color = true, true, Color3.new(0.2,0.2,0.2)
end end

Players.PlayerAdded:Connect(function(p) if p ~= LP then
    ESP[p] = {Box = Drawing.new("Square"), Name = Drawing.new("Text"), Dist = Drawing.new("Text"), Health = Drawing.new("Square"), HealthBg = Drawing.new("Square")}
    ESP[p].Name.Size, ESP[p].Name.Center, ESP[p].Name.Outline, ESP[p].Name.Font = 16, true, true, 3
    ESP[p].Dist.Size, ESP[p].Dist.Center, ESP[p].Dist.Outline, ESP[p].Dist.Font = 14, true, true, 3
    ESP[p].Box.Thickness, ESP[p].Box.Filled = 1.5, false
    ESP[p].HealthBg.Filled, ESP[p].Health.Filled, ESP[p].HealthBg.Color = true, true, Color3.new(0.2,0.2,0.2)
end end)

RunService.RenderStepped:Connect(function()
    if not getgenv().Settings.ESP then for _, e in pairs(ESP) do
        if e.Box then e.Box.Visible = false end if e.Name then e.Name.Visible = false end
        if e.Dist then e.Dist.Visible = false end if e.Health then e.Health.Visible = false end
        if e.HealthBg then e.HealthBg.Visible = false end
    end return end
    for p, e in pairs(ESP) do
        if p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Head") then
            local r, rv = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
            local h, hv = Camera:WorldToViewportPoint(p.Character.Head.Position + Vector3.new(0,0.5,0))
            if rv and hv then
                local height = math.abs((h.Y - r.Y) * 1.5)
                local width = height * 0.6
                local boxPos = Vector2.new(r.X - width/2, r.Y - height/4)
                if getgenv().Settings.ESPBox then
                    e.Box.Visible = true; e.Box.Color = getgenv().Settings.ESPColor; e.Box.Position = boxPos; e.Box.Size = Vector2.new(width, height)
                else e.Box.Visible = false end
                if getgenv().Settings.ESPName then
                    e.Name.Visible = true; e.Name.Position = Vector2.new(r.X, r.Y - height/2 - 20); e.Name.Text = p.Name; e.Name.Color = getgenv().Settings.ESPColor
                else e.Name.Visible = false end
                if getgenv().Settings.ESPDistance then
                    e.Dist.Visible = true; e.Dist.Position = Vector2.new(r.X, r.Y - height/2 - 5)
                    e.Dist.Text = math.floor((LP.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude) .. "m"
                else e.Dist.Visible = false end
                if getgenv().Settings.ESPHealth then
                    local hp = p.Character.Humanoid.Health / p.Character.Humanoid.MaxHealth
                    e.HealthBg.Visible = true; e.HealthBg.Position = Vector2.new(boxPos.X - 6, boxPos.Y); e.HealthBg.Size = Vector2.new(3, height)
                    e.Health.Visible = true; e.Health.Position = Vector2.new(boxPos.X - 6, boxPos.Y + (height * (1 - hp)))
                    e.Health.Size = Vector2.new(3, height * hp); e.Health.Color = Color3.fromRGB(255 - (255 * hp), 255 * hp, 0)
                else e.HealthBg.Visible = false; e.Health.Visible = false end
            else
                e.Box.Visible = false; e.Name.Visible = false; e.Dist.Visible = false; e.Health.Visible = false; e.HealthBg.Visible = false
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
    if not state then if LP.Character and LP.Character:FindFirstChild("Humanoid") then LP.Character.Humanoid.PlatformStand = false end return end
    local c = LP.Character; if not c then return end
    local h = c:FindFirstChild("Humanoid"); local r = c:FindFirstChild("HumanoidRootPart")
    if not h or not r then return end
    h.PlatformStand = true
    flyConnection = RunService.RenderStepped:Connect(function()
        if not getgenv().Settings.Fly then flyConnection:Disconnect() return end
        local md = h.MoveDirection
        r.Velocity = (Camera.CFrame.RightVector * md.X + Camera.CFrame.UpVector * md.Y + Camera.CFrame.LookVector * -md.Z) * getgenv().Settings.FlySpeed
    end)
end

RunService.Stepped:Connect(function()
    if getgenv().Settings.Noclip and LP.Character then
        for _, part in pairs(LP.Character:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide = false end end
    end
end)

LP.CharacterAdded:Connect(function(c) wait(0.5) local h = c:WaitForChild("Humanoid") h.WalkSpeed, h.JumpPower = getgenv().Settings.Speed, getgenv().Settings.Jump end)
if LP.Character and LP.Character:FindFirstChild("Humanoid") then LP.Character.Humanoid.WalkSpeed, LP.Character.Humanoid.JumpPower = getgenv().Settings.Speed, getgenv().Settings.Jump end

-- =============================================
-- 🎨 SKIN CHANGER
-- =============================================
local oldSkinHook = hookmetamethod(game, "__namecall", function(self, ...)
    local m, a = getnamecallmethod(), {...}
    local rn = tostring(self)
    if m == "FireServer" then
        if (rn:find("HasSkin") or rn:find("Inventory")) and getgenv().Settings.SkinChanger then return true end
        if (rn:find("Purchase") or rn:find("BuySkin")) and getgenv().Settings.SkinChanger then return {Success = true, SkinId = a[1]} end
        if (rn:find("Equip") or rn:find("SelectSkin")) and getgenv().Settings.SkinChanger and getgenv().Settings.CurrentSkin then
            a[1] = getgenv().Settings.CurrentSkin
            return oldSkinHook(self, unpack(a))
        end
    end
    return oldSkinHook(self, ...)
end)

-- =============================================
-- 🖥️ RAYFIELD UI
-- =============================================
local Window = Rayfield:CreateWindow({
    Name = "RIVALS INFERNO | aspan666",
    LoadingTitle = "RIVALS INFERNO",
    LoadingSubtitle = "made by aspan666",
    ConfigurationSaving = { Enabled = true, FolderName = "RivalsInferno", FileName = "Config" },
    Discord = { Enabled = false },
    KeySystem = false,
})

-- Вкладка Aimbot
local AimTab = Window:CreateTab("🎯 Aimbot", "rbxassetid://13951167659")
local AimSec = AimTab:CreateSection("Основные настройки")
AimTab:CreateToggle({ Name = "Aimbot", CurrentValue = false, Callback = function(v) getgenv().Settings.Aimbot = v end })
AimTab:CreateDropdown({ Name = "Режим", Options = {"Silent", "Visible"}, CurrentOption = "Silent", Callback = function(v) getgenv().Settings.AimMode = v end })
AimTab:CreateDropdown({ Name = "Хитбокс", Options = {"Head", "Torso", "Legs", "Random"}, CurrentOption = "Head", Callback = function(v) getgenv().Settings.Hitbox = v end })
AimTab:CreateSlider({ Name = "FOV", Range = {30, 360}, Increment = 5, CurrentValue = 120, Callback = function(v) getgenv().Settings.FOV = v end })
AimTab:CreateSlider({ Name = "Smooth", Range = {1, 100}, Increment = 5, CurrentValue = 25, Callback = function(v) getgenv().Settings.Smooth = v end })

-- Вкладка ESP
local ESPTab = Window:CreateTab("👁️ ESP", "rbxassetid://13951169214")
ESPTab:CreateSection("Визуал")
ESPTab:CreateToggle({ Name = "ESP", CurrentValue = false, Callback = function(v) getgenv().Settings.ESP = v end })
ESPTab:CreateToggle({ Name = "Box", CurrentValue = true, Callback = function(v) getgenv().Settings.ESPBox = v end })
ESPTab:CreateToggle({ Name = "Name", CurrentValue = true, Callback = function(v) getgenv().Settings.ESPName = v end })
ESPTab:CreateToggle({ Name = "Distance", CurrentValue = true, Callback = function(v) getgenv().Settings.ESPDistance = v end })
ESPTab:CreateToggle({ Name = "Health", CurrentValue = true, Callback = function(v) getgenv().Settings.ESPHealth = v end })
ESPTab:CreateColorPicker({ Name = "Color", CurrentValue = Color3.fromRGB(255,80,80), Callback = function(v) getgenv().Settings.ESPColor = v end })

-- Вкладка Movement
local MoveTab = Window:CreateTab("🚀 Movement", "rbxassetid://13951164120")
MoveTab:CreateSection("Передвижение")
MoveTab:CreateSlider({ Name = "WalkSpeed", Range = {16, 350}, Increment = 5, CurrentValue = 16, Callback = function(v)
    getgenv().Settings.Speed = v; if LP.Character and LP.Character:FindFirstChild("Humanoid") then LP.Character.Humanoid.WalkSpeed = v end end })
MoveTab:CreateSlider({ Name = "JumpPower", Range = {50, 200}, Increment = 5, CurrentValue = 50, Callback = function(v)
    getgenv().Settings.Jump = v; if LP.Character and LP.Character:FindFirstChild("Humanoid") then LP.Character.Humanoid.JumpPower = v end end })
MoveTab:CreateToggle({ Name = "Fly", CurrentValue = false, Callback = function(v) getgenv().Settings.Fly = v; toggleFly(v) end })
MoveTab:CreateSlider({ Name = "Fly Speed", Range = {10, 200}, Increment = 5, CurrentValue = 50, Callback = function(v) getgenv().Settings.FlySpeed = v end })
MoveTab:CreateToggle({ Name = "Noclip", CurrentValue = false, Callback = function(v) getgenv().Settings.Noclip = v end })

-- Вкладка Skin Changer
local SkinTab = Window:CreateTab("🎨 Skin", "rbxassetid://13951167951")
SkinTab:CreateSection("Скин-ченджер")
SkinTab:CreateToggle({ Name = "Skin Changer", CurrentValue = false, Callback = function(v) getgenv().Settings.SkinChanger = v end })
SkinTab:CreateLabel("Доступные скины")
for name, id in pairs(getgenv().Skins) do
    SkinTab:CreateButton({ Name = name, Callback = function()
        getgenv().Settings.CurrentSkin = id
        Rayfield:Notify({ Title = "Skin Changer", Content = "Выбран: " .. name, Duration = 3 })
    end })
end

-- Финал
Rayfield:Notify({ Title = "RIVALS INFERNO", Content = "✅ Made by aspan666 | Rayfield Edition", Duration = 5 })
print("========================================")
print("🔥 RIVALS INFERNO | aspan666")
print("✅ RAYFIELD EDITION | ГОТОВО")
print("📌 Нажми RightShift или иконку для меню")
print("========================================")
