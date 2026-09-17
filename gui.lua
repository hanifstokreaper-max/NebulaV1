-- Nebula V1 | gui.lua
-- Premium Minimalist UI

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Color Scheme
local Theme = {
    Background   = Color3.fromRGB(10, 12, 20),
    Surface      = Color3.fromRGB(15, 18, 30),
    Accent       = Color3.fromRGB(0, 191, 255),
    AccentDark   = Color3.fromRGB(0, 120, 180),
    Text         = Color3.fromRGB(230, 235, 255),
    TextDim      = Color3.fromRGB(120, 130, 160),
    Toggle_ON    = Color3.fromRGB(0, 191, 255),
    Toggle_OFF   = Color3.fromRGB(40, 45, 65),
    Separator    = Color3.fromRGB(25, 30, 50),
}

-- GUI Base
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NebulaV1"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = LocalPlayer.PlayerGui

-- Main Frame
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 420, 0, 500)
Main.Position = UDim2.new(0.5, -210, 0.5, -250)
Main.BackgroundColor3 = Theme.Background
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Parent = ScreenGui

-- Corner
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = Main

-- Accent line top
local AccentBar = Instance.new("Frame")
AccentBar.Size = UDim2.new(1, 0, 0, 2)
AccentBar.BackgroundColor3 = Theme.Accent
AccentBar.BorderSizePixel = 0
AccentBar.Parent = Main

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 45)
TitleBar.Position = UDim2.new(0, 0, 0, 2)
TitleBar.BackgroundColor3 = Theme.Surface
TitleBar.BorderSizePixel = 0
TitleBar.Parent = Main

-- Title Text
local TitleText = Instance.new("TextLabel")
TitleText.Text = "NEBULA V1"
TitleText.Font = Enum.Font.GothamBold
TitleText.TextSize = 14
TitleText.TextColor3 = Theme.Accent
TitleText.BackgroundTransparency = 1
TitleText.Size = UDim2.new(1, -20, 1, 0)
TitleText.Position = UDim2.new(0, 15, 0, 0)
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TitleBar

-- Subtitle
local SubText = Instance.new("TextLabel")
SubText.Text = "Premium Cali Cheat"
SubText.Font = Enum.Font.Gotham
SubText.TextSize = 10
SubText.TextColor3 = Theme.TextDim
SubText.BackgroundTransparency = 1
SubText.Size = UDim2.new(1, -20, 1, 0)
SubText.Position = UDim2.new(0, 15, 0, 16)
SubText.TextXAlignment = Enum.TextXAlignment.Left
SubText.Parent = TitleBar

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Text = "✕"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 12
CloseBtn.TextColor3 = Theme.TextDim
CloseBtn.BackgroundTransparency = 1
CloseBtn.Size = UDim2.new(0, 40, 1, 0)
CloseBtn.Position = UDim2.new(1, -40, 0, 0)
CloseBtn.Parent = TitleBar

CloseBtn.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

-- Tab Bar
local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, 0, 0, 35)
TabBar.Position = UDim2.new(0, 0, 0, 47)
TabBar.BackgroundColor3 = Theme.Surface
TabBar.BorderSizePixel = 0
TabBar.Parent = Main

local TabLayout = Instance.new("UIListLayout")
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.Padding = UDim.new(0, 0)
TabLayout.Parent = TabBar

local Tabs = {"Aimbot", "ESP", "Player", "Misc"}
local TabButtons = {}
local TabPages = {}

-- Content Area
local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, 0, 1, -85)
ContentArea.Position = UDim2.new(0, 0, 0, 82)
ContentArea.BackgroundTransparency = 1
ContentArea.Parent = Main

-- Helper: Create Tab
local function createTab(name, index)
    local btn = Instance.new("TextButton")
    btn.Text = name
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 11
    btn.TextColor3 = Theme.TextDim
    btn.BackgroundTransparency = 1
    btn.Size = UDim2.new(0, 105, 1, 0)
    btn.Parent = TabBar
    TabButtons[name] = btn

    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = Theme.Accent
    page.Visible = false
    page.Parent = ContentArea
    TabPages[name] = page

    local pageLayout = Instance.new("UIListLayout")
    pageLayout.Padding = UDim.new(0, 6)
    pageLayout.Parent = page

    local pagePad = Instance.new("UIPadding")
    pagePad.PaddingLeft = UDim.new(0, 15)
    pagePad.PaddingRight = UDim.new(0, 15)
    pagePad.PaddingTop = UDim.new(0, 10)
    pagePad.Parent = page
