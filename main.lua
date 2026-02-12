--[[
    🔥 RIVALS INFERNO 🔥
    Made by aspan666
    Версия: СТАБИЛЬНАЯ | РАБОТАЕТ 100%
    Никаких библиотек, никаких loadstring-зависимостей
--]]

pcall(function()local m=game:GetService("ReplicatedStorage"):FindFirstChild("Modules")if m then local b=m:FindFirstChild("BetterDebris")if b then b.Parent=nil end end end)

getgenv().Settings = {
    Aimbot = false,
    AimMode = "Visible",
    Hitbox = "Head",
    FOV = 120,
    Smooth = 25,
    ESP = false,
    ESPColor = Color3.fromRGB(255,80,80),
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

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LP = Players.LocalPlayer
local Mouse = LP:GetMouse()

-- Visible Aimbot (Camera Smooth)
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
            local targetPos = closest.Character.Head.Position
            if getgenv().Settings.Hitbox == "Torso" then
                targetPos = (closest.Character:FindFirstChild("UpperTorso") or closest.Character:FindFirstChild("HumanoidRootPart")).Position
            elseif getgenv().Settings.Hitbox == "Legs" then
                targetPos = (closest.Character:FindFirstChild("LowerTorso") or closest.Character:FindFirstChild("Left Leg")).Position
            end
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, targetPos), getgenv().Settings.Smooth / 100)
        end
    end
end)

-- Silent Aim (Hook)
local oldNC = hookmetamethod(game, "__namecall", function(s, ...)
    local m, a = getnamecallmethod(), {...}
    if m == "FireServer" and tostring(s):find("Weapon") and getgenv().Settings.Aimbot and getgenv().Settings.AimMode == "Silent" then
        local closest, dist = nil, getgenv().Settings.FOV
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LP and p.Character and p.Character:FindFirstChild("Head") then
                local pos, vis = Camera:WorldToViewportPoint(p.Character.Head.Position)
                local d = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(pos.X, pos.Y)).Magnitude
                if d < dist and vis then dist = d; closest = p end
            end
        end
        if closest then
            local hitPos = closest.Character.Head.Position
            if getgenv().Settings.Hitbox == "Torso" then
                hitPos = (closest.Character:FindFirstChild("UpperTorso") or closest.Character:FindFirstChild("HumanoidRootPart")).Position
            elseif getgenv().Settings.Hitbox == "Legs" then
                hitPos = (closest.Character:FindFirstChild("LowerTorso") or closest.Character:FindFirstChild("Left Leg")).Position
            end
            a[2] = hitPos; a[3] = hitPos
            return oldNC(s, unpack(a))
        end
    end
    return oldNC(s, ...)
end)

-- ESP (Drawing)
local ESP = {}
for _, p in pairs(Players:GetPlayers()) do if p ~= LP then
    ESP[p] = {Box = Drawing.new("Square"), Name = Drawing.new("Text"), Dist = Drawing.new("Text")}
    ESP[p].Name.Size = 16; ESP[p].Name.Center = true; ESP[p].Name.Outline = true; ESP[p].Name.Font = 3
    ESP[p].Dist.Size = 14; ESP[p].Dist.Center = true; ESP[p].Dist.Outline = true; ESP[p].Dist.Font = 3
    ESP[p].Box.Thickness = 1.5; ESP[p].Box.Filled = false
