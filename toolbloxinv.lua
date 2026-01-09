-- 🔥 SERVER-SIDE INVENTORY TOOL HACKER
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local HttpService = game:GetService("HttpService")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "InventoryHackerPro"
screenGui.Parent = game.CoreGui

-- الإطار الرئيسي
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0.9, 0, 0.85, 0)
mainFrame.Position = UDim2.new(0.05, 0, 0.075, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 10, 20)
mainFrame.BorderSizePixel = 3
mainFrame.BorderColor3 = Color3.fromRGB(180, 0, 180)
mainFrame.Parent = screenGui

-- سحب النافذة
local isDragging = false
local dragStart, frameStart

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = true
        dragStart = Vector2.new(input.Position.X, input.Position.Y)
        frameStart = Vector2.new(mainFrame.Position.X.Scale, mainFrame.Position.Y.Scale)
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if isDragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
        local currentPos = Vector2.new(input.Position.X, input.Position.Y)
        local delta = currentPos - dragStart
        local viewportSize = workspace.CurrentCamera.ViewportSize
        local deltaScale = Vector2.new(delta.X / viewportSize.X, delta.Y / viewportSize.Y)
        local newX = math.clamp(frameStart.X + deltaScale.X, 0, 0.1)
        local newY = math.clamp(frameStart.Y + deltaScale.Y, 0, 0.15)
        mainFrame.Position = UDim2.new(newX, 0, newY, 0)
    end
end)

game:GetService("UserInputService").InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = false
    end
end)

-- شريط العنوان
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0.08, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(150, 0, 150)
titleBar.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Text = "📦 INVENTORY TOOL HACKER PRO"
title.Size = UDim2.new(0.8, 0, 1, 0)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Parent = titleBar

-- زر الإغلاق
local closeBtn = Instance.new("TextButton")
closeBtn.Text = "✕"
closeBtn.Size = UDim2.new(0.1, 0, 1, 0)
closeBtn.Position = UDim2.new(0.9, 0, 0, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 150)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.Parent = titleBar

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- لوحة التحكم
local controlPanel = Instance.new("Frame")
controlPanel.Size = UDim2.new(0.98, 0, 0.15, 0)
controlPanel.Position = UDim2.new(0.01, 0, 0.09, 0)
controlPanel.BackgroundColor3 = Color3.fromRGB(30, 20, 40)
controlPanel.Parent = mainFrame

-- زر المسح
local scanBtn = Instance.new("TextButton")
scanBtn.Text = "🔍 SCAN ALL TOOLS"
scanBtn.Size = UDim2.new(0.48, 0, 0.8, 0)
scanBtn.Position = UDim2.new(0.01, 0, 0.1, 0)
scanBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
scanBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
scanBtn.Font = Enum.Font.SourceSansBold
scanBtn.TextSize = 16
scanBtn.Parent = controlPanel

-- زر السرقة للإنفنتوري
local stealToInventoryBtn = Instance.new("TextButton")
stealToInventoryBtn.Text = "📦 STEAL TO INVENTORY"
stealToInventoryBtn.Size = UDim2.new(0.48, 0, 0.8, 0)
stealToInventoryBtn.Position = UDim2.new(0.51, 0, 0.1, 0)
stealToInventoryBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 100)
stealToInventoryBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
stealToInventoryBtn.Font = Enum.Font.SourceSansBold
stealToInventoryBtn.TextSize = 16
stealToInventoryBtn.Parent = controlPanel

-- حالة النظام
local statusLabel = Instance.new("TextLabel")
statusLabel.Text = "🟢 جاهز - إصدار Inventory Hacker 2.0"
statusLabel.Size = UDim2.new(1, 0, 0.2, 0)
statusLabel.Position = UDim2.new(0, 0, 0.85, 0)
statusLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
statusLabel.BackgroundTransparency = 1
statusLabel.Font = Enum.Font.SourceSansBold
statusLabel.TextSize = 14
statusLabel.Parent = controlPanel

