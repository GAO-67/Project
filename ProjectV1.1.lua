local ScreenGui = Instance.new("ScreenGui")
local UIContainer = Instance.new("Frame")
local Sidebar = Instance.new("Frame")
local MainArea = Instance.new("ScrollingFrame")
local MiniCircle = Instance.new("ImageButton")

ScreenGui.Name = "NYX_CN_Panel"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

-- Mini Circle
MiniCircle.Name = "MiniCircle"
MiniCircle.Parent = ScreenGui
MiniCircle.BackgroundColor3 = Color3.fromRGB(0,0,0)
MiniCircle.Size = UDim2.new(0,50,0,50)
MiniCircle.Position = UDim2.new(0.9,0,0.9,0)
MiniCircle.Visible = false
MiniCircle.ZIndex = 50
local CircleCorner = Instance.new("UICorner", MiniCircle)
CircleCorner.CornerRadius = UDim.new(1,0)

-- UI Container
UIContainer.Name = "UIContainer"
UIContainer.Parent = ScreenGui
UIContainer.BackgroundColor3 = Color3.fromRGB(219,234,254)
UIContainer.Position = UDim2.new(0.5,-300,0.5,-200)
UIContainer.Size = UDim2.new(0,600,0,400)
UIContainer.ClipsDescendants = true
Instance.new("UICorner", UIContainer).CornerRadius = UDim.new(0,8)

-- Sidebar
Sidebar.Name = "Sidebar"
Sidebar.Parent = UIContainer
Sidebar.BackgroundColor3 = Color3.fromRGB(59,130,246)
Sidebar.Size = UDim2.new(0.25,0,1,0)

local SidebarList = Instance.new("UIListLayout", Sidebar)
SidebarList.Padding = UDim.new(0,10)
SidebarList.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Main Area
MainArea.Name = "MainArea"
MainArea.Parent = UIContainer
MainArea.BackgroundColor3 = Color3.fromRGB(255,255,255)
MainArea.Position = UDim2.new(0.27,0,0.05,0)
MainArea.Size = UDim2.new(0.7,0,0.9,0)
MainArea.CanvasSize = UDim2.new(0,0,2,0)
Instance.new("UICorner", MainArea)

-- Close Button
local CloseBtn = Instance.new("TextButton", UIContainer)
CloseBtn.Size = UDim2.new(0,25,0,25)
CloseBtn.Position = UDim2.new(0.95,0,0.02,0)
CloseBtn.BackgroundColor3 = Color3.fromRGB(220,38,38)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1,0)

CloseBtn.MouseButton1Click:Connect(function()
    UIContainer.Visible = false
    MiniCircle.Visible = true
end)

MiniCircle.MouseButton1Click:Connect(function()
    UIContainer.Visible = true
    MiniCircle.Visible = false
end)

-- Function Button Colors
local function createMenuButton(name, menuID)
    local btn = Instance.new("TextButton", Sidebar)
    btn.Size = UDim2.new(0.9,0,0,40)
    btn.BackgroundColor3 = Color3.fromRGB(255,255,255)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(0,0,0)
    Instance.new("UICorner", btn)
    
    btn.MouseButton1Click:Connect(function()
        for _,v in pairs(MainArea:GetChildren()) do
            if v:IsA("Frame") then v:Destroy() end
        end

        for i = 1,4 do
            local fnFrame = Instance.new("Frame", MainArea)
            fnFrame.Size = UDim2.new(0.95,0,0,45)
            fnFrame.BackgroundColor3 = Color3.fromRGB(243,244,246)
            fnFrame.Position = UDim2.new(0,0,(i-1)*0.12,0)

            local label = Instance.new("TextLabel", fnFrame)
            label.Text = "Function "..menuID..string.char(64+i)
            label.Size = UDim2.new(0.5,0,1,0)
            label.BackgroundTransparency = 1

            local toggle = Instance.new("TextButton", fnFrame)
            toggle.Size = UDim2.new(0,60,0,30)
            toggle.Position = UDim2.new(0.7,0,0.2,0)
            toggle.BackgroundColor3 = Color3.fromRGB(34,197,94)
            toggle.Text = "Open"
            toggle.TextColor3 = Color3.fromRGB(255,255,255)
            Instance.new("UICorner", toggle)

            toggle.MouseButton1Click:Connect(function()
                if toggle.Text == "Open" then
                    toggle.Text = "Close"
                    toggle.BackgroundColor3 = Color3.fromRGB(239,68,68)
                    -- ใส่โค้ด Script ทำงานตรงนี้
                else
                    toggle.Text = "Open"
                    toggle.BackgroundColor3 = Color3.fromRGB(34,197,94)
                    -- ปิด Script
                end
            end)
        end
    end)
end

createMenuButton("Menu 1",1)
createMenuButton("Menu 2",2)
createMenuButton("Menu 3",3)
createMenuButton("Menu 4",4)

-- Drag UI & MiniCircle
local function makeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    frame.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset+delta.X, startPos.Y.Scale, startPos.Y.Offset+delta.Y)
        end
    end)
    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

makeDraggable(UIContainer)
makeDraggable(MiniCircle)
