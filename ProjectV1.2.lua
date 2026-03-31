-- Title Bar (แถบข้างบน)
local TitleBar = Instance.new("Frame", UIContainer)
TitleBar.Size = UDim2.new(1,0,0,30)
TitleBar.Position = UDim2.new(0,0,0,0)
TitleBar.BackgroundColor3 = Color3.fromRGB(59,130,246)
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0,8)

local TitleLabel = Instance.new("TextLabel", TitleBar)
TitleLabel.Size = UDim2.new(1,-10,1,0)
TitleLabel.Position = UDim2.new(0,5,0,0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "NYX Panel"
TitleLabel.TextColor3 = Color3.fromRGB(255,255,255)
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Resize Handle (ขวาล่าง)
local ResizeHandle = Instance.new("Frame", UIContainer)
ResizeHandle.Size = UDim2.new(0,20,0,20)
ResizeHandle.Position = UDim2.new(1,-20,1,-20)
ResizeHandle.BackgroundColor3 = Color3.fromRGB(100,100,100)
ResizeHandle.ZIndex = 2
local handleCorner = Instance.new("UICorner", ResizeHandle)
handleCorner.CornerRadius = UDim.new(0.3,0)

-- Drag Resize
local draggingResize = false
local dragStartResize
local startSize
ResizeHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingResize = true
        dragStartResize = input.Position
        startSize = UIContainer.Size
    end
end)
ResizeHandle.InputChanged:Connect(function(input)
    if draggingResize and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStartResize
        local newX = math.clamp(startSize.X.Offset + delta.X, 300, 800)
        local newY = math.clamp(startSize.Y.Offset + delta.Y, 200, 600)
        UIContainer.Size = UDim2.new(0,newX,0,newY)
        MainArea.Size = UDim2.new(0.7,0,0.9,0) -- ปรับตาม MainArea เดิม
        Sidebar.Size = UDim2.new(0.25,0,1,0)
        ResizeHandle.Position = UDim2.new(1,-20,1,-20)
    end
end)
game:GetService("UserInputService").InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingResize = false
    end
end)
