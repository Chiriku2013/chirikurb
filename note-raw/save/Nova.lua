--[[
    ███╗   ██╗ ██████╗ ██╗   ██╗ █████╗
    ████╗  ██║██╔═══██╗██║   ██║██╔══██╗
    ██╔██╗ ██║██║   ██║██║   ██║███████║
    ██║╚██╗██║██║   ██║╚██╗ ██╔╝██╔══██║
    ██║ ╚████║╚██████╔╝ ╚████╔╝ ██║  ██║
    ╚═╝  ╚═══╝ ╚═════╝   ╚═══╝  ╚═╝  ╚═╝

    Nova UI Library v1.0
    by nova-scripts
    Fluent-compatible API for Roblox

    Themes: Dark | Amoled | Ocean | Rose | Forest | Light
--]]

-- ═══════════════════════════════════════════
--              SERVICES
-- ═══════════════════════════════════════════
local Players            = game:GetService("Players")
local RunService         = game:GetService("RunService")
local TweenService       = game:GetService("TweenService")
local UserInputService   = game:GetService("UserInputService")
local CoreGui            = game:GetService("CoreGui")
local TextService        = game:GetService("TextService")
local HttpService        = game:GetService("HttpService")

local LocalPlayer  = Players.LocalPlayer
local Mouse        = LocalPlayer:GetMouse()

-- ═══════════════════════════════════════════
--              NOVA CORE
-- ═══════════════════════════════════════════
local Nova = {}
Nova.__index = Nova
Nova.Version = "1.0"
Nova.Unloaded = false
Nova.Options = {}   -- Holds all element value references by index key
Nova.Themes = {}
Nova.Windows = {}

-- ── Tween Helper ──────────────────────────
local function Tween(obj, props, duration, style, dir)
    style    = style    or Enum.EasingStyle.Quad
    dir      = dir      or Enum.EasingDirection.Out
    duration = duration or 0.2
    local info = TweenInfo.new(duration, style, dir)
    local t    = TweenService:Create(obj, info, props)
    t:Play()
    return t
end

-- ── Create Instance Helper ────────────────
local function New(class, props, children)
    local obj = Instance.new(class)
    for k, v in pairs(props or {}) do
        if k ~= "Parent" then
            obj[k] = v
        end
    end
    for _, child in pairs(children or {}) do
        child.Parent = obj
    end
    if props and props.Parent then
        obj.Parent = props.Parent
    end
    return obj
end

-- ── Corner Helper ─────────────────────────
local function Corner(radius, parent)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 8)
    c.Parent = parent
    return c
end

local function Padding(t, r, b, l, parent)
    local p = Instance.new("UIPadding")
    p.PaddingTop    = UDim.new(0, t or 0)
    p.PaddingRight  = UDim.new(0, r or 0)
    p.PaddingBottom = UDim.new(0, b or 0)
    p.PaddingLeft   = UDim.new(0, l or 0)
    p.Parent = parent
    return p
end

local function ListLayout(parent, props)
    local l = Instance.new("UIListLayout")
    l.SortOrder = Enum.SortOrder.LayoutOrder
    for k, v in pairs(props or {}) do
        l[k] = v
    end
    l.Parent = parent
    return l
end

-- ── Dragging ──────────────────────────────
local function MakeDraggable(topBar, frame)
    local dragging, dragStart, startPos
    topBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging  = true
            dragStart = input.Position
            startPos  = frame.Position
        end
    end)
    topBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- ═══════════════════════════════════════════
--              THEMES
-- ═══════════════════════════════════════════
Nova.Themes = {
    Dark = {
        Background      = Color3.fromRGB(13,  13,  15),
        Surface         = Color3.fromRGB(20,  20,  23),
        Surface2        = Color3.fromRGB(26,  26,  31),
        Sidebar         = Color3.fromRGB(17,  17,  21),
        Border          = Color3.fromRGB(42,  42,  50),
        Accent          = Color3.fromRGB(124, 106, 255),
        AccentLight     = Color3.fromRGB(167, 139, 250),
        AccentGlow      = Color3.fromRGB(60,  45,  120),
        Text            = Color3.fromRGB(232, 232, 240),
        TextDim         = Color3.fromRGB(122, 122, 144),
        TextMuted       = Color3.fromRGB(74,  74,  90),
        Success         = Color3.fromRGB(52,  211, 153),
        Warning         = Color3.fromRGB(251, 191, 36),
        Danger          = Color3.fromRGB(248, 113, 113),
    },
    Amoled = {
        Background      = Color3.fromRGB(0,   0,   0),
        Surface         = Color3.fromRGB(10,  10,  10),
        Surface2        = Color3.fromRGB(17,  17,  17),
        Sidebar         = Color3.fromRGB(5,   5,   5),
        Border          = Color3.fromRGB(34,  34,  34),
        Accent          = Color3.fromRGB(124, 106, 255),
        AccentLight     = Color3.fromRGB(167, 139, 250),
        AccentGlow      = Color3.fromRGB(50,  40,  100),
        Text            = Color3.fromRGB(255, 255, 255),
        TextDim         = Color3.fromRGB(136, 136, 136),
        TextMuted       = Color3.fromRGB(68,  68,  68),
        Success         = Color3.fromRGB(52,  211, 153),
        Warning         = Color3.fromRGB(251, 191, 36),
        Danger          = Color3.fromRGB(248, 113, 113),
    },
    Ocean = {
        Background      = Color3.fromRGB(6,   13,  26),
        Surface         = Color3.fromRGB(11,  21,  37),
        Surface2        = Color3.fromRGB(16,  29,  48),
        Sidebar         = Color3.fromRGB(8,   15,  30),
        Border          = Color3.fromRGB(26,  48,  80),
        Accent          = Color3.fromRGB(56,  189, 248),
        AccentLight     = Color3.fromRGB(125, 211, 252),
        AccentGlow      = Color3.fromRGB(20,  70,  100),
        Text            = Color3.fromRGB(224, 242, 254),
        TextDim         = Color3.fromRGB(106, 165, 196),
        TextMuted       = Color3.fromRGB(40,  80,  110),
        Success         = Color3.fromRGB(52,  211, 153),
        Warning         = Color3.fromRGB(251, 191, 36),
        Danger          = Color3.fromRGB(248, 113, 113),
    },
    Rose = {
        Background      = Color3.fromRGB(19,  10,  14),
        Surface         = Color3.fromRGB(30,  15,  22),
        Surface2        = Color3.fromRGB(38,  20,  32),
        Sidebar         = Color3.fromRGB(15,  8,   16),
        Border          = Color3.fromRGB(61,  31,  46),
        Accent          = Color3.fromRGB(251, 113, 133),
        AccentLight     = Color3.fromRGB(253, 164, 175),
        AccentGlow      = Color3.fromRGB(100, 40,  55),
        Text            = Color3.fromRGB(255, 228, 230),
        TextDim         = Color3.fromRGB(196, 119, 138),
        TextMuted       = Color3.fromRGB(100, 50,  70),
        Success         = Color3.fromRGB(52,  211, 153),
        Warning         = Color3.fromRGB(251, 191, 36),
        Danger          = Color3.fromRGB(248, 113, 113),
    },
    Forest = {
        Background      = Color3.fromRGB(8,   14,  9),
        Surface         = Color3.fromRGB(14,  26,  15),
        Surface2        = Color3.fromRGB(19,  32,  21),
        Sidebar         = Color3.fromRGB(6,   12,  7),
        Border          = Color3.fromRGB(30,  51,  32),
        Accent          = Color3.fromRGB(74,  222, 128),
        AccentLight     = Color3.fromRGB(134, 239, 172),
        AccentGlow      = Color3.fromRGB(25,  80,  40),
        Text            = Color3.fromRGB(220, 252, 231),
        TextDim         = Color3.fromRGB(106, 173, 122),
        TextMuted       = Color3.fromRGB(45,  90,  55),
        Success         = Color3.fromRGB(52,  211, 153),
        Warning         = Color3.fromRGB(251, 191, 36),
        Danger          = Color3.fromRGB(248, 113, 113),
    },
    Light = {
        Background      = Color3.fromRGB(240, 240, 245),
        Surface         = Color3.fromRGB(255, 255, 255),
        Surface2        = Color3.fromRGB(248, 248, 252),
        Sidebar         = Color3.fromRGB(232, 232, 240),
        Border          = Color3.fromRGB(221, 221, 232),
        Accent          = Color3.fromRGB(109, 90,  255),
        AccentLight     = Color3.fromRGB(149, 128, 255),
        AccentGlow      = Color3.fromRGB(200, 190, 255),
        Text            = Color3.fromRGB(26,  26,  46),
        TextDim         = Color3.fromRGB(96,  96,  128),
        TextMuted       = Color3.fromRGB(170, 170, 200),
        Success         = Color3.fromRGB(22,  163, 74),
        Warning         = Color3.fromRGB(202, 138, 4),
        Danger          = Color3.fromRGB(220, 38,  38),
    },
}

-- ═══════════════════════════════════════════
--         NOTIFICATION SYSTEM
-- ═══════════════════════════════════════════
local NotificationHolder

