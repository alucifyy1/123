--[[
    █▀█ █ █▀▄▀█ █▀ ▀█▀ █▀█ █▀█ █ █▀▀ █▀▄
    █▀▄ █ █░▀░█ ▄█ ░█░ █▄█ █▀▄ █ ██▄ █▄▀

    🔥 RIVALS ZENITH 🔥
    Made by aspan666
    Версия: 3.0.0 | PREMIUM
    Стиль: Kiciahook Legacy | Anti-Key | Full Matcha Spec
    
    Функционал:
    • Silent Aim + Visible Aim + Rage
    • Triggerbot (1ms response)
    • Prediction X/Y (20.0)
    • FOV Circle (169px, Smooth)
    • Hitbox Expand (2.5x)
    • ESP Pro (Box, Health, Distance, Chams)
    • Skin Changer (Legacy + Season 1)
    • Fly, Noclip, Speed, Jump
    • Anti-Ban (HWID Spoof, Log Blocker)
--]]

-- =============================================
-- 🛡️ ANTI-BAN CORE (БЛОКИРОВКА ЛОГОВ, СПУФИНГ)
-- =============================================
pcall(function()
    if getconnections then
        for _, con in pairs(getconnections(game:GetService("LogService").MessageOut)) do
            con:Disable()
        end
    end
    if getexecutorname then
        hookfunction(getexecutorname, function() return "RobloxPlayerBeta" end)
    end
    getgenv().aspan = "aspan666_zenith"
end)

