-- Xycon UI Library - Updated Version with Persistent Minimize Button and Key to Close UI
local UILib = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

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
    create("UIStroke", {Parent = mainFrame, Color = Color3.fromRGB(0, 255, 170)})

    local title = create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundTransparency = 1,
        Text = titleText or "Xycon UI",
        TextColor3 = Color3.fromRGB(0, 255, 170),
        Font = Enum.Font.GothamBold,
        TextSize = 20,
        Parent = mainFrame
    })

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

        local layout = create("UIListLayout", {
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

        function Tab:AddToggle(toggleName, defaultState, callback)
            local toggle = create("TextButton", {
                Size = UDim2.new(1, -10, 0, 30),
                BackgroundColor3 = Color3.fromRGB(45, 45, 45),
                Text = toggleName .. (defaultState and " (On)" or " (Off)"),
                Font = Enum.Font.Gotham,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 16,
                Parent = tabPage
            })
            create("UICorner", {Parent = toggle})

            toggle.MouseButton1Click:Connect(function()
                defaultState = not defaultState
                toggle.Text = toggleName .. (defaultState and " (On)" or " (Off)")
                if callback then
                    callback(defaultState)
                end
            end)
        end

        return Tab
    end

    -- Close and Minimize Buttons
    local function addMinimizeAndCloseButtons()
        local closeButton = create("TextButton", {
            Size = UDim2.new(0, 30, 0, 30),
            Position = UDim2.new(1, -30, 0, 0),
            BackgroundColor3 = Color3.fromRGB(255, 0, 0),
            Text = "X",
            Font = Enum.Font.GothamBold,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 20,
            Parent = mainFrame
        })
        create("UICorner", {Parent = closeButton})

        closeButton.MouseButton1Click:Connect(function()
            screenGui:Destroy()  -- Destroys the entire GUI
        end)

        local minimizeButton = create("TextButton", {
            Size = UDim2.new(0, 30, 0, 30),
            Position = UDim2.new(1, -60, 0, 0),
            BackgroundColor3 = Color3.fromRGB(255, 255, 0),
            Text = "-",
            Font = Enum.Font.GothamBold,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 20,
            Parent = mainFrame
        })
        create("UICorner", {Parent = minimizeButton})

        local isMinimized = false
        minimizeButton.MouseButton1Click:Connect(function()
            isMinimized = not isMinimized
            -- Toggle the visibility of the tab content holder
            contentHolder.Visible = not isMinimized
        end)
    end

    -- Draggable UI Functionality
    local dragInput, dragStart, startPos
    local function dragUI(input)
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    local function beginDrag(input)
        dragStart = input.Position
        startPos = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragInput:Disconnect()
            end
        end)
        dragInput = input.InputChanged:Connect(dragUI)
    end

    mainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            beginDrag(input)
        end
    end)

    addMinimizeAndCloseButtons()

    return Window
end

-- Automatically open and close UI with 'L' key press
local screenGui -- Variable to store the reference to the GUI

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.L then
        if screenGui then
            screenGui:Destroy()  -- Close the UI if it's already open
        else
            -- Open the UI if it's not open
            screenGui = UILib:CreateWindow("Xycon UI")
            local tab = screenGui:CreateTab("Main")

            tab:AddButton("Click Me", function()
                print("Button was clicked!")
            end)

            tab:AddToggle("God Mode", false, function(state)
                print("God Mode:", state and "Enabled" or "Disabled")
            end)
        end
    end
end)

return UILib
