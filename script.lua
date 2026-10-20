--[[
    Moreno Dev King ❤️‍🔥🇧🇷 
    FIXED JAIL (INSIDE TELEPORT) & TARGET TAG MANAGER
]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- // 1. LISTA EXCLUSIVA DE PERMISSÃO
local Owner = {"inc0mum000"}
local Admins = {"rickmv535", "Miguel9430654", "akilavitoriaoliveira"}

-- // 2. TRAVA DE SEGURANÇA (SÓ EXECUTA QUEM ESTÁ NA LISTA)
local isOwner = table.find(Owner, LocalPlayer.Name)
local isAdmin = table.find(Admins, LocalPlayer.Name)

if not (isOwner or isAdmin) then
    return -- Interrompe a execução se não estiver na lista
end

-- // 3. LÓGICA DE CRIAÇÃO DE TAG
local function CreateTagForPlayer(targetPlayer, text, isRainbow)
    if not targetPlayer or not targetPlayer.Character then return end
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
    lbl.Text = text

    if isRainbow then
        spawn(function()
            while targetPlayer.Character and targetPlayer.Character:FindFirstChild("ExecutorRankTag") do
                lbl.TextColor3 = Color3.fromHSV(tick() % 5 / 5, 1, 1)
                task.wait()
            end
        end)
    else
        lbl.TextColor3 = Color3.fromRGB(0, 170, 255) -- Azul Admin
    end
end

-- // 4. INTERFACE WINDUI
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
local SelectedPlayer = ""
local SavedPos = nil
local InfJump = false
local NoclipEnabled = false
local LoopKillActive = false

local Window = WindUI:CreateWindow({
    Title = "Moreno Dev King ❤️‍🔥🇧🇷",
    Icon = "rbxassetid://10723343321",
    Author = "FIXED JAIL & TAG SYSTEM",
    Size = UDim2.fromOffset(650, 670),
    Transparent = true,
    Theme = "Dark"
})

-- ABA ADMIN (TARGET)
local TabAdmin = Window:Tab({ Title = "Admin Controls", Icon = "shield" })

TabAdmin:Dropdown({
    Title = "Select Target",
    Values = (function() local t={} for _,v in pairs(Players:GetPlayers()) do table.insert(t,v.Name) end return t end)(),
    Callback = function(v) SelectedPlayer = v end
})

TabAdmin:Section({Title = "Tag Options"})

-- OPÇÃO DE APLICAR TAG NO ALVO SELECIONADO
TabAdmin:Button({Title = "Give Target Admin Tag 🏷️", Callback = function()
    local t = Players:FindFirstChild(SelectedPlayer)
    if t then
        CreateTagForPlayer(t, "User-admin", false)
    end
end})

TabAdmin:Button({Title = "Remove Target Tag 🗑️", Callback = function()
    local t = Players:FindFirstChild(SelectedPlayer)
    if t and t.Character and t.Character:FindFirstChild("ExecutorRankTag") then
        t.Character.ExecutorRankTag:Destroy()
    end
end})

TabAdmin:Section({Title = "Teleport & Bring Ops"})

TabAdmin:Button({Title = "Slow TP BR 🚚", Callback = function()
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
    pcall(function()
        Players[SelectedPlayer].Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
    end)
end})

TabAdmin:Section({Title = "Hostile & Punishment"})

-- JAIL CORRIGIDO (Cria a estrutura e coloca você/alvo DENTRO do cubo)
TabAdmin:Button({Title = "Jail Target ⛓️", Callback = function() 
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

        createWall(Vector3.new(12, 1, 12), CFrame.new(0, -3.5, 0)) -- Chão
        createWall(Vector3.new(12, 1, 12), CFrame.new(0, 8.5, 0))  -- Teto
        createWall(Vector3.new(1, 12, 12), CFrame.new(-6, 2.5, 0)) -- Parede Esq
        createWall(Vector3.new(1, 12, 12), CFrame.new(6, 2.5, 0))  -- Parede Dir
        createWall(Vector3.new(12, 12, 1), CFrame.new(0, 2.5, -6)) -- Parede Trás
        createWall(Vector3.new(12, 12, 1), CFrame.new(0, 2.5, 6))  -- Parede Frente

        -- Teleporta o alvo exatamente para o meio interno da jaula
        root.CFrame = cf * CFrame.new(0, 1, 0)
    end 
end})

TabAdmin:Button({Title = "Unjail 🔓", Callback = function() 
    if workspace:FindFirstChild("Jail_"..SelectedPlayer) then 
        workspace["Jail_"..SelectedPlayer]:Destroy() 
    end 
end})

TabAdmin:Button({Title = "Kill 💀", Callback = function() 
    pcall(function() Players[SelectedPlayer].Character:BreakJoints() end) 
end})

TabAdmin:Toggle({Title = "Loop Kill 🔄", Value = false, Callback = function(state)
    LoopKillActive = state
    spawn(function()
        while LoopKillActive do
            pcall(function() Players[SelectedPlayer].Character:BreakJoints() end)
            task.wait(0.5)
        end
    end)
end})

TabAdmin:Button({Title = "Fling Target 🌪️", Callback = function()
    local t = Players:FindFirstChild(SelectedPlayer)
    if t and t.Character and t.Character:FindFirstChild("HumanoidRootPart") then
        local b = Instance.new("BodyVelocity", t.Character.HumanoidRootPart)
        b.Velocity = Vector3.new(0, 10000, 0)
        b.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        game.Debris:AddItem(b, 0.2)
    end
end})

TabAdmin:Button({Title = "Freeze 🧊", Callback = function() 
    pcall(function() Players[SelectedPlayer].Character.HumanoidRootPart.Anchored = true end) 
end})

TabAdmin:Button({Title = "Unfreeze 🔥", Callback = function() 
    pcall(function() Players[SelectedPlayer].Character.HumanoidRootPart.Anchored = false end) 
end})

TabAdmin:Button({Title = "Kick Player 🚫", Callback = function() 
    pcall(function() Players[SelectedPlayer]:Kick("Kicked by Moreno King Admin") end) 
end})

-- ABA SELF & MOVEMENT
local TabSelf = Window:Tab({ Title = "Self & Movement", Icon = "zap" })

TabSelf:Section({Title = "Rank Tag Setting"})

TabSelf:Toggle({Title = "Display Self Rank Tag 🏷️", Value = false, Callback = function(state)
    if state then
        if isOwner then
            CreateTagForPlayer(LocalPlayer, "Dono- principal !", true)
        elseif isAdmin then
            CreateTagForPlayer(LocalPlayer, "User-admin", false)
        end
    else
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("ExecutorRankTag") then
            LocalPlayer.Character.ExecutorRankTag:Destroy()
        end
    end
end})

TabSelf:Section({Title = "Movement Settings"})

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

TabSelf:Toggle({Title = "Noclip 👻", Value = false, Callback = function(v) 
    NoclipEnabled = v 
end})

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

TabWorld:Button({Title = "Stop Time (Freeze All) ❄️", Callback = function() 
    for _, p in pairs(Players:GetPlayers()) do 
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then 
            p.Character.HumanoidRootPart.Anchored = true 
        end 
    end 
end})

TabWorld:Button({Title = "Resume Time (Unfreeze) 🔥", Callback = function() 
    for _, p in pairs(Players:GetPlayers()) do 
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then 
            p.Character.HumanoidRootPart.Anchored = false 
        end 
    end 
end})

-- ABA JUMPSCARE
local TabJump = Window:Tab({ Title = "Jumpscares", Icon = "ghost" })

local function TriggerJump(imageId)
    local target = Players:FindFirstChild(SelectedPlayer)
    if target then
        local gui = Instance.new("ScreenGui", target.PlayerGui)
        local img = Instance.new("ImageLabel", gui)
        img.Size = UDim2.new(1,0,1,0)
        img.Image = imageId
        local snd = Instance.new("Sound", gui)
        snd.SoundId = "rbxassetid://4633232063"
        snd.Volume = 10
        snd:Play()
        game.Debris:AddItem(gui, 10)
    end
end

TabJump:Button({Title = "Scare 1 😱", Callback = function() TriggerJump("rbxassetid://12554763870") end})
TabJump:Button({Title = "Scare 2 🌑", Callback = function() TriggerJump("rbxassetid://12554768340") end})

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

WindUI:Notify({Title = "Moreno Dev King", Content = "Script Loaded! Jail & Tag options fixed ⛓️🏷️", Duration = 5})
