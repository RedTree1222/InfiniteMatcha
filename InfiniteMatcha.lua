spawn(function()
local PlayersReady = false
for Attempt = 1, 120 do
    local Ok, Resolved = pcall(function()
        local Svc = game:GetService("Players")
        return Svc and Svc.LocalPlayer and Svc.LocalPlayer.Name
    end)
    if Ok and Resolved then
        PlayersReady = true
        break
    end
    task.wait(0.5)
end
if not PlayersReady then
    print("InfiniteMatcha: player list never resolved, run the script again")
    return
end
local InfiniteMatchaVersion = "1.0"

local CurrentPlayer = game:GetService("Players").LocalPlayer
local PlayersService = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local WorkspaceService = game:GetService("Workspace")

local ExecutorName = identifyexecutor and identifyexecutor() or "Unknown"
local GameNameValue = getgamename and getgamename() or "Unknown"
local RobloxVersion = getrbxversion and getrbxversion() or "Unknown"
local PlaceIdentifier = game.PlaceId

local ExecutableName = "InfiniteMatcha"
local Prefix = ";"
local Splitter = " "
local BailOut = false

local CommandsTable = {}
local AliasesTable = {}
local HistoryList = {}
local HistoryIndex = 0
local SuggestionsList = {}
local OrigionsTable = {}

local BooleanKeypress = false
local BlockInput = false
local ViewMode = false
local ViewLocked = false
local NoclipLoop = false
local FlyLoop = false
local FlySpeed = 1
local ClickTpKey = nil
local ClickTpActive = false
local ClickAimKey = nil
local ClickAimActive = false
local EspLoop = false
local EspBoxes = false
local EspTracers = false
local EspChams = false
local EspNameTags = false
local EspDistanceTags = false
local EspTeamCheck = false
local EspTargets = {}
local EspPool = {}
local EspPoolSize = 32
local EspPoolBuilt = false
local EspColor = Color3.fromRGB(255, 80, 80)
local EspRenderConnection = nil
local EspCollectorRunning = false
local FullbrightLoop = false
local FovAmount = 70
local InfJumpActive = false
local JumpDebounce = false
local SpinActive = false
local LastTypedCode = nil
local LastTypedTime = 0
local SessionStartTime = tick()
local AimbotRunning = false
local WhitelistTable = {}
local AimbotFovValue = 200
local AimbotToggling = false
local AimbotTarget = nil
local AimbotParts = {"Head", "Torso", "UpperTorso", "HumanoidRootPart", "LowerTorso"}
local AimbotTeamCheck = false
local AimbotVisibleCheck = false
local AimbotSmoothing = 0.15
local HitscanActive = false
local ClickAimActive = false
local AimAssistActive = false
local AimAssistConnection = nil
local ChatSpyActive = false
local ChatSpyLog = {}
local ChatSpyChannel = "All"
local AdminsTable = {}
local BanList = {}
local WeatherTable = {}
local SavesTable = {}
local OriginalLightingTable = {}
local SpectatingPlayer = nil
local OldCamera = nil
local IYrunning = false
local RidePlayerActive = false
local InvisRunning = false
local AntiLagRunning = false
local LowmapActive = false
local LagBackActive = false
local ChatLogActive = false
local ChatLogConnection = nil
local ChatLogs = {}
local TimeCodeActive = false
local VirtualBotsRunning = false
local StackTarget = nil
local UnflyLoop = false
local FastflyLoop = false
local RejoinStressActive = false
local NoZoomActive = false
local NoZoomOldFov = 70
local OldControlActive = false
local GetPrimitivesActive = false
local ClearFreezeServerActive = false
local HideAccountActive = false
local PlayerDetectorActive = false
local DetectorLoop = nil
local ArcaneeActive = false
local IsInfraredActive = false
local NoClipObjectsActive = false
local RightClickTpActive = false
local CframeSpeedActive = false
local CframeSpeedValue = 1
local CframeSpeedConnection = nil
local McShieldActive = false
local MaintenancePartsActive = false
local HighjumpActive = false
local VpnCheckActive = false
local ServerhopLocked = false
local SpawnLocationCache = nil
local ToggleKeyOpen = nil
local ToggleKeyHide = nil

local KeycodeTable = {
    Space = 32,
    Return = 13,
    Backspace = 8,
    Tab = 9,
    Escape = 27,
    Up = 273,
    Down = 274,
    Right = 275,
    Left = 276,
    Home = 278,
    End = 279,
    Insert = 277,
    Delete = 127,
    PageUp = 280,
    PageDown = 281,
    RightShift = 303,
    LeftShift = 304,
    RightControl = 305,
    LeftControl = 306,
    RightAlt = 308,
    LeftAlt = 307,
    Minus = 45,
    Equals = 61,
    LeftBracket = 91,
    RightBracket = 93,
    Semicolon = 59,
    Quote = 39,
    Comma = 44,
    Period = 46,
    Slash = 47,
    Zero = 48,
    One = 49,
    Two = 50,
    Three = 51,
    Four = 52,
    Five = 53,
    Six = 54,
    Seven = 55,
    Eight = 56,
    Nine = 57,
    A = 97,
    B = 98,
    C = 99,
    D = 100,
    E = 101,
    F = 102,
    G = 103,
    H = 104,
    I = 105,
    J = 106,
    K = 107,
    L = 108,
    M = 109,
    N = 110,
    O = 111,
    P = 112,
    Q = 113,
    R = 114,
    S = 115,
    T = 116,
    U = 117,
    V = 118,
    W = 119,
    X = 120,
    Y = 121,
    Z = 122,
    F1 = 282,
    F2 = 283,
    F3 = 284,
    F4 = 285,
    F5 = 286,
    F6 = 287,
    F7 = 288,
    F8 = 289,
    F9 = 290,
    F10 = 291,
    F11 = 292,
    F12 = 293
}

ToggleKeyOpen = KeycodeTable.RightShift

local function ToKeyCode(Name)
    local Direct = KeycodeTable[Name]
    if Direct then
        return Direct
    end
    local EnumEntry = Enum.KeyCode[Name]
    if EnumEntry then
        return EnumEntry.Value
    end
    local Ascii = string.byte(string.upper(Name))
    if Ascii and Ascii >= 32 and Ascii <= 126 then
        return Ascii
    end
    return nil
end

local function VectorRound(Vector)
    return Vector3.new(math.floor(Vector.X + 0.5), math.floor(Vector.Y + 0.5), math.floor(Vector.Z + 0.5))
end

local function IsTeamMate(Player)
    local MyTeam = CurrentPlayer.Team
    local TheirTeam = Player.Team
    if MyTeam and TheirTeam then
        return MyTeam == TheirTeam
    end
    return false
end

local function GetCharacter(Player)
    local Target = Player or CurrentPlayer
    if not Target then
        return nil
    end
    local Success, Character = pcall(function()
        return Target.Character
    end)
    if Success and Character then
        return Character
    end
    return nil
end

local function GetRootPart(Player)
    local Character = GetCharacter(Player)
    if not Character then
        return nil
    end
    local Root = Character:FindFirstChild("HumanoidRootPart")
    if Root then
        return Root
    end
    return Character:FindFirstChild("Torso") or Character:FindFirstChild("UpperTorso")
end

local function GetHumanoid(Player)
    local Character = GetCharacter(Player)
    if not Character then
        return nil
    end
    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    if Humanoid then
        return Humanoid
    end
    return nil
end

local function Alive(Player)
    local Humanoid = GetHumanoid(Player)
    if Humanoid and Humanoid.Health and Humanoid.MaxHealth then
        return Humanoid.Health > 0 and Humanoid.MaxHealth > 0
    end
    return false
end

local function GetCharacterPosition(Player)
    local Root = GetRootPart(Player)
    if Root then
        local Success, Position = pcall(function()
            return Root.Position
        end)
        if Success and Position then
            return Position
        end
    end
    return nil
end

local function PlayerExists(Player)
    if not Player then
        return false
    end
    for _, Listed in pairs(PlayersService:GetPlayers()) do
        if Listed.Name == Player.Name then
            return true
        end
    end
    return false
end

local function Notify(Title, Message, Duration)
    local SafeTitle = tostring(Title or "")
    local SafeMessage = tostring(Message or "")
    local SafeDuration = tonumber(Duration) or 5
    local Success, ErrorValue = pcall(function()
        notify(SafeTitle, SafeMessage, SafeDuration)
    end)
    if not Success then
        print(SafeTitle .. ": " .. SafeMessage)
    end
end

local function CommandError(Message)
    Notify(ExecutableName, tostring(Message), 5)
end

local function IsAdmin(Player)
    for _, AdminName in pairs(AdminsTable) do
        if AdminName == Player.Name then
            return true
        end
    end
    return false
end

local function ShouldIgnore(Player)
    if EspTeamCheck and IsTeamMate(Player) then
        return true
    end
    return false
end

local function IsValidCharacter(Player)
    local Character = GetCharacter(Player)
    if not Character then
        return false
    end
    if not GetRootPart(Player) then
        return false
    end
    if not Alive(Player) then
        return false
    end
    return true
end

local function FindInTable(Table, Value)
    for Index, Entry in pairs(Table) do
        if Entry == Value then
            return Index
        end
    end
    return nil
end

local function DeepCopy(Source)
    local Copy = {}
    for Key, Value in pairs(Source) do
        if type(Value) == "table" then
            Copy[Key] = DeepCopy(Value)
        else
            Copy[Key] = Value
        end
    end
    return Copy
end

local function TrimText(Text)
    Text = tostring(Text or "")
    Text = string.gsub(Text, "^%s+", "")
    Text = string.gsub(Text, "%s+$", "")
    return Text
end

local function SplitArguments(Text)
    local Result = {}
    local Pattern = "%S+"
    for Word in string.gmatch(Text, Pattern) do
        table.insert(Result, Word)
    end
    return Result
end

local function GetPlayerNames()
    local Names = {}
    for _, Player in pairs(PlayersService:GetPlayers()) do
        table.insert(Names, Player.Name)
    end
    return Names
end

local function GetPlayerFromPartial(Search)
    local Matches = FindPlayer(Search)
    if #Matches == 1 then
        return Matches[1]
    end
    return nil
end

function FindPlayer(Search)
    local Returned = {}
    if not Search then
        return Returned
    end
    Search = string.lower(tostring(Search))
    if string.sub(Search, 1, 1) == "@" then
        Search = string.sub(Search, 2)
        for _, Player in pairs(PlayersService:GetPlayers()) do
            if string.sub(string.lower(Player.Name), 1, string.len(Search)) == Search then
                table.insert(Returned, Player)
            end
        end
    else
        for _, Player in pairs(PlayersService:GetPlayers()) do
            local NameMatch = string.find(string.lower(Player.Name), Search, 1, true)
            local DisplayName = nil
            pcall(function()
                DisplayName = Player.DisplayName
            end)
            local DisplayMatch = false
            if DisplayName then
                DisplayMatch = string.find(string.lower(DisplayName), Search, 1, true)
            end
            if NameMatch or DisplayMatch then
                table.insert(Returned, Player)
            end
        end
    end
    return Returned
end
local function GetProperty(Object, PropertyName)
    local Success, Value = pcall(function()
        return Object[PropertyName]
    end)
    if Success then
        return Value
    end
    return nil
end

local function SetProperty(Object, PropertyName, Value)
    local Success, ErrorValue = pcall(function()
        Object[PropertyName] = Value
    end)
    return Success, ErrorValue
end

local function WorldToScreenPosition(WorldPosition)
    if type(WorldToScreen) ~= "function" then
        return nil, false
    end
    local Success, ScreenPoint, OnScreen = pcall(function()
        return WorldToScreen(WorldPosition)
    end)
    if Success then
        return ScreenPoint, OnScreen
    end
    return nil, false
end

local function GetCameraField(PropertyName)
    local Camera = WorkspaceService.CurrentCamera
    if not Camera then
        return nil
    end
    return GetProperty(Camera, PropertyName)
end

local function MakeDrawing(DrawingType)
    local Success, Object = pcall(function()
        return Drawing.new(DrawingType)
    end)
    if Success then
        return Object
    end
    return nil
end

local function RemoveDrawingSafe(Object)
    if Object then
        pcall(function()
            Object:Remove()
        end)
    end
end

local DrawingFactory = {}
DrawingFactory.Order = 0

function DrawingFactory.Next()
    DrawingFactory.Order = DrawingFactory.Order + 1
    return DrawingFactory.Order
end

function DrawingFactory.Text(Position)
    local TextObject = MakeDrawing("Text")
    if not TextObject then
        return nil
    end
    TextObject.Size = 13
    TextObject.Center = false
    TextObject.Outline = true
    TextObject.Color = Color3.fromRGB(255, 255, 255)
    TextObject.Visible = false
    pcall(function()
        TextObject.ZIndex = DrawingFactory.Next()
    end)
    if Position then
        TextObject.Position = Position
    end
    return TextObject
end

function DrawingFactory.Square(Position, Size)
    local SquareObject = MakeDrawing("Square")
    if not SquareObject then
        return nil
    end
    SquareObject.Thickness = 1
    SquareObject.Filled = false
    SquareObject.Color = Color3.fromRGB(255, 255, 255)
    SquareObject.Visible = false
    pcall(function()
        SquareObject.ZIndex = DrawingFactory.Next()
    end)
    if Position then
        SquareObject.Position = Position
    end
    if Size then
        SquareObject.Size = Size
    end
    return SquareObject
end

function DrawingFactory.Line(From, To)
    local LineObject = MakeDrawing("Line")
    if not LineObject then
        return nil
    end
    LineObject.Thickness = 1
    LineObject.Color = Color3.fromRGB(255, 255, 255)
    LineObject.Visible = false
    pcall(function()
        LineObject.ZIndex = DrawingFactory.Next()
    end)
    if From then
        LineObject.From = From
    end
    if To then
        LineObject.To = To
    end
    return LineObject
end

local CommandWindow = nil

function NewDrawingWindow(Position, Size, Text)
    local Window = {}
    Window.Visible = false
    Window.Dragging = false
    Window.DragStart = nil
    Window.Background = DrawingFactory.Square(Position, Size)
    Window.Header = DrawingFactory.Square(Position, Vector2.new(Size.X, 18))
    Window.Label = DrawingFactory.Text(Position + Vector2.new(4, 3))
    Window.Label.Text = Text
    Window.Label.Size = 13
    Window.Objects = {}
    function Window.Show()
        Window.Visible = true
    end
    function Window.Hide()
        Window.Visible = false
        Window.Background.Visible = false
        Window.Header.Visible = false
        Window.Label.Visible = false
        for _, Entry in pairs(Window.Objects) do
            if Entry.Hide then
                Entry.Hide()
            end
        end
    end
    function Window.Remove()
        for _, Entry in pairs(Window.Objects) do
            if Entry.Remove then
                Entry.Remove()
            end
        end
        RemoveDrawingSafe(Window.Background)
        RemoveDrawingSafe(Window.Header)
        RemoveDrawingSafe(Window.Label)
    end
    function Window.Frame()
        if not Window.Visible then
            return
        end
        local VisibleFlag = Window.Visible and CommandWindow ~= nil
        pcall(function()
            Window.Background.Position = Window.Position
            Window.Background.Size = Window.Size
            Window.Header.Position = Window.Position
            Window.Header.Size = Vector2.new(Window.Size.X, 18)
            Window.Header.Color = Color3.fromRGB(30, 30, 30)
            Window.Background.Color = Color3.fromRGB(15, 15, 15)
            Window.Background.Transparency = 0.15
            Window.Header.Transparency = 0.05
            Window.Label.Text = Window.Text
            Window.Label.Position = Window.Position + Vector2.new(6, 3)
            Window.Label.Color = Color3.fromRGB(255, 255, 255)
            Window.Background.Visible = VisibleFlag
            Window.Header.Visible = VisibleFlag
            Window.Label.Visible = VisibleFlag
        end)
        for _, Entry in pairs(Window.Objects) do
            if Entry.Frame then
                Entry.Frame()
            end
        end
    end
    return Window
end

function NewDrawingTextbox(Position, Size, PlaceHolder, IsCommand)
    local Box = {}
    Box.Visible = false
    Box.Focused = false
    Box.Text = ""
    Box.Cursor = 0
    Box.Position = Position
    Box.Size = Size
    Box.PlaceHolder = PlaceHolder
    Box.IsCommand = IsCommand and true or false
    Box.Background = DrawingFactory.Square(Position, Size)
    Box.Label = DrawingFactory.Text(Position + Vector2.new(4, 3))
    function Box.Show()
        Box.Visible = true
    end
    function Box.Hide()
        Box.Visible = false
        Box.Focused = false
        Box.Background.Visible = false
        Box.Label.Visible = false
    end
    function Box.Remove()
        RemoveDrawingSafe(Box.Background)
        RemoveDrawingSafe(Box.Label)
    end
    function Box.SetText(NewText)
        Box.Text = tostring(NewText or "")
        Box.Cursor = string.len(Box.Text)
    end
    function Box.GetValue()
        return Box.Text
    end
    function Box.HandleCharacter(CharacterValue)
        if CharacterValue == nil then
            return
        end
        local Before = string.sub(Box.Text, 1, Box.Cursor)
        local After = string.sub(Box.Text, Box.Cursor + 1)
        if CharacterValue == "\b" then
            if Box.Cursor > 0 then
                Box.Text = string.sub(Before, 1, string.len(Before) - 1) .. After
                Box.Cursor = Box.Cursor - 1
            end
        elseif CharacterValue == "\r" or CharacterValue == "\n" then
            if Box.IsCommand then
                local Submitted = Box.Text
                Box:SetText("")
                CommandSubmitted(Submitted)
            end
        else
            Box.Text = Before .. CharacterValue .. After
            Box.Cursor = Box.Cursor + string.len(CharacterValue)
        end
    end
    function Box.HandleSpecial(KeyCodeNumber)
        if KeyCodeNumber == KeycodeTable.Backspace then
            Box.HandleCharacter("\b")
        elseif KeyCodeNumber == KeycodeTable.Return then
            Box.HandleCharacter("\r")
        elseif KeyCodeNumber == KeycodeTable.Up then
            if Box.IsCommand then
                RecallHistory(-1, Box)
            end
        elseif KeyCodeNumber == KeycodeTable.Down then
            if Box.IsCommand then
                RecallHistory(1, Box)
            end
        elseif KeyCodeNumber == KeycodeTable.Tab then
            if Box.IsCommand then
                AutocompleteCommand(Box)
            end
        end
    end
    function Box.Frame()
        if not Box.Visible then
            return
        end
        pcall(function()
            Box.Background.Position = Box.Position
            Box.Background.Size = Box.Size
            Box.Background.Color = Box.Focused and Color3.fromRGB(40, 40, 40) or Color3.fromRGB(25, 25, 25)
            Box.Background.Transparency = 0.1
            Box.Background.Visible = true
            local Shown = Box.Text
            if string.len(Shown) == 0 then
                Box.Label.Text = Box.PlaceHolder
                Box.Label.Color = Color3.fromRGB(120, 120, 120)
            else
                Box.Label.Text = Shown
                Box.Label.Color = Color3.fromRGB(255, 255, 255)
            end
            Box.Label.Position = Box.Position + Vector2.new(5, 3)
            Box.Label.Visible = true
        end)
    end
    return Box
end

function NewDrawingList(Position, Size)
    local List = {}
    List.Visible = false
    List.Entries = {}
    List.ScrollOffset = 0
    List.LineHeight = 14
    List.Position = Position
    List.Size = Size
    List.Objects = {}
    List.Background = DrawingFactory.Square(Position, Size)
    List.MaxObjects = math.floor(Size.Y / List.LineHeight)
    function List.Show()
        List.Visible = true
    end
    function List.Hide()
        List.Visible = false
        List.Background.Visible = false
        for _, TextObject in pairs(List.Objects) do
            TextObject.Visible = false
        end
    end
    function List.Remove()
        List:Hide()
        RemoveDrawingSafe(List.Background)
        for _, TextObject in pairs(List.Objects) do
            RemoveDrawingSafe(TextObject)
        end
    end
    function List.SetEntries(NewEntries)
        List.Entries = NewEntries
        List.ScrollOffset = 0
    end
    function List.EnsureObjects()
        while #List.Objects < List.MaxObjects do
            local TextObject = DrawingFactory.Text(nil)
            table.insert(List.Objects, TextObject)
        end
    end
    function List.Frame()
        if not List.Visible then
            return
        end
        List:EnsureObjects()
        pcall(function()
            List.Background.Position = List.Position
            List.Background.Size = List.Size
            List.Background.Color = Color3.fromRGB(15, 15, 15)
            List.Background.Transparency = 0.2
            List.Background.Visible = true
        end)
        local StartIndex = List.ScrollOffset + 1
        for Slot = 1, List.MaxObjects do
            local TextObject = List.Objects[Slot]
            local EntryIndex = StartIndex + Slot - 1
            local EntryText = List.Entries[EntryIndex]
            if EntryText then
                pcall(function()
                    TextObject.Text = EntryText
                    TextObject.Size = 13
                    TextObject.Color = Color3.fromRGB(220, 220, 220)
                    TextObject.Position = List.Position + Vector2.new(5, (Slot - 1) * List.LineHeight + 3)
                    TextObject.Visible = true
                end)
            else
                TextObject.Visible = false
            end
        end
    end
    return List
end

function NewDrawingScroller(Window, RelX, RelY, SizeX, Rows)
    local Scroller = {}
    Scroller.Window = Window
    Scroller.RelativeX = RelX
    Scroller.RelativeY = RelY
    Scroller.SizeX = SizeX
    Scroller.Rows = Rows
    Scroller.Options = {}
    Scroller.Selected = 1
    Scroller.Scroll = 0
    Scroller.RowHeight = 14
    Scroller.Objects = {}
    function Scroller.SetOptions(NewOptions)
        Scroller.Options = NewOptions
        if Scroller.Selected > #NewOptions then
            Scroller.Selected = #NewOptions
        end
    end
    function Scroller.GetSelected()
        return Scroller.Options[Scroller.Selected]
    end
    function Scroller.EnsureObjects()
        while #Scroller.Objects < Scroller.Rows do
            local TextObject = DrawingFactory.Text(nil)
            table.insert(Scroller.Objects, TextObject)
        end
    end
    function Scroller.Frame()
        Scroller:EnsureObjects()
        local BaseX = Window.Position.X + Scroller.RelativeX
        local BaseY = Window.Position.Y + Scroller.RelativeY
        for Row = 1, Scroller.Rows do
            local OptionIndex = Scroller.Scroll + Row
            local OptionText = Scroller.Options[OptionIndex]
            local TextObject = Scroller.Objects[Row]
            if OptionText then
                pcall(function()
                    TextObject.Text = (OptionIndex == Scroller.Selected and "> " or "  ") .. OptionText
                    TextObject.Size = 13
                    if OptionIndex == Scroller.Selected then
                        TextObject.Color = Color3.fromRGB(120, 200, 120)
                    else
                        TextObject.Color = Color3.fromRGB(180, 180, 180)
                    end
                    TextObject.Position = Vector2.new(BaseX, BaseY + (Row - 1) * Scroller.RowHeight)
                    TextObject.Visible = Window.Visible
                end)
            else
                TextObject.Visible = false
            end
        end
    end
    return Scroller
end
local function BuildCommandWindow()
    local Window = NewDrawingWindow(Vector2.new(12, 12), Vector2.new(520, 200), ExecutableName .. " " .. InfiniteMatchaVersion .. "  |  " .. ExecutorName .. "  |  prefix " .. Prefix)
    local InputBox = NewDrawingTextbox(Vector2.new(12, 40), Vector2.new(520, 20), "press " .. Prefix .. " to open, type a command, Tab completes", true)
    local SuggestionList = NewDrawingList(Vector2.new(12, 64), Vector2.new(520, 144))
    Window.InputBox = InputBox
    Window.SuggestionList = SuggestionList
    Window.Objects = {InputBox, SuggestionList}
    function Window.Toggle()
        if Window.Visible then
            Window.Hide()
            InputBox.Hide()
            SuggestionList.Hide()
        else
            Window.Show()
            InputBox.Show()
            SuggestionList.Show()
            InputBox.Focused = true
        end
    end
    CommandWindow = Window
    return Window
end

local HintBar = nil
local HintText = nil

function ShowHintBar(Text)
    if not HintBar then
        HintBar = DrawingFactory.Square(Vector2.new(0, 0), Vector2.new(600, 18))
        HintText = DrawingFactory.Text(Vector2.new(4, 2))
        HintText.Size = 13
    end
    HintBar.Visible = true
    HintText.Visible = true
    HintText.Text = tostring(Text or "")
end

function HideHintBar()
    if HintBar then
        HintBar.Visible = false
        HintText.Visible = false
    end
end

local function UpdateSuggestions(Text)
    if not CommandWindow then
        return
    end
    SuggestionsList = {}
    local BodyOnly = Text
    if string.sub(BodyOnly, 1, 1) == Prefix then
        BodyOnly = string.sub(BodyOnly, 2)
    end
    if string.len(BodyOnly) > 0 then
        local LowerText = string.lower(BodyOnly)
        for CommandName, CommandEntry in pairs(CommandsTable) do
            if string.sub(CommandName, 1, string.len(LowerText)) == LowerText then
                table.insert(SuggestionsList, Prefix .. CommandName .. "  " .. (CommandEntry.Arguments or ""))
            end
        end
    end
    table.sort(SuggestionsList)
    if #SuggestionsList > 8 then
        local Trimmed = {}
        for Index = 1, 8 do
            Trimmed[Index] = SuggestionsList[Index]
        end
        SuggestionsList = Trimmed
    end
    CommandWindow.SuggestionList.SetEntries(SuggestionsList)
end

local function RecallHistoryLocal(Direction)
    if Direction == -1 then
        if HistoryIndex == 0 then
            HistoryIndex = #HistoryList + 1
        end
        if HistoryIndex > 1 then
            HistoryIndex = HistoryIndex - 1
        end
    else
        if HistoryIndex < #HistoryList then
            HistoryIndex = HistoryIndex + 1
        elseif HistoryIndex == #HistoryList then
            HistoryIndex = 0
            return ""
        end
    end
    return HistoryList[HistoryIndex] or ""
end

RecallHistory = RecallHistoryLocal

local function AutocompleteLocal(Box)
    local Text = Box.GetValue()
    if string.sub(Text, 1, 1) == Prefix then
        Text = string.sub(Text, 2)
    end
    local LowerText = string.lower(Text)
    local Best = nil
    for CommandName in pairs(CommandsTable) do
        if string.sub(CommandName, 1, string.len(LowerText)) == LowerText then
            if Best == nil or string.len(CommandName) < string.len(Best) then
                Best = CommandName
            end
        end
    end
    if Best then
        Box.SetText(Prefix .. Best .. " ")
    end
end

AutocompleteCommand = AutocompleteLocal

function CommandSubmitted(RawText)
    RawText = TrimText(RawText)
    if string.len(RawText) == 0 then
        return
    end
    table.insert(HistoryList, RawText)
    HistoryIndex = 0
    if CommandWindow and CommandWindow.InputBox then
        CommandWindow.InputBox.SetText("")
    end
    UpdateSuggestions("")
    local Body = RawText
    if string.sub(Body, 1, 1) == Prefix then
        Body = string.sub(Body, 2)
    end
    local Parts = SplitArguments(Body)
    if #Parts == 0 then
        return
    end
    local CommandWord = string.lower(Parts[1])
    local CommandEntry = CommandsTable[CommandWord]
    if not CommandEntry then
        for Aliased, Real in pairs(AliasesTable) do
            if Aliased == CommandWord and CommandsTable[Real] then
                CommandEntry = CommandsTable[Real]
                CommandWord = Real
                break
            end
        end
    end
    if not CommandEntry then
        local Matched = false
        for AliasWord, AliasTarget in pairs(AliasesTable) do
            local TargetEntry = CommandsTable[AliasTarget]
            if TargetEntry then
                for _, AliasName in pairs(TargetEntry.Aliases) do
                    if string.lower(AliasName) == CommandWord then
                        CommandEntry = TargetEntry
                        CommandWord = AliasTarget
                        Matched = true
                        break
                    end
                end
            end
            if Matched then
                break
            end
        end
    end
    if not CommandEntry then
        CommandError("unknown command: " .. CommandWord)
        return
    end
    local Arguments = {}
    for Index = 2, #Parts do
        table.insert(Arguments, Parts[Index])
    end
    local Ok, ErrorValue = pcall(CommandEntry.Function, unpack(Arguments))
    if not Ok then
        CommandError("error in " .. CommandWord .. ": " .. tostring(ErrorValue))
    end
end

local function RenderFrame()
    if CommandWindow then
        CommandWindow.Frame()
        if CommandWindow.Visible then
            CommandWindow.InputBox.Frame()
            CommandWindow.SuggestionList.Frame()
        end
    end
    if HintBar and HintBar.Visible then
        local Camera = WorkspaceService.CurrentCamera
        if Camera then
            local Viewport = GetProperty(Camera, "ViewportSize")
            if Viewport then
                HintBar.Position = Vector2.new(Viewport.X * 0.5 - 300, Viewport.Y - 60)
                HintText.Position = HintBar.Position + Vector2.new(6, 2)
            end
        end
        HintBar.Color = Color3.fromRGB(20, 20, 20)
        HintBar.Transparency = 0.2
        HintText.Color = Color3.fromRGB(255, 255, 255)
    end
end

RenderConnection = RunService.RenderStepped:Connect(function()
    local Ok, ErrorValue = pcall(RenderFrame)
    if not Ok then
        print("render error: " .. tostring(ErrorValue))
    end
end)

InputConnection = UserInputService.InputBegan:Connect(function(InputTable)
    local Ok, ErrorValue = pcall(function()
        local KeyCode = InputTable.KeyCode
        if BlockInput and KeyCode ~= KeycodeTable.RightShift and KeyCode ~= KeycodeTable.Escape then
            return
        end
        if CommandWindow and CommandWindow.Visible and CommandWindow.InputBox.Focused then
            if KeyCode == KeycodeTable.Escape then
                CommandWindow.InputBox.Focused = false
                return
            end
            CommandWindow.InputBox.HandleSpecial(KeyCode)
            return
        end
        if ToggleKeyOpen and KeyCode == ToggleKeyOpen then
            if CommandWindow then
                CommandWindow.Toggle()
            end
            return
        end
        if ToggleKeyHide and KeyCode == ToggleKeyHide then
            if CommandWindow and CommandWindow.Visible then
                CommandWindow.Hide()
                CommandWindow.InputBox.Hide()
                CommandWindow.SuggestionList.Hide()
            end
            return
        end
        if ClickTpKey and KeyCode == ClickTpKey and ClickTpActive then
            ClickTpRun()
            return
        end
        if ClickAimKey and KeyCode == ClickAimKey and ClickAimActive then
            ClickAimRun()
            return
        end
    end)
    if not Ok then
        print("input error: " .. tostring(ErrorValue))
    end
end)

local function PollKeyboard()
    task.spawn(function()
        while not BailOut do
            local Ok, ErrorValue = pcall(function()
                if CommandWindow and CommandWindow.Visible and CommandWindow.InputBox.Focused then
                    local Text = CommandWindow.InputBox.GetValue()
                    for Code = 32, 126 do
                        if iskeypressed(Code) then
                            local CharacterValue = string.char(Code)
                            if Code == KeycodeTable.Space then
                                CharacterValue = " "
                            end
                            if LastTypedCode ~= Code or tick() - LastTypedTime > 0.35 then
                                LastTypedCode = Code
                                LastTypedTime = tick()
                                if string.len(CharacterValue) > 0 then
                                    CommandWindow.InputBox.HandleCharacter(CharacterValue)
                                    UpdateSuggestions(CommandWindow.InputBox.GetValue())
                                end
                            end
                        end
                    end
                end
            end)
            if not Ok then
                print("keyboard error: " .. tostring(ErrorValue))
                task.wait(1)
            else
                task.wait(0.03)
            end
        end
    end)
end

local Commands = {}

function Commands.Cmd(Name, Arguments, Description, FunctionRef, Category)
    CommandsTable[string.lower(Name)] = {
        Name = string.lower(Name),
        Arguments = Arguments or "",
        Description = Description or "",
        Function = FunctionRef,
        Aliases = {},
        Category = Category or "Main"
    }
end

function Commands.AddAlias(CommandName, AliasName)
    local Entry = CommandsTable[string.lower(CommandName)]
    if Entry then
        table.insert(Entry.Aliases, AliasName)
    end
end

function Commands.List()
    local Ordered = {}
    for Name in pairs(CommandsTable) do
        table.insert(Ordered, Name)
    end
    table.sort(Ordered)
    return Ordered
end

local function PlayerCommandNames()
    local Names = {}
    for _, Player in pairs(PlayersService:GetPlayers()) do
        table.insert(Names, Player.Name)
    end
    table.sort(Names)
    return table.concat(Names, ", ")
end

local function WorldRoot()
    return WorkspaceService
end

local function CharacterSelf()
    return GetCharacter(CurrentPlayer)
end

local function SelfRoot()
    return GetRootPart(CurrentPlayer)
end

local function SelfHumanoid()
    return GetHumanoid(CurrentPlayer)
end

local function TeleportSelf(Position)
    local Root = SelfRoot()
    if Root then
        pcall(function()
            Root.CFrame = CFrame.new(Position)
        end)
    end
end

Commands.Cmd("console", "", "prints command list to F9", function()
    local Ordered = Commands.List()
    print("== " .. ExecutableName .. " " .. InfiniteMatchaVersion .. " ==")
    for _, Name in pairs(Ordered) do
        local Entry = CommandsTable[Name]
        print(Prefix .. Name .. " " .. Entry.Arguments .. " - " .. Entry.Description)
    end
end, "Main")

Commands.Cmd("cmds", "", "shows a scrolling hint bar with every command", function()
    local Ordered = Commands.List()
    local Lines = {}
    for _, Name in pairs(Ordered) do
        local Entry = CommandsTable[Name]
        table.insert(Lines, Prefix .. Name .. " " .. Entry.Arguments .. " | " .. Entry.Description)
    end
    ShowHintBar(table.concat(Lines, "   //   "))
end, "Main")

Commands.Cmd("hidehint", "", "hides the hint bar", function()
    HideHintBar()
end, "Main")

Commands.Cmd("players", "", "lists player names", function()
    Notify(ExecutableName, PlayerCommandNames(), 8)
end, "Main")

Commands.Cmd("re", "", "respawn your character the only way this vm allows", function()
    local Humanoid = SelfHumanoid()
    if Humanoid then
        pcall(function()
            Humanoid.Health = 0
        end)
    end
    local Root = SelfRoot()
    if Root then
        pcall(function()
            Root.CFrame = Root.CFrame + Vector3.new(0, 3, 0)
        end)
    end
    Notify(ExecutableName, "re executed (health zero or nudge, depends on the game)", 4)
end, "Main")

Commands.Cmd("unre", "", "stop the respawn routine", function()
    Notify(ExecutableName, "nothing to undo", 4)
end, "Main")

Commands.Cmd("rejoin", "", "rejoin this server", function()
    Notify(ExecutableName, "attempting rejoin", 4)
    TeleportToPlaceId(PlaceIdentifier, game.JobId)
end, "Main")

Commands.Cmd("exit", "", "unloads InfiniteMatcha and restores everything", function()
    DoUnload()
end, "Main")

Commands.Cmd("gotomemory", "", "teleports you to the base address readout position", function()
    local Base = getbase and getbase() or 0
    Notify(ExecutableName, "base address: " .. tostring(Base), 5)
end, "Main")

Commands.Cmd("uptime", "", "how long the session has been alive", function()
    Notify(ExecutableName, "session uptime: " .. string.format("%.0f", tick() - SessionStartTime) .. "s", 5)
end, "Main")
local function ApplySpeedMultiplier(Multiplier)
    local Applied = 0
    local Ok, Hits = pcall(function()
        return getgc("WalkSpeed")
    end)
    if Ok and Hits then
        for _, Hit in pairs(Hits) do
            if Hit.type == "number" and Hit.value and Hit.value >= 16 and Hit.value <= 200 then
                pcall(function()
                    setgc(Hit.key, Hit.value * Multiplier, Hit.value)
                end)
                Applied = Applied + 1
            end
        end
    end
    return Applied
end

local function ResetSpeed()
    local Reset = 0
    local Ok, Hits = pcall(function()
        return getgc("WalkSpeed")
    end)
    if Ok and Hits then
        for _, Hit in pairs(Hits) do
            if Hit.type == "number" and Hit.value and Hit.value > 200 then
                pcall(function()
                    setgc(Hit.key, 16, Hit.value)
                end)
                Reset = Reset + 1
            end
        end
    end
    return Reset
end

local function RunNoclipLoop()
    if NoclipLoop then
        return
    end
    NoclipLoop = true
    task.spawn(function()
        while NoclipLoop and not BailOut do
            local Character = GetCharacter(CurrentPlayer)
            if Character then
                for _, Part in pairs(Character:GetChildren()) do
                    if Part.ClassName == "Part" or Part.ClassName == "MeshPart" or Part.ClassName == "UnionOperation" then
                        pcall(function()
                            Part.CanCollide = false
                        end)
                    end
                end
            end
            task.wait(0.1)
        end
    end)
end

local function StopNoclipLoop()
    NoclipLoop = false
    local Character = GetCharacter(CurrentPlayer)
    if Character then
        for _, Part in pairs(Character:GetChildren()) do
            if Part.ClassName == "Part" or Part.ClassName == "MeshPart" or Part.ClassName == "UnionOperation" then
                pcall(function()
                    Part.CanCollide = true
                end)
            end
        end
    end
end

local function RunFlyLoop()
    if FlyLoop then
        return
    end
    FlyLoop = true
    task.spawn(function()
        while FlyLoop and not BailOut do
            local Root = SelfRoot()
            if Root then
                local Ok, CurrentCFrame = pcall(function()
                    return Root.CFrame
                end)
                if Ok and CurrentCFrame then
                    local Move = Vector3.new(0, 0, 0)
                    if iskeypressed(KeycodeTable.W) then
                        Move = Move + Vector3.new(0, 0, -1)
                    end
                    if iskeypressed(KeycodeTable.S) then
                        Move = Move + Vector3.new(0, 0, 1)
                    end
                    if iskeypressed(KeycodeTable.A) then
                        Move = Move + Vector3.new(-1, 0, 0)
                    end
                    if iskeypressed(KeycodeTable.D) then
                        Move = Move + Vector3.new(1, 0, 0)
                    end
                    if iskeypressed(KeycodeTable.Space) then
                        Move = Move + Vector3.new(0, 1, 0)
                    end
                    if iskeypressed(KeycodeTable.LeftControl) then
                        Move = Move + Vector3.new(0, -1, 0)
                    end
                    if Move.Magnitude > 0 then
                        local Camera = WorkspaceService.CurrentCamera
                        local LookDirection = Vector3.new(0, 0, -1)
                        pcall(function()
                            LookDirection = Camera.CFrame.LookVector
                        end)
                        local FlatLook = Vector3.new(LookDirection.X, 0, LookDirection.Z)
                        if FlatLook.Magnitude > 0.001 then
                            FlatLook = FlatLook.Unit
                        else
                            FlatLook = Vector3.new(0, 0, -1)
                        end
                        local FlatRight = Vector3.new(-FlatLook.Z, 0, FlatLook.X)
                        local WorldMove = FlatLook * (-Move.Z) + FlatRight * Move.X + Vector3.new(0, Move.Y, 0)
                        local Step = WorldMove * (FlySpeed * 40) * 0.03
                        pcall(function()
                            Root.CFrame = CFrame.new(CurrentCFrame.Position + Step) * CFrame.Angles(0, 0, 0)
                        end)
                        pcall(function()
                            Root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                        end)
                    else
                        pcall(function()
                            Root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                        end)
                    end
                end
            end
            task.wait(0.03)
        end
    end)
end

local function RunInfJump()
    if InfJumpActive then
        return
    end
    InfJumpActive = true
    task.spawn(function()
        while InfJumpActive and not BailOut do
            if iskeypressed(KeycodeTable.Space) and not JumpDebounce then
                local Humanoid = SelfHumanoid()
                if Humanoid then
                    JumpDebounce = true
                    local Ok = pcall(function()
                        local Root = SelfRoot()
                        if Root then
                            Root.CFrame = Root.CFrame + Vector3.new(0, 5, 0)
                        end
                    end)
                    task.wait(0.25)
                    JumpDebounce = false
                end
            end
            task.wait(0.05)
        end
    end)
end

Commands.Cmd("speed", "number", "multiplies your walkspeed via the gc scanner", function(Amount)
    local Value = tonumber(Amount)
    if not Value or Value <= 0 then
        CommandError("speed needs a positive number")
        return
    end
    local Applied = ApplySpeedMultiplier(Value)
    Notify(ExecutableName, "applied to " .. Applied .. " values (see ;unspeed)", 5)
end, "Movement")

Commands.Cmd("unspeed", "", "restore walkspeed to 16", function()
    local Reset = ResetSpeed()
    Notify(ExecutableName, "reset " .. Reset .. " values", 5)
end, "Movement")

Commands.Cmd("fly", "speed", "fly with wasd space ctrl", function(Speed)
    FlySpeed = tonumber(Speed) or 1
    RunFlyLoop()
    Notify(ExecutableName, "fly on, speed " .. tostring(FlySpeed), 4)
end, "Movement")

Commands.Cmd("unfly", "", "stop fly", function()
    FlyLoop = false
    Notify(ExecutableName, "fly off", 4)
end, "Movement")

Commands.Cmd("noclip", "", "walk through walls", function()
    RunNoclipLoop()
    Notify(ExecutableName, "noclip on", 4)
end, "Movement")

Commands.Cmd("clip", "", "stop noclip", function()
    StopNoclipLoop()
    Notify(ExecutableName, "noclip off", 4)
end, "Movement")

Commands.Cmd("infjump", "", "jump in midair with space", function()
    RunInfJump()
    Notify(ExecutableName, "infjump on", 4)
end, "Movement")

Commands.Cmd("uninfjump", "", "stop infjump", function()
    InfJumpActive = false
    Notify(ExecutableName, "infjump off", 4)
end, "Movement")

Commands.Cmd("clicktp", "", "left click to teleport to your cursor", function()
    ClickTpActive = true
    ClickTpKey = nil
    Notify(ExecutableName, "clicktp armed, use ;clicktpkey to bind a key", 5)
end, "Movement")

Commands.Cmd("unclicktp", "", "disable clicktp", function()
    ClickTpActive = false
    Notify(ExecutableName, "clicktp off", 4)
end, "Movement")

Commands.Cmd("clicktpkey", "key", "bind a key to clicktp", function(KeyName)
    local Code = ToKeyCode(KeyName)
    if not Code then
        CommandError("unknown key: " .. tostring(KeyName))
        return
    end
    ClickTpKey = Code
    ClickTpActive = true
    Notify(ExecutableName, "clicktp bound to " .. string.upper(KeyName), 5)
end, "Movement")

Commands.Cmd("goto", "player", "teleport to a player", function(TargetName)
    local Target = GetPlayerFromPartial(TargetName)
    if not Target then
        CommandError("no player: " .. tostring(TargetName))
        return
    end
    local Position = GetCharacterPosition(Target)
    if not Position then
        CommandError("no position for " .. Target.Name)
        return
    end
    TeleportSelf(Position + Vector3.new(0, 2, 0))
    Notify(ExecutableName, "went to " .. Target.Name, 4)
end, "Movement")

Commands.Cmd("tp", "x y z", "teleport to coordinates", function(X, Y, Z)
    local Nx, Ny, Nz = tonumber(X), tonumber(Y), tonumber(Z)
    if not Nx or not Ny or not Nz then
        CommandError("tp needs three numbers")
        return
    end
    TeleportSelf(Vector3.new(Nx, Ny, Nz))
    Notify(ExecutableName, "teleported", 4)
end, "Movement")

Commands.Cmd("spawn", "x y z", "teleport slightly above coordinates", function(X, Y, Z)
    local Nx, Ny, Nz = tonumber(X), tonumber(Y), tonumber(Z)
    if not Nx or not Ny or not Nz then
        CommandError("spawn needs three numbers")
        return
    end
    TeleportSelf(Vector3.new(Nx, Ny + 5, Nz))
    Notify(ExecutableName, "teleported", 4)
end, "Movement")

Commands.Cmd("bring", "player", "bring a player to you (client side)", function(TargetName)
    local Target = GetPlayerFromPartial(TargetName)
    if not Target then
        CommandError("no player: " .. tostring(TargetName))
        return
    end
    local MyPosition = GetCharacterPosition(CurrentPlayer)
    local TheirRoot = GetRootPart(Target)
    if not MyPosition or not TheirRoot then
        CommandError("missing positions")
        return
    end
    pcall(function()
        TheirRoot.CFrame = CFrame.new(MyPosition + Vector3.new(0, 2, 0))
    end)
    Notify(ExecutableName, "brought " .. Target.Name .. " (client side only)", 5)
end, "Movement")

Commands.Cmd("view", "player", "spectate a player", function(TargetName)
    local Target = GetPlayerFromPartial(TargetName)
    if not Target then
        CommandError("no player: " .. tostring(TargetName))
        return
    end
    local Camera = WorkspaceService.CurrentCamera
    if not Camera then
        CommandError("no camera")
        return
    end
    local Subject = GetHumanoid(Target)
    if not Subject then
        CommandError("no humanoid on " .. Target.Name)
        return
    end
    OldCamera = GetProperty(Camera, "CameraSubject")
    ViewLocked = true
    SpectatingPlayer = Target.Name
    local Ok = pcall(function()
        Camera.CameraSubject = Subject
    end)
    Notify(ExecutableName, Ok and ("viewing " .. Target.Name) or "camera subject write rejected", 5)
end, "Movement")

Commands.Cmd("unview", "", "return the camera to you", function()
    ViewLocked = false
    SpectatingPlayer = nil
    local Camera = WorkspaceService.CurrentCamera
    if Camera and OldCamera then
        pcall(function()
            Camera.CameraSubject = OldCamera
        end)
    elseif Camera then
        pcall(function()
            Camera.CameraSubject = SelfHumanoid()
        end)
    end
    Notify(ExecutableName, "camera back", 4)
end, "Movement")

Commands.Cmd("spin", "", "spin your character", function()
    if SpinActive then
        CommandError("spin already on")
        return
    end
    SpinActive = true
    task.spawn(function()
        while SpinActive and not BailOut do
            local Root = SelfRoot()
            if Root then
                pcall(function()
                    Root.CFrame = Root.CFrame * CFrame.Angles(0, math.rad(25), 0)
                end)
            end
            task.wait(0.03)
        end
    end)
    Notify(ExecutableName, "spin on", 4)
end, "Movement")

Commands.Cmd("unspin", "", "stop spinning", function()
    SpinActive = false
    Notify(ExecutableName, "spin off", 4)
end, "Movement")
local function EspBuildPool()
    if EspPoolBuilt then
        return
    end
    for Slot = 1, EspPoolSize do
        local Entry = {}
        Entry.Box = DrawingFactory.Square()
        Entry.Box.Thickness = 1
        Entry.Box.Color = EspColor
        Entry.Tracer = DrawingFactory.Line()
        Entry.Tracer.Color = EspColor
        Entry.NameTag = DrawingFactory.Text()
        Entry.NameTag.Center = true
        Entry.NameTag.Color = Color3.fromRGB(255, 255, 255)
        Entry.DistanceTag = DrawingFactory.Text()
        Entry.DistanceTag.Center = true
        Entry.DistanceTag.Color = Color3.fromRGB(200, 200, 200)
        EspPool[Slot] = Entry
    end
    EspPoolBuilt = true
end

local function EspHideSlot(Entry)
    Entry.Box.Visible = false
    Entry.Tracer.Visible = false
    Entry.NameTag.Visible = false
    Entry.DistanceTag.Visible = false
end

local function EspHideAll()
    for Slot = 1, EspPoolSize do
        if EspPool[Slot] then
            EspHideSlot(EspPool[Slot])
        end
    end
end

local function EspCollector()
    if EspCollectorRunning then
        return
    end
    EspCollectorRunning = true
    task.spawn(function()
        while EspLoop and not BailOut do
            local Fresh = {}
            for _, Player in pairs(PlayersService:GetPlayers()) do
                if Player ~= CurrentPlayer and not ShouldIgnore(Player) then
                    local Position = GetCharacterPosition(Player)
                    local HeadPart = nil
                    local Character = GetCharacter(Player)
                    if Character then
                        HeadPart = Character:FindFirstChild("Head") or Character:FindFirstChild("UpperTorso") or Character:FindFirstChild("Torso")
                    end
                    local Health = nil
                    local MaxHealth = nil
                    local Humanoid = GetHumanoid(Player)
                    if Humanoid then
                        Health = GetProperty(Humanoid, "Health")
                        MaxHealth = GetProperty(Humanoid, "MaxHealth")
                    end
                    if Position and HeadPart and Health and Health > 0 then
                        local TeamName = nil
                        pcall(function()
                            if Player.Team then
                                TeamName = Player.Team.Name
                            end
                        end)
                        Fresh[Player.UserId] = {
                            Name = Player.Name,
                            UserId = Player.UserId,
                            Position = Position,
                            Head = HeadPart,
                            Health = Health,
                            MaxHealth = MaxHealth,
                            Team = TeamName
                        }
                    end
                end
            end
            EspTargets = Fresh
            task.wait(0.4)
        end
        EspCollectorRunning = false
    end)
end

local function EspRenderer()
    if not EspLoop then
        if EspRenderConnection then
            EspRenderConnection:Disconnect()
            EspRenderConnection = nil
        end
        EspHideAll()
        return
    end
    EspBuildPool()
    local Slot = 0
    local MyPosition = GetCharacterPosition(CurrentPlayer)
    for _, Target in pairs(EspTargets) do
        if Slot >= EspPoolSize then
            break
        end
        local HeadPosition = nil
        pcall(function()
            HeadPosition = Target.Head.Position
        end)
        if HeadPosition then
            local TopPoint, TopVisible = WorldToScreenPosition(HeadPosition + Vector3.new(0, 0.7, 0))
            local BottomPoint, BottomVisible = WorldToScreenPosition(Target.Position - Vector3.new(0, 0.5, 0))
            if TopVisible and BottomVisible and TopPoint and BottomPoint then
                local Height = BottomPoint.Y - TopPoint.Y
                if Height > 4 then
                    Slot = Slot + 1
                    local Entry = EspPool[Slot]
                    local Width = Height * 0.5
                    local Distance = 0
                    if MyPosition then
                        Distance = (MyPosition - Target.Position).Magnitude
                    end
                    pcall(function()
                        if EspBoxes then
                            Entry.Box.Size = Vector2.new(Width, Height)
                            Entry.Box.Position = Vector2.new(TopPoint.X - Width * 0.5, TopPoint.Y)
                            Entry.Box.Color = EspColor
                            Entry.Box.Visible = true
                        else
                            Entry.Box.Visible = false
                        end
                        if EspTracers then
                            local Viewport = GetCameraField("ViewportSize")
                            if Viewport then
                                Entry.Tracer.From = Vector2.new(Viewport.X * 0.5, Viewport.Y)
                                Entry.Tracer.To = Vector2.new(TopPoint.X, BottomPoint.Y)
                                Entry.Tracer.Color = EspColor
                                Entry.Tracer.Visible = true
                            end
                        else
                            Entry.Tracer.Visible = false
                        end
                        if EspNameTags then
                            Entry.NameTag.Text = Target.Name
                            Entry.NameTag.Position = Vector2.new(TopPoint.X, TopPoint.Y - 15)
                            Entry.NameTag.Visible = true
                        else
                            Entry.NameTag.Visible = false
                        end
                        if EspDistanceTags then
                            Entry.DistanceTag.Text = tostring(math.floor(Distance)) .. "m"
                            Entry.DistanceTag.Position = Vector2.new(TopPoint.X, BottomPoint.Y + 2)
                            Entry.DistanceTag.Visible = true
                        else
                            Entry.DistanceTag.Visible = false
                        end
                    end)
                end
            end
        end
    end
    for HideSlot = Slot + 1, EspPoolSize do
        if EspPool[HideSlot] then
            EspHideSlot(EspPool[HideSlot])
        end
    end
end

local function StartEsp()
    EspLoop = true
    EspBuildPool()
    EspCollector()
    if not EspRenderConnection then
        EspRenderConnection = RunService.RenderStepped:Connect(function()
            local Ok = pcall(EspRenderer)
            if not Ok then
                EspHideAll()
            end
        end)
    end
end

local function StopEsp()
    EspLoop = false
    EspTargets = {}
    if EspRenderConnection then
        EspRenderConnection:Disconnect()
        EspRenderConnection = nil
    end
    EspHideAll()
end

Commands.Cmd("esp", "", "boxes tracers names and distance on every player", function()
    if EspLoop then
        CommandError("esp already running")
        return
    end
    EspBoxes = true
    EspTracers = true
    EspNameTags = true
    EspDistanceTags = true
    StartEsp()
    Notify(ExecutableName, "esp on", 4)
end, "Visuals")

Commands.Cmd("unesp", "", "turn esp off", function()
    StopEsp()
    Notify(ExecutableName, "esp off", 4)
end, "Visuals")

Commands.Cmd("boxes", "", "toggle esp boxes", function()
    EspBoxes = not EspBoxes
    Notify(ExecutableName, "boxes " .. (EspBoxes and "on" or "off"), 3)
end, "Visuals")

Commands.Cmd("tracers", "", "toggle esp tracers", function()
    EspTracers = not EspTracers
    Notify(ExecutableName, "tracers " .. (EspTracers and "on" or "off"), 3)
end, "Visuals")

Commands.Cmd("names", "", "toggle esp name tags", function()
    EspNameTags = not EspNameTags
    Notify(ExecutableName, "names " .. (EspNameTags and "on" or "off"), 3)
end, "Visuals")

Commands.Cmd("distances", "", "toggle esp distance tags", function()
    EspDistanceTags = not EspDistanceTags
    Notify(ExecutableName, "distances " .. (EspDistanceTags and "on" or "off"), 3)
end, "Visuals")

Commands.Cmd("espcolor", "r g b", "esp color", function(R, G, B)
    local Nr, Ng, Nb = tonumber(R), tonumber(G), tonumber(B)
    if not Nr or not Ng or not Nb then
        CommandError("espcolor needs three numbers")
        return
    end
    EspColor = Color3.fromRGB(Nr, Ng, Nb)
    Notify(ExecutableName, "esp color set", 3)
end, "Visuals")

Commands.Cmd("espwhitelist", "", "only draw esp on whitelisted players", function()
    Notify(ExecutableName, "use ;whitelist player then ;esp, whitelist is stored in WhitelistTable", 5)
end, "Visuals")

Commands.Cmd("fullbright", "", "attempts lighting changes, see what sticks", function()
    local Lighting = nil
    pcall(function()
        Lighting = game:GetService("Lighting")
    end)
    if not Lighting then
        pcall(function()
            Lighting = game:FindFirstChild("Lighting")
        end)
    end
    if not Lighting then
        CommandError("no lighting service visible to this vm")
        return
    end
    local Changed = 0
    local Attempts = {
        {"Brightness", 3},
        {"Ambient", Color3.fromRGB(200, 200, 200)},
        {"OutdoorAmbient", Color3.fromRGB(200, 200, 200)},
        {"GlobalShadows", false},
        {"FogEnd", 100000}
    }
    for _, Attempt in pairs(Attempts) do
        local Ok = pcall(function()
            Lighting[Attempt[1]] = Attempt[2]
        end)
        if Ok then
            Changed = Changed + 1
        end
    end
    if Changed == 0 then
        CommandError("this vm cannot write lighting properties, fullbright is impossible here")
    else
        Notify(ExecutableName, "fullbright changed " .. Changed .. " properties", 4)
    end
end, "Visuals")

Commands.Cmd("fov", "number", "camera field of view", function(Amount)
    local Value = tonumber(Amount)
    if not Value or Value < 10 or Value > 120 then
        CommandError("fov needs a number between 10 and 120")
        return
    end
    local Camera = WorkspaceService.CurrentCamera
    if not Camera then
        CommandError("no camera")
        return
    end
    pcall(function()
        Camera.FieldOfView = Value
    end)
    FovAmount = Value
    Notify(ExecutableName, "fov " .. tostring(Value), 3)
end, "Visuals")

Commands.Cmd("resetfov", "", "fov back to 70", function()
    local Camera = WorkspaceService.CurrentCamera
    if Camera then
        pcall(function()
            Camera.FieldOfView = 70
        end)
    end
    FovAmount = 70
    Notify(ExecutableName, "fov reset", 3)
end, "Visuals")
local function GetScreenMiddle()
    local Viewport = GetCameraField("ViewportSize")
    if Viewport then
        return Vector2.new(Viewport.X * 0.5, Viewport.Y * 0.5)
    end
    return Vector2.new(0, 0)
end

local function ClosestTargetOnScreen()
    local Camera = WorkspaceService.CurrentCamera
    if not Camera then
        return nil
    end
    local Middle = GetScreenMiddle()
    local Best = nil
    local BestDistance = AimbotFovValue
    for _, Player in pairs(PlayersService:GetPlayers()) do
        if Player ~= CurrentPlayer and not ShouldIgnore(Player) and IsValidCharacter(Player) then
            local AimPart = nil
            local Character = GetCharacter(Player)
            if Character then
                for _, PartName in pairs(AimbotParts) do
                    local Part = Character:FindFirstChild(PartName)
                    if Part then
                        AimPart = Part
                        break
                    end
                end
            end
            if AimPart then
                local WorldPosition = nil
                pcall(function()
                    WorldPosition = AimPart.Position
                end)
                if WorldPosition then
                    local ScreenPoint, OnScreen = WorldToScreenPosition(WorldPosition)
                    if OnScreen and ScreenPoint then
                        local ScreenDistance = (ScreenPoint - Middle).Magnitude
                        if ScreenDistance < BestDistance then
                            BestDistance = ScreenDistance
                            Best = WorldPosition
                        end
                    end
                end
            end
        end
    end
    return Best
end

local function ApplyCameraAim(WorldPosition)
    local Camera = WorkspaceService.CurrentCamera
    if not Camera then
        return
    end
    local Ok, CurrentCFrame = pcall(function()
        return Camera.CFrame
    end)
    if not Ok or not CurrentCFrame then
        return
    end
    local NewLook = CFrame.lookAt(CurrentCFrame.Position, WorldPosition)
    local Blended = CurrentCFrame:Lerp(NewLook, AimbotSmoothing)
    pcall(function()
        Camera.CFrame = Blended
    end)
end

local function RunAimbot()
    if AimbotRunning then
        return
    end
    AimbotRunning = true
    task.spawn(function()
        while AimbotRunning and not BailOut do
            local Camera = WorkspaceService.CurrentCamera
            if Camera and WorldToScreenPosition(nil) ~= nil then
                local TargetPosition = ClosestTargetOnScreen()
                if TargetPosition then
                    ApplyCameraAim(TargetPosition)
                end
            end
            task.wait()
        end
    end)
end

Commands.Cmd("aimbot", "", "camera based aimbot, nearest head in your view", function()
    RunAimbot()
    Notify(ExecutableName, "aimbot on", 4)
end, "Combat")

Commands.Cmd("unaimbot", "", "stop the aimbot", function()
    AimbotRunning = false
    Notify(ExecutableName, "aimbot off", 4)
end, "Combat")

Commands.Cmd("aimbotfov", "number", "aimbot search radius in pixels", function(Value)
    AimbotFovValue = tonumber(Value) or 200
    Notify(ExecutableName, "aimbot fov " .. tostring(AimbotFovValue), 3)
end, "Combat")

Commands.Cmd("aimbotteam", "", "toggle team check for aimbot", function()
    AimbotTeamCheck = not AimbotTeamCheck
    EspTeamCheck = AimbotTeamCheck
    Notify(ExecutableName, "team check " .. (AimbotTeamCheck and "on" or "off"), 3)
end, "Combat")

Commands.Cmd("aimbotvis", "", "toggle visibility check via raycast", function()
    AimbotVisibleCheck = not AimbotVisibleCheck
    Notify(ExecutableName, "visibility check " .. (AimbotVisibleCheck and "on" or "off"), 3)
end, "Combat")

Commands.Cmd("clickaim", "", "bind a key that aims at the nearest player", function(KeyName)
    local Code = ToKeyCode(KeyName)
    if not Code then
        CommandError("unknown key: " .. tostring(KeyName))
        return
    end
    ClickAimKey = Code
    ClickAimActive = true
    Notify(ExecutableName, "clickaim bound to " .. string.upper(KeyName), 5)
end, "Combat")

Commands.Cmd("unclickaim", "", "remove the clickaim bind", function()
    ClickAimKey = nil
    ClickAimActive = false
    Notify(ExecutableName, "clickaim off", 3)
end, "Combat")

ClickAimRun = function()
    local Target = ClosestTargetOnScreen()
    if Target then
        ApplyCameraAim(Target)
    end
end
Commands.Cmd("notifyme", "", "test notification", function()
    Notify(ExecutableName, "notifications work", 4)
end, "Utility")

Commands.Cmd("charinfo", "player", "prints a player character structure", function(TargetName)
    local Target = GetPlayerFromPartial(TargetName)
    if not Target then
        CommandError("no player: " .. tostring(TargetName))
        return
    end
    local Character = GetCharacter(Target)
    if not Character then
        CommandError("no character")
        return
    end
    print("== " .. Target.Name .. " character ==")
    for _, Part in pairs(Character:GetChildren()) do
        print(Part.Name .. " / " .. Part.ClassName)
    end
end, "Utility")

Commands.Cmd("partcount", "player", "how many descendants in a character", function(TargetName)
    local Target = GetPlayerFromPartial(TargetName)
    if not Target then
        CommandError("no player: " .. tostring(TargetName))
        return
    end
    local Character = GetCharacter(Target)
    if not Character then
        CommandError("no character")
        return
    end
    local Count = 0
    pcall(function()
        Count = #Character:GetDescendants()
    end)
    Notify(ExecutableName, Target.Name .. " has " .. tostring(Count) .. " descendants", 4)
end, "Utility")

Commands.Cmd("remotes", "", "lists RemoteEvents and RemoteFunctions visible to the vm", function()
    task.spawn(function()
        local Seen = {}
        local Count = 0
        pcall(function()
            for _, Service in pairs(game:GetChildren()) do
                local Ok, Descendants = pcall(function()
                    return Service:GetDescendants()
                end)
                if Ok and Descendants then
                    for _, Descendant in pairs(Descendants) do
                        local ClassName = GetProperty(Descendant, "ClassName")
                        if ClassName == "RemoteEvent" or ClassName == "RemoteFunction" then
                            Count = Count + 1
                            if Count <= 150 then
                                local ParentName = "root"
                                pcall(function()
                                    ParentName = Descendant.Parent.Name
                                end)
                                table.insert(Seen, Descendant.Name .. " [" .. ClassName .. "] in " .. ParentName)
                            end
                        end
                    end
                end
            end
        end)
        print("== remotes: " .. tostring(Count) .. " total ==")
        for _, Line in pairs(Seen) do
            print(Line)
        end
        Notify(ExecutableName, tostring(Count) .. " remotes, list in console (F9)", 6)
    end)
end, "Utility")

Commands.Cmd("copypos", "", "copies your position as a ;tp command", function()
    local Position = GetCharacterPosition(CurrentPlayer)
    if not Position then
        CommandError("no position")
        return
    end
    local Text = ";tp " .. string.format("%.1f", Position.X) .. " " .. string.format("%.1f", Position.Y) .. " " .. string.format("%.1f", Position.Z)
    pcall(function()
        setclipboard(Text)
    end)
    Notify(ExecutableName, "copied: " .. Text, 4)
end, "Utility")

Commands.Cmd("copyname", "player", "copies a player username", function(TargetName)
    local Target = GetPlayerFromPartial(TargetName)
    if not Target then
        CommandError("no player: " .. tostring(TargetName))
        return
    end
    pcall(function()
        setclipboard(Target.Name)
    end)
    Notify(ExecutableName, "copied " .. Target.Name, 4)
end, "Utility")

Commands.Cmd("serverinfo", "", "place id job id and player count", function()
    local JobId = "-"
    pcall(function()
        JobId = game.JobId
    end)
    Notify(ExecutableName, "place " .. tostring(PlaceIdentifier) .. " job " .. tostring(JobId) .. " players " .. tostring(#PlayersService:GetPlayers()), 8)
end, "Utility")

Commands.Cmd("ping", "", "your network ping via the executor", function()
    local PingValue = nil
    pcall(function()
        PingValue = GetPingValue()
    end)
    if PingValue then
        Notify(ExecutableName, "ping " .. tostring(PingValue) .. "ms", 4)
    else
        CommandError("ping not available")
    end
end, "Utility")

Commands.Cmd("age", "player", "account age in days", function(TargetName)
    local Target = GetPlayerFromPartial(TargetName)
    if not Target then
        CommandError("no player: " .. tostring(TargetName))
        return
    end
    local AccountAge = nil
    pcall(function()
        AccountAge = Target.AccountAge
    end)
    if AccountAge then
        Notify(ExecutableName, Target.Name .. " account age " .. tostring(AccountAge) .. " days", 5)
    else
        CommandError("AccountAge is not readable in this vm")
    end
end, "Utility")

Commands.Cmd("displayname", "player", "show a player display name", function(TargetName)
    local Target = GetPlayerFromPartial(TargetName)
    if not Target then
        CommandError("no player: " .. tostring(TargetName))
        return
    end
    local Display = nil
    pcall(function()
        Display = Target.DisplayName
    end)
    Notify(ExecutableName, Target.Name .. " displays as " .. tostring(Display), 5)
end, "Utility")

Commands.Cmd("userid", "player", "show a player user id", function(TargetName)
    local Target = GetPlayerFromPartial(TargetName)
    if not Target then
        CommandError("no player: " .. tostring(TargetName))
        return
    end
    local Id = nil
    pcall(function()
        Id = Target.UserId
    end)
    Notify(ExecutableName, Target.Name .. " id " .. tostring(Id), 5)
end, "Utility")

Commands.Cmd("getreg", "", "scans the gc for common stat keys", function()
    task.spawn(function()
        local Keys = {"Damage", "FireRate", "Ammo", "AmmoInClip", "WalkSpeed", "Coins", "Cash", "Money", "Kills", "Health"}
        local Found = 0
        for _, Key in pairs(Keys) do
            local Ok, Hits = pcall(function()
                return getgc(Key)
            end)
            if Ok and Hits and #Hits > 0 then
                Found = Found + 1
                print(Key .. ": " .. tostring(#Hits) .. " hits, first=" .. tostring(Hits[1].value) .. " (" .. tostring(Hits[1].type) .. ")")
            end
        end
        if Found == 0 then
            print("gc scanner found nothing for the common keys in this game")
        end
        Notify(ExecutableName, tostring(Found) .. " keys found, details in console (F9)", 5)
    end)
end, "Utility")

Commands.Cmd("team", "player", "show a player team", function(TargetName)
    local Target = GetPlayerFromPartial(TargetName)
    if not Target then
        CommandError("no player: " .. tostring(TargetName))
        return
    end
    local TeamName = nil
    pcall(function()
        if Target.Team then
            TeamName = Target.Team.Name
        end
    end)
    Notify(ExecutableName, Target.Name .. " team " .. tostring(TeamName), 4)
end, "Utility")

Commands.AddAlias("copypos", "clipboard")
Commands.AddAlias("speed", "ws")
function TeleportToPlaceId(PlaceId, JobId)
    local Handled = false
    pcall(function()
        local TeleportService = game:GetService("TeleportService")
        if TeleportService and TeleportService.TeleportToPlaceInstance then
            if JobId and JobId ~= "" then
                TeleportService:TeleportToPlaceInstance(PlaceId, JobId, CurrentPlayer)
                Handled = true
            end
        end
    end)
    if not Handled then
        pcall(function()
            local TeleportService = game:GetService("TeleportService")
            if TeleportService and TeleportService.Teleport then
                TeleportService:Teleport(PlaceId, CurrentPlayer)
                Handled = true
            end
        end)
    end
    if not Handled then
        CommandError("this vm exposes no working teleport method, rejoin manually")
    end
    return Handled
end

ClickTpRun = function()
    local Camera = WorkspaceService.CurrentCamera
    if not Camera then
        CommandError("no camera")
        return
    end
    local Mouse = nil
    pcall(function()
        Mouse = CurrentPlayer:GetMouse()
    end)
    if not Mouse then
        CommandError("no mouse access")
        return
    end
    local MouseX, MouseY = nil, nil
    pcall(function()
        MouseX = Mouse.X
        MouseY = Mouse.Y
    end)
    if not MouseX or not MouseY then
        CommandError("mouse position not readable")
        return
    end
    local Viewport = GetCameraField("ViewportSize")
    local CameraCFrame = nil
    pcall(function()
        CameraCFrame = Camera.CFrame
    end)
    if not Viewport or not CameraCFrame then
        CommandError("camera state not readable")
        return
    end
    local FieldOfView = GetCameraField("FieldOfView") or 70
    local OffsetX = MouseX / Viewport.X - 0.5
    local OffsetY = MouseY / Viewport.Y - 0.5
    local TanY = math.tan(math.rad(FieldOfView) * 0.5)
    local TanX = TanY * (Viewport.X / Viewport.Y)
    local Forward = CameraCFrame.LookVector
    local Right = CameraCFrame.RightVector
    local Up = CameraCFrame.UpVector
    local Direction = Forward + Right * (2 * OffsetX * TanX) - Up * (2 * OffsetY * TanY)
    Direction = Vector3.new(Direction.X, Direction.Y, Direction.Z)
    local Magnitude = Direction.Magnitude
    if Magnitude < 0.001 then
        CommandError("bad ray direction")
        return
    end
    Direction = Vector3.new(Direction.X / Magnitude, Direction.Y / Magnitude, Direction.Z / Magnitude)
    local Origin = CameraCFrame.Position + Direction * 4
    local Hit = nil
    pcall(function()
        Hit = WorkspaceService:Raycast(Origin, Direction * 2000)
    end)
    if Hit and Hit.Position then
        TeleportSelf(Hit.Position + Vector3.new(0, 3, 0))
        Notify(ExecutableName, "teleported", 3)
    else
        CommandError("raycast found nothing, this vm may not support raycast here")
    end
end

Commands.Cmd("antiafk", "", "simulates key input every few minutes", function()
    if AntiLagRunning then
        CommandError("antiafk already on")
        return
    end
    AntiLagRunning = true
    task.spawn(function()
        while AntiLagRunning and not BailOut do
            pcall(function()
                keypress(1)
                task.wait(0.05)
                keyrelease(1)
            end)
            task.wait(240)
        end
    end)
    Notify(ExecutableName, "antiafk on", 4)
end, "Utility")

Commands.Cmd("unantiafk", "", "stop antiafk", function()
    AntiLagRunning = false
    Notify(ExecutableName, "antiafk off", 3)
end, "Utility")

Commands.Cmd("chatlog", "", "logs chat text found in the ui to console", function()
    if ChatLogActive then
        CommandError("chatlog already on")
        return
    end
    ChatLogActive = true
    task.spawn(function()
        local Seen = {}
        while ChatLogActive and not BailOut do
            local Found = 0
            pcall(function()
                local PlayerGui = CurrentPlayer.PlayerGui
                if PlayerGui then
                    for _, Descendant in pairs(PlayerGui:GetDescendants()) do
                        local ClassName = GetProperty(Descendant, "ClassName")
                        if ClassName == "TextLabel" or ClassName == "TextButton" then
                            local Text = GetProperty(Descendant, "Text")
                            if Text and string.len(Text) > 2 and string.len(Text) < 200 and not Seen[Text] then
                                Seen[Text] = true
                                Found = Found + 1
                                if Found <= 20 then
                                    table.insert(ChatLogs, Text)
                                    print("[chat] " .. Text)
                                end
                            end
                        end
                    end
                end
            end)
            task.wait(2)
        end
    end)
    Notify(ExecutableName, "chatlog on, output in console and ;chatlogshow", 5)
end, "Utility")

Commands.Cmd("unchatlog", "", "stop chat logging", function()
    ChatLogActive = false
    Notify(ExecutableName, "chatlog off", 3)
end, "Utility")

Commands.Cmd("chatlogshow", "", "prints captured chat", function()
    print("== chat log ==")
    for _, Line in pairs(ChatLogs) do
        print(Line)
    end
    Notify(ExecutableName, tostring(#ChatLogs) .. " lines in console", 4)
end, "Utility")

Commands.Cmd("chatlogclear", "", "clears the chat log", function()
    ChatLogs = {}
    Notify(ExecutableName, "chat log cleared", 3)
end, "Utility")

Commands.Cmd("chat", "message", "sends a chat message if the vm can reach the chat ui", function(...)
    CommandError("this vm cannot create ui instances or write chat text, chat is impossible")
end, "Utility")

Commands.Cmd("serverbrowser", "", "lists public servers of this game", function()
    task.spawn(function()
        local Ok, Result = pcall(function()
            return game:HttpGet("https://games.roblox.com/v1/games/" .. tostring(PlaceIdentifier) .. "/servers/Public?limit=100")
        end)
        if not Ok then
            CommandError("http request failed: " .. tostring(Result))
            return
        end
        local Decoded = nil
        pcall(function()
            Decoded = HttpService:JSONDecode(Result)
        end)
        if not Decoded or not Decoded.data then
            CommandError("bad server response")
            return
        end
        print("== servers ==")
        for Index, ServerInfo in pairs(Decoded.data) do
            print(tostring(Index) .. ": id=" .. tostring(ServerInfo.id) .. " players=" .. tostring(ServerInfo.playing) .. "/" .. tostring(ServerInfo.maxPlayers))
        end
        Notify(ExecutableName, tostring(#Decoded.data) .. " servers in console, use ;copyjob to grab this server id", 6)
    end)
end, "Server")

Commands.Cmd("copyjob", "", "copies this server job id", function()
    local JobId = "-"
    pcall(function()
        JobId = game.JobId
    end)
    pcall(function()
        setclipboard(tostring(JobId))
    end)
    Notify(ExecutableName, "copied " .. tostring(JobId), 4)
end, "Server")

Commands.Cmd("hop", "jobid", "attempts to join a server by job id", function(JobId)
    if not JobId then
        CommandError("hop needs a job id from ;serverbrowser")
        return
    end
    TeleportToPlaceId(PlaceIdentifier, JobId)
end, "Server")

Commands.Cmd("saveprefs", "", "saves prefix esp color fov and fly speed", function()
    if type(writefile) ~= "function" then
        CommandError("writefile missing")
        return
    end
    local Ok = pcall(function()
        makefolder("InfiniteMatcha")
        writefile("InfiniteMatcha/prefs.json", HttpService:JSONEncode({
            prefix = Prefix,
            espcolor = {EspColor.R * 255, EspColor.G * 255, EspColor.B * 255},
            fov = FovAmount,
            flyspeed = FlySpeed
        }))
    end)
    if Ok then
        Notify(ExecutableName, "prefs saved", 4)
    else
        CommandError("save failed")
    end
end, "Settings")

Commands.Cmd("loadprefs", "", "loads saved prefs", function()
    if type(readfile) ~= "function" then
        CommandError("readfile missing")
        return
    end
    local Raw = nil
    pcall(function()
        Raw = readfile("InfiniteMatcha/prefs.json")
    end)
    if not Raw then
        CommandError("no prefs saved yet")
        return
    end
    local Decoded = nil
    pcall(function()
        Decoded = HttpService:JSONDecode(Raw)
    end)
    if not Decoded then
        CommandError("prefs file corrupted")
        return
    end
    if Decoded.prefix and string.len(Decoded.prefix) == 1 then
        Prefix = Decoded.prefix
    end
    if Decoded.espcolor and Decoded.espcolor[1] then
        EspColor = Color3.fromRGB(Decoded.espcolor[1], Decoded.espcolor[2], Decoded.espcolor[3])
    end
    if Decoded.fov then
        FovAmount = Decoded.fov
    end
    if Decoded.flyspeed then
        FlySpeed = Decoded.flyspeed
    end
    Notify(ExecutableName, "prefs loaded", 4)
end, "Settings")

Commands.Cmd("prefix", "char", "changes the command prefix", function(NewPrefix)
    if NewPrefix and string.len(NewPrefix) == 1 then
        Prefix = NewPrefix
        Notify(ExecutableName, "prefix is now " .. Prefix, 4)
    else
        CommandError("prefix must be one character")
    end
end, "Settings")

Commands.Cmd("addadmin", "player", "marks a player as an admin locally", function(TargetName)
    local Target = GetPlayerFromPartial(TargetName)
    if not Target then
        CommandError("no player: " .. tostring(TargetName))
        return
    end
    table.insert(AdminsTable, Target.Name)
    Notify(ExecutableName, Target.Name .. " added to local admins", 4)
end, "Settings")

Commands.Cmd("admins", "", "lists local admins", function()
    if #AdminsTable == 0 then
        Notify(ExecutableName, "no admins set", 4)
    else
        Notify(ExecutableName, table.concat(AdminsTable, ", "), 6)
    end
end, "Settings")

Commands.Cmd("ban", "player", "marks a player for client side esp tagging", function(TargetName)
    local Target = GetPlayerFromPartial(TargetName)
    if not Target then
        CommandError("no player: " .. tostring(TargetName))
        return
    end
    table.insert(BanList, Target.Name)
    Notify(ExecutableName, Target.Name .. " marked, note kicking others is impossible in this vm", 5)
end, "Settings")

Commands.Cmd("unban", "player", "removes a player from the ban list", function(TargetName)
    for Index, Name in pairs(BanList) do
        if Name == TargetName then
            table.remove(BanList, Index)
            Notify(ExecutableName, TargetName .. " unbanned", 4)
            return
        end
    end
    CommandError("not in ban list: " .. tostring(TargetName))
end, "Settings")

Commands.Cmd("binds", "", "lists active key binds", function()
    local Lines = {}
    if ToggleKeyOpen then
        table.insert(Lines, "menu=" .. tostring(ToggleKeyOpen))
    end
    if ToggleKeyHide then
        table.insert(Lines, "hide=" .. tostring(ToggleKeyHide))
    end
    if ClickTpKey then
        table.insert(Lines, "clicktp=" .. tostring(ClickTpKey))
    end
    if ClickAimKey then
        table.insert(Lines, "clickaim=" .. tostring(ClickAimKey))
    end
    if #Lines == 0 then
        Notify(ExecutableName, "no binds set", 4)
    else
        Notify(ExecutableName, table.concat(Lines, "  "), 6)
    end
end, "Settings")

Commands.Cmd("setkey", "which key", "binds menu or hide keys", function(Which, KeyName)
    local Code = ToKeyCode(KeyName)
    if not Code then
        CommandError("unknown key: " .. tostring(KeyName))
        return
    end
    if Which == "menu" or Which == "open" then
        ToggleKeyOpen = Code
        Notify(ExecutableName, "menu key bound", 4)
    elseif Which == "hide" then
        ToggleKeyHide = Code
        Notify(ExecutableName, "hide key bound", 4)
    else
        CommandError("setkey menu or setkey hide")
    end
end, "Settings")

Commands.Cmd("fireservercheck", "", "checks if remote calls are wired up", function()
    local Sample = nil
    pcall(function()
        for _, Service in pairs(game:GetChildren()) do
            local Ok, Descendants = pcall(function()
                return Service:GetDescendants()
            end)
            if Ok and Descendants then
                for _, Descendant in pairs(Descendants) do
                    if GetProperty(Descendant, "ClassName") == "RemoteEvent" then
                        Sample = Descendant
                        break
                    end
                end
            end
            if Sample then
                break
            end
        end
    end)
    if not Sample then
        CommandError("no remoteevent visible to test")
        return
    end
    local Method = nil
    pcall(function()
        Method = type(Sample.FireServer)
    end)
    if Method == "function" then
        Notify(ExecutableName, "FireServer exists, if it errors at runtime enable hybrid mode in the matcha menu", 8)
    else
        CommandError("FireServer not available")
    end
end, "Settings")

Commands.Cmd("hybridmode", "", "explains hybrid mode", function()
    Notify(ExecutableName, "enable hybrid mode in the matcha menu before running remote based commands, this script cannot toggle it from lua", 8)
end, "Settings")

function DoUnload()
    BailOut = true
    EspLoop = false
    FlyLoop = false
    NoclipLoop = false
    InfJumpActive = false
    AimbotRunning = false
    SpinActive = false
    ChatLogActive = false
    AntiLagRunning = false
    ClickTpActive = false
    ClickAimActive = false
    ViewLocked = false
    if EspRenderConnection then
        pcall(function()
            EspRenderConnection:Disconnect()
        end)
        EspRenderConnection = nil
    end
    if RenderConnection then
        pcall(function()
            RenderConnection:Disconnect()
        end)
        RenderConnection = nil
    end
    if InputConnection then
        pcall(function()
            InputConnection:Disconnect()
        end)
        InputConnection = nil
    end
    if CommandWindow then
        CommandWindow.Hide()
        CommandWindow.InputBox.Hide()
        CommandWindow.SuggestionList.Hide()
        CommandWindow.Remove()
        CommandWindow.InputBox.Remove()
        CommandWindow.SuggestionList.Remove()
        CommandWindow = nil
    end
    EspHideAll()
    for Slot = 1, EspPoolSize do
        local Entry = EspPool[Slot]
        if Entry then
            RemoveDrawingSafe(Entry.Box)
            RemoveDrawingSafe(Entry.Tracer)
            RemoveDrawingSafe(Entry.NameTag)
            RemoveDrawingSafe(Entry.DistanceTag)
            EspPool[Slot] = nil
        end
    end
    EspPoolBuilt = false
    RemoveDrawingSafe(HintBar)
    RemoveDrawingSafe(HintText)
    HintBar = nil
    HintText = nil
    local Camera = WorkspaceService.CurrentCamera
    if Camera then
        pcall(function()
            Camera.FieldOfView = 70
        end)
        if OldCamera then
            pcall(function()
                Camera.CameraSubject = OldCamera
            end)
        end
    end
    Notify(ExecutableName, "unloaded", 3)
    _G.InfiniteMatchaVersion = nil
    _G.InfiniteMatchaUnload = nil
end

Commands.Cmd("unload", "", "same as exit", function()
    DoUnload()
end, "Main")

local function Boot()
    BuildCommandWindow()
    PollKeyboard()
    _G.InfiniteMatchaVersion = InfiniteMatchaVersion
    _G.InfiniteMatchaUnload = DoUnload
    _G.InfiniteMatchaExec = CommandSubmitted
    Notify(ExecutableName, "loaded " .. InfiniteMatchaVersion .. " on " .. ExecutorName .. ", press " .. Prefix .. " to open, ;cmds for the list", 7)
end

Boot()
end)
