

if getgenv().Library then
    getgenv().Library:Exit()
end

cloneref = cloneref or function(...) return ... end 

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local GuiService = game:GetService("GuiService")
local CoreGui = cloneref(game:GetService("CoreGui"))

gethui = gethui or function() return CoreGui end

local LocalPlayer = Players.LocalPlayer
local IsMobile = UserInputService.TouchEnabled or false
local GuiInset = GuiService:GetGuiInset().Y
local Mouse = cloneref(LocalPlayer:GetMouse())

local Library = { 
    Flags = { },
    MenuKeybind = tostring(Enum.KeyCode.End), 

    Directory = "kuma",
    Folders = {
        Assets = "/Assets",
        Configs = "/Configs",
        Themes = "/Themes"
    },

    FontSize = 12,

    Animation = {
        Time = 0.3,
        Style = "Quint",
        Direction = "Out"
    },

    TabAnimation = {
        Time = 1,
        Style = "Exponential",
        Direction = "Out"
    },

    ColorpickerAnimation = {
        Time = 0.55,
        Style = "Exponential",
        Direction = "Out"
    },

    NotifAnimation = {
        Time = 0.85,
        Style = "Exponential",
        Direction = "Out"
    },

    ZIndexOrder = {
        ["OptionHolder"] = 4,
        ["KeybindWindow"] = 4, -- burp
        ["ColorpickerWindow"] = 6
    },

    -- Ignore below
    Threads = { },
    Connections = { },
    SetFlags = { },

    ThemingStuff = { },
    ThemeMap = { },

    OpenFrames = { },

    Holder = nil,
    UnusedHolder = nil,

    Font = nil,

    Notifications = { },
    KeyList = nil,

    Theme = nil,
} do 
    Library.__index = Library

    local Flags = Library.Flags 
    local SetFlags = Library.SetFlags

    local Keys = {
        ["Unknown"]           = "Unknown",
        ["Backspace"]         = "Back",
        ["Tab"]               = "Tab",
        ["Clear"]             = "Clear",
        ["Return"]            = "Return",
        ["Pause"]             = "Pause",
        ["Escape"]            = "Escape",
        ["Space"]             = "Space",
        ["QuotedDouble"]      = '"',
        ["Hash"]              = "#",
        ["Dollar"]            = "$",
        ["Percent"]           = "%",
        ["Ampersand"]         = "&",
        ["Quote"]             = "'",
        ["LeftParenthesis"]   = "(",
        ["RightParenthesis"]  = " )",
        ["Asterisk"]          = "*",
        ["Plus"]              = "+",
        ["Comma"]             = ",",
        ["Minus"]             = "-",
        ["Period"]            = ".",
        ["Slash"]             = "`",
        ["Three"]             = "3",
        ["Seven"]             = "7",
        ["Eight"]             = "8",
        ["Colon"]             = ":",
        ["Semicolon"]         = ";",
        ["LessThan"]          = "<",
        ["GreaterThan"]       = ">",
        ["Question"]          = "?",
        ["Equals"]            = "=",
        ["At"]                = "@",
        ["LeftBracket"]       = "LeftBracket",
        ["RightBracket"]      = "RightBracked",
        ["BackSlash"]         = "BackSlash",
        ["Caret"]             = "^",
        ["Underscore"]        = "_",
        ["Backquote"]         = "`",
        ["LeftCurly"]         = "{",
        ["Pipe"]              = "|",
        ["RightCurly"]        = "}",
        ["Tilde"]             = "~",
        ["Delete"]            = "Delete",
        ["End"]               = "End",
        ["KeypadZero"]        = "Keypad0",
        ["KeypadOne"]         = "Keypad1",
        ["KeypadTwo"]         = "Keypad2",
        ["KeypadThree"]       = "Keypad3",
        ["KeypadFour"]        = "Keypad4",
        ["KeypadFive"]        = "Keypad5",
        ["KeypadSix"]         = "Keypad6",
        ["KeypadSeven"]       = "Keypad7",
        ["KeypadEight"]       = "Keypad8",
        ["KeypadNine"]        = "Keypad9",
        ["KeypadPeriod"]      = "KeypadP",
        ["KeypadDivide"]      = "KeypadD",
        ["KeypadMultiply"]    = "KeypadM",
        ["KeypadMinus"]       = "KeypadM",
        ["KeypadPlus"]        = "KeypadP",
        ["KeypadEnter"]       = "KeypadE",
        ["KeypadEquals"]      = "KeypadE",
        ["Insert"]            = "Insert",
        ["Home"]              = "Home",
        ["PageUp"]            = "PageUp",
        ["PageDown"]          = "PageDown",
        ["RightShift"]        = "RightShift",
        ["LeftShift"]         = "LeftShift",
        ["RightControl"]      = "RightControl",
        ["LeftControl"]       = "LeftControl",
        ["LeftAlt"]           = "LeftAlt",
        ["RightAlt"]          = "RightAlt"
    }

    -- Folders
    if not isfolder(Library.Directory) then 
        makefolder(Library.Directory)
    end

    for _, Folder in Library.Folders do 
        if not isfolder(Library.Directory .. Folder) then 
            makefolder(Library.Directory .. Folder)
        end
    end

    if not isfile(Library.Directory .. "/autoload.json") then 
        writefile(Library.Directory .. "/autoload.json", "")
    end

    local Themes = {
        ["Preset"] = {
            ["Border"] = Color3.fromRGB(3, 3, 3),
            ["Outline"] = Color3.fromRGB(51, 51, 51),
            ["Background"] = Color3.fromRGB(12, 12, 12),
            ["Inline"] = Color3.fromRGB(19, 19, 19),
            ["Accent"] = Color3.fromRGB(220, 100, 100),
            ["Text"] = Color3.fromRGB(208, 207, 227),
            ["Inactive Text"] = Color3.fromRGB(134, 134, 134),
            ["Element"] = Color3.fromRGB(39, 39, 39),
            ["Element 2"] = Color3.fromRGB(56, 56, 56),
            ["Hovered Element"] = Color3.fromRGB(61, 61, 61)
        }
    }

    Library.Theme = Themes.Preset

    -- Custom Font
    local CustomFont = { } do
        function CustomFont:New(Name, Weight, Style, Data)
            if not isfile(Data.Id) then 
                writefile(Data.Id, game:HttpGet(Data.Url))
            end

            local Data = {
                name = Name,
                faces = {
                    {
                        name = Name,
                        weight = Weight,
                        style = Style,
                        assetId = getcustomasset(Data.Id)
                    }
                }
            }

            writefile(`{Library.Directory .. Library.Folders.Assets}/{Name}.font`, HttpService:JSONEncode(Data))
            return Font.new(getcustomasset(`{Library.Directory .. Library.Folders.Assets}/{Name}.font`))
        end

        Library.Font = CustomFont:New("TahomaXP", 400, "Regular", {
            Id = "TahomaXP",
            Url = "https://github.com/sametexe001/luas/raw/refs/heads/main/fonts/windows-xp-tahoma.ttf"
        })
    end

    Library.Exit = function(Self)
        for _, Connection in Library.Connections do 
            Connection:Disconnect()
        end

        for _, Thread in Library.Threads do 
            coroutine.close(Thread)
        end

        if Self.Holder then 
            Self.Holder.Instance:Destroy()
        end

        if Self.UnusedHolder then 
            Self.UnusedHolder.Instance:Destroy()
        end

        for Index, Value in Library.Notifications do 
            Value.Items.Notification.Instance:Destroy()
        end

        if Self.NotifHolder then 
            Self.NotifHolder.Instance:Destroy()
        end

        Library = nil
        getgenv().Library = nil
    end

    Library.Create = function(Self, Class, Properties)
        local Data = {
            Class = Class,
            Properties = Properties,
            Instance = Instance.new(Class)
        }

        for Index, Property in Properties do 
            if Property == "FontFace" then
                Data.Instance[Property] = Library.Font
                continue
            end

            if Property == "TextSize" then 
                Data.Instance[Property] = Library.FontSize
                continue
            end

            if Property == "Name" then 
                Data.Instance[Property] = "\0"
                continue
            end

            if Class == "TextButton" then 
                if Property == "AutoButtonColor" then 
                    Data.Instance[Property] = false
                    continue
                end

                if Property == "Text" then 
                    Data.Instance[Property] = ""
                    continue
                end
            end

            Data.Instance[Index] = Property
        end

        return setmetatable(Data, Library)
    end

    Library.Thread = function(Self, Function)
        local NewThread = coroutine.create(Function)
        
        coroutine.wrap(function()
            coroutine.resume(NewThread)
        end)()

        table.insert(Library.Threads, NewThread)
        return NewThread
    end

    Library.Connect = function(Self, Signal, Callback)
        local Connection

        if Self.Instance then
            if Self.Instance[Signal] then 
                if IsMobile and Signal == "MouseButton1Down" then 
                    Connection = Self.Instance.InputBegan:Connect(function(Input)
                        if Input.UserInputType == Enum.UserInputType.Touch or Input.UserInputType == Enum.UserInputType.MouseButton1 then
                            Callback(Input)
                        end
                    end)

                    return
                end
                
                Connection = Self.Instance[Signal]:Connect(Callback)
            else
                Connection = Signal:Connect(Callback)
            end
        else
            Connection = Signal:Connect(Callback)
        end

        table.insert(Library.Connections, Connection)
        return Connection
    end

    Library.Tween = function(Self, Properties, Info, IsRawItem)
        if not Library then return end 

        local Object = Self.Instance or IsRawItem
        Info = Info or TweenInfo.new(Library.Animation.Time, Enum.EasingStyle[Library.Animation.Style], Enum.EasingDirection[Library.Animation.Direction])

        if not Object then 
            return 
        end

        local NewTween = TweenService:Create(Object, Info, Properties)
        NewTween:Play()

        return NewTween
    end

    Library.GetTweenProperty = function(Self, IsRawItem)
        local Object = Self.Instance or IsRawItem

        if not Object then 
            return { }
        end

        if Object:IsA("Frame") then
            return { "BackgroundTransparency" }
        elseif Object:IsA("TextLabel") or Object:IsA("TextButton") then
            return { "TextTransparency", "BackgroundTransparency" }
        elseif Object:IsA("ImageLabel") or Object:IsA("ImageButton") then
            return { "BackgroundTransparency", "ImageTransparency" }
        elseif Object:IsA("ScrollingFrame") then
            return { "BackgroundTransparency", "ScrollBarImageTransparency" }
        elseif Object:IsA("TextBox") then
            return { "TextTransparency", "BackgroundTransparency" }
        elseif Object:IsA("UIStroke") then 
            return { "Transparency" }
        end
    end

    Library.Fade = function(Self, Property, Visibility, IsRawItem)
        local Object = Self.Instance or IsRawItem

        if not Object then 
            return 
        end

        local OldTransparency = Object[Property]
        Object[Property] = Visibility and 1 or OldTransparency

        local NewTween = Library:Tween({[Property] = Visibility and OldTransparency or 1}, nil, Object)

        Library:Connect(NewTween.Completed, function()
            if not Visibility then 
                task.wait()
                Object[Property] = OldTransparency
            end
        end)

        return NewTween
    end

    Library.FadeDescendants = function(Self, Visibility, Callback)
        if Visibility then 
            Self.Instance.Visible = true 
        end

        local NewTween 

        local Children = Self.Instance:GetDescendants()
        table.insert(Children, Self.Instance)

        for _, Child in Children do 
            local TransparencyProperty = Library:GetTweenProperty(Child)

            if not TransparencyProperty then 
                continue 
            end

            if type(TransparencyProperty) == "table" then
                for _, Property in TransparencyProperty do
                    NewTween = Library:Fade(Property, Visibility, Child)
                end
            else
                NewTween = Library:Fade(TransparencyProperty, Visibility, Child)
            end
        end

        Library:Connect(NewTween.Completed, function()
            if Callback and type(Callback) == "function" then 
                Callback()
            end

            Self.Instance.Visible = Visibility
        end)
    end

    Library.MakeDraggable = function(Self)
        if not Self.Instance then 
            return
        end
    
        local Gui = Self.Instance
        local Dragging = false 
        local DragStart
        local StartPosition 
    
        local Set = function(Input)
            local Scale = Library:GetScreenScale()
            local DragDelta = (Input.Position - DragStart) / Scale
            
            local NewX = StartPosition.X.Offset + DragDelta.X
            local NewY = StartPosition.Y.Offset + DragDelta.Y

            local ScreenSize = Gui.Parent.AbsoluteSize / Scale
            local GuiSize = Gui.AbsoluteSize / Scale
            
            NewX = math.clamp(NewX, 0, ScreenSize.X - GuiSize.X)
            NewY = math.clamp(NewY, 0, ScreenSize.Y - GuiSize.Y)
    
            Self:Tween({Position = UDim2.new(0, NewX, 0, NewY)}, TweenInfo.new(0.65, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out))
        end
    
        local InputChanged
    
        Self:Connect("InputBegan", function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                Dragging = true
                DragStart = Input.Position
                StartPosition = Gui.Position
    
                if InputChanged then 
                    return
                end
    
                InputChanged = Input.Changed:Connect(function()
                    if Input.UserInputState == Enum.UserInputState.End then
                        Dragging = false
                        InputChanged:Disconnect()
                        InputChanged = nil
                    end
                end)
            end
        end)
    
        Library:Connect(UserInputService.InputChanged, function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                if Dragging then
                    Set(Input)
                end
            end
        end)
    
        return Dragging
    end

    Library.MakeResizeable = function(Self, Minimum)
        if not Self.Instance then 
            return
        end

        local Gui = Self.Instance

        local Resizing = false 
        local CurrentSide = nil

        local StartMouse = nil 
        local StartPosition = nil 
        local StartSize = nil
        
        local EdgeThickness = 2

        local MakeEdge = function(Name, Position, Size)
            local Button = Library:Create("TextButton", {
                Name = "\0",
                Size = Size,
                Position = Position,
                BackgroundColor3 = Color3.fromRGB(166, 147, 243),
                BackgroundTransparency = 1,
                Text = "",
                BorderSizePixel = 0,
                AutoButtonColor = false,
                Parent = Gui,
            })  Button:AddToTheme({BackgroundColor3 = "Accent"})

            return Button
        end

        local Edges = {
            {Button = MakeEdge(
                "Left", 
                UDim2.new(0, 0, 0, 0), 
                UDim2.new(0, EdgeThickness, 1, 0)), 
                Side = "L"
            },

            {Button = MakeEdge(
                "Right", 
                UDim2.new(1, -EdgeThickness, 0, 0), 
                UDim2.new(0, EdgeThickness, 1, 0)), 
                Side = "R"
            },

            {Button = MakeEdge(
                "Top", UDim2.new(0, 0, 0, 0), 
                UDim2.new(1, 0, 0, EdgeThickness)), 
                Side = "T"
            },

            {Button = MakeEdge(
                "Bottom", 
                UDim2.new(0, 0, 1, -EdgeThickness), 
                UDim2.new(1, 0, 0, EdgeThickness)), 
                Side = "B"
            },
        }

        local BeginResizing = function(Side)
            Resizing = true 
            CurrentSide = Side 

            StartMouse = UserInputService:GetMouseLocation()

            StartPosition = Vector2.new(Gui.Position.X.Offset, Gui.Position.Y.Offset)
            StartSize = Vector2.new(Gui.Size.X.Offset, Gui.Size.Y.Offset)
            
            for Index, Value in Edges do 
                Value.Button.Instance.BackgroundTransparency = (Value.Side == Side) and 0 or 1
            end
        end

        local EndResizing = function()
            Resizing = false 
            CurrentSide = nil

            for Index, Value in Edges do 
                Value.Button.Instance.BackgroundTransparency = 1
            end
        end

        for Index, Value in Edges do 
            Value.Button:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    BeginResizing(Value.Side)
                end
            end)
        end

        Library:Connect(UserInputService.InputEnded, function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                if Resizing then
                    EndResizing()
                end
            end
        end)

        Library:Connect(RunService.RenderStepped, function()
            if not Resizing or not CurrentSide then 
                return 
            end

            local MouseLocation = UserInputService:GetMouseLocation()
            local dx = MouseLocation.X - StartMouse.X
            local dy = MouseLocation.Y - StartMouse.Y
        
            local x, y = StartPosition.X, StartPosition.Y
            local w, h = StartSize.X, StartSize.Y

            if CurrentSide == "L" then
                x = StartPosition.X + dx
                w = StartSize.X - dx
            elseif CurrentSide == "R" then
                w = StartSize.X + dx
            elseif CurrentSide == "T" then
                y = StartPosition.Y + dy
                h = StartSize.Y - dy
            elseif CurrentSide == "B" then
                h = StartSize.Y + dy
            end
        
            if w < Minimum.X then
                if CurrentSide == "L" then
                    x = x - (Minimum.X - w)
                end
                w = Minimum.X
            end
            if h < Minimum.Y then
                if CurrentSide == "T" then
                    y = y - (Minimum.Y - h)
                end
                h = Minimum.Y
            end
        
            Self:Tween({Position = UDim2.fromOffset(x, y)}, TweenInfo.new(0.65, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out))
            Self:Tween({Size = UDim2.fromOffset(w, h)}, TweenInfo.new(0.65, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out))
        end)
    end

    Library.IsMouseOverFrame = function(Self)
        if not Self.Instance then 
            return 
        end

        local Object = Self.Instance

        local MousePosition = Vector2.new(Mouse.X, Mouse.Y)

        return MousePosition.X >= Object.AbsolutePosition.X and MousePosition.X <= Object.AbsolutePosition.X + Object.AbsoluteSize.X 
        and MousePosition.Y >= Object.AbsolutePosition.Y and MousePosition.Y <= Object.AbsolutePosition.Y + Object.AbsoluteSize.Y
    end

    Library.SafeCall = function(Self, Function, ...)
        local Arguements = { ... }
        local Success, Result = pcall(Function, table.unpack(Arguements))

        if not Success then
            warn(Result)
            return false
        end

        return Success, Result
    end

    Library.Round = function(Self, Number, Float)
        local Multiplier = 1 / (Float or 1)
        return math.floor(Number * Multiplier) / Multiplier
    end

    Library.GetConfig = function(Self)
        local Config = { }

        local Success, Result = Library:SafeCall(function()
            for Index, Value in Library.Flags do 
                if type(Value) == "table" and Value.Key then
                    Config[Index] = {Key = tostring(Value.Key), Mode = Value.Mode}
                elseif type(Value) == "table" and Value.Color then
                    Config[Index] = {Color = "#" .. Value.HexValue, Alpha = Value.Alpha}
                else
                    Config[Index] = Value
                end
            end
        end)

        if not Success then
            warn("Failed to get config:\n"..Result)
            return
        end

        return HttpService:JSONEncode(Config)
    end

    Library.LoadConfig = function(Self, Config)
        local Decoded = HttpService:JSONDecode(Config)

        local Success, Result = Library:SafeCall(function()
            for Index, Value in Decoded do 
                local SetFunction = Library.SetFlags[Index]

                if not SetFunction then
                    continue
                end

                if type(Value) == "table" and Value.Key then 
                    SetFunction(Value)
                elseif type(Value) == "table" and Value.Color then
                    SetFunction(Value.Color, Value.Alpha)
                else
                    SetFunction(Value)
                end
            end
        end)

        return Success, Result
    end

    Library.GetConfigsList = function(Self, Element)
        local List = { }
        local ReturnList = { }

        List = listfiles(Library.Directory .. Library.Folders.Configs)

        for Index = 1, #List do 
            local File = List[Index]

            if File:sub(-5) == ".json" then
                local Position = File:find(".json", 1, true)
                local StartPosition = Position

                local Character = File:sub(Position, Position)
                while Character ~= "/" and Character ~= "\\" and Character ~= "" do
                    Position = Position - 1
                    Character = File:sub(Position, Position)
                end

                if Character == "/" or Character == "\\" then
                    table.insert(ReturnList, File:sub(Position + 1, StartPosition - 1))
                end
            end
        end

        Element:Refresh(ReturnList)
    end

    Library.AddToTheme = function(Self, Properties)
        local Object = Self.Instance

        local ThemeData = {
            Item = Object,
            Properties = Properties,
        }

        for Property, Value in ThemeData.Properties do
            if type(Value) == "string" then
                if not Library.Theme[Value] then
                    Object[Property] = Value 
                end

                Object[Property] = Library.Theme[Value]
            else
                Object[Property] = Value()
            end
        end

        table.insert(Library.ThemingStuff, ThemeData)
        Library.ThemeMap[Object] = ThemeData
        return Self
    end

    Library.ChangeItemTheme = function(Self, Properties)
        local Object = Self.Instance

        if not Library.ThemeMap[Object] then 
            return
        end

        Library.ThemeMap[Object].Properties = Properties
        Library.ThemeMap[Object] = Library.ThemeMap[Object]
    end

    Library.ChangeTheme = function(Self, Theme, Color)
        Library.Theme[Theme] = Color

        for _, Item in Library.ThemingStuff do
            for Property, Value in Item.Properties do
                if type(Value) == "string" and Value == Theme then
                    Item.Item[Property] = Color
                elseif type(Value) == "function" then
                    Item.Item[Property] = Value()
                end
            end
        end
    end

    Library.OnHover = function(Self, OnHoverEnter, OnHoverLeave)
        local Object = Self.Instance

        if not Object then 
            return 
        end 

        Library:Connect(Object.MouseEnter, OnHoverEnter)
        Library:Connect(Object.MouseLeave, OnHoverLeave)
    end

    Library.GetScreenScale = function(Self)
        local Scale = 1
    
        for _, Obj in Library.Holder.Instance:GetDescendants() do
            if Obj:IsA("UIScale") then
                Scale *= Obj.Scale
            end
        end
    
        return Scale
    end
    
    Library.PopupPosition = function(Self, Anchor, Popup, ExtraY)
        local Scale = Library:GetScreenScale()
        ExtraY = ExtraY or 0
    
        local X = Anchor.AbsolutePosition.X / Scale
        local Y = (Anchor.AbsolutePosition.Y + Anchor.AbsoluteSize.Y + GuiInset + ExtraY) / Scale
    
        return UDim2.fromOffset(X, Y)
    end

    Library.VisibleCheck = function(Self)
        local Object = Self.Instance 

        if not Object then 
            return 
        end

        local OriginalParent = Object.Parent

        Library:Connect(Object:GetPropertyChangedSignal("Visible"), function()
            local IsVisible = Object.Visible
            Object.Parent = IsVisible and OriginalParent or Library.UnusedHolder.Instance
        end)
    end

    Library.GetTheme = function(Self)
        local Config = { }

        local Success, Result = Library:SafeCall(function()
            for Index, Value in Library.Flags do 
                if type(Value) == "table" and Value.Color and Value.Flag:find("Theming") then
                    Config[Index] = {Color = "#" .. Value.HexValue, Alpha = Value.Alpha}
                end
            end
        end)

        if not Success then
            warn("Failed to get theme:\n"..Result)
            return
        end

        return HttpService:JSONEncode(Config)
    end

    Library.LoadTheme = function(Self, Config)
        local Decoded = HttpService:JSONDecode(Config)

        local Success, Result = Library:SafeCall(function()
            for Index, Value in Decoded do 
                local SetFunction = Library.SetFlags[Index]

                if not SetFunction then
                    continue
                end

                if type(Value) == "table" and Value.Color then
                    SetFunction(Value.Color, Value.Alpha)
                end
            end
        end)

        return Success, Result
    end

    Library.GetThemesList = function(Self, Element)
        local List = { }
        local ReturnList = { }

        List = listfiles(Library.Directory .. Library.Folders.Themes)

        for Index = 1, #List do 
            local File = List[Index]

            if File:sub(-5) == ".json" then
                local Position = File:find(".json", 1, true)
                local StartPosition = Position

                local Character = File:sub(Position, Position)
                while Character ~= "/" and Character ~= "\\" and Character ~= "" do
                    Position = Position - 1
                    Character = File:sub(Position, Position)
                end

                if Character == "/" or Character == "\\" then
                    table.insert(ReturnList, File:sub(Position + 1, StartPosition - 1))
                end
            end
        end

        Element:Refresh(ReturnList)
    end

    Library.Holder = Library:Create("ScreenGui", {
        Parent = gethui(),
        IgnoreGuiInset = true,
        Name = "\0",
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        ResetOnSpawn = false
    })

    Library.NotifHolder = Library:Create("ScreenGui", {
        Parent = gethui(),
        IgnoreGuiInset = true,
        Name = "\0",
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        ResetOnSpawn = false
    })

    Library.UnusedHolder = Library:Create("ScreenGui", {
        Parent = gethui(),
        Name = "\0",
        Enabled = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        ResetOnSpawn = false
    })

    -- themes
    Library:Thread(function()
        writefile(Library.Directory .. Library.Folders.Themes .. "/Sky.json", '{"MenuKeybindModeDropdown":"Toggle","AccentTheming":{"Color":"#93eeff","Alpha":0},"BackgroundTheming":{"Color":"#141718","Alpha":0},"color":{"Color":"#ffffff","Alpha":0},"MenuKeybind":{"Key":"Enum.KeyCode.X","Mode":"Toggle"},"keybindModeDropdown":"Toggle","keybind2ModeDropdown":"Toggle","Hovered ElementTheming":{"Color":"#444949","Alpha":0},"keybind2ShowInKeybindsList":true,"target":"Head","OutlineTheming":{"Color":"#292d2e","Alpha":0},"keybind3ShowInKeybindsList":true,"InlineTheming":{"Color":"#1f2324","Alpha":0},"keybind":{"Key":"Enum.KeyCode.E","Mode":"Toggle"},"keybind3":{"Key":"Enum.KeyCode.R","Mode":"Toggle"},"keybind3ModeDropdown":"Toggle","ElementTheming":{"Color":"#2e3131","Alpha":0},"Element 2Theming":{"Color":"#454a4b","Alpha":0},"keybind2":{"Key":"Enum.KeyCode.F","Mode":"Toggle"},"ThemeName":"Sky","BorderTheming":{"Color":"#1a1d1d","Alpha":0},"AutoParry":false,"ConfigName":"","keybindShowInKeybindsList":true,"Inactive TextTheming":{"Color":"#868686","Alpha":0},"walkspeed":16,"TextTheming":{"Color":"#ffffff","Alpha":0},"MenuKeybindShowInKeybindsList":true,"textbox":"default"}')
        writefile(Library.Directory .. Library.Folders.Themes .. "/Magma.json", '{"MenuKeybindModeDropdown":"Toggle","AccentTheming":{"Color":"#e92b1a","Alpha":0},"BackgroundTheming":{"Color":"#221c1c","Alpha":0},"color":{"Color":"#ffffff","Alpha":0},"MenuKeybind":{"Key":"Enum.KeyCode.X","Mode":"Toggle"},"keybindModeDropdown":"Toggle","keybind2ModeDropdown":"Toggle","Hovered ElementTheming":{"Color":"#362a2a","Alpha":0},"keybind2ShowInKeybindsList":true,"target":"Head","OutlineTheming":{"Color":"#291d1d","Alpha":0},"keybind3ShowInKeybindsList":true,"InlineTheming":{"Color":"#1f1717","Alpha":0},"keybind":{"Key":"Enum.KeyCode.E","Mode":"Toggle"},"keybind3":{"Key":"Enum.KeyCode.R","Mode":"Toggle"},"keybind3ModeDropdown":"Toggle","ElementTheming":{"Color":"#292121","Alpha":0},"Element 2Theming":{"Color":"#363131","Alpha":0},"keybind2":{"Key":"Enum.KeyCode.F","Mode":"Toggle"},"ThemeName":"Magma","BorderTheming":{"Color":"#000000","Alpha":0},"AutoParry":true,"ConfigName":"","keybindShowInKeybindsList":true,"Inactive TextTheming":{"Color":"#867979","Alpha":0},"walkspeed":16,"TextTheming":{"Color":"#d0cfe3","Alpha":0},"MenuKeybindShowInKeybindsList":true,"textbox":"default"}')
        writefile(Library.Directory .. Library.Folders.Themes .. "/Sand.json", '{"MenuKeybindModeDropdown":"Toggle","AccentTheming":{"Color":"#ffe593","Alpha":0},"BackgroundTheming":{"Color":"#2d2e25","Alpha":0},"color":{"Color":"#ffffff","Alpha":0},"MenuKeybind":{"Key":"Enum.KeyCode.X","Mode":"Toggle"},"keybindModeDropdown":"Toggle","keybind2ModeDropdown":"Toggle","Hovered ElementTheming":{"Color":"#47473b","Alpha":0},"keybind2ShowInKeybindsList":true,"target":"Head","OutlineTheming":{"Color":"#585344","Alpha":0},"keybind3ShowInKeybindsList":true,"InlineTheming":{"Color":"#3f4137","Alpha":0},"keybind":{"Key":"Enum.KeyCode.E","Mode":"Toggle"},"keybind3":{"Key":"Enum.KeyCode.R","Mode":"Toggle"},"keybind3ModeDropdown":"Toggle","ElementTheming":{"Color":"#36362c","Alpha":0},"Element 2Theming":{"Color":"#414133","Alpha":0},"keybind2":{"Key":"Enum.KeyCode.F","Mode":"Toggle"},"ThemeName":"Sand","BorderTheming":{"Color":"#141403","Alpha":0},"AutoParry":false,"ConfigName":"","keybindShowInKeybindsList":true,"Inactive TextTheming":{"Color":"#888784","Alpha":0},"walkspeed":16,"TextTheming":{"Color":"#d0cfe3","Alpha":0},"MenuKeybindShowInKeybindsList":true,"textbox":"default"}')
        writefile(Library.Directory .. Library.Folders.Themes .. "/Navy.json", '{"MenuKeybindModeDropdown":"Toggle","AccentTheming":{"Color":"#0066ff","Alpha":0},"BackgroundTheming":{"Color":"#1c1e24","Alpha":0},"color":{"Color":"#ffffff","Alpha":0},"Watermark":true,"keybind2ModeDropdown":"Toggle","keybindModeDropdown":"Toggle","Hovered ElementTheming":{"Color":"#282b31","Alpha":0},"keybind2ShowInKeybindsList":true,"ThemeName":"Navy","InlineTheming":{"Color":"#202229","Alpha":0},"textbox":"default","OutlineTheming":{"Color":"#252a36","Alpha":0},"keybind":{"Key":"Enum.KeyCode.E","Mode":"Toggle"},"MenuKeybind":{"Key":"Enum.KeyCode.X","Mode":"Toggle"},"BorderTheming":{"Color":"#030303","Alpha":0},"keybind3":{"Key":"Enum.KeyCode.R","Mode":"Toggle"},"keybind3ModeDropdown":"Toggle","ElementTheming":{"Color":"#1d202b","Alpha":0},"Keybind list":true,"keybind2":{"Key":"Enum.KeyCode.F","Mode":"Toggle"},"AutoParry":true,"keybind3ShowInKeybindsList":true,"Element 2Theming":{"Color":"#3e414b","Alpha":0},"keybindShowInKeybindsList":true,"ConfigName":"","Inactive TextTheming":{"Color":"#65697e","Alpha":0},"walkspeed":34,"TextTheming":{"Color":"#a5a4bb","Alpha":0},"MenuKeybindShowInKeybindsList":true,"target":"Head"}')
    end)

    do
        local ColorpickerInfo = TweenInfo.new(Library.ColorpickerAnimation.Time, Enum.EasingStyle[Library.ColorpickerAnimation.Style], Enum.EasingDirection[Library.ColorpickerAnimation.Direction])

        Library.CreateColorpicker = function(Self, Data)
            local Colorpicker = {
                Hue = 0,
                Saturation = 0,
                Value = 0,

                Alpha = 0,

                Color = Color3.fromRGB(255, 255, 255),
                HexValue = "#FFFFFF",

                Flag = Data.Flag,
                IsOpen = false,

                Items = { }
            }

            local Items = { } do 
                Items["ColorpickerButton"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Data.Parent.Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Size = UDim2.new(0, 23, 0, 9),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(255, 57, 83)
                })
                
                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["ColorpickerButton"].Instance,
                    Rotation = 90,
                    Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(163, 163, 163))
                }
                })                

                Items["ColorpickerWindow"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Library.Holder.Instance,
                    Visible = false,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Position = UDim2.new(0, 1049, 0, 216),
                    Size = UDim2.new(0, 240, 0, 190),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Background"]
                }):AddToTheme({BackgroundColor3 = 'Background'})
                
                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["ColorpickerWindow"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({Color = 'Border'})
                
                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["ColorpickerWindow"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({Color = 'Outline'})
                
                Items["CurrentColor"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["ColorpickerWindow"].Instance,
                    AnchorPoint = Vector2.new(0, 1),
                    Position = UDim2.new(0, 10, 1, -10),
                    Size = UDim2.new(1, -20, 0, 10),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(255, 57, 83)
                })
                
                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["CurrentColor"].Instance,
                    Rotation = 90,
                    Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(163, 163, 163))
                }
                })
                
                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["CurrentColor"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({Color = 'Outline'})
                
                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["CurrentColor"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({Color = 'Border'})
                
                Items["Alpha"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["ColorpickerWindow"].Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    AnchorPoint = Vector2.new(1, 0),
                    Position = UDim2.new(1, -10, 0, 10),
                    Size = UDim2.new(0, 15, 1, -40),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(255, 57, 83)
                })
                
                Items["Fill"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Alpha"].Instance,
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BorderSizePixel = 0
                })
                
                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["Fill"].Instance,
                    Rotation = -90,
                    Transparency = NumberSequence.new{
                    NumberSequenceKeypoint.new(0, 0),
                    NumberSequenceKeypoint.new(1, 1)
                }
                })
                
                Items["AlphaDragger"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Alpha"].Instance,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Size = UDim2.new(1, 0, 0, 1),
                    BorderSizePixel = 0
                })
                
                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["AlphaDragger"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"]
                }):AddToTheme({Color = 'Border'})
                
                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Alpha"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({Color = 'Border'})
                
                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Alpha"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({Color = 'Outline'})
                
                Items["Hue"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["ColorpickerWindow"].Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Text = "",
                    AutoButtonColor = false,
                    AnchorPoint = Vector2.new(1, 0),
                    Position = UDim2.new(1, -35, 0, 10),
                    Size = UDim2.new(0, 15, 1, -40),
                    BorderSizePixel = 0
                })
                
                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["Hue"].Instance,
                    Rotation = 90,
                    Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
                    ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
                    ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
                    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
                    ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
                    ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
                }
                })
                
                Items["HueDragger"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Hue"].Instance,
                    Size = UDim2.new(1, 0, 0, 1),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BorderSizePixel = 0
                })
                
                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["HueDragger"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"]
                }):AddToTheme({Color = 'Border'})
                
                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Hue"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({Color = 'Border'})
                
                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Hue"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({Color = 'Outline'})
                
                Items["Palette"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["ColorpickerWindow"].Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Position = UDim2.new(0, 10, 0, 10),
                    Size = UDim2.new(1, -70, 1, -40),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(255, 57, 83)
                })
                
                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Palette"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({Color = 'Border'})
                
                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Palette"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({Color = 'Outline'})
                
                Items["Saturation"] = Library:Create("Frame", {
                    Name = "\0",
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Parent = Items["Palette"].Instance,
                    Size = UDim2.new(1, 1, 1, 0),
                    BorderSizePixel = 0
                })
                
                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["Saturation"].Instance,
                    Transparency = NumberSequence.new{
                    NumberSequenceKeypoint.new(0, 1),
                    NumberSequenceKeypoint.new(1, 0)
                }
                })
                
                Items["Value"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Palette"].Instance,
                    Size = UDim2.new(1, 1, 1, 1),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                })
                
                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["Value"].Instance,
                    Rotation = 90,
                    Transparency = NumberSequence.new{
                    NumberSequenceKeypoint.new(0, 1),
                    NumberSequenceKeypoint.new(1, 0)
                }
                })
                
                Items["PaletteDragger"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Palette"].Instance,
                    Size = UDim2.new(0, 1, 0, 1),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BorderSizePixel = 0
                })
                
                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["PaletteDragger"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"]
                }):AddToTheme({Color = 'Border'})                

                Colorpicker.Items = Items
            end

            function Colorpicker:SetVisibility(Bool)
                Items["ColorpickerButton"].Instance.Visible = Bool
            end

            function Colorpicker:Update(IsFromAlpha)
                local Hue, Saturation, Value = Colorpicker.Hue, Colorpicker.Saturation, Colorpicker.Value
                Colorpicker.Color = Color3.fromHSV(Hue, Saturation, Value)
                Colorpicker.HexValue = Colorpicker.Color:ToHex()
        
                Items["ColorpickerButton"]:Tween({BackgroundColor3 = Colorpicker.Color})
                Items["Palette"]:Tween({BackgroundColor3 = Color3.fromHSV(Hue, 1, 1)})

                Flags[Colorpicker.Flag] = {
                    Alpha = Colorpicker.Alpha,
                    Color = Colorpicker.Color,
                    HexValue = Colorpicker.HexValue,
                    Flag = Colorpicker.Flag,
                    Transparency = 1 - Colorpicker.Alpha
                }

                Items["CurrentColor"]:Tween({BackgroundColor3 = Colorpicker.Color})
    
                if not IsFromAlpha then 
                    Items["Alpha"]:Tween({BackgroundColor3 = Colorpicker.Color})
                end
    
                if Data.Callback then 
                    Library:SafeCall(Data.Callback, Colorpicker.Color, Colorpicker.Alpha)
                end
            end

            local Debounce = false 
            local ColorpickerWindow = Items["ColorpickerWindow"].Instance
            local ColorpickerButton = Items["ColorpickerButton"].Instance

            local IsSettings = Data.Section and Data.Section.IsSettings

            function Colorpicker:SetOpen(Bool)
                if Debounce then 
                    return 
                end

                Colorpicker.IsOpen = Bool

                Debounce = true 
                
                if Colorpicker.IsOpen then 
                    ColorpickerWindow.Position = Library:PopupPosition(ColorpickerButton, ColorpickerWindow, 0)

                    ColorpickerWindow.Visible = true
                    Items["ColorpickerWindow"]:Tween({
                        Position = Library:PopupPosition(ColorpickerButton, ColorpickerWindow, 10)
                    })

                    Items["ColorpickerWindow"]:FadeDescendants(true, function()
                        Debounce = false
                    end)

                    for Index, Value in Library.OpenFrames do
                        if Value ~= IsSettings then
                            Value:SetOpen(false)
                        end
                    end

                    Library.OpenFrames[Colorpicker] = Colorpicker 
                else
                    Items["ColorpickerWindow"]:Tween({
                        Position = Library:PopupPosition(ColorpickerButton, ColorpickerWindow, -10)
                    })

                    Items["ColorpickerWindow"]:FadeDescendants(false, function()
                        Debounce = false
                    end)

                    if Library.OpenFrames[Colorpicker] then 
                        Library.OpenFrames[Colorpicker] = nil
                    end
                end

                local Descendants = ColorpickerWindow:GetDescendants()
                table.insert(Descendants, ColorpickerWindow)

                for Index, Value in Descendants do 
                    if Value.ClassName:find("UI") then
                        continue
                    end

                    if IsSettings then
                        Value.ZIndex = Colorpicker.IsOpen and Library.ZIndexOrder.ColorpickerWindow + 4 or 1
                    else 
                        Value.ZIndex = Colorpicker.IsOpen and Library.ZIndexOrder.ColorpickerWindow or 1
                    end
                end
            end

            Items["ColorpickerWindow"]:VisibleCheck()
    
            local SlidingPalette = false
            local PaletteChanged
            
            function Colorpicker:SlidePalette(Input)
                if not Input or not SlidingPalette then
                    return
                end
    
                local ValueX = math.clamp(1 - (Input.Position.X - Items["Palette"].Instance.AbsolutePosition.X) / Items["Palette"].Instance.AbsoluteSize.X, 0, 1)
                local ValueY = math.clamp(1 - (Input.Position.Y - Items["Palette"].Instance.AbsolutePosition.Y) / Items["Palette"].Instance.AbsoluteSize.Y, 0, 1)
    
                Colorpicker.Saturation = ValueX
                Colorpicker.Value = ValueY
    
                local SlideX = math.clamp((Input.Position.X - Items["Palette"].Instance.AbsolutePosition.X) / Items["Palette"].Instance.AbsoluteSize.X, 0, 1)
                local SlideY = math.clamp((Input.Position.Y - Items["Palette"].Instance.AbsolutePosition.Y) / Items["Palette"].Instance.AbsoluteSize.Y, 0, 1)
    
                Items["PaletteDragger"]:Tween({Position = UDim2.new(SlideX, 0, SlideY, 0)}, ColorpickerInfo)
                Colorpicker:Update()
            end
            
            local SlidingHue = false
            local HueChanged
    
            function Colorpicker:SlideHue(Input)
                if not Input or not SlidingHue then
                    return
                end

                local ValueY = math.clamp((Input.Position.Y - Items["Hue"].Instance.AbsolutePosition.Y) / Items["Hue"].Instance.AbsoluteSize.Y, 0, 1)
    
                Colorpicker.Hue = ValueY
    
                local SlideY = math.clamp((Input.Position.Y - Items["Hue"].Instance.AbsolutePosition.Y) / Items["Hue"].Instance.AbsoluteSize.Y, 0, 0.99)
    
                Items["HueDragger"]:Tween({Position = UDim2.new(0, 0, SlideY, 0)}, ColorpickerInfo)
                Colorpicker:Update()
            end
    
            local SlidingAlpha = false 
            local AlphaChanged
    
            function Colorpicker:SlideAlpha(Input)
                if not Input or not SlidingAlpha then
                    return
                end
    
                local ValueY = math.clamp((Input.Position.Y - Items["Alpha"].Instance.AbsolutePosition.Y) / Items["Alpha"].Instance.AbsoluteSize.Y, 0, 1)
    
                Colorpicker.Alpha = ValueY
    
                local SlideY = math.clamp((Input.Position.Y - Items["Alpha"].Instance.AbsolutePosition.Y) / Items["Alpha"].Instance.AbsoluteSize.Y, 0, 0.99)
    
                Items["AlphaDragger"]:Tween({Position = UDim2.new(0, 0, SlideY, 0)}, ColorpickerInfo)
                Colorpicker:Update(true)
            end
    
            function Colorpicker:Set(Color, Alpha)
                if type(Color) == "table" then
                    Color = Color3.fromRGB(Color[1], Color[2], Color[3])
                elseif type(Color) == "string" then
                    Color = Color3.fromHex(Color)
                else
                    Color = Color -- Shit
                end 

                Colorpicker.Hue, Colorpicker.Saturation, Colorpicker.Value = Color:ToHSV()
                Colorpicker.Alpha = Alpha or 0  
    
                local PaletteValueX = math.clamp(1 - Colorpicker.Saturation, 0, 0.99)
                local PaletteValueY = math.clamp(1 - Colorpicker.Value, 0, 0.99)
    
                local AlphaPositionY = math.clamp(Colorpicker.Alpha, 0, 0.99)
                    
                local HuePositionY = math.clamp(Colorpicker.Hue, 0, 0.99)
    
                Items["PaletteDragger"]:Tween({Position = UDim2.new(PaletteValueX, 0, PaletteValueY, 0)}, ColorpickerInfo)
                Items["HueDragger"]:Tween({Position = UDim2.new(0, 0, HuePositionY, 0)}, ColorpickerInfo)
                Items["AlphaDragger"]:Tween({Position = UDim2.new(0, 0, AlphaPositionY, 0)}, ColorpickerInfo)
                Colorpicker:Update()
            end

            Items["ColorpickerButton"]:Connect("MouseButton1Down", function()
                Colorpicker:SetOpen(not Colorpicker.IsOpen)
            end)
    
            Items["Palette"]:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    SlidingPalette = true 
    
                    Colorpicker:SlidePalette(Input)
    
                    if PaletteChanged then
                        return
                    end
    
                    PaletteChanged = Input.Changed:Connect(function()
                        if Input.UserInputState == Enum.UserInputState.End then
                            SlidingPalette = false
    
                            PaletteChanged:Disconnect()
                            PaletteChanged = nil
                        end
                    end)
                end
            end)
    
            Items["Hue"]:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    SlidingHue = true 
    
                    Colorpicker:SlideHue(Input)
    
                    if HueChanged then
                        return
                    end
    
                    HueChanged = Input.Changed:Connect(function()
                        if Input.UserInputState == Enum.UserInputState.End then
                            SlidingHue = false
    
                            HueChanged:Disconnect()
                            HueChanged = nil
                        end
                    end)
                end
            end)
    
            Items["Alpha"]:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    SlidingAlpha = true 
    
                    Colorpicker:SlideAlpha(Input)
    
                    if AlphaChanged then
                        return
                    end
    
                    AlphaChanged = Input.Changed:Connect(function()
                        if Input.UserInputState == Enum.UserInputState.End then
                            SlidingAlpha = false
    
                            AlphaChanged:Disconnect()
                            AlphaChanged = nil
                        end
                    end)
                end
            end)
    
            Library:Connect(UserInputService.InputChanged, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                    if SlidingPalette then 
                        Colorpicker:SlidePalette(Input)
                    end
    
                    if SlidingHue then
                        Colorpicker:SlideHue(Input)
                    end
    
                    if SlidingAlpha then
                        Colorpicker:SlideAlpha(Input)
                    end
                end
            end)

            Library:Connect(UserInputService.InputBegan, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    if Colorpicker.IsOpen then
                        if Items["ColorpickerWindow"]:IsMouseOverFrame() then 
                            return 
                        end

                        Colorpicker:SetOpen(false)
                    end
                end
            end)

            if Data.Default then
                Colorpicker:Set(Data.Default, Data.Alpha)
            end
    
            SetFlags[Colorpicker.Flag] = function(Value, Alpha)
                Colorpicker:Set(Value, Alpha)
            end

            return Colorpicker, Items 
        end

        Library.CreateKeybind = function(Self, Data)
            local Keybind = {
                Flag = Data.Flag,
                IsOpen = false,

                Key = "",
                Mode = "",
                Value = "",

                Toggled = false,
                Picking = false,

                Items = { },
            }

            local Items = { } do
                Items["KeyButtonOutline"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Data.Parent.Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Size = UDim2.new(0, 0, 0, 13),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundColor3 = Library.Theme["Border"]
                }):AddToTheme({BackgroundColor3 = 'Border'})
                
                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["KeyButtonOutline"].Instance,
                    PaddingTop = UDim.new(0, 1),
                    PaddingBottom = UDim.new(0, 1),
                    PaddingRight = UDim.new(0, 1),
                    PaddingLeft = UDim.new(0, 1)
                })
                
                Items["KeyButton"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["KeyButtonOutline"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = "none",
                    AutoButtonColor = false,
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundColor3 = Library.Theme["Element 2"]
                }):AddToTheme({BackgroundColor3 = 'Element 2', TextColor3 = 'Text'})
                
                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["KeyButton"].Instance,
                    Rotation = 90,
                    Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(163, 163, 163))
                }
                })
                
                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["KeyButton"].Instance,
                    PaddingBottom = UDim.new(0, 2),
                    PaddingRight = UDim.new(0, 5),
                    PaddingLeft = UDim.new(0, 6)
                })             
                
                Items["KeybindWindow"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Library.Holder.Instance,
                    Visible = false,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Size = UDim2.new(0, 200, 0, 50),
                    Position = UDim2.new(0.5749104022979736, 0, 0.8196721076965332, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundColor3 = Library.Theme["Background"]
                }):AddToTheme({BackgroundColor3 = 'Background'})
                
                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["KeybindWindow"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({Color = 'Border'})
                
                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["KeybindWindow"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({Color = 'Outline'})
                
                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["KeybindWindow"].Instance,
                    PaddingTop = UDim.new(0, 8),
                    PaddingBottom = UDim.new(0, 8),
                    PaddingRight = UDim.new(0, 8),
                    PaddingLeft = UDim.new(0, 8)
                })

                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["KeybindWindow"].Instance,
                    Padding = UDim.new(0, 8)
                })                
                
                Keybind.Items = Items
            end

            Items["KeyButton"]:OnHover(function()
                Items["KeyButton"]:Tween({BackgroundColor3 = Library.Theme["Hovered Element"]})
            end, function()
                Items["KeyButton"]:Tween({BackgroundColor3 = Library.Theme.Element})
            end)

            local Debounce = false
            local KeybindWindow = Items["KeybindWindow"].Instance
            local KeyButton = Items["KeyButton"].Instance

            local IsSettings = Data.Section and Data.Section.IsSettings

            function Keybind:SetOpen(Bool)
                if Debounce then 
                    return 
                end

                Keybind.IsOpen = Bool

                Debounce = true 
                
                if Keybind.IsOpen then 
                    KeybindWindow.Visible = true
                    KeybindWindow.Position = Library:PopupPosition(KeyButton, KeybindWindow, 0)

                    Items["KeybindWindow"]:Tween({
                        Position = Library:PopupPosition(KeyButton, KeybindWindow, 10)
                    })
                    
                    Items["KeybindWindow"]:FadeDescendants(true, function()
                        Debounce = false 
                    end)

                    for Index, Value in Library.OpenFrames do 
                        if Value ~= IsSettings then
                            Value:SetOpen(false)
                        end
                    end

                    Library.OpenFrames[Keybind] = Keybind 
                else
                    Items["KeybindWindow"]:Tween({
                        Position = Library:PopupPosition(KeyButton, KeybindWindow, -10)
                    })

                    Items["KeybindWindow"]:FadeDescendants(false, function()
                        Debounce = false
                    end)

                    if Library.OpenFrames[Keybind] then 
                        Library.OpenFrames[Keybind] = nil
                    end
                end

                local Descendants = KeybindWindow:GetDescendants()
                table.insert(Descendants, KeybindWindow)

                for Index, Value in Descendants do 
                    if Value.ClassName:find("UI") then
                        continue
                    end

                    if IsSettings then 
                        Value.ZIndex = Keybind.IsOpen and Library.ZIndexOrder.KeybindWindow or 1
                    else
                        Value.ZIndex = Keybind.IsOpen and Library.ZIndexOrder.KeybindWindow + 1 or 1
                    end
                end
            end

            Items["KeybindWindow"]:VisibleCheck()
    
            function Keybind:SetMode()
                Flags[Keybind.Flag] = {
                    Mode = Keybind.Mode,
                    Key = Keybind.Key,
                    Toggled = Keybind.Toggled
                }
    
                if Data.Callback then 
                    Library:SafeCall(Data.Callback, Keybind.Toggled)
                end
            end

            local KeybindObject 

            if Library.KeyList and Data.Name ~= "Menu Keybind" then 
                KeybindObject = Library.KeyList:Add("", "", "")
            end

            local Update = function()
                if KeybindObject then 
                    KeybindObject:Set(Data.Name, Keybind.Mode, Keybind.Value)
                    KeybindObject:SetStatus(Keybind.Toggled)
                end
            end

            local ModeDropdown = Library:Dropdown({
                Name = "Mode",
                Flag = Keybind.Flag .. "ModeDropdown",
                Parent = Items["KeybindWindow"],
                Items = { "Toggle", "Hold", "Always" },
                Default = "Toggle",
                Callback = function(Value)
                    Keybind.Mode = Value
                    Keybind:SetMode()

                    if Value == "Always" then 
                        Keybind:Press(true)
                    end

                    Update()
                end
            })

            local ShowInKeybindsList = Library:Toggle({
                Name = "Show in keybinds list",
                Flag = Keybind.Flag .. "ShowInKeybindsList",
                Parent = Items["KeybindWindow"],
                Default = true,
                Callback = function(Value)
                    if KeybindObject then 
                        KeybindObject:SetVis(Value)
                        Update()
                    end
                end
            })
    
            function Keybind:Press(Bool)
                if Keybind.Mode == "Toggle" then 
                    Keybind.Toggled = not Keybind.Toggled
                elseif Keybind.Mode == "Hold" then 
                    Keybind.Toggled = Bool
                elseif Keybind.Mode == "Always" then 
                    Keybind.Toggled = true
                end
    
                Flags[Keybind.Flag] = {
                    Mode = Keybind.Mode,
                    Key = Keybind.Key,
                    Toggled = Keybind.Toggled
                }
    
                if Data.Callback then 
                    Library:SafeCall(Data.Callback, Keybind.Toggled)
                end

                Update()
            end
    
            function Keybind:Set(Key) -- this is so shit but its whatever
                if string.find(tostring(Key), "Enum") then 
                    Keybind.Key = tostring(Key)
    
                    Key = Key.Name == "Backspace" and "none" or Key.Name
    
                    local KeyString = Keys[Keybind.Key] or string.gsub(Key, "Enum.", "") or "none"
                    local TextToDisplay = string.gsub(string.gsub(KeyString, "KeyCode.", ""), "UserInputType.", "") or "none"
    
                    Keybind.Value = TextToDisplay
                    Items["KeyButton"].Instance.Text = TextToDisplay:lower()
    
                    Flags[Keybind.Flag] = {
                        Mode = Keybind.Mode,
                        Key = Keybind.Key,
                        Toggled = Keybind.Toggled
                    }
    
                    if Data.Callback then 
                        Library:SafeCall(Data.Callback, Keybind.Toggled)
                    end

                    Update()
                elseif type(Key) == "table" then
                    local RealKey = Key.Key == "Backspace" and "none" or Key.Key
                    Keybind.Key = tostring(Key.Key)
    
                    if Key.Mode then
                        Keybind.Mode = Key.Mode
                        Keybind:SetMode()
                    else
                        Keybind.Mode = "Toggle"
                        Keybind:SetMode()
                    end
    
                    local KeyString = Keys[Keybind.Key] or string.gsub(tostring(RealKey), "Enum.", "") or RealKey
                    local TextToDisplay = KeyString and string.gsub(string.gsub(KeyString, "KeyCode.", ""), "UserInputType.", "") or "none"
    
                    TextToDisplay = string.gsub(string.gsub(KeyString, "KeyCode.", ""), "UserInputType.", "")
    
                    Keybind.Value = TextToDisplay
                    Items["KeyButton"].Instance.Text = TextToDisplay:lower()
    
                    if Data.Callback then 
                        Library:SafeCall(Data.Callback, Keybind.Toggled)
                    end
                    
                    Update()
                elseif table.find({"Toggle", "Hold", "Always"}, Key) then
                    Keybind.Mode = Key
                    Keybind:SetMode()
    
                    if Data.Callback then 
                        Library:SafeCall(Data.Callback, Keybind.Toggled)
                    end

                    Update()
                end

                Keybind.Picking = false
            end
    
            Items["KeyButton"]:Connect("MouseButton1Click", function()
                Keybind.Picking = true 
    
                Items["KeyButton"].Instance.Text = ". . ."
    
                local InputBegan
                InputBegan = UserInputService.InputBegan:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.Keyboard then 
                        Keybind:Set(Input.KeyCode)
                    else
                        Keybind:Set(Input.UserInputType)
                    end
    
                    InputBegan:Disconnect()
                    InputBegan = nil
                end)
            end)
    
            Library:Connect(UserInputService.InputBegan, function(Input, GPE)
                if Keybind.Value == "none" then
                    return
                end
    
                if not GPE then
                    if tostring(Input.KeyCode) == Keybind.Key then
                        if Keybind.Mode == "Toggle" then 
                            Keybind:Press()
                        elseif Keybind.Mode == "Hold" then 
                            Keybind:Press(true)
                        elseif Keybind.Mode == "Always" then 
                            Keybind:Press(true)
                        end
                    elseif tostring(Input.UserInputType) == Keybind.Key then
                        if Keybind.Mode == "Toggle" then 
                            Keybind:Press()
                        elseif Keybind.Mode == "Hold" then 
                            Keybind:Press(true)
                        elseif Keybind.Mode == "Always" then 
                            Keybind:Press(true)
                        end
                    end
                end

                if Input.UserInputType == Enum.UserInputType.MouseButton1 and Keybind.IsOpen then 
                    if not Items["KeybindWindow"]:IsMouseOverFrame() and not ModeDropdown.Items.OptionHolder:IsMouseOverFrame() then
                        Keybind:SetOpen(false)
                    end
                end
            end)
    
            Library:Connect(UserInputService.InputEnded, function(Input, GPE)
                if GPE then
                    return
                end

                if Keybind.Value == "None" then
                    return
                end
    
                if tostring(Input.KeyCode) == Keybind.Key then
                    if Keybind.Mode == "Hold" then 
                        Keybind:Press(false)
                    elseif Keybind.Mode == "Always" then 
                        Keybind:Press(true)
                    end
                elseif tostring(Input.UserInputType) == Keybind.Key then
                    if Keybind.Mode == "Hold" then 
                        Keybind:Press(false)
                    elseif Keybind.Mode == "Always" then 
                        Keybind:Press(true)
                    end
                end
            end)
    
            Items["KeyButton"]:Connect("MouseButton2Down", function()
                Keybind:SetOpen(not Keybind.IsOpen)
            end)
    
            if Data.Default then 
                Keybind:Set({
                    Mode = Data.Mode or "Toggle",
                    Key = Data.Default,
                })
            end
    
            SetFlags[Keybind.Flag] = function(Value)
                Keybind:Set(Value)
            end

            return Keybind, Items 
        end

        Library.Watermark = function(Self, Params)
            Params = Params or { }

            local Watermark = {
                Name = Params.Name or Params.name or "Watermark",

                Items = { }
            }

            local Items = { } do 
                Items["Watermark"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Library.Holder.Instance,
                    AnchorPoint = Vector2.new(0, 0),
                    Position = UDim2.new(0, 10, 0, GuiInset + 10),
                    Size = UDim2.new(0, 0, 0, 53),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundColor3 = Library.Theme["Background"]
                }):AddToTheme({BackgroundColor3 = 'Background'})

                Items["Watermark"]:MakeDraggable()
                
                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Watermark"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({Color = 'Border'})
                
                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Watermark"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({Color = 'Outline'})
                
                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["Watermark"].Instance,
                    PaddingTop = UDim.new(0, 10),
                    PaddingBottom = UDim.new(0, 10),
                    PaddingRight = UDim.new(0, 10),
                    PaddingLeft = UDim.new(0, 10)
                })
                
                Items["Liner"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Watermark"].Instance,
                    AnchorPoint = Vector2.new(1, 0),
                    Position = UDim2.new(1, 1, 0, 0),
                    Size = UDim2.new(1, 2, 0, 2),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Accent"]
                }):AddToTheme({BackgroundColor3 = 'Accent'})
                
                Items["Glow"] = Library:Create("ImageLabel", {
                    Name = "\0",
                    Parent = Items["Liner"].Instance,
                    ImageColor3 = Library.Theme["Accent"],
                    ScaleType = Enum.ScaleType.Slice,
                    ImageTransparency = 0.800000011920929,
                    Size = UDim2.new(1, 25, 1, 25),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Image = "http://www.roblox.com/asset/?id=18245826428",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    BorderSizePixel = 0,
                    SliceCenter = Rect.new(Vector2.new(21, 21), Vector2.new(79, 79))
                }):AddToTheme({ImageColor3 = 'Accent'})
                
                Items["Inline"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Watermark"].Instance,
                    Size = UDim2.new(0, 0, 0, 25),
                    Position = UDim2.new(0, 0, 0, 6),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundColor3 = Library.Theme["Inline"]
                }):AddToTheme({BackgroundColor3 = 'Inline'})
                
                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Inline"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({Color = 'Outline'})
                
                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Inline"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({Color = 'Border'})
                
                Items["Holder"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Inline"].Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 0, 1, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                })
                
                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["Holder"].Instance,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    FillDirection = Enum.FillDirection.Horizontal,
                    Padding = UDim.new(0, 6),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })
                
                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["Holder"].Instance,
                    PaddingRight = UDim.new(0, 8),
                    PaddingLeft = UDim.new(0, 8)
                })
                
                Items["Title"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Holder"].Instance,
                    TextColor3 = Library.Theme["Accent"],
                    Text = Watermark.Name,
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY
                }):AddToTheme({TextColor3 = 'Accent'})
                
                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["Title"].Instance,
                    PaddingBottom = UDim.new(0, 2)
                })

                Watermark.Items = Items 
            end

            function Watermark:SetVisibility(Bool)
                Items["Watermark"].Instance.Visible = Bool
            end

            function Watermark:SetText(Text)
                Items["Title"].Instance.Text = tostring(Text)
            end
            
            function Watermark:Add(Text)
                Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Holder"].Instance,
                    Size = UDim2.new(0, 1, 1, -10),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Outline"]
                }):AddToTheme({BackgroundColor3 = 'Outline'})
                
                local NewItem = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Holder"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = Text,
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY
                }):AddToTheme({TextColor3 = 'Text'})

                function NewItem:SetText(Text)
                    NewItem.Instance.Text = tostring(Text)
                end

                function NewItem:SetVisibility(Bool)
                    NewItem.Instance.Visible = Bool
                end

                return NewItem
            end

            Self.Watermark = Watermark
            return setmetatable(Watermark, Library)
        end

        local KeybindTweenInfo = TweenInfo.new(0.55, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out) -- this is only for the keybind list and should not be used anywhere else
        
        Library.KeybindList = function(Self)
            local KeybindList = {
                Items = {},
                Keys = {}
            }
        
            local Items = {} do
                Items["KeybindList"] = Library:Create("Frame", {
                    Name = "\0", 
                    Parent = Library.Holder.Instance, 
                    AnchorPoint = Vector2.new(0, 0.5), 
                    Position = UDim2.new(0, 10, 0.5, 0), 
                    Size = UDim2.new(0, 34, 0, 53), 
                    ClipsDescendants = true, 
                    BorderSizePixel = 0, 
                    BackgroundColor3 = Library.Theme["Background"]
                }):AddToTheme({BackgroundColor3 = "Background"})

                Items["KeybindList"]:MakeDraggable()
        
                Library:Create("UIStroke", {
                    Parent = Items["KeybindList"].Instance, 
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border, 
                    LineJoinMode = Enum.LineJoinMode.Miter, 
                    Color = Library.Theme["Border"], 
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({Color = "Border"})

                Library:Create("UIStroke", {
                    Parent = Items["KeybindList"].Instance, 
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border, 
                    LineJoinMode = Enum.LineJoinMode.Miter, 
                    Color = Library.Theme["Outline"]
                }):AddToTheme({Color = "Outline"})
        
                Library:Create("UIPadding", {
                    Parent = Items["KeybindList"].Instance, 
                    PaddingTop = UDim.new(0, 10), 
                    PaddingBottom = UDim.new(0, 12), 
                    PaddingRight = UDim.new(0, 10), 
                    PaddingLeft = UDim.new(0, 10)
                })
        
                Items["Liner"] = Library:Create("Frame", {
                    Parent = Items["KeybindList"].Instance, 
                    AnchorPoint = Vector2.new(1, 0), 
                    Position = UDim2.new(1, 1, 0, 0), 
                    Size = UDim2.new(1, 2, 0, 2), 
                    BorderSizePixel = 0, 
                    BackgroundColor3 = Library.Theme["Accent"]
                }):AddToTheme({BackgroundColor3 = "Accent"})
        
                Items["Glow"] = Library:Create("ImageLabel", {
                    Parent = Items["Liner"].Instance, 
                    ImageColor3 = Library.Theme["Accent"], 
                    ScaleType = Enum.ScaleType.Slice, 
                    ImageTransparency = 0.8, 
                    Size = UDim2.new(1, 25, 1, 25), 
                    AnchorPoint = Vector2.new(0.5, 0.5), 
                    Image = "http://www.roblox.com/asset/?id=18245826428", 
                    BackgroundTransparency = 1, 
                    Position = UDim2.new(0.5, 0, 0.5, 0), 
                    BorderSizePixel = 0, 
                    SliceCenter = Rect.new(Vector2.new(21, 21), Vector2.new(79, 79))
                }):AddToTheme({ImageColor3 = "Accent"})
        
                Items["Inline"] = Library:Create("Frame", {
                    Parent = Items["KeybindList"].Instance, 
                    Size = UDim2.new(0, 8, 0, 25), 
                    Position = UDim2.new(0, 0, 0, 6), 
                    ClipsDescendants = true,
                    BorderSizePixel = 0, 
                    BackgroundColor3 = Library.Theme["Inline"]
                }):AddToTheme({BackgroundColor3 = "Inline"})
        
                Library:Create("UIStroke", {
                    Parent = Items["Inline"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border, 
                    LineJoinMode = Enum.LineJoinMode.Miter, 
                    Color = Library.Theme["Outline"]
                }):AddToTheme({Color = "Outline"})

                Library:Create("UIStroke", {
                    Parent = Items["Inline"].Instance, 
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border, 
                    LineJoinMode = Enum.LineJoinMode.Miter, 
                    Color = Library.Theme["Border"], 
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({Color = "Border"})
        
                Items["Content"] = Library:Create("Frame", {
                    Parent = Items["Inline"].Instance, 
                    BackgroundTransparency = 1, 
                    Position = UDim2.new(0, 0, 0, 0), 
                    Size = UDim2.new(0, 0, 0, 25), 
                    BorderSizePixel = 0
                })
            end
        
            Library.KeyList = KeybindList
            Self.KeybindList = KeybindList
        
            function KeybindList:SetVisibility(Bool)
                Items["KeybindList"].Instance.Visible = Bool
            end
        
            function KeybindList:UpdateSize()
                local Width = 0
                local Y = 6
                local Count = 0
        
                for Index, Value in KeybindList.Keys do
                    if Value.Showing then
                        local RowHeight = 14
        
                        Value.Object.Instance.Visible = true
                        Width = math.max(Width, Value.Object.Instance.TextBounds.X)
        
                        Value.Object:Tween({Position = UDim2.new(0, 8, 0, Y), Size = UDim2.new(0, Value.Object.Instance.TextBounds.X, 0, RowHeight), TextTransparency = 0}, KeybindTweenInfo)
        
                        Y += RowHeight + 4
                        Count += 1
                    end
                end
        
                local TargetHeight = Count > 0 and math.max(25, Y + 5) or 25
        
                Items["Content"].Instance.Size = UDim2.new(0, Width, 0, TargetHeight)
        
                Items["Inline"]:Tween({Size = UDim2.new(0, Width + 14, 0, TargetHeight)}, KeybindTweenInfo)
                Items["KeybindList"]:Tween({Size = UDim2.new(0, Width + 34, 0, TargetHeight + 28)}, KeybindTweenInfo)

                local ActiveKeys = { }

                for Index, Value in KeybindList.Keys do
                    if Value.Showing then
                        table.insert(ActiveKeys, Value.Object.Instance.Text)
                    end
                end
        
                if #ActiveKeys == 0 then 
                    Items["KeybindList"].Instance.Visible = false
                else
                    Items["KeybindList"].Instance.Visible = true
                end
            end
        
            function KeybindList:Add(Name, Mode, Key)
                local NewKeyText = Library:Create("TextLabel", {
                    Parent = Items["Content"].Instance, 
                    FontFace = Library.Font, 
                    TextSize = Library.FontSize, 
                    TextColor3 = Library.Theme["Text"], 
                    Text = Name .. " - " .. Mode .. " [" .. Key .. "]", 
                    BackgroundTransparency = 1, 
                    BorderSizePixel = 0, 
                    Size = UDim2.new(0, 0, 0, 14), 
                    Position = UDim2.new(0, -8, 0, 6), 
                    TextTransparency = 1, 
                    Visible = false, 
                    TextYAlignment = Enum.TextYAlignment.Center, 
                    TextXAlignment = Enum.TextXAlignment.Left
                }):AddToTheme({TextColor3 = "Text"})
        
                local CanShow = true
        
                local NewKey = {
                    Object = NewKeyText,
                    Showing = false
                }
        
                table.insert(KeybindList.Keys, NewKey)
        
                function NewKey:SetVis(Bool)
                    CanShow = Bool

                    if not Bool then
                        NewKey:SetStatus(false)
                    end
                end
        
                function NewKey:Set(Name, Mode, Key)
                    NewKey.Object.Instance.Text = Name .. " - " .. Mode .. " [" .. Key .. "]"

                    KeybindList:UpdateSize()
                end
        
                function NewKey:SetStatus(Bool)
                    Bool = Bool and CanShow
        
                    if NewKey.Showing == Bool then
                        return
                    end
        
                    NewKey.Showing = Bool
        
                    if Bool then
                        NewKeyText.Instance.Visible = true
                        NewKeyText.Instance.Position = UDim2.new(0, 0, 0, NewKeyText.Instance.Position.Y.Offset)
                        NewKeyText.Instance.TextTransparency = 1
        
                        KeybindList:UpdateSize()
                    else
                        NewKeyText:Tween({Position = UDim2.new(0, 0, 0, NewKeyText.Instance.Position.Y.Offset), TextTransparency = 1}, KeybindTweenInfo)
        
                        KeybindList:UpdateSize()
        
                        task.delay(KeybindTweenInfo.Time, function()
                            if not NewKey.Showing then
                                NewKeyText.Instance.Visible = false
                            end
                        end)
                    end
                end
        
                return NewKey
            end
        
            KeybindList:UpdateSize()
        
            return setmetatable(KeybindList, Library)
        end

        local NotifTweenInfo = TweenInfo.new(Library.NotifAnimation.Time, Enum.EasingStyle[Library.NotifAnimation.Style], Enum.EasingDirection[Library.NotifAnimation.Direction])

        Library.Notification = function(Self, Name, Duration, Color)
            Duration = Duration or 5
            Color = Color or Library.Theme.Accent
        
            local Notification = {
                Duration = Duration,
                Removing = false,
                Items = {}
            }
        
            local Padding = 8
            local Spacing = 8
        
            local function UpdatePositions()
                local Y = GuiInset + Padding + 5
            
                for Index, Value in Library.Notifications do
                    local Height = Value.Items["Notification"].Instance.AbsoluteSize.Y
            
                    Value.Items["Notification"]:Tween({Position = UDim2.new(0, Padding, 0, Y)}, NotifTweenInfo)
            
                    Y += Height + Spacing
                end
            end
        
            local Items = {} do
                Items["Notification"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Library.NotifHolder.Instance,
                    Size = UDim2.new(0, 0, 0, 25),
                    AnchorPoint = Vector2.new(0, 0),
                    Position = UDim2.new(0, -260, 0, GuiInset + Padding + 5),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundColor3 = Library.Theme["Inline"]
                }):AddToTheme({BackgroundColor3 = "Inline"})
        
                Library:Create("UIStroke", {
                    Name = "\0", 
                    Parent = 
                    Items["Notification"].Instance, 
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border, 
                    LineJoinMode = Enum.LineJoinMode.Miter, 
                    Color = Library.Theme["Border"], 
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({Color = "Border"})

                Library:Create("UIStroke", {
                    Name = "\0", 
                    Parent = Items["Notification"].Instance, 
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border, 
                    LineJoinMode = Enum.LineJoinMode.Miter, 
                    Color = Library.Theme["Outline"]
                }):AddToTheme({Color = "Outline"})
        
                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["Notification"].Instance,
                    PaddingRight = UDim.new(0, 8),
                    PaddingLeft = UDim.new(0, 8)
                })
        
                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Notification"].Instance,
                    TextColor3 = Library.Theme["Accent"],
                    Text = Name,
                    AnchorPoint = Vector2.new(0, 0.5),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 3, 0.5, -1),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY
                }):AddToTheme({TextColor3 = "Text"})
        
                Items["Liner"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Notification"].Instance,
                    Position = UDim2.new(0, -8, 0, 0),
                    Size = UDim2.new(0, 1, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color
                })
        
                Items["DurationLiner"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Notification"].Instance,
                    Position = UDim2.new(0, -8, 0, 0),
                    Size = UDim2.new(1, 16, 0, 1),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color
                })
        
                Notification.Items = Items
            end
        
            local FadeNotification = function(Transparency) -- cant use fadedescendants because that one saves the transparency and it breaks and looks really gay 
                Items["Notification"]:Tween({BackgroundTransparency = Transparency}, NotifTweenInfo)
        
                for _, Value in Items["Notification"].Instance:GetDescendants() do
                    if Value:IsA("TextLabel") then
                        Library:Tween({TextTransparency = Transparency}, NotifTweenInfo, Value)
                    elseif Value:IsA("Frame") then
                        Library:Tween({BackgroundTransparency = Transparency}, NotifTweenInfo, Value)
                    elseif Value:IsA("UIStroke") then
                        Library:Tween({Transparency = Transparency}, NotifTweenInfo, Value)
                    end
                end
            end
        
            table.insert(Library.Notifications, 1, Notification)
        
            task.wait()
        
            local Width = Items["Notification"].Instance.AbsoluteSize.X
            local Height = Items["Notification"].Instance.AbsoluteSize.Y
        
            Items["Notification"].Instance.Size = UDim2.new(0, Width, 0, Height)
            Items["Notification"].Instance.AutomaticSize = Enum.AutomaticSize.None
            Items["Notification"].Instance.BackgroundTransparency = 1
        
            for Index, Value in Items["Notification"].Instance:GetDescendants() do
                if Value:IsA("TextLabel") then
                    Value.TextTransparency = 1
                elseif Value:IsA("Frame") then
                    Value.BackgroundTransparency = 1
                elseif Value:IsA("UIStroke") then
                    Value.Transparency = 1
                end
            end
        
            UpdatePositions()
            FadeNotification(0)
        
            Items["DurationLiner"]:Tween({Size = UDim2.new(0, 0, 0, 1)}, TweenInfo.new(Duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out))
        
            task.spawn(function()
                local Tick = tick()
        
                while tick() - Tick < Duration and not Notification.Removing do
                    task.wait(0.05)
                end
        
                if Notification.Removing then return end
        
                Notification.Removing = true
        
                if not Library then return end 

                for Index, Value in Library.Notifications do
                    if Value == Notification then
                        table.remove(Library.Notifications, Index)
                        break
                    end
                end
        
                Items["Notification"]:Tween({Position = UDim2.new(0, -(Width + Padding + 20), 0, Items["Notification"].Instance.Position.Y.Offset)}, NotifTweenInfo)

                FadeNotification(1)
        
                task.delay(NotifTweenInfo.Time, function()
                    Items["Notification"].Instance:Destroy()
                    UpdatePositions()
                end)
            end)
        
            return Notification
        end
        
        Library.Window = function(Self, Params)
            Params = Params or { }

            local Window = {
                Name = Params.Name or Params.name or "Window",

                IsOpen = true,
                Pages = { },
                Items = { }
            }

            local Items = { } do 
                if IsMobile then 
                    Library:Create("UIScale", {
                        Parent = Library.Holder.Instance,
                        Scale = 0.7
                    })
                end

                Items["Outline"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Library.Holder.Instance,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    Size = UDim2.new(0, 613, 0, 453),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Border"]
                }):AddToTheme({BackgroundColor3 = 'Border'})

                Items["Outline"]:MakeDraggable()
                Items["Outline"]:MakeResizeable(Vector2.new(Items["Outline"].Instance.AbsoluteSize.X, Items["Outline"].Instance.AbsoluteSize.Y))
                
                Items["Outline2"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Outline"].Instance,
                    Position = UDim2.new(0, 1, 0, 1),
                    Size = UDim2.new(1, -2, 1, -2),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Outline"]
                }):AddToTheme({BackgroundColor3 = 'Outline'})
                
                Items["Background"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Outline2"].Instance,
                    Position = UDim2.new(0, 1, 0, 1),
                    Size = UDim2.new(1, -2, 1, -2),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Background"]
                }):AddToTheme({BackgroundColor3 = 'Background'})
                
                --[[
                Items["Title"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Items["Background"].Instance,
                    TextColor3 = Library.Theme["Accent"],
                    Text = Window.Name,
                    Position = UDim2.new(0, 8, 0, 8),
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY
                }):AddToTheme({TextColor3 = 'Accent'})
                --]]
                
                Items["Liner"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Background"].Instance,
                    Size = UDim2.new(1, 0, 0, 2),
                    Position = UDim2.new(0, 0, 0, 30),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Accent"]
                }):AddToTheme({BackgroundColor3 = 'Accent'})
                
                Items["Glow"] = Library:Create("ImageLabel", {
                    Name = "\0",
                    Parent = Items["Liner"].Instance,
                    ImageColor3 = Library.Theme["Accent"],
                    ScaleType = Enum.ScaleType.Slice,
                    ImageTransparency = 0.800000011920929,
                    Size = UDim2.new(1, 8, 1, 8),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Image = "http://www.roblox.com/asset/?id=18245826428",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    BorderSizePixel = 0,
                    SliceCenter = Rect.new(Vector2.new(21, 21), Vector2.new(79, 79))
                }):AddToTheme({ImageColor3 = 'Accent'})
                
                Items["Pages"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Background"].Instance,
                    AnchorPoint = Vector2.new(1, 0),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, 0, 0, 0),
                    Size = UDim2.new(0, 0, 0, 30),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                })
                
                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["Pages"].Instance,
                    PaddingBottom = UDim.new(0, 4),
                    PaddingRight = UDim.new(0, 8),
                    PaddingLeft = UDim.new(0, 8)
                })
                
                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["Pages"].Instance,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    FillDirection = Enum.FillDirection.Horizontal,
                    Padding = UDim.new(0, 8),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Items["Content"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Background"].Instance,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0, 30),
                    ClipsDescendants = true,
                    Size = UDim2.new(1, 0, 1, -30),
                    BorderSizePixel = 0
                })

                Window.Items = Items
            end

            local Debounce = false

            function Window:SetOpen(Bool)
                if Debounce then 
                    return 
                end

                for Index, Value in Window.Pages do 
                    if Value.Debounce then 
                        return 
                    end
                end

                Debounce = true 

                Window.IsOpen = Bool
                Items["Outline"]:FadeDescendants(Bool, function()
                    Debounce = false
                end)

                for Index, Value in Library.OpenFrames do 
                    Value:SetOpen(false)
                end
            end

            function Window:Center()
                local AbsPos = Items["Outline"].Instance.AbsolutePosition
                Items["Outline"].Instance.AnchorPoint = Vector2.new(0, 0)
                task.wait()
                Items["Outline"].Instance.Position = UDim2.new(0, AbsPos.X, 0, AbsPos.Y + GuiInset)
            end

            Library:Connect(UserInputService.InputBegan, function(Input)
                if tostring(Input.KeyCode) == Library.MenuKeybind or tostring(Input.UserInputType) == Library.MenuKeybind then
                    if UserInputService:GetFocusedTextBox() then
                        return
                    end

                    Window:SetOpen(not Window.IsOpen)
                end
            end)

            -- the title animation logic below
            local OffsetX = 8
            local OffsetY = 12
            local Width = 7 -- this would be the gap between each letter

            local WaveHeight = 4
            local WaveSpeed =  2.5
            local WaveSpacing = 0.25

            local Letters = { } -- try not to make the title too long since every letter is created individually for the animation

            for Index = 1, #Window.Name do 
                local Letter = Window.Name:sub(Index, Index)

                local NewLetter = Library:Create("TextLabel",{
                    Name = "\0",
                    Size = UDim2.new(0, Width, 0, 0),
                    Position = UDim2.new(0, OffsetX + ((Index - 1) * Width), 0, OffsetY),
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    Text = Letter,
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Background"].Instance
                }):AddToTheme({TextColor3 = 'Accent'})

                Letters[Index] = {
                    LetterInstance = NewLetter,
                    X = OffsetX + ((Index - 1) * Width),
                    Y = OffsetY
                }
            end

            Library:Connect(RunService.RenderStepped, function()
                local Tick = tick()

                for Index, Value in Letters do 
                    local OffsetY = math.sin((Tick * WaveSpeed) - (Index * WaveSpacing)) * WaveHeight

                    Value.LetterInstance.Instance.Position = UDim2.new(0, Value.X, 0, Value.Y + OffsetY)
                end
            end)            

            Window:Center()
            return setmetatable(Window, Library)
        end

        local PageInfo = TweenInfo.new(Library.TabAnimation.Time, Enum.EasingStyle[Library.TabAnimation.Style], Enum.EasingDirection[Library.TabAnimation.Direction])

        Library.Page = function(Self, Params)
            Params = Params or { }

            local Page = {
                Name = Params.Name or Params.name or "Page",

                Window = Self,
                ColumnsData = { },
                Items = { },
                Active = false,
                Debounce = false
            }

            local Items = { } do 
                Items["Inactive"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Page.Window.Items["Pages"].Instance,
                    TextColor3 = Library.Theme["Inactive Text"],
                    Text = Page.Name,
                    AutoButtonColor = false,
                    Size = UDim2.new(0, 0, 0, 20),
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                }):AddToTheme({TextColor3 = 'Inactive Text'})         
                
                Items["Page"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Library.UnusedHolder.Instance,
                    BackgroundTransparency = 1,
                    Visible = false,
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0
                })
                
                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["Page"].Instance,
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalFlex = Enum.UIFlexAlignment.Fill,
                    Padding = UDim.new(0, 11),
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    VerticalFlex = Enum.UIFlexAlignment.Fill
                })
                
                Items["LeftColumn"] = Library:Create("ScrollingFrame", {
                    Name = "\0",
                    Parent = Items["Page"].Instance,
                    ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0),
                    Active = true,
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    ScrollBarThickness = 0,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 100, 0, 100),
                    BorderSizePixel = 0,
                    CanvasSize = UDim2.new(0, 0, 0, 0)
                })
                
                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["LeftColumn"].Instance,
                    Padding = UDim.new(0, 15),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })
                
                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["LeftColumn"].Instance,
                    PaddingTop = UDim.new(0, 19),
                    PaddingBottom = UDim.new(0, 15),
                    PaddingRight = UDim.new(0, 2),
                    PaddingLeft = UDim.new(0, 10)
                })                

                Items["RightColumn"] = Library:Create("ScrollingFrame", {
                    Name = "\0",
                    Parent = Items["Page"].Instance,
                    ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0),
                    Active = true,
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    ScrollBarThickness = 0,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 100, 0, 100),
                    BorderSizePixel = 0,
                    CanvasSize = UDim2.new(0, 0, 0, 0)
                })
                
                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["RightColumn"].Instance,
                    Padding = UDim.new(0, 15),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })
                
                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["RightColumn"].Instance,
                    PaddingTop = UDim.new(0, 19),
                    PaddingBottom = UDim.new(0, 15),
                    PaddingRight = UDim.new(0, 10),
                    PaddingLeft = UDim.new(0, 2)
                })

                Page.ColumnsData[1] = Items["LeftColumn"]
                Page.ColumnsData[2] = Items["RightColumn"]

                Page.Items = Items
            end

            Items["Inactive"]:OnHover(function()
                if Page.Active then return end 
                
                Items["Inactive"]:Tween({TextColor3 = Library.Theme.Text})
            end, function()
                if Page.Active then return end 
                
                Items["Inactive"]:Tween({TextColor3 = Library.Theme["Inactive Text"]})
            end)

            function Page:Turn()
                local Old = Page.Window.Current 

                if Old == Page then 
                    return 
                end

                if Page.Debounce then 
                    return
                end

                if Old and Old.Debounce then 
                    return 
                end

                Page.Debounce = true 
                
                if Old then 
                    Old.Items["Page"].Instance.Position = UDim2.new(0, 0, 0, 0)
                    Old.Items["Inactive"]:ChangeItemTheme({TextColor3 = "Inactive Text"})
                    Old.Items["Inactive"]:Tween({TextColor3 = Library.Theme["Inactive Text"]})

                    Old.Items["Page"]:Tween({Position = UDim2.new(-1, 0, 0, 0)}, PageInfo)

                    Old.Items["Page"]:FadeDescendants(false, function()
                        Old.Items["Page"].Instance.Parent = Library.UnusedHolder.Instance
                    end)

                    Old.Active = false
                end

                Items["Page"].Instance.Position = UDim2.new(1, 0, 0, 0)
                
                Items["Page"].Instance.Parent = Page.Window.Items["Content"].Instance
                Items["Page"].Instance.Visible = true
                Items["Page"]:FadeDescendants(true, function()
                    Page.Debounce = false
                end)

                Items["Inactive"]:ChangeItemTheme({TextColor3 = "Accent"})
                Items["Inactive"]:Tween({TextColor3 = Library.Theme["Accent"]})

                Items["Page"]:Tween({Position = UDim2.new(0, 0, 0, 0)}, PageInfo)

                Page.Window.Current = Page
                Page.Active = true
            end

            Items["Inactive"]:Connect("MouseButton1Down", function()
                Page:Turn()
            end)

            if #Page.Window.Pages == 0 then 
                Page:Turn()
            end

            table.insert(Page.Window.Pages, Page)
            return setmetatable(Page, Library)
        end

        Library.Section = function(Self, Params)
            Params = Params or { } 

            local Section = {
                Name = Params.Name or Params.name or "Section",
                Side = Params.Side or Params.side or 1,

                Window = Self.Window,
                Page = Self,
                Items = { },
            }

            local Items = { } do 
                Items["Section"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Section.Page.ColumnsData[Section.Side].Instance,
                    Size = UDim2.new(1, 0, 0, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundColor3 = Library.Theme["Inline"]
                }):AddToTheme({BackgroundColor3 = 'Inline'})
                
                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Section"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({Color = 'Outline'})
                
                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Section"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({Color = 'Border'})
                
                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Items["Section"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = Section.Name,
                    Position = UDim2.new(0, 9, 0, -2),
                    Size = UDim2.new(0, 0, 0, 1),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundColor3 = Library.Theme["Background"]
                }):AddToTheme({BackgroundColor3 = 'Background'})
                
                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["Text"].Instance,
                    PaddingRight = UDim.new(0, 4),
                    PaddingLeft = UDim.new(0, 4)
                })
                
                Items["Content"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Section"].Instance,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 8, 0, 10),
                    Size = UDim2.new(1, -16, 0, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.Y
                })
                
                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["Content"].Instance,
                    Padding = UDim.new(0, 8),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["Section"].Instance,
                    PaddingBottom = UDim.new(0, 8)
                })                

                Section.Items = Items
            end 

            function Section:SetText(Text)
                Items["Text"].Instance.Text = tostring(Text)
            end

            return setmetatable(Section, Library)
        end

        Library.Toggle = function(Self, Params)
            Params = Params or { }

            local Toggle = {
                Name = Params.Name or Params.name or "Toggle",
                Flag = Params.Flag or Params.flag or (Params.Name or Params.name),
                Default = Params.Default or Params.default or false,
                Callback = Params.Callback or Params.callback or function() end,

                Window = Self.Window,
                Page = Self.Page,
                Section = Self,

                Value = false,
                Items = { }
            }

            local Parent 

            if Params.Parent then 
                Parent = Params.Parent
            else
                Parent = Toggle.Section.Items["Content"]
            end

            local Items = { } do 
                Items["Toggle"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Parent.Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 12),
                    BorderSizePixel = 0
                })
                
                Items["Outline"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Toggle"].Instance,
                    AnchorPoint = Vector2.new(0, 0.5),
                    Position = UDim2.new(0, 0, 0.5, 0),
                    Size = UDim2.new(0, 9, 0, 9),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Border"]
                }):AddToTheme({BackgroundColor3 = 'Border'})
                
                Items["Indicator"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Outline"].Instance,
                    Position = UDim2.new(0, 1, 0, 1),
                    Size = UDim2.new(1, -2, 1, -2),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Element 2"]
                }):AddToTheme({BackgroundColor3 = 'Element 2'})
                
                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["Indicator"].Instance,
                    Rotation = 90,
                    Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(163, 163, 163))
                }
                })
                
                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Items["Toggle"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = Toggle.Name,
                    Position = UDim2.new(0, 18, 0, -1),
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY
                }):AddToTheme({TextColor3 = 'Text'})       
                
                Items["SubElements"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Toggle"].Instance,
                    AnchorPoint = Vector2.new(1, 0),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, 0, 0, 0),
                    Size = UDim2.new(0, 0, 1, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                })
                
                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["SubElements"].Instance,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    FillDirection = Enum.FillDirection.Horizontal,
                    Padding = UDim.new(0, 8),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })                
            
                Toggle.Items = Items
            end

            Items["Toggle"]:OnHover(function()
                if Toggle.Value then return end 
                Items["Indicator"]:Tween({BackgroundColor3 = Library.Theme["Hovered Element"]})
            end, function()
                if Toggle.Value then return end 
                Items["Indicator"]:Tween({BackgroundColor3 = Library.Theme["Element 2"]})
            end)

            function Toggle:Set(Bool)
                Toggle.Value = Bool 

                if Bool then 
                    Items["Indicator"]:ChangeItemTheme({BackgroundColor3 = "Accent"})
                    Items["Indicator"]:Tween({BackgroundColor3 = Library.Theme.Accent})
                else
                    Items["Indicator"]:ChangeItemTheme({BackgroundColor3 = "Element 2"})
                    Items["Indicator"]:Tween({BackgroundColor3 = Library.Theme["Element 2"]})
                end

                Flags[Toggle.Flag] = Bool
                Library:SafeCall(Toggle.Callback, Bool)
            end

            function Toggle:SetVisibility(Bool)
                Items["Toggle"].Instance.Visible = Bool 
            end

            function Toggle:SetText(Text)
                Items["Text"].Instance.Text = tostring(Text)
            end

            function Toggle:Colorpicker(Data)
                Data = Data or { }

                local Colorpicker = {
                    Flag = Data.Flag or Data.flag or (Data.Name or Data.name or Toggle.Name),
                    Default = Data.Default or Data.default or Color3.fromRGB(255, 255, 255),
                    Callback = Data.Callback or Data.callback or function() end,
                    Alpha = Data.Alpha or Data.alpha or 0,

                    Window = Toggle.Window,
                    Page = Toggle.Page,
                    Section = Toggle.Section,
                }

                local NewColorpicker, ColorpickerItems = Library:CreateColorpicker({
                    Parent = Items["SubElements"],
                    Page = Colorpicker.Page,
                    Section = Colorpicker.Section,
                    Flag = Colorpicker.Flag,
                    Default = Colorpicker.Default,
                    Callback = Colorpicker.Callback,
                    Alpha = Colorpicker.Alpha
                })

                return NewColorpicker
            end

            function Toggle:Keybind(Data)
                Data = Data or { }

                local Keybind = {
                    Name = Data.Name or Data.name or Toggle.Name,
                    Flag = Data.Flag or Data.flag or (Data.Name or Data.name or Toggle.Name),
                    Default = Data.Default or Data.default or nil,
                    Callback = Data.Callback or Data.callback or function() end,
                    Mode = Data.Mode or Data.mode or "Toggle",

                    Window = Toggle.Window,
                    Page = Toggle.Page,
                    Section = Toggle.Section,
                }

                local NewKeybind, KeybindItems = Library:CreateKeybind({
                    Parent = Items["SubElements"],
                    Name = Keybind.Name,
                    Page = Keybind.Page,
                    Section = Keybind.Section,
                    Flag = Keybind.Flag,
                    Default = Keybind.Default,
                    Mode = Keybind.Mode,
                    Callback = Keybind.Callback
                })

                return NewKeybind
            end

            Items["Toggle"]:Connect("MouseButton1Down", function()
                Toggle:Set(not Toggle.Value)
            end)

            Toggle:Set(Toggle.Default)

            SetFlags[Toggle.Flag] = function(Value)
                Toggle:Set(Value)
            end

            return setmetatable(Toggle, Library)
        end

        Library.Button = function(Self, Params)
            Params = Params or { }

            local Button = {
                Name = Params.Name or Params.name or "Button",
                Callback = Params.Callback or Params.callback or function() end,

                Window = Self.Window,
                Page = Self.Page,
                Section = Self,
                Items = { }
            }

            local Parent 

            if Params.Parent then 
                Parent = Params.Parent
            else
                Parent = Button.Section.Items["Content"]
            end

            local Items = { } do 
                Items["Button"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Parent.Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Size = UDim2.new(1, 0, 0, 20),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Border"]
                }):AddToTheme({BackgroundColor3 = 'Border'})
                
                Items["Inline"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Button"].Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Position = UDim2.new(0, 1, 0, 1),
                    Size = UDim2.new(1, -2, 1, -2),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Outline"]
                }):AddToTheme({BackgroundColor3 = 'Outline'})
                
                Items["RealButton"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Inline"].Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Position = UDim2.new(0, 1, 0, 1),
                    Size = UDim2.new(1, -2, 1, -2),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Element"]
                }):AddToTheme({BackgroundColor3 = 'Element'})
                
                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["RealButton"].Instance,
                    Rotation = 90,
                    Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(163, 163, 163))
                }
                })
                
                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Items["RealButton"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = Button.Name,
                    AutomaticSize = Enum.AutomaticSize.XY,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new(0.5, 0, 0.5, -1),
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    ZIndex = 2
                }):AddToTheme({TextColor3 = 'Text'})
                
                Items["Accent"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["RealButton"].Instance,
                    Size = UDim2.new(0, 0, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    BackgroundColor3 = Library.Theme["Accent"]
                }):AddToTheme({BackgroundColor3 = 'Accent'})                

                Button.Items = Items
            end

            Items["RealButton"]:OnHover(function()
                Items["RealButton"]:Tween({BackgroundColor3 = Library.Theme["Hovered Element"]})
            end, function()
                Items["RealButton"]:Tween({BackgroundColor3 = Library.Theme.Element})
            end)

            function Button:Press()
                pcall(function() -- i have to do this so it doesnt error on unload
                    Library:SafeCall(Button.Callback)

                    Items["Accent"]:Tween({BackgroundTransparency = 0, Size = UDim2.new(1, 0, 1, 0)})
                    task.wait(Library.Animation.Time - 0.1)
                    Items["Accent"]:Tween({BackgroundTransparency = 1, Size = UDim2.new(0, 0, 1, 0)})
                end)
            end

            function Button:SetVisibility(Bool)
                Items["Button"].Instance.Visible = Bool
            end

            function Button:SetText(Text)
                Items["Text"].Instance.Text = tostring(Text)
            end

            Items["RealButton"]:Connect("MouseButton1Down", function()
                Button:Press()
            end)

            return setmetatable(Button, Library)
        end

        Library.Slider = function(Self, Params)
            Params = Params or { }

            local Slider = {
                Name = Params.Name or Params.name or "Slider",
                Flag = Params.Flag or Params.flag or (Params.Name or Params.name),
                Default = Params.Default or Params.default or 0,
                Min = Params.Min or Params.min or 0,
                Max = Params.Max or Params.max or 100,
                Callback = Params.Callback or Params.callback or function() end,
                Decimals = Params.Decimals or Params.decimals or 1,
                Suffix = Params.Suffix or Params.suffix or "",

                Window = Self.Window,
                Page = Self.Page,
                Section = Self,

                Value = 0,
                Sliding = false,
                Items = { }
            }

            local Parent 

            if Params.Parent then 
                Parent = Params.Parent
            else
                Parent = Slider.Section.Items["Content"]
            end

            local Items = { } do 
                Items["Slider"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Parent.Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 30),
                    BorderSizePixel = 0
                })
                
                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Items["Slider"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = Slider.Name,
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY
                }):AddToTheme({TextColor3 = 'Text'})
                
                Items["RealSliderOutline"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Slider"].Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    AnchorPoint = Vector2.new(0, 1),
                    Position = UDim2.new(0, 0, 1, 0),
                    Size = UDim2.new(1, 0, 0, 9),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Border"]
                }):AddToTheme({BackgroundColor3 = 'Border'})
                
                Items["RealSlider"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["RealSliderOutline"].Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Position = UDim2.new(0, 1, 0, 1),
                    Size = UDim2.new(1, -2, 1, -2),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Element 2"]
                }):AddToTheme({BackgroundColor3 = 'Element 2'})
                
                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["RealSlider"].Instance,
                    Rotation = 90,
                    Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(163, 163, 163))
                }
                })
                
                Items["AccentHolder"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["RealSlider"].Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0
                })
                
                Items["Accent"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["AccentHolder"].Instance,
                    Size = UDim2.new(0.5, 0, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Accent"]
                }):AddToTheme({BackgroundColor3 = 'Accent'})
                
                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["Accent"].Instance,
                    Rotation = 90,
                    Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(163, 163, 163))
                }
                })
                
                Items["Value"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Items["Slider"].Instance,
                    TextColor3 = Library.Theme["Inactive Text"],
                    Text = "2.5",
                    AnchorPoint = Vector2.new(1, 0),
                    Position = UDim2.new(1, 1, 0, 0),
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY
                }):AddToTheme({TextColor3 = 'Inactive Text'})                

                Slider.Items = Items 
            end

            Items["RealSlider"]:OnHover(function()
                Items["RealSlider"]:Tween({BackgroundColor3 = Library.Theme["Hovered Element"]})
            end, function()
                Items["RealSlider"]:Tween({BackgroundColor3 = Library.Theme.Element})
            end)

            function Slider:Set(Value)
                Slider.Value = Library:Round(math.clamp(Value, Slider.Min, Slider.Max), Slider.Decimals)

                Items["Accent"]:Tween({Size = UDim2.new((Slider.Value - Slider.Min) / (Slider.Max - Slider.Min), 0, 1, 0)}, TweenInfo.new(Library.Animation.Time, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out))
                Items["Value"].Instance.Text = string.format("%s%s", Slider.Value, Slider.Suffix)

                Flags[Slider.Flag] = Slider.Value
                Library:SafeCall(Slider.Callback, Slider.Value)
            end

            function Slider:SetVisibility(Bool)
                Items["Slider"].Instance.Visible = Bool
            end

            function Slider:GetSize(Input)
                local SizeX = (Input.Position.X - Items["RealSlider"].Instance.AbsolutePosition.X) / Items["RealSlider"].Instance.AbsoluteSize.X
                local Value = ((Slider.Max - Slider.Min) * SizeX) + Slider.Min

                return Value
            end

            function Slider:SetText(Text)
                Items["Text"].Instance.Text = tostring(Text)
            end

            local InputChanged 
            
            Items["RealSlider"]:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    Items["Value"]:Tween({TextColor3 = Library.Theme.Text})
                    Slider.Sliding = true

                    local Value = Slider:GetSize(Input)

                    Slider:Set(Value)

                    if InputChanged then
                        return
                    end

                    InputChanged = Input.Changed:Connect(function()
                        if Input.UserInputState == Enum.UserInputState.End then
                            Items["Value"]:Tween({TextColor3 = Library.Theme["Inactive Text"]})
                            Slider.Sliding = false

                            InputChanged:Disconnect()
                            InputChanged = nil
                        end
                    end)
                end
            end)

            Library:Connect(UserInputService.InputChanged, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                    if Slider.Sliding then
                        local Value = Slider:GetSize(Input)

                        Slider:Set(Value)
                    end
                end
            end)

            Slider:Set(Slider.Default)

            SetFlags[Slider.Flag] = function(Value)
                Slider:Set(Value)
            end

            return setmetatable(Slider, Library)
        end

        Library.Dropdown = function(Self, Params)
            Params = Params or { }

            local Dropdown = {
                Name = Params.Name or Params.name or "Dropdown",
                OptionItems = Params.Items or Params.items or { },
                Flag = Params.Flag or Params.flag or (Params.Name or Params.name),
                Default = Params.Default or Params.default or "",
                Callback = Params.Callback or Params.callback or function() end,
                Multi = Params.Multi or Params.multi or false,

                Window = Self.Window,
                Page = Self.Page,
                Section = Self,

                Value = { },
                Options = { },
                IsOpen = false,
                Items = { }
            }

            local Parent 

            if Params.Parent then 
                Parent = Params.Parent
            else
                Parent = Dropdown.Section.Items["Content"]
            end

            local Items = { } do 
                Items["Dropdown"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Parent.Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 40),
                    BorderSizePixel = 0
                })
                
                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Items["Dropdown"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = Dropdown.Name,
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY
                }):AddToTheme({TextColor3 = 'Text'})
                
                Items["RealDropdownOutline"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Dropdown"].Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    AnchorPoint = Vector2.new(0, 1),
                    Position = UDim2.new(0, 0, 1, 0),
                    Size = UDim2.new(1, 0, 0, 20),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Border"]
                }):AddToTheme({BackgroundColor3 = 'Border'})
                
                Items["Inline"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["RealDropdownOutline"].Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Position = UDim2.new(0, 1, 0, 1),
                    Size = UDim2.new(1, -2, 1, -2),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Outline"]
                }):AddToTheme({BackgroundColor3 = 'Outline'})
                
                Items["RealDropdown"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Inline"].Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Position = UDim2.new(0, 1, 0, 1),
                    Size = UDim2.new(1, -2, 1, -2),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Element"]
                }):AddToTheme({BackgroundColor3 = 'Element'})
                
                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["RealDropdown"].Instance,
                    Rotation = 90,
                    Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(163, 163, 163))
                }
                })
                
                Items["Icon"] = Library:Create("ImageLabel", {
                    Name = "\0",
                    Parent = Items["RealDropdown"].Instance,
                    ImageColor3 = Library.Theme["Accent"],
                    AnchorPoint = Vector2.new(1, 0.5),
                    Image = "rbxassetid://98057726606591",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, -1, 0.5, -1),
                    Size = UDim2.new(0, 16, 0, 16),
                    BorderSizePixel = 0
                }):AddToTheme({ImageColor3 = 'Accent'})
                
                Items["Value"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Items["RealDropdown"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = "none",
                    Size = UDim2.new(1, -24, 0, 0),
                    Position = UDim2.new(0, 4, 0.5, -1),
                    AnchorPoint = Vector2.new(0, 0.5),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    TextTruncate = Enum.TextTruncate.AtEnd,
                    AutomaticSize = Enum.AutomaticSize.Y
                }):AddToTheme({TextColor3 = 'Text'})          
                
                Items["OptionHolder"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Library.Holder.Instance,
                    Visible = false,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Size = UDim2.new(0, 200, 0, 50),
                    Position = UDim2.new(0, 792, 0, 649),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundColor3 = Library.Theme["Background"]
                }):AddToTheme({BackgroundColor3 = 'Background'})
                
                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["OptionHolder"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({Color = 'Border'})
                
                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["OptionHolder"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({Color = 'Outline'})
                
                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["OptionHolder"].Instance,
                    PaddingTop = UDim.new(0, 8),
                    PaddingBottom = UDim.new(0, 8),
                    PaddingRight = UDim.new(0, 8),
                    PaddingLeft = UDim.new(0, 8)
                })

                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["OptionHolder"].Instance,
                    Padding = UDim.new(0, 8),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Dropdown.Items = Items 
            end

            Items["RealDropdown"]:OnHover(function()
                Items["RealDropdown"]:Tween({BackgroundColor3 = Library.Theme["Hovered Element"]})
            end, function()
                Items["RealDropdown"]:Tween({BackgroundColor3 = Library.Theme.Element})
            end)

            function Dropdown:Set(Value)
                if Dropdown.Multi then 
                    if type(Value) ~= "table" then 
                        return
                    end

                    Dropdown.Value = Value

                    for Index, Value in Value do
                        local OptionData = Dropdown.Options[Value]
                         
                        if not OptionData then
                            continue
                        end

                        OptionData.IsSelected = true 
                        OptionData:ToggleState("Active")
                    end

                    Flags[Dropdown.Flag] = Value
                    Items["Value"].Instance.Text = table.concat(Value, ", ")
                else
                    if not Dropdown.Options[Value] then
                        return
                    end

                    local OptionData = Dropdown.Options[Value]

                    Dropdown.Value = Value

                    for Index, Value in Dropdown.Options do
                        if Value ~= OptionData then
                            Value.IsSelected = false 
                            Value:ToggleState("Inactive")
                        else
                            Value.IsSelected = true 
                            Value:ToggleState("Active")
                        end
                    end

                    Flags[Dropdown.Flag] = Value
                    Items["Value"].Instance.Text = Value
                end

                Library:SafeCall(Dropdown.Callback, Dropdown.Value)
            end

            function Dropdown:Add(Value)
                local OptionButton = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Items["OptionHolder"].Instance,
                    TextColor3 = Library.Theme["Inactive Text"],
                    Text = Value,
                    AutoButtonColor = false,
                    Size = UDim2.new(1, 0, 0, 0),
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.Y
                }):AddToTheme({TextColor3 = 'Inactive Text'})

                local OptionData = {
                    Button = OptionButton,
                    Name = Value,
                    IsSelected = false
                }

                OptionButton:OnHover(function()
                    if OptionData.IsSelected then return end 

                    OptionButton:Tween({TextColor3 = Library.Theme.Text})
                end, function()
                    if OptionData.IsSelected then return end 

                    OptionButton:Tween({TextColor3 = Library.Theme["Inactive Text"]})
                end)
                
                function OptionData:ToggleState(Value)
                    if Value == "Active" then
                        OptionButton:ChangeItemTheme({TextColor3 = "Accent"})
                        OptionButton:Tween({TextColor3 = Library.Theme.Accent})
                    else
                        OptionButton:ChangeItemTheme({TextColor3 = "Inactive Text"})
                        OptionButton:Tween({TextColor3 = Library.Theme["Inactive Text"]})
                    end
                end

                function OptionData:Set()
                    Library:Thread(function()
                        Items["Value"]:Tween({TextTransparency = 1})
                        task.wait(0.1)
                        Items["Value"]:Tween({TextTransparency = 0})
                    end)

                    OptionData.IsSelected = not OptionData.IsSelected

                    if Dropdown.Multi then 
                        local Index = table.find(Dropdown.Value, OptionData.Name)

                        if Index then 
                            table.remove(Dropdown.Value, Index)
                        else
                            table.insert(Dropdown.Value, OptionData.Name)
                        end

                        OptionData:ToggleState(Index and "Inactive" or "Active")

                        Flags[Dropdown.Flag] = Dropdown.Value

                        local TextFormat = #Dropdown.Value > 0 and table.concat(Dropdown.Value, ", ") or "none"
                        Items["Value"].Instance.Text = TextFormat
                    else
                        if OptionData.IsSelected then 
                            Dropdown.Value = OptionData.Name
                            Flags[Dropdown.Flag] = OptionData.Name

                            OptionData.IsSelected = true
                            OptionData:ToggleState("Active")

                            for Index, Value in Dropdown.Options do 
                                if Value ~= OptionData then
                                    Value.IsSelected = false 
                                    Value:ToggleState("Inactive")
                                end
                            end

                            Items["Value"].Instance.Text = OptionData.Name
                        else
                            Dropdown.Value = nil
                            Flags[Dropdown.Flag] = nil

                            OptionData.IsSelected = false
                            OptionData:ToggleState("Inactive")

                            Items["Value"].Instance.Text = "none"
                        end
                    end

                    Library:SafeCall(Dropdown.Callback, Dropdown.Value)
                end

                OptionData.Button:Connect("MouseButton1Down", function()
                    OptionData:Set()
                end)

                Dropdown.Options[OptionData.Name] = OptionData
                return OptionData
            end

            function Dropdown:Remove(Option)
                if Dropdown.Options[Option] then
                    Dropdown.Options[Option].Button.Instance:Destroy()
                    Dropdown.Options[Option] = nil
                end
            end

            function Dropdown:Refresh(List)
                for Index, Value in Dropdown.Options do 
                    Dropdown:Remove(Value.Name)
                end

                for Index, Value in List do 
                    Dropdown:Add(Value)
                end
            end

            function Dropdown:SetText(Text)
                Items["Text"].Instance.Text = tostring(Text)
            end

            function Dropdown:SetVisibility(Bool)
                Items["Dropdown"].Instance.Visible = Bool 
            end

            local Debounce = false 
            local OptionHolder = Items["OptionHolder"].Instance
            local RealDropdown = Items["RealDropdown"].Instance

            local IsSettings = Dropdown.Section and Dropdown.Section.IsSettings

            function Dropdown:SetOpen(Bool)
                if Debounce then 
                    return 
                end

                Dropdown.IsOpen = Bool

                Debounce = true 
                
                if Dropdown.IsOpen then 
                    Items["OptionHolder"].Instance.Visible = true

                    local Scale = Library:GetScreenScale()
                    OptionHolder.Position = Library:PopupPosition(RealDropdown, OptionHolder, 0)
                    OptionHolder.Size = UDim2.new(0, RealDropdown.AbsoluteSize.X / Scale, 0, 0)
                    
                    Items["OptionHolder"]:Tween({
                        Position = Library:PopupPosition(RealDropdown, OptionHolder, 10)
                    })
                    
                    Items["OptionHolder"]:FadeDescendants(true, function()
                        Debounce = false 
                    end)

                    for Index, Value in Library.OpenFrames do 
                        if Value ~= IsSettings and not Params.Parent then
                            Value:SetOpen(false)
                        end
                    end

                    Library.OpenFrames[Dropdown] = Dropdown 
                else
                    Items["OptionHolder"]:Tween({
                        Position = Library:PopupPosition(RealDropdown, OptionHolder, -10)
                    })

                    Items["OptionHolder"]:FadeDescendants(false, function()
                        Debounce = false
                    end)

                    if Library.OpenFrames[Dropdown] then 
                        Library.OpenFrames[Dropdown] = nil
                    end
                end

                local Descendants = OptionHolder:GetDescendants()
                table.insert(Descendants, OptionHolder)

                for Index, Value in Descendants do 
                    if Value.ClassName:find("UI") then
                        continue
                    end

                    if not Params.Parent then
                        Value.ZIndex = Dropdown.IsOpen and Library.ZIndexOrder.OptionHolder or 1
                    else
                        Value.ZIndex = Dropdown.IsOpen and Library.ZIndexOrder.OptionHolder + 3 or 1
                    end
                end
            end

            Items["OptionHolder"]:VisibleCheck()

            Library:Connect(UserInputService.InputBegan, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                    if Dropdown.IsOpen and not Items["OptionHolder"]:IsMouseOverFrame() then
                        Dropdown:SetOpen(false)
                    end
                end
            end)

            Items["RealDropdown"]:Connect("MouseButton1Down", function()
                Dropdown:SetOpen(not Dropdown.IsOpen)
            end)

            for Index, Value in Dropdown.OptionItems do 
                Dropdown:Add(Value)
            end

            Dropdown:Set(Dropdown.Default)

            SetFlags[Dropdown.Flag] = function(Value)
                Dropdown:Set(Value)
            end

            return setmetatable(Dropdown, Library)
        end

        Library.List = function(Self, Params)
            Params = Params or { }

            local List = {
                OptionItems = Params.Items or Params.items or { },
                Flag = Params.Flag or Params.flag or (Params.Name or Params.name),
                Default = Params.Default or Params.default or "",
                Callback = Params.Callback or Params.callback or function() end,
                Multi = Params.Multi or Params.multi or false,

                Window = Self.Window,
                Page = Self.Page,
                Section = Self,

                Value = { },
                Options = { },
                Items = { }
            }

            local Parent 

            if Params.Parent then 
                Parent = Params.Parent
            else
                Parent = List.Section.Items["Content"]
            end

            local Items = { } do 
                Items["List"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Parent.Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 200),
                    BorderSizePixel = 0
                })
                
                Items["SearchOutline"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["List"].Instance,
                    Size = UDim2.new(1, 0, 0, 20),
                    Active = true,
                    Selectable = true,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Border"]
                }):AddToTheme({BackgroundColor3 = 'Border'})
                
                Items["SearchInline"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["SearchOutline"].Instance,
                    Active = true,
                    Position = UDim2.new(0, 1, 0, 1),
                    Selectable = true,
                    Size = UDim2.new(1, -2, 1, -2),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Outline"]
                }):AddToTheme({BackgroundColor3 = 'Outline'})
                
                Items["SearchBackground"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["SearchInline"].Instance,
                    ClipsDescendants = true,
                    Size = UDim2.new(1, -2, 1, -2),
                    Position = UDim2.new(0, 1, 0, 1),
                    Selectable = true,
                    Active = true,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Element"]
                }):AddToTheme({BackgroundColor3 = 'Element'})
                
                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["SearchBackground"].Instance,
                    Rotation = 90,
                    Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(163, 163, 163))
                }
                })
                
                Items["Input"] = Library:Create("TextBox", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Items["SearchBackground"].Instance,
                    AnchorPoint = Vector2.new(0, 0.5),
                    PlaceholderColor3 = Library.Theme["Inactive Text"],
                    PlaceholderText = "Search..",
                    Size = UDim2.new(1, -8, 0, 0),
                    TextColor3 = Library.Theme["Text"],
                    Text = "",
                    Position = UDim2.new(0, 4, 0.5, -1),
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    ClearTextOnFocus = false,
                    AutomaticSize = Enum.AutomaticSize.Y
                }):AddToTheme({TextColor3 = 'Text', PlaceholderColor3 = 'Inactive Text'})
                
                Items["ListOutline"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["List"].Instance,
                    Position = UDim2.new(0, 0, 0, 25),
                    Size = UDim2.new(1, 0, 1, -25),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Border"]
                }):AddToTheme({BackgroundColor3 = 'Border'})
                
                Items["ListInline"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["ListOutline"].Instance,
                    Position = UDim2.new(0, 1, 0, 1),
                    Size = UDim2.new(1, -2, 1, -2),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Outline"]
                }):AddToTheme({BackgroundColor3 = 'Outline'})
                
                Items["ListBackground"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["ListInline"].Instance,
                    Position = UDim2.new(0, 1, 0, 1),
                    Size = UDim2.new(1, -2, 1, -2),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Element"]
                }):AddToTheme({BackgroundColor3 = 'Element'})
                
                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["ListBackground"].Instance,
                    Rotation = 90,
                    Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(163, 163, 163))
                }
                })
                
                Items["Holder"] = Library:Create("ScrollingFrame", {
                    Name = "\0",
                    Parent = Items["ListBackground"].Instance,
                    Active = true,
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    BorderSizePixel = 0,
                    CanvasSize = UDim2.new(0, 0, 0, 0),
                    ScrollBarImageColor3 = Library.Theme["Accent"],
                    MidImage = "rbxassetid://81680855285439",
                    ScrollBarThickness = 2,
                    Size = UDim2.new(1, -16, 1, -16),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 8, 0, 8),
                    BottomImage = "rbxassetid://81680855285439",
                    TopImage = "rbxassetid://81680855285439"
                }):AddToTheme({ScrollBarImageColor3 = 'Accent'})
                
                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["Holder"].Instance,
                    Padding = UDim.new(0, 8),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })
                
                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["Holder"].Instance,
                    PaddingBottom = UDim.new(0, 8)
                })                

                List.Items = Items 
            end

            function List:Set(Value)
                if List.Multi then 
                    if type(Value) ~= "table" then 
                        return
                    end

                    List.Value = Value

                    for Index, Value in Value do
                        local OptionData = List.Options[Value]
                         
                        if not OptionData then
                            continue
                        end

                        OptionData.IsSelected = true 
                        OptionData:ToggleState("Active")
                    end

                    Flags[List.Flag] = Value
                else
                    if not List.Options[Value] then
                        return
                    end

                    local OptionData = List.Options[Value]

                    List.Value = Value

                    for Index, Value in List.Options do
                        if Value ~= OptionData then
                            Value.IsSelected = false 
                            Value:ToggleState("Inactive")
                        else
                            Value.IsSelected = true 
                            Value:ToggleState("Active")
                        end
                    end

                    Flags[List.Flag] = Value
                end

                Library:SafeCall(List.Callback, List.Value)
            end

            function List:Add(Value)
                local OptionButton = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    TextXAlignment = Enum.TextXAlignment.Center,
                    Parent = Items["Holder"].Instance,
                    TextColor3 = Library.Theme["Inactive Text"],
                    Text = Value,
                    AutoButtonColor = false,
                    Size = UDim2.new(1, 0, 0, 0),
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.Y
                }):AddToTheme({TextColor3 = 'Inactive Text'})

                local OptionData = {
                    Button = OptionButton,
                    Name = Value,
                    IsSelected = false
                }

                OptionButton:OnHover(function()
                    if OptionData.IsSelected then return end 

                    OptionButton:Tween({TextColor3 = Library.Theme.Text})
                end, function()
                    if OptionData.IsSelected then return end 

                    OptionButton:Tween({TextColor3 = Library.Theme["Inactive Text"]})
                end)
                
                function OptionData:ToggleState(Value)
                    if Value == "Active" then
                        OptionButton:ChangeItemTheme({TextColor3 = "Accent"})
                        OptionButton:Tween({TextColor3 = Library.Theme.Accent})
                    else
                        OptionButton:ChangeItemTheme({TextColor3 = "Inactive Text"})
                        OptionButton:Tween({TextColor3 = Library.Theme["Inactive Text"]})
                    end
                end

                function OptionData:Set()
                    OptionData.IsSelected = not OptionData.IsSelected

                    if List.Multi then 
                        local Index = table.find(List.Value, OptionData.Name)

                        if Index then 
                            table.remove(List.Value, Index)
                        else
                            table.insert(List.Value, OptionData.Name)
                        end

                        OptionData:ToggleState(Index and "Inactive" or "Active")

                        Flags[List.Flag] = List.Value
                    else
                        if OptionData.IsSelected then 
                            List.Value = OptionData.Name
                            Flags[List.Flag] = OptionData.Name

                            OptionData.IsSelected = true
                            OptionData:ToggleState("Active")

                            for Index, Value in List.Options do 
                                if Value ~= OptionData then
                                    Value.IsSelected = false 
                                    Value:ToggleState("Inactive")
                                end
                            end
                        else
                            List.Value = nil
                            Flags[List.Flag] = nil

                            OptionData.IsSelected = false
                            OptionData:ToggleState("Inactive")
                        end
                    end

                    Library:SafeCall(List.Callback, List.Value)
                end

                OptionData.Button:Connect("MouseButton1Down", function()
                    OptionData:Set()
                end)

                List.Options[OptionData.Name] = OptionData
                return OptionData
            end

            function List:Remove(Option)
                if List.Options[Option] then
                    List.Options[Option].Button.Instance:Destroy()
                    List.Options[Option] = nil
                end
            end

            function List:Refresh(NewList)
                for Index, Value in List.Options do 
                    List:Remove(Value.Name)
                end

                for Index, Value in NewList do 
                    List:Add(Value)
                end
            end

            function List:SetVisibility(Bool)
                Items["List"].Instance.Visible = Bool 
            end

            for Index, Value in List.OptionItems do 
                List:Add(Value)
            end

            Items["Input"]:Connect("Changed", function(Property)
                if Property == "Text" then
                    for Index, Value in List.Options do
                        if string.find(string.lower(Value.Name), string.lower(Items["Input"].Instance.Text)) then
                            Value.Button.Instance.Visible = true
                        else
                            Value.Button.Instance.Visible = false
                        end
                    end
                end
            end)

            List:Set(List.Default)

            SetFlags[List.Flag] = function(Value)
                List:Set(Value)
            end

            return setmetatable(List, Library)
        end

        Library.Label = function(Self, Params)
            Params = Params or { }

            local Label = {
                Name = Params.Name or Params.name or "Label",

                Window = Self.Window,
                Page = Self.Page,
                Section = Self,

                Items = { }
            }

            local Parent 

            if Params.Parent then 
                Parent = Params.Parent
            else
                Parent = Label.Section.Items["Content"]
            end

            local Items = { } do 
                Items["Label"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Parent.Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 12),
                    BorderSizePixel = 0
                })
                
                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Items["Label"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = Label.Name,
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY
                }):AddToTheme({TextColor3 = 'Text'})
                
                Items["SubElements"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Label"].Instance,
                    AnchorPoint = Vector2.new(1, 0),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, 0, 0, 0),
                    Size = UDim2.new(0, 0, 1, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                })
                
                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["SubElements"].Instance,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    FillDirection = Enum.FillDirection.Horizontal,
                    Padding = UDim.new(0, 8),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })                

                Label.Items = Items 
            end

            function Label:SetVisibility(Bool)
                Items["Label"].Instance.Visible = Bool 
            end

            function Label:SetText(Text)
                Items["Text"].Instance.Text = tostring(Text)
            end

            function Label:Colorpicker(Data)
                Data = Data or { }

                local Colorpicker = {
                    Flag = Data.Flag or Data.flag or (Data.Name or Data.name or Label.Name),
                    Default = Data.Default or Data.default or Color3.fromRGB(255, 255, 255),
                    Callback = Data.Callback or Data.callback or function() end,
                    Alpha = Data.Alpha or Data.alpha or 0,

                    Window = Label.Window,
                    Page = Label.Page,
                    Section = Label.Section,
                }

                local NewColorpicker, ColorpickerItems = Library:CreateColorpicker({
                    Parent = Items["SubElements"],
                    Page = Colorpicker.Page,
                    Section = Colorpicker.Section,
                    Flag = Colorpicker.Flag,
                    Default = Colorpicker.Default,
                    Callback = Colorpicker.Callback,
                    Alpha = Colorpicker.Alpha
                })

                return NewColorpicker
            end

            function Label:Keybind(Data)
                Data = Data or { }

                local Keybind = {
                    Name = Data.Name or Data.name or Label.Name,
                    Flag = Data.Flag or Data.flag or (Data.Name or Data.name or Label.Name),
                    Default = Data.Default or Data.default or nil,
                    Callback = Data.Callback or Data.callback or function() end,
                    Mode = Data.Mode or Data.mode or "Toggle",

                    Window = Label.Window,
                    Page = Label.Page,
                    Section = Label.Section,
                }

                local NewKeybind, KeybindItems = Library:CreateKeybind({
                    Parent = Items["SubElements"],
                    Name = Keybind.Name,
                    Page = Keybind.Page,
                    Section = Keybind.Section,
                    Flag = Keybind.Flag,
                    Default = Keybind.Default,
                    Mode = Keybind.Mode,
                    Callback = Keybind.Callback
                })

                return NewKeybind
            end

            Label:SetText(Label.Name)

            return setmetatable(Label, Library)
        end

        Library.Textbox = function(Self, Params)
            Params = Params or { }

            local Textbox = {
                Name = Params.Name or Params.name or "Textbox",
                Flag = Params.Flag or Params.flag or (Params.Name or Params.name),
                Default = Params.Default or Params.default or "",
                Callback = Params.Callback or Params.callback or function() end,
                Finished = Params.Finished or Params.finished or false,
                Placeholder = Params.Placeholder or Params.placeholder or "",
                Numeric = Params.Numeric or Params.numeric or false,

                Window = Self.Window,
                Page = Self.Page,
                Section = Self,
                Value = "",

                Items = { },
            }

            local Parent 

            if Params.Parent then 
                Parent = Params.Parent
            else
                Parent = Textbox.Section.Items["Content"]
            end

            local Items = { } do 
                Items["Textbox"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Parent.Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 40),
                    BorderSizePixel = 0
                })
                
                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Items["Textbox"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = Textbox.Name,
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY
                }):AddToTheme({TextColor3 = 'Text'})
                
                Items["Outline"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Textbox"].Instance,
                    Active = true,
                    AnchorPoint = Vector2.new(0, 1),
                    Position = UDim2.new(0, 0, 1, 0),
                    Size = UDim2.new(1, 0, 0, 20),
                    Selectable = true,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Border"]
                }):AddToTheme({BackgroundColor3 = 'Border'})
                
                Items["Inline"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Outline"].Instance,
                    Active = true,
                    Position = UDim2.new(0, 1, 0, 1),
                    Selectable = true,
                    Size = UDim2.new(1, -2, 1, -2),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Outline"]
                }):AddToTheme({BackgroundColor3 = 'Outline'})
                
                Items["Background"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Inline"].Instance,
                    ClipsDescendants = true,
                    Size = UDim2.new(1, -2, 1, -2),
                    Position = UDim2.new(0, 1, 0, 1),
                    Selectable = true,
                    Active = true,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Element"]
                }):AddToTheme({BackgroundColor3 = 'Element'})
                
                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["Background"].Instance,
                    Rotation = 90,
                    Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(163, 163, 163))
                }
                })
                
                Items["Input"] = Library:Create("TextBox", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Items["Background"].Instance,
                    AnchorPoint = Vector2.new(0, 0.5),
                    PlaceholderColor3 = Library.Theme["Inactive Text"],
                    PlaceholderText = Textbox.Placeholder,
                    Size = UDim2.new(1, -8, 0, 0),
                    TextColor3 = Library.Theme["Text"],
                    Text = "",
                    Position = UDim2.new(0, 4, 0.5, -1),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    CursorPosition = -1,
                    ClearTextOnFocus = false,
                    AutomaticSize = Enum.AutomaticSize.Y
                }):AddToTheme({TextColor3 = 'Text', PlaceholderColor3 = 'Inactive Text'})                

                Textbox.Items = Items
            end

            Items["Background"]:OnHover(function()
                Items["Background"]:Tween({BackgroundColor3 = Library.Theme["Hovered Element"]})
            end, function()
                Items["Background"]:Tween({BackgroundColor3 = Library.Theme.Element})
            end)

            function Textbox:SetVisibility(Bool)
                Items["Textbox"].Instance.Visible = Bool
            end

            function Textbox:SetText(Text)
                Items["Text"].Instance.Text = tostring(Text)
            end

            function Textbox:Set(Value)
                if Textbox.Numeric and string.len(tostring(Value)) > 0 and not tonumber(Value) then
                    Value = Textbox.Value
                end

                Textbox.Value = Value
                Items["Input"].Instance.Text = Value
                Flags[Textbox.Flag] = Value

                Library:SafeCall(Textbox.Callback, Value)
            end

            if Textbox.Finished then 
                Items["Input"]:Connect("FocusLost", function(Bool)
                    if Bool then
                        Textbox:Set(Items["Input"].Instance.Text)
                    end
                end)
            else
                Items["Input"]:Connect("Changed", function(Property)
                    if Property == "Text" then
                        Textbox:Set(Items["Input"].Instance.Text)
                    end
                end)
            end

            Textbox:Set(Textbox.Default)

            SetFlags[Textbox.Flag] = function(Value)
                Textbox:Set(Value)
            end
            
            return setmetatable(Textbox, Library)
        end

        Library.Init = function(Self)
            local SettingsPage = Self:Page({Name = "settings"}) do 
                local ThemingSection = SettingsPage:Section({Name = "Theming", Side = 2}) do
                    for Index, Value in Library.Theme do 
                        ThemingSection:Label({Name = Index}):Colorpicker({
                            Name = Index,
                            Flag = Index.."Theming",
                            Default = Value,
                            Callback = function(Value)
                                Library.Theme[Index] = Value
                                Library:ChangeTheme(Index, Value)
                            end
                        })
                    end

                    local ThemeSelected 
                    local ThemeName
                    local ThemesFolder = Library.Directory .. Library.Folders.Themes .. "/"

                    local ThemesDropdown = ThemingSection:Dropdown({
                        Name = "Themes",
                        Flag = "Themes",
                        Default = "",
                        Items = { },
                        Callback = function(Value)
                            ThemeSelected = Value
                        end
                    })

                    ThemingSection:Textbox({
                        Name = "Theme name",
                        Flag = "ThemeName",
                        Default = "",
                        Callback = function(Value)
                            ThemeName = Value
                        end
                    })

                    ThemingSection:Button({
                        Name = "Save",
                        Callback = function()
                            if ThemeName then 
                                if ThemeName == "" then 
                                    return
                                end

                                if isfile(ThemesFolder .. ThemeName .. ".json") then 
                                    Library:Notification("Saved theme "..ThemeName, 3, Library.Theme.Accent)
                                    writefile(ThemesFolder .. ThemeName .. ".json", Library:GetConfig())
                                    return
                                end

                                writefile(ThemesFolder .. ThemeName .. ".json", Library:GetConfig())
                                Library:GetThemesList(ThemesDropdown)
                                Library:Notification("Created theme "..ThemeName, 3, Library.Theme.Accent)
                            end
                        end
                    })

                    ThemingSection:Button({
                        Name = "Load",
                        Callback = function()
                            if ThemeSelected then 
                                if not isfile(ThemesFolder .. ThemeSelected .. ".json") then
                                    Library:Notification("Theme does not exist", 3, Color3.fromRGB(255, 0, 0))
                                    return
                                end

                                local Success, Error = Library:LoadConfig(readfile(ThemesFolder .. ThemeSelected .. ".json"))

                                if Success then 
                                    Library:Notification("Loaded theme "..ThemeSelected .. " succesfully", 3, Library.Theme.Accent)
                                else
                                    Library:Notification("Failed to load theme "..ThemeSelected .. " report this to the devs: "..Error, 3, Color3.fromRGB(255, 0, 0))
                                end
                            end
                        end
                    })

                    ThemingSection:Button({
                        Name = "Delete",
                        Callback = function()
                            if ThemeSelected then 
                                if not isfile(ThemesFolder .. ThemeSelected .. ".json") then
                                    Library:Notification("Theme does not exist", 3, Color3.fromRGB(255, 0, 0))
                                    return
                                end

                                delfile(ThemesFolder .. ThemeSelected .. ".json")
                                Library:GetThemesList(ThemesDropdown)
                                Library:Notification("Deleted theme "..ThemeSelected, 3, Library.Theme.Accent)
                            end
                        end
                    })

                    Library:GetThemesList(ThemesDropdown)
                end
                
                local MenuSection = SettingsPage:Section({Name = "Menu", Side = 2}) do
                    MenuSection:Button({Name = "Exit", Callback = function()
                        Library:Exit()
                    end})

                    MenuSection:Label({ Name = "Menu Keybind" }):Keybind({
                        Name = "Menu Keybind",
                        Flag = "MenuKeybind",
                        Default = Library.MenuKeybind,
                        Mode = "Toggle",
                        Callback = function(Value)
                            Library.MenuKeybind = Library.Flags["MenuKeybind"].Key
                        end
                    })

                    if Self.Watermark then
                        MenuSection:Toggle({
                            Name = "Watermark",
                            Flag = "Watermark",
                            Default = true,
                            Callback = function(Value)
                                Self.Watermark:SetVisibility(Value)
                            end
                        })
                    end

                    if Self.KeybindList then 
                        MenuSection:Toggle({
                            Name = "Keybind list",
                            Flag = "Keybind list",
                            Default = true,
                            Callback = function(Value)
                                Self.KeybindList:SetVisibility(Value)
                            end
                        })
                    end
                end

                local ConfigName 
                local ConfigSelected 
                local ConfigsFolder = Library.Directory .. Library.Folders.Configs .. "/"

                local ConfigsSection = SettingsPage:Section({Name = "Profiles", Side = 1}) do
                    local ConfigsList = ConfigsSection:List({
                        Flag = "Configs",
                        Items = { },
                        Multi = false,
                        Callback = function(Value)
                            ConfigSelected = Value
                        end
                    })

                    ConfigsSection:Textbox({
                        Name = "Config name",
                        Flag = "ConfigName",
                        Placeholder = "Config name",
                        Callback = function(Value)
                            ConfigName = Value 
                        end
                    })

                    ConfigsSection:Button({
                        Name = "Create",
                        Callback = function()
                            if ConfigName then 
                                if ConfigName == "" then 
                                    return
                                end

                                if isfile(ConfigsFolder .. ConfigName .. ".json") then 
                                    Library:Notification("Config with the name "..ConfigName.." already exists", 3, Color3.fromRGB(255, 0, 0))
                                    return
                                end

                                writefile(ConfigsFolder .. ConfigName .. ".json", Library:GetConfig())
                                Library:GetConfigsList(ConfigsList)
                                Library:Notification("Created config "..ConfigName, 3, Library.Theme.Accent)
                            end
                        end
                    })

                    ConfigsSection:Button({
                        Name = "Load",
                        Callback = function()
                            if ConfigSelected then 
                                if not isfile(ConfigsFolder .. ConfigSelected .. ".json") then
                                    Library:Notification("Config does not exist", 3, Color3.fromRGB(255, 0, 0))
                                    return
                                end

                                local Success, Error = Library:LoadConfig(readfile(ConfigsFolder .. ConfigSelected .. ".json"))

                                if Success then 
                                    Library:Notification("Loaded config "..ConfigSelected .. " succesfully", 3, Library.Theme.Accent)
                                else
                                    Library:Notification("Failed to load config "..ConfigSelected .. " report this to the devs: "..Error, 3, Color3.fromRGB(255, 0, 0))
                                end
                            end
                        end
                    })

                    ConfigsSection:Button({
                        Name = "Delete",
                        Callback = function()
                            if ConfigSelected then 
                                if not isfile(ConfigsFolder .. ConfigSelected .. ".json") then
                                    Library:Notification("Config does not exist", 3, Color3.fromRGB(255, 0, 0))
                                    return
                                end

                                delfile(ConfigsFolder .. ConfigSelected .. ".json")
                                Library:GetConfigsList(ConfigsList)
                                Library:Notification("Deleted config "..ConfigSelected, 3, Library.Theme.Accent)
                            end
                        end
                    })

                    ConfigsSection:Button({
                        Name = "Overwrite",
                        Callback = function()
                            if ConfigSelected then 
                                if not isfile(ConfigsFolder .. ConfigSelected .. ".json") then
                                    Library:Notification("Config does not exist", 3, Color3.fromRGB(255, 0, 0))
                                    return
                                end

                                writefile(ConfigsFolder .. ConfigSelected .. ".json", Library:GetConfig())
                                Library:Notification("Overwrote config "..ConfigSelected, 3, Library.Theme.Accent)
                            end
                        end
                    })

                    Library:GetConfigsList(ConfigsList)
                end

                local AutoloadSection = SettingsPage:Section({Name = "Autoload", Side = 1}) do
                    AutoloadSection:Button({
                        Name = "Set selected as autoload",
                        Callback = function()
                            if ConfigSelected then 
                                if not isfile(ConfigsFolder .. ConfigSelected .. ".json") then
                                    Library:Notification("Config does not exist", 3, Color3.fromRGB(255, 0, 0))
                                    return
                                end

                                writefile(Library.Directory .. "/autoload.json", readfile(ConfigsFolder .. ConfigSelected .. ".json"))
                                Library:Notification("Set config "..ConfigSelected.." as autoload", 3, Library.Theme.Accent)
                            end
                        end
                    })

                    AutoloadSection:Button({
                        Name = "Remove autoload",
                        Callback = function()
                            writefile(Library.Directory .. "/autoload.json", "")
                            Library:Notification("Removed autoload", 3, Library.Theme.Accent)
                        end
                    })
                end

                local AutoloadContent = readfile(Library.Directory .. "/autoload.json")

                if AutoloadContent ~= "" then 
                    Library:LoadConfig(AutoloadContent)
                end
            end
        end
    end
