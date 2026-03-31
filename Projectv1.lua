local ScreenGui = Instance.new("ScreenGui")
local UIContainer = Instance.new("Frame")
local Sidebar = Instance.new("Frame")
local MainArea = Instance.new("ScrollingFrame")
local MiniCircle = Instance.new("ImageButton")
local UICorner = Instance.new("UICorner")

-- Setup ScreenGui
ScreenGui.Name = "NYX_CN_Panel"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

-- 1. Mini Circle (ปุ่มวงกลมตอนปิด UI)
MiniCircle.Name = "MiniCircle"
MiniCircle.Parent = ScreenGui
MiniCircle.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MiniCircle.Position = UDim2.new(0.9, 0, 0.9, 0)
MiniCircle.Size = UDim2.new(0, 50, 0, 50)
MiniCircle.Visible = false
MiniCircle.ZIndex = 50
local CircleCorner = Instance.new("UICorner", MiniCircle)
CircleCorner.CornerRadius = UDim.new(1, 0)

-- 2. UI Container (600x400 ตาม HTML)
UIContainer.Name = "UIContainer"
UIContainer.Parent = ScreenGui
UIContainer.BackgroundColor3 = Color3.fromRGB(219, 234, 254) -- blue-100
UIContainer.Position = UDim2.new(0.5, -300, 0.5, -200)
UIContainer.Size = UDim2.new(0, 600, 0, 400)
UIContainer.ClipsDescendants = true
Instance.new("UICorner", UIContainer).CornerRadius = UDim.new(0, 8)

-- 3. Sidebar (แถบเมนูด้านซ้าย)
Sidebar.Name = "Sidebar"
Sidebar.Parent = UIContainer
Sidebar.BackgroundColor3 = Color3.fromRGB(59, 130, 246) -- blue-500
Sidebar.Size = UDim2.new(0.25, 0, 1, 0)

local SidebarList = Instance.new("UIListLayout", Sidebar)
SidebarList.Padding = UDim.new(0, 10)
SidebarList.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- 4. Main Area (พื้นที่แสดงฟังก์ชัน)
MainArea.Name = "MainArea"
MainArea.Parent = UIContainer
MainArea.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MainArea.Position = UDim2.new(0.27, 0, 0.05, 0)
MainArea.Size = UDim2.new(0.7, 0, 0.9, 0)
MainArea.CanvasSize = UDim2.new(0, 0, 2, 0)
Instance.new("UICorner", MainArea)

-- 5. ระบบปุ่มเปิด-ปิด (เลียนแบบ JS)
local CloseBtn = Instance.new("TextButton", UIContainer)
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Position = UDim2.new(0.95, 0, 0.02, 0)
CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 38, 38)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1, 0)

CloseBtn.MouseButton1Click:Connect(function()
    UIContainer.Visible = false
    MiniCircle.Visible = true
end)

MiniCircle.MouseButton1Click:Connect(function()
    UIContainer.Visible = true
    MiniCircle.Visible = false
end)

-- 6. ฟังก์ชันสร้างปุ่มเมนู (Menu 1-4)
local function createMenuButton(name, menuID)
    local btn = Instance.new("TextButton", Sidebar)
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(0, 0, 0)
    Instance.new("UICorner", btn)
    
    btn.MouseButton1Click:Connect(function()
        -- ล้างหน้าจอเก่า
        for _, v in pairs(MainArea:GetChildren()) do
            if v:IsA("Frame") then v:Destroy() end
        end
        -- สร้างปุ่มจำลองฟังก์ชัน (Function A, B, C...)
        for i = 1, 4 do
            local fnFrame = Instance.new("Frame", MainArea)
            fnFrame.Size = UDim2.new(0.95, 0, 0, 45)
            fnFrame.BackgroundColor3 = Color3.fromRGB(243, 244, 246)
            
            local label = Instance.new("TextLabel", fnFrame)
            label.Text = "Function " .. menuID .. string.char(64+i)
            label.Size = UDim2.new(0.5, 0, 1, 0)
            label.BackgroundTransparency = 1
            
            local toggle = Instance.new("TextButton", fnFrame)
            toggle.Size = UDim2.new(0, 60, 0, 30)
            toggle.Position = UDim2.new(0.7, 0, 0.2, 0)
            toggle.BackgroundColor3 = Color3.fromRGB(34, 197, 94) -- green
            toggle.Text = "Open"
            toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
            Instance.new("UICorner", toggle)
        end
    end)
end

createMenuButton("Menu 1", 1)
createMenuButton("Menu 2", 2)
createMenuButton("Menu 3", 3)
createMenuButton("Menu 4", 4)

-- 7. ระบบลากจ่อ (Drag) สำหรับ Delta/Mobile
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
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
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

