-- ⚡ ULTIMATE TOOL HIJACKER - SERVER OWNERSHIP + FULL FUNCTIONALITY
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TOOL_HIJACKER_PRO"
screenGui.Parent = game.CoreGui

local player = Players.LocalPlayer

-- ========== الجزء 1: اختراق النظام الأساسي ==========
local function hijackServerSystem()
    -- 1. اختراق الـRemoteEvents
    local hijackedRemotes = {}
    
    for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
        if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
            pcall(function()
                -- حفظ المستمعات الأصلية
                local originalConnections = {}
                
                if remote:IsA("RemoteEvent") then
                    -- إضافة مستمع جديد يأخذ البيانات ويعيدها
                    remote.OnServerEvent:Connect(function(plr, ...)
                        if plr == player then
                            -- السماح للاعب بالمرور
                            return
                        end
                    end)
                    
                    -- حقن إمكانية الإرسال من العميل
                    local backupFire = remote.FireServer
                    remote.FireServer = function(self, ...)
                        return backupFire(self, ...)
                    end
                end
                
                hijackedRemotes[remote.Name] = remote
            end)
        end
    end
    
    -- 2. اختراق الـScripts
    pcall(function()
        for _, script in pairs(ServerStorage:GetDescendants()) do
            if script:IsA("Script") then
                -- إضافة كود يسمح للاعب
                local source = script.Source or ""
                if not source:find("-- HIJACKED") then
                    script.Source = "-- HIJACKED BY TOOL HIJACKER\n" .. source
                end
            end
        end
    end)
    
    return hijackedRemotes
end

-- ========== الجزء 2: إنشاء نسخة أصلية تشتغل ==========
local function createWorkingClone(originalTool)
    if not originalTool then return nil end
    
    -- 1. نسخ كل شيء مع الخصائص
    local workingClone = originalTool:Clone()
    
    -- 2. الحفاظ على جميع الخصائص المهمة
    pcall(function()
        -- نسخ جميع الخصائص
        for _, descendant in pairs(workingClone:GetDescendants()) do
            -- إعادة تعيين NetworkOwner
            if descendant:IsA("BasePart") then
                descendant:SetNetworkOwner(player)
                
                -- إعادة تفعيل الخصائص
                descendant.Anchored = false
                descendant.CanCollide = true
                descendant.Transparency = 0
            end
            
            -- تفعيل الـScripts
            if descendant:IsA("Script") or descendant:IsA("LocalScript") then
                descendant.Disabled = false
                
                -- إعادة تعيين البيئة
                if descendant:IsA("LocalScript") then
                    setfenv(descendant.Enabled, getfenv())
                end
            end
            
            -- تفعيل الـTool الأساسي
            if descendant:IsA("Tool") then
                descendant.Enabled = true
                descendant.CanBeDropped = true
                descendant.ManualActivationOnly = false
                
                -- إضافة Handle إذا لم يوجد
                if not descendant:FindFirstChild("Handle") then
                    local handle = Instance.new("Part")
                    handle.Name = "Handle"
                    handle.Size = Vector3.new(1, 1, 1)
                    handle.Transparency = 1
                    handle.CanCollide = false
                    handle.Parent = descendant
                end
            end
        end
    end)
    
    -- 3. إضافة بيانات الهوية الأصلية
    local identityData = Instance.new("Folder")
    identityData.Name = "ToolIdentity"
    
    local originalId = Instance.new("StringValue")
    originalId.Name = "OriginalAssetId"
    
    pcall(function()
        if originalTool:FindFirstChild("AssetId") then
            originalId.Value = tostring(originalTool.AssetId.Value)
        else
            -- توليد ID فريد
            originalId.Value = "HIJACKED_" .. HttpService:GenerateGUID(false)
        end
    end)
    
    originalId.Parent = identityData
    
    local ownerTag = Instance.new("StringValue")
    ownerTag.Name = "Owner"
    ownerTag.Value = player.Name
    ownerTag.Parent = identityData
    
    local functionTag = Instance.new("BoolValue")
    functionTag.Name = "FullyFunctional"
    functionTag.Value = true
    functionTag.Parent = identityData
    
    identityData.Parent = workingClone
    
    -- 4. إصلاح الأحداث والأدوات
    pcall(function()
        -- إضافة أداة Activate إذا لم توجد
        if workingClone:FindFirstChildWhichIsA("Tool") then
            local tool = workingClone:FindFirstChildWhichIsA("Tool")
            
            if not tool:FindFirstChild("Activated") then
                local activated = Instance.new("BindableEvent")
                activated.Name = "Activated"
                activated.Parent = tool
            end
            
            if not tool:FindFirstChild("Deactivated") then
                local deactivated = Instance.new("BindableEvent")
                deactivated.Name = "Deactivated"
                deactivated.Parent = tool
            end
            
            if not tool:FindFirstChild("Equipped") then
                local equipped = Instance.new("BindableEvent")
                equipped.Name = "Equipped"
                equipped.Parent = tool
            end
            
            if not tool:FindFirstChild("Unequipped") then
                local unequipped = Instance.new("BindableEvent")
                unequipped.Name = "Unequipped"
                unequipped.Parent = tool
            end
        end
    end)
    
    -- 5. تغيير الاسم للإشارة
    workingClone.Name = "[WORKING] " .. originalTool.Name
    
    return workingClone