end

getgenv().Library = Library


-- ==============================
-- MAIN SCRIPT
-- ==============================

task.spawn(function()
do
    local G = {
        Decimals = 4,
        Clock = os.clock(),
        RS = game:GetService("ReplicatedStorage"),
        P = game:GetService("Players"),
        R = game:GetService("RunService"),
        U = game:GetService("UserInputService"),
        W = game:GetService("Workspace"),
        H = game:GetService("HttpService"),
        L = game:GetService("Lighting"),
        LP = game.Players.LocalPlayer,
        C = workspace.CurrentCamera,
        CG = game:GetService("CoreGui"),
        GS = game:GetService("GuiService")
    }
    
    G.Mouse = G.LP:GetMouse()
    
    
    local Library = getgenv().Library
    local Window = Library:Window({Name = "mentic.cc"})
    local Watermark = Window:Watermark({Name = "BY 09LOH ON DC"})
    local KeybindList = Window:KeybindList()
    
    local Pages = {
        Legit = Window:Page({Name = 'legit'}),
        Rage = Window:Page({Name = 'rage'}),
        Weapons = Window:Page({Name = 'weapons'}),
        World = Window:Page({Name = 'world'}),
        
        Movement = Window:Page({Name = 'movement'})
    }
    
    local Sections = {
        LegitLeft = Pages.Legit:Section({Name = 'aim assist', Side = 1}),
        LegitRight = Pages.Legit:Section({Name = 'silent aim', Side = 2}),
        RageLeft = Pages.Rage:Section({Name = 'rage', Side = 1}),
        RageAntiAim = Pages.Rage:Section({Name = 'anti aim', Side = 1}),
        RageRight = Pages.Rage:Section({Name = 'players', Side = 2}),
        RageTarget = Pages.Rage:Section({Name = 'target', Side = 2}),
        WeaponsLeft = Pages.Weapons:Section({Name = 'guns', Side = 1}),
        WeaponsRight = Pages.Weapons:Section({Name = 'spread', Side = 2}),
        WorldLeft = Pages.World:Section({Name = 'view', Side = 1}),
        WorldRight = Pages.World:Section({Name = 'world', Side = 2}),
        
        MovementLeft = Pages.Movement:Section({Name = 'self', Side = 1}),
        MovementRight = Pages.Movement:Section({Name = 'other', Side = 2})
        
    }
    
    
    
        -- ============================================
    -- AIM ASSIST (WITH CHECKS)
    -- ============================================
    local AimState = {CurrentTarget = nil, Circle = nil}
    
    -- Aim Assist Checks
    local AimChecks = {
        Wall = true,
        Knock = true,
        Team = false
    }
    
    local function GetTargetParts(char)
        if not char then return nil end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then return nil end
        local root = char:FindFirstChild("HumanoidRootPart")
        local head = char:FindFirstChild("Head")
        if root and head then
            return {Character=char, Humanoid=hum, RootPart=root, Head=head, UpperTorso=char:FindFirstChild("UpperTorso"), LowerTorso=char:FindFirstChild("LowerTorso"), Torso=char:FindFirstChild("Torso")}
        end
        return nil
    end
    
    local function IsTeammate(p)
        if not p.Team or not G.LP.Team then return false end
        return p.Team == G.LP.Team
    end
    
    local function IsVisible(pos, targetChar)
        local params = RaycastParams.new()
        params.FilterDescendantsInstances = {G.LP.Character, targetChar}
        params.FilterType = Enum.RaycastFilterType.Blacklist
        return G.W:Raycast(G.C.CFrame.Position, pos - G.C.CFrame.Position, params) == nil
    end
    
    local function isPlayerKnocked(player)
        if not player or not player.Character then return false end
        local be = player.Character:FindFirstChild("BodyEffects")
        if be then
            local ko = be:FindFirstChild("K.O")
            if ko and ko.Value == true then
                return true
            end
        end
        return false
    end
    
    local function isPlayerAlive(player)
        if not player or not player.Character then return false end
        local hum = player.Character:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then
            return false
        end
        return true
    end
    
    local function isValidTarget(p)
        if not p or p == G.LP then return false end
        if not isPlayerAlive(p) then return false end
        
        if AimChecks.Knock then
            if isPlayerKnocked(p) then return false end
        end
        
        if AimChecks.Team then
            if IsTeammate(p) then return false end
        end
        
        return true
    end
    
    local function GetClosestPlayer()
        local closest, shortest = nil, math.huge
        local mousePos = G.U:GetMouseLocation()
        local fovRadius = Library.Flags.fov_assist and ((Library.Flags.fov_size or 10) * 10) or math.huge
        
        for _, p in ipairs(G.P:GetPlayers()) do
            if p ~= G.LP and isValidTarget(p) then
                local parts = GetTargetParts(p.Character)
                if parts then
                    local aimPartName = Library.Flags.example_listbox == "head" and "Head" or "HumanoidRootPart"
                    local aimPart = parts[aimPartName] or parts.Head
                    local screenPos, onScreen = G.C:WorldToViewportPoint(aimPart.Position)
                    if onScreen and screenPos.Z > 0 then
                        local dist2D = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                        if dist2D < fovRadius and dist2D < shortest then
                            if AimChecks.Wall and not IsVisible(aimPart.Position, p.Character) then
                                -- Skip if wall check is on and not visible
                            else
                                shortest, closest = dist2D, p
                            end
                        end
                    end
                end
            end
        end
        return closest
    end
    
    local function AimAt(target)
        if not target then return end
        local parts = GetTargetParts(target.Character)
        if not parts then AimState.CurrentTarget = nil return end
        local aimPartName = Library.Flags.example_listbox == "head" and "Head" or "HumanoidRootPart"
        local aimPart = parts[aimPartName] or parts.Head
        local targetPos = aimPart.Position
        local predTime = math.clamp(Library.Flags.prediction_time or 0.13, 0, 1)
        if predTime > 0 and parts.RootPart then
            local vel = parts.RootPart.Velocity
            if vel.Magnitude > 200 then vel = vel.Unit * 200 end
            targetPos = targetPos + (vel * predTime)
        end
        local smoothness = math.clamp((Library.Flags.smoothness or 50) / 100, 0.01, 1)
        if Library.Flags.aim_type == "mouse" then
            local screenPos = G.C:WorldToViewportPoint(targetPos)
            local mousePos = G.U:GetMouseLocation()
            local moveVec = (Vector2.new(screenPos.X, screenPos.Y) - mousePos) * (smoothness * 2)
            if mousemoverel then mousemoverel(moveVec.X, moveVec.Y)
            else G.C.CFrame = G.C.CFrame:Lerp(CFrame.new(G.C.CFrame.Position, targetPos), smoothness) end
        else
            G.C.CFrame = G.C.CFrame:Lerp(CFrame.new(G.C.CFrame.Position, targetPos), smoothness)
        end
    end
    
    -- FOV Circle
    AimState.Circle = Drawing.new("Circle")
    AimState.Circle.Thickness = 1.5
    AimState.Circle.NumSides = 100
    AimState.Circle.Filled = false
    AimState.Circle.Color = Color3.fromRGB(255, 0, 0)
    
    G.R.RenderStepped:Connect(function()
        if Library.Flags.show_fov then
            local mousePos = G.U:GetMouseLocation()
            AimState.Circle.Visible = true
            AimState.Circle.Position = mousePos
            AimState.Circle.Radius = (Library.Flags.fov_size or 10) * 10
            AimState.Circle.Color = Library.Flags.fov_color or Color3.fromRGB(255, 0, 0)
            AimState.Circle.Transparency = 0.7
        else
            AimState.Circle.Visible = false
        end
        
        if not Library.Flags.aim_assist then 
            AimState.CurrentTarget = nil 
            return 
        end
        
        -- Sticky logic
        if Library.Flags.sticky_aim then
            if AimState.CurrentTarget and GetTargetParts(AimState.CurrentTarget.Character) then
                -- Keep the same target
            else
                AimState.CurrentTarget = GetClosestPlayer()
            end
        else
            AimState.CurrentTarget = GetClosestPlayer()
        end
        
        if AimState.CurrentTarget then
            AimAt(AimState.CurrentTarget)
        end
    end)
    
    G.P.PlayerRemoving:Connect(function(p) if p == AimState.CurrentTarget then AimState.CurrentTarget = nil end end)
    for _, p in ipairs(G.P:GetPlayers()) do if p ~= G.LP then p.CharacterAdded:Connect(function() if p == AimState.CurrentTarget then AimState.CurrentTarget = nil end end) end end
    G.P.PlayerAdded:Connect(function(p) p.CharacterAdded:Connect(function() if p == AimState.CurrentTarget then AimState.CurrentTarget = nil end end) end)
    
    -- ============================================
    -- LEGIT MENU
    -- ============================================
    local AimAssistToggle = Sections.LegitLeft:Toggle({Name = 'aim assist', Flag = 'aim_assist', Default = false})
    AimAssistToggle:Keybind({Flag = 'aim_assist_bind', Mode = 'Toggle', Callback = function(s) 
        Library.Flags.aim_assist = s 
        AimAssistToggle:Set(s) 
        if not s then 
            AimState.CurrentTarget = nil 
        end 
    end})
    Sections.LegitLeft:Toggle({Name = 'sticky', Flag = 'sticky_aim', Default = false})
    
    -- Checks Dropdown
    Sections.LegitLeft:Dropdown({
        Name = 'checks',
        Flag = 'aim_checks',
        Items = {'Wall Check', 'Knock Check', 'Team Check'},
        Default = {'Wall Check', 'Knock Check'},
        Multi = true,
        Callback = function(value)
            AimChecks.Wall = table.find(value, 'Wall Check') ~= nil
            AimChecks.Knock = table.find(value, 'Knock Check') ~= nil
            AimChecks.Team = table.find(value, 'Team Check') ~= nil
            AimState.CurrentTarget = nil
        end
    })
    
    Sections.LegitLeft:Dropdown({Name = 'aim type', Flag = 'aim_type', Items = {'cam', 'mouse'}, Default = 'cam', Multi = false})
    Sections.LegitLeft:Slider({Name = 'smooth', Flag = 'smoothness', Default = 50, Min = 0, Max = 100, Decimals = 0.01, Suffix = '%'})
    Sections.LegitLeft:Dropdown({Name = 'part', Flag = 'example_listbox', Items = {'head', 'humanoid'}, Default = 'head', Multi = false})
    Sections.LegitLeft:Toggle({Name = 'fov', Flag = 'fov_assist', Default = false})
    Sections.LegitLeft:Toggle({Name = 'show fov', Flag = 'show_fov', Default = false})
    Sections.LegitLeft:Slider({Name = 'size', Flag = 'fov_size', Default = 10, Min = 0, Max = 100, Decimals = 0.01, Suffix = '%'})
    local FovColorLabel = Sections.LegitLeft:Label({Name = 'color'})
    FovColorLabel:Colorpicker({Name = 'color', Flag = 'fov_color', Default = Color3.fromRGB(255,0,0), Callback = function(c) AimState.Circle.Color = c end})
    Sections.LegitLeft:Slider({Name = 'Prediction Time', Flag = 'prediction_time', Default = 0.13, Min = 0, Max = 1, Decimals = 0.01})
    
    -- ============================================
    -- SILENT AIM (FIXED - WITH CHECKS)
    -- ============================================
    local Silent = {
        Enabled = false, ShowFOV = false, FOV = 65, FOVSides = 64, FOVColour = Color3.fromRGB(231,84,128),
        FOVFilled = false, FOVFillColour = Color3.fromRGB(231,84,128), FOVFillTransparency = 0.5,
        ShowTargetLine = false, TargetLineColour = Color3.fromRGB(255,255,255), TargetLineOrigin = 'Screen Center',
        Sticky = {Enabled = false, Target = nil},
        MaxDistance = 250, HvH = false, VisibleCheck = true, HitChance = 100, Selected = nil, SelectedPart = nil,
        TargetPart = {"Head"}, UseFOV = false,
        Checks = {Wall = true, Knock = true, Team = false},
        Ignored = {Teams = {}, Players = {G.LP}},
        IgnoreFriends = false
    }
    local SilentDraw = {Circle = nil, CircleFill = nil, TargetLine = nil}
    
    SilentDraw.Circle = Drawing.new("Circle")
    SilentDraw.Circle.Transparency = 1
    SilentDraw.Circle.Thickness = 2
    SilentDraw.Circle.Color = Silent.FOVColour
    SilentDraw.Circle.Filled = false
    SilentDraw.Circle.NumSides = Silent.FOVSides
    
    SilentDraw.CircleFill = Drawing.new("Circle")
    SilentDraw.CircleFill.Transparency = Silent.FOVFillTransparency
    SilentDraw.CircleFill.Thickness = 1
    SilentDraw.CircleFill.Color = Silent.FOVFillColour
    SilentDraw.CircleFill.Filled = true
    SilentDraw.CircleFill.NumSides = Silent.FOVSides
    
    SilentDraw.TargetLine = Drawing.new("Line")
    SilentDraw.TargetLine.Thickness = 1.5
    SilentDraw.TargetLine.Color = Silent.TargetLineColour
    SilentDraw.TargetLine.Visible = false
    SilentDraw.TargetLine.Transparency = 1
    
    local function SilentUpdateFOV()
        if not SilentDraw.Circle then return end
        local pos = Vector2.new(G.Mouse.X, G.Mouse.Y + G.GS:GetGuiInset().Y)
        local radius = Silent.FOV * 3
        SilentDraw.Circle.Visible = Silent.ShowFOV
        SilentDraw.Circle.Radius = radius
        SilentDraw.Circle.Position = pos
        SilentDraw.Circle.NumSides = Silent.FOVSides
        SilentDraw.Circle.Color = Silent.FOVColour
        if SilentDraw.CircleFill then
            SilentDraw.CircleFill.Visible = Silent.ShowFOV and Silent.FOVFilled
            SilentDraw.CircleFill.Radius = radius
            SilentDraw.CircleFill.Position = pos
            SilentDraw.CircleFill.NumSides = Silent.FOVSides
            SilentDraw.CircleFill.Color = Silent.FOVFillColour
            SilentDraw.CircleFill.Transparency = Silent.FOVFillTransparency
        end
        return SilentDraw.Circle
    end
    
    local function SilentUpdateTargetLine()
        if not SilentDraw.TargetLine then return end
        if Silent.ShowTargetLine and Silent.Selected and Silent.Selected ~= G.LP and Silent.SelectedPart then
            local partPos, onScreen = G.C:WorldToViewportPoint(Silent.SelectedPart.Position)
            if onScreen then
                SilentDraw.TargetLine.Visible = true
                if Silent.TargetLineOrigin == 'Mouse' then
                    SilentDraw.TargetLine.From = Vector2.new(G.Mouse.X, G.Mouse.Y + G.GS:GetGuiInset().Y)
                else
                    SilentDraw.TargetLine.From = Vector2.new(G.C.ViewportSize.X / 2, G.C.ViewportSize.Y / 2)
                end
                SilentDraw.TargetLine.To = Vector2.new(partPos.X, partPos.Y)
                SilentDraw.TargetLine.Color = Silent.TargetLineColour
                return
            end
        end
        SilentDraw.TargetLine.Visible = false
    end
    
    local function SilentCalcChance(pct)
        return math.random() <= pct / 100
    end
    
    local function SilentIsPartVisible(Part, PartDescendant)
        local char = G.LP.Character
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Blacklist
        params.FilterDescendantsInstances = {char, G.C}
        local result = G.W:Raycast(G.C.CFrame.Position, Part.Position - G.C.CFrame.Position, params)
        return result == nil or result.Instance:IsDescendantOf(PartDescendant)
    end
    
    local function SilentIsFriend(p)
        if not p then return false end
        local ok, isF = pcall(function()
            return G.LP:IsFriendsWith(p.UserId)
        end)
        return ok and isF
    end
    
    local function SilentIsIgnored(p)
        if Silent.IgnoreFriends and SilentIsFriend(p) then
            return true
        end
        for _, ignored in ipairs(Silent.Ignored.Players) do
            if ignored == p then return true end
        end
        for _, team in ipairs(Silent.Ignored.Teams) do
            if p.Team == team[1] then return true end
        end
        return false
    end
    
    local function isPlayerKnocked(player)
        if not player or not player.Character then return false end
        local be = player.Character:FindFirstChild("BodyEffects")
        if be then
            local ko = be:FindFirstChild("K.O")
            if ko and ko.Value == true then
                return true
            end
        end
        return false
    end
    
    local function isPlayerAlive(player)
        if not player or not player.Character then return false end
        local hum = player.Character:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then
            return false
        end
        return true
    end
    
    local function isValidTarget(player)
        if not player or player == G.LP then return false end
        if not isPlayerAlive(player) then return false end
        
        if Silent.Checks.Knock then
            if isPlayerKnocked(player) then
                return false
            end
        end
        
        return true
    end
    
    local function SilentGetClosestTargetPartToCursor(char)
        local closestPart, shortest = nil, math.huge
        local function CheckPart(part)
            if typeof(part) == "string" then part = char:FindFirstChild(part) end
            if not part then return end
            local pos, onScreen = G.C:WorldToViewportPoint(part.Position)
            if not onScreen then return end
            local dist = (Vector2.new(pos.X, pos.Y - G.GS:GetGuiInset().Y) - Vector2.new(G.Mouse.X, G.Mouse.Y)).Magnitude
            if dist < shortest then shortest, closestPart = dist, part end
        end
        if typeof(Silent.TargetPart) == "string" and Silent.TargetPart == "All" then
            for _, v in ipairs(char:GetChildren()) do if v:IsA("BasePart") then CheckPart(v) end end
        elseif typeof(Silent.TargetPart) == "string" then
            CheckPart(Silent.TargetPart)
        elseif typeof(Silent.TargetPart) == "table" then
            for _, name in ipairs(Silent.TargetPart) do CheckPart(name) end
        end
        return closestPart
    end
    
    local function SilentGetClosestPlayer()
        if Silent.Sticky.Enabled and Silent.Sticky.Target then
            local p = Silent.Sticky.Target
            if not p or p.Parent ~= G.P then 
                Silent.Sticky.Target = nil
            else
                local char = p.Character
                if char and isValidTarget(p) then
                    local part = char:FindFirstChild(Silent.TargetPart[1] or "Head")
                    if part then 
                        Silent.Selected, Silent.SelectedPart = p, part 
                        return 
                    end
                end
                Silent.Selected, Silent.SelectedPart = nil, nil
                return
            end
        end
        
        if not SilentCalcChance(Silent.HitChance) then 
            Silent.Selected, Silent.SelectedPart = G.LP, nil 
            return 
        end
        
        local closestPlayer, targetPart, shortest = nil, nil, math.huge
        
        for _, p in ipairs(G.P:GetPlayers()) do
            local char = p.Character
            if not SilentIsIgnored(p) and char then
                -- Distance check
                if not Silent.HvH and Silent.MaxDistance > 0 then
                    local myHRP = G.LP.Character and G.LP.Character:FindFirstChild("HumanoidRootPart")
                    local targetHRP = char:FindFirstChild("HumanoidRootPart")
                    if myHRP and targetHRP and (myHRP.Position - targetHRP.Position).Magnitude > Silent.MaxDistance then 
                        continue 
                    end
                end
                
                -- Check if target is valid (alive + not knocked)
                if not isValidTarget(p) then
                    continue
                end
                
                local part = SilentGetClosestTargetPartToCursor(char)
                if part then
                    local pos = G.C:WorldToViewportPoint(part.Position)
                    local dist = (Vector2.new(pos.X, pos.Y - G.GS:GetGuiInset().Y) - Vector2.new(G.Mouse.X, G.Mouse.Y)).Magnitude
                    
                    if (not Silent.UseFOV or SilentDraw.Circle.Radius > dist) and dist < shortest then
                        if Silent.Checks.Wall and not SilentIsPartVisible(part, char) then 
                            continue 
                        end
                        closestPlayer, targetPart, shortest = p, part, dist
                    end
                end
            end
        end
        
        Silent.Selected, Silent.SelectedPart = closestPlayer, targetPart
    end
    
    local mt = getrawmetatable(game)
    local oldIndex = mt.__index
    setreadonly(mt, false)
    mt.__index = function(t, k)
        if t == G.Mouse and (k == "Hit" or k == "Target") and Silent.Enabled and Silent.SelectedPart then
            if Silent.Selected and not isValidTarget(Silent.Selected) then
                Silent.Selected = nil
                Silent.SelectedPart = nil
                return oldIndex(t, k)
            end
            
            if k == "Hit" then
                if getgenv().BypassAimView then
                    local jitter = Vector3.new(math.random(-8,8)/1000, math.random(-8,8)/1000, math.random(-8,8)/1000)
                    return Silent.SelectedPart.CFrame + jitter
                end
                return Silent.SelectedPart.CFrame
            elseif k == "Target" then
                return Silent.SelectedPart
            end
        end
        return oldIndex(t, k)
    end
    setreadonly(mt, true)
    
    G.R.Heartbeat:Connect(function() 
        pcall(function() 
            SilentUpdateFOV() 
            SilentUpdateTargetLine() 
            SilentGetClosestPlayer() 
        end) 
    end)
    
    -- ============================================
    -- SILENT MENU (WITH CHECKS)
    -- ============================================
    Sections.LegitRight:Toggle({Name = 'silent', Flag = 'silent_aim_toggle', Default = false, Callback = function(v) Silent.Enabled = v end})
    Sections.LegitRight:Toggle({Name = 'byp aimview', Flag = 'byp_aimview_toggle', Default = false, Callback = function(v) getgenv().BypassAimView = v end})
    
    Sections.LegitRight:Toggle({
        Name = 'ignore friends',
        Flag = 'silent_ignore_friends',
        Default = false,
        Callback = function(v)
            Silent.IgnoreFriends = v
        end
    })
    
    -- Silent Checks Dropdown
    Sections.LegitRight:Dropdown({
        Name = 'checks',
        Flag = 'silent_checks',
        Items = {'Wall Check', 'Knock Check', 'Team Check'},
        Default = {'Wall Check', 'Knock Check'},
        Multi = true,
        Callback = function(v)
            Silent.Checks.Wall = table.find(v, 'Wall Check') ~= nil
            Silent.Checks.Knock = table.find(v, 'Knock Check') ~= nil
            local team = table.find(v, 'Team Check') ~= nil
            Silent.Checks.Team = team
            if team then
                for _, team in ipairs(Silent.Ignored.Teams) do if team[1] == G.LP.Team then return end end
                table.insert(Silent.Ignored.Teams, {G.LP.Team, G.LP.TeamColor})
            else
                for i, team in ipairs(Silent.Ignored.Teams) do if team[1] == G.LP.Team then table.remove(Silent.Ignored.Teams, i) break end end
            end
        end
    })
    
    Sections.LegitRight:Slider({Name = 'max distance', Flag = 'silent_max_distance', Default = 250, Min = 0, Max = 1000, Decimals = 1, Suffix = ' studs', Callback = function(v) Silent.MaxDistance = v end})
    Sections.LegitRight:Toggle({Name = 'hvh', Flag = 'silent_hvh_toggle', Default = false, Callback = function(v) Silent.HvH = v end})
    Sections.LegitRight:Toggle({Name = 'fov', Flag = 'silent_fov_toggle', Default = false, Callback = function(v) Silent.UseFOV = v end})
    local ShowFOVToggle = Sections.LegitRight:Toggle({Name = 'show fov', Flag = 'show_silent_fov', Default = false, Callback = function(v) Silent.ShowFOV = v end})
    ShowFOVToggle:Colorpicker({Flag = 'silent_fov_color', Default = Color3.fromRGB(231,84,128), Alpha = 0, Callback = function(c,a) Silent.FOVColour = c end})
    Sections.LegitRight:Slider({Name = 'fov', Flag = 'silent_fov', Default = 0.13, Min = 0, Max = 1, Decimals = 0.01, Callback = function(v) Silent.FOV = v * 500 end})
    local FillFOVToggle = Sections.LegitRight:Toggle({Name = 'fill fov', Flag = 'silent_fov_fill_toggle', Default = false, Callback = function(v) Silent.FOVFilled = v end})
    FillFOVToggle:Colorpicker({Flag = 'silent_fov_fill_color', Default = Color3.fromRGB(231,84,128), Alpha = 0, Callback = function(c,a) Silent.FOVFillColour = c end})
    Sections.LegitRight:Slider({Name = 'fill transparency', Flag = 'silent_fov_fill_transparency', Default = 0.5, Min = 0, Max = 1, Decimals = 0.01, Callback = function(v) Silent.FOVFillTransparency = v end})
    local TargetLineToggle = Sections.LegitRight:Toggle({Name = 'target line', Flag = 'silent_target_line', Default = false, Callback = function(v) Silent.ShowTargetLine = v end})
    TargetLineToggle:Colorpicker({Flag = 'silent_target_line_color', Default = Color3.fromRGB(255,255,255), Alpha = 0, Callback = function(c,a) Silent.TargetLineColour = c end})
    Sections.LegitRight:Dropdown({Name = 'target line origin', Flag = 'silent_target_line_origin', Items = {'Screen Center','Mouse'}, Default = 'Screen Center', Multi = false, Callback = function(v) Silent.TargetLineOrigin = v end})
    local StickyToggle = Sections.LegitRight:Toggle({Name = 'sticky', Flag = 'silent_sticky_toggle', Default = false, Callback = function(v)
        Silent.Sticky.Enabled = v
        if v and Silent.Selected and Silent.Selected ~= G.LP then Silent.Sticky.Target = Silent.Selected
        else Silent.Sticky.Target, Silent.Selected, Silent.SelectedPart = nil, nil, nil end
    end})
    StickyToggle:Keybind({Flag = 'silent_sticky_key', Default = Enum.KeyCode.T, Mode = 'Toggle', Callback = function(s)
        Silent.Sticky.Enabled = s
        if s and Silent.Selected and Silent.Selected ~= G.LP then Silent.Sticky.Target = Silent.Selected
        else Silent.Sticky.Target, Silent.Selected, Silent.SelectedPart = nil, nil, nil end
    end})
    Sections.LegitRight:Slider({Name = 'Prediction Time', Flag = 'silent_prediction_time', Default = 0.13, Min = 0, Max = 1, Decimals = 0.01, Callback = function(v) getgenv().Prediction = v end})
    
    
    
    Sections.RageLeft:Toggle({Name = 'bullet tp', Flag = 'rage_bullet_tp', Default = false})
    Sections.RageLeft:Toggle({Name = 'wallbang', Flag = 'rage_wallbang', Default = false})
    Sections.RageLeft:Toggle({Name = 'magic bullet', Flag = 'rage_magic_bullet', Default = false})
    Sections.RageLeft:Slider({Name = 'magic fov', Flag = 'hitbox_size', Default = 1, Min = 0, Max = 20, Decimals = 1})
    
    
    Sections.RageAntiAim:Toggle({Name = 'void hide', Flag = 'rage_void_hide', Default = false})
    Sections.RageAntiAim:Toggle({Name = 'desync', Flag = 'rage_desync', Default = false})
    Sections.RageAntiAim:Slider({Name = 'void depth', Flag = 'void_depth', Default = 1000000, Min = 50000, Max = 10000000, Decimals = 1})
    Sections.RageAntiAim:Slider({Name = 'jitter x', Flag = 'jitter_x', Default = 50, Min = 0, Max = 500, Decimals = 1})
    Sections.RageAntiAim:Slider({Name = 'jitter y', Flag = 'jitter_y', Default = 25, Min = 0, Max = 500, Decimals = 1})
    Sections.RageAntiAim:Slider({Name = 'jitter z', Flag = 'jitter_z', Default = 50, Min = 0, Max = 500, Decimals = 1})
    Sections.RageAntiAim:Slider({Name = 'jitter speed', Flag = 'jitter_speed', Default = 20, Min = 1, Max = 100, Decimals = 1})
    
    
    
    local GunData = {
        ["Revolver"] = {
            ToolName = "[Revolver]",
            Offset = CFrame.new(-1, 0.4, 0),
            UseHandler = true,
        },
        ["Double Barrel"] = {
            ToolName = "[Double-Barrel SG]",
            Offset = CFrame.new(0, 0, 0),
            IsShotgun = true,
            Pellets = 5,
        },
        ["Tactical SG"] = {
            ToolName = "[TacticalShotgun]",
            Offset = CFrame.new(0, 0.25, -2.5),
            IsShotgun = true,
            Pellets = 5,
        },
    }
    
    
    local SelectedGuns = {}
    local InfRangeEnabled = false
    local PatchedGuns = {}
    local MonitorConnections = {}
    local RapidFireEnabled = false
    local RapidFireTools = {}
    
    -- ============================================
    -- AMMO REFILL SYSTEM
    -- ============================================
    local refillActive = false
    local refillCooldown = 0
    local lastEquipped = nil
    local isRefilling = false
    
    local function requestAmmoRefill(tool)
        if LoadoutRemote == nil or isRefilling or tool == nil then return false end
        if tick() - refillCooldown < 0.8 then return false end
        
        local ammo = tool:FindFirstChild("Ammo")
        if not ammo then return false end
        if ammo:GetAttribute("ZeeKillRefillRequested") then return false end
        if ammo.Value > 3 then return false end
        
        local char = G.LP.Character
        local bp = G.LP:FindFirstChild("Backpack")
        if bp == nil then return false end
        
        isRefilling = true
        refillCooldown = tick()
        
        ammo:SetAttribute("ZeeKillRefillRequested", true)
        
        local requestedName = tool.Name
        local oldTools = {}
        local equippedTools = {}
        local newestTools = {}
        local seenTools = {}
        
        for _, container in ipairs({bp, char}) do
            if container then
                for _, item in ipairs(container:GetChildren()) do
                    if item:IsA("Tool") and item:FindFirstChild("Ammo") then
                        oldTools[item] = true
                        if item.Parent == char then
                            equippedTools[item.Name] = true
                        end
                    end
                end
            end
        end
        
        local connections = {}
        local stopped = false
        local deadline = os.clock() + 2.0
        local lastAdded = os.clock()
        
        local function stop()
            if stopped then return end
            stopped = true
            for _, conn in ipairs(connections) do
                pcall(function() conn:Disconnect() end)
            end
            if not newestTools[requestedName] and ammo.Parent then
                ammo:SetAttribute("ZeeKillRefillRequested", nil)
            end
            isRefilling = false
            
            task.spawn(function()
                task.wait(0.2)
                if lastEquipped then
                    local bp2 = G.LP:FindFirstChild("Backpack")
                    if bp2 then
                        local newTool = bp2:FindFirstChild(lastEquipped)
                        if newTool and G.LP.Character then
                            newTool.Parent = G.LP.Character
                        end
                    end
                    lastEquipped = nil
                end
            end)
        end
        
        local function accept(item)
            if not item:IsA("Tool") or not item:FindFirstChild("Ammo") or oldTools[item] or seenTools[item] then
                return
            end
            seenTools[item] = true
            lastAdded = os.clock()
            local name = item.Name
            local previous = newestTools[name]
            if previous and previous ~= item and previous.Parent then
                previous:Destroy()
            end
            newestTools[name] = item
            for oldTool in pairs(oldTools) do
                if oldTool.Name == name and oldTool.Parent then
                    oldTool:Destroy()
                end
            end
            if equippedTools[name] and char and item.Parent then
                item.Parent = char
            end
        end
        
        connections[1] = bp.ChildAdded:Connect(accept)
        if char then
            connections[2] = char.ChildAdded:Connect(accept)
        end
        
        local loadout = {tool.Name}
        LoadoutRemote:FireServer(loadout)
        
        local heartbeat = G.R.Heartbeat:Connect(function()
            if os.clock() >= deadline or (next(newestTools) and os.clock() - lastAdded >= 0.15) then
                stop()
            end
        end)
        
        return true
    end
    
    -- ============================================
    -- FORCE REFILL FUNCTION (CALLED ON TOGGLE)
    -- ============================================
    local function ForceRefillAllGuns()
        local char = G.LP.Character
        local bp = G.LP:FindFirstChild("Backpack")
        if not char and not bp then return end
        
        -- Check equipped gun
        local tool = char and char:FindFirstChildOfClass("Tool")
        if tool and tool:FindFirstChild("Ammo") then
            local ammo = tool:FindFirstChild("Ammo")
            if ammo.Value <= 3 and not ammo:GetAttribute("ZeeKillRefillRequested") then
                requestAmmoRefill(tool)
            end
        end
        
        -- Check backpack guns
        if bp then
            for _, item in ipairs(bp:GetChildren()) do
                if item:IsA("Tool") and item:FindFirstChild("Ammo") then
                    local ammo = item:FindFirstChild("Ammo")
                    if ammo.Value <= 3 and not ammo:GetAttribute("ZeeKillRefillRequested") then
                        requestAmmoRefill(item)
                    end
                end
            end
        end
    end
    
    -- ============================================
    -- SPREAD SYSTEM
    -- ============================================
    local settings = { 
        BulletSpread = { 
            Enabled = false, 
            Amount = 0 
        } 
    }
    
    local originalRandom
    originalRandom = hookfunction(math.random, function(...)
        local args = { ... }
        if checkcaller() then return originalRandom(...) end
        if (#args == 0) or 
           (args[1] == -0.05 and args[2] == 0.05) or 
           (args[1] == -0.1) or 
           (args[1] == -0.05) then
            if settings.BulletSpread.Enabled then
                return originalRandom(...) * (settings.BulletSpread.Amount / 100)
            end
        end
        return originalRandom(...)
    end)
    
    
   
    
    
    
    local function CleanupGun(gun)
        local data = PatchedGuns[gun]
        if not data then return end
        for _, c in ipairs(data.Connections) do
            pcall(function() c:Disconnect() end)
        end
        if data.OriginalValues then
            for propName, propValue in pairs(data.OriginalValues) do
                local prop = gun:FindFirstChild(propName)
                if prop then
                    pcall(function() prop.Value = propValue end)
                end
            end
        end
        local ourEvent = gun:FindFirstChild("Activated")
        if ourEvent and data.OurActivated then
            pcall(function() ourEvent:Destroy() end)
        end
        local originalEvent = gun:FindFirstChild("_OriginalActivated")
        if originalEvent then
            pcall(function() originalEvent.Name = "Activated" end)
        end
        if data.OriginalActivatedProp ~= nil then
            pcall(function() gun.Activated = data.OriginalActivatedProp end)
        end
        PatchedGuns[gun] = nil
    end
    
    local function PatchProperties(gun, storage)
        local props = {"Range", "Ammo", "ShootingCooldown", "Damage"}
        storage.OriginalValues = {}
        for _, propName in ipairs(props) do
            local prop = gun:FindFirstChild(propName)
            if not prop then
                prop = Instance.new("NumberValue")
                prop.Name = propName
                prop.Parent = gun
                storage.OriginalValues[propName] = 0
            else
                storage.OriginalValues[propName] = prop.Value
            end
            if propName == "Range" then prop.Value = 9999999 end
            if propName == "Ammo" then prop.Value = 999 end
            if propName == "ShootingCooldown" then prop.Value = 0 end
            if propName == "Damage" then prop.Value = 9999 end
        end
    end
    
    local function PatchRevolver(gun)
        if PatchedGuns[gun] then return end
        local store = {Connections = {}, OriginalValues = {}}
        PatchedGuns[gun] = store
        PatchProperties(gun, store)
        local oldActivated = gun:FindFirstChild("Activated")
        if oldActivated then
            oldActivated.Name = "_OriginalActivated"
            store.OriginalActivated = oldActivated
        end
        local newActivated = Instance.new("BindableEvent")
        newActivated.Name = "Activated"
        newActivated.Parent = gun
        store.OurActivated = newActivated
        local conn = newActivated.Event:Connect(function()
            if not InfRangeEnabled then
                local orig = gun:FindFirstChild("_OriginalActivated")
                if orig then pcall(function() orig:Fire() end) end
                return
            end
            local handle = gun:FindFirstChild("Handle")
            local char = G.LP.Character
            local head = char and char:FindFirstChild("Head")
            if not (handle and head) then return end
            local handlePos = (handle.CFrame * GunData["Revolver"].Offset).Position
            local aimPos = handlePos + head.CFrame.LookVector * 9999999
            local muzzle = gun:FindFirstChild("Default")
                and gun.Default:FindFirstChild("Mesh")
                and gun.Default.Mesh:FindFirstChild("Muzzle")
            local origin = muzzle and muzzle.WorldPosition or handlePos
            local remote = G.RS:FindFirstChild("GameRemotes")
            if remote then remote = remote:FindFirstChild("MainGameEvent") end
            if not remote then return end
            local v6, v7, v8 = nil, nil, nil
            local GunHandler = nil
            pcall(function() GunHandler = require(G.RS.Modules.GunHandler) end)
            if GunHandler then
                pcall(function()
                    v6, v7, v8 = GunHandler.Shoot({
                        Shooter = G.LP,
                        Handle = handle,
                        ForcedOrigin = origin,
                        AimPosition = aimPos,
                        BeamColor = Color3.new(1, 0, 0),
                        Range = 9999999,
                    })
                end)
            end
            pcall(function()
                remote:FireServer("ShootGun", handle, origin, nil, v6, v7, v8, 9999999, 9999)
            end)
        end)
        table.insert(store.Connections, conn)
        table.insert(store.Connections, gun.AncestryChanged:Connect(function()
            if not gun.Parent then CleanupGun(gun) end
        end))
    end
    
    local function PatchDoubleBarrel(gun)
        if PatchedGuns[gun] then return end
        local store = {Connections = {}, OriginalValues = {}}
        PatchedGuns[gun] = store
        PatchProperties(gun, store)
        local handle = gun:FindFirstChild("Handle") or gun:FindFirstChildWhichIsA("BasePart")
        if not handle then
            PatchedGuns[gun] = nil
            return
        end
        store.OriginalActivatedProp = gun.Activated
        pcall(function() gun.Activated = nil end)
        local conn = gun.Activated:Connect(function()
            if not InfRangeEnabled then return end
            if not gun.Parent then return end
            local char = G.LP.Character
            if not char then return end
            local head = char:FindFirstChild("Head") or G.C
            local handlePos = handle.Position
            local aimPos = handlePos + head.CFrame.LookVector * 9999999
            local shots = {}
            for i = 1, 5 do
                table.insert(shots, {
                    AimPosition = aimPos,
                    Result1 = nil,
                    Result2 = nil,
                    Result3 = nil,
                })
            end
            local remote = G.RS:FindFirstChild("GameRemotes")
            if remote then remote = remote:FindFirstChild("MainGameEvent") end
            if not remote then return end
            pcall(function()
                remote:FireServer("ShootGun", handle, handlePos, shots, nil, nil, nil, 9999999, 9999)
            end)
        end)
        table.insert(store.Connections, conn)
        table.insert(store.Connections, gun.AncestryChanged:Connect(function()
            if not gun.Parent then CleanupGun(gun) end
        end))
    end
    
    local function PatchTacticalShotgun(gun)
        if PatchedGuns[gun] then return end
        local store = {Connections = {}, OriginalValues = {}}
        PatchedGuns[gun] = store
        PatchProperties(gun, store)
        local oldActivated = gun:FindFirstChild("Activated")
        if oldActivated then
            oldActivated.Name = "_OriginalActivated"
            store.OriginalActivated = oldActivated
        end
        local newActivated = Instance.new("BindableEvent")
        newActivated.Name = "Activated"
        newActivated.Parent = gun
        store.OurActivated = newActivated
        local conn = newActivated.Event:Connect(function()
            if not InfRangeEnabled then
                local orig = gun:FindFirstChild("_OriginalActivated")
                if orig then pcall(function() orig:Fire() end) end
                return
            end
            local handle = gun:FindFirstChild("Handle")
            local char = G.LP.Character
            local head = char and char:FindFirstChild("Head")
            if not (handle and head) then return end
            local handlePos = (handle.CFrame * GunData["Tactical SG"].Offset).Position
            local aimPos = handlePos + head.CFrame.LookVector * 9999999
            local muzzle = gun:FindFirstChild("Default")
                and gun.Default:FindFirstChild("Mesh")
                and gun.Default.Mesh:FindFirstChild("Muzzle")
            local origin = muzzle and muzzle.WorldPosition or handlePos
            local shots = {}
            for i = 1, 5 do
                table.insert(shots, {
                    AimPosition = aimPos,
                    Result1 = nil,
                    Result2 = nil,
                    Result3 = nil,
                })
            end
            local remote = G.RS:FindFirstChild("GameRemotes")
            if remote then remote = remote:FindFirstChild("MainGameEvent") end
            if not remote then return end
            pcall(function()
                remote:FireServer("ShootGun", handle, origin, shots, nil, nil, nil, 9999999, 9999)
            end)
        end)
        table.insert(store.Connections, conn)
        table.insert(store.Connections, gun.AncestryChanged:Connect(function()
            if not gun.Parent then CleanupGun(gun) end
        end))
    end
    
    local Patchers = {
        ["Revolver"] = PatchRevolver,
        ["Double Barrel"] = PatchDoubleBarrel,
        ["Tactical SG"] = PatchTacticalShotgun,
    }
    
    local function ScanAndPatch()
        if not InfRangeEnabled then return end
        local char = G.LP.Character
        local backpack = G.LP:FindFirstChild("Backpack")
        for _, gunName in ipairs(SelectedGuns) do
            local gData = GunData[gunName]
            if gData then
                if char then
                    local tool = char:FindFirstChild(gData.ToolName)
                    if tool then pcall(function() Patchers[gunName](tool) end) end
                end
                if backpack then
                    local tool = backpack:FindFirstChild(gData.ToolName)
                    if tool then pcall(function() Patchers[gunName](tool) end) end
                end
            end
        end
    end
    
    local function SetupMonitoring()
        for _, c in ipairs(MonitorConnections) do
            pcall(function() c:Disconnect() end)
        end
        table.clear(MonitorConnections)
        local backpack = G.LP:WaitForChild("Backpack")
        table.insert(MonitorConnections, backpack.ChildAdded:Connect(function(child)
            if not InfRangeEnabled then return end
            for _, gunName in ipairs(SelectedGuns) do
                local gData = GunData[gunName]
                if gData and child.Name == gData.ToolName then
                    pcall(function() Patchers[gunName](child) end)
                end
            end
        end))
        local function OnCharacterAdded(char)
            table.insert(MonitorConnections, char.ChildAdded:Connect(function(child)
                if not InfRangeEnabled then return end
                for _, gunName in ipairs(SelectedGuns) do
                    local gData = GunData[gunName]
                    if gData and child.Name == gData.ToolName then
                        pcall(function() Patchers[gunName](child) end)
                    end
                end
            end))
            ScanAndPatch()
        end
        if G.LP.Character then
            OnCharacterAdded(G.LP.Character)
        end
        table.insert(MonitorConnections, G.LP.CharacterAdded:Connect(OnCharacterAdded))
    end
    
    
    local function IsGunSelected(tool)
        if not SelectedGuns or #SelectedGuns == 0 then return false end
        for _, name in ipairs(SelectedGuns) do
            if GunData[name] and tool.Name == GunData[name].ToolName then
                return true
            end
        end
        return false
    end
    
    
       -- ============================================
    -- WEAPONS TAB - INF RANGE, RAPID FIRE, REMOVE DELAY
    -- ============================================
    
    -- Gun Data (NO DOUBLE BARREL)
    local GunData = {
        ["Revolver"] = {
            ToolName = "[Revolver]",
            Offset = CFrame.new(-1, 0.4, 0),
            UseHandler = true,
        },
        ["Tactical SG"] = {
            ToolName = "[TacticalShotgun]",
            Offset = CFrame.new(0, 0.25, -2.5),
            IsShotgun = true,
            Pellets = 5,
        },
    }
    
    -- State
    local SelectedGuns = {}
    local InfRangeEnabled = false
    local PatchedGuns = {}
    local MonitorConnections = {}
    local RapidFireEnabled = false
    local RapidFireTools = {}
    local RemoveDelayEnabled = false
    local RemoveDelayTools = {}
    local RemoveDelayHold = false
    local RemoveDelayHoldDelay = 0.05
    local RemoveDelayHoldActive = false
    local RemoveDelayHoldConnection = nil
    local RemoveDelayMouseDownConnection = nil
    local RemoveDelayMouseUpConnection = nil
    
    -- ========================== SPREAD SYSTEM ==========================
    local settings = { 
        BulletSpread = { 
            Enabled = false, 
            Amount = 0 
        } 
    }
    
    local originalRandom
    originalRandom = hookfunction(math.random, function(...)
        local args = { ... }
        if checkcaller() then return originalRandom(...) end
        if (#args == 0) or 
           (args[1] == -0.05 and args[2] == 0.05) or 
           (args[1] == -0.1) or 
           (args[1] == -0.05) then
            if settings.BulletSpread.Enabled then
                return originalRandom(...) * (settings.BulletSpread.Amount / 100)
            end
        end
        return originalRandom(...)
    end)
    -- ===================================================================
    
    -- Spread UI
    Sections.WeaponsRight:Dropdown({
        Name = "Spread Guns",
        Flag = "spread_gun_selector",
        Items = {"Tactical Shotgun"},
        Default = {},
        Multi = true,
    })
    
    Sections.WeaponsRight:Toggle({
        Name = "adjust spread",
        Flag = "adjust_spread",
        Default = false,
        Callback = function(value)
            settings.BulletSpread.Enabled = value
        end,
    })
    
    Sections.WeaponsRight:Slider({
        Name = "spread amount",
        Flag = "spread_amount",
        Min = 1,
        Max = 100,
        Default = 1,
        Callback = function(value)
            settings.BulletSpread.Amount = value
        end,
    })
    
    -- ============================================
    -- INF RANGE FUNCTIONS
    -- ============================================
    
    local function CleanupGun(gun)
        local data = PatchedGuns[gun]
        if not data then return end
        for _, c in ipairs(data.Connections) do
            pcall(function() c:Disconnect() end)
        end
        if data.OriginalValues then
            for propName, propValue in pairs(data.OriginalValues) do
                local prop = gun:FindFirstChild(propName)
                if prop then
                    pcall(function() prop.Value = propValue end)
                end
            end
        end
        local ourEvent = gun:FindFirstChild("Activated")
        if ourEvent and data.OurActivated then
            pcall(function() ourEvent:Destroy() end)
        end
        local originalEvent = gun:FindFirstChild("_OriginalActivated")
        if originalEvent then
            pcall(function() originalEvent.Name = "Activated" end)
        end
        if data.OriginalActivatedProp ~= nil then
            pcall(function() gun.Activated = data.OriginalActivatedProp end)
        end
        PatchedGuns[gun] = nil
    end
    
    local function PatchProperties(gun, storage)
        local props = {"Range", "Damage"}
        storage.OriginalValues = {}
        for _, propName in ipairs(props) do
            local prop = gun:FindFirstChild(propName)
            if not prop then
                prop = Instance.new("NumberValue")
                prop.Name = propName
                prop.Parent = gun
                storage.OriginalValues[propName] = 0
            else
                storage.OriginalValues[propName] = prop.Value
            end
            if propName == "Range" then prop.Value = 9999999 end
            if propName == "Damage" then prop.Value = 9999 end
        end
    end
    
    local function PatchRevolver(gun)
        if PatchedGuns[gun] then return end
        local store = {Connections = {}, OriginalValues = {}}
        PatchedGuns[gun] = store
        PatchProperties(gun, store)
        local oldActivated = gun:FindFirstChild("Activated")
        if oldActivated then
            oldActivated.Name = "_OriginalActivated"
            store.OriginalActivated = oldActivated
        end
        local newActivated = Instance.new("BindableEvent")
        newActivated.Name = "Activated"
        newActivated.Parent = gun
        store.OurActivated = newActivated
        local conn = newActivated.Event:Connect(function()
            if not InfRangeEnabled then
                local orig = gun:FindFirstChild("_OriginalActivated")
                if orig then pcall(function() orig:Fire() end) end
                return
            end
            local handle = gun:FindFirstChild("Handle")
            local char = G.LP.Character
            local head = char and char:FindFirstChild("Head")
            if not (handle and head) then return end
            local handlePos = (handle.CFrame * GunData["Revolver"].Offset).Position
            local aimPos = handlePos + head.CFrame.LookVector * 9999999
            local muzzle = gun:FindFirstChild("Default")
                and gun.Default:FindFirstChild("Mesh")
                and gun.Default.Mesh:FindFirstChild("Muzzle")
            local origin = muzzle and muzzle.WorldPosition or handlePos
            local remote = G.RS:FindFirstChild("GameRemotes")
            if remote then remote = remote:FindFirstChild("MainGameEvent") end
            if not remote then return end
            local v6, v7, v8 = nil, nil, nil
            local GunHandler = nil
            pcall(function() GunHandler = require(G.RS.Modules.GunHandler) end)
            if GunHandler then
                pcall(function()
                    v6, v7, v8 = GunHandler.Shoot({
                        Shooter = G.LP,
                        Handle = handle,
                        ForcedOrigin = origin,
                        AimPosition = aimPos,
                        BeamColor = Color3.new(1, 0, 0),
                        Range = 9999999,
                    })
                end)
            end
            pcall(function()
                remote:FireServer("ShootGun", handle, origin, nil, v6, v7, v8, 9999999, 9999)
            end)
        end)
        table.insert(store.Connections, conn)
        table.insert(store.Connections, gun.AncestryChanged:Connect(function()
            if not gun.Parent then CleanupGun(gun) end
        end))
    end
    
    local function PatchTacticalShotgun(gun)
        if PatchedGuns[gun] then return end
        local store = {Connections = {}, OriginalValues = {}}
        PatchedGuns[gun] = store
        PatchProperties(gun, store)
        local oldActivated = gun:FindFirstChild("Activated")
        if oldActivated then
            oldActivated.Name = "_OriginalActivated"
            store.OriginalActivated = oldActivated
        end
        local newActivated = Instance.new("BindableEvent")
        newActivated.Name = "Activated"
        newActivated.Parent = gun
        store.OurActivated = newActivated
        local conn = newActivated.Event:Connect(function()
            if not InfRangeEnabled then
                local orig = gun:FindFirstChild("_OriginalActivated")
                if orig then pcall(function() orig:Fire() end) end
                return
            end
            local handle = gun:FindFirstChild("Handle")
            local char = G.LP.Character
            local head = char and char:FindFirstChild("Head")
            if not (handle and head) then return end
            local handlePos = (handle.CFrame * GunData["Tactical SG"].Offset).Position
            local aimPos = handlePos + head.CFrame.LookVector * 9999999
            local muzzle = gun:FindFirstChild("Default")
                and gun.Default:FindFirstChild("Mesh")
                and gun.Default.Mesh:FindFirstChild("Muzzle")
            local origin = muzzle and muzzle.WorldPosition or handlePos
            local shots = {}
            for i = 1, 5 do
                table.insert(shots, {
                    AimPosition = aimPos,
                    Result1 = nil,
                    Result2 = nil,
                    Result3 = nil,
                })
            end
            local remote = G.RS:FindFirstChild("GameRemotes")
            if remote then remote = remote:FindFirstChild("MainGameEvent") end
            if not remote then return end
            pcall(function()
                remote:FireServer("ShootGun", handle, origin, shots, nil, nil, nil, 9999999, 9999)
            end)
        end)
        table.insert(store.Connections, conn)
        table.insert(store.Connections, gun.AncestryChanged:Connect(function()
            if not gun.Parent then CleanupGun(gun) end
        end))
    end
    
    local Patchers = {
        ["Revolver"] = PatchRevolver,
        ["Tactical SG"] = PatchTacticalShotgun,
    }
    
    -- ============================================
    -- PATCH GUN ONLY WHEN EQUIPPED
    -- ============================================
    local function PatchGunIfEquipped(gun)
        if not gun then return end
        if not InfRangeEnabled then return end
        if gun.Parent ~= G.LP.Character then return end
        if PatchedGuns[gun] then return end
        
        for gunName, gData in pairs(GunData) do
            if gun.Name == gData.ToolName then
                if Patchers[gunName] then
                    pcall(function() Patchers[gunName](gun) end)
                end
                break
            end
        end
    end
    
    local function CheckEquippedGun()
        if not InfRangeEnabled then return end
        local char = G.LP.Character
        if not char then return end
        local tool = char:FindFirstChildOfClass("Tool")
        if tool then
            PatchGunIfEquipped(tool)
        end
    end
    
    local function ScanAndPatch()
        if not InfRangeEnabled then return end
        local char = G.LP.Character
        if not char then return end
        local tool = char:FindFirstChildOfClass("Tool")
        if tool then
            PatchGunIfEquipped(tool)
        end
    end
    
    -- ============================================
    -- RAPID FIRE FUNCTIONS
    -- ============================================
    
    local function IsGunSelected(tool)
        if not SelectedGuns or #SelectedGuns == 0 then return false end
        for _, name in ipairs(SelectedGuns) do
            if GunData[name] and tool.Name == GunData[name].ToolName then
                return true
            end
        end
        return false
    end
    
    local function SetupRapidFire(tool)
        if not tool or not tool.Parent then return end
        if RapidFireTools[tool] then return end
        if tool.Parent ~= G.LP.Character then return end
        if not tool:FindFirstChild("GunScript") then return end
        
        local connections = getconnections(tool.Activated)
        for _, conn in ipairs(connections) do
            local func = conn.Function
            if func then
                local info = debug.getinfo(func)
                for i = 1, (info.nups or 0) do
                    local val = debug.getupvalue(func, i)
                    if type(val) == "number" and val > 0 and val < 0.5 then
                        debug.setupvalue(func, i, 0)
                    end
                end
            end
        end
        RapidFireTools[tool] = true
    end
    
    local function CleanupRapidFire(tool)
        RapidFireTools[tool] = nil
    end
    
    local function ScanAndPatchRapidFire()
        if not RapidFireEnabled then return end
        local char = G.LP.Character
        if not char then return end
        local equipped = char:FindFirstChildOfClass("Tool")
        if equipped and IsGunSelected(equipped) then
            SetupRapidFire(equipped)
        end
    end
    
    -- ============================================
    -- REMOVE DELAY FUNCTIONS
    -- ============================================
    
    local function SetupRemoveDelay(tool)
        if not tool or not tool.Parent then return end
        if RemoveDelayTools[tool] then return end
        if tool.Parent ~= G.LP.Character then return end
        
        local gunScript = tool:FindFirstChild("GunScript")
        local fireRate = tool:FindFirstChild("FireRate") or tool:FindFirstChild("Rate") or tool:FindFirstChild("ShootRate")
        local cooldown = tool:FindFirstChild("ShootingCooldown")
        
        if gunScript then
            local connections = getconnections(tool.Activated)
            for _, conn in ipairs(connections) do
                local func = conn.Function
                if func then
                    local info = debug.getinfo(func)
                    for i = 1, (info.nups or 0) do
                        local val = debug.getupvalue(func, i)
                        if type(val) == "number" and val > 0.05 and val < 1 then
                            debug.setupvalue(func, i, 0)
                        end
                    end
                end
            end
        end
        
        if fireRate and fireRate:IsA("NumberValue") then
            fireRate.Value = 0
        end
        
        if cooldown and cooldown:IsA("NumberValue") then
            cooldown.Value = 0
        end
        
        RemoveDelayTools[tool] = true
    end
    
    local function CleanupRemoveDelay(tool)
        RemoveDelayTools[tool] = nil
    end
    
    local function ScanAndPatchRemoveDelay()
        if not RemoveDelayEnabled then return end
        local char = G.LP.Character
        if not char then return end
        local equipped = char:FindFirstChildOfClass("Tool")
        if equipped and IsGunSelected(equipped) then
            SetupRemoveDelay(equipped)
        end
    end
    
    -- ============================================
    -- HOLD MODE (AUTO-CLICKER LOGIC WITH DELAY)
    -- ============================================
    local function StartHoldMode()
        if RemoveDelayHoldConnection then return end
        
        RemoveDelayMouseDownConnection = G.U.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                if not RemoveDelayEnabled then return end
                
                local char = G.LP.Character
                if not char then return end
                local tool = char:FindFirstChildOfClass("Tool")
                if not tool or not IsGunSelected(tool) then return end
                
                if not RemoveDelayTools[tool] then
                    SetupRemoveDelay(tool)
                end
                
                RemoveDelayHoldActive = true
                
                if RemoveDelayHoldConnection then
                    RemoveDelayHoldConnection:Disconnect()
                    RemoveDelayHoldConnection = nil
                end
                
                local delay = RemoveDelayHoldDelay
                local lastFire = 0
                
                -- Fire immediately on click
                pcall(function() tool:Activate() end)
                lastFire = tick()
                
                RemoveDelayHoldConnection = G.R.Heartbeat:Connect(function()
                    if not RemoveDelayHoldActive then
                        if RemoveDelayHoldConnection then
                            RemoveDelayHoldConnection:Disconnect()
                            RemoveDelayHoldConnection = nil
                        end
                        return
                    end
                    
                    local char2 = G.LP.Character
                    if not char2 then
                        RemoveDelayHoldActive = false
                        return
                    end
                    
                    local tool2 = char2:FindFirstChildOfClass("Tool")
                    if not tool2 or not IsGunSelected(tool2) then
                        RemoveDelayHoldActive = false
                        return
                    end
                    
                    -- Only fire if enough time has passed since last fire
                    local now = tick()
                    if now - lastFire >= delay then
                        pcall(function() tool2:Activate() end)
                        lastFire = now
                    end
                end)
            end
        end)
        
        RemoveDelayMouseUpConnection = G.U.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                RemoveDelayHoldActive = false
                if RemoveDelayHoldConnection then
                    RemoveDelayHoldConnection:Disconnect()
                    RemoveDelayHoldConnection = nil
                end
            end
        end)
    end
    
    local function StopHoldMode()
        RemoveDelayHoldActive = false
        
        if RemoveDelayHoldConnection then
            RemoveDelayHoldConnection:Disconnect()
            RemoveDelayHoldConnection = nil
        end
        
        if RemoveDelayMouseDownConnection then
            RemoveDelayMouseDownConnection:Disconnect()
            RemoveDelayMouseDownConnection = nil
        end
        
        if RemoveDelayMouseUpConnection then
            RemoveDelayMouseUpConnection:Disconnect()
            RemoveDelayMouseUpConnection = nil
        end
    end
    
    local function RefreshHoldMode()
        StopHoldMode()
        if RemoveDelayHold and RemoveDelayEnabled then
            StartHoldMode()
        end
    end
    
    -- ============================================
    -- CLEANUP ALL ON DEATH/RESPAWN
    -- ============================================
    local function CleanupAllWeaponMods()
        -- Cleanup Inf Range
        for gun, _ in pairs(PatchedGuns) do
            CleanupGun(gun)
        end
        
        -- Cleanup Rapid Fire
        for tool, _ in pairs(RapidFireTools) do
            CleanupRapidFire(tool)
        end
        RapidFireTools = {}
        
        -- Cleanup Remove Delay
        for tool, _ in pairs(RemoveDelayTools) do
            CleanupRemoveDelay(tool)
        end
        RemoveDelayTools = {}
        
        -- Stop Hold Mode
        StopHoldMode()
    end
    
    -- ============================================
    -- RENDER LOOPS
    -- ============================================
    
    G.R.RenderStepped:Connect(function()
        if InfRangeEnabled then
            CheckEquippedGun()
        end
    end)
    
    G.R.RenderStepped:Connect(function()
        if not RapidFireEnabled then return end
        local char = G.LP.Character
        if not char then return end
        local tool = char:FindFirstChildOfClass("Tool")
        if tool and IsGunSelected(tool) then
            if not RapidFireTools[tool] then
                SetupRapidFire(tool)
            end
            if G.U:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                tool:Activate()
            end
        end
    end)
    
    G.R.RenderStepped:Connect(function()
        if not RemoveDelayEnabled then return end
        local char = G.LP.Character
        if not char then return end
        local tool = char:FindFirstChildOfClass("Tool")
        if tool and IsGunSelected(tool) then
            if not RemoveDelayTools[tool] then
                SetupRemoveDelay(tool)
            end
        end
    end)
    
    -- ============================================
    -- CHARACTER EVENTS
    -- ============================================
    
    if G.LP.Character then
        G.LP.Character.ChildAdded:Connect(function(child)
            if child:IsA("Tool") then
                -- Wait for the tool to be fully equipped
                task.wait(0.15)
                
                if InfRangeEnabled and IsGunSelected(child) and child.Parent == G.LP.Character then
                    PatchGunIfEquipped(child)
                end
                if RapidFireEnabled and IsGunSelected(child) and child.Parent == G.LP.Character then
                    SetupRapidFire(child)
                end
                if RemoveDelayEnabled and IsGunSelected(child) and child.Parent == G.LP.Character then
                    SetupRemoveDelay(child)
                end
            end
        end)
    end
    
    G.LP.CharacterAdded:Connect(function()
        -- Cleanup everything on death/respawn FIRST
        CleanupAllWeaponMods()
        
        -- Then re-apply after character loads
        task.delay(0.8, function()
            if RapidFireEnabled then
                ScanAndPatchRapidFire()
            end
            if InfRangeEnabled then
                ScanAndPatch()
            end
            if RemoveDelayEnabled then
                ScanAndPatchRemoveDelay()
                if RemoveDelayHold then
                    StartHoldMode()
                end
            end
        end)
    end)
    
    -- ============================================
    -- MONITORING
    -- ============================================
    
    local function SetupMonitoring()
        for _, c in ipairs(MonitorConnections) do
            pcall(function() c:Disconnect() end)
        end
        table.clear(MonitorConnections)
        local backpack = G.LP:WaitForChild("Backpack")
        table.insert(MonitorConnections, backpack.ChildAdded:Connect(function(child)
            -- Don't patch in backpack - wait for equip
        end))
        local function OnCharacterAdded(char)
            table.insert(MonitorConnections, char.ChildAdded:Connect(function(child)
                if not InfRangeEnabled then return end
                for _, gunName in ipairs(SelectedGuns) do
                    local gData = GunData[gunName]
                    if gData and child.Name == gData.ToolName then
                        task.delay(0.15, function()
                            PatchGunIfEquipped(child)
                        end)
                    end
                end
            end))
            ScanAndPatch()
        end
        if G.LP.Character then
            OnCharacterAdded(G.LP.Character)
        end
        table.insert(MonitorConnections, G.LP.CharacterAdded:Connect(OnCharacterAdded))
    end
    
    -- ============================================
    -- MENU
    -- ============================================
    
    Sections.WeaponsLeft:Dropdown({
        Name = "modification",
        Flag = "gun_selector",
        Items = {"Revolver", "Tactical SG"},
        Default = {"Revolver"},
        Multi = true,
        Callback = function(selected)
            SelectedGuns = selected
            for gun, _ in pairs(PatchedGuns) do
                local stillSelected = false
                for _, name in ipairs(selected) do
                    if gun.Name == GunData[name].ToolName then
                        stillSelected = true
                        break
                    end
                end
                if not stillSelected then
                    CleanupGun(gun)
                end
            end
            if InfRangeEnabled then
                ScanAndPatch()
            end
            if #selected > 0 then
                task.delay(0.3, ForceRefillAllGuns)
            end
        end,
    })
    
    Sections.WeaponsLeft:Toggle({
        Name = "inf range",
        Flag = "inf_range",
        Default = false,
        Callback = function(value)
            if value and _KillAllEnabled then
                pcall(function()
                    if Sections.WeaponsLeft and Sections.WeaponsLeft.Toggles and Sections.WeaponsLeft.Toggles.inf_range then
                        Sections.WeaponsLeft.Toggles.inf_range:Set(false)
                    end
                end)
                return
            end
            
            InfRangeEnabled = value
            if not value then
                for gun, _ in pairs(PatchedGuns) do
                    CleanupGun(gun)
                end
            else
                task.delay(0.3, function()
                    if InfRangeEnabled then
                        ScanAndPatch()
                        ForceRefillAllGuns()
                    end
                end)
            end
        end,
    })
    
    Sections.WeaponsLeft:Toggle({
        Name = "rapid fire",
        Flag = "rapid_fire",
        Default = false,
        Callback = function(value)
            if value and _KillAllEnabled then
                pcall(function()
                    if Sections.WeaponsLeft and Sections.WeaponsLeft.Toggles and Sections.WeaponsLeft.Toggles.rapid_fire then
                        Sections.WeaponsLeft.Toggles.rapid_fire:Set(false)
                    end
                end)
                return
            end
            
            RapidFireEnabled = value
            if not value then
                for tool, _ in pairs(RapidFireTools) do
                    CleanupRapidFire(tool)
                end
                RapidFireTools = {}
            else
                task.delay(0.3, function()
                    if RapidFireEnabled then
                        ScanAndPatchRapidFire()
                        ForceRefillAllGuns()
                    end
                end)
            end
        end,
    })
    
    -- Remove Delay Toggle
    Sections.WeaponsLeft:Toggle({
        Name = "remove delay",
        Flag = "remove_delay",
        Default = false,
        Callback = function(value)
            if value and _KillAllEnabled then
                pcall(function()
                    if Sections.WeaponsLeft and Sections.WeaponsLeft.Toggles and Sections.WeaponsLeft.Toggles.remove_delay then
                        Sections.WeaponsLeft.Toggles.remove_delay:Set(false)
                    end
                end)
                return
            end
            
            RemoveDelayEnabled = value
            if not value then
                StopHoldMode()
                for tool, _ in pairs(RemoveDelayTools) do
                    CleanupRemoveDelay(tool)
                end
                RemoveDelayTools = {}
            else
                task.delay(0.3, function()
                    if RemoveDelayEnabled then
                        ScanAndPatchRemoveDelay()
                        ForceRefillAllGuns()
                        if RemoveDelayHold then
                            StartHoldMode()
                        end
                    end
                end)
            end
        end,
    })
    
    -- Hold Mode Toggle
    Sections.WeaponsLeft:Toggle({
        Name = "hold mode",
        Flag = "remove_delay_hold",
        Default = false,
        Callback = function(value)
            RemoveDelayHold = value
            if value and RemoveDelayEnabled then
                StartHoldMode()
            else
                StopHoldMode()
            end
        end,
    })
    
    -- Hold Delay Slider
    Sections.WeaponsLeft:Slider({
        Name = "hold delay",
        Flag = "remove_delay_hold_delay",
        Default = 0.075,
        Min = 0.001,
        Max = 0.150,
        Decimals = 0.001,
        Callback = function(value)
            RemoveDelayHoldDelay = value
            if RemoveDelayHold and RemoveDelayEnabled then
                StopHoldMode()
                StartHoldMode()
            end
        end,
    })
    
    SetupMonitoring()
    
    
    
        -- ============================================
    -- RAGE TARGET SECTION - FULL WORKING
    -- ============================================
    
    local Target = {
        Enabled = false,
        AutoKill = false,
        MultiKill = false,
        MultiTargets = {},
        CurrentTarget = nil,
        TargetLine = false,
        LineColor = Color3.fromRGB(255, 0, 0)
    }
    
    local selectedTarget = nil
    local autoKillConnection = nil
    local multiKillConnection = nil
    local targetLine = nil
    local isRefilling = false
    local refillCooldown = 0
    
    -- ============================================
    -- DISABLE WEAPON MODS WHEN TARGET IS ON
    -- ============================================
    local function disableWeaponModsForTarget()
        -- Disable Inf Range
        if InfRangeEnabled then
            InfRangeEnabled = false
            for gun, _ in pairs(PatchedGuns) do
                CleanupGun(gun)
            end
            pcall(function()
                if Sections.WeaponsLeft and Sections.WeaponsLeft.Toggles and Sections.WeaponsLeft.Toggles.inf_range then
                    Sections.WeaponsLeft.Toggles.inf_range:Set(false)
                end
            end)
        end
        
        -- Disable Rapid Fire
        if RapidFireEnabled then
            RapidFireEnabled = false
            for tool, _ in pairs(RapidFireTools) do
                CleanupRapidFire(tool)
            end
            RapidFireTools = {}
            pcall(function()
                if Sections.WeaponsLeft and Sections.WeaponsLeft.Toggles and Sections.WeaponsLeft.Toggles.rapid_fire then
                    Sections.WeaponsLeft.Toggles.rapid_fire:Set(false)
                end
            end)
        end
    end
    
    -- ============================================
    -- FIND REMOTES
    -- ============================================
    local function findKillRemote()
        for _, obj in ipairs(G.RS:GetDescendants()) do
            if obj:IsA("RemoteEvent") and obj.Name:lower():find("main", 1, true) then
                return obj
            end
        end
        return nil
    end
    
    local function findLoadoutRemote()
        for _, obj in ipairs(G.RS:GetDescendants()) do
            if obj:IsA("RemoteEvent") and obj.Name:lower():find("loadout", 1, true) then
                return obj
            end
        end
        return nil
    end
    
    local KillRemote = findKillRemote()
    local LoadoutRemote = findLoadoutRemote()
    
    -- ============================================
    -- GET CURRENT EQUIPPED GUN
    -- ============================================
    local function getCurrentGun()
        local char = G.LP.Character
        if not char then return nil end
        local tool = char:FindFirstChildOfClass("Tool")
        if tool then
            local ammo = tool:FindFirstChild("Ammo")
            local handle = tool:FindFirstChild("Handle")
            if ammo and handle then
                return tool
            end
        end
        return nil
    end
    
    -- ============================================
    -- CHECK IF GUN NEEDS REFILL
    -- ============================================
    local function needsRefill(tool)
        if not tool then return false end
        local ammo = tool:FindFirstChild("Ammo")
        if not ammo then return false end
        return ammo.Value <= 0
    end
    
    -- ============================================
    -- AMMO REFILL SYSTEM
    -- ============================================
    local function requestAmmoRefill(tool)
        if LoadoutRemote == nil or isRefilling or tool == nil then return false end
        if tick() - refillCooldown < 0.8 then return false end
        
        local ammo = tool:FindFirstChild("Ammo")
        if not ammo then return false end
        if ammo:GetAttribute("ZeeKillRefillRequested") then return false end
        if not needsRefill(tool) then return false end
        
        local char = G.LP.Character
        local bp = G.LP:FindFirstChild("Backpack")
        if bp == nil then return false end
        
        isRefilling = true
        refillCooldown = tick()
        
        ammo:SetAttribute("ZeeKillRefillRequested", true)
        
        local requestedName = tool.Name
        local oldTools = {}
        local equippedTools = {}
        local newestTools = {}
        local seenTools = {}
        
        for _, container in ipairs({bp, char}) do
            if container then
                for _, item in ipairs(container:GetChildren()) do
                    if item:IsA("Tool") and item:FindFirstChild("Ammo") then
                        oldTools[item] = true
                        if item.Parent == char then
                            equippedTools[item.Name] = true
                        end
                    end
                end
            end
        end
        
        local connections = {}
        local stopped = false
        local deadline = os.clock() + 2.0
        local lastAdded = os.clock()
        
        local function stop()
            if stopped then return end
            stopped = true
            for _, conn in ipairs(connections) do
                pcall(function() conn:Disconnect() end)
            end
            if not newestTools[requestedName] and ammo.Parent then
                ammo:SetAttribute("ZeeKillRefillRequested", nil)
            end
            isRefilling = false
        end
        
        local function accept(item)
            if not item:IsA("Tool") or not item:FindFirstChild("Ammo") or oldTools[item] or seenTools[item] then
                return
            end
            seenTools[item] = true
            lastAdded = os.clock()
            local name = item.Name
            local previous = newestTools[name]
            if previous and previous ~= item and previous.Parent then
                previous:Destroy()
            end
            newestTools[name] = item
            for oldTool in pairs(oldTools) do
                if oldTool.Name == name and oldTool.Parent then
                    oldTool:Destroy()
                end
            end
            if equippedTools[name] and char and item.Parent then
                item.Parent = char
            end
        end
        
        connections[1] = bp.ChildAdded:Connect(accept)
        if char then
            connections[2] = char.ChildAdded:Connect(accept)
        end
        
        local loadout = {tool.Name}
        LoadoutRemote:FireServer(loadout)
        
        local heartbeat = G.R.Heartbeat:Connect(function()
            if os.clock() >= deadline or (next(newestTools) and os.clock() - lastAdded >= 0.15) then
                stop()
            end
        end)
        
        return true
    end
    
    -- ============================================
    -- RE-EQUIP FUNCTION
    -- ============================================
    local function forceReEquip(weaponName)
        if not weaponName then return end
        
        task.spawn(function()
            task.wait(1.0)
            
            local attempts = 0
            local maxAttempts = 5
            
            while attempts < maxAttempts do
                attempts = attempts + 1
                task.wait(0.1)
                
                local char = G.LP.Character
                if not char then continue end
                
                local equipped = char:FindFirstChild(weaponName)
                if equipped then
                    return
                end
                
                local bp = G.LP:FindFirstChild("Backpack")
                if bp then
                    local tool = bp:FindFirstChild(weaponName)
                    if tool then
                        tool.Parent = char
                        return
                    end
                end
            end
        end)
    end
    
    -- ============================================
    -- GET TARGET FROM CROSSHAIR
    -- ============================================
    local function getTargetFromCrosshair()
        local mousePos = G.U:GetMouseLocation()
        local SELECTION_FOV = 150
        
        local closestPlayer = nil
        local closestDistance = SELECTION_FOV
        
        for _, player in ipairs(G.P:GetPlayers()) do
            if player ~= G.LP and player.Character then
                local hum = player.Character:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 then
                    local be = player.Character:FindFirstChild("BodyEffects")
                    local knocked = false
                    if be then
                        local ko = be:FindFirstChild("K.O")
                        if ko and ko.Value == true then knocked = true end
                    end
                    if not knocked then
                        local head = player.Character:FindFirstChild("Head")
                        if head then
                            local screenPos, onScreen = G.C:WorldToScreenPoint(head.Position)
                            if onScreen then
                                local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                                if dist < closestDistance then
                                    closestDistance = dist
                                    closestPlayer = player
                                end
                            end
                        end
                    end
                end
            end
        end
        
        return closestPlayer
    end
    
    -- ============================================
    -- KILL TARGET FUNCTION
    -- ============================================
    local function killTarget(player)
        if not player then return false end
        if not player.Character then return false end
        if isRefilling then return false end
        
        local char = G.LP.Character
        local bp = G.LP:FindFirstChild("Backpack")
        if not char or not bp then return false end
        
        local tool = getCurrentGun()
        if not tool then
            for _, child in ipairs(bp:GetChildren()) do
                if child:IsA("Tool") and child:FindFirstChild("Ammo") and child:FindFirstChild("Handle") then
                    child.Parent = char
                    tool = child
                    break
                end
            end
            if not tool then
                return false
            end
        end
        
        local currentWeaponName = tool.Name
        local handle = tool:FindFirstChild("Handle")
        local ammo = tool:FindFirstChild("Ammo")
        if not handle or not ammo then return false end
        if KillRemote == nil then return false end
        
        if needsRefill(tool) and not isRefilling then
            requestAmmoRefill(tool)
            return false
        end
        
        if isRefilling then
            return false
        end
        
        local targetChar = player.Character
        if not targetChar then return false end
        
        local head = targetChar:FindFirstChild("Head")
        if not head then return false end
        
        local hum = targetChar:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then return false end
        
        local be = targetChar:FindFirstChild("BodyEffects")
        if be then
            local ko = be:FindFirstChild("K.O")
            if ko and ko.Value == true then return false end
        end
        
        local pos = head.Position
        
        local pellets = {}
        for _ = 1, 20 do
            pellets[#pellets + 1] = {
                AimPosition = pos,
                Result1 = pos,
                Result2 = head,
                Result3 = Vector3.yAxis
            }
        end
        
        local rangeObj = tool:FindFirstChild("Range")
        local dmgObj = tool:FindFirstChild("Damage")
        local range = rangeObj and rangeObj.Value or 200
        local dmg = dmgObj and dmgObj.Value or 50
        
        tool.Enabled = true
        if tool.Parent ~= char then
            tool.Parent = char
        end
        
        local shots = 8
        local toolName = tool.Name
        if toolName == "[Revolver]" then
            shots = 3
        elseif toolName == "[Double-Barrel SG]" then
            shots = 8
        elseif toolName == "[TacticalShotgun]" then
            shots = 8
        end
        
        for _ = 1, shots do
            KillRemote:FireServer("ShootGun", handle, handle.Position, pellets, nil, nil, nil, range, dmg)
        end
        
        forceReEquip(currentWeaponName)
        return true
    end
    
    -- ============================================
    -- CHECK IF TARGET IS VALID
    -- ============================================
    local function isValidTarget(player)
        if not player or player == G.LP then return false end
        if not player.Character then return false end
        local hum = player.Character:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then return false end
        local be = player.Character:FindFirstChild("BodyEffects")
        if be then
            local ko = be:FindFirstChild("K.O")
            if ko and ko.Value == true then return false end
        end
        return true
    end
    
    -- ============================================
    -- TARGET LINE
    -- ============================================
    local function CreateTargetLine()
        if not targetLine then
            local success, line = pcall(function()
                return Drawing.new("Line")
            end)
            if success and line then
                targetLine = line
                targetLine.Thickness = 2
                targetLine.Color = Target.LineColor
                targetLine.Transparency = 1
                targetLine.Visible = false
                return targetLine
            end
        end
        return targetLine
    end
    
    local function UpdateTargetLine()
        if not Target.Enabled or not Target.TargetLine or not selectedTarget then
            if targetLine then
                targetLine.Visible = false
            end
            return
        end
        
        if not isValidTarget(selectedTarget) then
            if targetLine then
                targetLine.Visible = false
            end
            return
        end
        
        local head = selectedTarget.Character:FindFirstChild("Head")
        if not head then
            if targetLine then
                targetLine.Visible = false
            end
            return
        end
        
        local screenPos, onScreen = G.C:WorldToScreenPoint(head.Position)
        if not onScreen then
            if targetLine then
                targetLine.Visible = false
            end
            return
        end
        
        local mousePos = G.U:GetMouseLocation()
        local line = CreateTargetLine()
        if line then
            line.From = Vector2.new(mousePos.X, mousePos.Y)
            line.To = Vector2.new(screenPos.X, screenPos.Y)
            line.Color = Target.LineColor
            line.Visible = true
        end
    end
    
    -- ============================================
    -- AUTO KILL SYSTEM
    -- ============================================
    local function StartAutoKill()
        if autoKillConnection then return end
        autoKillConnection = G.R.Heartbeat:Connect(function()
            if not Target.AutoKill or not Target.Enabled then return end
            if not selectedTarget then return end
            
            if isValidTarget(selectedTarget) then
                local tool = getCurrentGun()
                if tool then
                    local ammo = tool:FindFirstChild("Ammo")
                    if ammo and ammo.Value <= 0 then
                        requestAmmoRefill(tool)
                        return
                    end
                end
                killTarget(selectedTarget)
            end
            UpdateTargetLine()
        end)
    end
    
    local function StopAutoKill()
        if autoKillConnection then
            autoKillConnection:Disconnect()
            autoKillConnection = nil
        end
        if targetLine then
            targetLine.Visible = false
        end
    end
    
    -- ============================================
    -- MULTI TARGET KILL SYSTEM - FAST
    -- ============================================
    local function StartMultiKill()
        if multiKillConnection then return end
        
        multiKillConnection = G.R.Heartbeat:Connect(function()
            if not Target.MultiKill or not Target.Enabled then return end
            if not Target.MultiTargets or #Target.MultiTargets == 0 then return end
            
            local tool = getCurrentGun()
            if tool then
                local ammo = tool:FindFirstChild("Ammo")
                if ammo and ammo.Value <= 0 then
                    requestAmmoRefill(tool)
                    return
                end
            end
            
            for _, playerName in ipairs(Target.MultiTargets) do
                local player = G.P:FindFirstChild(playerName)
                if player and isValidTarget(player) then
                    killTarget(player)
                end
            end
            UpdateTargetLine()
        end)
    end
    
    local function StopMultiKill()
        if multiKillConnection then
            multiKillConnection:Disconnect()
            multiKillConnection = nil
        end
        if targetLine then
            targetLine.Visible = false
        end
    end
    
    -- ============================================
    -- AMMO REFILL WATCHER - FAST
    -- ============================================
    G.R.Heartbeat:Connect(function()
        if not Target.Enabled then return end
        if isRefilling then return end
        
        local tool = getCurrentGun()
        if not tool then return end
        local ammo = tool:FindFirstChild("Ammo")
        if not ammo then return end
        
        if tool.Parent == G.LP.Character and ammo.Value <= 0 and not ammo:GetAttribute("ZeeKillRefillRequested") then
            requestAmmoRefill(tool)
        end
    end)
    
    -- ============================================
    -- SHOOT BUTTON HOOK
    -- ============================================
    G.U.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if not Target.Enabled then return end
        if isRefilling then return end
        
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            if selectedTarget and isValidTarget(selectedTarget) then
                killTarget(selectedTarget)
            end
        end
    end)
    
    -- ============================================
    -- TARGET LINE RENDER LOOP
    -- ============================================
    G.R.RenderStepped:Connect(function()
        if Target.Enabled and Target.TargetLine then
            UpdateTargetLine()
        elseif targetLine then
            targetLine.Visible = false
        end
    end)
    
    -- ============================================
    -- GET PLAYER NAMES
    -- ============================================
    local function GetPlayerNames()
        local t = {}
        for _, p in ipairs(G.P:GetPlayers()) do
            if p ~= G.LP then table.insert(t, p.Name) end
        end
        return t
    end
    
    -- ============================================
    -- MENU INTEGRATION
    -- ============================================
    
    local TargetToggle = Sections.RageTarget:Toggle({
        Name = 'target',
        Flag = 'target_system',
        Default = false,
        Callback = function(value)
            Target.Enabled = value
            if value then
                -- DISABLE INF RANGE & RAPID FIRE WHEN TARGET IS ENABLED
                disableWeaponModsForTarget()
            else
                selectedTarget = nil
                StopAutoKill()
                StopMultiKill()
                if targetLine then targetLine.Visible = false end
            end
        end
    })
    
    TargetToggle:Keybind({
        Flag = 'target_bind',
        Mode = 'Toggle',
        Callback = function(state)
            if state then
                -- DISABLE INF RANGE & RAPID FIRE WHEN TARGET IS ENABLED
                disableWeaponModsForTarget()
                local target = getTargetFromCrosshair()
                if target and isValidTarget(target) then
                    selectedTarget = target
                    
                    
                    if Target.AutoKill then
                        local tool = getCurrentGun()
                        if tool then
                            local ammo = tool:FindFirstChild("Ammo")
                            if ammo and ammo.Value <= 0 then
                                requestAmmoRefill(tool)
                                return
                            end
                        end
                        killTarget(selectedTarget)
                    end
                else
                    
                end
            else
                selectedTarget = nil
                StopAutoKill()
                if targetLine then targetLine.Visible = false end
            end
        end
    })
    
    Sections.RageTarget:Toggle({
        Name = 'auto kill',
        Flag = 'auto_kill_target',
        Default = false,
        Callback = function(value)
            Target.AutoKill = value
            if value and Target.Enabled then
                StartAutoKill()
                if selectedTarget and isValidTarget(selectedTarget) then
                    killTarget(selectedTarget)
                end
            else
                StopAutoKill()
            end
        end
    })
    
    Sections.RageTarget:Toggle({
        Name = 'multi kill',
        Flag = 'multi_kill_targets',
        Default = false,
        Callback = function(value)
            Target.MultiKill = value
            if value and Target.Enabled then
                StartMultiKill()
            else
                StopMultiKill()
            end
        end
    })
    
    local multiDropdown = Sections.RageTarget:Dropdown({
    Name = 'targets',
    Flag = 'kill_targets_list',
    Items = GetPlayerNames(),
    Default = {},
    Multi = true,
    Callback = function(value)
        Target.MultiTargets = value or {}
        if #Target.MultiTargets > 0 then
            
        end
    end
})

