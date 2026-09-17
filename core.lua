-- Nebula V1 | core.lua
-- Full cheat logic

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local GUI = _G.NebulaGUI
local Pages = GUI.Pages
local Theme = GUI.Theme

-- ========================
-- STATE
-- ========================
local State = {
    Aimbot = {
        Enabled = false,
        FOV = 130,
        Smooth = 8,
        FOVColor = Color3.fromRGB(0, 191, 255),
        ShowFOV = true,
        HitPart = "Head",
        TeamCheck = true,
    },
    ESP = {
        Enabled = false,
        BoxColor = Color3.fromRGB(0, 191, 255),
        NameColor = Color3.fromRGB(255, 255, 255),
        HealthColor = Color3.fromRGB(0, 255, 80),
        DistanceColor = Color3.fromRGB(200, 200, 200),
        ShowBox = true,
        ShowName = true,
        ShowHealth = true,
        ShowDistance = true,
    },
    Player = {
        Noclip = false,
        Speed = 16,
        Fly = false,
        InfJump = false,
    },
    Misc = {
        AutoFarm = false,
        AutoRob = false,
    }
}

-- ========================
-- AIMBOT
-- ========================
local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = false
FOVCircle.Radius = State.Aimbot.FOV
FOVCircle.Color = State.Aimbot.FOVColor
FOVCircle.Thickness = 1.5
FOVCircle.Filled = false
FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

local function getClosestPlayer()
    local closest = nil
    local closestDist = math.huge
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        if State.Aimbot.TeamCheck and player.Team == LocalPlayer.Team then continue end

        local char = player.Character
        if not char then continue end
        local part = char:FindFirstChild(State.Aimbot.HitPart)
        if not part then continue end

        local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
        if not onScreen then continue end

        local dist = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
        if dist < State.Aimbot.FOV and dist < closestDist then
            closestDist = dist
            closest = part
        end
    end

    return closest
end

RunService.RenderStepped:Connect(function()
    -- FOV Circle update
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    FOVCircle.Radius = State.Aimbot.FOV
    FOVCircle.Color = State.Aimbot.FOVColor
    FOVCircle.Visible = State.Aimbot.Enabled and State.Aimbot.ShowFOV

    -- Aimbot logic
    if State.Aimbot.Enabled and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local target = getClosestPlayer()
        if target then
            local targetPos = Camera:WorldToViewportPoint(target.Position)
            local currentCF = Camera.CFrame
            local targetCF = CFrame.lookAt(currentCF.Position, target.Position)
            Camera.CFrame = currentCF:Lerp(targetCF, 1 / State.Aimbot.Smooth)
        end
    end
end)

-- ========================
-- ESP
-- ========================
local ESPObjects = {}

local function removeESP(player)
    if ESPObjects[player] then
        for _, obj in pairs(ESPObjects[player]) do
            if obj.Remove then obj:Remove()
            elseif obj.Destroy then obj:Destroy() end
        end
        ESPObjects[player] = nil
    end
end

local function createESP(player)
    if player == LocalPlayer then return end
    removeESP(player)

    local objects = {}

    objects.Box = Drawing.new("Square")
    objects.Box.Visible = false
    objects.Box.Thickness = 1.5
    objects.Box.Filled = false

    objects.Name = Drawing.new("Text")
    objects.Name.Visible = false
    objects.Name.Size = 13
    objects.Name.Center = true
    objects.Name.Outline = true
    objects.Name.Font = 2

    objects.Health = Drawing.new("Text")
    objects.Health.Visible = false
    objects.Health.Size = 11
    objects.Health.Center = true
    objects.Health.Outline = true
    objects.Health.Font = 2

    objects.Distance = Drawing.new("Text")
    objects.Distance.Visible = false
    objects.Distance.Size = 11
    objects.Distance.Center = true
    objects.Distance.Outline = true
    objects.Distance.Font = 2

    ESPObjects[player] = objects
end

Players.PlayerAdded:Connect(createESP)
Players.PlayerRemoving:Connect(removeESP)
for _, p in ipairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then createESP(p) end
end

