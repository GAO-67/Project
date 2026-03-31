-- NYX Panel Delta Optimized Full Version
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NYX_DeltaUI"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- UI Container
local UIContainer = Instance.new("Frame")
UIContainer.Name = "UIContainer"
UIContainer.Size = UDim2.new(0.25,0,0.25,0)
UIContainer.Position = UDim2.new(0.5,0,0.5,0)
UIContainer.AnchorPoint = Vector2.new(0.5,0.5)
UIContainer.BackgroundColor3 = Color3.fromRGB(30,30,30)
UIContainer.ClipsDescendants = true
Instance.new("UICorner", UIContainer).CornerRadius = UDim.new(0,8)
UIContainer.Parent = ScreenGui

-- Title Bar
local TitleBar = Instance.new("Frame", UIContainer)
TitleBar.Size = UDim2.new(1,0,0,30)
TitleBar.BackgroundColor3 = Color3.fromRGB(180,0,0)
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0,8)

local TitleLabel = Instance.new("TextLabel", TitleBar)
TitleLabel.Size = UDim2.new(1,-10,1,0)
TitleLabel.Position = UDim2.new(0,5,0,0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "NYX Panel"
TitleLabel.TextColor3 = Color3.fromRGB(255,255,255)
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Sidebar
local Sidebar = Instance.new("Frame", UIContainer)
Sidebar.Size = UDim2.new(0.25,0,1,0)
Sidebar.BackgroundColor3 = Color3.fromRGB(100,0,0)
local SidebarList = Instance.new("UIListLayout", Sidebar)
SidebarList.Padding = UDim.new(0,10)
SidebarList.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Main Area
local MainArea = Instance.new("ScrollingFrame", UIContainer)
MainArea.Size = UDim2.new(0.72,0,0.85,0)
MainArea.Position = UDim2.new(0.26,0,0.08,0)
MainArea.BackgroundColor3 = Color3.fromRGB(60,0,0)
MainArea.ScrollBarThickness = 6
Instance.new("UICorner", MainArea)
MainArea.CanvasSize = UDim2.new(0,0,0,0)

-- Close Button
local CloseBtn = Instance.new("TextButton", UIContainer)
CloseBtn.Size = UDim2.new(0,25,0,25)
CloseBtn.Position = UDim2.new(0.95,0,0.02,0)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255,50,50)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1,0)

-- MiniCircle
local MiniCircle = Instance.new("ImageButton", ScreenGui)
MiniCircle.Size = UDim2.new(0,50,0,50)
MiniCircle.Position = UDim2.new(0.9,0,0.9,0)
MiniCircle.BackgroundColor3 = Color3.fromRGB(0,0,0)
MiniCircle.Visible = false
local CircleCorner = Instance.new("UICorner", MiniCircle)
CircleCorner.CornerRadius = UDim.new(1,0)

CloseBtn.MouseButton1Click:Connect(function()
    UIContainer.Visible = false
    MiniCircle.Visible = true
end)
MiniCircle.MouseButton1Click:Connect(function()
    UIContainer.Visible = true
    MiniCircle.Visible = false
end)

-- Function: Create Sidebar Menu + Functions
local function createMenuButton(name, menuID)
    local btn = Instance.new("TextButton", Sidebar)
    btn.Size = UDim2.new(0.9,0,0,40)
    btn.BackgroundColor3 = Color3.fromRGB(200,0,0)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    Instance.new("UICorner", btn)

    btn.MouseButton1Click:Connect(function()
        -- Clear previous
        for _,v in pairs(MainArea:GetChildren()) do
            if v:IsA("Frame") then v:Destroy() end
        end

        -- Add 4 function buttons
        local totalHeight = 0
        for i = 1,4 do
            local fnFrame = Instance.new("Frame", MainArea)
            fnFrame.Size = UDim2.new(0.95,0,0,45)
            fnFrame.Position = UDim2.new(0,0,totalHeight,0)
            fnFrame.BackgroundColor3 = Color3.fromRGB(80,0,0)
            totalHeight = totalHeight + 50

            local label = Instance.new("TextLabel", fnFrame)
            label.Text = "Function "..menuID..string.char(64+i)
            label.Size = UDim2.new(0.5,0,1,0)
            label.BackgroundTransparency = 1
            label.TextColor3 = Color3.fromRGB(255,255,255)

            local toggle = Instance.new("TextButton", fnFrame)
            toggle.Size = UDim2.new(0,60,0,30)
            toggle.Position = UDim2.new(0.7,0,0.2,0)
            toggle.BackgroundColor3 = Color3.fromRGB(255,100,100)
            toggle.Text = "Open"
            toggle.TextColor3 = Color3.fromRGB(255,255,255)
            Instance.new("UICorner", toggle)

            toggle.MouseButton1Click:Connect(function()
                if toggle.Text == "Open" then
                    toggle.Text = "Close"
                    toggle.BackgroundColor3 = Color3.fromRGB(255,0,0)
                else
                    toggle.Text = "Open"
                    toggle.BackgroundColor3 = Color3.fromRGB(255,100,100)
                end
            end)
        end
        MainArea.CanvasSize = UDim2.new(0,0,0,totalHeight)
    end)
end

for i=1,4 do
    createMenuButton("Menu "..i, i)
end

-- Drag & Resize (Delta Optimized)
local dragging, dragStart, startPos
local resizing, resizeStart, startSize
local minSize = Vector2.new(200,150)
local maxSize = Vector2.new(800,600)

-- Drag
UIContainer.InputBegan:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = UIContainer.Position
    end
end)
UIContainer.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        UIContainer.Position = UDim2.new(
            0.5, math.clamp(startPos.X.Offset + delta.X,0,workspace.CurrentCamera.ViewportSize.X - UIContainer.Size.X.Offset),
            0.5, math.clamp(startPos.Y.Offset + delta.Y,0,workspace.CurrentCamera.ViewportSize.Y - UIContainer.Size.Y.Offset)
        )
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- Resize Handle (Right-Bottom Corner)
local resizeHandle = Instance.new("Frame", UIContainer)
resizeHandle.Size = UDim2.new(0,20,0,20)
resizeHandle.Position = UDim2.new(1,-20,1,-20)
resizeHandle.AnchorPoint = Vector2.new(0,0)
resizeHandle.BackgroundColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner", resizeHandle).CornerRadius = UDim.new(0,4)

resizeHandle.InputBegan:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
        resizing = true
        resizeStart = input.Position
        startSize = UIContainer.Size
    end
end)
resizeHandle.InputChanged:Connect(function(input)
    if resizing and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
        local delta = input.Position - resizeStart
        local newWidth = math.clamp(startSize.X.Offset + delta.X, minSize.X, maxSize.X)
        local newHeight = math.clamp(startSize.Y.Offset + delta.Y, minSize.Y, maxSize.Y)
        UIContainer.Size = UDim2.new(0,newWidth,0,newHeight)
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
        resizing = false
    end
end)
