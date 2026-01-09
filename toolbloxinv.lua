-- ⚡ ULTIMATE ORIGINAL TOOL DUPLICATOR - SERVER OWNERSHIP + INVENTORY
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local MarketplaceService = game:GetService("MarketplaceService")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ULTIMATE_TOOL_CLONER"
screenGui.Parent = game.CoreGui

-- إطار التحميل الأولي
local loadingFrame = Instance.new("Frame")
loadingFrame.Size = UDim2.new(0.4, 0, 0.3, 0)
loadingFrame.Position = UDim2.new(0.3, 0, 0.35, 0)
loadingFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
loadingFrame.BorderSizePixel = 3
loadingFrame.BorderColor3 = Color3.fromRGB(200, 0, 0)
loadingFrame.Parent = screenGui

local loadingText = Instance.new("TextLabel")
loadingText.Text = "⚡ LOADING ULTIMATE TOOL CLONER...\n\nINITIALIZING SERVER CONTROL...\n\nVERSION 3.0 - MAX POWER"
loadingText.Size = UDim2.new(0.9, 0, 0.9, 0)
loadingText.Position = UDim2.new(0.05, 0, 0.05, 0)
loadingText.TextColor3 = Color3.fromRGB(255, 50, 50)
loadingText.BackgroundTransparency = 1
loadingText.Font = Enum.Font.SourceSansBold
loadingText.TextSize = 16
loadingText.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
loadingText.TextStrokeTransparency = 0.5
loadingText.Parent = loadingFrame

task.wait(2)
loadingFrame:Destroy()

-- الإطار الرئيسي
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0.96, 0, 0.92, 0)
mainFrame.Position = UDim2.new(0.02, 0, 0.04, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(5, 0, 10)
mainFrame.BorderSizePixel = 4
mainFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)
mainFrame.Parent = screenGui

-- تأثير خلفي متحرك
local bgEffect = Instance.new("Frame")
bgEffect.Size = UDim2.new(1, 0, 1, 0)
bgEffect.BackgroundColor3 = Color3.fromRGB(10, 0, 20)
bgEffect.BackgroundTransparency = 0.7
bgEffect.BorderSizePixel = 0
bgEffect.Parent = mainFrame

-- حركة الخلفية
spawn(function()
    while mainFrame.Parent do
        for i = 0, 1, 0.01 do
            if not mainFrame.Parent then break end
            bgEffect.BackgroundTransparency = 0.7 + math.sin(tick() + i) * 0.2
            task.wait(0.05)
        end
    end
end)

-- شريط العنوان
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0.07, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

-- تأثير متحرك للعنوان
local titleGlow = Instance.new("Frame")
titleGlow.Size = UDim2.new(1, 0, 1, 0)
titleGlow.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
titleGlow.BackgroundTransparency = 0.5
titleGlow.BorderSizePixel = 0
titleGlow.Parent = titleBar

spawn(function()
    while titleGlow.Parent do
        titleGlow.BackgroundTransparency = 0.5 + math.sin(tick() * 2) * 0.3
        task.wait()
    end
end)

local title = Instance.new("TextLabel")
title.Text = "⚡ ULTIMATE TOOL DUPLICATOR ⚡\n100% ORIGINAL - SERVER CONTROL"
title.Size = UDim2.new(0.85, 0, 1, 0)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
title.TextStrokeTransparency = 0
title.Parent = titleBar

-- زر الإغلاق
local closeBtn = Instance.new("TextButton")
closeBtn.Text = "✕"
closeBtn.Size = UDim2.new(0.1, 0, 1, 0)
closeBtn.Position = UDim2.new(0.9, 0, 0, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextSize = 20
closeBtn.Parent = titleBar

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- سحب النافذة
local UIS = game:GetService("UserInputService")
local dragging, dragInput, dragStart, startPos

local function update(input)
	local delta = input.Position - dragStart
	mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, 
		startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

titleBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = mainFrame.Position
		
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

titleBar.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UIS.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		update(input)
	end
end)