-- ============================================
-- TARGET MULTI KILL DROPDOWN REFRESH - SAME AS WHITELIST
-- ============================================
local function refreshMultiDropdown()
    local names = GetPlayerNames()
    if type(multiDropdown.Refresh) == "function" then 
        multiDropdown:Refresh(names)
    elseif type(multiDropdown.SetItems) == "function" then 
        multiDropdown:SetItems(names)
    elseif type(multiDropdown.SetValues) == "function" then 
        multiDropdown:SetValues(names)
    end
end

-- Refresh when players join/leave
G.P.PlayerAdded:Connect(refreshMultiDropdown)
G.P.PlayerRemoving:Connect(refreshMultiDropdown)

-- Refresh when dropdown button is clicked
task.defer(function()
    task.wait(0.1)
    local inst = typeof(multiDropdown) == "Instance" and multiDropdown or (type(multiDropdown) == "table" and multiDropdown.Instance)
    if inst then
        for _, d in ipairs(inst:GetDescendants()) do
            if d:IsA("GuiButton") then
                d.Activated:Connect(refreshMultiDropdown)
                break
            end
        end
    end
end)
    
    local LineToggle = Sections.RageTarget:Toggle({
        Name = 'target line',
        Flag = 'target_line',
        Default = false,
        Callback = function(value)
            Target.TargetLine = value
            if not value and targetLine then
                targetLine.Visible = false
            end
        end
    })
    
    LineToggle:Colorpicker({
        Flag = 'target_line_color',
        Default = Color3.fromRGB(255, 0, 0),
        Alpha = 0,
        Callback = function(color, alpha)
            Target.LineColor = color
            if targetLine then
                targetLine.Color = color
            end
        end
    })
    
    -- end of target
    
    
    
   
    local ESP = {Name=false, Distance=false, Health=false, Tool=false}