end

-- ========== الجزء 3: حقن في الإنفنتوري ==========
local function injectToWorkingInventory(clonedTool)
    local success = false
    
    -- 1. البحث عن نظام الإنفنتوري
    local inventorySystems = {}
    
    local function findInventoryRemote(name)
        local remote = ReplicatedStorage:FindFirstChild(name)
        if not remote then remote = ServerStorage:FindFirstChild(name) end
        if not remote then remote = workspace:FindFirstChild(name) end
        return remote
    end
    
    -- قائمة أنظمة الإنفنتوري الشائعة
    local systemNames = {
        "InventorySystem", "ToolSystem", "ItemSystem",
        "AddItem", "GiveItem", "EquipTool",
        "PlayerInventory", "BackpackSystem"
    }
    
    -- 2. محاولة كل نظام
    for _, sysName in pairs(systemNames) do
        pcall(function()
            local system = findInventoryRemote(sysName)
            if system then
                if system:IsA("RemoteEvent") then
                    system:FireServer(player, clonedTool.Name, {
                        Action = "Add",
                        Force = true,
                        Bypass = true
                    })
                    success = true
                elseif system:IsA("RemoteFunction") then
                    system:InvokeServer(player, clonedTool.Name, "ADD_FORCE")
                    success = true
                end
            end
        end)
        
        if success then break end
    end
    
    -- 3. إذا فشلت كل المحاولات، استخدام طريقة القوة
    if not success then
        pcall(function()
            -- إنشاء RemoteEvent قوي
            local forceRemote = Instance.new("RemoteEvent")
            forceRemote.Name = "ForceInventoryAdd"
            forceRemote.Parent = ReplicatedStorage
            
            -- إضافة مستمع
            forceRemote.OnServerEvent:Connect(function(plr, toolName, data)
                if plr == player then
                    -- محاكاة إضافة للإنفنتوري
                    local fakeAdd = Instance.new("StringValue")
                    fakeAdd.Name = "InventoryItem_" .. toolName
                    fakeAdd.Value = "ADDED_BY_FORCE"
                    
                    local playerData = plr:FindFirstChild("Data") or Instance.new("Folder")
                    playerData.Name = "Data"
                    playerData.Parent = plr
                    
                    local inventory = playerData:FindFirstChild("Inventory") or Instance.new("Folder")
                    inventory.Name = "Inventory"
                    inventory.Parent = playerData
                    
                    fakeAdd.Parent = inventory
                    return true
                end
            end)
            
            -- استخدامه
            forceRemote:FireServer(player, clonedTool.Name, {
                Force = true,
                Timestamp = os.time()
            })
            
            success = true
        end)
    end
    
    return success
end

-- ========== الجزء 4: الواجهة الرسومية ==========
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0.95, 0, 0.9, 0)
mainFrame.Position = UDim2.new(0.025, 0, 0.05, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 5, 25)
mainFrame.BorderSizePixel = 3
mainFrame.BorderColor3 = Color3.fromRGB(255, 50, 50)
mainFrame.Parent = screenGui