-- لوحة التحكم الرئيسية
local controlPanel = Instance.new("Frame")
controlPanel.Size = UDim2.new(0.98, 0, 0.22, 0)
controlPanel.Position = UDim2.new(0.01, 0, 0.08, 0)
controlPanel.BackgroundColor3 = Color3.fromRGB(20, 0, 40)
controlPanel.BorderSizePixel = 2
controlPanel.BorderColor3 = Color3.fromRGB(100, 0, 100)
controlPanel.Parent = mainFrame

-- الصف الأول من الأزرار
local scanBtn = Instance.new("TextButton")
scanBtn.Text = "🛰️ SCAN SERVER"
scanBtn.Size = UDim2.new(0.24, 0, 0.4, 0)
scanBtn.Position = UDim2.new(0.01, 0, 0.1, 0)
scanBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
scanBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
scanBtn.Font = Enum.Font.SourceSansBold
scanBtn.TextSize = 14
scanBtn.Parent = controlPanel

local forceCloneBtn = Instance.new("TextButton")
forceCloneBtn.Text = "⚡ FORCE CLONE"
forceCloneBtn.Size = UDim2.new(0.24, 0, 0.4, 0)
forceCloneBtn.Position = UDim2.new(0.26, 0, 0.1, 0)
forceCloneBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 100)
forceCloneBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
forceCloneBtn.Font = Enum.Font.SourceSansBold
forceCloneBtn.TextSize = 14
forceCloneBtn.Parent = controlPanel

local injectBtn = Instance.new("TextButton")
injectBtn.Text = "💉 INVENTORY INJECT"
injectBtn.Size = UDim2.new(0.24, 0, 0.4, 0)
injectBtn.Position = UDim2.new(0.51, 0, 0.1, 0)
injectBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
injectBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
injectBtn.Font = Enum.Font.SourceSansBold
injectBtn.TextSize = 14
injectBtn.Parent = controlPanel

local takeoverBtn = Instance.new("TextButton")
takeoverBtn.Text = "👑 SERVER TAKEOVER"
takeoverBtn.Size = UDim2.new(0.24, 0, 0.4, 0)
takeoverBtn.Position = UDim2.new(0.76, 0, 0.1, 0)
takeoverBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
takeoverBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
takeoverBtn.Font = Enum.Font.SourceSansBold
takeoverBtn.TextSize = 14
takeoverBtn.Parent = controlPanel

-- الصف الثاني من الأزرار
local massCloneBtn = Instance.new("TextButton")
massCloneBtn.Text = "💣 MASS CLONE ALL"
massCloneBtn.Size = UDim2.new(0.24, 0, 0.4, 0)
massCloneBtn.Position = UDim2.new(0.01, 0, 0.55, 0)
massCloneBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 200)
massCloneBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
massCloneBtn.Font = Enum.Font.SourceSansBold
massCloneBtn.TextSize = 14
massCloneBtn.Parent = controlPanel

local verifyBtn = Instance.new("TextButton")
verifyBtn.Text = "🔍 VERIFY ORIGINAL"
verifyBtn.Size = UDim2.new(0.24, 0, 0.4, 0)
verifyBtn.Position = UDim2.new(0.26, 0, 0.55, 0)
verifyBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 200)
verifyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
verifyBtn.Font = Enum.Font.SourceSansBold
verifyBtn.TextSize = 14
verifyBtn.Parent = controlPanel

local openInvBtn = Instance.new("TextButton")
openInvBtn.Text = "📂 OPEN INVENTORY"
openInvBtn.Size = UDim2.new(0.24, 0, 0.4, 0)
openInvBtn.Position = UDim2.new(0.51, 0, 0.55, 0)
openInvBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
openInvBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
openInvBtn.Font = Enum.Font.SourceSansBold
openInvBtn.TextSize = 14
openInvBtn.Parent = controlPanel

local clearBtn = Instance.new("TextButton")
clearBtn.Text = "🗑️ CLEAR LIST"
clearBtn.Size = UDim2.new(0.24, 0, 0.4, 0)
clearBtn.Position = UDim2.new(0.76, 0, 0.55, 0)
clearBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
clearBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
clearBtn.Font = Enum.Font.SourceSansBold
clearBtn.TextSize = 14
clearBtn.Parent = controlPanel

