--[[
    🔥 RIVALS INFERNO 🔥
    Made by aspan666
    Версия: ULTRA STABLE | 100% WORKS
    БЕЗ ХУКОВ | БЕЗ БИБЛИОТЕК
--]]

-- Глушитель ошибок игры
pcall(function()
    local m = game:GetService("ReplicatedStorage"):FindFirstChild("Modules")
    if m then
        local b = m:FindFirstChild("BetterDebris")
        if b then b.Parent = nil end
    end
end)

-- Настройки (меняй хоть сейчас)
Settings = {
    Aimbot = false,
    FOV = 150,
    Smooth = 25,
    ESP = false,
    ESPColor = Color3.fromRGB(255, 80, 80),
    Speed = 16,
    Jump = 50,
    Fly = false,
    FlySpeed = 50,
    Noclip = false,
}

-- Сервисы
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LP = Players.LocalPlayer
local Mouse = LP:GetMouse()

-- ========== VISIBLE AIMBOT (РАБОТАЕТ ВСЕГДА) ==========
RunService.RenderStepped:Connect(function()
    if Settings.Aimbot then
        local closest, dist = nil, Settings.FOV
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
            local targetPos = closest.Character.Head.Position
            Camera.CFrame = Camera.CFrame:Lerp(
                CFrame.new(Camera.CFrame.Position, targetPos),
                Settings.Smooth / 100
            )
        end
    end
end)