local ESPLabels = {Name={}, Distance={}, Health={}, Tool={}}
local TargetColor = Color3.fromRGB(255, 0, 0) -- Default red

local ScreenGui = G.CG:FindFirstChild("ESPGui") or Instance.new("ScreenGui")
if not ScreenGui.Parent then ScreenGui.Name = "ESPGui" ScreenGui.ResetOnSpawn = false ScreenGui.IgnoreGuiInset = true ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global ScreenGui.Parent = G.CG end

local function CreateLabel(name)
    local label = Instance.new("TextLabel")
    label.Name = name
    label.BackgroundTransparency = 1
    label.BorderSizePixel = 0
    label.Size = UDim2.new(0, 250, 0, 18)
    label.AnchorPoint = Vector2.new(0.5, 0.5)
    label.TextColor3 = Color3.fromRGB(172,183,212)
    label.TextStrokeColor3 = Color3.fromRGB(0,0,0)
    label.TextStrokeTransparency = 0
    label.TextSize = 13
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Center
    label.TextYAlignment = Enum.TextYAlignment.Center
    label.Visible = false
    label.ZIndex = 10
    label.Parent = ScreenGui
    return label
end

local function AddPlayer(p)
    if p == G.LP then return end
    ESPLabels.Name[p] = ESPLabels.Name[p] or CreateLabel("Name")
    ESPLabels.Distance[p] = ESPLabels.Distance[p] or CreateLabel("Distance")
    ESPLabels.Health[p] = ESPLabels.Health[p] or CreateLabel("Health")
    ESPLabels.Tool[p] = ESPLabels.Tool[p] or CreateLabel("Tool")