RunService.RenderStepped:Connect(function()
    for player, objs in pairs(ESPObjects) do
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChild("Humanoid")
        local head = char and char:FindFirstChild("Head")

        if not (hrp and hum and head and State.ESP.Enabled) then
            for _, o in pairs(objs) do o.Visible = false end
            continue
        end

        local screenPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
        local headPos, headOnScreen = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))

        if not (onScreen and headOnScreen) then
            for _, o in pairs(objs) do o.Visible = false end
            continue
        end

        local dist = (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart"))
            and (hrp.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude or 0

        local height = math.abs(headPos.Y - screenPos.Y) + 20
        local width = height * 0.55
        local cx = screenPos.X
        local cy = (headPos.Y + screenPos.Y) / 2

        -- Box
        if State.ESP.ShowBox then
            objs.Box.Visible = true
            objs.Box.Position = Vector2.new(cx - width/2, cy - height/2)
            objs.Box.Size = Vector2.new(width, height)
            objs.Box.Color = State.ESP.BoxColor
        else
            objs.Box.Visible = false
        end

        -- Name
        if State.ESP.ShowName then
            objs.Name.Visible = true
            objs.Name.Position = Vector2.new(cx, headPos.Y - 16)
            objs.Name.Text = player.DisplayName
            objs.Name.Color = State.ESP.NameColor
        else
            objs.Name.Visible = false
        end

        -- Health
        if State.ESP.ShowHealth then
            objs.Health.Visible = true
            objs.Health.Position = Vector2.new(cx, screenPos.Y + 6)
            local hp = math.floor(hum.Health)
            local maxHp = math.floor(hum.MaxHealth)
            objs.Health.Text = hp .. "/" .. maxHp
            objs.Health.Color = State.ESP.HealthColor
        else
            objs.Health.Visible = false
        end

        -- Distance
        if State.ESP.ShowDistance then
            objs.Distance.Visible = true
            objs.Distance.Position = Vector2.new(cx, screenPos.Y + 18)
            objs.Distance.Text = math.floor(dist) .. "m"
            objs.Distance.Color = State.ESP.DistanceColor
        else
            objs.Distance.Visible = false
        end
    end
end)

-- ========================
-- NOCLIP
-- ========================
RunService.Stepped:Connect(function()
    if not State.Player.Noclip then return end
    local char = LocalPlayer.Character
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
end)

-- ========================
-- SPEED & FLY
-- ========================
local function setSpeed(val)
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChild("Humanoid")
    if hum then hum.WalkSpeed = val end
end

local flyBody = nil
local flying = false

local function startFly()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    flying = true
    local bg = Instance.new("BodyGyro")
    bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bg.P = 9e9
    bg.CFrame = hrp.CFrame
    bg.Parent = hrp

    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bv.Velocity = Vector3.zero
    bv.Parent = hrp

    flyBody = {bg = bg, bv = bv}

    RunService.RenderStepped:Connect(function()
        if not flying or not flyBody then return end
        local dir = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir = dir - Vector3.new(0, 1, 0) end
        flyBody.bv.Velocity = dir * 40
        flyBody.bg.CFrame = Camera.CFrame
    end)
end

local function stopFly()
    flying = false
    if flyBody then
        if flyBody.bg and flyBody.bg.Parent then flyBody.bg:Destroy() end
        if flyBody.bv and flyBody.bv.Parent then flyBody.bv:Destroy() end
        flyBody = nil
    end
end

-- ========================
-- INFINITE JUMP
-- ========================
UserInputService.JumpRequest:Connect(function()
    if not State.Player.InfJump then return end
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChild("Humanoid")
    if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
end)

-- ========================
-- AUTOFARM
-- ========================
local function autoFarmLoop()
    while State.Misc.AutoFarm do
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            -- generic NPC kill loop
            for _, obj in ipairs(workspace:GetDescendants()) do
                if not State.Misc.AutoFarm then break end
                if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj ~= LocalPlayer.Character then
                    local npcHum = obj:FindFirstChild("Humanoid")
                    local npcHRP = obj:FindFirstChild("HumanoidRootPart")
                    if npcHum and npcHRP and npcHum.Health > 0 then
                        hrp.CFrame = npcHRP.CFrame * CFrame.new(0, 0, -3)
                        task.wait(0.1)
                        -- fire tool if equipped
                        local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                        if tool and tool:FindFirstChild("RemoteFunction") then
                            tool.RemoteFunction:InvokeServer()
                        end
                    end
                end
            end
        end
        task.wait(0.5 + math.random() * 0.3) -- randomized anti-detect delay
    end
end

-- ========================
-- GUI BINDING
-- ========================

-- AIMBOT TAB
GUI.createSection(Pages["Aimbot"], "Aimbot Settings")
GUI.createToggle(Pages["Aimbot"], "Aimbot (Hold RMB)", false, function(v)
    State.Aimbot.Enabled = v
end)
GUI.createToggle(Pages["Aimbot"], "Show FOV Circle", true, function(v)
    State.Aimbot.ShowFOV = v
end)
GUI.createToggle(Pages["Aimbot"], "Team Check", true, function(v)
    State.Aimbot.TeamCheck = v
end)
GUI.createSlider(Pages["Aimbot"], "FOV Size", 50, 300, 130, function(v)
    State.Aimbot.FOV = v
end)
GUI.createSlider(Pages["Aimbot"], "Smooth", 1, 20, 8, function(v)
    State.Aimbot.Smooth = v
end)
GUI.createSection(Pages["Aimbot"], "FOV Color")
GUI.createColorPicker(Pages["Aimbot"], "FOV Circle Color", Color3.fromRGB(0, 191, 255), function(c)
    State.Aimbot.FOVColor = c
end)

-- ESP TAB
GUI.createSection(Pages["ESP"], "ESP Settings")
GUI.createToggle(Pages["ESP"], "ESP Enabled", false, function(v)
    State.ESP.Enabled = v
end)
GUI.createToggle(Pages["ESP"], "Box ESP", true, function(v)
    State.ESP.ShowBox = v
end)
GUI.createToggle(Pages["ESP"], "Name ESP", true, function(v)
    State.ESP.ShowName = v
end)
GUI.createToggle(Pages["ESP"], "Health ESP", true, function(v)
    State.ESP.ShowHealth = v
end)
GUI.createToggle(Pages["ESP"], "Distance ESP", true, function(v)
    State.ESP.ShowDistance = v
end)
GUI.createSection(Pages["ESP"], "ESP Colors")
GUI.createColorPicker(Pages["ESP"], "Box Color", Color3.fromRGB(0, 191, 255), function(c)
    State.ESP.BoxColor = c
end)
GUI.createColorPicker(Pages["ESP"], "Name Color", Color3.fromRGB(255, 255, 255), function(c)
    State.ESP.NameColor = c
end)
GUI.createColorPicker(Pages["ESP"], "Health Color", Color3.fromRGB(0, 255, 80), function(c)
    State.ESP.HealthColor = c
end)

-- PLAYER TAB
GUI.createSection(Pages["Player"], "Movement")
GUI.createToggle(Pages["Player"], "Noclip", false, function(v)
    State.Player.Noclip = v
end)
GUI.createToggle(Pages["Player"], "Fly Mode (WASD + Space/Ctrl)", false, function(v)
    State.Player.Fly = v
    if v then startFly() else stopFly() end
end)
GUI.createToggle(Pages["Player"], "Infinite Jump", false, function(v)
    State.Player.InfJump = v
end)
GUI.createSlider(Pages["Player"], "Walk Speed", 16, 200, 16, function(v)
    State.Player.Speed = v
    setSpeed(v)
end)

-- MISC TAB
GUI.createSection(Pages["Misc"], "Farm")
GUI.createToggle(Pages["Misc"], "Auto Farm (NPC Kill)", false, function(v)
    State.Misc.AutoFarm = v
    if v then task.spawn(autoFarmLoop) end
end)

-- ========================
-- KEYBIND TOGGLE (Insert)
-- ========================
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.Insert then
        local main = LocalPlayer.PlayerGui:FindFirstChild("NebulaV1")
        if main then
            main.Main.Visible = not main.Main.Visible
        end
    end
end)

print("[Nebula V1] Core loaded. Insert = toggle GUI.")