local function EnsureNotifHolder()
    if NotificationHolder and NotificationHolder.Parent then return end
    local sg = Instance.new("ScreenGui")
    sg.Name             = "NovaNotifications"
    sg.ResetOnSpawn     = false
    sg.ZIndexBehavior   = Enum.ZIndexBehavior.Sibling
    sg.DisplayOrder     = 999
    sg.Parent           = (pcall(function() return CoreGui end)) and CoreGui or LocalPlayer.PlayerGui

    NotificationHolder = New("Frame", {
        Name              = "Holder",
        BackgroundTransparency = 1,
        Position          = UDim2.new(1, -320, 0, 18),
        Size              = UDim2.new(0, 300, 1, -36),
        Parent            = sg,
    })
    ListLayout(NotificationHolder, {
        Padding           = UDim.new(0, 8),
        VerticalAlignment = Enum.VerticalAlignment.Top,
    })
end

function Nova:Notify(options)
    EnsureNotifHolder()
    local theme   = self._theme or Nova.Themes.Dark
    local title   = options.Title      or "Nova"
    local content = options.Content    or ""
    local sub     = options.SubContent or nil
    local dur     = options.Duration   or 5
    local color   = options.Color      or theme.Accent

    -- Container
    local card = New("Frame", {
        Name              = "Notif_" .. title,
        BackgroundColor3  = theme.Surface,
        BorderSizePixel   = 0,
        ClipsDescendants  = true,
        Size              = UDim2.new(1, 0, 0, 0), -- starts at 0, expands
        AutomaticSize     = Enum.AutomaticSize.Y,
        Parent            = NotificationHolder,
    })
    Corner(10, card)

    -- Left accent bar
    New("Frame", {
        Name             = "Bar",
        BackgroundColor3 = color,
        BorderSizePixel  = 0,
        Size             = UDim2.new(0, 3, 1, 0),
        Parent           = card,
    }, { Corner(2) })

    -- Stroke
    local stroke = Instance.new("UIStroke")
    stroke.Color         = color
    stroke.Thickness     = 1
    stroke.Transparency  = 0.5
    stroke.Parent        = card

    -- Inner frame
    local inner = New("Frame", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 14, 0, 0),
        Size     = UDim2.new(1, -14, 1, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        Parent   = card,
    })
    Padding(10, 12, 10, 0, inner)
    ListLayout(inner, { Padding = UDim.new(0, 3) })

    -- Title label
    New("TextLabel", {
        Name              = "Title",
        BackgroundTransparency = 1,
        Text              = title,
        TextColor3        = theme.AccentLight,
        Font              = Enum.Font.GothamBold,
        TextSize          = 13,
        TextXAlignment    = Enum.TextXAlignment.Left,
        Size              = UDim2.new(1, 0, 0, 16),
        AutomaticSize     = Enum.AutomaticSize.Y,
        Parent            = inner,
    })

    -- Content
    New("TextLabel", {
        Name              = "Content",
        BackgroundTransparency = 1,
        Text              = content,
        TextColor3        = theme.TextDim,
        Font              = Enum.Font.Gotham,
        TextSize          = 11,
        TextXAlignment    = Enum.TextXAlignment.Left,
        TextWrapped       = true,
        Size              = UDim2.new(1, 0, 0, 0),
        AutomaticSize     = Enum.AutomaticSize.Y,
        Parent            = inner,
    })

    -- SubContent (optional)
    if sub then
        New("TextLabel", {
            Name              = "Sub",
            BackgroundTransparency = 1,
            Text              = sub,
            TextColor3        = theme.TextMuted,
            Font              = Enum.Font.Gotham,
            TextSize          = 10,
            TextXAlignment    = Enum.TextXAlignment.Left,
            TextWrapped       = true,
            Size              = UDim2.new(1, 0, 0, 0),
            AutomaticSize     = Enum.AutomaticSize.Y,
            Parent            = inner,
        })
    end

    -- Progress bar
    if dur then
        local barBg = New("Frame", {
            BackgroundColor3 = theme.Border,
            BorderSizePixel  = 0,
            Size             = UDim2.new(1, 0, 0, 2),
            Parent           = inner,
        }, { Corner(1) })

        local barFill = New("Frame", {
            BackgroundColor3 = color,
            BorderSizePixel  = 0,
            Size             = UDim2.new(1, 0, 1, 0),
            Parent           = barBg,
        }, { Corner(1) })

        -- animate progress shrink
        Tween(barFill, { Size = UDim2.new(0, 0, 1, 0) }, dur, Enum.EasingStyle.Linear)
    end

    -- Entrance tween
    card.BackgroundTransparency = 1
    Tween(card, { BackgroundTransparency = 0 }, 0.25)

    -- Auto-dismiss
    if dur then
        task.delay(dur, function()
            Tween(card, { BackgroundTransparency = 1 }, 0.3)
            task.wait(0.35)
            card:Destroy()
        end)
    end

    return {
        Dismiss = function()
            Tween(card, { BackgroundTransparency = 1 }, 0.3)
            task.delay(0.35, function() card:Destroy() end)
        end
    }
end

-- ═══════════════════════════════════════════
--         WINDOW CREATION
-- ═══════════════════════════════════════════
function Nova:CreateWindow(options)
    local Window = setmetatable({}, { __index = Nova })
    Window._tabs      = {}
    Window._tabBtns   = {}
    Window._activeTab = nil
    Window._options   = options or {}
    Window._visible   = true

    -- Resolve theme
    local themeName = options.Theme or "Dark"
    local theme     = Nova.Themes[themeName] or Nova.Themes.Dark
    Window._theme   = theme

    -- Propagate theme to Notify
    Nova._theme = theme

    local winSize = options.Size or UDim2.fromOffset(620, 480)
    local tabW    = options.TabWidth or 160

    -- ── ScreenGui ───────────────────────────
    local sg = Instance.new("ScreenGui")
    sg.Name           = "Nova_" .. (options.Title or "Window")
    sg.ResetOnSpawn   = false
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sg.DisplayOrder   = 100
    sg.Parent         = (pcall(function() return CoreGui end)) and CoreGui or LocalPlayer.PlayerGui
    Window._sg        = sg

    -- ── Blur (Acrylic) ──────────────────────
    if options.Acrylic ~= false then
        local blur = Instance.new("BlurEffect")
        blur.Size   = 16
        blur.Parent = game:GetService("Lighting")
        Window._blur = blur
    end

    -- ── Main Window Frame ───────────────────
    local win = New("Frame", {
        Name             = "Window",
        BackgroundColor3 = theme.Surface,
        BorderSizePixel  = 0,
        Position         = UDim2.new(0.5, -(winSize.X.Offset/2), 0.5, -(winSize.Y.Offset/2)),
        Size             = winSize,
        ClipsDescendants = true,
        Parent           = sg,
    })
    Corner(14, win)
    Window._win = win

    -- Drop shadow
    local shadow = New("ImageLabel", {
        Name  = "Shadow",
        BackgroundTransparency = 1,
        Image = "rbxassetid://6014261993",
        ImageColor3  = Color3.fromRGB(0,0,0),
        ImageTransparency = 0.5,
        Position = UDim2.new(0, -20, 0, -20),
        Size     = UDim2.new(1, 40, 1, 40),
        ZIndex   = -1,
        Parent   = win,
    })

    -- Border stroke
    local stroke = Instance.new("UIStroke")
    stroke.Color       = theme.Border
    stroke.Thickness   = 1
    stroke.Parent      = win

    -- ── Titlebar ────────────────────────────
    local titlebar = New("Frame", {
        Name             = "Titlebar",
        BackgroundColor3 = theme.Sidebar,
        BorderSizePixel  = 0,
        Size             = UDim2.new(1, 0, 0, 46),
        Parent           = win,
    })
    local tbStroke = Instance.new("UIStroke")
    tbStroke.Color     = theme.Border
    tbStroke.Thickness = 1
    tbStroke.Parent    = titlebar

    -- Window dots
    local dots = New("Frame", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 14, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        Size     = UDim2.new(0, 50, 0, 12),
        Parent   = titlebar,
    })
    ListLayout(dots, { FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0,6), VerticalAlignment = Enum.VerticalAlignment.Center })
    for _, c in pairs({ Color3.fromRGB(248,113,113), Color3.fromRGB(251,191,36), Color3.fromRGB(74,222,128) }) do
        New("Frame", { BackgroundColor3 = c, BorderSizePixel = 0, Size = UDim2.new(0,11,0,11), Parent = dots }, { Corner(6) })
    end

    -- Title text
    New("TextLabel", {
        Name             = "Title",
        BackgroundTransparency = 1,
        Text             = (options.Title or "Nova") .. "  ",
        TextColor3       = theme.Text,
        Font             = Enum.Font.GothamBold,
        TextSize         = 13,
        TextXAlignment   = Enum.TextXAlignment.Left,
        Position         = UDim2.new(0, 72, 0, 0),
        Size             = UDim2.new(0.5, 0, 1, 0),
        Parent           = titlebar,
    })

    -- SubTitle
    if options.SubTitle then
        New("TextLabel", {
            Name             = "SubTitle",
            BackgroundTransparency = 1,
            Text             = options.SubTitle,
            TextColor3       = theme.TextMuted,
            Font             = Enum.Font.Gotham,
            TextSize         = 10,
            TextXAlignment   = Enum.TextXAlignment.Right,
            Position         = UDim2.new(0.5, 0, 0, 0),
            Size             = UDim2.new(0.5, -14, 1, 0),
            Parent           = titlebar,
        })
    end

    MakeDraggable(titlebar, win)

    -- ── Body ────────────────────────────────
    local body = New("Frame", {
        Name             = "Body",
        BackgroundTransparency = 1,
        Position         = UDim2.new(0, 0, 0, 46),
        Size             = UDim2.new(1, 0, 1, -46),
        Parent           = win,
    })

    -- ── Tab Sidebar ──────────────────────────
    local sidebar = New("Frame", {
        Name             = "Sidebar",
        BackgroundColor3 = theme.Sidebar,
        BorderSizePixel  = 0,
        Size             = UDim2.new(0, tabW, 1, 0),
        Parent           = body,
    })
    local sbStroke = Instance.new("UIStroke")
    sbStroke.Color     = theme.Border
    sbStroke.Thickness = 1
    sbStroke.Parent    = sidebar

    local tabList = New("Frame", {
        BackgroundTransparency = 1,
        Size  = UDim2.new(1, 0, 1, 0),
        Parent = sidebar,
    })
    Padding(8, 8, 8, 8, tabList)
    ListLayout(tabList, { Padding = UDim.new(0, 4) })

    -- ── Content Area ─────────────────────────
    local contentArea = New("Frame", {
        Name             = "Content",
        BackgroundTransparency = 1,
        Position         = UDim2.new(0, tabW, 0, 0),
        Size             = UDim2.new(1, -tabW, 1, 0),
        ClipsDescendants = true,
        Parent           = body,
    })
    Window._contentArea = contentArea
    Window._tabList     = tabList
    Window._theme       = theme
    Window._stroke      = stroke

    -- ── Entrance animation ───────────────────
    win.Size = UDim2.fromOffset(winSize.X.Offset, 0)
    win.BackgroundTransparency = 1
    Tween(win, { Size = winSize, BackgroundTransparency = 0 }, 0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

    -- ── Minimize Keybind ─────────────────────
    local minimizeKey = options.MinimizeKey or Enum.KeyCode.LeftControl
    if options.MinimizeKeybind then
        minimizeKey = options.MinimizeKeybind
    end
    UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == minimizeKey then
            Window:ToggleVisibility()
        end
    end)

    table.insert(Nova.Windows, Window)
    return Window