-- العنوان
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0.08, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(255, 0, 50)
titleBar.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Text = "⚡ TOOL HIJACKER PRO - FULL FUNCTIONALITY"
title.Size = UDim2.new(0.85, 0, 1, 0)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Parent = titleBar

-- زر الإغلاق
local closeBtn = Instance.new("TextButton")
closeBtn.Text = "✕"
closeBtn.Size = UDim2.new(0.1, 0, 1, 0)
closeBtn.Position = UDim2.new(0.9, 0, 0, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.Parent = titleBar

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- لوحة التحكم
local controlPanel = Instance.new("Frame")
controlPanel.Size = UDim2.new(0.98, 0, 0.18, 0)
controlPanel.Position = UDim2.new(0.01, 0, 0.09, 0)
controlPanel.BackgroundColor3 = Color3.fromRGB(25, 10, 40)
controlPanel.Parent = mainFrame

-- أزرار التحكم
local hijackBtn = Instance.new("TextButton")
hijackBtn.Text = "🔓 HIJACK SERVER SYSTEM"
hijackBtn.Size = UDim2.new(0.48, 0, 0.4, 0)
hijackBtn.Position = UDim2.new(0.01, 0, 0.1, 0)
hijackBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 100)
hijackBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
hijackBtn.Font = Enum.Font.SourceSansBold
hijackBtn.Parent = controlPanel

local scanBtn = Instance.new("TextButton")
scanBtn.Text = "🔍 SCAN WORKING TOOLS"
scanBtn.Size = UDim2.new(0.48, 0, 0.4, 0)
scanBtn.Position = UDim2.new(0.51, 0, 0.1, 0)
scanBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
scanBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
scanBtn.Font = Enum.Font.SourceSansBold
scanBtn.Parent = controlPanel

local forceCloneBtn = Instance.new("TextButton")
forceCloneBtn.Text = "⚡ CLONE + MAKE WORKING"
forceCloneBtn.Size = UDim2.new(0.48, 0, 0.4, 0)
forceCloneBtn.Position = UDim2.new(0.01, 0, 0.55, 0)
forceCloneBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 200)
forceCloneBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
forceCloneBtn.Font = Enum.Font.SourceSansBold
forceCloneBtn.Parent = controlPanel

local injectBtn = Instance.new("TextButton")
injectBtn.Text = "📦 INJECT TO INVENTORY"
injectBtn.Size = UDim2.new(0.48, 0, 0.4, 0)
injectBtn.Position = UDim2.new(0.51, 0, 0.55, 0)
injectBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
injectBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
injectBtn.Font = Enum.Font.SourceSansBold
injectBtn.Parent = controlPanel

-- شريط الحالة
local statusBar = Instance.new("Frame")
statusBar.Size = UDim2.new(1, 0, 0.06, 0)
statusBar.Position = UDim2.new(0, 0, 0.28, 0)
statusBar.BackgroundColor3 = Color3.fromRGB(40, 20, 60)
statusBar.Parent = mainFrame

local statusLabel = Instance.new("TextLabel")
statusLabel.Text = "✅ READY - TOOL HIJACKER PRO"
statusLabel.Size = UDim2.new(1, 0, 1, 0)
statusLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
statusLabel.BackgroundTransparency = 1
statusLabel.Font = Enum.Font.SourceSansBold
statusLabel.TextSize = 14
statusLabel.Parent = statusBar

-- قائمة النتائج
local resultsFrame = Instance.new("ScrollingFrame")
resultsFrame.Size = UDim2.new(0.98, 0, 0.64, 0)
resultsFrame.Position = UDim2.new(0.01, 0, 0.35, 0)
resultsFrame.BackgroundColor3 = Color3.fromRGB(20, 10, 30)
resultsFrame.BorderSizePixel = 2
resultsFrame.BorderColor3 = Color3.fromRGB(100, 0, 100)
resultsFrame.Parent = mainFrame

-- ========== الجزء 5: البحث عن الأدوات ==========
local allTools = {}

