-- Xycon UI Library - Updated with Draggable Window, Button Fix, Close/Minimize Buttons, Reopen Functionality, AddTab, AddButton, AddToggle, and Keybinding (L key)
local UILib = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

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
        Parent = game:GetService("CoreGui"),
        ResetOnSpawn = false
    })

    local mainFrame = create("Frame", {
        Size = UDim2.new(0, 500, 0, 300),
        Position = UDim2.new(0.5, -250, 0.5, -150),
        BackgroundColor3 = Color3.fromRGB(25, 25, 25),
        BorderSizePixel = 0,
        Parent = screenGui,
        Name = "Main"
    })

    create("UICorner", {Parent = mainFrame})

    -- Title TextLabel
    local title = create("TextLabel", {
        Size = UDim2.new(1, -60, 0, 30), -- Adjusted size to make space for buttons
        Position = UDim2.new(0, 0, 0, 0), -- Positioning to top-left
        BackgroundTransparency = 1,
        Text = titleText or "Xycon UI",
        TextColor3 = Color3.fromRGB(0, 255, 170),
        Font = Enum.Font.GothamBold,
        TextSize = 20,
        TextXAlignment = Enum.TextXAlignment.Left, -- Left-align the text
        Parent = mainFrame
    })

    -- Minimize Button ( - )
    local minimizeButton = create("TextButton", {
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -35, 0, 5),
        Text = "-",
        BackgroundColor3 = Color3.fromRGB(255, 0, 0),
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.Gotham,
        TextSize = 20,
        Parent = mainFrame
    })
    create("UICorner", {Parent = minimizeButton})

    -- Close Button ( X )
    local closeButton = create("TextButton", {
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -35, 0, 35),
        Text = "X",
        BackgroundColor3 = Color3.fromRGB(255, 0, 0),
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.Gotham,
        TextSize = 20,
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

    create("UIListLayout", {
        Parent = tabHolder,
        SortOrder = Enum.SortOrder.LayoutOrder
    })

    local contentHolder = create("Frame", {
        Size = UDim2.new(1, -100, 1, -30),
        Position = UDim2.new(0, 100, 0, 30),
        BackgroundTransparency = 1,
        Parent = mainFrame
    })

    -- Draggable Window Logic
    local dragInput, mousePos, framePos

    local function updateDrag(input)
        local delta = input.Position - mousePos
        mainFrame.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
    end

    -- Dragging logic for the title bar
    title.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragInput = input
            mousePos = input.Position
            framePos = mainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragInput = nil
                end
            end)
        end
    end)

    title.InputChanged:Connect(function(input)
        if input == dragInput then
            updateDrag(input)
        end
    end)

    -- Minimize Button Functionality
    minimizeButton.MouseButton1Click:Connect(function()
        mainFrame.Visible = false  -- Hides the window but keeps it draggable
    end)

    -- Close Button Functionality
    closeButton.MouseButton1Click:Connect(function()
        screenGui:Destroy()  -- Completely destroys the UI
    end)

    -- Reopen Window after Minimize
    title.MouseButton1Click:Connect(function()
        mainFrame.Visible = true  -- Makes the window visible again
    end)

    -- Keybinding (L key) to toggle visibility
    local windowOpen = false
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.UserInputType == Enum.UserInputType.Keyboard then
            if input.KeyCode == Enum.KeyCode.L then
                windowOpen = not windowOpen
                mainFrame.Visible = windowOpen
            end
        end
    end)

    local Window = {}

    -- AddButton function
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
            Padding = UDim.new(0, 8)
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

        -- AddButton function
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

        -- AddToggle function
        function Tab:AddToggle(toggleName, defaultState, callback)
            local toggleFrame = create("Frame", {
                Size = UDim2.new(1, -10, 0, 30),
                BackgroundColor3 = Color3.fromRGB(45, 45, 45),
                Parent = tabPage
            })
            create("UICorner", {Parent = toggleFrame})

            local toggleButton = create("TextButton", {
                Size = UDim2.new(0, 50, 0, 20),
                Position = UDim2.new(1, -60, 0, 5),
                BackgroundColor3 = Color3.fromRGB(0, 255, 170),
                Font = Enum.Font.Gotham,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 14,
                Text = defaultState and "On" or "Off",
                Parent = toggleFrame
            })
            create("UICorner", {Parent = toggleButton})

            local toggleLabel = create("TextLabel", {
                Size = UDim2.new(1, -70, 0, 30),
                BackgroundTransparency = 1,
                Text = toggleName,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                Font = Enum.Font.Gotham,
                TextSize = 16,
                Parent = toggleFrame
            })

            local toggled = defaultState

            toggleButton.MouseButton1Click:Connect(function()
                toggled = not toggled
                toggleButton.Text = toggled and "On" or "Off"
                if callback then
                    callback(toggled)
                end
            end)
        end

        return Tab
    end

    return Window
end

return UILib