end

local function RemovePlayer(p)
    for _, t in pairs(ESPLabels) do if t[p] then t[p]:Destroy() t[p] = nil end end
end

for _, p in ipairs(G.P:GetPlayers()) do AddPlayer(p) end
G.P.PlayerAdded:Connect(AddPlayer)
G.P.PlayerRemoving:Connect(RemovePlayer)

G.R.RenderStepped:Connect(function()
    G.C = G.W.CurrentCamera
    if not G.C then return end
    
    -- Get the current sticky target from silent aim
    local stickyTarget = nil
    if Silent and Silent.Sticky and Silent.Sticky.Enabled and Silent.Sticky.Target then
        stickyTarget = Silent.Sticky.Target
    end
    
    for p, nameLabel in pairs(ESPLabels.Name) do
        local char = p.Character
        local head = char and char:FindFirstChild("Head")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not head or not hum or hum.Health <= 0 then
            for _, t in pairs(ESPLabels) do if t[p] then t[p].Visible = false end end
            continue
        end
        local headTop = head.Position + Vector3.new(0, head.Size.Y / 2, 0)
        local screenPos, onScreen = G.C:WorldToViewportPoint(headTop)
        if not onScreen or screenPos.Z <= 0 then
            for _, t in pairs(ESPLabels) do if t[p] then t[p].Visible = false end end
            continue
        end
        local x, y = screenPos.X, screenPos.Y
        local offset = 8
        local spacing = 15
        
        -- Check if this player is the sticky target
        local isTarget = (stickyTarget == p)
        
        if ESP.Name then
            nameLabel.Text = p.DisplayName
            nameLabel.Position = UDim2.fromOffset(x, y - offset)
            -- ONLY change color, keep size the same
            if isTarget then
                nameLabel.TextColor3 = TargetColor
                nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            else
                nameLabel.TextColor3 = Color3.fromRGB(172,183,212)
                nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            end
            -- KEEP TEXT SIZE THE SAME
            nameLabel.TextSize = 13
            nameLabel.Visible = true
            offset = offset + spacing
        else nameLabel.Visible = false end
        
        if ESP.Distance then
            local dist = math.floor((G.C.CFrame.Position - head.Position).Magnitude)
            ESPLabels.Distance[p].Text = "[" .. dist .. "m]"
            ESPLabels.Distance[p].Position = UDim2.fromOffset(x, y - offset)
            if isTarget then
                ESPLabels.Distance[p].TextColor3 = TargetColor
            else
                ESPLabels.Distance[p].TextColor3 = Color3.fromRGB(172,183,212)
            end
            ESPLabels.Distance[p].Visible = true
            offset = offset + spacing
        else ESPLabels.Distance[p].Visible = false end
        
        if ESP.Health then
            ESPLabels.Health[p].Text = math.floor(hum.Health) .. " HP"
            ESPLabels.Health[p].Position = UDim2.fromOffset(x, y - offset)
            ESPLabels.Health[p].Visible = true
            offset = offset + spacing
        else ESPLabels.Health[p].Visible = false end
        
        if ESP.Tool then
            local tool = nil
            if char then for _, obj in ipairs(char:GetChildren()) do if obj:IsA("Tool") then tool = obj break end end end
            if tool then
                ESPLabels.Tool[p].Text = "[" .. tool.Name .. "]"
                ESPLabels.Tool[p].Position = UDim2.fromOffset(x, y - offset)
                ESPLabels.Tool[p].Visible = true
            else ESPLabels.Tool[p].Visible = false end
        else ESPLabels.Tool[p].Visible = false end
    end
end)