end end
Players.PlayerAdded:Connect(function(p) if p ~= LP then
    ESP[p] = {Box = Drawing.new("Square"), Name = Drawing.new("Text"), Dist = Drawing.new("Text")}
    ESP[p].Name.Size = 16; ESP[p].Name.Center = true; ESP[p].Name.Outline = true; ESP[p].Name.Font = 3
    ESP[p].Dist.Size = 14; ESP[p].Dist.Center = true; ESP[p].Dist.Outline = true; ESP[p].Dist.Font = 3
    ESP[p].Box.Thickness = 1.5; ESP[p].Box.Filled = false
end end)
RunService.RenderStepped:Connect(function()
    if not getgenv().Settings.ESP then
        for _, e in pairs(ESP) do
            if e.Box then e.Box.Visible = false end
            if e.Name then e.Name.Visible = false end
            if e.Dist then e.Dist.Visible = false end
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
                e.Box.Visible = true; e.Box.Color = getgenv().Settings.ESPColor
                e.Box.Position = Vector2.new(r.X - width/2, r.Y - height/4); e.Box.Size = Vector2.new(width, height)
                e.Name.Visible = true; e.Name.Position = Vector2.new(r.X, r.Y - height/2 - 20)
                e.Name.Text = p.Name; e.Name.Color = getgenv().Settings.ESPColor
                e.Dist.Visible = true; e.Dist.Position = Vector2.new(r.X, r.Y - height/2 - 5)
                e.Dist.Text = math.floor((LP.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude) .. "m"
            else
                e.Box.Visible = false; e.Name.Visible = false; e.Dist.Visible = false
            end
        end
    end
end)

-- Speed & Jump
if LP.Character and LP.Character:FindFirstChild("Humanoid") then
    LP.Character.Humanoid.WalkSpeed = getgenv().Settings.Speed
    LP.Character.Humanoid.JumpPower = getgenv().Settings.Jump
end
LP.CharacterAdded:Connect(function(c) wait(0.5) local h = c:WaitForChild("Humanoid") h.WalkSpeed = getgenv().Settings.Speed; h.JumpPower = getgenv().Settings.Jump end)

-- Fly
local flyC; local function toggleFly(s)
    if flyC then flyC:Disconnect() end
    if not s then if LP.Character and LP.Character:FindFirstChild("Humanoid") then LP.Character.Humanoid.PlatformStand = false end return end
    local c = LP.Character; if not c then return end
    local h = c:FindFirstChild("Humanoid"); local r = c:FindFirstChild("HumanoidRootPart")
    if not h or not r then return end
    h.PlatformStand = true
    flyC = RunService.RenderStepped:Connect(function()
        if not getgenv().Settings.Fly then flyC:Disconnect() return end
        local md = h.MoveDirection
        r.Velocity = (Camera.CFrame.RightVector * md.X + Camera.CFrame.UpVector * md.Y + Camera.CFrame.LookVector * -md.Z) * getgenv().Settings.FlySpeed
    end)
end

-- Noclip
RunService.Stepped:Connect(function()
    if getgenv().Settings.Noclip and LP.Character then
        for _, part in pairs(LP.Character:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide = false end end
    end
end)

-- Skin Changer Hook
local oldSH = hookmetamethod(game, "__namecall", function(s, ...)
    local m, a = getnamecallmethod(), {...}
    local rn = tostring(s)
    if m == "FireServer" then
        if (rn:find("HasSkin") or rn:find("Inventory")) and getgenv().Settings.SkinChanger then return true end
        if (rn:find("Purchase") or rn:find("BuySkin")) and getgenv().Settings.SkinChanger then return {Success = true, SkinId = a[1]} end
        if (rn:find("Equip") or rn:find("SelectSkin")) and getgenv().Settings.SkinChanger and getgenv().Settings.CurrentSkin then
            a[1] = getgenv().Settings.CurrentSkin; return oldSH(s, unpack(a))
        end
    end
    return oldSH(s, ...)
end)

-- ========== UI (ПРОСТОЙ, РАБОЧИЙ, БЕЗ БИБЛИОТЕК) ==========
local g = Instance.new("ScreenGui", game:GetService("CoreGui"))
g.Name = "RivalsInferno_aspan666"
local f = Instance.new("Frame", g)
f.Size, f.Position, f.BackgroundColor3, f.BackgroundTransparency, f.Active, f.Draggable = UDim2.new(0,400,0,500), UDim2.new(0.5,-200,0.5,-250), Color3.fromRGB(18,18,22), 0.1, true, true
Instance.new("TextLabel", f).Text = "🔥 RIVALS INFERNO | aspan666"
Instance.new("TextButton", f).Size, Instance.new("TextButton", f).Position, Instance.new("TextButton", f).BackgroundColor3, Instance.new("TextButton", f).Text, Instance.new("TextButton", f).Parent = UDim2.new(0,30,0,30), UDim2.new(1,-35,0,5), Color3.fromRGB(255,50,100), "X", f
game:GetService("UserInputService").InputBegan:Connect(function(i) if i.KeyCode == Enum.KeyCode.RightShift then f.Visible = not f.Visible end end)

local y = 10
local aimT = Instance.new("TextButton", f)
aimT.Size, aimT.Position, aimT.BackgroundColor3, aimT.Text, aimT.TextColor3, aimT.TextSize, aimT.Font = UDim2.new(0,180,0,35), UDim2.new(0,10,0,y), getgenv().Settings.Aimbot and Color3.fromRGB(255,50,100) or Color3.fromRGB(40,40,45), "Aimbot: " .. (getgenv().Settings.Aimbot and "ON" or "OFF"), Color3.new(1,1,1), 16, Enum.Font.Gotham
aimT.MouseButton1Click:Connect(function() getgenv().Settings.Aimbot = not getgenv().Settings.Aimbot; aimT.BackgroundColor3 = getgenv().Settings.Aimbot and Color3.fromRGB(255,50,100) or Color3.fromRGB(40,40,45); aimT.Text = "Aimbot: " .. (getgenv().Settings.Aimbot and "ON" or "OFF") end)
y = y + 45
local espT = Instance.new("TextButton", f)
espT.Size, espT.Position, espT.BackgroundColor3, espT.Text, espT.TextColor3, espT.TextSize, espT.Font = UDim2.new(0,180,0,35), UDim2.new(0,10,0,y), getgenv().Settings.ESP and Color3.fromRGB(255,50,100) or Color3.fromRGB(40,40,45), "ESP: " .. (getgenv().Settings.ESP and "ON" or "OFF"), Color3.new(1,1,1), 16, Enum.Font.Gotham
espT.MouseButton1Click:Connect(function() getgenv().Settings.ESP = not getgenv().Settings.ESP; espT.BackgroundColor3 = getgenv().Settings.ESP and Color3.fromRGB(255,50,100) or Color3.fromRGB(40,40,45); espT.Text = "ESP: " .. (getgenv().Settings.ESP and "ON" or "OFF") end)
y = y + 45
local flyT = Instance.new("TextButton", f)
flyT.Size, flyT.Position, flyT.BackgroundColor3, flyT.Text, flyT.TextColor3, flyT.TextSize, flyT.Font = UDim2.new(0,180,0,35), UDim2.new(0,10,0,y), getgenv().Settings.Fly and Color3.fromRGB(255,50,100) or Color3.fromRGB(40,40,45), "Fly: " .. (getgenv().Settings.Fly and "ON" or "OFF"), Color3.new(1,1,1), 16, Enum.Font.Gotham
flyT.MouseButton1Click:Connect(function() getgenv().Settings.Fly = not getgenv().Settings.Fly; flyT.BackgroundColor3 = getgenv().Settings.Fly and Color3.fromRGB(255,50,100) or Color3.fromRGB(40,40,45); flyT.Text = "Fly: " .. (getgenv().Settings.Fly and "ON" or "OFF"); toggleFly(getgenv().Settings.Fly) end)
y = y + 45
local nocT = Instance.new("TextButton", f)
nocT.Size, nocT.Position, nocT.BackgroundColor3, nocT.Text, nocT.TextColor3, nocT.TextSize, nocT.Font = UDim2.new(0,180,0,35), UDim2.new(0,10,0,y), getgenv().Settings.Noclip and Color3.fromRGB(255,50,100) or Color3.fromRGB(40,40,45), "Noclip: " .. (getgenv().Settings.Noclip and "ON" or "OFF"), Color3.new(1,1,1), 16, Enum.Font.Gotham
nocT.MouseButton1Click:Connect(function() getgenv().Settings.Noclip = not getgenv().Settings.Noclip; nocT.BackgroundColor3 = getgenv().Settings.Noclip and Color3.fromRGB(255,50,100) or Color3.fromRGB(40,40,45); nocT.Text = "Noclip: " .. (getgenv().Settings.Noclip and "ON" or "OFF") end)
y = y + 45
local skinT = Instance.new("TextButton", f)
skinT.Size, skinT.Position, skinT.BackgroundColor3, skinT.Text, skinT.TextColor3, skinT.TextSize, skinT.Font = UDim2.new(0,180,0,35), UDim2.new(0,10,0,y), getgenv().Settings.SkinChanger and Color3.fromRGB(255,50,100) or Color3.fromRGB(40,40,45), "Skin: " .. (getgenv().Settings.SkinChanger and "ON" or "OFF"), Color3.new(1,1,1), 16, Enum.Font.Gotham
skinT.MouseButton1Click:Connect(function() getgenv().Settings.SkinChanger = not getgenv().Settings.SkinChanger; skinT.BackgroundColor3 = getgenv().Settings.SkinChanger and Color3.fromRGB(255,50,100) or Color3.fromRGB(40,40,45); skinT.Text = "Skin: " .. (getgenv().Settings.SkinChanger and "ON" or "OFF") end)

print("🔥 RIVALS INFERNO | aspan666 | ГОТОВО")
print("📌 Нажми RightShift для меню")
