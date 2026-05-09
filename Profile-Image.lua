local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local localPlayer = Players.LocalPlayer
local myUserIdStr = tostring(localPlayer.UserId)

if CoreGui:FindFirstChild("Add_Image") then CoreGui.ArgoHub_Mini:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Add_Image"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local NormalSize = UDim2.new(0, 230, 0, 105) 
local FullSize = UDim2.new(1, 0, 1, 0)
local NormalPos = UDim2.new(0.5, -115, 0.15, 0)

local MainFrame = Instance.new("Frame")
MainFrame.Size = NormalSize
MainFrame.Position = NormalPos
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BackgroundTransparency = 0.2
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 6)
MainCorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 100, 0, 20)
Title.Position = UDim2.new(1, -105, 0, 4)
Title.BackgroundTransparency = 1
Title.Text = "Add Image Avatar"
Title.TextColor3 = Color3.fromRGB(150, 150, 150)
Title.TextSize = 9
Title.Font = Enum.Font.Gotham
Title.TextXAlignment = Enum.TextXAlignment.Right
Title.Parent = MainFrame

local Divider = Instance.new("Frame")
Divider.Name = "Divider"
Divider.Parent = MainFrame
Divider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Divider.BackgroundTransparency = 0.85
Divider.BorderSizePixel = 0
Divider.Size = UDim2.new(0.88, 0, 0, 1)
Divider.Position = UDim2.new(0.06, 0, 0, 28)

local function createDot(pos, color)
    local dot = Instance.new("TextButton")
    dot.Size = UDim2.new(0, 9, 0, 9)
    dot.Position = pos
    dot.BackgroundColor3 = color
    dot.Text = ""
    dot.Parent = MainFrame
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
    return dot
end

local CloseBtn = createDot(UDim2.new(0, 10, 0, 9), Color3.fromRGB(255, 95, 87))
local MinimizeBtn = createDot(UDim2.new(0, 25, 0, 9), Color3.fromRGB(245, 213, 135))
local MaximizeBtn = createDot(UDim2.new(0, 40, 0, 9), Color3.fromRGB(40, 200, 64))

local TextBox = Instance.new("TextBox")
TextBox.Size = UDim2.new(0.88, 0, 0.22, 0)
TextBox.Position = UDim2.new(0.06, 0, 0.38, 0)
TextBox.PlaceholderText = "paste your image link here..."
TextBox.Text = ""
TextBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextBox.BackgroundTransparency = 0.93
TextBox.TextColor3 = Color3.fromRGB(180, 180, 180)
TextBox.TextSize = 13
TextBox.Font = Enum.Font.Gotham
TextBox.Parent = MainFrame
Instance.new("UICorner", TextBox).CornerRadius = UDim.new(0, 4)

local AddBtn = Instance.new("TextButton")
AddBtn.Size = UDim2.new(0.42, 0, 0.22, 0)
AddBtn.Position = UDim2.new(0.06, 0, 0.68, 0)
AddBtn.Text = "ADD"
AddBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
AddBtn.BackgroundTransparency = 0.6
AddBtn.TextColor3 = Color3.fromRGB(160, 160, 160)
AddBtn.TextSize = 12
AddBtn.Font = Enum.Font.Gotham
AddBtn.Parent = MainFrame
Instance.new("UICorner", AddBtn).CornerRadius = UDim.new(0, 4)

local DestroyBtn = Instance.new("TextButton")
DestroyBtn.Size = UDim2.new(0.42, 0, 0.22, 0)
DestroyBtn.Position = UDim2.new(0.52, 0, 0.68, 0)
DestroyBtn.Text = "DESTROY"
DestroyBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
DestroyBtn.BackgroundTransparency = 0.6
DestroyBtn.TextColor3 = Color3.fromRGB(160, 160, 160)
DestroyBtn.TextSize = 12
DestroyBtn.Font = Enum.Font.Gotham
DestroyBtn.Parent = MainFrame
Instance.new("UICorner", DestroyBtn).CornerRadius = UDim.new(0, 4)

local currentAsset = nil

local function applyToImage(v)
    if v:IsA("ImageLabel") and currentAsset then
        if string.find(tostring(v.Image), myUserIdStr) then
            v.Image = currentAsset
        end
    end
end

local function hookImage(v)
    if v:IsA("ImageLabel") then
        applyToImage(v)
        v:GetPropertyChangedSignal("Image"):Connect(function()
            applyToImage(v)
        end)
    end
end

game.DescendantAdded:Connect(hookImage)

local function toggleMenu()
    MainFrame.Visible = not MainFrame.Visible
    if not MainFrame.Visible then
        StarterGui:SetCore("SendNotification", {
            Title = "Image_Add",
            Text = "Press Right ctrl to hide/show menu",
            Duration = 3
        })
    end
end

AddBtn.MouseButton1Click:Connect(function()
    local url = TextBox.Text
    if url ~= "" then
        AddBtn.Text = "..."
        local success, content = pcall(function() return game:HttpGet(url) end)
        if success then
            local randomId = math.random(1000, 9999)
            local tempFile = "argo_" .. randomId .. ".png"
            writefile(tempFile, content)
            currentAsset = getcustomasset(tempFile)
            
            for _, v in pairs(game:GetDescendants()) do
                pcall(applyToImage, v)
                if v:IsA("ImageLabel") then
                    pcall(function()
                        v:GetPropertyChangedSignal("Image"):Connect(function() applyToImage(v) end)
                    end)
                end
            end
            AddBtn.Text = "DONE"
            task.wait(0.6)
            AddBtn.Text = "ADD"
        else
            AddBtn.Text = "ERROR!"
            task.wait(0.6)
            AddBtn.Text = "ADD"
        end
    end
end)

DestroyBtn.MouseButton1Click:Connect(function()
    currentAsset = nil
    TextBox.Text = ""
    DestroyBtn.Text = "CLEARED"
    task.wait(0.6)
    DestroyBtn.Text = "DESTROY"
end)

UserInputService.InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == Enum.KeyCode.RightControl then
        toggleMenu()
    end
end)

CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
MinimizeBtn.MouseButton1Click:Connect(toggleMenu)

local isFull = false
MaximizeBtn.MouseButton1Click:Connect(function()
    isFull = not isFull
    if isFull then
        MainFrame:TweenSizeAndPosition(FullSize, UDim2.new(0,0,0,0), "Out", "Quad", 0.3, true)
        Divider.Visible = false
        Title.Visible = false
    else
        MainFrame:TweenSizeAndPosition(NormalSize, NormalPos, "Out", "Quad", 0.3, true)
        Divider.Visible = true
        Title.Visible = true
    end
end)

for _, v in pairs(game:GetDescendants()) do
    pcall(hookImage, v)
end