-- ESP Toggles
Sections.WorldLeft:Toggle({Name = "name", Flag = "name_esp", Default = false, Callback = function(v) ESP.Name = v end})
Sections.WorldLeft:Toggle({Name = "distance", Flag = "distance_esp", Default = false, Callback = function(v) ESP.Distance = v end})
Sections.WorldLeft:Toggle({Name = "health", Flag = "health_esp", Default = false, Callback = function(v) ESP.Health = v end})
Sections.WorldLeft:Toggle({Name = "current tool", Flag = "tool_esp", Default = false, Callback = function(v) ESP.Tool = v end})

-- Target Color Picker (with toggle)
local TargetColorToggle = Sections.WorldLeft:Toggle({
    Name = "target color",
    Flag = "target_color_toggle",
    Default = false
})

TargetColorToggle:Colorpicker({
    Flag = "target_color",
    Default = Color3.fromRGB(255, 0, 0),
    Alpha = 0,
    Callback = function(color, alpha)
        TargetColor = color
    end
})
    
    
    local origWorld = {FogStart = G.L.FogStart, FogEnd = G.L.FogEnd, FogColor = G.L.FogColor, Brightness = G.L.Brightness}
    Sections.WorldRight:Toggle({Name = "enable world", Flag = "world_enable", Default = false, Callback = function(v)
        if v then
            G.L.FogStart = 0
            G.L.FogEnd = Library.Flags.fog_distance or 1000
            G.L.FogColor = Library.Flags.fog_color or Color3.fromRGB(255,255,255)
            G.L.Brightness = Library.Flags.world_exposure or 1
        else
            G.L.FogStart = origWorld.FogStart
            G.L.FogEnd = origWorld.FogEnd
            G.L.FogColor = origWorld.FogColor
            G.L.Brightness = origWorld.Brightness
        end
    end})
    Sections.WorldRight:Slider({Name = "fog distance", Flag = "fog_distance", Default = 1000, Min = 0, Max = 10000, Decimals = 1, Callback = function(v) if Library.Flags.world_enable then G.L.FogEnd = v end end})
    local FogColorLabel2 = Sections.WorldRight:Label({Name = "fog color"})
    FogColorLabel2:Colorpicker({Name = "fog color", Flag = "fog_color", Default = Color3.fromRGB(255,255,255), Callback = function(c) if Library.Flags.world_enable then G.L.FogColor = c end end})
    Sections.WorldRight:Slider({Name = "exposure", Flag = "world_exposure", Default = 1, Min = 0, Max = 10, Decimals = 0.01, Callback = function(v) if Library.Flags.world_enable then G.L.Brightness = v end end})
    
   
    local Armor = {Enabled = false, Value = 1, Running = false}
    
    local function GetRemote()
        local r = G.RS:FindFirstChild("MainGameEvent", true) or G.RS:FindFirstChild("GameRemotes", true)
        return r and r:IsA("RemoteEvent") and r or nil
    end
    
    local function GetArmorValue()
        local char = G.LP.Character
        if not char then return 0 end
        local be = char:FindFirstChild("BodyEffects")
        if be then
            local armor = be:FindFirstChild("Armor")
            if armor then return tonumber(armor.Value) or 0 end
        end
        for _, v in ipairs(char:GetDescendants()) do
            if v:IsA("ValueBase") and string.lower(v.Name) == "armor" then return tonumber(v.Value) or 0 end
        end
        return 0
    end
    
    local function SetArmor(v)
        local remote = GetRemote()
        if remote then pcall(function() remote:FireServer("ChangeSettings", "ArmorSave", v) end) end
    end
    
    local function ResetChar()
        local char = G.LP.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum.Health = 0 end
        end
    end
    
    local function ApplyArmor()
        if not Armor.Enabled then return end
        if Armor.Running then return end
        Armor.Running = true
        local current = GetArmorValue()
        if current < 200 then
            local shop = nil
            for _, v in ipairs(G.W:GetDescendants()) do
                if v.Name:lower():find("armor") and v:FindFirstChild("ClickDetector") then shop = v break end
            end
            if shop then
                local cd = shop:FindFirstChildWhichIsA("ClickDetector")
                local part = shop:IsA("BasePart") and shop or shop:FindFirstChildWhichIsA("BasePart")
                if cd and part then
                    local hrp = G.LP.Character and G.LP.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local homeCF = hrp.CFrame
                        hrp.CFrame = part.CFrame * CFrame.new(0, 2.5, 0)
                        task.wait(0.1)
                        pcall(function() cd.MaxActivationDistance = 9e9 fireclickdetector(cd) end)
                        task.wait(0.2)
                        hrp.CFrame = homeCF
                    end
                end
            end
        end
        SetArmor(Armor.Value)
        task.wait(0.1)
        ResetChar()
        Armor.Running = false
    end
    
    
    
    










    
    
     
    local Walk = {Type = "slippery", Speed = 250, Enabled = false, Active = false, Connection = nil}
    
    local function UpdateWalk()
        if Walk.Connection then Walk.Connection:Disconnect() Walk.Connection = nil end
        if not Walk.Enabled or not Walk.Active or Walk.Type ~= "cframe" then return end
        Walk.Connection = G.R.Heartbeat:Connect(function(dt)
            if not Walk.Enabled or not Walk.Active then return end
            local char, hum, hrp = G.LP.Character, nil, nil
            if char then hum = char:FindFirstChildOfClass("Humanoid") hrp = char:FindFirstChild("HumanoidRootPart") end
            if not hum or not hrp then return end
            local moveDir = hum.MoveDirection
            if moveDir.Magnitude > 0 then hrp.CFrame = hrp.CFrame + (moveDir * Walk.Speed * dt) end
        end)
    end
    
    local WalkToggle = Sections.MovementLeft:Toggle({Name = "walk", Flag = "walkspeed", Default = false, Callback = function(v) Walk.Enabled = v UpdateWalk() end})
    WalkToggle:Keybind({Flag = "walkspeed_bind", Mode = "Toggle", Callback = function(s) Walk.Active = s UpdateWalk() end})
    Sections.MovementLeft:Dropdown({Name = "type", Flag = "walkspeed_type", Items = {"slippery", "cframe"}, Default = "slippery", Multi = false, Callback = function(v) Walk.Type = v UpdateWalk() end})
    Sections.MovementLeft:Slider({Name = "speed", Flag = "walkspeed_speed", Default = 250, Min = 0, Max = 2500, Decimals = 0.01, Callback = function(v) Walk.Speed = v end})
    
    G.R.RenderStepped:Connect(function()
        if not Walk.Enabled or not Walk.Active then return end
        local char = G.LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        if Walk.Type == "slippery" then
            hum.WalkSpeed = Walk.Speed + 1
            hum.WalkSpeed = Walk.Speed - 1
            hum.WalkSpeed = Walk.Speed
        end
    end)
    
    
    local Fly = {
        Enabled = false,
        Speed = 50,
        Connection = nil,
        Keys = {
            [Enum.KeyCode.W] = false,
            [Enum.KeyCode.A] = false,
            [Enum.KeyCode.S] = false,
            [Enum.KeyCode.D] = false,
            [Enum.KeyCode.Space] = false,
            [Enum.KeyCode.LeftControl] = false
        }
    }
    
    
    local function UpdateFlyKey(input, state)
        if Fly.Keys[input.KeyCode] ~= nil then
            Fly.Keys[input.KeyCode] = state
        end
    end
    
    G.U.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        UpdateFlyKey(input, true)
    end)
    
    G.U.InputEnded:Connect(function(input)
        UpdateFlyKey(input, false)
    end)
    
    local function StartFly()
        if Fly.Connection then return end
        
        local char = G.LP.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.PlatformStand = true
                hum.AutoRotate = false
                hum:ChangeState(Enum.HumanoidStateType.Freefall)
            end
        end
        
        Fly.Connection = G.R.RenderStepped:Connect(function()
            if not Fly.Enabled then
                StopFly()
                return
            end
            
            local char = G.LP.Character
            if not char then
                StopFly()
                return
            end
            
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then
                StopFly()
                return
            end
            
            local hum = char:FindFirstChildOfClass("Humanoid")
            if not hum then
                StopFly()
                return
            end
            
            hum:ChangeState(Enum.HumanoidStateType.Freefall)
            
            local camCF = G.C.CFrame
            local forward = camCF.LookVector
            local right = camCF.RightVector
            local up = Vector3.new(0, 1, 0)
            
            local moveVec = Vector3.new(0, 0, 0)
            
            if Fly.Keys[Enum.KeyCode.W] then
                moveVec = moveVec + forward
            end
            if Fly.Keys[Enum.KeyCode.S] then
                moveVec = moveVec - forward
            end
            if Fly.Keys[Enum.KeyCode.A] then
                moveVec = moveVec - right
            end
            if Fly.Keys[Enum.KeyCode.D] then
                moveVec = moveVec + right
            end
            if Fly.Keys[Enum.KeyCode.Space] then
                moveVec = moveVec + up
            end
            if Fly.Keys[Enum.KeyCode.LeftControl] then
                moveVec = moveVec - up
            end
            
            if moveVec.Magnitude > 0 then
                moveVec = moveVec.Unit * Fly.Speed
            end
            
            hrp.AssemblyLinearVelocity = moveVec
        end)
        
        
    end
    
    local function StopFly()
        if Fly.Connection then
            Fly.Connection:Disconnect()
            Fly.Connection = nil
        end
        
        local char = G.LP.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.PlatformStand = false
                hum.AutoRotate = true
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
        end
        
    end
    
    
    local FlyToggle = Sections.MovementLeft:Toggle({
        Name = "fly",
        Flag = "fly_toggle",
        Default = false,
        Callback = function(value)
            Fly.Enabled = value
            if value then
                StartFly()
            else
                StopFly()
            end
        end
    })
    
    FlyToggle:Keybind({
        Flag = "fly_keybind",
        Mode = "Toggle",
        Callback = function(state)
            Fly.Enabled = state
            if state then
                StartFly()
            else
                StopFly()
            end
        end
    })
    
    
    Sections.MovementLeft:Slider({
        Name = "fly speed",
        Flag = "fly_speed",
        Default = 50,
        Min = 0,
        Max = 500,
        Decimals = 0.01,
        Callback = function(value)
            Fly.Speed = value
            if Fly.Enabled then
                
            end
        end
    })
    

    local Freeze = {Target = nil, Connection = nil}
    
    local function Unfreeze()
        if Freeze.Target and Freeze.Target.Character then
            local hrp = Freeze.Target.Character:FindFirstChild("HumanoidRootPart")
            if hrp then hrp.Anchored = false end
        end
        Freeze.Target = nil
        if Freeze.Connection then Freeze.Connection:Disconnect() Freeze.Connection = nil end
    end
    
    local function GetClosestPlayerToCrosshair()
        local closest, shortest = nil, math.huge
        local mousePos = G.U:GetMouseLocation()
        for _, p in ipairs(G.P:GetPlayers()) do
            if p ~= G.LP and p.Character then
                local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                if hrp and hum and hum.Health > 0 then
                    local screenPos, onScreen = G.C:WorldToViewportPoint(hrp.Position)
                    if onScreen then
                        local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                        if dist < shortest then shortest, closest = dist, p end
                    end
                end
            end
        end
        return closest
    end
    
    Sections.MovementRight:Toggle({Name = "player freeze", Flag = "player_freeze_toggle", Default = false})
    local FreezeLabel = Sections.MovementRight:Label({Name = "freeze key"})
    FreezeLabel:Keybind({Name = "freeze key", Flag = "player_freeze_keybind", Mode = "Hold", Callback = function(active)
        if not Library.Flags.player_freeze_toggle then return end
        if active then
            local target = GetClosestPlayerToCrosshair()
            if target and target.Character then
                local hrp = target.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    Unfreeze()
                    Freeze.Target = target
                    hrp.Anchored = true
                    Freeze.Connection = target.CharacterRemoving:Connect(Unfreeze)
                end
            end
        else Unfreeze() end
    end})
    
    
    local Handler = G.RS:WaitForChild("MainModule")
    local Module = require(Handler)
    local defaultIgnored = {G.W:WaitForChild("Vehicles"), G.W:WaitForChild("MAP"), G.W:WaitForChild("Ignored")}
    task.spawn(function()
        while not Library or not Library.Flags do task.wait() end
        local last = nil
        while true do
            local current = Library.Flags.rage_wallbang
            if current ~= last then
                last = current
                Module.Ignored = current and defaultIgnored or {}
            end
            task.wait(0.1)
        end
    end)
    
    
    local Bullet = {Enabled = false, Part = "Head", Prediction = 0.1, MaxFov = 150, Target = nil, Teleporting = false, LastTime = 0}
    
    G.R.RenderStepped:Connect(function() Bullet.Enabled = Library.Flags.rage_bullet_tp or false end)
    
    local function GetHand()
        local char = G.LP.Character
        return char and (char:FindFirstChild("RightHand") or char:FindFirstChild("Right Arm"))
    end
    
    local function UpdateBulletTarget()
        local mousePos = G.U:GetMouseLocation()
        local closest, minDist = nil, Bullet.MaxFov
        for _, p in ipairs(G.P:GetPlayers()) do
            if p ~= G.LP and p.Character then
                local part = p.Character:FindFirstChild(Bullet.Part)
                local hum = p.Character:FindFirstChild("Humanoid")
                if part and hum and hum.Health > 0 then
                    local screenPos, onScreen = G.C:WorldToViewportPoint(part.Position)
                    if onScreen then
                        local dist = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(mousePos.X, mousePos.Y)).Magnitude
                        if dist < minDist then minDist, closest = dist, p end
                    end
                end
            end
        end
        Bullet.Target = closest
    end
    
    local function CFrameToOffset(origin, target)
        local adjusted = origin * CFrame.new(0, -1, 0, 1, 0, 0, 0, 0, 1, 0, -1, 0)
        return adjusted:ToObjectSpace(target):inverse()
    end
    
    local function TeleportBullet(tool)
        if not Bullet.Enabled then return end
        local now = tick()
        if Bullet.Teleporting or (now - Bullet.LastTime < 0.2) then return end
        Bullet.Teleporting = true
        Bullet.LastTime = now
        local target, hand = Bullet.Target, GetHand()
        if not (target and hand and target.Character) then Bullet.Teleporting = false return end
        local part = target.Character:FindFirstChild(Bullet.Part)
        if not part then Bullet.Teleporting = false return end
        local predictedPos = part.Position + part.Velocity * Bullet.Prediction
        local offset = CFrameToOffset(hand.CFrame, CFrame.new(predictedPos))
        local originalGrip = tool.Grip
        tool.Grip = offset
        G.R.RenderStepped:Wait()
        tool.Grip = originalGrip
        Bullet.Teleporting = false
    end
    
    local function SetupCharacter(char)
        char.ChildAdded:Connect(function(tool)
            if tool:IsA("Tool") then
                for _, conn in ipairs(getconnections(tool:GetPropertyChangedSignal("Grip"))) do conn:Disable() end
                tool.Activated:Connect(function() TeleportBullet(tool) end)
            end
        end)
    end
    
    task.spawn(function()
        while true do
            if Bullet.Enabled then pcall(UpdateBulletTarget) else Bullet.Target = nil end
            task.wait(0.1)
        end
    end)
    
    if G.LP.Character then SetupCharacter(G.LP.Character) end
    G.LP.CharacterAdded:Connect(SetupCharacter)
    
   
    getgenv().TargetPart = "HumanoidRootPart"
    getgenv().MagicTarget = nil
    
    local function ResetHitbox(p)
        if p and p.Character then
            local part = p.Character:FindFirstChild(getgenv().TargetPart)
            if part then part.Size, part.Transparency, part.CanCollide = Vector3.new(2,2,1), 1, true end
        end
    end
    
    local function EnlargeHitbox(p)
        if p and p.Character then
            local part = p.Character:FindFirstChild(getgenv().TargetPart)
            if part then
                local size = Library.Flags.hitbox_size or 1
                part.Size, part.Transparency, part.CanCollide = Vector3.new(size,size,size), 1, false
            end
        end
    end
    
    local function GetClosestPlayerMagic()
        local closest, shortest = nil, math.huge
        local mousePos = G.U:GetMouseLocation()
        for _, p in ipairs(G.P:GetPlayers()) do
            if p ~= G.LP and p.Character then
                local part = p.Character:FindFirstChild(getgenv().TargetPart)
                local hum = p.Character:FindFirstChild("Humanoid")
                if part and hum and hum.Health > 0 then
                    local screenPos, onScreen = G.C:WorldToViewportPoint(part.Position)
                    if onScreen then
                        local dist = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(mousePos.X, mousePos.Y)).Magnitude
                        if dist < shortest then shortest, closest = dist, p end
                    end
                end
            end
        end
        return closest
    end
    
    task.spawn(function()
        while true do
            task.wait(0.1)
            if Library and Library.Flags.rage_magic_bullet then
                local newTarget = GetClosestPlayerMagic()
                if newTarget ~= getgenv().MagicTarget then
                    ResetHitbox(getgenv().MagicTarget)
                    EnlargeHitbox(newTarget)
                    getgenv().MagicTarget = newTarget
                end
            else
                ResetHitbox(getgenv().MagicTarget)
                getgenv().MagicTarget = nil
            end
        end
    end)
    -- Global flag for Kill All state (accessible everywhere)