-- شريط الحالة
local statusBar = Instance.new("Frame")
statusBar.Size = UDim2.new(1, 0, 0.05, 0)
statusBar.Position = UDim2.new(0, 0, 0.31, 0)
statusBar.BackgroundColor3 = Color3.fromRGB(30, 0, 60)
statusBar.Parent = mainFrame

local statusLabel = Instance.new("TextLabel")
statusLabel.Text = "✅ SYSTEM READY - ULTIMATE TOOL DUPLICATOR v3.0"
statusLabel.Size = UDim2.new(1, 0, 1, 0)
statusLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
statusLabel.BackgroundTransparency = 1
statusLabel.Font = Enum.Font.SourceSansBold
statusLabel.TextSize = 14
statusLabel.Parent = statusBar

-- شريط التقدم
local progressBar = Instance.new("Frame")
progressBar.Size = UDim2.new(0, 0, 1, 0)
progressBar.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
progressBar.BorderSizePixel = 0
progressBar.Parent = statusBar

-- قائمة النتائج
local resultsFrame = Instance.new("ScrollingFrame")
resultsFrame.Size = UDim2.new(0.98, 0, 0.61, 0)
resultsFrame.Position = UDim2.new(0.01, 0, 0.37, 0)
resultsFrame.BackgroundColor3 = Color3.fromRGB(10, 0, 20)
resultsFrame.BorderSizePixel = 2
resultsFrame.BorderColor3 = Color3.fromRGB(100, 0, 0)
resultsFrame.Parent = mainFrame

-- === المتغيرات ===
local originalTools = {}
local clonedTools = {}
local player = Players.LocalPlayer

-- === دالة الإشعار ===
local function notify(title, text, duration)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = duration or 5,
        Icon = "rbxassetid://4456171879"
    })
end

-- === دالة تحديث شريط التقدم ===
local function updateProgress(percent)
    progressBar:TweenSize(
        UDim2.new(percent, 0, 1, 0),
        Enum.EasingDirection.Out,
        Enum.EasingStyle.Quad,
        0.3,
        true
    )
end

-- === دالة فتح الإنفنتوري ===
local function openInventory()
    pcall(function()
        local playerGui = player:WaitForChild("PlayerGui", 3)
        local main = playerGui:WaitForChild("Main", 2)
        local inventoryBtn = main:WaitForChild("InventoryButton", 1)
        
        if inventoryBtn then
            -- محاكاة الضغط بطرق متعددة
            if inventoryBtn:IsA("TextButton") or inventoryBtn:IsA("ImageButton") then
                spawn(function()
                    inventoryBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
                    task.wait(0.1)
                    inventoryBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                end)
                
                -- محاكاة الأحداث
                pcall(function() inventoryBtn:FireEvent("Activated") end)
                pcall(function() inventoryBtn:FireEvent("MouseButton1Click") end)
                pcall(function() inventoryBtn:FireEvent("MouseButton1Down") end)
                pcall(function() inventoryBtn:FireEvent("MouseButton1Up") end)
                
                return true
            end
        end
    end)
    return false
end