-- قائمة النتائج
local resultsFrame = Instance.new("ScrollingFrame")
resultsFrame.Size = UDim2.new(0.98, 0, 0.72, 0)
resultsFrame.Position = UDim2.new(0.01, 0, 0.25, 0)
resultsFrame.BackgroundColor3 = Color3.fromRGB(20, 15, 25)
resultsFrame.BorderSizePixel = 2
resultsFrame.BorderColor3 = Color3.fromRGB(100, 0, 100)
resultsFrame.Parent = mainFrame

-- === الوظائف الأساسية ===

-- دالة إيجاد زر الإنفنتوري
local function findInventoryButton()
    local player = Players.LocalPlayer
    if not player then return nil end
    
    -- البحث في PlayerGui
    local playerGui = player:FindFirstChild("PlayerGui")
    if playerGui then
        local main = playerGui:FindFirstChild("Main")
        if main then
            local inventoryBtn = main:FindFirstChild("InventoryButton")
            if inventoryBtn then
                return inventoryBtn
            end
        end
    end
    
    -- البحث في جميع الأماكن المحتملة
    local possiblePaths = {
        player.PlayerGui,
        player:WaitForChild("PlayerGui", 1),
        game:GetService("CoreGui"),
        game:GetService("StarterGui")
    }
    
    for _, location in pairs(possiblePaths) do
        if location then
            local inventoryBtn = location:FindFirstChild("InventoryButton", true)
            if inventoryBtn then
                return inventoryBtn
            end
        end
    end
    
    return nil
end

-- دالة فتح الإنفنتوري
local function openInventory()
    local inventoryBtn = findInventoryButton()
    if inventoryBtn then
        if inventoryBtn:IsA("TextButton") or inventoryBtn:IsA("ImageButton") then
            -- محاكاة الضغط على الزر
            pcall(function()
                inventoryBtn:FireEvent("MouseButton1Click")
                inventoryBtn:FireEvent("Activated")
                inventoryBtn:FireEvent("MouseButton1Down")
                inventoryBtn:FireEvent("MouseButton1Up")
            end)
            return true
        end
    end
    return false
end

-- دالة محاكاة حدث سيرفري
local function simulateServerEvent(eventName, ...)
    pcall(function()
        -- البحث عن RemoteEvent
        local remoteEvent = ReplicatedStorage:FindFirstChild(eventName)
        if not remoteEvent then
            remoteEvent = ServerStorage:FindFirstChild(eventName)
        end
        if not remoteEvent then
            remoteEvent = workspace:FindFirstChild(eventName)
        end
        
        if remoteEvent and (remoteEvent:IsA("RemoteEvent") or remoteEvent:IsA("RemoteFunction")) then
            if remoteEvent:IsA("RemoteEvent") then
                remoteEvent:FireServer(...)
            else
                remoteEvent:InvokeServer(...)
            end
            return true
        end
    end)
    return false
end