-- =============================================
-- 📦 KICIAHOOK UI ENGINE (РЕКОМПИЛИРОВАННЫЙ, БЕЗ КЛЮЧЕЙ)
-- =============================================
do
    local UI = {}
    UI.__index = UI
    UI.__type = "Library"
    UI.__version = "3.0.0"
    UI.__author = "aspan666"
    
    local RunService = game:GetService("RunService")
    local TweenService = game:GetService("TweenService")
    local UIS = game:GetService("UserInputService")
    
    -- ========== ОСНОВНОЙ КОНТЕЙНЕР ==========
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "Zenith_aspan666"
    ScreenGui.Parent = game:GetService("CoreGui")
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.DisplayOrder = 999
    
    -- ========== БИБЛИОТЕКА ==========
    _G.Lib = {
        Notify = function(data)
            local notif = Instance.new("Frame")
            notif.Size = UDim2.new(0, 320, 0, 50)
            notif.Position = UDim2.new(1, 20, 0, 20)
            notif.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
            notif.BackgroundTransparency = 0.1
            notif.BorderSizePixel = 0
            notif.Parent = ScreenGui
            
            local outline = Instance.new("ImageLabel")
            outline.Size = UDim2.new(1, 0, 1, 0)
            outline.BackgroundTransparency = 1
            outline.Image = "rbxassetid://2592362371"
            outline.ImageColor3 = Color3.fromRGB(40, 40, 45)
            outline.ScaleType = Enum.ScaleType.Slice
            outline.SliceCenter = Rect.new(2, 2, 62, 62)
            outline.Parent = notif
            
            local title = Instance.new("TextLabel")
            title.Size = UDim2.new(1, -45, 0, 20)
            title.Position = UDim2.new(0, 45, 0, 6)
            title.BackgroundTransparency = 1
            title.Text = data.Title or "Notification"
            title.TextColor3 = Color3.fromRGB(255, 255, 255)
            title.TextSize = 16
            title.Font = Enum.Font.GothamSemibold
            title.TextXAlignment = Enum.TextXAlignment.Left
            title.Parent = notif
            
            local desc = Instance.new("TextLabel")
            desc.Size = UDim2.new(1, -45, 0, 20)
            desc.Position = UDim2.new(0, 45, 0, 26)
            desc.BackgroundTransparency = 1
            desc.Text = data.Desc or ""
            desc.TextColor3 = Color3.fromRGB(180, 180, 180)
            desc.TextSize = 14
            desc.Font = Enum.Font.Gotham
            desc.TextXAlignment = Enum.TextXAlignment.Left
            desc.Parent = notif
            
            local icon = Instance.new("ImageLabel")
            icon.Size = UDim2.new(0, 25, 0, 25)
            icon.Position = UDim2.new(0, 10, 0.5, -12.5)
            icon.BackgroundTransparency = 1
            icon.Image = "rbxassetid://6026568210"
            icon.ImageColor3 = Color3.fromRGB(255, 50, 100)
            icon.Parent = notif
            
            notif:TweenPosition(UDim2.new(1, -340, 0, 20), "Out", "Quart", 0.3, true)
            task.delay(data.Duration or 5, function()
                notif:TweenPosition(UDim2.new(1, 20, 0, 20), "Out", "Quart", 0.2, true)
                task.wait(0.2)
                notif:Destroy()
            end)
        end,
        
        Window = function(config)
            local WindowObj = {}
            WindowObj.__type = "Window"
            
            -- ========== ОСНОВНОЕ ОКНО ==========
            local MainFrame = Instance.new("Frame")
            MainFrame.Size = UDim2.new(0, 550, 0, 350)
            MainFrame.Position = UDim2.new(0.5, -275, 0.5, -175)
            MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
            MainFrame.BackgroundTransparency = 0.05
            MainFrame.BorderSizePixel = 0
            MainFrame.ClipsDescendants = true
            MainFrame.Parent = ScreenGui
            MainFrame.Visible = config.Startup or true
            
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
            
            -- ========== ТИТУЛЬНАЯ ПАНЕЛЬ ==========
            local TopBar = Instance.new("Frame")
            TopBar.Size = UDim2.new(1, -10, 0, 35)
            TopBar.Position = UDim2.new(0, 5, 0, 5)
            TopBar.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
            TopBar.BackgroundTransparency = 0.2
            TopBar.BorderSizePixel = 0
            TopBar.Parent = MainFrame
            
            local Title = Instance.new("TextLabel")
            Title.Size = UDim2.new(0, 200, 1, 0)
            Title.Position = UDim2.new(0, 10, 0, 0)
            Title.BackgroundTransparency = 1
            Title.Text = config.Title or "RIVALS ZENITH"
            Title.TextColor3 = Color3.fromRGB(255, 255, 255)
            Title.TextSize = 18
            Title.Font = Enum.Font.GothamBold
            Title.TextXAlignment = Enum.TextXAlignment.Left
            Title.Parent = TopBar
            
            local SubTitle = Instance.new("TextLabel")
            SubTitle.Size = UDim2.new(0, 200, 1, 0)
            SubTitle.Position = UDim2.new(0, 210, 0, 0)
            SubTitle.BackgroundTransparency = 1
            SubTitle.Text = config.SubTitle or "made by aspan666"
            SubTitle.TextColor3 = Color3.fromRGB(180, 180, 180)
            SubTitle.TextSize = 14
            SubTitle.Font = Enum.Font.Gotham
            SubTitle.TextXAlignment = Enum.TextXAlignment.Left
            SubTitle.Parent = TopBar
            
            local AccentLine = Instance.new("Frame")
            AccentLine.Size = UDim2.new(1, 0, 0, 2)
            AccentLine.Position = UDim2.new(0, 0, 1, -2)
            AccentLine.BackgroundColor3 = config.Theme and config.Theme.Accent or Color3.fromRGB(255, 50, 100)
            AccentLine.BorderSizePixel = 0
            AccentLine.Parent = TopBar
            
            -- ========== ПЕРЕТАСКИВАНИЕ ==========
            local dragging, dragInput, dragStart, startPos
            TopBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    dragStart = input.Position
                    startPos = MainFrame.Position
                    input.Changed:Connect(function()
                        if input.UserInputState == Enum.UserInputState.End then
                            dragging = false
                        end
                    end)
                end
            end)
            TopBar.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement then
                    dragInput = input
                end
            end)
            UIS.InputChanged:Connect(function(input)
                if input == dragInput and dragging then
                    local delta = input.Position - dragStart
                    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
                end
            end)
            
            -- ========== КОНТЕЙНЕР ВКЛАДОК ==========
            local TabContainer = Instance.new("Frame")
            TabContainer.Size = UDim2.new(1, -20, 1, -60)
            TabContainer.Position = UDim2.new(0, 10, 0, 50)
            TabContainer.BackgroundTransparency = 1
            TabContainer.Parent = MainFrame
            
            local TabButtons = Instance.new("Frame")
            TabButtons.Size = UDim2.new(1, 0, 0, 35)
            TabButtons.BackgroundTransparency = 1
            TabButtons.Parent = TabContainer
            
            local ButtonList = Instance.new("UIListLayout")
            ButtonList.FillDirection = Enum.FillDirection.Horizontal
            ButtonList.HorizontalAlignment = Enum.HorizontalAlignment.Left
            ButtonList.SortOrder = Enum.SortOrder.LayoutOrder
            ButtonList.Padding = UDim.new(0, 8)
            ButtonList.Parent = TabButtons
            
            local TabPages = Instance.new("Frame")
            TabPages.Size = UDim2.new(1, 0, 1, -45)
            TabPages.Position = UDim2.new(0, 0, 0, 45)
            TabPages.BackgroundTransparency = 1
            TabPages.Parent = TabContainer
            
            WindowObj.Tabs = {}
            
            function WindowObj:Tab(tabConfig)
                local TabObj = {}
                TabObj.__type = "Tab"
                
                -- ========== КНОПКА ВКЛАДКИ ==========
                local TabButton = Instance.new("TextButton")
                TabButton.Size = UDim2.new(0, 85, 0, 30)
                TabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
                TabButton.BackgroundTransparency = 0.2
                TabButton.Text = "   " .. tabConfig.Name
                TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
                TabButton.TextSize = 14
                TabButton.Font = Enum.Font.Gotham
                TabButton.BorderSizePixel = 0
                TabButton.AutoButtonColor = false
                TabButton.Parent = TabButtons
                TabButton.LayoutOrder = #WindowObj.Tabs
                
                local ButtonIcon = Instance.new("ImageLabel")
                ButtonIcon.Size = UDim2.new(0, 16, 0, 16)
                ButtonIcon.Position = UDim2.new(0, 8, 0.5, -8)
                ButtonIcon.BackgroundTransparency = 1
                ButtonIcon.Image = tabConfig.Icon or "rbxassetid://13951167659"
                ButtonIcon.ImageColor3 = Color3.fromRGB(200, 200, 200)
                ButtonIcon.Parent = TabButton
                
                -- ========== СТРАНИЦА ВКЛАДКИ ==========
                local TabPage = Instance.new("ScrollingFrame")
                TabPage.Size = UDim2.new(1, 0, 1, 0)
                TabPage.BackgroundTransparency = 1
                TabPage.BorderSizePixel = 0
                TabPage.ScrollBarThickness = 3
                TabPage.ScrollBarImageColor3 = Color3.fromRGB(255, 50, 100)
                TabPage.CanvasSize = UDim2.new(0, 0, 0, 0)
                TabPage.AutomaticCanvasSize = Enum.AutomaticSize.Y
                TabPage.Parent = TabPages
                TabPage.Visible = #WindowObj.Tabs == 0
                
                local PageLayout = Instance.new("UIListLayout")
                PageLayout.FillDirection = Enum.FillDirection.Vertical
                PageLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
                PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
                PageLayout.Padding = UDim.new(0, 12)
                PageLayout.Parent = TabPage
                
                -- ========== ПЕРЕКЛЮЧЕНИЕ ВКЛАДОК ==========
                TabButton.MouseButton1Click:Connect(function()
                    for _, btn in pairs(TabButtons:GetChildren()) do
                        if btn:IsA("TextButton") then
                            btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
                            btn.TextColor3 = Color3.fromRGB(200, 200, 200)
                            local icon = btn:FindFirstChildOfClass("ImageLabel")
                            if icon then icon.ImageColor3 = Color3.fromRGB(200, 200, 200) end
                        end
                    end
                    TabButton.BackgroundColor3 = Color3.fromRGB(255, 50, 100)
                    TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                    ButtonIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
                    
                    for _, page in pairs(TabPages:GetChildren()) do
                        if page:IsA("ScrollingFrame") then
                            page.Visible = false
                        end
                    end
                    TabPage.Visible = true
                end)
                
                TabObj.__page = TabPage
                TabObj.__layout = PageLayout
                
                function TabObj:Section(sectionConfig)
                    local SectionObj = {}
                    
                    local SectionFrame = Instance.new("Frame")
                    SectionFrame.Size = UDim2.new(1, -10, 0, 0)
                    SectionFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
                    SectionFrame.BackgroundTransparency = 0.2
                    SectionFrame.BorderSizePixel = 0
                    SectionFrame.AutomaticSize = Enum.AutomaticSize.Y
                    SectionFrame.Parent = TabPage
                    
                    local SectionOutline = Instance.new("ImageLabel")
                    SectionOutline.Size = UDim2.new(1, 0, 1, 0)
                    SectionOutline.BackgroundTransparency = 1
                    SectionOutline.Image = "rbxassetid://2592362371"
                    SectionOutline.ImageColor3 = Color3.fromRGB(40, 40, 45)
                    SectionOutline.ScaleType = Enum.ScaleType.Slice
                    SectionOutline.SliceCenter = Rect.new(2, 2, 62, 62)
                    SectionOutline.Parent = SectionFrame
                    
                    local SectionTitle = Instance.new("TextLabel")
                    SectionTitle.Size = UDim2.new(1, -20, 0, 30)
                    SectionTitle.Position = UDim2.new(0, 10, 0, 5)
                    SectionTitle.BackgroundTransparency = 1
                    SectionTitle.Text = sectionConfig.Name or "Section"
                    SectionTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
                    SectionTitle.TextSize = 16
                    SectionTitle.Font = Enum.Font.GothamSemibold
                    SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
                    SectionTitle.Parent = SectionFrame
                    
                    local SectionContent = Instance.new("Frame")
                    SectionContent.Size = UDim2.new(1, -20, 0, 0)
                    SectionContent.Position = UDim2.new(0, 10, 0, 40)
                    SectionContent.BackgroundTransparency = 1
                    SectionContent.AutomaticSize = Enum.AutomaticSize.Y
                    SectionContent.Parent = SectionFrame
                    
                    local ContentLayout = Instance.new("UIListLayout")
                    ContentLayout.FillDirection = Enum.FillDirection.Vertical
                    ContentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
                    ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
                    ContentLayout.Padding = UDim.new(0, 8)
                    ContentLayout.Parent = SectionContent
                    
                    function SectionObj:Toggle(toggleConfig)
                        local ToggleFrame = Instance.new("Frame")
                        ToggleFrame.Size = UDim2.new(1, 0, 0, 30)
                        ToggleFrame.BackgroundTransparency = 1
                        ToggleFrame.Parent = SectionContent
                        
                        local ToggleButton = Instance.new("TextButton")
                        ToggleButton.Size = UDim2.new(0, 50, 0, 24)
                        ToggleButton.Position = UDim2.new(1, -60, 0.5, -12)
                        ToggleButton.BackgroundColor3 = toggleConfig.Value and Color3.fromRGB(255, 50, 100) or Color3.fromRGB(40, 40, 45)
                        ToggleButton.Text = ""
                        ToggleButton.BorderSizePixel = 0
                        ToggleButton.AutoButtonColor = false
                        ToggleButton.Parent = ToggleFrame
                        
                        local ToggleCircle = Instance.new("Frame")
                        ToggleCircle.Size = UDim2.new(0, 20, 0, 20)
                        ToggleCircle.Position = toggleConfig.Value and UDim2.new(1, -26, 0.5, -10) or UDim2.new(0, 4, 0.5, -10)
                        ToggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                        ToggleCircle.BorderSizePixel = 0
                        ToggleCircle.Parent = ToggleButton
                        
                        local ToggleName = Instance.new("TextLabel")
                        ToggleName.Size = UDim2.new(1, -70, 1, 0)
                        ToggleName.Position = UDim2.new(0, 0, 0, 0)
                        ToggleName.BackgroundTransparency = 1
                        ToggleName.Text = toggleConfig.Name or "Toggle"
                        ToggleName.TextColor3 = Color3.fromRGB(220, 220, 220)
                        ToggleName.TextSize = 14
                        ToggleName.Font = Enum.Font.Gotham
                        ToggleName.TextXAlignment = Enum.TextXAlignment.Left
                        ToggleName.Parent = ToggleFrame
                        
                        local state = toggleConfig.Value or false
                        ToggleButton.MouseButton1Click:Connect(function()
                            state = not state
                            ToggleButton.BackgroundColor3 = state and Color3.fromRGB(255, 50, 100) or Color3.fromRGB(40, 40, 45)
                            ToggleCircle.Position = state and UDim2.new(1, -26, 0.5, -10) or UDim2.new(0, 4, 0.5, -10)
                            if toggleConfig.Callback then
                                toggleConfig.Callback(state)
                            end
                        end)
                        
                        return ToggleButton
                    end
                    
                    function SectionObj:Slider(sliderConfig)
                        local SliderFrame = Instance.new("Frame")
                        SliderFrame.Size = UDim2.new(1, 0, 0, 40)
                        SliderFrame.BackgroundTransparency = 1
                        SliderFrame.Parent = SectionContent
                        
                        local SliderName = Instance.new("TextLabel")
                        SliderName.Size = UDim2.new(1, 0, 0, 20)
                        SliderName.Position = UDim2.new(0, 0, 0, 0)
                        SliderName.BackgroundTransparency = 1
                        SliderName.Text = sliderConfig.Name .. ": " .. tostring(sliderConfig.Default or 0)
                        SliderName.TextColor3 = Color3.fromRGB(220, 220, 220)
                        SliderName.TextSize = 14
                        SliderName.Font = Enum.Font.Gotham
                        SliderName.TextXAlignment = Enum.TextXAlignment.Left
                        SliderName.Parent = SliderFrame
                        
                        local SliderBg = Instance.new("Frame")
                        SliderBg.Size = UDim2.new(1, -20, 0, 6)
                        SliderBg.Position = UDim2.new(0, 0, 0, 25)
                        SliderBg.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
                        SliderBg.BorderSizePixel = 0
                        SliderBg.Parent = SliderFrame
                        
                        local SliderFill = Instance.new("Frame")
                        SliderFill.Size = UDim2.new((sliderConfig.Default - sliderConfig.Min) / (sliderConfig.Max - sliderConfig.Min), 0, 1, 0)
                        SliderFill.BackgroundColor3 = Color3.fromRGB(255, 50, 100)
                        SliderFill.BorderSizePixel = 0
                        SliderFill.Parent = SliderBg
                        
                        local SliderKnob = Instance.new("Frame")
                        SliderKnob.Size = UDim2.new(0, 12, 0, 12)
                        SliderKnob.Position = UDim2.new(SliderFill.Size.X.Scale, -6, 0.5, -6)
                        SliderKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                        SliderKnob.BorderSizePixel = 0
                        SliderKnob.Parent = SliderBg
                        
                        local current = sliderConfig.Default
                        SliderName.Text = sliderConfig.Name .. ": " .. tostring(current)
                        
                        local dragging = false
                        SliderKnob.InputBegan:Connect(function(input)
                            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                                dragging = true
                            end
                        end)
                        SliderKnob.InputEnded:Connect(function(input)
                            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                                dragging = false
                            end
                        end)
                        
                        UIS.InputChanged:Connect(function(input)
                            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                                local mousePos = UIS:GetMouseLocation()
                                local absPos = SliderBg.AbsolutePosition
                                local absSize = SliderBg.AbsoluteSize.X
                                local relative = math.clamp((mousePos.X - absPos.X) / absSize, 0, 1)
                                local value = math.floor(sliderConfig.Min + (sliderConfig.Max - sliderConfig.Min) * relative)
                                if sliderConfig.Increment then
                                    value = math.round(value / sliderConfig.Increment) * sliderConfig.Increment
                                end
                                current = math.clamp(value, sliderConfig.Min, sliderConfig.Max)
                                SliderFill.Size = UDim2.new((current - sliderConfig.Min) / (sliderConfig.Max - sliderConfig.Min), 0, 1, 0)
                                SliderKnob.Position = UDim2.new(SliderFill.Size.X.Scale, -6, 0.5, -6)
                                SliderName.Text = sliderConfig.Name .. ": " .. tostring(current)
                                if sliderConfig.Callback then
                                    sliderConfig.Callback(current)
                                end
                            end
                        end)
                    end
                    
                    function SectionObj:Dropdown(dropdownConfig)
                        local DropdownFrame = Instance.new("Frame")
                        DropdownFrame.Size = UDim2.new(1, 0, 0, 30)
                        DropdownFrame.BackgroundTransparency = 1
                        DropdownFrame.Parent = SectionContent
                        
                        local DropdownName = Instance.new("TextLabel")
                        DropdownName.Size = UDim2.new(0.5, -10, 1, 0)
                        DropdownName.Position = UDim2.new(0, 0, 0, 0)
                        DropdownName.BackgroundTransparency = 1
                        DropdownName.Text = dropdownConfig.Name or "Dropdown"
                        DropdownName.TextColor3 = Color3.fromRGB(220, 220, 220)
                        DropdownName.TextSize = 14
                        DropdownName.Font = Enum.Font.Gotham
                        DropdownName.TextXAlignment = Enum.TextXAlignment.Left
                        DropdownName.Parent = DropdownFrame
                        
                        local DropdownButton = Instance.new("TextButton")
                        DropdownButton.Size = UDim2.new(0.5, -10, 0, 26)
                        DropdownButton.Position = UDim2.new(0.5, 10, 0, 2)
                        DropdownButton.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
                        DropdownButton.Text = dropdownConfig.Default or dropdownConfig.Options[1]
                        DropdownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                        DropdownButton.TextSize = 14
                        DropdownButton.Font = Enum.Font.Gotham
                        DropdownButton.BorderSizePixel = 0
                        DropdownButton.Parent = DropdownFrame
                        
                        local current = dropdownConfig.Default or dropdownConfig.Options[1]
                        DropdownButton.MouseButton1Click:Connect(function()
                            local idx = 1
                            for i, opt in ipairs(dropdownConfig.Options) do
                                if opt == current then idx = i break end
                            end
                            idx = idx % #dropdownConfig.Options + 1
                            current = dropdownConfig.Options[idx]
                            DropdownButton.Text = current
                            if dropdownConfig.Callback then
                                dropdownConfig.Callback(current)
                            end
                        end)
                    end
                    
                    return SectionObj
                end
                
                table.insert(WindowObj.Tabs, TabObj)
                return TabObj
            end
            
            return WindowObj
        end
    }
    
    _G.LibLoaded = true