end

-- ─── Toggle Window Visibility ─────────────
function Nova:ToggleVisibility()
    self._visible = not self._visible
    local win = self._win
    if self._visible then
        win.Visible = true
        Tween(win, { BackgroundTransparency = 0 }, 0.25)
    else
        local t = Tween(win, { BackgroundTransparency = 1 }, 0.2)
        t.Completed:Connect(function()
            win.Visible = false
        end)
    end
end

-- ─── Dialog ───────────────────────────────
function Nova:Dialog(options)
    local theme   = self._theme
    local sg      = self._sg
    local title   = options.Title   or "Dialog"
    local content = options.Content or ""
    local buttons = options.Buttons or {}

    -- Overlay
    local overlay = New("Frame", {
        BackgroundColor3     = Color3.fromRGB(0,0,0),
        BackgroundTransparency = 0.5,
        BorderSizePixel      = 0,
        Size                 = UDim2.new(1,0,1,0),
        ZIndex               = 10,
        Parent               = sg,
    })

    -- Box
    local box = New("Frame", {
        AnchorPoint      = Vector2.new(0.5, 0.5),
        BackgroundColor3 = theme.Surface,
        BorderSizePixel  = 0,
        Position         = UDim2.new(0.5, 0, 0.5, 0),
        Size             = UDim2.fromOffset(300, 0),
        AutomaticSize    = Enum.AutomaticSize.Y,
        ZIndex           = 11,
        Parent           = sg,
    })
    Corner(14, box)
    Padding(20, 20, 20, 20, box)
    ListLayout(box, { Padding = UDim.new(0, 10) })
    local bStroke = Instance.new("UIStroke")
    bStroke.Color  = theme.Accent
    bStroke.Thickness = 1
    bStroke.Parent = box

    -- Title
    New("TextLabel", {
        BackgroundTransparency = 1,
        Text           = title,
        TextColor3     = theme.Text,
        Font           = Enum.Font.GothamBold,
        TextSize       = 15,
        TextXAlignment = Enum.TextXAlignment.Left,
        Size           = UDim2.new(1, 0, 0, 20),
        ZIndex         = 11,
        Parent         = box,
    })

    -- Content
    New("TextLabel", {
        BackgroundTransparency = 1,
        Text           = content,
        TextColor3     = theme.TextDim,
        Font           = Enum.Font.Gotham,
        TextSize       = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped    = true,
        Size           = UDim2.new(1, 0, 0, 0),
        AutomaticSize  = Enum.AutomaticSize.Y,
        ZIndex         = 11,
        Parent         = box,
    })

    -- Button row
    local btnRow = New("Frame", {
        BackgroundTransparency = 1,
        Size          = UDim2.new(1, 0, 0, 34),
        ZIndex        = 11,
        Parent        = box,
    })
    local btnLayout = Instance.new("UIListLayout")
    btnLayout.FillDirection  = Enum.FillDirection.Horizontal
    btnLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    btnLayout.Padding        = UDim.new(0, 8)
    btnLayout.SortOrder      = Enum.SortOrder.LayoutOrder
    btnLayout.Parent         = btnRow

    local function closeDialog()
        overlay:Destroy()
        box:Destroy()
    end

    for i, btn in ipairs(buttons) do
        local isPrimary = (i == 1)
        local b = New("TextButton", {
            BackgroundColor3 = isPrimary and theme.Accent or theme.Surface2,
            BorderSizePixel  = 0,
            Size             = UDim2.fromOffset(90, 34),
            Text             = btn.Title or "OK",
            TextColor3       = isPrimary and Color3.fromRGB(255,255,255) or theme.TextDim,
            Font             = Enum.Font.GothamBold,
            TextSize         = 12,
            ZIndex           = 12,
            Parent           = btnRow,
        })
        Corner(8, b)
        if not isPrimary then
            local s = Instance.new("UIStroke")
            s.Color = theme.Border
            s.Thickness = 1
            s.Parent = b
        end
        b.MouseButton1Click:Connect(function()
            closeDialog()
            if btn.Callback then btn.Callback() end
        end)
        b.MouseEnter:Connect(function()
            Tween(b, { BackgroundColor3 = isPrimary and theme.AccentLight or theme.Border }, 0.15)
        end)
        b.MouseLeave:Connect(function()
            Tween(b, { BackgroundColor3 = isPrimary and theme.Accent or theme.Surface2 }, 0.15)
        end)
    end

    overlay.MouseButton1Click:Connect(closeDialog)

    -- Entrance
    box.Size = UDim2.fromOffset(300, 0)
    Tween(box, {}, 0.3, Enum.EasingStyle.Back)
end