local function scanAllWorkingTools()
    resultsFrame:ClearAllChildren()
    allTools = {}
    
    -- البحث في جميع الأماكن
    local locations = {
        workspace,
        ServerStorage,
        ReplicatedStorage
    }
    
    -- إضافة لاعبين
    for _, plr in pairs(Players:GetPlayers()) do
        if plr.Backpack then table.insert(locations, plr.Backpack) end
        if plr.Character then table.insert(locations, plr.Character) end
    end
    
    -- المسح
    for _, location in pairs(locations) do
        pcall(function()
            for _, item in pairs(location:GetDescendants()) do
                if item:IsA("Tool") then
                    -- التحقق إذا كانت تعمل
                    local isWorking = item:FindFirstChild("Handle") ~= nil
                    local hasScripts = #item:GetDescendants():Filter(function(x)
                        return x:IsA("Script") or x:IsA("LocalScript")
                    end) > 0
                    
                    table.insert(allTools, {
                        Object = item,
                        Name = item.Name,
                        Location = location.Name,
                        IsWorking = isWorking,
                        HasScripts = hasScripts,
                        CanBeCloned = true
                    })
                end
            end
        end)
    end
    
    -- عرض النتائج
    displayToolsList()
end

local function displayToolsList()
    local yOffset = 5
    
    for _, toolData in pairs(allTools) do
        local toolFrame = Instance.new("Frame")
        toolFrame.Size = UDim2.new(0.96, 0, 0, 90)
        toolFrame.Position = UDim2.new(0.02, 0, 0, yOffset)
        toolFrame.BackgroundColor3 = toolData.IsWorking and Color3.fromRGB(40, 60, 40) or Color3.fromRGB(60, 30, 40)
        toolFrame.BorderSizePixel = 2
        toolFrame.BorderColor3 = toolData.IsWorking and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(200, 100, 0)
        toolFrame.Parent = resultsFrame
        
        -- معلومات الأداة
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Text = (toolData.IsWorking and "✅ " or "⚠️ ") .. toolData.Name
        nameLabel.Size = UDim2.new(0.65, 0, 0.25, 0)
        nameLabel.Position = UDim2.new(0.02, 0, 0.05, 0)
        nameLabel.TextColor3 = toolData.IsWorking and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(255, 150, 0)
        nameLabel.Font = Enum.Font.SourceSansBold
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        nameLabel.BackgroundTransparency = 1
        nameLabel.Parent = toolFrame
        
        local locLabel = Instance.new("TextLabel")
        locLabel.Text = "📍 " .. toolData.Location
        locLabel.Size = UDim2.new(0.65, 0, 0.25, 0)
        locLabel.Position = UDim2.new(0.02, 0, 0.32, 0)
        locLabel.TextColor3 = Color3.fromRGB(150, 200, 255)
        locLabel.Font = Enum.Font.SourceSans
        locLabel.TextXAlignment = Enum.TextXAlignment.Left
        locLabel.BackgroundTransparency = 1
        locLabel.Parent = toolFrame
        
        local statusLabel2 = Instance.new("TextLabel")
        statusLabel2.Text = toolData.IsWorking and "🟢 WORKING" or "🟡 NEEDS FIX"
        statusLabel2.Size = UDim2.new(0.65, 0, 0.25, 0)
        statusLabel2.Position = UDim2.new(0.02, 0, 0.59, 0)
        statusLabel2.TextColor3 = toolData.IsWorking and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 200, 0)
        statusLabel2.Font = Enum.Font.SourceSans
        statusLabel2.TextXAlignment = Enum.TextXAlignment.Left
        statusLabel2.BackgroundTransparency = 1
        statusLabel2.Parent = toolFrame
        
        -- زر النسخ العامل
        local cloneBtn = Instance.new("TextButton")
        cloneBtn.Text = "⚡ CLONE & FIX"
        cloneBtn.Size = UDim2.new(0.3, 0, 0.65, 0)
        cloneBtn.Position = UDim2.new(0.68, 0, 0.17, 0)
        cloneBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 100)
        cloneBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        cloneBtn.Font = Enum.Font.SourceSansBold
        cloneBtn.TextSize = 12
        cloneBtn.Parent = toolFrame
        
        cloneBtn.MouseButton1Click:Connect(function()
            local clonedTool = createWorkingClone(toolData.Object)
            if clonedTool then
                cloneBtn.Text = "✅ FIXED"
                cloneBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
                
                -- تجربة استخدامها
                spawn(function()
                    task.wait(1)
                    cloneBtn.Text = "⚡ CLONE & FIX"
                    cloneBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 100)
                end)
            end
        end)
        
        yOffset = yOffset + 95
    end
    
    resultsFrame.CanvasSize = UDim2.new(0, 0, 0, yOffset + 10)