-- دالة إضافة Tool للإنفنتوري عبر السيرفر
local function addToolToInventoryServer(tool, player)
    if not tool or not player then return false end
    
    -- 1. أولاً: اختراق ملكية الـTool
    pcall(function()
        -- تغيير NetworkOwner
        for _, part in pairs(tool:GetDescendants()) do
            if part:IsA("BasePart") then
                part:SetNetworkOwner(player)
            end
        end
        
        -- إضافة علامة الملكية
        local ownershipTag = Instance.new("StringValue")
        ownershipTag.Name = "InventoryHacker_Owner"
        ownershipTag.Value = player.Name
        ownershipTag.Parent = tool
        
        -- تغيير CreatorId
        if tool:FindFirstChild("Creator") then
            tool.Creator.Value = player.Name
        end
        
        if tool:FindFirstChild("CreatorId") then
            tool.CreatorId.Value = player.UserId
        end
    end)
    
    -- 2. محاولة إضافة الـTool للإنفنتوري عبر السيرفر
    local success = false
    
    -- الطريقة 1: محاكاة أحداث سيرفرية
    success = simulateServerEvent("AddToolToInventory", tool.Name, player)
    
    if not success then
        -- الطريقة 2: استخدام RemoteFunctions شائعة
        local commonRemotes = {
            "InventoryAdd",
            "AddToInventory",
            "EquipTool",
            "PickupTool",
            "CollectItem",
            "GetTool"
        }
        
        for _, remoteName in pairs(commonRemotes) do
            if simulateServerEvent(remoteName, tool, player) then
                success = true
                break
            end
        end
    end
    
    -- الطريقة 3: حقن مباشر في بيانات اللاعب
    if not success then
        pcall(function()
            -- البحث عن بيانات إنفنتوري اللاعب
            local playerData = player:FindFirstChild("Data")
            if playerData then
                local inventory = playerData:FindFirstChild("Inventory")
                if not inventory then
                    inventory = Instance.new("Folder")
                    inventory.Name = "Inventory"
                    inventory.Parent = playerData
                end
                
                -- إضافة Tool كـStringValue
                local toolValue = Instance.new("StringValue")
                toolValue.Name = tool.Name .. "_" .. HttpService:GenerateGUID(false)
                toolValue.Value = tool:GetFullName()
                toolValue.Parent = inventory
                
                success = true
            end
        end)
    end
    
    -- الطريقة 4: إذا فشل كل شيء، نفتح الإنفنتوري ونضع الـTool في حقيبة اللاعب
    if not success then
        -- فتح الإنفنتوري أولاً
        openInventory()
        
        task.wait(0.5)
        
        -- وضع الـTool في Backpack
        local backpack = player:FindFirstChild("Backpack")
        if backpack then
            local clone = tool:Clone()
            
            -- إضافة بيانات إنفنتوري
            local invData = Instance.new("StringValue")
            invData.Name = "InventoryItem"
            invData.Value = "true"
            invData.Parent = clone
            
            clone.Parent = backpack
            success = true
            
            -- إشعار
            statusLabel.Text = "📦 وضعت " .. tool.Name .. " في حقيبتك"
            statusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
        end
    end
    
    return success
end

-- دالة المسح الشامل
local function deepScanAllTools()
    local allTools = {}
    
    -- 1. البحث في Workspace
    for _, item in pairs(workspace:GetDescendants()) do
        if item:IsA("Tool") then
            table.insert(allTools, {
                Object = item,
                Name = item.Name,
                Path = item:GetFullName(),
                Location = "Workspace",
                CanSteal = true
            })
        end
    end
    
    -- 2. البحث في اللاعبين الآخرين
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer then
            -- في الـCharacter
            if player.Character then
                for _, item in pairs(player.Character:GetDescendants()) do
                    if item:IsA("Tool") then
                        table.insert(allTools, {
                            Object = item,
                            Name = item.Name,
                            Path = item:GetFullName(),
                            Location = player.Name .. "'s Character",
                            CanSteal = true
                        })
                    end
                end
            end
            
            -- في الـBackpack
            if player.Backpack then
                for _, item in pairs(player.Backpack:GetDescendants()) do
                    if item:IsA("Tool") then
                        table.insert(allTools, {
                            Object = item,
                            Name = item.Name,
                            Path = item:GetFullName(),
                            Location = player.Name .. "'s Backpack",
                            CanSteal = true
                        })
                    end
                end
            end
        end
    end
    
    -- 3. البحث في ServerStorage
    pcall(function()
        for _, item in pairs(ServerStorage:GetDescendants()) do
            if item:IsA("Tool") then
                table.insert(allTools, {
                    Object = item,
                    Name = item.Name,
                    Path = item:GetFullName(),
                    Location = "ServerStorage",
                    CanSteal = true
                })
            end
        end
    end)
    
    return allTools
end

-- === الأحداث الرئيسية ===