-- ═══════════════════════════════════════════
--         ADD TAB
-- ═══════════════════════════════════════════
function Nova:AddTab(options)
    local theme    = self._theme
    local title    = options.Title or "Tab"
    local icon     = options.Icon  -- string name (unused in pure Lua, for extensibility)

    -- ── Tab Button ──────────────────────────
    local tabBtn = New("TextButton", {
        Name             = "Tab_" .. title,
        BackgroundColor3 = theme.Sidebar,
        BorderSizePixel  = 0,
        Size             = UDim2.new(1, 0, 0, 36),
        Text             = "",
        AutoButtonColor  = false,
        Parent           = self._tabList,
    })
    Corner(9, tabBtn)
    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color     = theme.Border
    btnStroke.Thickness = 1
    btnStroke.Transparency = 1  -- hidden by default
    btnStroke.Parent    = tabBtn

    -- Accent bar (left side)
    local accentBar = New("Frame", {
        BackgroundColor3 = theme.Accent,
        BorderSizePixel  = 0,
        Position         = UDim2.new(0, 0, 0.1, 0),
        Size             = UDim2.new(0, 3, 0.8, 0),
        Parent           = tabBtn,
    }, { Corner(2) })
    accentBar.Visible = false

    -- Label
    local label = New("TextLabel", {
        BackgroundTransparency = 1,
        Text           = title,
        TextColor3     = theme.TextDim,
        Font           = Enum.Font.GothamMedium,
        TextSize       = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        Position       = UDim2.new(0, 14, 0, 0),
        Size           = UDim2.new(1, -14, 1, 0),
        Parent         = tabBtn,
    })

    -- ── Content ScrollFrame ──────────────────
    local scroll = New("ScrollingFrame", {
        Name                   = "Panel_" .. title,
        BackgroundTransparency = 1,
        BorderSizePixel        = 0,
        Position               = UDim2.new(0, 0, 0, 0),
        Size                   = UDim2.new(1, 0, 1, 0),
        ScrollBarThickness     = 3,
        ScrollBarImageColor3   = theme.Border,
        CanvasSize             = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize    = Enum.AutomaticSize.Y,
        Visible                = false,
        Parent                 = self._contentArea,
    })
    Padding(12, 14, 12, 14, scroll)
    ListLayout(scroll, { Padding = UDim.new(0, 8) })

    local Tab = { _window = self, _scroll = scroll, _theme = theme }
    setmetatable(Tab, { __index = self })

    -- ── Activate/Deactivate ──────────────────
    local function activate()
        -- deactivate old
        if self._activeTab then
            local old = self._activeTab
            Tween(old._btn, { BackgroundColor3 = theme.Sidebar }, 0.15)
            Tween(old._label, { TextColor3 = theme.TextDim }, 0.15)
            old._bar.Visible  = false
            old._btnStroke.Transparency = 1
            old._scroll.Visible = false
        end
        self._activeTab    = Tab
        Tab._scroll.Visible = true
        Tween(tabBtn, { BackgroundColor3 = Color3.fromRGB(
            math.clamp(theme.Accent.R * 255 * 0.12, 0, 255) / 255,
            math.clamp(theme.Accent.G * 255 * 0.08, 0, 255) / 255,
            math.clamp(theme.Accent.B * 255 * 0.15, 0, 255) / 255
        )}, 0.15)
        Tween(label, { TextColor3 = theme.AccentLight }, 0.15)
        accentBar.Visible   = true
        btnStroke.Transparency = 0.5
    end

    Tab._btn      = tabBtn
    Tab._label    = label
    Tab._bar      = accentBar
    Tab._btnStroke = btnStroke

    tabBtn.MouseButton1Click:Connect(activate)
    tabBtn.MouseEnter:Connect(function()
        if self._activeTab ~= Tab then
            Tween(tabBtn, { BackgroundColor3 = theme.Surface2 }, 0.12)
            Tween(label, { TextColor3 = theme.Text }, 0.12)
        end
    end)
    tabBtn.MouseLeave:Connect(function()
        if self._activeTab ~= Tab then
            Tween(tabBtn, { BackgroundColor3 = theme.Sidebar }, 0.12)
            Tween(label, { TextColor3 = theme.TextDim }, 0.12)
        end
    end)

    table.insert(self._tabs, Tab)
    table.insert(self._tabBtns, tabBtn)

    -- Auto-activate first tab
    if #self._tabs == 1 then
        activate()
    end

    return Tab
end

-- ═══════════════════════════════════════════
--         SELECT TAB (by index or ref)
-- ═══════════════════════════════════════════
function Nova:SelectTab(index)
    local tab = self._tabs[index]
    if tab then
        tab._btn.MouseButton1Click:Fire()
    end
end

-- ═══════════════════════════════════════════
--         ELEMENT HELPERS
-- ═══════════════════════════════════════════
local function MakeElemBase(tab, title, description)
    local theme = tab._theme
    local frame = New("Frame", {
        BackgroundColor3 = theme.Surface2,
        BorderSizePixel  = 0,
        Size             = UDim2.new(1, 0, 0, 0),
        AutomaticSize    = Enum.AutomaticSize.Y,
        Parent           = tab._scroll,
    })
    Corner(10, frame)
    local fStroke = Instance.new("UIStroke")
    fStroke.Color     = theme.Border
    fStroke.Thickness = 1
    fStroke.Parent    = frame

    Padding(11, 13, 11, 13, frame)

    local innerRow = New("Frame", {
        BackgroundTransparency = 1,
        Size          = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        Parent        = frame,
    })
    ListLayout(innerRow, {
        FillDirection        = Enum.FillDirection.Horizontal,
        VerticalAlignment    = Enum.VerticalAlignment.Center,
        HorizontalAlignment  = Enum.HorizontalAlignment.Left,
    })

    -- Info column
    local info = New("Frame", {
        BackgroundTransparency = 1,
        Size          = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        Parent        = innerRow,
        LayoutOrder   = 1,
    })
    ListLayout(info, { Padding = UDim.new(0, 2) })

    New("TextLabel", {
        BackgroundTransparency = 1,
        Text           = title or "",
        TextColor3     = theme.Text,
        Font           = Enum.Font.GothamBold,
        TextSize       = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        Size           = UDim2.new(1, 0, 0, 16),
        Parent         = info,
    })

    if description then
        New("TextLabel", {
            BackgroundTransparency = 1,
            Text           = description,
            TextColor3     = theme.TextDim,
            Font           = Enum.Font.Gotham,
            TextSize       = 10,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped    = true,
            Size           = UDim2.new(1, 0, 0, 0),
            AutomaticSize  = Enum.AutomaticSize.Y,
            Parent         = info,
        })
    end

    -- Hover effect
    local mEnter = frame.MouseEnter
    local mLeave = frame.MouseLeave
    if mEnter then
        mEnter:Connect(function()
            Tween(fStroke, { Color = theme.Accent }, 0.15)
        end)
        mLeave:Connect(function()
            Tween(fStroke, { Color = theme.Border }, 0.15)
        end)
    end

    return frame, innerRow, info, fStroke
end

-- ═══════════════════════════════════════════
--         PARAGRAPH
-- ═══════════════════════════════════════════
function Nova:AddParagraph(options)
    local theme = self._theme
    local frame = New("Frame", {
        BackgroundColor3 = theme.Surface2,
        BorderSizePixel  = 0,
        Size             = UDim2.new(1, 0, 0, 0),
        AutomaticSize    = Enum.AutomaticSize.Y,
        Parent           = self._scroll,
    })
    Corner(10, frame)
    Padding(11, 13, 11, 13, frame)

    -- Left accent border
    New("Frame", {
        BackgroundColor3 = theme.Accent,
        BorderSizePixel  = 0,
        Size             = UDim2.new(0, 3, 1, 0),
        Position         = UDim2.new(0, 0, 0, 0),
        Parent           = frame,
    }, { Corner(2) })

    local inner = New("Frame", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 0),
        Size     = UDim2.new(1, -10, 1, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        Parent   = frame,
    })
    ListLayout(inner, { Padding = UDim.new(0, 5) })

    New("TextLabel", {
        BackgroundTransparency = 1,
        Text           = options.Title or "",
        TextColor3     = theme.AccentLight,
        Font           = Enum.Font.GothamBold,
        TextSize       = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        Size           = UDim2.new(1, 0, 0, 16),
        Parent         = inner,
    })

    New("TextLabel", {
        BackgroundTransparency = 1,
        Text           = options.Content or "",
        TextColor3     = theme.TextDim,
        Font           = Enum.Font.Gotham,
        TextSize       = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped    = true,
        Size           = UDim2.new(1, 0, 0, 0),
        AutomaticSize  = Enum.AutomaticSize.Y,
        Parent         = inner,
    })
end

-- ═══════════════════════════════════════════
--         BUTTON
-- ═══════════════════════════════════════════
function Nova:AddButton(options)
    local theme    = self._theme
    local frame, row, info = MakeElemBase(self, options.Title, options.Description)

    -- Shrink info to leave room for button
    info.Size = UDim2.new(1, -110, 0, 0)

    local btn = New("TextButton", {
        BackgroundColor3 = theme.Accent,
        BorderSizePixel  = 0,
        Size             = UDim2.fromOffset(100, 32),
        Text             = options.Title or "Click",
        TextColor3       = Color3.fromRGB(255, 255, 255),
        Font             = Enum.Font.GothamBold,
        TextSize         = 12,
        AutoButtonColor  = false,
        LayoutOrder      = 2,
        Parent           = row,
    })
    Corner(8, btn)

    btn.MouseEnter:Connect(function()
        Tween(btn, { BackgroundColor3 = theme.AccentLight, Size = UDim2.fromOffset(100, 34) }, 0.15)
    end)
    btn.MouseLeave:Connect(function()
        Tween(btn, { BackgroundColor3 = theme.Accent, Size = UDim2.fromOffset(100, 32) }, 0.15)
    end)
    btn.MouseButton1Click:Connect(function()
        Tween(btn, { Size = UDim2.fromOffset(96, 30) }, 0.08)
        task.delay(0.1, function()
            Tween(btn, { Size = UDim2.fromOffset(100, 32) }, 0.1)
        end)
        if options.Callback then options.Callback() end
    end)

    local Element = {}
    function Element:SetText(text) btn.Text = text end
    return Element
end

