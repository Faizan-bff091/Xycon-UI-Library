local UILib = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local function create(class, props)
    local inst = Instance.new(class)
    for i, v in pairs(props) do
        inst[i] = v
    end
    return inst
end

function UILib:CreateWindow(titleText)
    local screenGui = create("ScreenGui", {
        Name = "XyconUI",
        Parent = CoreGui,
        ResetOnSpawn = false
    })

    local dragConnection = nil

    local mainFrame = create("Frame", {
        Size = UDim2.new(0, 500, 0, 300),
        Position = UDim2.new(0.5, -250, 0.5, -150),
        BackgroundColor3 = Color3.fromRGB(25, 25, 25),
        BorderSizePixel = 0,
        Name = "Main",
        Parent = screenGui
    })
    create("UICorner", {Parent = mainFrame})
    create("UIStroke", {Parent = mainFrame, Color = Color3.fromRGB(0, 255, 170)})

    local title = create("TextLabel", {
        Size = UDim2.new(1, -50, 0, 30),
        BackgroundTransparency = 1,
        Text = titleText or "Xycon UI",
        TextColor3 = Color3.fromRGB(0, 255, 170),
        Font = Enum.Font.GothamBold,
        TextSize = 20,
        Parent = mainFrame,
        Name = "Title",
        Position = UDim2.new(0, 10, 0, 0),
        TextXAlignment = Enum.TextXAlignment.Left
    })

    -- Red X button to minimize
    local closeButton = create("TextButton", {
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -35, 0, 0),
        BackgroundColor3 = Color3.fromRGB(255, 50, 50),
        Text = "X",
        Font = Enum.Font.GothamBold,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 18,
        Parent = mainFrame
    })
    create("UICorner", {Parent = closeButton})

    local tabHolder = create("Frame", {
        Size = UDim2.new(0, 100, 1, -30),
        Position = UDim2.new(0, 0, 0, 30),
        BackgroundColor3 = Color3.fromRGB(20, 20, 20),
        BorderSizePixel = 0,
        Parent = mainFrame
    })
    create("UICorner", {Parent = tabHolder})

    local tabLayout = create("UIListLayout", {
        Parent = tabHolder,
        SortOrder = Enum.SortOrder.LayoutOrder
    })

    local contentHolder = create("Frame", {
        Size = UDim2.new(1, -100, 1, -30),
        Position = UDim2.new(0, 100, 0, 30),
        BackgroundTransparency = 1,
        Parent = mainFrame
    })

    -- Small blue X button for restore
    local minimizedButton = create("TextButton", {
        Size = UDim2.new(0, 40, 0, 40),
        Position = UDim2.new(0, 10, 0.5, -20),
        BackgroundColor3 = Color3.fromRGB(0, 170, 255),
        Text = "X",
        TextColor3 = Color3.new(1, 1, 1),
        Font = Enum.Font.GothamBold,
        TextSize = 18,
        Visible = false,
        Parent = screenGui
    })
    create("UICorner", {Parent = minimizedButton})

    -- Dragging support
    local dragging = false
    local dragInput, dragStart, startPos

    title.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
        end
    end)

    title.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    closeButton.MouseButton1Click:Connect(function()
        mainFrame.Visible = false
        minimizedButton.Visible = true
    end)

    minimizedButton.MouseButton1Click:Connect(function()
        mainFrame.Visible = true
        minimizedButton.Visible = false
    end)

    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.L then
            screenGui.Enabled = not screenGui.Enabled
        end
    end)

    local Window = {}

    function Window:CreateTab(name)
        local tabButton = create("TextButton", {
            Size = UDim2.new(1, 0, 0, 30),
            BackgroundColor3 = Color3.fromRGB(35, 35, 35),
            Text = name,
            Font = Enum.Font.Gotham,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 16,
            Parent = tabHolder
        })
        create("UICorner", {Parent = tabButton})

        local tabPage = create("Frame", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Visible = false,
            Parent = contentHolder
        })

        create("UIListLayout", {
            Parent = tabPage,
            Padding = UDim.new(0, 6)
        })

        tabButton.MouseButton1Click:Connect(function()
            for _, child in pairs(contentHolder:GetChildren()) do
                if child:IsA("Frame") then
                    child.Visible = false
                end
            end
            tabPage.Visible = true
        end)

        local Tab = {}

        function Tab:AddButton(buttonName, callback)
            local button = create("TextButton", {
                Size = UDim2.new(1, -10, 0, 30),
                BackgroundColor3 = Color3.fromRGB(45, 45, 45),
                Text = buttonName,
                Font = Enum.Font.Gotham,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 16,
                Parent = tabPage
            })
            create("UICorner", {Parent = button})

            button.MouseButton1Click:Connect(function()
                if callback then
                    pcall(callback)
                end
            end)
        end

        function Tab:AddToggle(name, default, callback)
            local toggle = create("TextButton", {
                Size = UDim2.new(1, -10, 0, 30),
                BackgroundColor3 = Color3.fromRGB(45, 45, 45),
                Text = name .. ": " .. (default and "ON" or "OFF"),
                Font = Enum.Font.Gotham,
                TextColor3 = Color3.new(1, 1, 1),
                TextSize = 16,
                Parent = tabPage
            })
            create("UICorner", {Parent = toggle})

            local toggled = default

            toggle.MouseButton1Click:Connect(function()
                toggled = not toggled
                toggle.Text = name .. ": " .. (toggled and "ON" or "OFF")
                if callback then
                    pcall(callback, toggled)
                end
            end)
        end

        -- Add Slider to tab
        function Tab:AddSlider(name, minValue, maxValue, defaultValue, callback)
            local sliderFrame = create("Frame", {
                Size = UDim2.new(1, -10, 0, 30),
                BackgroundColor3 = Color3.fromRGB(45, 45, 45),
                Parent = tabPage
            })
            create("UICorner", {Parent = sliderFrame})

            local sliderBar = create("Frame", {
                Size = UDim2.new(0, 180, 0, 6),
                Position = UDim2.new(0, 10, 0, 12),
                BackgroundColor3 = Color3.fromRGB(200, 200, 200),
                Parent = sliderFrame
            })
            create("UICorner", {Parent = sliderBar})

            local sliderButton = create("TextButton", {
                Size = UDim2.new(0, 20, 0, 20),
                Position = UDim2.new(0, (defaultValue - minValue) / (maxValue - minValue) * sliderBar.AbsoluteSize.X, 0, -7),
                BackgroundColor3 = Color3.fromRGB(0, 255, 255),
                Text = "",
                Parent = sliderBar
            })
            create("UICorner", {Parent = sliderButton})

            local isDragging = false
            local function updateSlider(value)
                value = math.clamp(value, minValue, maxValue)
                local normalizedValue = (value - minValue) / (maxValue - minValue)
                sliderButton.Position = UDim2.new(normalizedValue, 0, 0, -7)
                if callback then
                    callback(value)
                end
            end

            sliderButton.MouseButton1Down:Connect(function()
                isDragging = true
            end)

            UserInputService.InputChanged:Connect(function(input)
                if isDragging then
                    local mousePos = input.Position.X
                    local barPos = sliderBar.AbsolutePosition.X
                    local newPos = math.clamp(mousePos - barPos, 0, sliderBar.AbsoluteSize.X)
                    updateSlider(minValue + (newPos / sliderBar.AbsoluteSize.X) * (maxValue - minValue))
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    isDragging = false
                end
            end)

            return sliderFrame
        end

        return Tab
    end

    return Window
end

return UILib