-- زر المسح
scanBtn.MouseButton1Click:Connect(function()
    resultsFrame:ClearAllChildren()
    statusLabel.Text = "🔍 جاري البحث عن جميع الـTools..."
    statusLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
    
    local allTools = deepScanAllTools()
    local yOffset = 5
    
    if #allTools == 0 then
        local noTools = Instance.new("TextLabel")
        noTools.Text = "❌ لا توجد أدوات في السيرفر"
        noTools.Size = UDim2.new(0.9, 0, 0, 50)
        noTools.Position = UDim2.new(0.05, 0, 0, yOffset)
        noTools.TextColor3 = Color3.fromRGB(255, 100, 100)
        noTools.BackgroundTransparency = 1
        noTools.Font = Enum.Font.SourceSansBold
        noTools.Parent = resultsFrame
    else
        for i, toolData in ipairs(allTools) do
            local toolFrame = Instance.new("Frame")
            toolFrame.Size = UDim2.new(0.96, 0, 0, 80)
            toolFrame.Position = UDim2.new(0.02, 0, 0, yOffset)
            toolFrame.BackgroundColor3 = Color3.fromRGB(40, 30, 50)
            toolFrame.BorderSizePixel = 2
            toolFrame.BorderColor3 = Color3.fromRGB(100, 50, 150)
            toolFrame.Parent = resultsFrame
            
            -- اسم الـTool
            local nameLabel = Instance.new("TextLabel")
            nameLabel.Text = "🛠️ " .. toolData.Name
            nameLabel.Size = UDim2.new(0.7, 0, 0.3, 0)
            nameLabel.Position = UDim2.new(0.02, 0, 0.05, 0)
            nameLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
            nameLabel.Font = Enum.Font.SourceSansBold
            nameLabel.TextXAlignment = Enum.TextXAlignment.Left
            nameLabel.BackgroundTransparency = 1
            nameLabel.Parent = toolFrame
            
            -- الموقع
            local locationLabel = Instance.new("TextLabel")
            locationLabel.Text = "📍 " .. toolData.Location
            locationLabel.Size = UDim2.new(0.7, 0, 0.3, 0)
            locationLabel.Position = UDim2.new(0.02, 0, 0.35, 0)
            locationLabel.TextColor3 = Color3.fromRGB(150, 200, 255)
            locationLabel.Font = Enum.Font.SourceSans
            locationLabel.TextXAlignment = Enum.TextXAlignment.Left
            locationLabel.TextSize = 12
            locationLabel.BackgroundTransparency = 1
            locationLabel.Parent = toolFrame
            
            -- المسار
            local pathLabel = Instance.new("TextLabel")
            pathLabel.Text = "📁 " .. string.sub(toolData.Path, 1, 30) .. "..."
            pathLabel.Size = UDim2.new(0.7, 0, 0.3, 0)
            pathLabel.Position = UDim2.new(0.02, 0, 0.65, 0)
            pathLabel.TextColor3 = Color3.fromRGB(200, 150, 255)
            pathLabel.Font = Enum.Font.SourceSans
            pathLabel.TextXAlignment = Enum.TextXAlignment.Left
            pathLabel.TextSize = 10
            pathLabel.BackgroundTransparency = 1
            pathLabel.Parent = toolFrame
            
            -- زر السرقة للإنفنتوري
            local stealBtn = Instance.new("TextButton")
            stealBtn.Text = "📦 STEAL"
            stealBtn.Size = UDim2.new(0.25, 0, 0.7, 0)
            stealBtn.Position = UDim2.new(0.73, 0, 0.15, 0)
            stealBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 100)
            stealBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            stealBtn.Font = Enum.Font.SourceSansBold
            stealBtn.Parent = toolFrame
            
            -- زر النسخ
            local copyBtn = Instance.new("TextButton")
            copyBtn.Text = "📋"
            copyBtn.Size = UDim2.new(0.1, 0, 0.7, 0)
            copyBtn.Position = UDim2.new(0.88, 0, 0.15, 0)
            copyBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 200)
            copyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            copyBtn.Font = Enum.Font.SourceSansBold
            copyBtn.Parent = toolFrame
            
            -- حدث السرقة
            stealBtn.MouseButton1Click:Connect(function()
                statusLabel.Text = "⚡ جاري سرقة " .. toolData.Name .. " إلى الإنفنتوري..."
                statusLabel.TextColor3 = Color3.fromRGB(255, 100, 200)
                
                local player = Players.LocalPlayer
                local success = addToolToInventoryServer(toolData.Object, player)
                
                if success then
                    stealBtn.Text = "✅"
                    stealBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
                    statusLabel.Text = "📦 تمت سرقة " .. toolData.Name .. " إلى الإنفنتوري!"
                    statusLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
                    
                    -- تغيير لون الإطار
                    toolFrame.BackgroundColor3 = Color3.fromRGB(40, 60, 40)
                    toolFrame.BorderColor3 = Color3.fromRGB(0, 200, 100)
                else
                    stealBtn.Text = "❌"
                    stealBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
                    statusLabel.Text = "⚠️ فشلت سرقة " .. toolData.Name
                    statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
                end
                
                task.wait(1.5)
                if stealBtn.Text == "✅" or stealBtn.Text == "❌" then
                    stealBtn.Text = "📦 STEAL"
                    stealBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 100)
                end
            end)
            
            -- حدث النسخ
            copyBtn.MouseButton1Click:Connect(function()
                pcall(function()
                    setclipboard(toolData.Path)
                    copyBtn.Text = "✅"
                    statusLabel.Text = "📋 نسخت مسار: " .. toolData.Name
                    statusLabel.TextColor3 = Color3.fromRGB(150, 200, 255)
                    task.wait(0.8)
                    copyBtn.Text = "📋"
                end)
            end)
            
            yOffset = yOffset + 85
        end
        
        statusLabel.Text = "✅ تم العثور على " .. #allTools .. " أداة"
        statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    end
    
    resultsFrame.CanvasSize = UDim2.new(0, 0, 0, yOffset + 10)