-- ═══════════════════════════════════════════
--         TOGGLE
-- ═══════════════════════════════════════════
function Nova:AddToggle(index, options)
    local theme   = self._theme
    local frame, row, info = MakeElemBase(self, options.Title, options.Description)
    info.Size = UDim2.new(1, -56, 0, 0)

    local value = options.Default or false

    -- Track background
    local track = New("Frame", {
        BackgroundColor3 = value and theme.Accent or theme.Border,
        BorderSizePixel  = 0,
        Size             = UDim2.fromOffset(44, 24),
        LayoutOrder      = 2,
        Parent           = row,
    })
    Corner(12, track)
    if value then
        local gs = Instance.new("UIStroke")
        gs.Color = theme.Accent
        gs.Thickness = 1
        gs.Parent = track
        track._stroke = gs
    end

    -- Knob
    local knob = New("Frame", {
        AnchorPoint      = Vector2.new(0.5, 0.5),
        BackgroundColor3 = value and Color3.fromRGB(255,255,255) or theme.TextDim,
        BorderSizePixel  = 0,
        Position         = value and UDim2.new(0, 34, 0.5, 0) or UDim2.new(0, 14, 0.5, 0),
        Size             = UDim2.fromOffset(16, 16),
        Parent           = track,
    })
    Corner(8, knob)

    -- Option object
    local opt = { Value = value }
    Nova.Options[index] = opt
    local callbacks = {}

    local function toggle()
        value = not value
        opt.Value = value
        Tween(knob, { Position = value and UDim2.new(0, 34, 0.5, 0) or UDim2.new(0, 14, 0.5, 0) }, 0.2, Enum.EasingStyle.Back)
        Tween(track, { BackgroundColor3 = value and theme.Accent or theme.Border }, 0.2)
        Tween(knob,  { BackgroundColor3 = value and Color3.fromRGB(255,255,255) or theme.TextDim }, 0.15)
        for _, cb in pairs(callbacks) do cb() end
    end

    local btn = New("TextButton", {
        BackgroundTransparency = 1,
        Text   = "",
        Size   = UDim2.new(1, 0, 1, 0),
        Parent = track,
    })
    btn.MouseButton1Click:Connect(toggle)
    frame.MouseButton1Click = btn.MouseButton1Click  -- allow frame click too

    local Element = {}
    function Element:OnChanged(cb) table.insert(callbacks, cb) end
    function Element:SetValue(v)
        if v ~= value then toggle() end
    end
    function Element:GetValue() return value end

    if options.Callback then
        Element:OnChanged(function() options.Callback(value) end)
    end

    return Element
end