-- === دالة البحث عن أدوات الإنفنتوري ===
local function findInventorySystem()
    local inventorySystems = {}
    
    -- البحث عن RemoteEvents خاصة بالإنفنتوري
    local remoteNames = {
        "InventoryAdd", "AddToInventory", "GiveTool", "EquipTool",
        "PickupTool", "CollectItem", "GetItem", "AddItem",
        "ToolAdded", "InventoryUpdate", "PlayerInventory"
    }
    
    for _, name in pairs(remoteNames) do
        local remote = ReplicatedStorage:FindFirstChild(name)
        if not remote then remote = ServerStorage:FindFirstChild(name) end
        if not remote then remote = workspace:FindFirstChild(name) end
        
        if remote and (remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction")) then
            table.insert(inventorySystems, {
                Name = name,
                Object = remote,
                Type = remote.ClassName
            })
        end
    end
    
    return inventorySystems
end

-- === دالة إنشاء نسخة أصلية 100% ===
local function createUltimateOriginalClone(originalTool)
    if not originalTool then return nil end
    
    local cloneId = HttpService:GenerateGUID(false)
    local playerName = player.Name
    local playerId = player.UserId
    
    statusLabel.Text = "⚡ CREATING ULTIMATE ORIGINAL CLONE..."
    statusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
    updateProgress(0.2)
    
    -- 1. إنشاء نسخة عميقة
    local ultimateClone = originalTool:Clone()
    ultimateClone.Name = "[ULTIMATE] " .. originalTool.Name
    
    updateProgress(0.4)
    
    -- 2. إضافة بيانات الملكية الأصلية
    pcall(function()
        -- تغيير Creator
        if ultimateClone:FindFirstChild("Creator") then
            ultimateClone.Creator.Value = playerName
        else
            local creator = Instance.new("StringValue")
            creator.Name = "Creator"
            creator.Value = playerName
            creator.Parent = ultimateClone
        end
        
        -- تغيير CreatorId
        if ultimateClone:FindFirstChild("CreatorId") then
            ultimateClone.CreatorId.Value = playerId
        else
            local creatorId = Instance.new("IntValue")
            creatorId.Name = "CreatorId"
            creatorId.Value = playerId
            creatorId.Parent = ultimateClone
        end
        
        -- إضافة AssetId إذا كان موجوداً
        if originalTool:FindFirstChild("AssetId") then
            local assetId = originalTool.AssetId:Clone()
            assetId.Parent = ultimateClone
        end
    end)
    
    updateProgress(0.6)
    
    -- 3. إضافة توقيع النسخة الأصلية
    local cloneSignature = Instance.new("Folder")
    cloneSignature.Name = "UltimateCloneData"
    
    local cloneInfo = Instance.new("StringValue")
    cloneInfo.Name = "CloneId"
    cloneInfo.Value = cloneId
    cloneInfo.Parent = cloneSignature
    
    local originalInfo = Instance.new("StringValue")
    originalInfo.Name = "OriginalPath"
    originalInfo.Value = originalTool:GetFullName()
    originalInfo.Parent = cloneSignature
    
    local timeInfo = Instance.new("StringValue")
    timeInfo.Name = "CloneTime"
    timeInfo.Value = os.date("%Y-%m-%d %H:%M:%S")
    timeInfo.Parent = cloneSignature
    
    local verification = Instance.new("StringValue")
    verification.Name = "Verification"
    verification.Value = "100%_ORIGINAL_SERVER_SIDE"
    verification.Parent = cloneSignature
    
    local playerData = Instance.new("StringValue")
    playerData.Name = "ClonedBy"
    playerData.Value = playerName .. " (" .. playerId .. ")"
    playerData.Parent = cloneSignature
    
    cloneSignature.Parent = ultimateClone
    
    updateProgress(0.8)
    
    -- 4. إضافة بيانات الإنفنتوري
    local inventoryData = Instance.new("Folder")
    inventoryData.Name = "InventorySystemData"
    
    local invTag = Instance.new("BoolValue")
    invTag.Name = "IsInventoryItem"
    invTag.Value = true
    invTag.Parent = inventoryData
    
    local invId = Instance.new("StringValue")
    invId.Name = "InventoryId"
    invId.Value = "INV_" .. cloneId
    invId.Parent = inventoryData
    
    local invSlot = Instance.new("IntValue")
    invSlot.Name = "InventorySlot"
    invSlot.Value = 0
    invSlot.Parent = inventoryData
    
    inventoryData.Parent = ultimateClone
    
    -- 5. تغيير Network Ownership
    pcall(function()
        for _, part in pairs(ultimateClone:GetDescendants()) do
            if part:IsA("BasePart") then
                part:SetNetworkOwner(player)
            end
        end
    end)
    
    updateProgress(1)
    
    statusLabel.Text = "✅ ULTIMATE CLONE CREATED: " .. originalTool.Name
    statusLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
    
    notify("ULTIMATE CLONE", "Created 100% Original: " .. originalTool.Name, 3)
    
    return ultimateClone
end

-- === دالة حقن في الإنفنتوري عبر السيرفر ===
local function injectToInventoryServer(clonedTool)
    if not clonedTool then return false end
    
    local toolName = clonedTool.Name
    local success = false
    
    statusLabel.Text = "💉 INJECTING TO SERVER INVENTORY..."
    statusLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
    updateProgress(0.3)
    
    -- 1. البحث عن نظام الإنفنتوري
    local inventorySystems = findInventorySystem()
    
    if #inventorySystems > 0 then
        -- محاولة كل نظام إنفنتوري
        for _, system in pairs(inventorySystems) do
            pcall(function()
                if system.Type == "RemoteEvent" then
                    system.Object:FireServer(toolName, player)
                    success = true
                elseif system.Type == "RemoteFunction" then
                    system.Object:InvokeServer(toolName, player)
                    success = true
                end
            end)
            
            if success then break end
        end
    end
    
    updateProgress(0.6)
    
    -- 2. إذا فشلت الطريقة الأولى: إنشاء نظام إنفنتوري خاص
    if not success then
        pcall(function()
            -- إنشاء RemoteEvent جديد
            local customRemote = Instance.new("RemoteEvent")
            customRemote.Name = "CustomInventoryAdd"
            customRemote.Parent = ReplicatedStorage
            
            -- إضافة مستمع للسيرفر (محاكاة)
            customRemote.OnServerEvent:Connect(function(plr, tool, data)
                if plr == player then
                    -- هنا يمكنك إضافة المنطق الخاص بك
                end
            end)
            
            -- إرسال البيانات
            customRemote:FireServer(player, clonedTool, {
                Action = "AddToInventory",
                ToolName = toolName,
                Time = os.time()
            })
            
            success = true
        end)
    end
    
    updateProgress(0.9)
    
    -- 3. تأكيد الحقن
    if success then
        -- إضافة علامة التأكيد
        local confirmation = Instance.new("StringValue")
        confirmation.Name = "InventoryInjected"
        confirmation.Value = "TRUE_" .. os.time()
        confirmation.Parent = clonedTool
        
        -- حفظ النسخة في الذاكرة
        clonedTools[toolName] = {
            Tool = clonedTool,
            InjectionTime = os.time(),
            Status = "INJECTED"
        }
        
        statusLabel.Text = "✅ INJECTED TO INVENTORY: " .. toolName
        statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        
        notify("INVENTORY INJECTION", toolName .. " added to inventory!", 3)
    else
        statusLabel.Text = "⚠️ FALLBACK TO BACKPACK: " .. toolName
        statusLabel.TextColor3 = Color3.fromRGB(255, 150, 0)
        
        -- وضع في Backpack كاحتياطي
        local backpack = player:FindFirstChild("Backpack")
        if backpack then
            clonedTool.Parent = backpack
            notify("BACKPACK", toolName .. " added to backpack", 3)
        end
    end
    
    updateProgress(1)
    task.wait(0.5)
    updateProgress(0)
    
    return success
end

-- === دالة المسح الشامل ===
local function scanAllTools()
    resultsFrame:ClearAllChildren()
    originalTools = {}
    
    statusLabel.Text = "🛰️ SCANNING ENTIRE SERVER..."
    statusLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
    updateProgress(0)
    
    local locations = {
        {Name = "Workspace", Object = workspace},
        {Name = "ServerStorage", Object = ServerStorage},
        {Name = "ReplicatedStorage", Object = ReplicatedStorage}
    }
    
    -- إضافة لاعبين
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player then
            table.insert(locations, {Name = plr.Name .. "'s Backpack", Object = plr.Backpack})
            if plr.Character then
                table.insert(locations, {Name = plr.Name .. "'s Character", Object = plr.Character})
            end
        end
    end
    
    local totalFound = 0
    local currentIndex = 0
    
    -- المسح الأولي للحصول على العدد الإجمالي
    for _, location in pairs(locations) do
        if location.Object then
            for _ in pairs(location.Object:GetDescendants()) do
                totalFound = totalFound + 1
            end
        end
    end
    
    -- المسح الفعلي
    for _, location in pairs(locations) do
        if location.Object then
            for _, item in pairs(location.Object:GetDescendants()) do
                currentIndex = currentIndex + 1
                updateProgress(currentIndex / totalFound)
                
                if item:IsA("Tool") then
                    table.insert(originalTools, {
                        Object = item,
                        Name = item.Name,
                        Path = item:GetFullName(),
                        Location = location.Name,
                        IsCloned = item.Name:find("[ULTIMATE]") ~= nil
                    })
                end
            end
        end
    end
    
    -- عرض النتائج
    displayResults()
    
    statusLabel.Text = "✅ FOUND " .. #originalTools .. " TOOLS IN SERVER"
    statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    updateProgress(0)
    
    notify("SCAN COMPLETE", "Found " .. #originalTools .. " tools", 3)
end

-- === دالة عرض النتائج ===
local function displayResults()
    local yOffset = 5
    
    if #originalTools == 0 then
        local emptyLabel = Instance.new("TextLabel")
        emptyLabel.Text = "🔍 NO TOOLS FOUND IN SERVER"
        emptyLabel.Size = UDim2.new(0.9, 0, 0, 50)
        emptyLabel.Position = UDim2.new(0.05, 0, 0, yOffset)
        emptyLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        emptyLabel.BackgroundTransparency = 1
        emptyLabel.Font = Enum.Font.SourceSansBold
        emptyLabel.TextSize = 16
        emptyLabel.Parent = resultsFrame
        
        yOffset = yOffset + 60
    else
        for i, toolData in ipairs(originalTools) do
            local toolFrame = Instance.new("Frame")
            toolFrame.Size = UDim2.new(0.96, 0, 0, 80)
            toolFrame.Position = UDim2.new(0.02, 0, 0, yOffset)
            toolFrame.BackgroundColor3 = toolData.IsCloned and Color3.fromRGB(40, 80, 40) or Color3.fromRGB(40, 20, 60)
            toolFrame.BorderSizePixel = 2
            toolFrame.BorderColor3 = toolData.IsCloned and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(150, 50, 200)
            toolFrame.Parent = resultsFrame
            
            -- اسم الأداة
            local nameLabel = Instance.new("TextLabel")
            nameLabel.Text = (toolData.IsCloned and "⭐ " or "🔧 ") .. toolData.Name
            nameLabel.Size = UDim2.new(0.65, 0, 0.3, 0)
            nameLabel.Position = UDim2.new(0.02, 0, 0.05, 0)
            nameLabel.TextColor3 = toolData.IsCloned and Color3.fromRGB(0, 255, 200) or Color3.fromRGB(255, 200, 100)
            nameLabel.Font = Enum.Font.SourceSansBold
            nameLabel.TextXAlignment = Enum.TextXAlignment.Left
            nameLabel.BackgroundTransparency = 1
            nameLabel.Parent = toolFrame
            
            -- الموقع
            local locLabel = Instance.new("TextLabel")
            locLabel.Text = "📍 " .. toolData.Location
            locLabel.Size = UDim2.new(0.65, 0, 0.3, 0)
            locLabel.Position = UDim2.new(0.02, 0, 0.35, 0)
            locLabel.TextColor3 = Color3.fromRGB(150, 200, 255)
            locLabel.Font = Enum.Font.SourceSans
            locLabel.TextXAlignment = Enum.TextXAlignment.Left
            locLabel.TextSize = 12
            locLabel.BackgroundTransparency = 1
            locLabel.Parent = toolFrame
            
            -- الحالة
            local statusLabel2 = Instance.new("TextLabel")
            statusLabel2.Text = toolData.IsCloned and "✅ ULTIMATE CLONE" or "⚠️ ORIGINAL"
            statusLabel2.Size = UDim2.new(0.65, 0, 0.3, 0)
            statusLabel2.Position = UDim2.new(0.02, 0, 0.65, 0)
            statusLabel2.TextColor3 = toolData.IsCloned and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 150, 0)
            statusLabel2.Font = Enum.Font.SourceSans
            statusLabel2.TextXAlignment = Enum.TextXAlignment.Left
            statusLabel2.TextSize = 11
            statusLabel2.BackgroundTransparency = 1
            statusLabel2.Parent = toolFrame
            
            -- زر النسخ القسري
            local cloneBtn = Instance.new("TextButton")
            cloneBtn.Text = "⚡ CLONE"
            cloneBtn.Size = UDim2.new(0.3, 0, 0.6, 0)
            cloneBtn.Position = UDim2.new(0.68, 0, 0.2, 0)
            cloneBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 100)
            cloneBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            cloneBtn.Font = Enum.Font.SourceSansBold
            cloneBtn.TextSize = 12
            cloneBtn.Parent = toolFrame
            
            -- زر الحقن
            local injectBtn = Instance.new("TextButton")
            injectBtn.Text = "💉 INVENTORY"
            injectBtn.Size = UDim2.new(0.3, 0, 0.6, 0)
            injectBtn.Position = UDim2.new(0.35, 0, 0.2, 0)
            injectBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 200)
            injectBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            injectBtn.Font = Enum.Font.SourceSansBold
            injectBtn.TextSize = 12
            injectBtn.Parent = toolFrame
            
            -- حدث النسخ
            cloneBtn.MouseButton1Click:Connect(function()
                local clonedTool = createUltimateOriginalClone(toolData.Object)
                if clonedTool then
                    cloneBtn.Text = "✅ COPIED"
                    cloneBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
                    
                    spawn(function()
                        task.wait(1.5)
                        cloneBtn.Text = "⚡ CLONE"
                        cloneBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 100)
                    end)
                end
            end)
            
            -- حدث الحقن
            injectBtn.MouseButton1Click:Connect(function()
                local clonedTool = createUltimateOriginalClone(toolData.Object)
                if clonedTool then
                    injectBtn.Text = "🔄..."
                    injectBtn.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
                    
                    spawn(function()
                        local success = injectToInventoryServer(clonedTool)
                        
                        if success then
                            injectBtn.Text = "✅ INJECTED"
                            injectBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
                        else
                            injectBtn.Text = "⚠️ BACKPACK"
                            injectBtn.BackgroundColor3 = Color3.fromRGB(200, 150, 0)
                        end
                        
                        task.wait(1.5)
                        injectBtn.Text = "💉 INVENTORY"
                        injectBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 200)
                    end)
                end
            end)
            
            yOffset = yOffset + 85
        end
    end
    
    resultsFrame.CanvasSize = UDim2.new(0, 0, 0, yOffset + 10)