end)

-- زر سرقة جميع الأدوات للإنفنتوري
stealToInventoryBtn.MouseButton1Click:Connect(function()
    statusLabel.Text = "📦 جاري سرقة جميع الأدوات إلى الإنفنتوري..."
    statusLabel.TextColor3 = Color3.fromRGB(255, 50, 200)
    
    local allTools = deepScanAllTools()
    local stolenCount = 0
    
    for _, toolData in pairs(allTools) do
        local player = Players.LocalPlayer
        if addToolToInventoryServer(toolData.Object, player) then
            stolenCount = stolenCount + 1
        end
        task.wait(0.1) -- لمنع التحميل الزائد
    end
    
    statusLabel.Text = "📦 تمت سرقة " .. stolenCount .. " أداة إلى الإنفنتوري!"
    statusLabel.TextColor3 = Color3.fromRGB(200, 0, 255)
    
    -- فتح الإنفنتوري تلقائياً
    task.wait(0.5)
    openInventory()
end)

-- زر إضافي: فتح الإنفنتوري
local openInvBtn = Instance.new("TextButton")
openInvBtn.Text = "🚪 OPEN INVENTORY"
openInvBtn.Size = UDim2.new(0.96, 0, 0.04, 0)
openInvBtn.Position = UDim2.new(0.02, 0, 0.98, 0)
openInvBtn.BackgroundColor3 = Color3.fromRGB(100, 0, 200)
openInvBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
openInvBtn.Font = Enum.Font.SourceSansBold
openInvBtn.Parent = mainFrame

openInvBtn.MouseButton1Click:Connect(function()
    if openInventory() then
        statusLabel.Text = "🚪 فتحت الإنفنتوري بنجاح"
        statusLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
    else
        statusLabel.Text = "⚠️ لم أستطع فتح الإنفنتوري"
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
end)

-- تحميل أولي
statusLabel.Text = "📦 Inventory Hacker Pro - جاهز للعمل"
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "INVENTORY HACKER LOADED",
    Text = "يمكنك الآن سرقة أي أداة إلى الإنفنتوري!",
    Duration = 5,
    Icon = "rbxassetid://4456171879"
})

-- معلومات النظام
local infoLabel = Instance.new("TextLabel")
infoLabel.Text = "🎯 الهدف: InventoryButton في PlayerGui/Main"
infoLabel.Size = UDim2.new(1, 0, 0.02, 0)
infoLabel.Position = UDim2.new(0, 0, 0.93, 0)
infoLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
infoLabel.BackgroundTransparency = 1
infoLabel.Font = Enum.Font.SourceSans
infoLabel.TextSize = 12
infoLabel.Parent = mainFrame