-- ═══════════════════════════════════════════
--         SLIDER
-- ═══════════════════════════════════════════
function Nova:AddSlider(index, options)
    local theme   = self._theme
    local min     = options.Min      or 0
    local max     = options.Max      or 100
    local default = options.Default  or min
    local round   = options.Rounding or 0
    local value   = default

    local frame = New("Frame", {
        BackgroundColor3 = theme.Surface2,
        BorderSizePixel  = 0,
        Size             = UDim2.new(1, 0, 0, 0),
        AutomaticSize    = Enum.AutomaticSize.Y,
        Parent           = self._scroll,
    })
    Corner(10, frame)
    Padding(11, 13, 13, 13, frame)
    ListLayout(frame, { Padding = UDim.new(0, 8) })

    local fStroke = Instance.new("UIStroke")
    fStroke.Color = theme.Border; fStroke.Thickness = 1; fStroke.Parent = frame

    -- Header row
    local headerRow = New("Frame", {
        BackgroundTransparency = 1,
        Size  = UDim2.new(1, 0, 0, 20),
        Parent = frame,
    })
    New("TextLabel", {
        BackgroundTransparency = 1,
        Text  = options.Title or "Slider",
        TextColor3 = theme.Text,
        Font  = Enum.Font.GothamBold,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        Size  = UDim2.new(1, -60, 1, 0),
        Parent = headerRow,
    })
    local valLabel = New("TextLabel", {
        BackgroundTransparency = 1,
        Text  = tostring(value),
        TextColor3 = theme.AccentLight,
        Font  = Enum.Font.GothamBold,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Right,
        Size  = UDim2.new(0, 60, 1, 0),
        Position = UDim2.new(1, -60, 0, 0),
        Parent = headerRow,
    })

    if options.Description then
        New("TextLabel", {
            BackgroundTransparency = 1,
            Text  = options.Description,
            TextColor3 = theme.TextDim,
            Font  = Enum.Font.Gotham,
            TextSize = 10,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            Size  = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            Parent = frame,
        })
    end

    -- Track
    local track = New("Frame", {
        BackgroundColor3 = theme.Border,
        BorderSizePixel  = 0,
        Size             = UDim2.new(1, 0, 0, 4),
        Parent           = frame,
    })
    Corner(2, track)

    -- Fill
    local fillPct = (default - min) / (max - min)
    local fill = New("Frame", {
        BackgroundColor3 = theme.Accent,
        BorderSizePixel  = 0,
        Size             = UDim2.new(fillPct, 0, 1, 0),
        Parent           = track,
    }, { Corner(2) })

    -- Glow on fill
    local glow = New("ImageLabel", {
        BackgroundTransparency = 1,
        Image = "rbxassetid://6014261993",
        ImageColor3 = theme.Accent,
        ImageTransparency = 0.7,
        Position = UDim2.new(0, -8, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        Size = UDim2.new(1, 16, 0, 16),
        ZIndex = -1,
        Parent = fill,
    })

    -- Knob
    local knob = New("Frame", {
        AnchorPoint      = Vector2.new(0.5, 0.5),
        BackgroundColor3 = theme.Accent,
        BorderSizePixel  = 0,
        Position         = UDim2.new(fillPct, 0, 0.5, 0),
        Size             = UDim2.fromOffset(14, 14),
        ZIndex           = 2,
        Parent           = track,
    })
    Corner(7, knob)

    -- Option object
    local opt = { Value = value }
    Nova.Options[index] = opt
    local callbacks = {}

    local function updateValue(pct)
        pct   = math.clamp(pct, 0, 1)
        local raw = min + (max - min) * pct
        local mult = 10 ^ round
        value = math.round(raw * mult) / mult
        opt.Value = value
        valLabel.Text = tostring(value)
        Tween(fill,  { Size     = UDim2.new(pct, 0, 1, 0) }, 0.05, Enum.EasingStyle.Linear)
        Tween(knob,  { Position = UDim2.new(pct, 0, 0.5, 0) }, 0.05, Enum.EasingStyle.Linear)
        for _, cb in pairs(callbacks) do cb(value) end
    end

    -- Drag
    local dragging = false
    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            local rel = (input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X
            updateValue(rel)
        end
    end)
    track.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local rel = (input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X
            updateValue(rel)
        end
    end)

    track.MouseEnter:Connect(function() Tween(knob, { Size = UDim2.fromOffset(16, 16) }, 0.1) end)
    track.MouseLeave:Connect(function()
        if not dragging then Tween(knob, { Size = UDim2.fromOffset(14, 14) }, 0.1) end
    end)

    local Element = {}
    function Element:OnChanged(cb) table.insert(callbacks, cb) end
    function Element:SetValue(v)
        local pct = (v - min) / (max - min)
        updateValue(pct)
    end
    function Element:GetValue() return value end

    if options.Callback then
        Element:OnChanged(options.Callback)
    end

    return Element
end

-- ═══════════════════════════════════════════
--         DROPDOWN
-- ═══════════════════════════════════════════
function Nova:AddDropdown(index, options)
    local theme   = self._theme
    local values  = options.Values  or {}
    local multi   = options.Multi   or false
    local default = options.Default

    local frame, row, info = MakeElemBase(self, options.Title, options.Description)
    info.Size = UDim2.new(1, -136, 0, 0)

    -- Selected value(s)
    local selected
    if multi then
        selected = {}
        if type(default) == "table" then
            for _, v in pairs(default) do selected[v] = true end
        end
    else
        selected = type(default) == "number" and values[default] or (type(default) == "string" and default or values[1])
    end

    -- Button
    local ddBtn = New("TextButton", {
        BackgroundColor3 = theme.Surface,
        BorderSizePixel  = 0,
        Size             = UDim2.fromOffset(126, 30),
        Text             = "",
        AutoButtonColor  = false,
        LayoutOrder      = 2,
        Parent           = row,
    })
    Corner(7, ddBtn)
    local ddStroke = Instance.new("UIStroke")
    ddStroke.Color = theme.Border; ddStroke.Thickness = 1; ddStroke.Parent = ddBtn

    local ddLabel = New("TextLabel", {
        BackgroundTransparency = 1,
        Text  = multi and "Select..." or (selected or "Select..."),
        TextColor3 = theme.Text,
        Font  = Enum.Font.Gotham,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
        Position = UDim2.new(0, 10, 0, 0),
        Size = UDim2.new(1, -26, 1, 0),
        ClipsDescendants = true,
        Parent = ddBtn,
    })

    -- Arrow
    New("TextLabel", {
        BackgroundTransparency = 1,
        Text  = "▾",
        TextColor3 = theme.TextDim,
        Font  = Enum.Font.Gotham,
        TextSize = 14,
        Position = UDim2.new(1, -22, 0, 0),
        Size = UDim2.new(0, 18, 1, 0),
        Parent = ddBtn,
    })

    -- Dropdown list (outside frame, in scroll)
    local listFrame = New("Frame", {
        BackgroundColor3 = theme.Surface,
        BorderSizePixel  = 0,
        Size             = UDim2.new(1, 0, 0, 0),
        Visible          = false,
        ClipsDescendants = true,
        ZIndex           = 5,
        Parent           = self._scroll,
    })
    Corner(9, listFrame)
    local lsStroke = Instance.new("UIStroke")
    lsStroke.Color = theme.Accent; lsStroke.Thickness = 1; lsStroke.Parent = listFrame
    Padding(5, 5, 5, 5, listFrame)
    local listLayout = ListLayout(listFrame, { Padding = UDim.new(0, 3) })

    local opt = { Value = selected }
    Nova.Options[index] = opt
    local callbacks = {}
    local isOpen = false

    local function updateLabel()
        if multi then
            local parts = {}
            for v, s in pairs(selected) do if s then table.insert(parts, v) end end
            ddLabel.Text = #parts > 0 and table.concat(parts, ", ") or "Select..."
        else
            ddLabel.Text = selected or "Select..."
        end
    end

    -- Build items
    local itemBtns = {}
    for _, v in ipairs(values) do
        local item = New("TextButton", {
            BackgroundColor3 = theme.Surface,
            BorderSizePixel  = 0,
            Size             = UDim2.new(1, 0, 0, 30),
            Text             = "",
            AutoButtonColor  = false,
            ZIndex           = 6,
            Parent           = listFrame,
        })
        Corner(6, item)
        local iLabel = New("TextLabel", {
            BackgroundTransparency = 1,
            Text  = v,
            TextColor3 = theme.TextDim,
            Font  = Enum.Font.Gotham,
            TextSize = 11,
            TextXAlignment = Enum.TextXAlignment.Left,
            Position = UDim2.new(0, 10, 0, 0),
            Size = UDim2.new(1, -10, 1, 0),
            ZIndex = 6,
            Parent = item,
        })

        local function isSelected()
            if multi then return selected[v] else return selected == v end
        end
        local function refreshItem()
            if isSelected() then
                Tween(item,   { BackgroundColor3 = theme.AccentGlow }, 0.1)
                Tween(iLabel, { TextColor3 = theme.AccentLight }, 0.1)
            else
                Tween(item,   { BackgroundColor3 = theme.Surface }, 0.1)
                Tween(iLabel, { TextColor3 = theme.TextDim }, 0.1)
            end
        end
        refreshItem()

        item.MouseEnter:Connect(function()
            if not isSelected() then
                Tween(item, { BackgroundColor3 = theme.Surface2 }, 0.1)
            end
        end)
        item.MouseLeave:Connect(function() refreshItem() end)

        item.MouseButton1Click:Connect(function()
            if multi then
                selected[v] = not selected[v]
                refreshItem()
                opt.Value = selected
            else
                selected = v
                opt.Value = v
                for _, ib in pairs(itemBtns) do ib.refresh() end
            end
            updateLabel()
            for _, cb in pairs(callbacks) do cb(opt.Value) end
        end)

        table.insert(itemBtns, { refresh = refreshItem })
    end

    -- Compute list height
    local listH = math.min(#values * 33 + 10, 180)

    local function toggleList()
        isOpen = not isOpen
        listFrame.Visible = isOpen
        if isOpen then
            Tween(listFrame, { Size = UDim2.new(1, 0, 0, listH) }, 0.2, Enum.EasingStyle.Back)
            Tween(ddStroke, { Color = theme.Accent }, 0.15)
        else
            Tween(listFrame, { Size = UDim2.new(1, 0, 0, 0) }, 0.15)
            Tween(ddStroke, { Color = theme.Border }, 0.15)
        end
    end

    ddBtn.MouseButton1Click:Connect(toggleList)

    local Element = {}
    function Element:OnChanged(cb) table.insert(callbacks, cb) end
    function Element:SetValue(v)
        if multi then
            if type(v) == "table" then
                for key, state in pairs(v) do selected[key] = state end
                for _, ib in pairs(itemBtns) do ib.refresh() end
                opt.Value = selected
                updateLabel()
            end
        else
            selected = v; opt.Value = v
            for _, ib in pairs(itemBtns) do ib.refresh() end
            updateLabel()
        end
    end
    function Element:GetValue() return opt.Value end

    if options.Callback then
        Element:OnChanged(options.Callback)
    end

    return Element
end

-- ═══════════════════════════════════════════
--         COLORPICKER
-- ═══════════════════════════════════════════
function Nova:AddColorpicker(index, options)
    local theme       = self._theme
    local default     = options.Default or Color3.fromRGB(255, 255, 255)
    local transparency = options.Transparency or nil
    local value       = default

    local frame, row, info = MakeElemBase(self, options.Title, options.Description)
    info.Size = UDim2.new(1, -44, 0, 0)

    -- Swatch button
    local swatch = New("TextButton", {
        BackgroundColor3 = value,
        BorderSizePixel  = 0,
        Size             = UDim2.fromOffset(34, 34),
        Text             = "",
        AutoButtonColor  = false,
        LayoutOrder      = 2,
        Parent           = row,
    })
    Corner(8, swatch)
    local swStroke = Instance.new("UIStroke")
    swStroke.Color = theme.Border; swStroke.Thickness = 2; swStroke.Parent = swatch

    local opt = { Value = value, Transparency = transparency or 0 }
    Nova.Options[index] = opt
    local callbacks = {}

    -- Simple color picker popup
    local pickerOpen = false
    local pickerFrame

    local function openPicker()
        if pickerOpen then
            pickerFrame:Destroy()
            pickerOpen = false
            return
        end
        pickerOpen = true

        pickerFrame = New("Frame", {
            BackgroundColor3 = theme.Surface,
            BorderSizePixel  = 0,
            Position         = UDim2.new(0, 0, 1, 6),
            Size             = UDim2.fromOffset(220, transparency ~= nil and 100 or 74),
            ZIndex           = 10,
            Parent           = frame,
        })
        Corner(10, pickerFrame)
        local ps = Instance.new("UIStroke")
        ps.Color = theme.Accent; ps.Thickness = 1; ps.Parent = pickerFrame
        Padding(10, 10, 10, 10, pickerFrame)
        ListLayout(pickerFrame, { Padding = UDim.new(0, 8) })

        -- RGB sliders
        local channels = {
            { label = "R", color = Color3.fromRGB(255,80,80),  getter = function() return math.round(value.R * 255) end },
            { label = "G", color = Color3.fromRGB(80,220,80),  getter = function() return math.round(value.G * 255) end },
            { label = "B", color = Color3.fromRGB(80,150,255), getter = function() return math.round(value.B * 255) end },
        }

        local function rebuild()
            swatch.BackgroundColor3 = value
            opt.Value = value
            for _, cb in pairs(callbacks) do cb() end
        end

        for _, ch in ipairs(channels) do
            local row2 = New("Frame", { BackgroundTransparency=1, Size=UDim2.new(1,0,0,14), Parent=pickerFrame })
            ListLayout(row2, { FillDirection=Enum.FillDirection.Horizontal, VerticalAlignment=Enum.VerticalAlignment.Center, Padding=UDim.new(0,6) })
            New("TextLabel", { BackgroundTransparency=1, Text=ch.label, TextColor3=ch.color, Font=Enum.Font.GothamBold, TextSize=11, Size=UDim2.fromOffset(10,14), ZIndex=10, Parent=row2 })
            local tr = New("Frame", { BackgroundColor3=theme.Border, BorderSizePixel=0, Size=UDim2.new(1,-40,0,4), ZIndex=10, Parent=row2 }, { Corner(2) })
            local curVal = ch.getter()
            local tf = New("Frame", { BackgroundColor3=ch.color, BorderSizePixel=0, Size=UDim2.new(curVal/255,0,1,0), ZIndex=10, Parent=tr }, { Corner(2) })
            local vl = New("TextLabel", { BackgroundTransparency=1, Text=tostring(curVal), TextColor3=theme.TextDim, Font=Enum.Font.Gotham, TextSize=10, Size=UDim2.fromOffset(24,14), ZIndex=10, Parent=row2 })

            local drag2 = false
            tr.InputBegan:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                    drag2 = true
                    local pct = math.clamp((inp.Position.X - tr.AbsolutePosition.X) / tr.AbsoluteSize.X, 0, 1)
                    local newVal = math.round(pct * 255)
                    tf.Size = UDim2.new(pct, 0, 1, 0)
                    vl.Text = tostring(newVal)
                    value = Color3.fromRGB(
                        ch.label == "R" and newVal or math.round(value.R*255),
                        ch.label == "G" and newVal or math.round(value.G*255),
                        ch.label == "B" and newVal or math.round(value.B*255)
                    )
                    rebuild()
                end
            end)
            tr.InputEnded:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 then drag2 = false end
            end)
            UserInputService.InputChanged:Connect(function(inp)
                if drag2 and inp.UserInputType == Enum.UserInputType.MouseMovement then
                    local pct = math.clamp((inp.Position.X - tr.AbsolutePosition.X) / tr.AbsoluteSize.X, 0, 1)
                    local newVal = math.round(pct * 255)
                    tf.Size = UDim2.new(pct, 0, 1, 0)
                    vl.Text = tostring(newVal)
                    value = Color3.fromRGB(
                        ch.label == "R" and newVal or math.round(value.R*255),
                        ch.label == "G" and newVal or math.round(value.G*255),
                        ch.label == "B" and newVal or math.round(value.B*255)
                    )
                    rebuild()
                end
            end)
        end

        -- Transparency slider (optional)
        if transparency ~= nil then
            local trow = New("Frame", { BackgroundTransparency=1, Size=UDim2.new(1,0,0,14), Parent=pickerFrame })
            ListLayout(trow, { FillDirection=Enum.FillDirection.Horizontal, VerticalAlignment=Enum.VerticalAlignment.Center, Padding=UDim.new(0,6) })
            New("TextLabel", { BackgroundTransparency=1, Text="A", TextColor3=theme.TextDim, Font=Enum.Font.GothamBold, TextSize=11, Size=UDim2.fromOffset(10,14), ZIndex=10, Parent=trow })
            local tr2 = New("Frame", { BackgroundColor3=theme.Border, BorderSizePixel=0, Size=UDim2.new(1,-40,0,4), ZIndex=10, Parent=trow }, { Corner(2) })
            local tf2 = New("Frame", { BackgroundColor3=theme.AccentLight, BorderSizePixel=0, Size=UDim2.new(1-transparency,0,1,0), ZIndex=10, Parent=tr2 }, { Corner(2) })
            local vl2 = New("TextLabel", { BackgroundTransparency=1, Text=tostring(transparency), TextColor3=theme.TextDim, Font=Enum.Font.Gotham, TextSize=10, Size=UDim2.fromOffset(24,14), ZIndex=10, Parent=trow })

            local drag3 = false
            tr2.InputBegan:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                    drag3 = true
                    local pct = math.clamp((inp.Position.X - tr2.AbsolutePosition.X) / tr2.AbsoluteSize.X, 0, 1)
                    transparency = math.round((1 - pct) * 100) / 100
                    opt.Transparency = transparency
                    tf2.Size = UDim2.new(pct, 0, 1, 0)
                    vl2.Text = tostring(transparency)
                    for _, cb in pairs(callbacks) do cb() end
                end
            end)
            tr2.InputEnded:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 then drag3 = false end
            end)
        end
    end

    swatch.MouseButton1Click:Connect(openPicker)
    swatch.MouseEnter:Connect(function() Tween(swStroke, { Color = theme.Accent }, 0.15) end)
    swatch.MouseLeave:Connect(function() Tween(swStroke, { Color = theme.Border }, 0.15) end)

    local Element = {}
    function Element:OnChanged(cb) table.insert(callbacks, cb) end
    function Element:SetValueRGB(color)
        value = color; swatch.BackgroundColor3 = color
        opt.Value = color
    end

    if options.Callback then
        Element:OnChanged(options.Callback)
    end

    return Element