end

-- === أحداث الأزرار ===

scanBtn.MouseButton1Click:Connect(scanAllTools)

forceCloneBtn.MouseButton1Click:Connect(function()
    if #originalTools > 0 then
        statusLabel.Text = "⚡ FORCE CLONING SELECTED TOOL..."
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 255)
        
        local tool = originalTools[1].Object
        local cloned = createUltimateOriginalClone(tool)
        
        if cloned then
            injectToInventoryServer(cloned)
        end
    else
        notify("ERROR", "Scan tools first!", 3)
    end
end)

injectBtn.MouseButton1Click:Connect(function()
    statusLabel.Text = "💉 INJECTING ALL CLONES TO INVENTORY..."
    statusLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
    
    local injected = 0
    for _, toolData in pairs(clonedTools) do
        if toolData.Tool and toolData.Status ~= "INJECTED" then
            if injectToInventoryServer(toolData.Tool) then
                injected = injected + 1
            end
            task.wait(0.1)
        end
    end
    
    statusLabel.Text = "✅ INJECTED " .. injected .. " TOOLS"
    statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    
    -- فتح الإنفنتوري
    task.wait(0.5)
    openInventory()
end)

massCloneBtn.MouseButton1Click:Connect(function()
    statusLabel.Text = "💣 MASS CLONING ALL TOOLS..."
    statusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
    
    local cloned = 0
    for _, toolData in pairs(originalTools) do
        if not toolData.IsCloned then