end

for i, name in ipairs(Tabs) do
    createTab(name, i)
end

-- Tab Switching
local currentTab = nil
local function switchTab(name)
    if currentTab == name then return end
    currentTab = name
    for _, n in ipairs(Tabs) do
        TabPages[n].Visible = false
        TabButtons[n].TextColor3 = Theme.TextDim
        TabButtons[n].Font = Enum.Font.Gotham
    end
    TabPages[name].Visible = true
    TabButtons[name].TextColor3 = Theme.Accent
    TabButtons[name].Font = Enum.Font.GothamBold
end

for _, name in ipairs(Tabs) do
    TabButtons[name].MouseButton1Click:Connect(function()
        switchTab(name)
    end)
end

switchTab("Aimbot")

-- Helper: Toggle Row
local function createToggle(parent, labelText, default, callback)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 38)
    row.BackgroundColor3 = Theme.Surface
    row.BorderSizePixel = 0
    row.Parent = parent

    local rowCorner = Instance.new("UICorner")
    rowCorner.CornerRadius = UDim.new(0, 8)
    rowCorner.Parent = row

    local label = Instance.new("TextLabel")
    label.Text = labelText
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.TextColor3 = Theme.Text
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = row

    local toggleBtn = Instance.new("Frame")
    toggleBtn.Size = UDim2.new(0, 36, 0, 18)
    toggleBtn.Position = UDim2.new(1, -48, 0.5, -9)
    toggleBtn.BackgroundColor3 = default and Theme.Toggle_ON or Theme.Toggle_OFF
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Parent = row

    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(1, 0)
    toggleCorner.Parent = toggleBtn

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 12, 0, 12)
    knob.Position = default and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BorderSizePixel = 0
    knob.Parent = toggleBtn

    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = knob

    local state = default
    local btn = Instance.new("TextButton")
    btn.Text = ""
    btn.BackgroundTransparency = 1
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.Parent = row

    btn.MouseButton1Click:Connect(function()
        state = not state
        local tween = TweenService:Create(toggleBtn, TweenInfo.new(0.2), {
            BackgroundColor3 = state and Theme.Toggle_ON or Theme.Toggle_OFF
        })
        local knobTween = TweenService:Create(knob, TweenInfo.new(0.2), {
            Position = state and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6)
        })
        tween:Play()
        knobTween:Play()
        if callback then callback(state) end
    end)

    return row
end

-- Helper: Slider
local function createSlider(parent, labelText, min, max, default, callback)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 52)
    row.BackgroundColor3 = Theme.Surface
    row.BorderSizePixel = 0
    row.Parent = parent

    local rowCorner = Instance.new("UICorner")
    rowCorner.CornerRadius = UDim.new(0, 8)
    rowCorner.Parent = row

    local label = Instance.new("TextLabel")
    label.Text = labelText
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.TextColor3 = Theme.Text
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(0.7, 0, 0, 22)
    label.Position = UDim2.new(0, 12, 0, 6)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = row

    local valLabel = Instance.new("TextLabel")
    valLabel.Text = tostring(default)
    valLabel.Font = Enum.Font.GothamBold
    valLabel.TextSize = 11
    valLabel.TextColor3 = Theme.Accent
    valLabel.BackgroundTransparency = 1
    valLabel.Size = UDim2.new(0.3, -12, 0, 22)
    valLabel.Position = UDim2.new(0.7, 0, 0, 6)
    valLabel.TextXAlignment = Enum.TextXAlignment.Right
    valLabel.Parent = row

    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, -24, 0, 4)
    track.Position = UDim2.new(0, 12, 0, 36)
    track.BackgroundColor3 = Theme.Separator
    track.BorderSizePixel = 0
    track.Parent = row

    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(1, 0)
    trackCorner.Parent = track

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Theme.Accent
    fill.BorderSizePixel = 0
    fill.Parent = track

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = fill

    local dragging = false
    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local trackPos = track.AbsolutePosition.X
            local trackSize = track.AbsoluteSize.X
            local rel = math.clamp((input.Position.X - trackPos) / trackSize, 0, 1)
            local val = math.floor(min + (max - min) * rel)
            fill.Size = UDim2.new(rel, 0, 1, 0)
            valLabel.Text = tostring(val)
            if callback then callback(val) end
        end
    end)

    return row
end