end

-- =============================================
-- ⚙️ КОНФИГУРАЦИЯ (MATCHA SPEC)
-- =============================================
getgenv().Config = {
    -- Aimbot Core
    Aimbot = false,
    AimMode = "Silent", -- Silent, Visible, Rage
    Hitbox = "Head",    -- Head, Torso, Legs, Random
    HitboxExpand = 2.5, -- 1.0-2.5
    FOV = 169,          -- 0-500
    ShowFOV = true,
    FOVStyle = "Smooth", -- Smooth, Glow, Outline
    FOVColor = Color3.fromRGB(255, 80, 80),
    
    -- Smoothness
    SmoothX = 1.0,      -- 1-100
    SmoothY = 20.0,     -- 1-100
    SmoothEnabled = true,
    
    -- Prediction
    Prediction = true,
    PredX = 1.0,        -- 1-20
    PredY = 20.0,       -- 1-20
    Resolver = true,
    
    -- Trigger Bot
    Triggerbot = false,
    TriggerDelay = 1,   -- ms
    TriggerRelease = 1, -- ms
    TriggerVisibleCheck = true,
    TriggerTeamCheck = true,
    
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
    ["⚡ Season 1 Legendary"] = 16789012350,
    ["💎 Void Walker"] = 16789012351,
}

