--[[
    Moreno Dev King ❤️‍🔥🇧🇷 
    SUPREME GOD EDITION + DEDICATED SCARE TAB
]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

-- // 1. CONFIGURAÇÃO DE CARGOS ESPECIAIS
local OwnerList = {"inc0mum000"}
local AdminList = {"rickmv535", "Miguel9430654", "akilavitoriaoliveira", "RIP_PEDRO11891"}

-- // 2. REGISTRO AUTOMÁTICO DE EXECUTORES
_G.ScriptExecutors = _G.ScriptExecutors or {}
_G.ScriptExecutors[LocalPlayer.Name] = true

local function IsPlayerExecutor(playerName)
    return _G.ScriptExecutors[playerName] == true
end

-- // 3. LÓGICA DE CRIAÇÃO DE TAG (SÓ PARA EXECUTORES)
local function CreateTagForPlayer(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then return end
    if not IsPlayerExecutor(targetPlayer.Name) then return end
    
    local head = targetPlayer.Character:WaitForChild("Head", 10)
    if not head then return end
    
    if targetPlayer.Character:FindFirstChild("ExecutorRankTag") then 
        targetPlayer.Character.ExecutorRankTag:Destroy() 
    end
    
    local bill = Instance.new("BillboardGui")
    bill.Name = "ExecutorRankTag"
    bill.Parent = targetPlayer.Character
    bill.Adornee = head
    bill.Size = UDim2.new(0, 250, 0, 50)
    bill.StudsOffset = Vector3.new(0, 3.5, 0)
    bill.AlwaysOnTop = true

    local lbl = Instance.new("TextLabel", bill)
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.GothamBlack
    lbl.TextSize = 28
    lbl.TextStrokeTransparency = 0
    lbl.TextStrokeColor3 = Color3.new(0,0,0)

    if table.find(OwnerList, targetPlayer.Name) then
        lbl.Text = "Dono- principal !"
        spawn(function()
            while targetPlayer.Character and targetPlayer.Character:FindFirstChild("ExecutorRankTag") do
                lbl.TextColor3 = Color3.fromHSV(tick() % 5 / 5, 1, 1)
                task.wait()
            end
        end)
    else
        lbl.Text = "User-admin"
        lbl.TextColor3 = Color3.fromRGB(0, 170, 255)
    end
end

-- // 4. INTERFACE WINDUI
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
local SelectedPlayer = ""
local ScareSelectedPlayer = "" -- Alvo específico da aba Susto
local SavedPos = nil
local InfJump = false
local NoclipEnabled = false
local LoopKillActive = false
local LoopFlingActive = false
local FlyEnabled = false

local Window = WindUI:CreateWindow({
    Title = "Moreno Dev King ❤️‍🔥🇧🇷",
    Icon = "rbxassetid://10723343321",
    Author = "SUPREME GOD EDITION",
    Size = UDim2.fromOffset(680, 720),
    Transparent = true,
    Theme = "Dark"
})

-- ABA ADMIN (SÓ MOSTRA E AFETA EXECUTORES)
local TabAdmin = Window:Tab({ Title = "Admin Controls", Icon = "shield" })

local function GetExecutorsList()
    local t = {}
    for _, v in pairs(Players:GetPlayers()) do
        if IsPlayerExecutor(v.Name) then
            table.insert(t, v.Name)
        end
    end
    return t
end

TabAdmin:Dropdown({
    Title = "Select Target (Executors Only)",
    Values = GetExecutorsList(),
    Callback = function(v) SelectedPlayer = v end
})

TabAdmin:Section({Title = "Tag Management"})

TabAdmin:Button({Title = "Refresh Target Tag 🏷️", Callback = function()
    local t = Players:FindFirstChild(SelectedPlayer)
    if t and IsPlayerExecutor(t.Name) then
        CreateTagForPlayer(t)
    end
end})

TabAdmin:Section({Title = "Teleport & Bring Ops"})

TabAdmin:Button({Title = "Slow TP BR 🚚", Callback = function()
    if not IsPlayerExecutor(SelectedPlayer) then return end
    local target = Players:FindFirstChild(SelectedPlayer)
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character then
        spawn(function()
            local targetHrp = target.Character.HumanoidRootPart
            for i = 1, 30 do
                if not targetHrp or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then break end
                local myPos = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -4)
                targetHrp.CFrame = targetHrp.CFrame:Lerp(myPos, 0.2)
                task.wait(0.05)
            end
        end)
    end
end})

TabAdmin:Button({Title = "Instant Bring 📍", Callback = function()
    if not IsPlayerExecutor(SelectedPlayer) then return end
    pcall(function()
        Players[SelectedPlayer].Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
    end)
end})

TabAdmin:Button({Title = "Void Target (Send to Abyss) 🕳️", Callback = function()
    if not IsPlayerExecutor(SelectedPlayer) then return end
    pcall(function()
        Players[SelectedPlayer].Character.HumanoidRootPart.CFrame = CFrame.new(0, -500, 0)
    end)
end})

TabAdmin:Section({Title = "Hostile & Punishment"})

TabAdmin:Button({Title = "Jail Target ⛓️", Callback = function() 
    if not IsPlayerExecutor(SelectedPlayer) then return end
    local t = Players:FindFirstChild(SelectedPlayer)
    if t and t.Character and t.Character:FindFirstChild("HumanoidRootPart") then 
        local root = t.Character.HumanoidRootPart
        local cf = root.CFrame
        
        local model = Instance.new("Model", workspace)
        model.Name = "Jail_"..t.Name

        local function createWall(size, offset)
            local p = Instance.new("Part", model)
            p.Size = size
            p.CFrame = cf * offset
            p.Anchored = true
            p.Material = Enum.Material.ForceField
            p.Transparency = 0.3
            p.Color = Color3.fromRGB(0, 162, 255)
        end

        createWall(Vector3.new(12, 1, 12), CFrame.new(0, -3.5, 0))
        createWall(Vector3.new(12, 1, 12), CFrame.new(0, 8.5, 0))
        createWall(Vector3.new(1, 12, 12), CFrame.new(-6, 2.5, 0))
        createWall(Vector3.new(1, 12, 12), CFrame.new(6, 2.5, 0))
        createWall(Vector3.new(12, 12, 1), CFrame.new(0, 2.5, -6))
        createWall(Vector3.new(12, 12, 1), CFrame.new(0, 2.5, 6))

        root.CFrame = cf * CFrame.new(0, 1, 0)
    end 
end})

TabAdmin:Button({Title = "Unjail 🔓", Callback = function() 
    if workspace:FindFirstChild("Jail_"..SelectedPlayer) then 
        workspace["Jail_"..SelectedPlayer]:Destroy() 
    end 
end})

TabAdmin:Button({Title = "Kill 💀", Callback = function() 
    if not IsPlayerExecutor(SelectedPlayer) then return end
    pcall(function() Players[SelectedPlayer].Character:BreakJoints() end) 
end})

TabAdmin:Button({Title = "Explode 💥", Callback = function() 
    if not IsPlayerExecutor(SelectedPlayer) then return end
    local t = Players:FindFirstChild(SelectedPlayer)
    if t and t.Character and t.Character:FindFirstChild("HumanoidRootPart") then
        local ex = Instance.new("Explosion", workspace)
        ex.Position = t.Character.HumanoidRootPart.Position
    end
end})

TabAdmin:Button({Title = "Rocket Target 🚀", Callback = function()
    if not IsPlayerExecutor(SelectedPlayer) then return end
    local t = Players:FindFirstChild(SelectedPlayer)
    if t and t.Character and t.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = t.Character.HumanoidRootPart
        local b = Instance.new("BodyVelocity", hrp)
        b.Velocity = Vector3.new(0, 300, 0)
        b.MaxForce = Vector3.new(0, math.huge, 0)
        task.wait(2)
        local ex = Instance.new("Explosion", workspace)
        ex.Position = hrp.Position
        b:Destroy()
    end
end})

TabAdmin:Toggle({Title = "Loop Kill 🔄", Value = false, Callback = function(state)
    LoopKillActive = state
    spawn(function()
        while LoopKillActive do
            if IsPlayerExecutor(SelectedPlayer) then
                pcall(function() Players[SelectedPlayer].Character:BreakJoints() end)
            end
            task.wait(0.5)
        end
    end)
end})

TabAdmin:Toggle({Title = "Loop Fling 🌪️", Value = false, Callback = function(state)
    LoopFlingActive = state
    spawn(function()
        while LoopFlingActive do
            if IsPlayerExecutor(SelectedPlayer) then
                local t = Players:FindFirstChild(SelectedPlayer)
                if t and t.Character and t.Character:FindFirstChild("HumanoidRootPart") then
                    local b = Instance.new("BodyVelocity", t.Character.HumanoidRootPart)
                    b.Velocity = Vector3.new(0, 10000, 0)
                    b.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                    game.Debris:AddItem(b, 0.2)
                end
            end
            task.wait(0.3)
        end
    end)
end})

TabAdmin:Button({Title = "Freeze 🧊", Callback = function() 
    if not IsPlayerExecutor(SelectedPlayer) then return end
    pcall(function() Players[SelectedPlayer].Character.HumanoidRootPart.Anchored = true end) 
end})

TabAdmin:Button({Title = "Unfreeze 🔥", Callback = function() 
    if not IsPlayerExecutor(SelectedPlayer) then return end
    pcall(function() Players[SelectedPlayer].Character.HumanoidRootPart.Anchored = false end) 
end})

-- ABA TROLL EXTREMO
local TabTroll = Window:Tab({ Title = "Troll & Chaos 🧨", Icon = "Flame" })

TabTroll:Section({Title = "Mass Disruptions"})

TabTroll:Button({Title = "Fling All Executors 🌪️", Callback = function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and IsPlayerExecutor(p.Name) and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local b = Instance.new("BodyVelocity", p.Character.HumanoidRootPart)
            b.Velocity = Vector3.new(0, 15000, 0)
            b.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            game.Debris:AddItem(b, 0.3)
        end
    end
end})

TabTroll:Button({Title = "Kill All Executors 💀", Callback = function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and IsPlayerExecutor(p.Name) and p.Character then
            p.Character:BreakJoints()
        end
    end
end})

TabTroll:Button({Title = "Explode All Executors 💥", Callback = function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and IsPlayerExecutor(p.Name) and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local ex = Instance.new("Explosion", workspace)
            ex.Position = p.Character.HumanoidRootPart.Position
        end
    end
end})

-- ABA SUSTO (DEDICADA APENAS A EXECUTORES)
local TabSusto = Window:Tab({ Title = "Susto 😱", Icon = "ghost" })

TabSusto:Dropdown({
    Title = "Selecionar Executor Alvo",
    Values = GetExecutorsList(),
    Callback = function(v) ScareSelectedPlayer = v end
})

TabSusto:Section({Title = "Painel de Sustos"})

TabSusto:Button({Title = "Susto 1 (Tela Preta + Grito Estourado) 💀", Callback = function()
    local target = Players:FindFirstChild(ScareSelectedPlayer)
    if target and IsPlayerExecutor(target.Name) and target:FindFirstChild("PlayerGui") then
        local sg = Instance.new("ScreenGui", target.PlayerGui)
        sg.Name = "SustoGui"
        sg.IgnoreGuiInset = true
        
        local frame = Instance.new("Frame", sg)
        frame.Size = UDim2.new(1, 0, 1, 0)
        frame.BackgroundColor3 = Color3.new(0, 0, 0)
        
        local sound = Instance.new("Sound", sg)
        sound.SoundId = "rbxassetid://4633232063"
        sound.Volume = 10 -- Volume estourado
        sound:Play()
        
        game.Debris:AddItem(sg, 5) -- Remove após 5 segundos
    else
        WindUI:Notify({Title = "Erro", Content = "Selecione um executor válido!", Duration = 3})
    end
end})

-- ABA SELF & MOVEMENT
local TabSelf = Window:Tab({ Title = "Self & Movement", Icon = "zap" })

TabSelf:Section({Title = "Rank Tag Setting"})

TabSelf:Toggle({Title = "Display Self Rank Tag 🏷️", Value = false, Callback = function(state)
    if state then
        CreateTagForPlayer(LocalPlayer)
    else
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("ExecutorRankTag") then
            LocalPlayer.Character.ExecutorRankTag:Destroy()
        end
    end
end})

TabSelf:Section({Title = "Player Mods"})

TabSelf:Button({Title = "God Mode ⭐", Callback = function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.MaxHealth = math.huge
        LocalPlayer.Character.Humanoid.Health = math.huge
    end
end})

TabSelf:Button({Title = "Invisibility 👻", Callback = function()
    if LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") or v:IsA("Decal") then
                v.Transparency = 1
            end
        end
    end
end})

TabSelf:Section({Title = "Movement Settings"})

TabSelf:Toggle({Title = "Fly Mode 🛸", Value = false, Callback = function(state)
    FlyEnabled = state
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart
    
    if FlyEnabled then
        local bv = Instance.new("BodyVelocity", hrp)
        bv.Name = "FlyVelocity"
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Velocity = Vector3.new(0,0,0)
        
        spawn(function()
            while FlyEnabled and char and char:FindFirstChild("HumanoidRootPart") do
                local cam = workspace.CurrentCamera
                local vel = Vector3.new(0,0,0)
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then vel = vel + cam.CoordinateFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then vel = vel - cam.CoordinateFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then vel = vel - cam.CoordinateFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then vel = vel + cam.CoordinateFrame.RightVector end
                bv.Velocity = vel * 75
                task.wait()
            end
            if bv then bv:Destroy() end
        end)
    else
        if hrp:FindFirstChild("FlyVelocity") then hrp.FlyVelocity:Destroy() end
    end
end})

TabSelf:Slider({Title = "WalkSpeed", Step = 1, Min = 16, Max = 500, Value = 16, Callback = function(v) 
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = v 
    end
end})

TabSelf:Slider({Title = "JumpPower", Step = 1, Min = 50, Max = 500, Value = 50, Callback = function(v) 
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.JumpPower = v 
    end
end})

TabSelf:Toggle({Title = "Infinite Jump 🚀", Value = false, Callback = function(v) InfJump = v end})

TabSelf:Toggle({Title = "Noclip 👻", Value = false, Callback = function(v) NoclipEnabled = v end})

TabSelf:Button({Title = "TP Tool 🛠️", Callback = function()
    local t = Instance.new("Tool")
    t.RequiresHandle = false
    t.Name = "TP Tool"
    t.Parent = LocalPlayer.Backpack
    t.Activated:Connect(function() 
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(LocalPlayer:GetMouse().Hit.p + Vector3.new(0, 3, 0)) 
        end
    end)
end})

TabSelf:Button({Title = "Save Position 💾", Callback = function() 
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        SavedPos = LocalPlayer.Character.HumanoidRootPart.CFrame 
    end
end})

TabSelf:Button({Title = "Teleport to Saved 🌀", Callback = function() 
    if SavedPos and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then 
        LocalPlayer.Character.HumanoidRootPart.CFrame = SavedPos 
    end 
end})

-- ABA WORLD
local TabWorld = Window:Tab({ Title = "World Control", Icon = "globe" })

TabWorld:Section({Title = "Global Controls"})

TabWorld:Slider({Title = "Server Gravity 🪐", Step = 1, Min = 0, Max = 196, Value = 196, Callback = function(v)
    workspace.Gravity = v
end})

TabWorld:Button({Title = "Delete Part Tool (Click to Delete) 🔨", Callback = function()
    local mouse = LocalPlayer:GetMouse()
    mouse.Button1Down:Connect(function()
        if mouse.Target then
            mouse.Target:Destroy()
        end
    end)
end})

TabWorld:Section({Title = "Time Control"})

TabWorld:Button({Title = "Stop Time (Freeze Executors) ❄️", Callback = function() 
    for _, p in pairs(Players:GetPlayers()) do 
        if p ~= LocalPlayer and IsPlayerExecutor(p.Name) and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then 
            p.Character.HumanoidRootPart.Anchored = true 
        end 
    end 
end})

TabWorld:Button({Title = "Resume Time 🔥", Callback = function() 
    for _, p in pairs(Players:GetPlayers()) do 
        if p ~= LocalPlayer and IsPlayerExecutor(p.Name) and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then 
            p.Character.HumanoidRootPart.Anchored = false 
        end 
    end 
end})

TabWorld:Section({Title = "Environment Lighting"})

TabWorld:Button({Title = "Set Day Time ☀️", Callback = function()
    Lighting.ClockTime = 14
end})

TabWorld:Button({Title = "Set Night Time 🌙", Callback = function()
    Lighting.ClockTime = 0
end})

TabWorld:Button({Title = "Full Bright 💡", Callback = function()
    Lighting.Brightness = 2
    Lighting.ClockTime = 14
    Lighting.GlobalShadows = false
end})

-- // 5. LOOPS DO SISTEMA
UserInputService.JumpRequest:Connect(function() 
    if InfJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then 
        LocalPlayer.Character.Humanoid:ChangeState("Jumping") 
    end 
end)

RunService.Stepped:Connect(function()
    if NoclipEnabled and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

WindUI:Notify({Title = "Moreno Dev King", Content = "Supreme God Edition Loaded with Scare Tab! 👑👻", Duration = 5})