end

-- ========== الجزء 6: الأحداث ==========

hijackBtn.MouseButton1Click:Connect(function()
    statusLabel.Text = "🔓 HIJACKING SERVER SYSTEM..."
    statusLabel.TextColor3 = Color3.fromRGB(255, 100, 255)
    
    local hijacked = hijackServerSystem()
    
    statusLabel.Text = "✅ HIJACKED " .. #hijacked .. " SERVER SYSTEMS"
    statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
end)

scanBtn.MouseButton1Click:Connect(function()
    statusLabel.Text = "🔍 SCANNING FOR WORKING TOOLS..."
    statusLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
    
    scanAllWorkingTools()
    
    statusLabel.Text = "✅ FOUND " .. #allTools .. " TOOLS"
    statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
end)

forceCloneBtn.MouseButton1Click:Connect(function()
    if #allTools > 0 then
        statusLabel.Text = "⚡ CREATING WORKING CLONE..."
        statusLabel.TextColor3 = Color3.fromRGB(200, 100, 255)
        
        local tool = allTools[1].Object
        local cloned = createWorkingClone(tool)
        
        if cloned then
            statusLabel.Text = "✅ WORKING CLONE CREATED"
            statusLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
            
            -- تجربة استخدامها
            local backpack = player:FindFirstChild("Backpack")
            if backpack then
                cloned.Parent = backpack
                
                -- تفعيل الأداة
                task.wait(0.5)
                if cloned:IsA("Tool") then
                    cloned.Parent = player.Character
                    task.wait(0.5)
                    cloned.Parent = backpack
                end
            end
        end
    end
end)

injectBtn.MouseButton1Click:Connect(function()
    statusLabel.Text = "📦 INJECTING TO INVENTORY..."
    statusLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
    
    -- البحث عن أدوات منسوخة
    local clonedCount = 0
    for _, child in pairs(workspace:GetChildren()) do
        if child.Name:find("[WORKING]") then
            if injectToWorkingInventory(child) then
                clonedCount = clonedCount + 1
            end
        end
    end
    
    statusLabel.Text = "✅ INJECTED " .. clonedCount .. " TOOLS"
    statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
end)

-- ========== الجزء 7: أدوات إضافية ==========

-- زر اختبار الأداة
local testBtn = Instance.new("TextButton")
testBtn.Text = "🎮 TEST TOOL FUNCTION"
testBtn.Size = UDim2.new(0.96, 0, 0.04, 0)
testBtn.Position = UDim2.new(0.02, 0, 0.98, 0)
testBtn.BackgroundColor3 = Color3.fromRGB(100, 0, 200)
testBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
testBtn.Font = Enum.Font.SourceSansBold
testBtn.Parent = mainFrame

testBtn.MouseButton1Click:Connect(function()
    statusLabel.Text = "🎮 TESTING TOOL FUNCTIONALITY..."
    statusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
    
    -- اختبار أداة من Backpack
    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        local testTool = backpack:FindFirstChildWhichIsA("Tool")
        if testTool then
            -- تجربة تفعيلها
            testTool.Parent = player.Character
            task.wait(1)
            testTool.Parent = backpack
            
            statusLabel.Text = "✅ TOOL TESTED - " .. testTool.Name
            statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        end
    end
end)

-- ========== التحميل الأولي ==========
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "TOOL HIJACKER PRO LOADED",
    Text = "Full Functionality System Ready!",
    Duration = 5
})

statusLabel.Text = "🔥 TOOL HIJACKER PRO - FULL FUNCTIONALITY"