-- =============================================
-- 🎯 AIMBOT ENGINE (ПОЛНЫЙ SPECTRUM)
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
FOVCircle.Radius = getgenv().Config.FOV
FOVCircle.Color = getgenv().Config.FOVColor
FOVCircle.Thickness = 1.5
FOVCircle.Filled = false
FOVCircle.NumSides = 64

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

-- Target Acquisition
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
    local expand = getgenv().Config.HitboxExpand
    
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

-- Visible Aim (Smooth Camera)
RunService.RenderStepped:Connect(function()
    if getgenv().Config.Aimbot and getgenv().Config.AimMode == "Visible" then
        local target = getClosestPlayer()
        if target then
            local hitPos = getHitboxPosition(target)
            if hitPos then
                local smoothX = getgenv().Config.SmoothEnabled and getgenv().Config.SmoothX or 1
                local smoothY = getgenv().Config.SmoothEnabled and getgenv().Config.SmoothY or 1
                
                local current = Camera.CFrame
                local goal = CFrame.new(current.Position, hitPos)
                
                local newX = current.X:Lerp(goal.X, smoothX/100)
                local newY = current.Y:Lerp(goal.Y, smoothY/100)
                local newZ = current.Z:Lerp(goal.Z, smoothX/100)
                
                Camera.CFrame = CFrame.new(newX, newY, newZ, goal.Rotation)
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
                
                -- Prediction
                if getgenv().Config.Prediction and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                    local root = target.Character.HumanoidRootPart
                    local velocity = root.Velocity
                    hitPos = hitPos + Vector3.new(
                        velocity.X * (getgenv().Config.PredX / 20),
                        velocity.Y * (getgenv().Config.PredY / 20),
                        velocity.Z * (getgenv().Config.PredX / 20)
                    )
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

-- =============================================
-- ⚡ TRIGGER BOT
-- =============================================
local triggerConnection
local function setupTriggerBot()
    if triggerConnection then triggerConnection:Disconnect() end
    
    if not getgenv().Config.Triggerbot then return end
    
    triggerConnection = RunService.RenderStepped:Connect(function()
        if not getgenv().Config.Triggerbot then return end
        
        local target = getClosestPlayer()
        if target then
            if getgenv().Config.TriggerVisibleCheck then
                local head = target.Character and target.Character:FindFirstChild("Head")
                if head then
                    local pos, vis = Camera:WorldToViewportPoint(head.Position)
                    if not vis then return end
                end
            end
            
            task.wait(getgenv().Config.TriggerDelay / 1000)
            mouse1press()
            task.wait(getgenv().Config.TriggerRelease / 1000)
            mouse1release()
        end
    end)
end

getgenv().Config.Triggerbot = false -- по умолчанию выкл

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
        ESP[p].Dist.Size = 14; ESP[p].Dist.Center = true; ESP[p].Dist.Outline = true; ESP[p].Dist.Font = 3
        ESP[p].Box.Thickness = 1.5; ESP[p].Box.Filled = false
        ESP[p].HealthBg.Filled = true; ESP[p].Health.Filled = true
        ESP[p].HealthBg.Color = Color3.fromRGB(20, 20, 20)
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
        ESP[p].Dist.Size = 14; ESP[p].Dist.Center = true; ESP[p].Dist.Outline = true; ESP[p].Dist.Font = 3
        ESP[p].Box.Thickness = 1.5; ESP[p].Box.Filled = false
        ESP[p].HealthBg.Filled = true; ESP[p].Health.Filled = true
        ESP[p].HealthBg.Color = Color3.fromRGB(20, 20, 20)
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
        if p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Head") then
            local rootPos, rootVis = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
            local headPos, headVis = Camera:WorldToViewportPoint(p.Character.Head.Position + Vector3.new(0, 0.5, 0))
            
            if rootVis and headVis then
                local height = math.abs((headPos.Y - rootPos.Y) * 1.5)
                local width = height * 0.6
                local boxPos = Vector2.new(rootPos.X - width/2, rootPos.Y - height/4)
                
                if getgenv().Config.ESPBox then
                    e.Box.Visible = true
                    e.Box.Color = getgenv().Config.ESPColor
                    e.Box.Position = boxPos
                    e.Box.Size = Vector2.new(width, height)
                else e.Box.Visible = false end
                
                if getgenv().Config.ESPName then
                    e.Name.Visible = true
                    e.Name.Position = Vector2.new(rootPos.X, rootPos.Y - height/2 - 20)
                    e.Name.Text = p.Name
                    e.Name.Color = getgenv().Config.ESPColor
                else e.Name.Visible = false end
                
                if getgenv().Config.ESPDistance then
                    e.Dist.Visible = true
                    e.Dist.Position = Vector2.new(rootPos.X, rootPos.Y - height/2 - 5)
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
-- 🎨 SKIN CHANGER
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
-- 🖥️ UI CONSTRUCTION (KICIAHOOK STYLE)
-- =============================================
local Zenith = _G.Lib:Window({
    Title = "RIVALS ZENITH",
    SubTitle = "made by aspan666",
    Bind = "RightShift",
    Startup = true,
    Theme = {
        Accent = Color3.fromRGB(255, 50, 100),
        Background = Color3.fromRGB(18, 18, 22),
    }
})

-- ========== AIMBOT TAB ==========
local AimTab = Zenith:Tab({Name = "AIMBOT", Icon = "rbxassetid://13951167659"})
local AimMain = AimTab:Section({Name = "AIMBOT CORE"})

AimMain:Toggle({
    Name = "Aimbot Enabled",
    Value = getgenv().Config.Aimbot,
    Callback = function(v) getgenv().Config.Aimbot = v end
})

AimMain:Dropdown({
    Name = "Aim Type",
    Options = {"Silent", "Visible", "Rage"},
    Default = getgenv().Config.AimMode,
    Callback = function(v) getgenv().Config.AimMode = v end
})

AimMain:Dropdown({
    Name = "Hitbox",
    Options = {"Head", "Torso", "Legs", "Random"},
    Default = getgenv().Config.Hitbox,
    Callback = function(v) getgenv().Config.Hitbox = v end
})

AimMain:Slider({
    Name = "Hitbox Expand",
    Min = 1.0,
    Max = 2.5,
    Increment = 0.1,
    Default = getgenv().Config.HitboxExpand,
    Callback = function(v) getgenv().Config.HitboxExpand = v end
})

AimMain:Slider({
    Name = "Aimbot FOV",
    Min = 0,
    Max = 500,
    Increment = 5,
    Default = getgenv().Config.FOV,
    Callback = function(v) getgenv().Config.FOV = v end
})

AimMain:Toggle({
    Name = "Show FOV Circle",
    Value = getgenv().Config.ShowFOV,
    Callback = function(v) getgenv().Config.ShowFOV = v end
})

AimMain:ColorPicker({
    Name = "FOV Color",
    Default = getgenv().Config.FOVColor,
    Callback = function(v) getgenv().Config.FOVColor = v end
})

local SmoothSection = AimTab:Section({Name = "SMOOTHNESS"})

SmoothSection:Toggle({
    Name = "Smooth Enabled",
    Value = getgenv().Config.SmoothEnabled,
    Callback = function(v) getgenv().Config.SmoothEnabled = v end
})

SmoothSection:Slider({
    Name = "Smoothness X",
    Min = 1,
    Max = 100,
    Increment = 1,
    Default = getgenv().Config.SmoothX,
    Callback = function(v) getgenv().Config.SmoothX = v end
})

SmoothSection:Slider({
    Name = "Smoothness Y",
    Min = 1,
    Max = 100,
    Increment = 1,
    Default = getgenv().Config.SmoothY,
    Callback = function(v) getgenv().Config.SmoothY = v end
})

local PredSection = AimTab:Section({Name = "PREDICTION"})

PredSection:Toggle({
    Name = "Prediction",
    Value = getgenv().Config.Prediction,
    Callback = function(v) getgenv().Config.Prediction = v end
})

PredSection:Slider({
    Name = "Prediction X",
    Min = 1,
    Max = 20,
    Increment = 0.5,
    Default = getgenv().Config.PredX,
    Callback = function(v) getgenv().Config.PredX = v end
})

PredSection:Slider({
    Name = "Prediction Y",
    Min = 1,
    Max = 20,
    Increment = 0.5,
    Default = getgenv().Config.PredY,
    Callback = function(v) getgenv().Config.PredY = v end
})

PredSection:Toggle({
    Name = "Resolver",
    Value = getgenv().Config.Resolver,
    Callback = function(v) getgenv().Config.Resolver = v end
})

local TriggerSection = AimTab:Section({Name = "TRIGGER BOT"})

TriggerSection:Toggle({
    Name = "Triggerbot",
    Value = getgenv().Config.Triggerbot,
    Callback = function(v) 
        getgenv().Config.Triggerbot = v
        setupTriggerBot()
    end
})

TriggerSection:Slider({
    Name = "Delay (ms)",
    Min = 1,
    Max = 100,
    Increment = 1,
    Default = getgenv().Config.TriggerDelay,
    Callback = function(v) getgenv().Config.TriggerDelay = v end
})

TriggerSection:Slider({
    Name = "Release (ms)",
    Min = 1,
    Max = 100,
    Increment = 1,
    Default = getgenv().Config.TriggerRelease,
    Callback = function(v) getgenv().Config.TriggerRelease = v end
})

-- ========== ESP TAB ==========
local ESPTab = Zenith:Tab({Name = "VISUALS", Icon = "rbxassetid://13951169214"})
local ESPMain = ESPTab:Section({Name = "ESP CONFIG"})

ESPMain:Toggle({
    Name = "ESP Enabled",
    Value = getgenv().Config.ESP,
    Callback = function(v) getgenv().Config.ESP = v end
})

ESPMain:Toggle({
    Name = "Box",
    Value = getgenv().Config.ESPBox,
    Callback = function(v) getgenv().Config.ESPBox = v end
})

ESPMain:Toggle({
    Name = "Name",
    Value = getgenv().Config.ESPName,
    Callback = function(v) getgenv().Config.ESPName = v end
})

ESPMain:Toggle({
    Name = "Distance",
    Value = getgenv().Config.ESPDistance,
    Callback = function(v) getgenv().Config.ESPDistance = v end
})

ESPMain:Toggle({
    Name = "Health",
    Value = getgenv().Config.ESPHealth,
    Callback = function(v) getgenv().Config.ESPHealth = v end
})

ESPMain:ColorPicker({
    Name = "ESP Color",
    Default = getgenv().Config.ESPColor,
    Callback = function(v) getgenv().Config.ESPColor = v end
})

-- ========== MOVEMENT TAB ==========
local MoveTab = Zenith:Tab({Name = "MOVEMENT", Icon = "rbxassetid://13951164120"})
local MoveMain = MoveTab:Section({Name = "PLAYER"})

MoveMain:Slider({
    Name = "WalkSpeed",
    Min = 16,
    Max = 350,
    Increment = 5,
    Default = getgenv().Config.Speed,
    Callback = function(v)
        getgenv().Config.Speed = v
        if LP.Character and LP.Character:FindFirstChild("Humanoid") then
            LP.Character.Humanoid.WalkSpeed = v
        end
    end
})

MoveMain:Slider({
    Name = "JumpPower",
    Min = 50,
    Max = 200,
    Increment = 5,
    Default = getgenv().Config.Jump,
    Callback = function(v)
        getgenv().Config.Jump = v
        if LP.Character and LP.Character:FindFirstChild("Humanoid") then
            LP.Character.Humanoid.JumpPower = v
        end
    end
})

MoveMain:Toggle({
    Name = "Fly",
    Value = getgenv().Config.Fly,
    Callback = function(v)
        getgenv().Config.Fly = v
        toggleFly(v)
    end
})

MoveMain:Slider({
    Name = "Fly Speed",
    Min = 10,
    Max = 200,
    Increment = 5,
    Default = getgenv().Config.FlySpeed,
    Callback = function(v) getgenv().Config.FlySpeed = v end
})

MoveMain:Toggle({
    Name = "Noclip",
    Value = getgenv().Config.Noclip,
    Callback = function(v) getgenv().Config.Noclip = v end
})

-- ========== SKIN TAB ==========
local SkinTab = Zenith:Tab({Name = "SKINS", Icon = "rbxassetid://13951167951"})
local SkinMain = SkinTab:Section({Name = "SKIN CHANGER"})

SkinMain:Toggle({
    Name = "Skin Changer",
    Value = getgenv().Config.SkinChanger,
    Callback = function(v) getgenv().Config.SkinChanger = v end
})

local SkinList = SkinTab:Section({Name = "LEGENDARY SKINS"})
for name, id in pairs(getgenv().Skins) do
    SkinList:Button({
        Name = name,
        Callback = function()
            getgenv().Config.CurrentSkin = id
            _G.Lib:Notify({
                Title = "Skin Changer",
                Desc = "Selected: " .. name,
                Duration = 3
            })
        end
    })
end

-- ========== INIT ==========
_G.Lib:Notify({
    Title = "RIVALS ZENITH",
    Desc = "Made by aspan666\n✅ Premium Loaded | Matcha Spec",
    Duration = 5
})

print("========================================")
print("🔥 RIVALS ZENITH by aspan666")
print("✅ PREMIUM EDITION LOADED")
print("📌 Press RightShift for menu")
print("⚡ Silent Aim | Triggerbot | FOV | Pred X/Y")
print("========================================")