end

-- ═══════════════════════════════════════════
--         KEYBIND
-- ═══════════════════════════════════════════
function Nova:AddKeybind(index, options)
    local theme   = self._theme
    local mode    = options.Mode    or "Toggle"  -- Always | Toggle | Hold
    local default = options.Default or "None"
    local currentKey = default

    local frame, row, info = MakeElemBase(self, options.Title, options.Description)
    info.Size = UDim2.new(1, -110, 0, 0)

    local kbBtn = New("TextButton", {
        BackgroundColor3 = theme.Surface,
        BorderSizePixel  = 0,
        Size             = UDim2.fromOffset(100, 30),
        Text             = "[" .. currentKey .. "]",
        TextColor3       = theme.AccentLight,
        Font             = Enum.Font.GothamBold,
        TextSize         = 11,
        AutoButtonColor  = false,
        LayoutOrder      = 2,
        Parent           = row,
    })
    Corner(7, kbBtn)
    local kbStroke = Instance.new("UIStroke")
    kbStroke.Color = theme.Border; kbStroke.Thickness = 1; kbStroke.Parent = kbBtn

    local opt = { Value = currentKey }
    Nova.Options[index] = opt
    local state = false
    local listening = false
    local clickCallbacks   = {}
    local changeCallbacks  = {}

    local function setListening(v)
        listening = v
        if v then
            kbBtn.Text = "..."
            Tween(kbStroke, { Color = Color3.fromRGB(251,191,36) }, 0.15)
            Tween(kbBtn, { TextColor3 = Color3.fromRGB(251,191,36) }, 0.15)
        else
            kbBtn.Text = "[" .. currentKey .. "]"
            Tween(kbStroke, { Color = theme.Border }, 0.15)
            Tween(kbBtn, { TextColor3 = theme.AccentLight }, 0.15)
        end
    end

    kbBtn.MouseButton1Click:Connect(function()
        setListening(not listening)
    end)

    UserInputService.InputBegan:Connect(function(input, gpe)
        if listening then
            local keyName = input.KeyCode ~= Enum.KeyCode.Unknown and input.KeyCode.Name
                or (input.UserInputType == Enum.UserInputType.MouseButton1 and "MB1")
                or (input.UserInputType == Enum.UserInputType.MouseButton2 and "MB2")
                or nil
            if keyName then
                currentKey = keyName
                opt.Value  = keyName
                setListening(false)
                for _, cb in pairs(changeCallbacks) do cb(input.KeyCode) end
            end
        elseif not gpe then
            local keyName = input.KeyCode ~= Enum.KeyCode.Unknown and input.KeyCode.Name or nil
            if keyName == currentKey then
                if mode == "Toggle" then
                    state = not state
                    if options.Callback then options.Callback(state) end
                    for _, cb in pairs(clickCallbacks) do cb() end
                elseif mode == "Hold" then
                    state = true
                    if options.Callback then options.Callback(true) end
                elseif mode == "Always" then
                    if options.Callback then options.Callback(true) end
                end
            end
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if mode == "Hold" then
            local keyName = input.KeyCode ~= Enum.KeyCode.Unknown and input.KeyCode.Name or nil
            if keyName == currentKey then
                state = false
                if options.Callback then options.Callback(false) end
            end
        end
    end)

    kbBtn.MouseEnter:Connect(function() Tween(kbStroke, { Color = theme.Accent }, 0.15) end)
    kbBtn.MouseLeave:Connect(function()
        if not listening then Tween(kbStroke, { Color = theme.Border }, 0.15) end
    end)

    local Element = {}
    function Element:OnClick(cb)   table.insert(clickCallbacks, cb) end
    function Element:OnChanged(cb) table.insert(changeCallbacks, cb) end
    function Element:GetState()    return state end
    function Element:SetValue(key, m)
        currentKey = key; opt.Value = key
        mode = m or mode
        kbBtn.Text = "[" .. key .. "]"
    end

    if options.ChangedCallback then
        Element:OnChanged(options.ChangedCallback)
    end

    return Element
end

-- ═══════════════════════════════════════════
--         INPUT
-- ═══════════════════════════════════════════
function Nova:AddInput(index, options)
    local theme   = self._theme
    local numeric = options.Numeric  or false
    local finished = options.Finished or false

    local frame, row, info = MakeElemBase(self, options.Title, options.Description)
    info.Size = UDim2.new(1, -150, 0, 0)

    local box = New("TextBox", {
        BackgroundColor3  = theme.Surface,
        BorderSizePixel   = 0,
        Size              = UDim2.fromOffset(140, 30),
        Text              = options.Default or "",
        PlaceholderText   = options.Placeholder or "",
        TextColor3        = theme.Text,
        PlaceholderColor3 = theme.TextMuted,
        Font              = Enum.Font.Gotham,
        TextSize          = 11,
        TextXAlignment    = Enum.TextXAlignment.Left,
        ClearTextOnFocus  = false,
        LayoutOrder       = 2,
        Parent            = row,
    })
    Corner(7, box)
    Padding(0, 10, 0, 10, box)
    local bxStroke = Instance.new("UIStroke")
    bxStroke.Color = theme.Border; bxStroke.Thickness = 1; bxStroke.Parent = box

    local opt = { Value = box.Text }
    Nova.Options[index] = opt
    local callbacks = {}
    local changedCbs = {}

    box.Focused:Connect(function()
        Tween(bxStroke, { Color = theme.Accent }, 0.15)
    end)
    box.FocusLost:Connect(function(enter)
        Tween(bxStroke, { Color = theme.Border }, 0.15)
        if finished and enter then
            if numeric then
                local n = tonumber(box.Text)
                if n then opt.Value = n; for _, cb in pairs(callbacks) do cb(n) end end
            else
                opt.Value = box.Text
                for _, cb in pairs(callbacks) do cb(box.Text) end
            end
        end
    end)

    if not finished then
        box:GetPropertyChangedSignal("Text"):Connect(function()
            if numeric then
                box.Text = box.Text:gsub("[^%d%.%-]", "")
            end
            opt.Value = box.Text
            for _, cb in pairs(changedCbs) do cb() end
            if options.Callback then options.Callback(box.Text) end
        end)
    end

    local Element = {}
    function Element:OnChanged(cb) table.insert(changedCbs, cb) end
    function Element:SetValue(v)   box.Text = tostring(v); opt.Value = v end
    function Element:GetValue()    return opt.Value end

    return Element
end