-- ========== ESP (ЕСЛИ ПОДДЕРЖИВАЕТСЯ DRAWING) ==========
if Drawing and Drawing.new then
    local ESP = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LP then
            ESP[p] = {
                Box = Drawing.new("Square"),
                Name = Drawing.new("Text"),
                Dist = Drawing.new("Text"),
            }
            ESP[p].Name.Size = 16; ESP[p].Name.Center = true; ESP[p].Name.Outline = true; ESP[p].Name.Font = 3
            ESP[p].Dist.Size = 14; ESP[p].Dist.Center = true; ESP[p].Dist.Outline = true; ESP[p].Dist.Font = 3
            ESP[p].Box.Thickness = 1.5; ESP[p].Box.Filled = false
        end
    end
    Players.PlayerAdded:Connect(function(p)
        if p ~= LP then
            ESP[p] = {
                Box = Drawing.new("Square"),
                Name = Drawing.new("Text"),
                Dist = Drawing.new("Text"),
            }
            ESP[p].Name.Size = 16; ESP[p].Name.Center = true; ESP[p].Name.Outline = true; ESP[p].Name.Font = 3
            ESP[p].Dist.Size = 14; ESP[p].Dist.Center = true; ESP[p].Dist.Outline = true; ESP[p].Dist.Font = 3
            ESP[p].Box.Thickness = 1.5; ESP[p].Box.Filled = false
        end
    end)
    RunService.RenderStepped:Connect(function()
        if not Settings.ESP then
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
                local h, hv = Camera:WorldToViewportPoint(p.Character.Head.Position + Vector3.new(0, 0.5, 0))
                if rv and hv then
                    local height = math.abs((h.Y - r.Y) * 1.5)
                    local width = height * 0.6
                    e.Box.Visible = true
                    e.Box.Color = Settings.ESPColor
                    e.Box.Position = Vector2.new(r.X - width/2, r.Y - height/4)
                    e.Box.Size = Vector2.new(width, height)
                    e.Name.Visible = true
                    e.Name.Position = Vector2.new(r.X, r.Y - height/2 - 20)
                    e.Name.Text = p.Name
                    e.Name.Color = Settings.ESPColor
                    e.Dist.Visible = true
                    e.Dist.Position = Vector2.new(r.X, r.Y - height/2 - 5)
                    e.Dist.Text = math.floor((LP.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude) .. "m"
                else
                    e.Box.Visible = false
                    e.Name.Visible = false
                    e.Dist.Visible = false
                end
            end
        end
    end)
end

-- ========== SPEED & JUMP ==========
if LP.Character and LP.Character:FindFirstChild("Humanoid") then
    LP.Character.Humanoid.WalkSpeed = Settings.Speed
    LP.Character.Humanoid.JumpPower = Settings.Jump
end
LP.CharacterAdded:Connect(function(c)
    wait(0.5)
    local h = c:WaitForChild("Humanoid")
    h.WalkSpeed = Settings.Speed
    h.JumpPower = Settings.Jump
end)

-- ========== FLY ==========
local flying = false
local flyBodyVelocity, flyBodyGyro
local function toggleFly(state)
    flying = state
    if not LP.Character then return end
    local h = LP.Character:FindFirstChild("Humanoid")
    local r = LP.Character:FindFirstChild("HumanoidRootPart")
    if not h or not r then return end
    if flying then
        h.PlatformStand = true
        flyBodyGyro = Instance.new("BodyGyro")
        flyBodyGyro.P = 9e4
        flyBodyGyro.MaxTorque = Vector3.new(9e4, 9e4, 9e4)
        flyBodyGyro.CFrame = r.CFrame
        flyBodyGyro.Parent = r
        flyBodyVelocity = Instance.new("BodyVelocity")
        flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
        flyBodyVelocity.MaxForce = Vector3.new(9e4, 9e4, 9e4)
        flyBodyVelocity.Parent = r
        RunService.RenderStepped:Connect(function()
            if not flying then return end
            local moveDir = h.MoveDirection
            flyBodyVelocity.Velocity = (Camera.CFrame.RightVector * moveDir.X + Camera.CFrame.UpVector * moveDir.Y + Camera.CFrame.LookVector * -moveDir.Z) * Settings.FlySpeed
            flyBodyGyro.CFrame = Camera.CFrame
        end)
    else
        h.PlatformStand = false
        if flyBodyGyro then flyBodyGyro:Destroy() flyBodyGyro = nil end
        if flyBodyVelocity then flyBodyVelocity:Destroy() flyBodyVelocity = nil end
    end
end

-- ========== NOCLIP ==========
RunService.Stepped:Connect(function()
    if Settings.Noclip and LP.Character then
        for _, part in pairs(LP.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- ========== ПРОСТОЕ МЕНЮ (РАБОТАЕТ ВЕЗДЕ) ==========
local gui = Instance.new("ScreenGui")
gui.Name = "RivalsInferno_aspan666"
gui.Parent = game:GetService("CoreGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 400, 0, 400)
frame.Position = UDim2.new(0.5, -200, 0.5, -200)
frame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
frame.BackgroundTransparency = 0.1
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(255, 50, 100)
title.Text = "🔥 RIVALS INFERNO | aspan666"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.Parent = frame

local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 30, 0, 30)
close.Position = UDim2.new(1, -35, 0, 5)
close.BackgroundColor3 = Color3.fromRGB(255, 50, 100)
close.Text = "X"
close.TextColor3 = Color3.new(1, 1, 1)
close.TextSize = 20
close.Font = Enum.Font.GothamBold
close.Parent = frame
close.MouseButton1Click:Connect(function() frame.Visible = false end)

game:GetService("UserInputService").InputBegan:Connect(function(i)
    if i.KeyCode == Enum.KeyCode.RightShift then
        frame.Visible = not frame.Visible
    end
end)

local y = 50

-- Speed
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0, 150, 0, 30)
speedLabel.Position = UDim2.new(0, 10, 0, y)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Speed: " .. Settings.Speed
speedLabel.TextColor3 = Color3.new(1,1,1)
speedLabel.TextSize = 16
speedLabel.Font = Enum.Font.Gotham
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.Parent = frame

Instance.new("TextButton", frame).Size, Instance.new("TextButton", frame).Position, Instance.new("TextButton", frame).BackgroundColor3, Instance.new("TextButton", frame).Text, Instance.new("TextButton", frame).TextColor3 = UDim2.new(0,30,0,30), UDim2.new(0,170,0,y), Color3.fromRGB(255,50,100), "+", Color3.new(1,1,1)
Instance.new("TextButton", frame).MouseButton1Click:Connect(function()
    Settings.Speed = math.min(Settings.Speed + 5, 350)
    speedLabel.Text = "Speed: " .. Settings.Speed
    if LP.Character and LP.Character:FindFirstChild("Humanoid") then
        LP.Character.Humanoid.WalkSpeed = Settings.Speed
    end
end)
Instance.new("TextButton", frame).Size, Instance.new("TextButton", frame).Position, Instance.new("TextButton", frame).BackgroundColor3, Instance.new("TextButton", frame).Text, Instance.new("TextButton", frame).TextColor3 = UDim2.new(0,30,0,30), UDim2.new(0,210,0,y), Color3.fromRGB(255,50,100), "-", Color3.new(1,1,1)
Instance.new("TextButton", frame).MouseButton1Click:Connect(function()
    Settings.Speed = math.max(Settings.Speed - 5, 16)
    speedLabel.Text = "Speed: " .. Settings.Speed
    if LP.Character and LP.Character:FindFirstChild("Humanoid") then
        LP.Character.Humanoid.WalkSpeed = Settings.Speed
    end
end)

y = y + 40

-- Jump
local jumpLabel = Instance.new("TextLabel")
jumpLabel.Size = UDim2.new(0, 150, 0, 30)
jumpLabel.Position = UDim2.new(0, 10, 0, y)
jumpLabel.BackgroundTransparency = 1
jumpLabel.Text = "Jump: " .. Settings.Jump
jumpLabel.TextColor3 = Color3.new(1,1,1)
jumpLabel.TextSize = 16
jumpLabel.Font = Enum.Font.Gotham
jumpLabel.TextXAlignment = Enum.TextXAlignment.Left
jumpLabel.Parent = frame

Instance.new("TextButton", frame).Size, Instance.new("TextButton", frame).Position, Instance.new("TextButton", frame).BackgroundColor3, Instance.new("TextButton", frame).Text, Instance.new("TextButton", frame).TextColor3 = UDim2.new(0,30,0,30), UDim2.new(0,170,0,y), Color3.fromRGB(255,50,100), "+", Color3.new(1,1,1)
Instance.new("TextButton", frame).MouseButton1Click:Connect(function()
    Settings.Jump = math.min(Settings.Jump + 5, 200)
    jumpLabel.Text = "Jump: " .. Settings.Jump
    if LP.Character and LP.Character:FindFirstChild("Humanoid") then
        LP.Character.Humanoid.JumpPower = Settings.Jump
    end
end)
Instance.new("TextButton", frame).Size, Instance.new("TextButton", frame).Position, Instance.new("TextButton", frame).BackgroundColor3, Instance.new("TextButton", frame).Text, Instance.new("TextButton", frame).TextColor3 = UDim2.new(0,30,0,30), UDim2.new(0,210,0,y), Color3.fromRGB(255,50,100), "-", Color3.new(1,1,1)
Instance.new("TextButton", frame).MouseButton1Click:Connect(function()
    Settings.Jump = math.max(Settings.Jump - 5, 50)
    jumpLabel.Text = "Jump: " .. Settings.Jump
    if LP.Character and LP.Character:FindFirstChild("Humanoid") then
        LP.Character.Humanoid.JumpPower = Settings.Jump
    end
end)

y = y + 40

-- Aimbot
local aimBtn = Instance.new("TextButton")
aimBtn.Size = UDim2.new(0, 180, 0, 35)
aimBtn.Position = UDim2.new(0, 10, 0, y)
aimBtn.BackgroundColor3 = Settings.Aimbot and Color3.fromRGB(255,50,100) or Color3.fromRGB(40,40,45)
aimBtn.Text = "Aimbot: " .. (Settings.Aimbot and "ON" or "OFF")
aimBtn.TextColor3 = Color3.new(1,1,1)
aimBtn.TextSize = 16
aimBtn.Font = Enum.Font.Gotham
aimBtn.Parent = frame
aimBtn.MouseButton1Click:Connect(function()
    Settings.Aimbot = not Settings.Aimbot
    aimBtn.BackgroundColor3 = Settings.Aimbot and Color3.fromRGB(255,50,100) or Color3.fromRGB(40,40,45)
    aimBtn.Text = "Aimbot: " .. (Settings.Aimbot and "ON" or "OFF")
end)

y = y + 45

-- ESP
if Drawing and Drawing.new then
    local espBtn = Instance.new("TextButton")
    espBtn.Size = UDim2.new(0, 180, 0, 35)
    espBtn.Position = UDim2.new(0, 10, 0, y)
    espBtn.BackgroundColor3 = Settings.ESP and Color3.fromRGB(255,50,100) or Color3.fromRGB(40,40,45)
    espBtn.Text = "ESP: " .. (Settings.ESP and "ON" or "OFF")
    espBtn.TextColor3 = Color3.new(1,1,1)
    espBtn.TextSize = 16
    espBtn.Font = Enum.Font.Gotham
    espBtn.Parent = frame
    espBtn.MouseButton1Click:Connect(function()
        Settings.ESP = not Settings.ESP
        espBtn.BackgroundColor3 = Settings.ESP and Color3.fromRGB(255,50,100) or Color3.fromRGB(40,40,45)
        espBtn.Text = "ESP: " .. (Settings.ESP and "ON" or "OFF")
    end)
    y = y + 45
end

-- Fly
local flyBtn = Instance.new("TextButton")
flyBtn.Size = UDim2.new(0, 180, 0, 35)
flyBtn.Position = UDim2.new(0, 10, 0, y)
flyBtn.BackgroundColor3 = Settings.Fly and Color3.fromRGB(255,50,100) or Color3.fromRGB(40,40,45)
flyBtn.Text = "Fly: " .. (Settings.Fly and "ON" or "OFF")
flyBtn.TextColor3 = Color3.new(1,1,1)
flyBtn.TextSize = 16
flyBtn.Font = Enum.Font.Gotham
flyBtn.Parent = frame
flyBtn.MouseButton1Click:Connect(function()
    Settings.Fly = not Settings.Fly
    flyBtn.BackgroundColor3 = Settings.Fly and Color3.fromRGB(255,50,100) or Color3.fromRGB(40,40,45)
    flyBtn.Text = "Fly: " .. (Settings.Fly and "ON" or "OFF")
    toggleFly(Settings.Fly)
end)

y = y + 45

-- Noclip
local noclipBtn = Instance.new("TextButton")
noclipBtn.Size = UDim2.new(0, 180, 0, 35)
noclipBtn.Position = UDim2.new(0, 10, 0, y)
noclipBtn.BackgroundColor3 = Settings.Noclip and Color3.fromRGB(255,50,100) or Color3.fromRGB(40,40,45)
noclipBtn.Text = "Noclip: " .. (Settings.Noclip and "ON" or "OFF")
noclipBtn.TextColor3 = Color3.new(1,1,1)
noclipBtn.TextSize = 16
noclipBtn.Font = Enum.Font.Gotham
noclipBtn.Parent = frame
noclipBtn.MouseButton1Click:Connect(function()
    Settings.Noclip = not Settings.Noclip
    noclipBtn.BackgroundColor3 = Settings.Noclip and Color3.fromRGB(255,50,100) or Color3.fromRGB(40,40,45)
    noclipBtn.Text = "Noclip: " .. (Settings.Noclip and "ON" or "OFF")
end)

print("========================================")
print("🔥 RIVALS INFERNO | aspan666")
print("✅ ULTRA STABLE | ГОТОВО")
print("📌 Нажми RightShift для меню")
print("========================================")