-- Global flag for Kill All state (accessible everywhere)
_KillAllEnabled = false

_KA_killAll = nil
do
    local Kill = {Enabled = false, Auto = false, IgnoreFriends = false, Whitelist = {}}
    local KillGuns = {["[Double-Barrel SG]"]=true, ["[Revolver]"]=true, ["[TacticalShotgun]"]=true}
    local Loadout = {"[Double-Barrel SG]","[Revolver]","[TacticalShotgun]","None"}
    local refillActive, RefillGen = false, 0
    local loopConn = nil
    
    local function findRemote(name)
        for _, obj in ipairs(G.RS:GetDescendants()) do
            if obj:IsA("RemoteEvent") and obj.Name:lower():find(name:lower(),1,true) then return obj end
        end
        return nil
    end
    local KillRemote = findRemote("MainGameEvent") or findRemote("MainRemoteEvent")
    local LoadoutRemote = findRemote("Loadout")
    
    -- ============================================
    -- AMMO REFILL SYSTEM
    -- ============================================
    local function requestAmmoRefill(tool, ammo)
        if LoadoutRemote == nil or refillActive or tool == nil or ammo == nil or ammo:GetAttribute("ZeeKillRefillRequested") then return false end
        local char, bp = G.LP.Character, G.LP:FindFirstChild("Backpack")
        if bp == nil then return false end
        if ammo.Value > 3 then return false end
        
        ammo:SetAttribute("ZeeKillRefillRequested", true)
        refillActive = true
        
        local reqName, oldTools, eqTools, newTools, seen = tool.Name, {}, {}, {}, {}
        for _, cont in ipairs({bp,char}) do
            if cont then
                for _, item in ipairs(cont:GetChildren()) do
                    if item:IsA("Tool") and KillGuns[item.Name] then
                        oldTools[item] = true
                        if item.Parent == char then eqTools[item.Name] = true end
                    end
                end
            end
        end
        local conns, stopped, deadline, lastAdd, gen = {}, false, os.clock()+2, os.clock(), RefillGen
        local function stop()
            if stopped then return end
            stopped = true
            for _, c in ipairs(conns) do c:Disconnect() end
            if not newTools[reqName] and ammo.Parent then ammo:SetAttribute("ZeeKillRefillRequested", nil) end
            refillActive = false
        end
        local function accept(item)
            if not item:IsA("Tool") or not KillGuns[item.Name] or oldTools[item] or seen[item] then return end
            seen[item] = true
            lastAdd = os.clock()
            local name = item.Name
            local prev = newTools[name]
            if prev and prev ~= item and prev.Parent then prev:Destroy() end
            newTools[name] = item
            for old in pairs(oldTools) do if old.Name == name and old.Parent then old:Destroy() end end
            if eqTools[name] and char and item.Parent then item.Parent = char end
        end
        conns[1] = bp.ChildAdded:Connect(accept)
        if char then conns[2] = char.ChildAdded:Connect(accept) end
        LoadoutRemote:FireServer(Loadout)
        local heartbeat = G.R.Heartbeat:Connect(function()
            if gen ~= RefillGen then stop() return end
            if os.clock() >= deadline or (next(newTools) and os.clock()-lastAdd >= 0.2) then stop() end
        end)
        return true
    end
    
    -- ============================================
    -- FORCE REFILL FUNCTIONS
    -- ============================================
    local function ForceRefillAllGuns()
        task.spawn(function()
            task.wait(0.3)
            local char = G.LP.Character
            local bp = G.LP:FindFirstChild("Backpack")
            if not char and not bp then return end
            
            local tool = char and char:FindFirstChildOfClass("Tool")
            if tool and tool:FindFirstChild("Ammo") then
                local ammo = tool:FindFirstChild("Ammo")
                if ammo.Value <= 3 and not ammo:GetAttribute("ZeeKillRefillRequested") then
                    requestAmmoRefill(tool, ammo)
                end
            end
            
            if bp then
                for _, item in ipairs(bp:GetChildren()) do
                    if item:IsA("Tool") and KillGuns[item.Name] and item:FindFirstChild("Ammo") then
                        local ammo = item:FindFirstChild("Ammo")
                        if ammo.Value <= 3 and not ammo:GetAttribute("ZeeKillRefillRequested") then
                            requestAmmoRefill(item, ammo)
                        end
                    end
                end
            end
        end)
    end
    
    local function ForceRefillAfterKill()
        task.spawn(function()
            task.wait(0.3)
            local char = G.LP.Character
            local bp = G.LP:FindFirstChild("Backpack")
            if not char and not bp then return end
            
            local tool = char and char:FindFirstChildOfClass("Tool")
            if tool and tool:FindFirstChild("Ammo") then
                local ammo = tool:FindFirstChild("Ammo")
                if ammo.Value <= 3 and not ammo:GetAttribute("ZeeKillRefillRequested") then
                    requestAmmoRefill(tool, ammo)
                end
            end
            
            if bp then
                for _, item in ipairs(bp:GetChildren()) do
                    if item:IsA("Tool") and KillGuns[item.Name] and item:FindFirstChild("Ammo") then
                        local ammo = item:FindFirstChild("Ammo")
                        if ammo.Value <= 3 and not ammo:GetAttribute("ZeeKillRefillRequested") then
                            requestAmmoRefill(item, ammo)
                        end
                    end
                end
            end
        end)
    end
    
    -- ============================================
    -- USABLE AMMO CHECK
    -- ============================================
    local function usableAmmo(tool, ammo)
        if ammo.Value <= 0 then 
            requestAmmoRefill(tool, ammo) 
            return false 
        end
        if not ammo:GetAttribute("ZeeKillAmmoWatching") then
            ammo:SetAttribute("ZeeKillAmmoWatching", true)
            local conn = ammo:GetPropertyChangedSignal("Value"):Connect(function()
                if ammo.Value <= 0 then 
                    conn:Disconnect() 
                    requestAmmoRefill(tool, ammo) 
                end
            end)
        end
        return true
    end
    
    local function getGun(char, bp)
        return bp:FindFirstChild("[TacticalShotgun]") or (char and char:FindFirstChild("[TacticalShotgun]"))
    end
    
    local function shouldSkip(p)
        if Kill.IgnoreFriends then
            local ok, isF = pcall(function() return G.LP:IsFriendsWith(p.UserId) end)
            if ok and isF then return true end
        end
        if Kill.Whitelist and next(Kill.Whitelist) then
            for _, name in ipairs(Kill.Whitelist) do if p.Name == name then return true end end
        end
        return false
    end
    
    -- ============================================
    -- KILL ALL FUNCTION
    -- ============================================
    local function killAll()
        if not Kill.Enabled then return false end
        if type(_SD_IsStimBusy) == "function" and _SD_IsStimBusy() then return false end
        local char, bp = G.LP.Character, G.LP:FindFirstChild("Backpack")
        if char == nil or bp == nil then return false end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local tool = getGun(char, bp)
        local handle = tool and tool:FindFirstChild("Handle")
        local ammo = tool and tool:FindFirstChild("Ammo")
        if KillRemote == nil or hum == nil or tool == nil or handle == nil or ammo == nil then return false end
        if not usableAmmo(tool, ammo) then
            if type(_SD_BusyFor) == "function" then _SD_BusyFor(2) end
            return false
        end
        local pellets, targets = {}, 0
        for _, p in ipairs(G.P:GetPlayers()) do
            if p ~= G.LP and (type(_WL_Allows) ~= "function" or _WL_Allows(p)) and not (type(_BL_IsBlocked) == "function" and _BL_IsBlocked(p)) and not shouldSkip(p) then
                local tc = p.Character
                if tc and tc.Parent then
                    local th = tc:FindFirstChild("Humanoid")
                    local head = tc:FindFirstChild("Head")
                    if th and th.Health > 0 and head then
                        local be, ko = tc:FindFirstChild("BodyEffects"), false
                        if be then
                            local koVal = be:FindFirstChild("K.O")
                            if koVal and koVal.Value == true then ko = true end
                        end
                        if not ko then
                            targets = targets + 1
                            local pos = head.Position
                            for _ = 1, 20 do pellets[#pellets+1] = {AimPosition=pos, Result1=pos, Result2=head, Result3=Vector3.yAxis} end
                        end
                    end
                end
            end
        end
        if #pellets == 0 then return false end
        local rangeObj, dmgObj = tool:FindFirstChild("Range"), tool:FindFirstChild("Damage")
        local range, dmg = rangeObj and rangeObj.Value or 200, dmgObj and dmgObj.Value or 50
        tool.Enabled = true
        if tool.Parent ~= char then tool.Parent = char end
        for _ = 1, 8 do KillRemote:FireServer("ShootGun", handle, handle.Position, pellets, nil, nil, nil, range, dmg) end
        if tool.Parent then tool.Parent = bp end
        
        ForceRefillAfterKill()
        return targets > 0
    end
    
    _KA_killAll = killAll
    
    -- ============================================
    -- AUTO LOOP
    -- ============================================
    local function startAutoLoop()
        if loopConn then return end
        loopConn = G.R.Heartbeat:Connect(function()
            if Kill.Enabled and Kill.Auto then killAll() end
        end)
    end
    
    local function stopAutoLoop()
        if loopConn then loopConn:Disconnect() loopConn = nil end
    end
    
    -- ============================================
    -- DISABLE WEAPON MODS FUNCTION (Uses global flag)
    -- ============================================
    local function disableWeaponMods()
        -- Disable Inf Range
        if InfRangeEnabled then
            InfRangeEnabled = false
            for gun, _ in pairs(PatchedGuns) do
                CleanupGun(gun)
            end
            pcall(function()
                if Sections.WeaponsLeft and Sections.WeaponsLeft.Toggles and Sections.WeaponsLeft.Toggles.inf_range then
                    Sections.WeaponsLeft.Toggles.inf_range:Set(false)
                end
            end)
        end
        
        -- Disable Rapid Fire
        if RapidFireEnabled then
            RapidFireEnabled = false
            for tool, _ in pairs(RapidFireTools) do
                CleanupRapidFire(tool)
            end
            RapidFireTools = {}
            pcall(function()
                if Sections.WeaponsLeft and Sections.WeaponsLeft.Toggles and Sections.WeaponsLeft.Toggles.rapid_fire then
                    Sections.WeaponsLeft.Toggles.rapid_fire:Set(false)
                end
            end)
        end
    end
    
    -- ============================================
    -- MENU
    -- ============================================
    local KillToggle = Sections.RageRight:Toggle({Name = 'kill all', Flag = 'Kill_All', Default = false, Callback = function(v)
        Kill.Enabled = v
        _KillAllEnabled = v  -- UPDATE GLOBAL FLAG
        if v then
            -- DISABLE INF RANGE & RAPID FIRE WHEN KILL ALL IS ENABLED
            disableWeaponMods()
            if Kill.Auto then startAutoLoop() end
        else
            stopAutoLoop()
        end
    end})
    
    Sections.RageRight:Toggle({Name = 'auto kill all', Flag = 'auto_kill_all', Default = false, Callback = function(v)
        Kill.Auto = v
        if v and Kill.Enabled then 
            disableWeaponMods()
            startAutoLoop() 
        elseif not v then 
            stopAutoLoop() 
        end
    end})
    
    KillToggle:Keybind({Flag = 'kill_all_bind', Mode = 'Hold', Callback = function(s)
        if s and Kill.Enabled and type(_KA_killAll) == "function" then 
            _KA_killAll() 
        end
    end})
    
    Sections.RageRight:Toggle({Name = 'ignore friends', Flag = 'ignore_friends', Default = false, Callback = function(v) Kill.IgnoreFriends = v end})
    
            local function getNames()
            local t = {}
            for _, p in ipairs(G.P:GetPlayers()) do
                if p ~= G.LP then table.insert(t, p.Name) end
            end
            return t
        end
        
        local wlDropdown = Sections.RageRight:Dropdown({
            Name = 'whitelist players',
            Flag = 'whitelist_players',
            Items = getNames(),
            Default = {},
            Multi = true,
            Callback = function(v) 
                Kill.Whitelist = v or {} 
            end
        })
        
        -- ============================================
        -- WHITELIST REFRESH - SAME AS SPECTATE
        -- ============================================
        local function refreshWhitelist()
            local names = getNames()
            if type(wlDropdown.Refresh) == "function" then 
                wlDropdown:Refresh(names)
            elseif type(wlDropdown.SetItems) == "function" then 
                wlDropdown:SetItems(names)
            elseif type(wlDropdown.SetValues) == "function" then 
                wlDropdown:SetValues(names)
            end
        end
        
        -- Refresh when players join/leave
        G.P.PlayerAdded:Connect(refreshWhitelist)
        G.P.PlayerRemoving:Connect(refreshWhitelist)
        
        -- Refresh when dropdown button is clicked
        task.defer(function()
            task.wait(0.1)
            local inst = typeof(wlDropdown) == "Instance" and wlDropdown or (type(wlDropdown) == "table" and wlDropdown.Instance)
            if inst then
                for _, d in ipairs(inst:GetDescendants()) do
                    if d:IsA("GuiButton") then
                        d.Activated:Connect(refreshWhitelist)
                        break
                    end
                end
            end
        end)
    end
    
    
    local Spec = {Names = {}, Selected = nil, Active = false, Connection = nil, Dropdown = nil}
    
    local function UpdateSpecNames()
        Spec.Names = {}
        for _, p in ipairs(G.P:GetPlayers()) do if p ~= G.LP then table.insert(Spec.Names, p.Name) end end
        table.sort(Spec.Names)
    end
    
    local function StartSpectate(name)
        local target = G.P:FindFirstChild(name)
        if not target then return false end
        local hum = target.Character and target.Character:FindFirstChildOfClass("Humanoid")
        if not hum then return false end
        G.C.CameraSubject = hum
        if Spec.Connection then Spec.Connection:Disconnect() end
        Spec.Connection = target.CharacterAdded:Connect(function(newChar)
            if not Spec.Active then return end
            local h = newChar:WaitForChild("Humanoid", 5)
            if h then G.C.CameraSubject = h end
        end)
        return true
    end
    
    local function StopSpectate()
        Spec.Active = false
        if Spec.Connection then Spec.Connection:Disconnect() Spec.Connection = nil end
        local char = G.LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then G.C.CameraSubject = hum end
    end
    
    local function RefreshDropdown()
        UpdateSpecNames()
        if not Spec.Dropdown then return end
        for _, m in ipairs({"Refresh", "SetItems", "SetOptions", "UpdateItems", "SetValues"}) do
            if Spec.Dropdown[m] then
                local ok = pcall(function() Spec.Dropdown[m](Spec.Dropdown, Spec.Names) end)
                if ok then break end
            end
        end
    end
    
    UpdateSpecNames()
    Spec.Dropdown = Sections.RageRight:Dropdown({Name = 'player list', Flag = 'spectate_playerlist', Items = Spec.Names, Default = Spec.Names[1] or "", Multi = false, Callback = function(v)
        Spec.Selected = v
        if Spec.Active then StartSpectate(v) end
    end})
    
    task.defer(function()
        task.wait(0.1)
        local inst = typeof(Spec.Dropdown) == "Instance" and Spec.Dropdown or (type(Spec.Dropdown) == "table" and Spec.Dropdown.Instance)
        if inst then
            for _, d in ipairs(inst:GetDescendants()) do
                if d:IsA("GuiButton") then
                    d.Activated:Connect(RefreshDropdown)
                    break
                end
            end
        end
    end)
    
    local specToggle = Sections.RageRight:Toggle({Name = 'spectate', Flag = 'Spectate', Default = false, Callback = function(v)
        Spec.Active = v
        if v then
            local target = Spec.Selected or (Spec.Dropdown.Value ~= "" and Spec.Dropdown.Value) or Spec.Names[1]
            if target and target ~= "" then
                if not StartSpectate(target) then pcall(function() specToggle:Set(false) end) end
            else pcall(function() specToggle:Set(false) end) end
        else StopSpectate() end
    end})
    
    G.P.PlayerAdded:Connect(RefreshDropdown)
    G.P.PlayerRemoving:Connect(function(p)
        local was = Spec.Active and Spec.Selected == p.Name
        RefreshDropdown()
        if was then StopSpectate() pcall(function() specToggle:Set(false) end) end
    end)
    G.LP.CharacterAdded:Connect(function(char)
        if Spec.Active then return end
        local hum = char:WaitForChild("Humanoid", 5)
        if hum then G.C.CameraSubject = hum end
    end)
    
    
    do
        local fpsText = Watermark:Add("FPS: ")
        local dateText = Watermark:Add("")
        local fps, frameCount, elapsed = 0, 0, 0
        Library:Connect(G.R.RenderStepped, function(dt)
            frameCount, elapsed = frameCount + 1, elapsed + dt
            if elapsed >= 1 then
                fps = math.floor(frameCount / elapsed)
                fpsText:SetText("FPS: " .. fps)
                frameCount, elapsed = 0, 0
            end
            dateText:SetText(os.date("%H:%M:%S %d/%m/%Y"))
        end)
    end
    
   
    local time = string.format("%."..G.Decimals.."f", os.clock() - G.Clock)
    Library:Notification("Loaded In "..time, 6, Color3.fromRGB(172,84,255))
    
    Window:Init()
end
end)
