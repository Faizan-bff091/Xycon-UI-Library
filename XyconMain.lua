-- Xycon UI Library - Updated with Toggle
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
            local toggle = defaultState or false

            local frame = create("Frame", {
                Size = UDim2.new(1, -10, 0, 30),
                BackgroundColor3 = Color3.fromRGB(45, 45, 45),
                Parent = tabPage
            })
            create("UICorner", {Parent = frame})

            local label = create("TextLabel", {
                Size = UDim2.new(1, -40, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                Text = toggleName,
                Font = Enum.Font.Gotham,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 16,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = frame
            })

            local toggleBtn = create("TextButton", {
                Size = UDim2.new(0, 20, 0, 20),
                Position = UDim2.new(1, -30, 0.5, -10),
                BackgroundColor3 = toggle and Color3.fromRGB(0, 255, 170) or Color3.fromRGB(70, 70, 70),
                Text = "",
                Parent = frame
            })
            create("UICorner", {Parent = toggleBtn})

            toggleBtn.MouseButton1Click:Connect(function()
                toggle = not toggle
                toggleBtn.BackgroundColor3 = toggle and Color3.fromRGB(0, 255, 170) or Color3.fromRGB(70, 70, 70)
                if callback then
                    pcall(callback, toggle)
                end
            end)
        end

        return Tab
    end

    return Window
end

return UILib