-- Helper: Color Picker (simple RGB sliders)
local function createColorPicker(parent, labelText, default, callback)
    local section = Instance.new("Frame")
    section.Size = UDim2.new(1, 0, 0, 140)
    section.BackgroundColor3 = Theme.Surface
    section.BorderSizePixel = 0
    section.Parent = parent

    local sCorner = Instance.new("UICorner")
    sCorner.CornerRadius = UDim.new(0, 8)
    sCorner.Parent = section

    local header = Instance.new("TextLabel")
    header.Text = labelText
    header.Font = Enum.Font.GothamBold
    header.TextSize = 11
    header.TextColor3 = Theme.TextDim
    header.BackgroundTransparency = 1
    header.Size = UDim2.new(1, -12, 0, 20)
    header.Position = UDim2.new(0, 12, 0, 6)
    header.TextXAlignment = Enum.TextXAlignment.Left
    header.Parent = section

    local preview = Instance.new("Frame")
    preview.Size = UDim2.new(0, 24, 0, 14)
    preview.Position = UDim2.new(1, -38, 0, 9)
    preview.BackgroundColor3 = default
    preview.BorderSizePixel = 0
    preview.Parent = section

    local pCorner = Instance.new("UICorner")
    pCorner.CornerRadius = UDim.new(0, 4)
    pCorner.Parent = preview

    local r, g, b = math.floor(default.R * 255), math.floor(default.G * 255), math.floor(default.B * 255)

    local function updateColor()
        local c = Color3.fromRGB(r, g, b)
        preview.BackgroundColor3 = c
        if callback then callback(c) end
    end

    local sliders = {
        {label = "R", min = 0, max = 255, default = r, set = function(v) r = v updateColor() end},
        {label = "G", min = 0, max = 255, default = g, set = function(v) g = v updateColor() end},
        {label = "B", min = 0, max = 255, default = b, set = function(v) b = v updateColor() end},
    }

    for i, s in ipairs(sliders) do
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, -24, 0, 28)
        row.Position = UDim2.new(0, 12, 0, 20 + (i-1) * 36)
        row.BackgroundTransparency = 1
        row.Parent = section

        local lbl = Instance.new("TextLabel")
        lbl.Text = s.label
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 10
        lbl.TextColor3 = Theme.Accent
        lbl.BackgroundTransparency = 1
        lbl.Size = UDim2.new(0, 12, 1, 0)
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = row

        local track = Instance.new("Frame")
        track.Size = UDim2.new(1, -40, 0, 4)
        track.Position = UDim2.new(0, 18, 0.5, -2)
        track.BackgroundColor3 = Theme.Separator
        track.BorderSizePixel = 0
        track.Parent = row

        local tCorner = Instance.new("UICorner")
        tCorner.CornerRadius = UDim.new(1, 0)
        tCorner.Parent = track

        local fill = Instance.new("Frame")
        fill.Size = UDim2.new(s.default / 255, 0, 1, 0)
        fill.BackgroundColor3 = Theme.Accent
        fill.BorderSizePixel = 0
        fill.Parent = track

        local fCorner = Instance.new("UICorner")
        fCorner.CornerRadius = UDim.new(1, 0)
        fCorner.Parent = fill

        local val = Instance.new("TextLabel")
        val.Text = tostring(s.default)
        val.Font = Enum.Font.Gotham
        val.TextSize = 10
        val.TextColor3 = Theme.TextDim
        val.BackgroundTransparency = 1
        val.Size = UDim2.new(0, 28, 1, 0)
        val.Position = UDim2.new(1, -28, 0, 0)
        val.TextXAlignment = Enum.TextXAlignment.Right
        val.Parent = row

        local dragging = false
        track.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local rel = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
                local v = math.floor(rel * 255)
                fill.Size = UDim2.new(rel, 0, 1, 0)
                val.Text = tostring(v)
                s.set(v)
            end
        end)
    end

    return section
end

-- Section Label
local function createSection(parent, text)
    local lbl = Instance.new("TextLabel")
    lbl.Text = "— " .. text .. " —"
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 10
    lbl.TextColor3 = Theme.TextDim
    lbl.BackgroundTransparency = 1
    lbl.Size = UDim2.new(1, 0, 0, 20)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = parent
    return lbl
end

-- Expose
_G.NebulaGUI = {
    Pages = TabPages,
    Theme = Theme,
    createToggle = createToggle,
    createSlider = createSlider,
    createColorPicker = createColorPicker,
    createSection = createSection,
}