-- ═══════════════════════════════════════════
--         LABEL (section header)
-- ═══════════════════════════════════════════
function Nova:AddLabel(text)
    local theme = self._theme
    New("TextLabel", {
        BackgroundTransparency = 1,
        Text  = text or "",
        TextColor3 = theme.TextMuted,
        Font  = Enum.Font.Gotham,
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left,
        Size  = UDim2.new(1, 0, 0, 14),
        Parent = self._scroll,
    })
end

-- ═══════════════════════════════════════════
--         SEPARATOR
-- ═══════════════════════════════════════════
function Nova:AddSeparator()
    local theme = self._theme
    New("Frame", {
        BackgroundColor3 = theme.Border,
        BorderSizePixel  = 0,
        Size             = UDim2.new(1, 0, 0, 1),
        Parent           = self._scroll,
    })
end

-- ═══════════════════════════════════════════
--         THEME SWITCH AT RUNTIME
-- ═══════════════════════════════════════════
function Nova:SetTheme(themeName)
    -- Runtime theme switch updates the library reference
    -- (Full re-render would require rebuilding; this updates new elements)
    local t = Nova.Themes[themeName]
    if t then
        self._theme = t
        Nova._theme = t
    end
end

-- ═══════════════════════════════════════════
--         SAVE MANAGER ADDON
-- ═══════════════════════════════════════════
local SaveManager = {}
SaveManager.__index = SaveManager
SaveManager._library = nil
SaveManager._folder  = "NovaUI"
SaveManager._ignore  = {}

function SaveManager:SetLibrary(lib) self._library = lib end
function SaveManager:SetFolder(folder) self._folder = folder end
function SaveManager:SetIgnoreIndexes(t) self._ignore = t end
function SaveManager:IgnoreThemeSettings()
    table.insert(self._ignore, "Theme")
    table.insert(self._ignore, "ActiveTheme")
end

function SaveManager:BuildConfigSection(tab)
    tab:AddLabel("Config Manager")
    tab:AddSeparator()

    local nameInput = tab:AddInput("_configName", {
        Title   = "Config Name",
        Default = "default",
        Placeholder = "Enter name...",
    })

    tab:AddButton({
        Title       = "Save Config",
        Description = "Save current settings to file",
        Callback    = function()
            local name = Nova.Options["_configName"] and Nova.Options["_configName"].Value or "default"
            self:Save(name)
        end
    })
    tab:AddButton({
        Title       = "Load Config",
        Description = "Load settings from file",
        Callback    = function()
            local name = Nova.Options["_configName"] and Nova.Options["_configName"].Value or "default"
            self:Load(name)
        end
    })
    tab:AddButton({
        Title       = "Delete Config",
        Description = "Delete saved file",
        Callback    = function()
            local name = Nova.Options["_configName"] and Nova.Options["_configName"].Value or "default"
            self:Delete(name)
        end
    })

    tab:AddToggle("_autoload", {
        Title   = "Auto-load Config",
        Default = false,
    })
end

function SaveManager:Save(name)
    if not isfolder then return end
    local data = {}
    for k, opt in pairs(Nova.Options) do
        if not table.find(self._ignore, k) and not k:sub(1,1) == "_" then
            local v = opt.Value
            if type(v) == "boolean" or type(v) == "number" or type(v) == "string" then
                data[k] = v
            end
        end
    end
    local folder = self._folder
    if not isfolder(folder) then makefolder(folder) end
    writefile(folder .. "/" .. name .. ".json", HttpService:JSONEncode(data))
    Nova:Notify({ Title = "Nova", Content = "Saved: " .. name, Duration = 3 })
end

function SaveManager:Load(name)
    if not isfile then return end
    local path = self._folder .. "/" .. name .. ".json"
    if not isfile(path) then
        Nova:Notify({ Title = "Nova", Content = "Config not found: " .. name, Duration = 3 })
        return
    end
    local ok, data = pcall(function() return HttpService:JSONDecode(readfile(path)) end)
    if ok and data then
        for k, v in pairs(data) do
            if Nova.Options[k] then
                Nova.Options[k].Value = v
            end
        end
        Nova:Notify({ Title = "Nova", Content = "Loaded: " .. name, Duration = 3 })
    end
end

function SaveManager:Delete(name)
    if not isfile then return end
    local path = self._folder .. "/" .. name .. ".json"
    if isfile(path) then
        delfile(path)
        Nova:Notify({ Title = "Nova", Content = "Deleted: " .. name, Duration = 3 })
    end
end

function SaveManager:LoadAutoloadConfig()
    self:Load("autoload")
end

-- ═══════════════════════════════════════════
--         INTERFACE MANAGER ADDON
-- ═══════════════════════════════════════════
local InterfaceManager = {}
InterfaceManager.__index = InterfaceManager
InterfaceManager._library = nil
InterfaceManager._folder  = "NovaUI"

function InterfaceManager:SetLibrary(lib) self._library = lib end
function InterfaceManager:SetFolder(folder) self._folder = folder end

function InterfaceManager:BuildInterfaceSection(tab)
    tab:AddLabel("Interface Manager")
    tab:AddSeparator()

    -- Theme dropdown
    local themes = {}
    for k in pairs(Nova.Themes) do table.insert(themes, k) end
    table.sort(themes)

    local themeDrop = tab:AddDropdown("ActiveTheme", {
        Title  = "Theme",
        Values = themes,
        Default = 1,
        Callback = function(v)
            -- In real Roblox usage this would re-apply theme
            -- For now just saves the preference
            Nova:Notify({ Title = "Nova", Content = "Theme set to " .. v, Duration = 2 })
        end
    })

    tab:AddToggle("UIAnimations", {
        Title   = "Animations",
        Default = true,
    })

    tab:AddToggle("UINotifications", {
        Title   = "Notifications",
        Default = true,
    })

    tab:AddSlider("UIOpacity", {
        Title   = "UI Opacity",
        Min     = 0.5,
        Max     = 1,
        Default = 1,
        Rounding = 2,
    })
end

-- ═══════════════════════════════════════════
--         EXPOSE ADDONS
-- ═══════════════════════════════════════════
Nova.SaveManager      = SaveManager
Nova.InterfaceManager = InterfaceManager

-- ═══════════════════════════════════════════
--         EXAMPLE USAGE (remove in production)
-- ═══════════════════════════════════════════
--[[
local Nova         = loadstring(game:HttpGet("https://github.com/nova-scripts/Nova/releases/latest/download/main.lua"))()
local SaveManager  = Nova.SaveManager
local InterfaceManager = Nova.InterfaceManager

local Window = Nova:CreateWindow({
    Title    = "My Script",
    SubTitle = "by you",
    Size     = UDim2.fromOffset(620, 480),
    Acrylic  = true,
    Theme    = "Dark",   -- Dark | Amoled | Ocean | Rose | Forest | Light
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main     = Window:AddTab({ Title = "Main",     Icon = "star"     }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" }),
}

local Options = Nova.Options

do
    Nova:Notify({
        Title      = "Nova",
        Content    = "Script loaded!",
        SubContent = "v1.0",
        Duration   = 5
    })

    Tabs.Main:AddParagraph({
        Title   = "Welcome",
        Content = "This is Nova UI Library.\nEnjoy your script!"
    })

    Tabs.Main:AddButton({
        Title       = "Teleport",
        Description = "Teleport to spawn point",
        Callback    = function()
            Window:Dialog({
                Title   = "Confirm",
                Content = "Teleport to spawn?",
                Buttons = {
                    { Title = "Yes", Callback = function() print("Teleporting!") end },
                    { Title = "No",  Callback = function() print("Cancelled")    end },
                }
            })
        end
    })

    local Toggle = Tabs.Main:AddToggle("ESPToggle", { Title = "ESP", Default = false })
    Toggle:OnChanged(function()
        print("ESP:", Options.ESPToggle.Value)
    end)

    local Slider = Tabs.Main:AddSlider("SpeedSlider", {
        Title    = "Walk Speed",
        Default  = 16,
        Min      = 0,
        Max      = 100,
        Rounding = 0,
        Callback = function(v)
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v
        end
    })

    local Dropdown = Tabs.Main:AddDropdown("GameMode", {
        Title  = "Game Mode",
        Values = { "Normal", "Rage", "Legit", "Custom" },
        Default = 1,
        Callback = function(v) print("Mode:", v) end
    })

    local Color = Tabs.Main:AddColorpicker("ESPColor", {
        Title   = "ESP Color",
        Default = Color3.fromRGB(124, 106, 255)
    })
    Color:OnChanged(function()
        print("Color:", Options.ESPColor.Value)
    end)

    local KB = Tabs.Main:AddKeybind("AimKey", {
        Title   = "Aimbot Key",
        Mode    = "Hold",
        Default = "E",
    })

    local Input = Tabs.Main:AddInput("PlayerName", {
        Title       = "Target Name",
        Placeholder = "Enter username...",
        Callback    = function(v) print("Target:", v) end
    })
end

SaveManager:SetLibrary(Nova)
InterfaceManager:SetLibrary(Nova)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("NovaScriptHub")
SaveManager:SetFolder("NovaScriptHub/configs")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)
Window:SelectTab(1)
Nova:Notify({ Title = "Nova", Content = "Ready.", Duration = 5 })
SaveManager:LoadAutoloadConfig()
--]]

return Nova
