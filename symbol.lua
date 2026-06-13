-- ============================================================
-- Symbol.Hit v3.3 |  Ragebot b208
-- ============================================================

local repo               = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'
local Library            = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager       = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager        = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

local Window             = Library:CreateWindow({
    Title        = 'Symbol.Hit v3.3 PRE RELEASE!!!',
    Center       = true,
    AutoShow     = true,
    TabPadding   = 8,
    MenuFadeTime = 0.06
})

local Tabs               = {
    Main            = Window:AddTab('Main'),
    Rage            = Window:AddTab('Rage'),
    Exploits        = Window:AddTab('Exploits'),
    Visuals         = Window:AddTab('Visuals'),
    ['UI Settings'] = Window:AddTab('UI Settings'),
}

-- ============================================================
-- SERVICES
-- ============================================================
local Players            = game:GetService("Players")
local RunService         = game:GetService("RunService")
local UIS                = game:GetService("UserInputService")
local RS                 = game:GetService("ReplicatedStorage")
local Stats              = game:GetService("Stats")
local SoundService       = game:GetService("SoundService")
local Debris             = game:GetService("Debris")
local MarketplaceService = game:GetService("MarketplaceService")
local HttpService        = game:GetService("HttpService")
local InsertService      = game:GetService("InsertService")

local LocalPlayer        = Players.LocalPlayer
local Camera             = workspace.CurrentCamera


-- LPH_NO_VIRTUALIZE fallback (is nil when not processed by Luarmor)
if not LPH_NO_VIRTUALIZE then
    LPH_NO_VIRTUALIZE = function(fn) return fn end
end

-- ============================================================
-- ANIMATION PLAYER SYSTEM
-- ============================================================

-- ┌──────────────────────────────────────────────────────────┐
-- │   ANIMATION DATABASE — añade tus animaciones aquí       │
-- │                                                          │
-- │   Formato:                                               │
-- │     ["Nombre"] = "rbxassetid://XXXXXXXXXX",             │
-- │                                                          │
-- │   Plantillas listas para llenar (descomenta y pon ID):  │
-- └──────────────────────────────────────────────────────────┘
local ANIM_DB = {
    -- ── Confirmed working (direct asset IDs) ──────────────────
    ["Bouncy Twirl"]                       = "rbxassetid://14352343065",
    ["Beauty Touchdown"]                   = "rbxassetid://16302968986",
    ["Checking My Angles"]                 = "rbxassetid://15392752812",
    ["Rock Guitar - Royal Blood"]          = "rbxassetid://6532134724",
    ["Borock's Rage"]                      = "rbxassetid://3236842542",
    ["Ud'zal's Summoning"]                 = "rbxassetid://3303161675",
    ["Y"]                                  = "rbxassetid://4349285876",
    ["Swan Dance"]                         = "rbxassetid://7465997989",
    ["Louder"]                             = "rbxassetid://3338083565",
    ["Up and Down - Twenty One"]           = "rbxassetid://7422797678",
    ["Swish"]                              = "rbxassetid://3361481910",
    ["Drummer Moves - Twenty One"]         = "rbxassetid://7422527690",
    ["Sneaky"]                             = "rbxassetid://3334424322",
    ["Heisman Pose"]                       = "rbxassetid://3695263073",
    ["Jacks"]                              = "rbxassetid://3338066331",
    ["Cha-Cha2"]                           = "rbxassetid://3695322025",
    ["Superhero Reveal"]                   = "rbxassetid://3695373233",
    ["Air Guitar"]                         = "rbxassetid://3695300085",
    ["Dismissive Wave"]                    = "rbxassetid://3333272779",
    ["Country Line Dance - Lil Nas X"]     = "rbxassetid://5915712534",
    ["Salute"]                             = "rbxassetid://3333474484",
    ["Applaud"]                            = "rbxassetid://5915693819",
    ["Hwaiting"]                           = "rbxassetid://9527885267",
    ["Annyeong"]                           = "rbxassetid://9527883498",
    ["Bunny Hop"]                          = "rbxassetid://4641985101",
    ["Sandwich Dance"]                     = "rbxassetid://4406555273",
    ["Hyperfast 5G Dance Move"]            = "rbxassetid://9408617181",
    ["Victory - 24kGoldn"]                 = "rbxassetid://9178377686",
    ["Tantrum"]                            = "rbxassetid://5104341999",
    ["RockStar - Royal Blood"]             = "rbxassetid://10714400171",
    ["Drum Solo - Royal Blood"]            = "rbxassetid://6532839007",
    ["DrumMaster - Royal Blood"]           = "rbxassetid://6531483720",
    ["High Hands"]                         = "rbxassetid://9710985298",
    ["Tilt"]                               = "rbxassetid://3334538554",
    ["Gashina - SUNMI"]                    = "rbxassetid://9527886709",
    ["Chicken Dance"]                      = "rbxassetid://4841399916",
    ["You can't sit with us"]              = "rbxassetid://9983520970",
    ["Frosty Flair - Tommy Hilfiger"]      = "rbxassetid://10214311282",
    ["Floor Rock Freeze - Tommy Hilfiger"] = "rbxassetid://10214314957",
    ["Boom Boom Clap - George Ezra"]       = "rbxassetid://10370346995",
    ["Cartwheel - George Ezra"]            = "rbxassetid://10370351535",
    ["Chill Vibes - George Ezra"]          = "rbxassetid://10370353969",
    ["Sidekicks - George Ezra"]            = "rbxassetid://10370362157",
    ["The Conductor - George Ezra"]        = "rbxassetid://10370359115",
    ["Super Charge"]                       = "rbxassetid://10478338114",
    ["Swag Walk"]                          = "rbxassetid://10478341260",
    ["Mean Mug - Tommy Hilfiger"]          = "rbxassetid://10214317325",
    ["V Pose - Tommy Hilfiger"]            = "rbxassetid://10214319518",
    ["Uprise - Tommy Hilfiger"]            = "rbxassetid://10275008655",
    ["2 Baddies - NCT 127"]                = "rbxassetid://12259828678",
    ["Kick It - NCT 127"]                  = "rbxassetid://12259826609",
    ["Sticker - NCT 127"]                  = "rbxassetid://12259825026",
    ["Elton John - Rock Out"]              = "rbxassetid://11753474067",
    ["Elton John - Heart Skip"]            = "rbxassetid://11309255148",
    ["Elton John - Still Standing"]        = "rbxassetid://11444443576",
    ["Elton John - Elevate"]               = "rbxassetid://11394033602",
    ["Elton John - Cat Man"]               = "rbxassetid://11444441914",
    ["Elton John - Piano Jump"]            = "rbxassetid://11453082181",
    ["Alo Yoga - Triangle"]                = "rbxassetid://12507084541",
    ["Alo Yoga - Warrior II"]              = "rbxassetid://12507083048",
    ["Alo Yoga - Lotus Position"]          = "rbxassetid://12507085924",
    ["TWICE - Moonlight Sunrise"]          = "rbxassetid://12714233242",
    ["TWICE - Set Me Free 1"]              = "rbxassetid://12714228341",
    ["TWICE - Set Me Free 2"]              = "rbxassetid://12714231087",
    ["Ay-Yo - NCT 127"]                    = "rbxassetid://12804157977",
    ["TWICE - The Feels"]                  = "rbxassetid://12874447851",
    ["Zombie"]                             = "rbxassetid://10714089137",
    ["Rise Above - Chainsmokers"]          = "rbxassetid://12992262118",
    ["TWICE - What Is Love"]               = "rbxassetid://13327655243",
    ["Man City - Bicycle Kick"]            = "rbxassetid://13421057998",
    ["TWICE - Fancy"]                      = "rbxassetid://13520524517",
    ["TWICE Pop by Nayeon"]                = "rbxassetid://13768941455",
    ["Tommy - Archer"]                     = "rbxassetid://13823324057",
    ["Man City Backflip"]                  = "rbxassetid://13694100677",
    ["Man City - Scorpion Kick"]           = "rbxassetid://13694096724",
    ["Arm Twist"]                          = "rbxassetid://10713968716",
    ["YUNGBLUD - HIGH KICK"]               = "rbxassetid://14022936101",
    ["TWICE Like Ooh-Ahh"]                 = "rbxassetid://14123781004",
    ["Baby Queen - Air Guitar"]            = "rbxassetid://14352335202",
    ["Baby Queen - Dramatic Bow"]          = "rbxassetid://14352337694",
    ["Baby Queen - Face Frame"]            = "rbxassetid://14352340648",
    ["Baby Queen - Strut"]                 = "rbxassetid://14352362059",
    ["BLACKPINK - Pink Venom 1"]           = "rbxassetid://14548619594",
    ["BLACKPINK - Pink Venom 2"]           = "rbxassetid://14548620495",
    ["BLACKPINK - Pink Venom 3"]           = "rbxassetid://14548621256",
    ["TWICE LIKEY"]                        = "rbxassetid://14899979575",
    ["TWICE Feel Special"]                 = "rbxassetid://14899980745",
    ["BLACKPINK Shut Down 1"]              = "rbxassetid://14901306096",
    ["BLACKPINK Shut Down 2"]              = "rbxassetid://14901308987",
    ["Bone Chillin Bop"]                   = "rbxassetid://15122972413",
    ["Paris Hilton - Sliving"]             = "rbxassetid://15392759696",
    ["Paris Hilton - Iconic IT"]           = "rbxassetid://15392756794",
    ["BLACKPINK JISOO Flower"]             = "rbxassetid://15439354020",
    ["BLACKPINK JENNIE You and Me"]        = "rbxassetid://15439356296",
    ["Rock n Roll"]                        = "rbxassetid://15505458452",
    ["Air Guitar 2"]                       = "rbxassetid://15505454268",
    ["Victory Dance"]                      = "rbxassetid://15505456446",
    ["Flex Walk"]                          = "rbxassetid://15505459811",
    ["Olivia Rodrigo Head Bop"]            = "rbxassetid://15517864808",
    ["Olivia Rodrigo good 4u"]             = "rbxassetid://15517862739",
    ["Olivia Rodrigo Fall Back"]           = "rbxassetid://15549124879",
    ["Nicki Minaj - Super Bass"]           = "rbxassetid://15571446961",
    ["Nicki Minaj - Boom Boom"]            = "rbxassetid://15571448688",
    ["Nicki Minaj - Anaconda"]             = "rbxassetid://15571450952",
    ["Nicki Minaj - Starships"]            = "rbxassetid://15571453761",
    ["Yungblud Happier Jump"]              = "rbxassetid://15609995579",
    ["Festive Dance"]                      = "rbxassetid://15679621440",
    ["BLACKPINK LISA Money"]               = "rbxassetid://15679623052",
    ["BLACKPINK ROSE On The Ground"]       = "rbxassetid://15679624464",
    ["Imagine Dragons Bones"]              = "rbxassetid://15689279687",
    ["GloRilla Tomorrow"]                  = "rbxassetid://15689278184",
    ["d4vd Backflip"]                      = "rbxassetid://15693621070",
    ["ericdoa dance"]                      = "rbxassetid://15698402762",
    ["Cuco Levitate"]                      = "rbxassetid://15698404340",
    ["Mean Girls Dance Break"]             = "rbxassetid://15963314052",
    ["BLACKPINK Ice Cream"]                = "rbxassetid://16181797368",
    ["BLACKPINK Kill This Love"]           = "rbxassetid://16181798319",
    ["TWICE I GOT YOU 1"]                  = "rbxassetid://16215030041",
    ["TWICE I GOT YOU 2"]                  = "rbxassetid://16256203246",
    ["Dave's Spin - Glass Animals"]        = "rbxassetid://16272432203",
    ["Sol de Janeiro - Samba"]             = "rbxassetid://16270690701",
    ["Skadoosh - Kung Fu Panda 4"]         = "rbxassetid://16371217304",
    ["Jawny - Stomp"]                      = "rbxassetid://16392075853",
    ["Mae Stephens - Piano Hands"]         = "rbxassetid://16553163212",
    ["BLACKPINK Boombayah"]                = "rbxassetid://16553164850",
    ["BLACKPINK DDU-DU-DU"]                = "rbxassetid://16553170471",
    ["HIPMOTION - Amaarae"]                = "rbxassetid://16572740012",
    ["Mae Stephens - Arm Wave"]            = "rbxassetid://16584481352",
    ["Wanna play?"]                        = "rbxassetid://16646423316",
    ["BLACKPINK How You Like That"]        = "rbxassetid://16874470507",
    ["BLACKPINK Lovesick Girls"]           = "rbxassetid://16874472321",
    ["MiniKong"]                           = "rbxassetid://17000021306",
    ["HUGO Let's Drive!"]                  = "rbxassetid://17360699557",
    ["Wisp - Air Guitar"]                  = "rbxassetid://17370775305",
    ["Vans Ollie"]                         = "rbxassetid://18305395285",
    ["Sturdy Dance - Ice Spice"]           = "rbxassetid://17746180844",
    ["Shuffle"]                            = "rbxassetid://17748314784",
    ["Rolling Stones Guitar Strum"]        = "rbxassetid://18148804340",
    ["Rock Out - Bebe Rexha"]              = "rbxassetid://18225053113",
    ["SpongeBob Imaginaaation"]            = "rbxassetid://18443237526",
    ["SpongeBob Dance"]                    = "rbxassetid://18443245017",
    ["Shrek Roar"]                         = "rbxassetid://18524313628",
    ["Team USA Breaking Emote"]            = "rbxassetid://18526288497",
    ["NBA WNBA Fadeaway"]                  = "rbxassetid://18526362841",
    ["Vroom Vroom"]                        = "rbxassetid://18526397037",
    ["TMNT Dance"]                         = "rbxassetid://18665811005",
    ["Olympic Dismount"]                   = "rbxassetid://18665825805",
    ["BLACKPINK As If It's Your Last"]     = "rbxassetid://18855536648",
    ["BLACKPINK Don't Know What To Do"]    = "rbxassetid://18855531354",
    ["TWICE ABCD by Nayeon"]               = "rbxassetid://18933706381",
    ["Charli xcx - Apple Dance"]           = "rbxassetid://18946844622",
    -- ── Plantillas — añade más aquí ───────────────────────────
    -- ["MiAnimacion"] = "rbxassetid://",
}

-- Custom animations saved locally (loaded from file on startup)
local CUSTOM_ANIM_FILE = "symbolhit_animations.json"
local CustomAnimations = {} -- { name = id, ... }

local function SaveCustomAnimations()
    local ok = pcall(function()
        writefile(CUSTOM_ANIM_FILE, HttpService:JSONEncode(CustomAnimations))
    end)
    return ok
end

local function LoadCustomAnimations()
    local ok, data = pcall(function()
        return HttpService:JSONDecode(readfile(CUSTOM_ANIM_FILE))
    end)
    if ok and type(data) == "table" then
        CustomAnimations = data
    end
end

LoadCustomAnimations()

-- Merge custom anims into ANIM_DB at load time
local function RebuildAnimDB()
    for name, id in pairs(CustomAnimations) do
        ANIM_DB[name] = id
    end
end
RebuildAnimDB()

-- Build sorted name list: all built-ins first (sorted), then custom
local function GetAnimNames()
    local builtInSet = {}
    for n, _ in pairs(ANIM_DB) do
        if not CustomAnimations[n] then
            table.insert(builtInSet, n)
        end
    end
    table.sort(builtInSet)
    local out = {}
    for _, n in ipairs(builtInSet) do table.insert(out, n) end
    for n, _ in pairs(CustomAnimations) do table.insert(out, n) end
    return out
end


-- Animation Forcer — plays + holds an animation, kills others on frame
local ActiveForcer = nil

local AnimationForcer = {}
AnimationForcer.__index = AnimationForcer

function AnimationForcer.new(assetId)
    local self       = setmetatable({}, AnimationForcer)
    self.assetId     = assetId
    self.active      = false
    self.track       = nil
    self.connections = {}
    return self
end

function AnimationForcer:force()
    if self.active then return end
    self.active = true

    local char = LocalPlayer.Character
    if not char then char = LocalPlayer.CharacterAdded:Wait() end

    local humanoid = char:FindFirstChildOfClass("Humanoid")
    local animator = humanoid and humanoid:FindFirstChildOfClass("Animator")
    if not (humanoid and animator) then
        self.active = false; return
    end

    local anim = Instance.new("Animation")
    anim.AnimationId = self.assetId
    anim.Parent = workspace -- needs a parent to load

    local ok, track = pcall(function()
        return animator:LoadAnimation(anim)
    end)
    anim:Destroy()

    if not ok or not track then
        self.active = false
        return
    end

    track.Priority = Enum.AnimationPriority.Action4
    track.Looped   = true
    track:Play()
    self.track = track

    local conn
    conn = RunService.RenderStepped:Connect(function()
        if not self.active then
            conn:Disconnect(); return
        end
        local c = LocalPlayer.Character
        if not c or not c.Parent then
            conn:Disconnect(); return
        end
        -- Keep our track playing and apply speed
        local spd = math.clamp(Opt('AnimSpeed', 1.0), 0.1, 5.0)
        if track then
            pcall(function() track.Speed = spd end)
            if not track.IsPlaying then
                pcall(function() track:Play() end)
            end
        end
        -- Stop all other tracks
        local anim2 = humanoid and humanoid:FindFirstChildOfClass("Animator")
        if anim2 then
            for _, t in ipairs(anim2:GetPlayingAnimationTracks()) do
                if t ~= track then
                    pcall(function() t:Stop(0) end)
                end
            end
        end
    end)
    table.insert(self.connections, conn)
end

function AnimationForcer:stop()
    self.active = false
    for _, c in ipairs(self.connections) do pcall(function() c:Disconnect() end) end
    self.connections = {}
    if self.track then
        pcall(function() self.track:Stop() end)
        self.track = nil
    end
end

local function StopCurrentAnimation()
    if ActiveForcer then
        ActiveForcer:stop()
        ActiveForcer = nil
    end
end

local function PlayAnimationById(assetId)
    StopCurrentAnimation()
    local f = AnimationForcer.new(assetId)
    ActiveForcer = f
    task.spawn(function() f:force() end)
end

-- Character respawn: stop forcer so it doesn't ghost
LocalPlayer.CharacterAdded:Connect(function()
    if ActiveForcer then
        ActiveForcer.active = false; ActiveForcer = nil
    end
end)

-- IsUnlocked always returns true — exclusivity removed
local function IsUnlocked() return true end

-- ============================================================
-- GLOBAL STATE
-- ============================================================
local TargetStrafeActive = false
local CurrentTarget      = nil
local FocusTarget        = nil -- manual lock, overrides auto-select
local FriendList         = {}  -- { [username] = true } — never targeted

local FRIEND_FILE        = "symbolhit_friends.json"

local function saveFriendList()
    pcall(function()
        local arr = {}
        for name in pairs(FriendList) do table.insert(arr, name) end
        writefile(FRIEND_FILE, game:GetService("HttpService"):JSONEncode(arr))
    end)
end

local function loadFriendList()
    pcall(function()
        local ok, data = pcall(function()
            return game:GetService("HttpService"):JSONDecode(readfile(FRIEND_FILE))
        end)
        if ok and type(data) == "table" then
            FriendList = {}
            for _, name in ipairs(data) do FriendList[name] = true end
        end
    end)
end

loadFriendList()
local State             = {
    OriginalPosition      = nil,
    StrafeAngle           = 0,
    SpectateActive        = false,
    OriginalCameraSubject = nil,
    LastResolverUpdate    = 0,
    ForgivenessValues     = {},
    VelocityHistory       = {},
    CertaintyLevel        = 0,
    ClusterData           = {},
    VoidSpamCFrame        = CFrame.new(),
    LastBaitTime          = 0,
    InVoid                = false,
    DesyncLocation        = CFrame.new(),
    DesyncPrevLook        = nil,
    DesyncSpinning        = false,
    StrafeFinalCFrame     = CFrame.new(),
    StrafeFinalReady      = false,
    VoidFlashCFrame       = CFrame.new(),
    VoidFlashReady        = false,
    LastAutoFireTime      = 0,
    LastTriggerbotTime    = 0,
    _ffWatchConns         = {}, -- [playerName] = connection watching FF removal
    SpectateFrozen        = false,  -- camera frozen after target died, waiting for respawn
    SpectateWasTarget     = nil,    -- player we were spectating when frozen
    SpectateFrozenCF      = nil,    -- camera CFrame at the moment of freeze
    SpectateFrozenAnchor  = nil,    -- Part anclada usada como CameraSubject durante el freeze
}

local function watchFFRemoval(target)
    if not target or not target.Character then return end
    local name = target.Name
    local char = target.Character
    if State._ffWatchConns[name] then State._ffWatchConns[name]:Disconnect() end
    local ff = char:FindFirstChildOfClass("ForceField")
    if not ff then return end
    State._ffWatchConns[name] = ff.AncestryChanged:Connect(function(_, parent)
        if parent ~= nil then return end -- still exists

        -- Consistency check: avoid burst firing if the character died/respawned
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not char.Parent or not hum or hum.Health <= 0 then
            if State._ffWatchConns[name] then
                State._ffWatchConns[name]:Disconnect(); State._ffWatchConns[name] = nil
            end
            return
        end

        if State._ffWatchConns[name] then
            State._ffWatchConns[name]:Disconnect(); State._ffWatchConns[name] = nil
        end
        if not Tog('AutoFireOnFFRemove') then return end
        if CurrentTarget ~= target then return end
        -- FF just removed — burst fire
        local rate   = Opt('AutoFireRate', 10)
        local bursts = math.clamp(Opt('FFBurstCount', 5), 1, 30)
        for i = 1, bursts do
            task.delay((i - 1) / math.max(rate, 1), function()
                if not Tog('AutoFireOnFFRemove') then return end
                local tRoot = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
                if tRoot then
                    local sp = Camera:WorldToViewportPoint(tRoot.Position)
                    if sp.Z > 0 then mouse1click() end
                end
            end)
        end
        Library:Notify("⚡ FF removido — ráfaga autofire en " .. name)
    end)
end

-- ============================================================
-- AURA SYSTEM  (multi-layer: particle / light / highlight /
--               fire / smoke / sparkles / trail / beam)
-- ============================================================
local _auraActive   = false
local _auraObjects  = {}   -- all created Instances (for cleanup)
local _auraConns    = {}   -- event connections
local _auraAnimated = {}   -- {fn=function(t) ... end} per-frame handlers
local AURA_CONFIGS          -- forward declaration (defined later in file)

-- Scale a NumberSequence's keypoint values by mult (for AuraSize slider)
local function _nsScale(ns, mult)
    if math.abs(mult - 1) < 0.001 then return ns end
    local kps = {}
    for _, kp in ipairs(ns.Keypoints) do
        table.insert(kps, NumberSequenceKeypoint.new(kp.Time, kp.Value * mult, kp.Envelope * mult))
    end
    return NumberSequence.new(kps)
end

-- Resolve body part by name (handles R6/R15)
local function _getAuraPart(char, name)
    if name == "head"  then return char:FindFirstChild("Head") end
    if name == "torso" then return char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") end
    return char:FindFirstChild("HumanoidRootPart")  -- default: "hrp" or unknown
end

local function StopAura()
    _auraActive   = false
    _auraAnimated = {}
    for _, c in ipairs(_auraConns) do pcall(function() c:Disconnect() end) end
    _auraConns = {}
    for _, obj in ipairs(_auraObjects) do pcall(function() obj:Destroy() end) end
    _auraObjects = {}
end

local function _applyAura(presetName)
    local char = LocalPlayer.Character
    if not char then return end
    local configs = AURA_CONFIGS[presetName]
    if not configs then return end

    local iMult = (Options and Options.AuraIntensity and Options.AuraIntensity.Value) or 1.0
    local sMult = (Options and Options.AuraSize      and Options.AuraSize.Value)      or 1.0

    for _, layer in ipairs(configs) do
        local part = _getAuraPart(char, layer.part or "hrp")
        if not part then continue end
        local t = layer.type

        if t == "particle" then
            local att = Instance.new("Attachment")
            att.Position = layer.offset or Vector3.new(0, 0, 0)
            att.Parent   = part
            table.insert(_auraObjects, att)
            local pe = Instance.new("ParticleEmitter")
            pe.Rate           = math.max(1, (layer.rate or 25) * iMult)
            pe.Lifetime       = layer.lifetime or NumberRange.new(0.5, 1.5)
            pe.Speed          = layer.speed    or NumberRange.new(2, 7)
            pe.Size           = _nsScale(layer.size or NumberSequence.new({NumberSequenceKeypoint.new(0,0.5),NumberSequenceKeypoint.new(1,0)}), sMult)
            pe.Transparency   = layer.transparency or NumberSequence.new({NumberSequenceKeypoint.new(0,0.3),NumberSequenceKeypoint.new(1,1)})
            pe.Color          = layer.color or ColorSequence.new(Color3.fromRGB(255,255,255))
            pe.LightEmission  = layer.lightEmission or 0.7
            pe.LightInfluence = 0
            pe.SpreadAngle    = layer.spread  or Vector2.new(180, 180)
            pe.Rotation       = NumberRange.new(0, 360)
            pe.RotSpeed       = layer.rotSpeed or NumberRange.new(-120, 120)
            pe.WindAffectsDrag = false
            if layer.texture and layer.texture ~= "" then pe.Texture = layer.texture end
            pe.Parent = att
            table.insert(_auraObjects, pe)

        elseif t == "light" then
            local lt = Instance.new("PointLight")
            lt.Brightness = math.clamp((layer.brightness or 3) * iMult, 0, 20)
            lt.Range      = math.clamp((layer.range or 16) * sMult, 1, 60)
            lt.Color      = layer.color or Color3.fromRGB(255, 255, 255)
            lt.Parent     = part
            table.insert(_auraObjects, lt)
            if layer.pulse then
                local base = layer.brightness or 3
                local freq = layer.pulseFreq  or 1
                local amp  = layer.pulseAmp   or 1.5
                table.insert(_auraAnimated, {fn = function(tk)
                    lt.Brightness = math.clamp((base + math.sin(tk * freq * math.pi * 2) * amp) * iMult, 0, 20)
                end})
            elseif layer.colorCycle then
                local speed  = layer.cycleSpeed or 0.3
                local bBrt   = math.clamp((layer.brightness or 3) * iMult, 0, 20)
                table.insert(_auraAnimated, {fn = function(tk)
                    lt.Color      = Color3.fromHSV((tk * speed) % 1, 1, 1)
                    lt.Brightness = bBrt
                end})
            end

        elseif t == "highlight" then
            local hl = Instance.new("Highlight")
            hl.FillColor           = layer.fillColor    or Color3.fromRGB(255, 255, 255)
            hl.OutlineColor        = layer.outlineColor or Color3.fromRGB(255, 255, 255)
            hl.FillTransparency    = layer.fillTransparency   or 0.7
            hl.OutlineTransparency = layer.outlineTransparency or 0
            hl.DepthMode           = Enum.HighlightDepthMode.Occluded
            hl.Parent = char
            table.insert(_auraObjects, hl)
            if layer.colorCycle then
                local speed = layer.cycleSpeed or 0.3
                table.insert(_auraAnimated, {fn = function(tk)
                    local hue = (tk * speed) % 1
                    hl.FillColor    = Color3.fromHSV(hue, 0.85, 1)
                    hl.OutlineColor = Color3.fromHSV((hue + 0.15) % 1, 1, 1)
                end})
            end

        elseif t == "fire" then
            local f = Instance.new("Fire")
            f.Heat = math.clamp((layer.heat or 8) * iMult, 1, 25)
            f.Size = math.clamp((layer.size or 5) * sMult, 0.1, 30)
            if layer.color          then f.Color          = layer.color end
            if layer.secondaryColor then f.SecondaryColor = layer.secondaryColor end
            f.Parent = part
            table.insert(_auraObjects, f)

        elseif t == "smoke" then
            local s = Instance.new("Smoke")
            s.Opacity = math.clamp((layer.opacity or 0.4) * iMult, 0, 1)
            s.Rise    = layer.rise or 1
            s.Size    = math.clamp((layer.size or 1) * sMult, 0.01, 100)
            if layer.color then s.Color = layer.color end
            s.Parent = part
            table.insert(_auraObjects, s)

        elseif t == "sparkles" then
            local sp = Instance.new("Sparkles")
            if layer.color then sp.SparkleColor = layer.color end
            sp.Parent = part
            table.insert(_auraObjects, sp)

        elseif t == "trail" then
            local attA = Instance.new("Attachment")
            attA.Position = layer.offsetA or Vector3.new(0,  1, 0)
            attA.Parent   = part
            table.insert(_auraObjects, attA)
            local attB = Instance.new("Attachment")
            attB.Position = layer.offsetB or Vector3.new(0, -1, 0)
            attB.Parent   = part
            table.insert(_auraObjects, attB)
            local tr = Instance.new("Trail")
            tr.Attachment0           = attA
            tr.Attachment1           = attB
            tr.Lifetime              = layer.lifetime or 0.5
            tr.Color                 = layer.color or ColorSequence.new(Color3.fromRGB(255,255,255))
            tr.Transparency          = layer.transparency or NumberSequence.new({NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(1,1)})
            tr.WidthScale            = layer.widthScale or NumberSequence.new({NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(1,0)})
            tr.LightEmission         = layer.lightEmission or 0.5
            tr.LightInfluence        = 0
            tr.MinStudsBetweenPoints = 0
            tr.FaceCamera            = true
            if layer.texture and layer.texture ~= "" then tr.Texture = layer.texture end
            tr.Parent = part
            table.insert(_auraObjects, tr)

        elseif t == "beam" then
            local attA = Instance.new("Attachment")
            attA.Position = layer.offsetA or Vector3.new(-2, 0, 0)
            attA.Parent   = part
            table.insert(_auraObjects, attA)
            local attB = Instance.new("Attachment")
            attB.Position = layer.offsetB or Vector3.new(2, 0, 0)
            attB.Parent   = part
            table.insert(_auraObjects, attB)
            local bm = Instance.new("Beam")
            bm.Attachment0    = attA
            bm.Attachment1    = attB
            bm.Color          = layer.color or ColorSequence.new(Color3.fromRGB(255,255,255))
            bm.LightEmission  = layer.lightEmission or 1
            bm.LightInfluence = 0
            bm.Transparency   = layer.transparency or NumberSequence.new({NumberSequenceKeypoint.new(0,0.2),NumberSequenceKeypoint.new(1,0.2)})
            bm.Width0         = math.clamp((layer.width0 or 0.3) * sMult, 0.01, 5)
            bm.Width1         = math.clamp((layer.width1 or 0.3) * sMult, 0.01, 5)
            bm.Segments       = layer.segments or 10
            bm.FaceCamera     = true
            if layer.texture and layer.texture ~= "" then
                bm.Texture       = layer.texture
                bm.TextureLength = layer.textureLength or 1
                bm.TextureSpeed  = layer.textureSpeed  or 1
            end
            bm.Parent = part
            table.insert(_auraObjects, bm)
        end
    end
end

local function StartAura(presetName)
    StopAura()
    if not presetName or presetName == "Sin Aura" or not AURA_CONFIGS[presetName] then return end
    _auraActive = true
    _applyAura(presetName)

    -- Per-frame animation loop (pulsing lights, color cycling)
    local animConn = RunService.Heartbeat:Connect(function()
        if not _auraActive then return end
        local tk = tick()
        for _, anim in ipairs(_auraAnimated) do pcall(anim.fn, tk) end
    end)
    table.insert(_auraConns, animConn)

    -- Rebuild on respawn (animConn stays alive across respawns)
    local respawnConn = LocalPlayer.CharacterAdded:Connect(function()
        task.wait(0.5)
        if not _auraActive then return end
        for _, obj in ipairs(_auraObjects) do pcall(function() obj:Destroy() end) end
        _auraObjects  = {}
        _auraAnimated = {}
        _applyAura(presetName)
    end)
    table.insert(_auraConns, respawnConn)
end


local HitNotifList           = {}
local HitChamList            = {}

local BacktrackHistory       = {}
local IdleStateActive        = false
local IdleStateTarget        = nil    -- the dead target we're waiting for
local IdleOrigin             = nil    -- position we were at when idle started
local IDLE_RANGE             = 200000 -- ±XZ range for random teleport
local IDLE_BASE_Y            = 700000 -- fixed Y altitude
local AggressiveFreezeEnd    = 0
local AggressiveFrozenStates = {}     -- [playerName] = { root, frozenCF, until_t }
local FlingHistory           = {}     -- [playerName] = tick()
local _deathDebounce         = {}     -- [playerName] = tick() — evita doble detección de muerte
-- Aggressive BT timing is now driven by UI sliders (AggrBTCooldown / AggrBTDuration)
-- These constants are fallback defaults only
local AGGR_BT_COOLDOWN_DEF   = 1.2
local AGGR_BT_DURATION_DEF   = 0.25

-- ============================================================
-- VISUAL CONSTANTS
-- ============================================================

local BEAM_TRACER_TEXTURES = {
    ["Solido"]  = "",
    ["Trueno"]  = "rbxassetid://6401544600",
    ["Pulso"]   = "rbxassetid://448100188",
    ["ADN"]     = "rbxassetid://22636887",
    ["Helice"]  = "rbxassetid://284895971",
    ["Cadena"]  = "rbxassetid://73834875",
    ["Laser"]   = "rbxassetid://1295553935",
}
local BEAM_TRACER_NAMES = {"Solido","Trueno","Pulso","ADN","Helice","Cadena","Laser"}

local PARTICLE_STYLE_NAMES = {"Chispas","Fuego","Electrico","Sangre","Cristal","Humo"}

local PARTICLE_STYLE_CFGS = {
    ["Chispas"] = {
        color = ColorSequence.new({
            ColorSequenceKeypoint.new(0,   Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(0.3, Color3.fromRGB(80,  210, 255)),
            ColorSequenceKeypoint.new(1,   Color3.fromRGB(0,   80,  180)),
        }),
        lightEmission = 1, size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.5), NumberSequenceKeypoint.new(0.5, 0.25), NumberSequenceKeypoint.new(1, 0),
        }),
        speed = NumberRange.new(14, 32), lifetime = NumberRange.new(0.15, 0.6),
        spread = Vector2.new(180, 180), count = 90,
        texture = "rbxasset://textures/particles/sparkles_main.dds",
    },
    ["Fuego"] = {
        color = ColorSequence.new({
            ColorSequenceKeypoint.new(0,   Color3.fromRGB(255, 255, 100)),
            ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255, 100, 0)),
            ColorSequenceKeypoint.new(1,   Color3.fromRGB(80,  0,   0)),
        }),
        lightEmission = 1, size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1.2), NumberSequenceKeypoint.new(0.5, 0.7), NumberSequenceKeypoint.new(1, 0),
        }),
        speed = NumberRange.new(8, 22), lifetime = NumberRange.new(0.3, 0.9),
        spread = Vector2.new(30, 30), count = 55,
        texture = "rbxasset://textures/particles/fire_main.dds",
    },
    ["Electrico"] = {
        color = ColorSequence.new({
            ColorSequenceKeypoint.new(0,   Color3.fromRGB(200, 240, 255)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0,   160, 255)),
            ColorSequenceKeypoint.new(1,   Color3.fromRGB(0,   40,  200)),
        }),
        lightEmission = 1, size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.25), NumberSequenceKeypoint.new(0.5, 0.12), NumberSequenceKeypoint.new(1, 0),
        }),
        speed = NumberRange.new(22, 55), lifetime = NumberRange.new(0.1, 0.45),
        spread = Vector2.new(180, 180), count = 110,
        texture = "rbxasset://textures/particles/sparkles_main.dds",
    },
    ["Sangre"] = {
        color = ColorSequence.new({
            ColorSequenceKeypoint.new(0,   Color3.fromRGB(255, 0,   0)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(180, 0,   0)),
            ColorSequenceKeypoint.new(1,   Color3.fromRGB(80,  0,   0)),
        }),
        lightEmission = 0.1, size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.35), NumberSequenceKeypoint.new(0.5, 0.2), NumberSequenceKeypoint.new(1, 0.05),
        }),
        speed = NumberRange.new(5, 16), lifetime = NumberRange.new(0.4, 1.1),
        spread = Vector2.new(180, 180), count = 65,
        texture = "rbxasset://textures/particles/smoke_main.dds",
        transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.2), NumberSequenceKeypoint.new(1, 1),
        }),
    },
    ["Cristal"] = {
        color = ColorSequence.new({
            ColorSequenceKeypoint.new(0,   Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(200, 220, 255)),
            ColorSequenceKeypoint.new(1,   Color3.fromRGB(100, 150, 255)),
        }),
        lightEmission = 0.9, size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.6), NumberSequenceKeypoint.new(0.3, 0.3), NumberSequenceKeypoint.new(1, 0),
        }),
        speed = NumberRange.new(16, 38), lifetime = NumberRange.new(0.2, 0.9),
        spread = Vector2.new(180, 180), count = 95,
        texture = "rbxasset://textures/particles/sparkles_main.dds",
    },
    ["Humo"] = {
        color = ColorSequence.new({
            ColorSequenceKeypoint.new(0,   Color3.fromRGB(20,  20,  20)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(60,  60,  60)),
            ColorSequenceKeypoint.new(1,   Color3.fromRGB(100, 100, 100)),
        }),
        lightEmission = 0, size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.6), NumberSequenceKeypoint.new(0.5, 1.8), NumberSequenceKeypoint.new(1, 0),
        }),
        speed = NumberRange.new(2, 9), lifetime = NumberRange.new(0.9, 2.2),
        spread = Vector2.new(30, 30), count = 40,
        texture = "rbxasset://textures/particles/smoke_main.dds",
    },
}

local AURA_PRESET_NAMES = {
    "Sin Aura",
    "Fuego Infernal",
    "Tormenta Eléctrica",
    "Sombra Oscura",
    "Divino",
    "Demonio Rojo",
    "Hielo Eterno",
    "Tóxico",
    "Prisma",
    "Alas de Fuego",
    "Void Eternal",
    "Neon Cyberpunk",
}

-- ──────────────────────────────────────────────────────────────
-- AURA CONFIGS  — each preset is a list of layers.
-- Layer fields:
--   type    : "particle"|"light"|"highlight"|"fire"|"smoke"|"sparkles"|"trail"|"beam"
--   part    : "hrp" (default) | "head" | "torso"
-- ──────────────────────────────────────────────────────────────
AURA_CONFIGS = {   -- assignment to forward-declared upvalue above
    ["Sin Aura"] = nil,

    -- ── Fuego Infernal ────────────────────────────────────────
    ["Fuego Infernal"] = {
        -- Legacy Fire core (most visible burst of flame)
        { type="fire", part="hrp",
          heat=9, size=8,
          color=Color3.fromRGB(255,60,0), secondaryColor=Color3.fromRGB(255,210,50) },
        -- Ember scatter (fast, omnidirectional sparks)
        { type="particle", part="hrp", offset=Vector3.new(0,-1,0),
          rate=55, lifetime=NumberRange.new(0.3,1.0), speed=NumberRange.new(5,20),
          spread=Vector2.new(180,180), lightEmission=1.0,
          size=NumberSequence.new({NumberSequenceKeypoint.new(0,0.22),NumberSequenceKeypoint.new(0.5,0.11),NumberSequenceKeypoint.new(1,0)}),
          color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(255,255,180)),ColorSequenceKeypoint.new(1,Color3.fromRGB(255,100,0))}),
          texture="rbxasset://textures/particles/sparkles_main.dds",
          transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(1,1)}) },
        -- Ash smoke rising
        { type="smoke", part="hrp", opacity=0.22, rise=2, size=2.5, color=Color3.fromRGB(40,18,8) },
        -- Pulsing orange PointLight
        { type="light", part="hrp", brightness=3, range=22, color=Color3.fromRGB(255,120,0),
          pulse=true, pulseFreq=1.2, pulseAmp=2.5 },
        -- Orange body highlight
        { type="highlight", fillColor=Color3.fromRGB(255,70,0), outlineColor=Color3.fromRGB(255,220,50),
          fillTransparency=0.75, outlineTransparency=0 },
    },

    -- ── Tormenta Eléctrica ────────────────────────────────────
    ["Tormenta Eléctrica"] = {
        -- Built-in Sparkles on HRP + Head (always-on electric shimmer)
        { type="sparkles", part="hrp",  color=Color3.fromRGB(100,200,255) },
        { type="sparkles", part="head", color=Color3.fromRGB(200,240,255) },
        -- Arc particles (very fast, tiny, omnidirectional)
        { type="particle", part="hrp", offset=Vector3.new(0,0,0),
          rate=90, lifetime=NumberRange.new(0.08,0.35), speed=NumberRange.new(15,45),
          spread=Vector2.new(180,180), lightEmission=1.0,
          size=NumberSequence.new({NumberSequenceKeypoint.new(0,0.14),NumberSequenceKeypoint.new(0.5,0.07),NumberSequenceKeypoint.new(1,0)}),
          color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(0.5,Color3.fromRGB(80,200,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(0,100,255))}),
          texture="rbxasset://textures/particles/sparkles_main.dds",
          transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(1,1)}) },
        -- Arc beam between shoulders (thunder texture, fast scroll)
        { type="beam", part="hrp",
          offsetA=Vector3.new(-2,0.5,0), offsetB=Vector3.new(2,0.5,0),
          color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(200,240,255)),ColorSequenceKeypoint.new(0.5,Color3.fromRGB(0,180,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(200,240,255))}),
          lightEmission=1,
          transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0.1),NumberSequenceKeypoint.new(0.5,0.35),NumberSequenceKeypoint.new(1,0.1)}),
          width0=0.14, width1=0.14,
          texture="rbxassetid://6401544600", textureLength=2, textureSpeed=6, segments=20 },
        -- Rapid-flicker blue PointLight (4 Hz → electric strobe)
        { type="light", part="hrp", brightness=4, range=16, color=Color3.fromRGB(100,200,255),
          pulse=true, pulseFreq=4, pulseAmp=3 },
        -- Electric body highlight
        { type="highlight", fillColor=Color3.fromRGB(0,140,255), outlineColor=Color3.fromRGB(200,240,255),
          fillTransparency=0.8, outlineTransparency=0 },
    },

    -- ── Sombra Oscura ─────────────────────────────────────────
    ["Sombra Oscura"] = {
        -- Dense purple-black smoke
        { type="smoke", part="hrp", opacity=0.5, rise=0.4, size=3.2, color=Color3.fromRGB(18,0,28) },
        -- Shadow wisps (slow, large, dark purple)
        { type="particle", part="hrp", offset=Vector3.new(0,0,0),
          rate=32, lifetime=NumberRange.new(1.5,3.0), speed=NumberRange.new(0.5,3),
          spread=Vector2.new(180,180), lightEmission=0.25,
          size=NumberSequence.new({NumberSequenceKeypoint.new(0,0.5),NumberSequenceKeypoint.new(0.5,1.2),NumberSequenceKeypoint.new(1,0)}),
          color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(80,0,100)),ColorSequenceKeypoint.new(0.5,Color3.fromRGB(28,0,44)),ColorSequenceKeypoint.new(1,Color3.fromRGB(4,0,8))}),
          texture="rbxasset://textures/particles/smoke_main.dds",
          transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0.4),NumberSequenceKeypoint.new(0.5,0.1),NumberSequenceKeypoint.new(1,1)}) },
        -- Ground tendrils rising from feet
        { type="particle", part="hrp", offset=Vector3.new(0,-2.5,0),
          rate=18, lifetime=NumberRange.new(1.0,2.2), speed=NumberRange.new(1,4),
          spread=Vector2.new(22,22), lightEmission=0.15,
          size=NumberSequence.new({NumberSequenceKeypoint.new(0,0.3),NumberSequenceKeypoint.new(0.5,0.85),NumberSequenceKeypoint.new(1,0)}),
          color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(50,0,70)),ColorSequenceKeypoint.new(1,Color3.fromRGB(0,0,0))}),
          texture="rbxasset://textures/particles/smoke_main.dds",
          transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0.6),NumberSequenceKeypoint.new(0.5,0.2),NumberSequenceKeypoint.new(1,1)}) },
        -- Dim pulsing purple PointLight (slow, mysterious)
        { type="light", part="hrp", brightness=1.5, range=12, color=Color3.fromRGB(80,0,120),
          pulse=true, pulseFreq=0.45, pulseAmp=1 },
        -- Dark body highlight
        { type="highlight", fillColor=Color3.fromRGB(48,0,68), outlineColor=Color3.fromRGB(110,0,160),
          fillTransparency=0.6, outlineTransparency=0 },
    },

    -- ── Divino ────────────────────────────────────────────────
    ["Divino"] = {
        -- Golden built-in Sparkles
        { type="sparkles", part="hrp",  color=Color3.fromRGB(255,230,100) },
        { type="sparkles", part="head", color=Color3.fromRGB(255,255,200) },
        -- Rising holy light pillars (tight upward beam)
        { type="particle", part="hrp", offset=Vector3.new(0,-1,0),
          rate=45, lifetime=NumberRange.new(1.2,2.6), speed=NumberRange.new(2,7),
          spread=Vector2.new(18,18), lightEmission=1.0,
          size=NumberSequence.new({NumberSequenceKeypoint.new(0,0.28),NumberSequenceKeypoint.new(0.4,0.5),NumberSequenceKeypoint.new(1,0)}),
          color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(255,255,220)),ColorSequenceKeypoint.new(0.5,Color3.fromRGB(255,220,100)),ColorSequenceKeypoint.new(1,Color3.fromRGB(255,255,255))}),
          texture="rbxasset://textures/particles/sparkles_main.dds",
          transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(1,1)}) },
        -- Halo ring particles (horizontal orbit at head level)
        { type="particle", part="head", offset=Vector3.new(0,0.9,0),
          rate=28, lifetime=NumberRange.new(0.9,2.0), speed=NumberRange.new(1.5,3),
          spread=Vector2.new(90,0), lightEmission=1.0,
          size=NumberSequence.new({NumberSequenceKeypoint.new(0,0.38),NumberSequenceKeypoint.new(0.5,0.22),NumberSequenceKeypoint.new(1,0)}),
          color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(0.5,Color3.fromRGB(255,230,150)),ColorSequenceKeypoint.new(1,Color3.fromRGB(255,255,255))}),
          texture="rbxasset://textures/particles/sparkles_main.dds",
          transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(1,1)}) },
        -- Slow golden pulsing PointLight
        { type="light", part="hrp", brightness=5, range=28, color=Color3.fromRGB(255,230,150),
          pulse=true, pulseFreq=0.6, pulseAmp=2 },
        -- Golden body highlight
        { type="highlight", fillColor=Color3.fromRGB(255,200,50), outlineColor=Color3.fromRGB(255,255,200),
          fillTransparency=0.78, outlineTransparency=0 },
    },

    -- ── Demonio Rojo ──────────────────────────────────────────
    ["Demonio Rojo"] = {
        -- Dark crimson Fire
        { type="fire", part="hrp",
          heat=7, size=7,
          color=Color3.fromRGB(170,0,0), secondaryColor=Color3.fromRGB(255,40,0) },
        -- Blood drip particles (thin, slow, downward spread)
        { type="particle", part="hrp", offset=Vector3.new(0,1,0),
          rate=22, lifetime=NumberRange.new(0.7,1.6), speed=NumberRange.new(2,8),
          spread=Vector2.new(18,18), lightEmission=0.08,
          size=NumberSequence.new({NumberSequenceKeypoint.new(0,0.1),NumberSequenceKeypoint.new(0.3,0.22),NumberSequenceKeypoint.new(1,0.04)}),
          color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(220,0,0)),ColorSequenceKeypoint.new(1,Color3.fromRGB(80,0,0))}),
          texture="rbxasset://textures/particles/smoke_main.dds",
          rotSpeed=NumberRange.new(0,0),
          transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0.2),NumberSequenceKeypoint.new(1,1)}) },
        -- Dark charcoal smoke
        { type="smoke", part="hrp", opacity=0.38, rise=0.7, size=2, color=Color3.fromRGB(28,0,0) },
        -- Intense rapid-pulse red PointLight
        { type="light", part="hrp", brightness=4, range=18, color=Color3.fromRGB(255,0,0),
          pulse=true, pulseFreq=2, pulseAmp=3 },
        -- Crimson body highlight
        { type="highlight", fillColor=Color3.fromRGB(170,0,0), outlineColor=Color3.fromRGB(255,40,0),
          fillTransparency=0.72, outlineTransparency=0 },
    },

    -- ── Hielo Eterno ──────────────────────────────────────────
    ["Hielo Eterno"] = {
        -- Cold white sparkles
        { type="sparkles", part="hrp", color=Color3.fromRGB(200,230,255) },
        -- Ice crystal shards (fast, upward spiral feel)
        { type="particle", part="hrp", offset=Vector3.new(0,-1,0),
          rate=42, lifetime=NumberRange.new(0.6,1.8), speed=NumberRange.new(4,12),
          spread=Vector2.new(35,180), lightEmission=0.8,
          size=NumberSequence.new({NumberSequenceKeypoint.new(0,0.07),NumberSequenceKeypoint.new(0.3,0.26),NumberSequenceKeypoint.new(1,0)}),
          color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(0.5,Color3.fromRGB(150,210,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(0,120,200))}),
          texture="rbxasset://textures/particles/sparkles_main.dds",
          transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(1,1)}) },
        -- Frost mist (wide, very slow)
        { type="smoke", part="hrp", opacity=0.22, rise=0.25, size=3.8, color=Color3.fromRGB(200,230,255) },
        -- Frost ground beam (ice crack at feet)
        { type="beam", part="hrp",
          offsetA=Vector3.new(-1,-2.5,0), offsetB=Vector3.new(1,-2.5,0),
          color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(200,240,255)),ColorSequenceKeypoint.new(0.5,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(200,240,255))}),
          lightEmission=0.8,
          transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0.2),NumberSequenceKeypoint.new(0.5,0.55),NumberSequenceKeypoint.new(1,0.2)}),
          width0=0.1, width1=0.1, textureLength=1, textureSpeed=2, segments=10 },
        -- Cool blue pulsing PointLight
        { type="light", part="hrp", brightness=3, range=18, color=Color3.fromRGB(150,210,255),
          pulse=true, pulseFreq=0.75, pulseAmp=1.5 },
        -- Ice blue highlight
        { type="highlight", fillColor=Color3.fromRGB(100,190,255), outlineColor=Color3.fromRGB(255,255,255),
          fillTransparency=0.8, outlineTransparency=0 },
    },

    -- ── Tóxico ────────────────────────────────────────────────
    ["Tóxico"] = {
        -- Thick toxic green smoke
        { type="smoke", part="hrp", opacity=0.5, rise=1, size=3, color=Color3.fromRGB(0,190,25) },
        -- Acid bubble particles (spherical, medium rise)
        { type="particle", part="hrp", offset=Vector3.new(0,0,0),
          rate=32, lifetime=NumberRange.new(0.8,2.2), speed=NumberRange.new(1.5,6),
          spread=Vector2.new(180,180), lightEmission=0.8,
          size=NumberSequence.new({NumberSequenceKeypoint.new(0,0.38),NumberSequenceKeypoint.new(0.5,0.82),NumberSequenceKeypoint.new(1,0)}),
          color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(50,255,50)),ColorSequenceKeypoint.new(0.5,Color3.fromRGB(0,200,0)),ColorSequenceKeypoint.new(1,Color3.fromRGB(0,80,0))}),
          texture="rbxasset://textures/particles/smoke_main.dds",
          transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0.3),NumberSequenceKeypoint.new(0.5,0.05),NumberSequenceKeypoint.new(1,1)}) },
        -- Acid drips (downward from head level)
        { type="particle", part="hrp", offset=Vector3.new(0,1.2,0),
          rate=14, lifetime=NumberRange.new(0.5,1.2), speed=NumberRange.new(3,9),
          spread=Vector2.new(12,12), lightEmission=0.6,
          size=NumberSequence.new({NumberSequenceKeypoint.new(0,0.09),NumberSequenceKeypoint.new(0.3,0.18),NumberSequenceKeypoint.new(1,0)}),
          color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(100,255,0)),ColorSequenceKeypoint.new(1,Color3.fromRGB(0,120,0))}),
          texture="rbxasset://textures/particles/smoke_main.dds",
          transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0.2),NumberSequenceKeypoint.new(1,1)}) },
        -- Sickly green slow-throb PointLight
        { type="light", part="hrp", brightness=3, range=20, color=Color3.fromRGB(0,220,50),
          pulse=true, pulseFreq=0.7, pulseAmp=2 },
        -- Toxic green highlight
        { type="highlight", fillColor=Color3.fromRGB(0,175,0), outlineColor=Color3.fromRGB(50,255,50),
          fillTransparency=0.75, outlineTransparency=0 },
    },

    -- ── Prisma (Rainbow) ──────────────────────────────────────
    ["Prisma"] = {
        -- Full-spectrum sparkle cloud
        { type="particle", part="hrp", offset=Vector3.new(0,0,0),
          rate=52, lifetime=NumberRange.new(0.6,1.8), speed=NumberRange.new(3,13),
          spread=Vector2.new(180,180), lightEmission=1.0,
          size=NumberSequence.new({NumberSequenceKeypoint.new(0,0.48),NumberSequenceKeypoint.new(0.5,0.28),NumberSequenceKeypoint.new(1,0)}),
          color=ColorSequence.new({
              ColorSequenceKeypoint.new(0,    Color3.fromRGB(255,0,0)),
              ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255,165,0)),
              ColorSequenceKeypoint.new(0.33, Color3.fromRGB(255,255,0)),
              ColorSequenceKeypoint.new(0.5,  Color3.fromRGB(0,255,0)),
              ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0,0,255)),
              ColorSequenceKeypoint.new(0.83, Color3.fromRGB(150,0,255)),
              ColorSequenceKeypoint.new(1,    Color3.fromRGB(255,0,255)),
          }),
          texture="rbxasset://textures/particles/sparkles_main.dds",
          transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(1,1)}) },
        -- White core Sparkles (always on)
        { type="sparkles", part="hrp", color=Color3.fromRGB(255,255,255) },
        -- Animated color-cycling PointLight
        { type="light", part="hrp", brightness=4, range=22, color=Color3.fromRGB(255,0,0),
          colorCycle=true, cycleSpeed=0.38 },
        -- Animated color-cycling Highlight
        { type="highlight", fillColor=Color3.fromRGB(255,0,0), outlineColor=Color3.fromRGB(255,255,255),
          fillTransparency=0.75, outlineTransparency=0, colorCycle=true, cycleSpeed=0.38 },
    },

    -- ── Alas de Fuego ─────────────────────────────────────────
    ["Alas de Fuego"] = {
        -- Left wing fan (shoulder offset, wide spread)
        { type="particle", part="hrp", offset=Vector3.new(-2.6,0.5,0),
          rate=38, lifetime=NumberRange.new(0.9,2.3), speed=NumberRange.new(3,11),
          spread=Vector2.new(55,90), lightEmission=1.0,
          size=NumberSequence.new({NumberSequenceKeypoint.new(0,1.2),NumberSequenceKeypoint.new(0.4,0.72),NumberSequenceKeypoint.new(1,0)}),
          color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(255,235,50)),ColorSequenceKeypoint.new(0.5,Color3.fromRGB(255,80,0)),ColorSequenceKeypoint.new(1,Color3.fromRGB(180,0,0))}),
          texture="rbxasset://textures/particles/fire_main.dds",
          transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(0.6,0.2),NumberSequenceKeypoint.new(1,1)}) },
        -- Right wing fan
        { type="particle", part="hrp", offset=Vector3.new(2.6,0.5,0),
          rate=38, lifetime=NumberRange.new(0.9,2.3), speed=NumberRange.new(3,11),
          spread=Vector2.new(55,90), lightEmission=1.0,
          size=NumberSequence.new({NumberSequenceKeypoint.new(0,1.2),NumberSequenceKeypoint.new(0.4,0.72),NumberSequenceKeypoint.new(1,0)}),
          color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(255,235,50)),ColorSequenceKeypoint.new(0.5,Color3.fromRGB(255,80,0)),ColorSequenceKeypoint.new(1,Color3.fromRGB(180,0,0))}),
          texture="rbxasset://textures/particles/fire_main.dds",
          transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(0.6,0.2),NumberSequenceKeypoint.new(1,1)}) },
        -- Wing tip embers left
        { type="particle", part="hrp", offset=Vector3.new(-3.8,0.9,0),
          rate=22, lifetime=NumberRange.new(0.35,0.9), speed=NumberRange.new(6,18),
          spread=Vector2.new(180,180), lightEmission=1.0,
          size=NumberSequence.new({NumberSequenceKeypoint.new(0,0.18),NumberSequenceKeypoint.new(1,0)}),
          color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(255,255,150)),ColorSequenceKeypoint.new(1,Color3.fromRGB(255,100,0))}),
          texture="rbxasset://textures/particles/sparkles_main.dds",
          transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(1,1)}) },
        -- Wing tip embers right
        { type="particle", part="hrp", offset=Vector3.new(3.8,0.9,0),
          rate=22, lifetime=NumberRange.new(0.35,0.9), speed=NumberRange.new(6,18),
          spread=Vector2.new(180,180), lightEmission=1.0,
          size=NumberSequence.new({NumberSequenceKeypoint.new(0,0.18),NumberSequenceKeypoint.new(1,0)}),
          color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(255,255,150)),ColorSequenceKeypoint.new(1,Color3.fromRGB(255,100,0))}),
          texture="rbxasset://textures/particles/sparkles_main.dds",
          transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(1,1)}) },
        -- Body Fire core
        { type="fire", part="hrp", heat=6, size=5, color=Color3.fromRGB(255,60,0), secondaryColor=Color3.fromRGB(255,210,50) },
        -- Pulsing warm PointLight
        { type="light", part="hrp", brightness=4, range=24, color=Color3.fromRGB(255,140,0),
          pulse=true, pulseFreq=1.0, pulseAmp=2 },
        -- Warm orange highlight
        { type="highlight", fillColor=Color3.fromRGB(255,90,0), outlineColor=Color3.fromRGB(255,235,50),
          fillTransparency=0.75, outlineTransparency=0 },
    },

    -- ── Void Eternal ──────────────────────────────────────────
    ["Void Eternal"] = {
        -- Black void wisps (omnidirectional, slow, dark purple-black)
        { type="particle", part="hrp", offset=Vector3.new(0,0,0),
          rate=38, lifetime=NumberRange.new(1.2,2.8), speed=NumberRange.new(0.5,4),
          spread=Vector2.new(180,180), lightEmission=0.08,
          size=NumberSequence.new({NumberSequenceKeypoint.new(0,0.55),NumberSequenceKeypoint.new(0.5,1.1),NumberSequenceKeypoint.new(1,0)}),
          color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(58,0,78)),ColorSequenceKeypoint.new(0.5,Color3.fromRGB(18,0,28)),ColorSequenceKeypoint.new(1,Color3.fromRGB(0,0,0))}),
          texture="rbxasset://textures/particles/smoke_main.dds",
          transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0.5),NumberSequenceKeypoint.new(0.4,0.1),NumberSequenceKeypoint.new(1,1)}) },
        -- Void star flashes (brief, bright purple sparks)
        { type="particle", part="hrp", offset=Vector3.new(0,0,0),
          rate=14, lifetime=NumberRange.new(0.15,0.45), speed=NumberRange.new(3,12),
          spread=Vector2.new(180,180), lightEmission=1.0,
          size=NumberSequence.new({NumberSequenceKeypoint.new(0,0.08),NumberSequenceKeypoint.new(0.5,0.3),NumberSequenceKeypoint.new(1,0)}),
          color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(210,0,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(90,0,200))}),
          texture="rbxasset://textures/particles/sparkles_main.dds",
          transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0.3),NumberSequenceKeypoint.new(1,1)}) },
        -- Null-black smoke
        { type="smoke", part="hrp", opacity=0.28, rise=0.2, size=4, color=Color3.fromRGB(0,0,0) },
        -- Vertical void beam (spine of darkness)
        { type="beam", part="hrp",
          offsetA=Vector3.new(0,-3,0), offsetB=Vector3.new(0,3,0),
          color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(90,0,180)),ColorSequenceKeypoint.new(0.5,Color3.fromRGB(20,0,40)),ColorSequenceKeypoint.new(1,Color3.fromRGB(90,0,180))}),
          lightEmission=0.6,
          transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0.5),NumberSequenceKeypoint.new(0.5,0.1),NumberSequenceKeypoint.new(1,0.5)}),
          width0=0.12, width1=0.12,
          texture="rbxassetid://448100188", textureLength=4, textureSpeed=3, segments=15 },
        -- Very dim pulsing deep-purple PointLight
        { type="light", part="hrp", brightness=1.5, range=11, color=Color3.fromRGB(100,0,180),
          pulse=true, pulseFreq=0.38, pulseAmp=1.0 },
        -- Dark void highlight (high fill transparency so it's subtle)
        { type="highlight", fillColor=Color3.fromRGB(28,0,48), outlineColor=Color3.fromRGB(140,0,255),
          fillTransparency=0.55, outlineTransparency=0 },
    },

    -- ── Neon Cyberpunk ────────────────────────────────────────
    ["Neon Cyberpunk"] = {
        -- Cyan Sparkles on body + pink on head
        { type="sparkles", part="hrp",  color=Color3.fromRGB(0,255,255) },
        { type="sparkles", part="head", color=Color3.fromRGB(255,0,200) },
        -- Digital circuit particles (fast, tiny, cyan→magenta)
        { type="particle", part="hrp", offset=Vector3.new(0,0,0),
          rate=38, lifetime=NumberRange.new(0.25,0.75), speed=NumberRange.new(9,28),
          spread=Vector2.new(180,180), lightEmission=1.0,
          size=NumberSequence.new({NumberSequenceKeypoint.new(0,0.07),NumberSequenceKeypoint.new(0.3,0.14),NumberSequenceKeypoint.new(1,0)}),
          color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(0,255,255)),ColorSequenceKeypoint.new(0.5,Color3.fromRGB(255,0,200)),ColorSequenceKeypoint.new(1,Color3.fromRGB(0,100,255))}),
          texture="rbxasset://textures/particles/sparkles_main.dds",
          transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(1,1)}) },
        -- Vertical neon laser beam (laser texture, fast scroll)
        { type="beam", part="hrp",
          offsetA=Vector3.new(0,-2.5,0), offsetB=Vector3.new(0,2.5,0),
          color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(0,255,255)),ColorSequenceKeypoint.new(0.5,Color3.fromRGB(255,0,200)),ColorSequenceKeypoint.new(1,Color3.fromRGB(0,255,255))}),
          lightEmission=1,
          transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0.1),NumberSequenceKeypoint.new(0.5,0.55),NumberSequenceKeypoint.new(1,0.1)}),
          width0=0.07, width1=0.07,
          texture="rbxassetid://1295553935", textureLength=3, textureSpeed=9, segments=20 },
        -- Horizontal shoulder beam (cyan→pink)
        { type="beam", part="hrp",
          offsetA=Vector3.new(-2,0.5,0), offsetB=Vector3.new(2,0.5,0),
          color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(255,0,200)),ColorSequenceKeypoint.new(0.5,Color3.fromRGB(0,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(255,0,200))}),
          lightEmission=1,
          transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0.1),NumberSequenceKeypoint.new(0.5,0.45),NumberSequenceKeypoint.new(1,0.1)}),
          width0=0.07, width1=0.07,
          texture="rbxassetid://1295553935", textureLength=3, textureSpeed=-7, segments=20 },
        -- HSV-cycling PointLight
        { type="light", part="hrp", brightness=4, range=20, color=Color3.fromRGB(0,255,255),
          colorCycle=true, cycleSpeed=0.5 },
        -- HSV-cycling body highlight
        { type="highlight", fillColor=Color3.fromRGB(0,200,255), outlineColor=Color3.fromRGB(255,0,200),
          fillTransparency=0.8, outlineTransparency=0, colorCycle=true, cycleSpeed=0.5 },
    },
}

-- ============================================================
-- HIT SOUND IDs
-- ============================================================
-- HitSounds (IDs de 17 dígitos usan rbxassetid://, los cortos también)
local HitSoundNames          = {
    "resetirl", "anime1", "scream", "tung", "ara ara", "yummers", "short",
    "DAAAAAAAMN", "Minecraft", "Sans", "Apex", "TF2normal", "Quake3 hit",
    "Crank Dat Soulja Boy", "cartoonbite", "goofy ahh trumpet", "crystal1",
    "anime2", "undertale", "scream1", "placeholder", "android pixie dust",
    "hits2", "hits", "osu! spin", "funkyhit1", "costcoguysboom!", "MLGhit",
    "Pluh!!", "eh!", "Metalpin", "hl2 Take That!", "oh",
    -- plantillas extra
    -- "MiSonido",
}

local HitSoundId             = {
    ["resetirl"]             = "rbxassetid://118459709742538",
    ["anime1"]               = "rbxassetid://131184394702134",
    ["scream"]               = "rbxassetid://72093868530698",
    ["tung"]                 = "rbxassetid://119946681968806",
    ["ara ara"]              = "rbxassetid://90030852927382",
    ["yummers"]              = "rbxassetid://138129369242537",
    ["short"]                = "rbxassetid://8047370627",
    ["DAAAAAAAMN"]           = "rbxassetid://106791149676363",
    ["Minecraft"]            = "rbxassetid://73571339886360",
    ["Sans"]                 = "rbxassetid://132322331764933",
    ["Apex"]                 = "rbxassetid://82483589201210",
    ["TF2normal"]            = "rbxassetid://95940995811019",
    ["Quake3 hit"]           = "rbxassetid://92440629467802",
    ["Crank Dat Soulja Boy"] = "rbxassetid://82034477982176",
    ["cartoonbite"]          = "rbxassetid://81906463817396",
    ["goofy ahh trumpet"]    = "rbxassetid://81233723542424",
    ["crystal1"]             = "rbxassetid://78750675578922",
    ["anime2"]               = "rbxassetid://77849223088718",
    ["undertale"]            = "rbxassetid://77770703006819",
    ["scream1"]              = "rbxassetid://75274501196144",
    ["placeholder"]          = "rbxassetid://74251426616113",
    ["android pixie dust"]   = "rbxassetid://138300264267348",
    ["hits2"]                = "rbxassetid://136601315351295",
    ["hits"]                 = "rbxassetid://139148727371684",
    ["osu! spin"]            = "rbxassetid://125860845463374",
    ["funkyhit1"]            = "rbxassetid://121311089745141",
    ["costcoguysboom!"]      = "rbxassetid://112554187270750",
    ["MLGhit"]               = "rbxassetid://109817519733426",
    ["Pluh!!"]               = "rbxassetid://106460739092828",
    ["eh!"]                  = "rbxassetid://105117264394463",
    ["Metalpin"]             = "rbxassetid://99636386529233",
    ["hl2 Take That!"]       = "rbxassetid://99478937381962",
    ["oh"]                   = "rbxassetid://98834599504077",
    -- plantillas extra
    -- ["MiSonido"] = "rbxassetid://",
}

-- ============================================================
-- HELPERS
-- ============================================================
local function Tog(k) return Toggles[k] and Toggles[k].Value end
local function Opt(k, d)
    local v = Options[k] and Options[k].Value; return (v ~= nil) and v or d
end

local function IsValidDamage(dmg)
    if type(dmg) ~= "number" then return false end
    if dmg ~= dmg then return false end
    if dmg == math.huge or dmg == -math.huge then return false end
    if math.abs(dmg) > 9e18 then return false end
    if dmg <= 0 then return false end
    return true
end

-- ============================================================
-- HITBOX EXPANDER
-- ============================================================
local _hbxExpanded = {}  -- [part] = { origSize, origTransp, origCC }

local function _hbxExpandPart(part, sz)
    if not (part and part.Parent) then return end
    local data = _hbxExpanded[part]
    if data then
        pcall(function() part.Size = Vector3.new(sz, sz, sz) end)
    else
        _hbxExpanded[part] = {
            origSize  = part.Size,
            origTransp = part.Transparency,
            origCC    = part.CanCollide,
        }
        pcall(function()
            part.Size         = Vector3.new(sz, sz, sz)
            part.Transparency = 1
            part.CanCollide   = false
        end)
    end
end

local function _hbxRevertAll()
    for part, data in pairs(_hbxExpanded) do
        pcall(function()
            if part and part.Parent then
                part.Size         = data.origSize
                part.Transparency = data.origTransp
                part.CanCollide   = data.origCC
            end
        end)
    end
    _hbxExpanded = {}
end

-- ============================================================
-- KEYBIND FIX
-- ============================================================
local KeybindToggleMap = {
    StrafeHotkey    = "TargetStrafe",
    SpectateHotkey  = "Spectate",
    AutoFireHotkey  = "AutoFireEnabled",
    AggressiveBTKey = "AggressiveBacktrack",
}

UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
    for optKey, togKey in pairs(KeybindToggleMap) do
        if Options[optKey] and Toggles[togKey] then
            local bound = Options[optKey].Value
            if bound and bound ~= "" then
                local ok, kc = pcall(function() return Enum.KeyCode[bound] end)
                if ok and kc and input.KeyCode == kc then
                    Toggles[togKey]:SetValue(not Toggles[togKey].Value)
                end
            end
        end
    end
end)

-- ============================================================
-- RESOLVER
-- ============================================================
-- ── Real Resolver ─────────────────────────────────────────────────────────────
-- Anti-desync: compares rawget position vs __index (detects ghost-positioning).
-- Anti-teleport: classifies jumps > RSVTeleportThresh st/s as teleports, conf=0.
-- Anti-bait: detects void-bait (Y < -50), suppresses fire while in void.
-- Real velocity: computed from position delta, immune to .Velocity spoofing.
-- Kinematic prediction: pos + vel*t + 0.5*acc*t² (t = ping in seconds).
local _rsvStates      = {}  -- per-player resolver state
local RSV_HIST_MAX    = 64
local RSV_SETTLE      = 6   -- frames to wait after teleport before trusting again

local function RSV_State(name)
    if not _rsvStates[name] then
        _rsvStates[name] = {
            posLog        = {},
            velLog        = {},
            realVel       = Vector3.zero,
            realAcc       = Vector3.zero,
            desync        = Vector3.zero,
            teleporting   = false,
            settleFrames  = 0,
            baitActive    = false,
            conf          = 0,
            teleportCount = 0,
            spamming      = false,
            lastPredPos   = nil,   -- predicted pos stored last frame (error tracking)
            predErrors    = {},    -- ring buffer of |predicted - actual| magnitudes (max 16)
            voidRisk      = 0,     -- 0-1 smoothed proximity to kill plane
        }
    end
    return _rsvStates[name]
end

local function RSV_Sample(player)
    if not player or not player.Character then return end
    local root = player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local now = tick()
    local st  = RSV_State(player.Name)

    -- Raw position via rawget (bypasses __index desync hooks)
    local rawP = root.Position
    pcall(function()
        local cf = rawget(root, "CFrame")
        if cf and typeof(cf) == "CFrame" then rawP = cf.Position end
    end)
    local hookP = root.Position
    st.desync   = rawP - hookP

    -- Measure prediction error from last frame BEFORE logging new position
    if st.lastPredPos and not st.teleporting then
        local err = (rawP - st.lastPredPos).Magnitude
        table.insert(st.predErrors, err)
        if #st.predErrors > 16 then table.remove(st.predErrors, 1) end
    end

    -- Teleport detection (default 12000 st/s — players with exploited high velocity won't false-trigger)
    local thresh = Opt('RSVTeleportThresh', 12000)
    if #st.posLog > 0 then
        local last = st.posLog[#st.posLog]
        local dt   = math.max(now - last.t, 0.001)
        local sps  = (rawP - last.pos).Magnitude / dt
        if sps > thresh then
            st.teleporting   = true
            st.settleFrames  = RSV_SETTLE
            st.conf          = 0
            st.teleportCount = st.teleportCount + 1
            st.predErrors    = {}    -- teleport errors are meaningless, reset ring buffer
            st.lastPredPos   = nil
        elseif st.teleporting then
            st.settleFrames  = st.settleFrames - 1
            if st.settleFrames <= 0 then st.teleporting = false end
        else
            st.teleportCount = math.max(0, st.teleportCount - (1 / 60))
        end
        st.spamming = st.teleportCount >= 3
    end

    table.insert(st.posLog, {pos = rawP, t = now})
    if #st.posLog > RSV_HIST_MAX then table.remove(st.posLog, 1) end

    -- Hard kill-plane suppress
    st.baitActive = rawP.Y < -50
    if st.teleporting or st.baitActive then
        st.conf     = 0
        st.voidRisk = st.baitActive and 1 or st.voidRisk
        return
    end

    -- Real velocity (position-derived, spoof-immune)
    local n = #st.posLog
    if n >= 3 then
        local dt = math.max(st.posLog[n].t - st.posLog[n - 2].t, 0.001)
        st.realVel = (st.posLog[n].pos - st.posLog[n - 2].pos) / dt
        table.insert(st.velLog, {vel = st.realVel, t = now})
        if #st.velLog > 32 then table.remove(st.velLog, 1) end
        if #st.velLog >= 2 then
            local m   = #st.velLog
            local dt2 = math.max(st.velLog[m].t - st.velLog[m - 1].t, 0.001)
            st.realAcc = (st.velLog[m].vel - st.velLog[m - 1].vel) / dt2
        end
    end

    -- ── Signal 1: warmup (30 clean samples for full weight) ──────────────
    local sampleF = math.clamp(n / 30, 0, 1)

    -- ── Signal 2: prediction accuracy — primary driver ───────────────────
    -- Measures how far our last-frame kinematic prediction was from actual pos.
    -- Neutral (0.5) until ring buffer has enough data; 8-stud avg error → 0.
    local predF = 0.5
    if #st.predErrors >= 4 then
        local avgErr = 0
        for _, e in ipairs(st.predErrors) do avgErr = avgErr + e end
        avgErr = avgErr / #st.predErrors
        predF  = math.clamp(1 - avgErr / 8, 0, 1)
    end

    -- ── Signal 3: multi-window velocity consistency ───────────────────────
    -- Short window (4 frames) vs medium window (14 frames).
    -- If they agree, motion is predictable; large divergence → low confidence.
    local shortV, medV = Vector3.zero, Vector3.zero
    local shortN, medN = 0, 0
    for i = math.max(1, n - 4), n - 1 do
        if st.posLog[i + 1] then
            local dt = math.max(st.posLog[i + 1].t - st.posLog[i].t, 0.001)
            shortV = shortV + (st.posLog[i + 1].pos - st.posLog[i].pos) / dt
            shortN = shortN + 1
        end
    end
    for i = math.max(1, n - 14), n - 1 do
        if st.posLog[i + 1] then
            local dt = math.max(st.posLog[i + 1].t - st.posLog[i].t, 0.001)
            medV = medV + (st.posLog[i + 1].pos - st.posLog[i].pos) / dt
            medN = medN + 1
        end
    end
    if shortN > 0 then shortV = shortV / shortN end
    if medN   > 0 then medV   = medV   / medN   end
    local consistF = 0.5
    if shortN > 0 and medN > 0 then
        consistF = math.clamp(1 - (shortV - medV).Magnitude / 30, 0, 1)
    end

    -- ── Signal 4: desync quality (smooth gradient) ────────────────────────
    -- < 4 studs: clean. > 80 studs: static spoof (invis exploit).
    local desyncM = st.desync.Magnitude
    local desyncF = desyncM < 4 and 1.0 or math.clamp(1 - (desyncM - 4) / 76, 0, 1)

    -- ── Void risk: progressive penalty approaching kill plane ─────────────
    -- Starts ramping at Y < 10, peaks at Y = -50. Fast descent amplifies risk.
    local rawVoidRisk = 0
    if rawP.Y < 10 then
        local distToKill = math.max(rawP.Y + 50, 0)   -- studs above Y=-50
        rawVoidRisk      = math.clamp(1 - distToKill / 60, 0, 1)
        if st.realVel.Y < -12 then                     -- fast descent: raise risk
            rawVoidRisk  = math.min(1, rawVoidRisk + 0.4)
        end
    end
    st.voidRisk = st.voidRisk + 0.15 * (rawVoidRisk - st.voidRisk)

    -- ── Raw confidence (weighted sum, void-penalised) ─────────────────────
    local rawConf = sampleF  * 0.15
                  + predF    * 0.45
                  + consistF * 0.25
                  + desyncF  * 0.15
    rawConf = rawConf * (1 - st.voidRisk * 0.55)
    rawConf = math.clamp(rawConf * 100, 0, 100)

    -- ── EMA smoothing: slow rise (α=0.06), faster fall (α=0.14) ─────────
    -- Prevents snapping: conf builds gradually, decays quickly on disruption.
    local alpha = rawConf > st.conf and 0.06 or 0.14
    st.conf     = st.conf + alpha * (rawConf - st.conf)

    -- Store predicted pos for next frame's error measurement
    local pingS    = math.clamp(Opt('PingAdjustment', 60) / 1000, 0, 0.5)
    st.lastPredPos = rawP + st.realVel * pingS + st.realAcc * (0.5 * pingS * pingS)
end

-- Kinematic aim position: pos + vel*t + 0.5*acc*t², with predictive kill-plane clamping
local function RSV_AimPos(player, pingMs)
    local st = RSV_State(player.Name)
    if #st.posLog == 0 then return nil, 0 end
    local base  = st.posLog[#st.posLog].pos
    local pingS = math.clamp(pingMs / 1000, 0, 0.5)
    local pred  = base + st.realVel * pingS + st.realAcc * (0.5 * pingS * pingS)

    local vb        = Opt('OutOfVoidBonus', 0)
    local killPlane = -50                          -- Roblox standard void threshold
    local safeFloor = killPlane + math.max(vb, 2) -- always at least 2 studs above kill plane

    -- Predictive: if current trajectory reaches kill plane within ping window, clamp early.
    -- This prevents firing at a target who will be dead/void-baiting by the time the shot arrives.
    if st.realVel.Y < -8 and base.Y > killPlane then
        local tToKill = (base.Y - killPlane) / (-st.realVel.Y)
        if tToKill < pingS + 0.15 then
            pred = Vector3.new(pred.X, math.max(pred.Y, safeFloor + vb), pred.Z)
        end
    end

    -- Hard floor: never predict below safeFloor regardless of trajectory
    if pred.Y < safeFloor then
        pred = Vector3.new(pred.X, safeFloor, pred.Z)
    end

    return pred, st.conf
end

-- Legacy-compatible wrappers (called by existing Heartbeat / indicator / autofire code)
local function UpdateResolver(target)
    if not Tog('ResolverEnabled') or not target then return end
    RSV_Sample(target)
end

local function GetResolvedPosition(target)
    if not Tog('ResolverEnabled') or not target then return nil end
    local pos, _ = RSV_AimPos(target, Opt('PingAdjustment', 60))
    return pos
end

local function CalculateConfidence(target)
    if not target then return 0 end
    return RSV_State(target.Name).conf
end

local function RSV_Clear(name) _rsvStates[name] = nil end

-- ============================================================
-- VOID SPAM
-- ============================================================
local function TickVoidSpam()
    if not Tog('BaitEnabled') then return end
    local now = tick()
    if State.InVoid then
        if now - State.LastBaitTime > Opt('InVoidTime', 0.5) then
            State.InVoid = false; State.LastBaitTime = now
        end
    else
        if now - State.LastBaitTime > Opt('OutOfVoidTime', 0.5) then
            State.InVoid = true; State.LastBaitTime = now
        end
    end
    if not State.InVoid then return end

    local preset = Opt('VoidSpamPreset', 'Spin')
    local cf

    if preset == 'Spin' then
        local t = now * 2  -- 2 rad/s
        local r = 50000000
        cf = CFrame.new(math.cos(t) * r, 0, math.sin(t) * r) * CFrame.Angles(0, t, 0)

    elseif preset == 'UpDown' then
        -- Quarterstep: pick one of four discrete bands (0.25 / 0.50 / 0.75 / 1.0 of 300M)
        local step = math.random(1, 4) * 0.25
        local sign = (math.floor(now * 120) % 2 == 0) and 1 or -1
        cf = CFrame.new(0, sign * step * 37804925, 0)

    elseif preset == 'NaN' then
        -- Roblox clamps math.huge to 10M; 0/0 still produces NaN in Luau
        local nan = 0/0
        cf = CFrame.new(nan, nan, nan)

    elseif preset == 'Random' then
        local range = 2147483647
        local sx = math.random() > 0.5 and 1 or -1
        local sy = math.random() > 0.5 and 1 or -1
        local sz = math.random() > 0.5 and 1 or -1
        cf = CFrame.new(
            math.random() * math.pi * range * sx,
            math.random() * math.pi * range * sy,
            math.random() * math.pi * range * sz
        )
    end

    if cf then State.VoidSpamCFrame = cf end
end

-- ============================================================
-- STRAFE
-- ============================================================
local function GetStrafePosition(targetPos, myPos)
    local method      = Opt('StrafeMethod', 'Normal')
    local dist        = Opt('StrafeDistance', 10)
    local height      = Opt('StrafeHeight', 0)
    local speed       = Opt('StrafeSpeed', 5)
    local rRange      = Opt('RandomRange', 10)
    State.StrafeAngle += speed * 0.01

    -- Distance 0: be at the target's HRP with height offset still applied.
    if dist <= 0 then return targetPos + Vector3.new(0, height, 0) end

    if method == "Normal" then
        return targetPos + Vector3.new(math.cos(State.StrafeAngle) * dist, height, math.sin(State.StrafeAngle) * dist)
    elseif method == "Hide" then
        return targetPos + Vector3.new(0, -30, 0)
    elseif method == "Random" then
        return targetPos + Vector3.new(
            (math.random() * 2 - 1) * rRange,
            (math.random() * 2 - 1) * rRange + height,
            (math.random() * 2 - 1) * rRange
        )
    elseif method == "Behind" then
        -- Stays directly behind the target relative to their LookVector
        local tRoot = CurrentTarget and CurrentTarget.Character and
            CurrentTarget.Character:FindFirstChild("HumanoidRootPart")
        if tRoot then
            local look = tRoot.CFrame.LookVector
            return targetPos - look * dist + Vector3.new(0, height, 0)
        end
        return targetPos + Vector3.new(math.cos(State.StrafeAngle) * dist, height, math.sin(State.StrafeAngle) * dist)
    elseif method == "Inside" then
        -- Stays exactly at target's position (useful for Connection Ragebot overlap)
        return targetPos + Vector3.new(0, height, 0)
    else
        return targetPos + Vector3.new(math.cos(State.StrafeAngle) * dist, height, math.sin(State.StrafeAngle) * dist)
    end
end

-- ============================================================
-- TARGET
-- ============================================================
local function isValidTarget(p)
    if not p or not p.Character then return false end
    -- Friend list: never target friends
    if FriendList[p.Name] or FriendList[p.DisplayName] then return false end
    local hum = p.Character:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return false end

    -- Global team check — skipped for FocusTarget so a team change never drops the lock
    if Tog('GlobalTeamCheck') and p ~= FocusTarget then
        local pt = pcall(function() return p.Team end) and p.Team
        local lt = pcall(function() return LocalPlayer.Team end) and LocalPlayer.Team
        if pt and lt and pt == lt then return false end
    end

    local checks = Opt('CustomChecks', {})
    local function hasCheck(name)
        if type(checks) ~= "table" then return false end
        if checks[name] then return true end
        for _, v in ipairs(checks) do if v == name then return true end end
        return false
    end

    if hasCheck("Forcefield") then
        if p.Character:FindFirstChildOfClass("ForceField") or p.Character:FindFirstChild("ForceField") then
            return false
        end
    end
    if hasCheck('"inf" salud') and (hum.Health >= 1e9 or hum.Health ~= hum.Health) then return false end
    if hasCheck("dead") and hum.Health <= 0 then return false end

    return true
end

-- ── Idle strafe ────────────────────────────────────────────────────────────
-- While IdleStateActive:
--   • Every frame: teleport the REAL character to random ±100k XZ, Y=200k,
--     with a random X-axis rotation.
--   • State.DesyncLocation is frozen at the same random position (ghost stays void).
-- On each tick: check if IdleStateTarget respawned (Health > 0).
--   → If yes: exit idle, re-lock CurrentTarget, resume normal strafe loop.

local function TickIdleStrafe()
    if not IdleStateActive then return end

    -- ── Target existence check ─────────────────────────────────────────────
    if not IdleStateTarget or not IdleStateTarget.Parent then
        IdleStateActive    = false
        IdleStateTarget    = nil
        FocusTarget        = nil
        CurrentTarget      = nil
        TargetStrafeActive = false
        if Tog('ReturnToOrigin') and State.OriginalPosition then
            local myChar = LocalPlayer.Character
            local mr = myChar and myChar:FindFirstChild("HumanoidRootPart")
            if mr then pcall(function() mr.CFrame = State.OriginalPosition end) end
        end
        State.OriginalPosition = nil
        Library:Notify("Idle: el objetivo salió del juego.")
        return
    end

    -- ── Respawn check ─────────────────────────────────────────────────────
    if IdleStateTarget then
        local char = IdleStateTarget.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            local ff  = char:FindFirstChildOfClass("ForceField")
            -- Target alive + no FF: exit idle and re-lock
            if hum and hum.Health > 0 and not ff and isValidTarget(IdleStateTarget) then
                IdleStateActive = false
                IdleOrigin      = nil
                CurrentTarget   = IdleStateTarget
                FocusTarget     = IdleStateTarget
                IdleStateTarget = nil
                Library:Notify("Idle: target respawneó — reanudando strafe.")
                return
            end
            -- Target alive but has FF: fall through to the normal void teleport below.
            -- Do NOT set 2147483647 — new Roblox clamps large coords and can crash the client.
        end
    end

    -- ── Void teleport ─────────────────────────────────────────────────────
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    local rx   = (math.random() * 2 - 1) * IDLE_RANGE
    local rz   = (math.random() * 2 - 1) * IDLE_RANGE
    local rotX = math.random() * math.pi * 2
    local idleCF = CFrame.new(rx, IDLE_BASE_Y, rz) * CFrame.Angles(rotX, 0, 0)

    if Tog('StrafDesyncEnabled') then
        -- Spoof pos: flash server to void, client stays physically in place
        State.VoidFlashCFrame = idleCF
        State.VoidFlashReady  = true
    else
        root.CFrame          = idleCF
        State.DesyncLocation = idleCF
    end
end

-- Auto-select nearest player (by mouse proximity or world distance)
local function selectTarget()
    -- Focus lock: if set, always return that player (even if dead — idle handles that)
    if FocusTarget and FocusTarget.Parent then
        return FocusTarget
    end
    local method = Opt('SelectionMethod', 'Posicion') -- default nearest by distance
    local best, bestDist = nil, math.huge
    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer or not isValidTarget(player) then continue end
        local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if not root then continue end
        local d
        if method == "Mouse" then
            local sp = Camera:WorldToViewportPoint(root.Position)
            local mp = UIS:GetMouseLocation()
            d = (Vector2.new(sp.X, sp.Y) - mp).Magnitude
        else
            local mr = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            d = mr and (root.Position - mr.Position).Magnitude or math.huge
        end
        if d < bestDist then
            bestDist = d; best = player
        end
    end
    return best
end

-- ============================================================
-- SPECTATE
-- ============================================================

-- ============================================================
-- AGGRESSIVE BACKTRACK
-- ============================================================
local function TickAggressiveBacktrack()
    if not IsUnlocked() or not Tog('AggressiveBacktrack') or not TargetStrafeActive or not CurrentTarget then
        if next(AggressiveFrozenStates) then
            for _, data in pairs(AggressiveFrozenStates) do
                if data.root and data.root.Parent then pcall(function() data.root.Anchored = false end) end
            end
            AggressiveFrozenStates = {}
        end
        return
    end

    local now = tick()
    local aggrCooldown = Opt('AggrBTCooldown', AGGR_BT_COOLDOWN_DEF)
    local aggrDuration = Opt('AggrBTDuration', AGGR_BT_DURATION_DEF)

    -- Only freeze the CurrentTarget
    if now > AggressiveFreezeEnd + aggrCooldown then
        AggressiveFreezeEnd = now + aggrDuration
        local char = CurrentTarget.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if root then
            AggressiveFrozenStates[CurrentTarget.Name] = {
                root = root,
                frozenCF = root.CFrame,
                until_t = now + aggrDuration
            }
        end
    end

    if now < AggressiveFreezeEnd then
        for name, data in pairs(AggressiveFrozenStates) do
            if data.root and data.root.Parent and now < data.until_t then
                pcall(function() data.root.CFrame = data.frozenCF end)
            end
        end
    else
        for _, data in pairs(AggressiveFrozenStates) do
            if data.root and data.root.Parent then pcall(function() data.root.Anchored = false end) end
        end
        AggressiveFrozenStates = {}
    end
end

-- ============================================================
-- SPECTATE
-- ============================================================
local function UpdateSpectate(target)
    if not target or not target.Character then return end
    -- Use the target's Humanoid (not HRP) so Roblox's camera tracks their character
    -- and is not affected by the local player's desync/spoof position flashes.
    local humanoid = target.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    Camera.CameraSubject = humanoid
    Camera.CameraType    = Enum.CameraType.Custom
end

local function RestoreCamera()
    -- Destruir el anchor de freeze si existe
    if State.SpectateFrozenAnchor then
        pcall(function() State.SpectateFrozenAnchor:Destroy() end)
        State.SpectateFrozenAnchor = nil
    end
    Camera.CameraSubject       = State.OriginalCameraSubject
        or (LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid"))
    Camera.CameraType          = Enum.CameraType.Custom
    State.SpectateActive       = false
    State.SpectateFrozen       = false
    State.SpectateWasTarget    = nil
    State.SpectateFrozenCF     = nil
end

local function _destroySpectateAnchor()
    if State.SpectateFrozenAnchor then
        pcall(function() State.SpectateFrozenAnchor:Destroy() end)
        State.SpectateFrozenAnchor = nil
    end
end

-- Congela el espectador en la posición del HRP del target al morir.
-- Usa una Part anclada como CameraSubject → posición fija pero mouse libre para rotar.
local function FreezeSpectate(frozenTarget)
    _destroySpectateAnchor()
    State.SpectateFrozen    = true
    State.SpectateWasTarget = frozenTarget
    State.SpectateFrozenCF  = Camera.CFrame

    local tChar = frozenTarget and frozenTarget.Character
    local tHRP  = tChar and tChar:FindFirstChild("HumanoidRootPart")
    local anchorCF = tHRP and tHRP.CFrame or Camera.CFrame

    local anchor = Instance.new("Part")
    anchor.Name         = "_SpectateAnchor"
    anchor.Anchored     = true
    anchor.CanCollide   = false
    anchor.Transparency = 1
    anchor.Size         = Vector3.new(0.1, 0.1, 0.1)
    anchor.CFrame       = anchorCF
    anchor.Parent       = workspace
    State.SpectateFrozenAnchor = anchor

    Camera.CameraSubject = anchor
    Camera.CameraType    = Enum.CameraType.Custom
end



-- ============================================================
-- HIT SOUNDS  (new system)
-- ============================================================
-- Spawn a fresh Sound instance every call → true concurrent overlap
local function SpawnSoundInstance(name)
    local id = HitSoundId[name]
    if not id then return end
    local vol              = math.clamp(Opt('HitSoundVolume', 0.5), 0, 10)
    local snd              = Instance.new("Sound")
    snd.SoundId            = id
    snd.Volume             = vol
    snd.RollOffMaxDistance = 0
    snd.Parent             = SoundService
    if snd.IsLoaded then
        snd:Play()
    else
        task.spawn(function()
            snd.Loaded:Wait(); snd:Play()
        end)
    end
    Debris:AddItem(snd, 8)
end

local function PlayHitSound()
    if not Tog('Hit_Sounds') then return end
    SpawnSoundInstance(Opt('Hit_SoundType', 'Neverlose'))
end

local function PreviewSound(name)
    SpawnSoundInstance(name)
end

-- ============================================================
-- HIT NOTIFICATIONS  (redesigned — slide-in, center-stack)
-- ============================================================
local NOTIF_DURATION   = 2.4
local NOTIF_FADE_IN    = 0.12
local NOTIF_FADE_OUT   = 0.50
local NOTIF_SLOT_H     = 24
local NOTIF_SLOT_GAP   = 4

-- Kill notifications
local KillNotifList    = {}
local KILL_DURATION    = 2.8
local KILL_FADE_IN     = 0.12
local KILL_FADE_OUT    = 0.55
local KILL_SLOT_H      = 28

local function DmgColor(dmg)
    if dmg >= 60 then
        return Color3.fromRGB(255, 50, 50)  -- big hit
    elseif dmg >= 25 then
        return Color3.fromRGB(255, 155, 30) -- medium
    else
        return Color3.fromRGB(200, 200, 200)
    end -- small
end

local function ShowHitNotification(targetName, dmg, partName)
    if not Tog('HitNotifsEnabled') then return end
    if not IsValidDamage(dmg) then return end

    local label         = string.format("%.2f  %s  [%s]", dmg, targetName, partName)
    local textW         = math.max(160, #label * 8 + 24)

    -- Background panel
    local bg            = Drawing.new("Square")
    bg.Filled           = true
    bg.Color            = Color3.fromRGB(6, 6, 10)
    bg.Transparency     = 0.42
    bg.ZIndex           = 9
    bg.Visible          = false

    -- Thin accent bar on left edge
    local accent        = Drawing.new("Square")
    accent.Filled       = true
    accent.Color        = DmgColor(dmg)
    accent.Transparency = 0
    accent.ZIndex       = 10
    accent.Visible      = false

    -- Text
    local txt           = Drawing.new("Text")
    txt.Text            = label
    txt.Color           = Color3.fromRGB(235, 235, 235)
    txt.Size            = 13
    txt.Center          = true
    txt.Outline         = true
    txt.OutlineColor    = Color3.fromRGB(0, 0, 0)
    txt.ZIndex          = 11
    txt.Visible         = false

    table.insert(HitNotifList, {
        bg = bg, accent = accent, txt = txt,
        w = textW, h = NOTIF_SLOT_H,
        spawnT = tick(), duration = NOTIF_DURATION,
        dmg = dmg, active = true,
    })
end

local function ShowKillNotification(targetName)
    if not Tog('KillNotifsEnabled') then return end
    local label         = "KILLED  " .. targetName
    local textW         = math.max(140, #label * 9 + 28)

    local bg            = Drawing.new("Square")
    bg.Filled           = true; bg.Color = Color3.fromRGB(14, 3, 3)
    bg.Transparency     = 0.35; bg.ZIndex = 9; bg.Visible = false

    local accent        = Drawing.new("Square")
    accent.Filled       = true; accent.Color = Color3.fromRGB(255, 25, 25)
    accent.Transparency = 0; accent.ZIndex = 10; accent.Visible = false

    local txt           = Drawing.new("Text")
    txt.Text            = label; txt.Color = Color3.fromRGB(255, 70, 70)
    txt.Size            = 15; txt.Center = true
    txt.Outline         = true; txt.OutlineColor = Color3.fromRGB(0, 0, 0)
    txt.ZIndex          = 11; txt.Visible = false

    table.insert(KillNotifList, {
        bg = bg, accent = accent, txt = txt,
        w = textW, h = KILL_SLOT_H,
        spawnT = tick(), duration = KILL_DURATION,
        active = true,
    })
end

-- ============================================================
-- HIT PARTICLES  (multi-style)
-- ============================================================
local function SpawnHitParticles(position)
    if not Tog('HitParticlesEnabled') then return end
    task.spawn(function()
        local part = Instance.new("Part")
        part.Size         = Vector3.new(0.6, 0.6, 0.6)
        part.CFrame       = CFrame.new(position)
        part.Anchored     = true
        part.CanCollide   = false
        part.Transparency = 1
        part.Parent       = workspace

        local styleName = Opt('ParticleStyle', 'Chispas')
        local cfg = PARTICLE_STYLE_CFGS[styleName] or PARTICLE_STYLE_CFGS["Chispas"]

        -- Main burst layer
        local pe = Instance.new("ParticleEmitter")
        pe.Color         = cfg.color
        pe.LightEmission = cfg.lightEmission or 1
        pe.LightInfluence = 0
        pe.Size          = cfg.size
        pe.Speed         = cfg.speed
        pe.Lifetime      = cfg.lifetime
        pe.Rotation      = NumberRange.new(0, 360)
        pe.RotSpeed      = NumberRange.new(-220, 220)
        pe.Transparency  = cfg.transparency or NumberSequence.new({ NumberSequenceKeypoint.new(0,0), NumberSequenceKeypoint.new(1,1) })
        pe.SpreadAngle   = cfg.spread or Vector2.new(180, 180)
        pe.Rate          = 0
        if cfg.texture then pe.Texture = cfg.texture end
        pe.Parent        = part
        pe:Emit(cfg.count or 75)

        -- Secondary shockwave ring
        local pe2 = Instance.new("ParticleEmitter")
        pe2.Color         = cfg.color
        pe2.LightEmission = 1
        pe2.LightInfluence = 0
        pe2.Size          = NumberSequence.new({ NumberSequenceKeypoint.new(0,0.7), NumberSequenceKeypoint.new(1,0) })
        pe2.Speed         = NumberRange.new(6, 18)
        pe2.Lifetime      = NumberRange.new(0.05, 0.25)
        pe2.SpreadAngle   = Vector2.new(88, 8)
        pe2.Rate          = 0
        pe2.Transparency  = NumberSequence.new({ NumberSequenceKeypoint.new(0,0), NumberSequenceKeypoint.new(1,1) })
        pe2.Parent        = part
        pe2:Emit(28)

        Debris:AddItem(part, 2.5)
    end)
end

-- ============================================================
-- HIT CHAMS  (fixed — no longer freezes enemy)
-- ============================================================
local function SpawnHitCham(target, hitPosition, partName)
    if not Tog('HitChamsEnabled') then return end
    local char = target and target.Character
    if not char then return end

    local chamColor = Opt('HitChamsColor', Color3.fromRGB(255, 60, 60))
    local dur       = Opt('HitChamsDuration', 2)

    -- Remove any previous highlight for this target to avoid stacking
    local prev = char:FindFirstChild("HitCham_HL")
    if prev then prev:Destroy() end

    local hl               = Instance.new("Highlight")
    hl.Name                = "HitCham_HL"
    hl.FillColor           = chamColor
    hl.FillTransparency    = 0.30
    hl.OutlineColor        = Color3.fromRGB(255, 255, 255)
    hl.OutlineTransparency = 0
    hl.DepthMode           = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Adornee             = char
    hl.Parent              = char

    table.insert(HitChamList, { highlight = hl, time = tick(), duration = dur })
    Debris:AddItem(hl, dur)
end

-- ============================================================
-- HIT TRACER  (beam-based, animated textures)
-- ============================================================
local function SpawnHitTracer(hitPosition)
    if not Tog('HitTracersEnabled') then return end
    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end

    local tracerSrc = Opt('HitTracerSource', 'HRP Local')
    local originPos = (tracerSrc == 'HRP Desync') and State.DesyncLocation.Position or myRoot.Position

    local dur    = Opt('HitTracerDuration', 1.5)
    local color  = Opt('HitTracerColor', Color3.fromRGB(220, 60, 60))
    local texKey = Opt('HitTracerTexture', 'Solido')
    local texId  = BEAM_TRACER_TEXTURES[texKey] or ""
    local thick  = Opt('HitTracerThickness', 0.2)

    task.spawn(function()
        local p0 = Instance.new("Part")
        p0.Anchored = true; p0.CanCollide = false
        p0.Transparency = 1; p0.Size = Vector3.new(0.1, 0.1, 0.1)
        p0.CFrame = CFrame.new(originPos); p0.Parent = workspace
        local a0 = Instance.new("Attachment"); a0.Parent = p0

        local p1 = Instance.new("Part")
        p1.Anchored = true; p1.CanCollide = false
        p1.Transparency = 1; p1.Size = Vector3.new(0.1, 0.1, 0.1)
        p1.CFrame = CFrame.new(hitPosition); p1.Parent = workspace
        local a1 = Instance.new("Attachment"); a1.Parent = p1

        local beam = Instance.new("Beam")
        beam.Attachment0   = a0
        beam.Attachment1   = a1
        beam.Color         = ColorSequence.new(color)
        beam.Width0        = thick
        beam.Width1        = thick * 0.35
        beam.LightEmission = 0.9
        beam.LightInfluence = 0
        beam.FaceCamera    = true
        beam.Segments      = 12
        beam.Transparency  = NumberSequence.new(0)
        if texId ~= "" then
            beam.Texture      = texId
            beam.TextureMode  = Enum.TextureMode.Wrap
            beam.TextureSpeed = 3
            beam.TextureLength = 2
        end
        beam.Parent = p0

        -- Fade out in last 35% of duration
        task.delay(dur * 0.65, function()
            local steps = 8
            local stepT = (dur * 0.35) / steps
            for i = 1, steps do
                task.wait(stepT)
                if beam and beam.Parent then
                    beam.Transparency = NumberSequence.new(i / steps)
                end
            end
        end)

        Debris:AddItem(p0, dur + 0.1)
        Debris:AddItem(p1, dur + 0.1)
    end)
end

-- ============================================================
-- ON HIT
-- ============================================================
local function OnHitRegistered(target, hitPos, dmg, partName)
    if not IsValidDamage(dmg) then return end
    PlayHitSound()
    ShowHitNotification(target.Name, dmg, partName)
    SpawnHitParticles(hitPos)
    SpawnHitCham(target, hitPos, partName)
    SpawnHitTracer(hitPos)
    -- Kill check (done slightly delayed so server HP update propagates)
    task.delay(0.05, function()
        local hum = target.Character and target.Character:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health <= 0 then
            ShowKillNotification(target.Name)
        end
    end)
end

-- ============================================================
-- HIT DETECTION  (HealthChanged monitor on CurrentTarget)
-- ============================================================
local _hdConn   = nil
local _hdTarget = nil
local _hdPrevHP = 0

local function TeardownHitDetect()
    if _hdConn then _hdConn:Disconnect(); _hdConn = nil end
    _hdTarget = nil
    _hdPrevHP = 0
end

local function SetupHitDetect(target)
    if not target or not target.Character then return end
    local hum = target.Character:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    -- Skip if already watching this exact humanoid instance
    if _hdTarget == target and _hdConn and _hdConn.Connected then return end
    TeardownHitDetect()
    _hdTarget = target
    _hdPrevHP = hum.Health
    _hdConn   = hum.HealthChanged:Connect(function(newHP)
        local dmg = _hdPrevHP - newHP
        _hdPrevHP = newHP
        if not IsValidDamage(dmg) then return end
        if not TargetStrafeActive then return end
        local char = target.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hitPos = root and root.Position or Vector3.new(0, 0, 0)
        OnHitRegistered(target, hitPos, dmg, Opt('AutoFirePart', 'HumanoidRootPart'))
    end)
end

-- ============================================================
-- FORCE HIT  (gated by IsUnlocked)
-- ============================================================
local Mouse1HeldConnection = nil

-- ============================================================
-- INDICATORS  (action / resolver / aggressive BT)
-- ============================================================
local function MakePanel(x, y, w, h, alpha)
    local bg = Drawing.new("Square")
    bg.Filled = true; bg.Color = Color3.fromRGB(8, 8, 12)
    bg.Transparency = alpha or 0.62; bg.Size = Vector2.new(w, h)
    bg.Position = Vector2.new(x, y); bg.Visible = false; bg.ZIndex = 1
    return bg
end

local function MakeLabel(x, y, size, color)
    local t = Drawing.new("Text")
    t.Size = size or 13; t.Color = color or Color3.fromRGB(220, 220, 220)
    t.Outline = true; t.OutlineColor = Color3.fromRGB(0, 0, 0)
    t.Center = false; t.Visible = false; t.Position = Vector2.new(x, y); t.ZIndex = 2
    return t
end

local actionBg        = MakePanel(8, 8, 240, 18, 0.65)
local actionLabel     = MakeLabel(12, 10, 12, Color3.fromRGB(210, 210, 210))
-- Crosshair lines
local _xhTop    = Drawing.new("Line");   _xhTop.Thickness   = 1.2; _xhTop.Visible   = false
local _xhBot    = Drawing.new("Line");   _xhBot.Thickness   = 1.2; _xhBot.Visible   = false
local _xhLeft   = Drawing.new("Line");   _xhLeft.Thickness  = 1.2; _xhLeft.Visible  = false
local _xhRight  = Drawing.new("Line");   _xhRight.Thickness = 1.2; _xhRight.Visible = false
local _xhDot    = Drawing.new("Circle"); _xhDot.Filled = true; _xhDot.Radius = 1.5; _xhDot.NumSides = 8; _xhDot.Visible = false
-- Symbol label + resolver text (no background)
local _symLbl   = Drawing.new("Text"); _symLbl.Size = 18;  _symLbl.Center = true; _symLbl.Outline = true; _symLbl.OutlineColor = Color3.fromRGB(0,0,0); _symLbl.Visible = false
local _rsvL1    = Drawing.new("Text"); _rsvL1.Size  = 17;  _rsvL1.Center  = true; _rsvL1.Outline  = true; _rsvL1.OutlineColor  = Color3.fromRGB(0,0,0); _rsvL1.Visible  = false
local _rsvL2    = Drawing.new("Text"); _rsvL2.Size  = 13;  _rsvL2.Center  = true; _rsvL2.Outline  = true; _rsvL2.OutlineColor  = Color3.fromRGB(0,0,0); _rsvL2.Visible  = false
-- Void spam status — always visible when BaitEnabled, independent of other indicators
local _voidLbl      = Drawing.new("Text"); _voidLbl.Size = 16; _voidLbl.Center = true; _voidLbl.Outline = true; _voidLbl.OutlineColor = Color3.fromRGB(0,0,0); _voidLbl.Visible = false
local _voidLblShown = false   -- guard: only write Drawing props when state changes
local aggressiveBg    = MakePanel(8, 228, 200, 18, 0.65)
local aggressiveLabel = MakeLabel(12, 230, 12, Color3.fromRGB(255, 180, 60))

local function ConfColor(c)
    if c >= 70 then
        return Color3.fromRGB(80, 220, 100)
    elseif c >= 40 then
        return Color3.fromRGB(255, 200, 50)
    else
        return Color3.fromRGB(255, 80, 80)
    end
end

local function UpdateIndicators(confidence)
    -- Action bar
    if Tog('ShowActionIndicator') then
        local parts = {}
        if TargetStrafeActive and CurrentTarget then table.insert(parts, "STRAFE  " .. CurrentTarget.Name) end
        if Tog('StrafDesyncEnabled') and TargetStrafeActive then table.insert(parts, "SPOOF POS") end
        -- void spam has its own dedicated label; skip here to avoid duplication
        if IsUnlocked() and Tog('AutoFireEnabled') and TargetStrafeActive then table.insert(parts, "AUTO FIRE") end
        if IsUnlocked() and Tog('AggressiveBacktrack') then table.insert(parts, "AGGR BT") end

        local text = table.concat(parts, "  |  ")
        if #parts > 0 then
            actionLabel.Text    = text
            actionBg.Size       = Vector2.new(#text * 7 + 16, 18)
            actionLabel.Visible = true; actionBg.Visible = true
        else
            actionLabel.Visible = false; actionBg.Visible = false
        end
        local oy             = Opt('IndicatorY', 8)
        local ox             = Camera.ViewportSize.X / 2 - (#text * 7 + 16) / 2
        actionBg.Position    = Vector2.new(ox, oy)
        actionLabel.Position = Vector2.new(ox + 5, oy + 3)
    else
        actionLabel.Visible = false; actionBg.Visible = false
    end

    -- Crosshair + Symbol label + Resolver HUD (no background)
    if Tog('ShowResolverIndicator') then
        local vp    = Camera.ViewportSize
        local cx    = vp.X / 2
        local cy    = vp.Y / 2
        local gap   = 5    -- gap between center dot and arm start
        local arm   = 11   -- arm length
        local xhC   = Color3.fromRGB(255, 255, 255)

        _xhTop.From    = Vector2.new(cx,        cy - gap - arm); _xhTop.To    = Vector2.new(cx,        cy - gap); _xhTop.Color    = xhC
        _xhBot.From    = Vector2.new(cx,        cy + gap);        _xhBot.To    = Vector2.new(cx,        cy + gap + arm); _xhBot.Color    = xhC
        _xhLeft.From   = Vector2.new(cx - gap - arm, cy);        _xhLeft.To   = Vector2.new(cx - gap,  cy);            _xhLeft.Color   = xhC
        _xhRight.From  = Vector2.new(cx + gap,  cy);             _xhRight.To  = Vector2.new(cx + gap + arm, cy);       _xhRight.Color  = xhC
        _xhDot.Position = Vector2.new(cx, cy); _xhDot.Color = xhC
        _xhTop.Visible = true; _xhBot.Visible = true; _xhLeft.Visible = true; _xhRight.Visible = true; _xhDot.Visible = true

        -- "Symbol" label below crosshair
        local lblY      = cy + gap + arm + 6
        _symLbl.Text     = "Symbol"
        _symLbl.Color    = Color3.fromRGB(200, 160, 255)
        _symLbl.Position = Vector2.new(cx, lblY)
        _symLbl.Visible  = true

        -- Resolver status lines
        if Tog('ResolverEnabled') and CurrentTarget and isValidTarget(CurrentTarget) then
            local st   = RSV_State(CurrentTarget.Name)
            local cert = math.clamp(st.conf * 25, 0, 2500)
            local char = CurrentTarget.Character
            local hum  = char and char:FindFirstChildOfClass("Humanoid")
            local hp   = hum and math.floor(hum.Health) or 0

            -- Determine Is-tags in priority order
            local tags = {}
            if st.spamming                  then table.insert(tags, "spamming")    end
            if st.desync.Magnitude > 80     then table.insert(tags, "invis")       end
            if st.baitActive                then table.insert(tags, "Void")        end
            if st.teleporting               then table.insert(tags, "Teleporting") end
            if hum and hum.PlatformStand    then table.insert(tags, "Flying")      end
            if #tags == 0                   then table.insert(tags, "Normal")      end

            -- out_void_spam: bait enabled, currently in void, bait timer < 0.3s remaining
            local ovs = ""
            if Tog('BaitEnabled') and State.InVoid then
                local rem = Opt('InVoidTime', 0.5) - (tick() - State.LastBaitTime)
                if rem > 0 and rem < 0.3 then ovs = ":(out_void_spam)" end
            end

            _rsvL1.Text     = string.format('T: %s | Ragebot:(Certainty: %.2f:(Is:"%s"):(Health: %d)%s)',
                CurrentTarget.Name, cert, table.concat(tags, ", "), hp, ovs)
            _rsvL1.Color    = Color3.fromRGB(200, 160, 255)
            _rsvL1.Position = Vector2.new(cx, lblY + 16)
            _rsvL1.Visible  = true
            _rsvL2.Visible  = false
        else
            _rsvL1.Visible = false; _rsvL2.Visible = false
        end
    else
        _xhTop.Visible = false; _xhBot.Visible = false; _xhLeft.Visible = false
        _xhRight.Visible = false; _xhDot.Visible = false
        _symLbl.Visible = false; _rsvL1.Visible = false; _rsvL2.Visible = false
    end

    -- Aggressive BT bar
    if IsUnlocked() and Tog('ShowAggressiveBTIndicator') and Tog('AggressiveBacktrack') then
        local now = tick()
        local txt
        if now < AggressiveFreezeEnd then
            txt = string.format("BT ACTIVO  %.1fs", AggressiveFreezeEnd - now)
            aggressiveLabel.Color = Color3.fromRGB(255, 80, 80)
        else
            local cd = (AggressiveFreezeEnd + Opt('AggrBTCooldown', AGGR_BT_COOLDOWN_DEF)) - now
            if cd > 0 then
                txt = string.format("BT COOLDOWN  %.1fs", cd)
                aggressiveLabel.Color = Color3.fromRGB(200, 150, 50)
            else
                txt = "BT LISTO"
                aggressiveLabel.Color = Color3.fromRGB(80, 220, 100)
            end
        end
        aggressiveLabel.Text     = txt
        aggressiveBg.Size        = Vector2.new(#txt * 7 + 16, 18)
        local ay                 = Opt('IndicatorY', 8) + 22
        local ax                 = Camera.ViewportSize.X / 2 - (#txt * 7 + 16) / 2
        aggressiveBg.Position    = Vector2.new(ax, ay)
        aggressiveLabel.Position = Vector2.new(ax + 5, ay + 3)
        aggressiveBg.Visible     = true; aggressiveLabel.Visible = true
    else
        aggressiveBg.Visible = false; aggressiveLabel.Visible = false
    end

    -- Void spam status: guard prevents setting Drawing props every frame (causes flicker)
    local baitNow = Tog('BaitEnabled')
    if baitNow and not _voidLblShown then
        local vp = Camera.ViewportSize
        _voidLbl.Text     = "VOID SPAM"
        _voidLbl.Color    = Color3.fromRGB(255, 90, 60)
        _voidLbl.Position = Vector2.new(vp.X / 2, vp.Y - 30)
        _voidLbl.Visible  = true
        _voidLblShown     = true
    elseif not baitNow and _voidLblShown then
        _voidLbl.Visible  = false
        _voidLblShown     = false
    end
end


-- ============================================================
-- SERVER WELD  (melee-grade position sync)
-- ============================================================
-- SILENT AIM
-- ============================================================
-- Redirects shots to land on the target regardless of crosshair direction.
-- "Closest Part": finds the target body part whose position is closest to the
--   current aim ray, so the aim correction looks natural and hits the most
--   hittable part instead of always snapping to HRP.
-- Methods:
--   Camera Override  — snaps Camera.CFrame toward target each RenderStepped.
--                      Most universal but can fight game camera scripts.
--   Mouse.Hit        — spoofs Mouse.Hit via sethiddenproperty, camera stays put.
--                      Works for games reading Mouse.Hit for shot origin.
--   findPartOnRay    — hooks workspace.__namecall to redirect raycast results.
--                      Transparent to the camera; needs hookmetamethod support.
-- ============================================================
local _saConn       = nil
local _saHooked     = false  -- findPartOnRay hook installed flag (installed once)
local _saOrigNC     = nil    -- original __namecall for findPartOnRay method
local _saCamSaved   = nil    -- saved CameraType before Camera Override

-- Returns the target body part position closest to the local aim ray,
-- or HRP if no better part found. FOV is intentionally ignored.
local function GetSAPos(target)
    target = target or CurrentTarget
    if not target or not target.Character then return nil end
    local char    = target.Character
    local aimOrig = Camera.CFrame.Position
    local aimDir  = Camera.CFrame.LookVector

    local best, bestPerp = nil, math.huge
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            local toP  = part.Position - aimOrig
            local proj = toP:Dot(aimDir)
            if proj > 0 then
                local perp = (toP - aimDir * proj).Magnitude
                if perp < bestPerp then bestPerp = perp; best = part end
            end
        end
    end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    return (best or hrp) and (best or hrp).Position
end

local function StopSilentAim()
    if _saConn then _saConn:Disconnect(); _saConn = nil end
    pcall(function() RunService:UnbindFromRenderStep("_saCamera") end)
    if _saCamSaved then
        pcall(function() Camera.CameraType = _saCamSaved end)
        _saCamSaved = nil
    end
end

local function StartSilentAim()
    StopSilentAim()
    if not Tog('SilentAimEnabled') then return end
    local method = Opt('SilentAimMethod', 'Mouse.Hit')

    if method == 'Camera Override' then
        -- BindToRenderStep at Camera+1 so we run AFTER Roblox's PlayerModule
        -- camera script (which also runs on RenderStepped and would overwrite us).
        _saCamSaved = Camera.CameraType
        RunService:BindToRenderStep("_saCamera", Enum.RenderPriority.Camera.Value + 1, function()
            if not Tog('SilentAimEnabled') or not CurrentTarget then return end
            local pos = GetSAPos()
            if not pos then return end
            pcall(function()
                Camera.CameraType = Enum.CameraType.Scriptable
                Camera.CFrame     = CFrame.new(Camera.CFrame.Position, pos)
            end)
        end)

    elseif method == 'Mouse.Hit' then
        -- Spoofs Mouse.Hit via sethiddenproperty. rawset removed — it conflicts
        -- with sethiddenproperty and resets the hidden property immediately.
        local mouse = LocalPlayer:GetMouse()
        _saConn = RunService.RenderStepped:Connect(function()
            if not Tog('SilentAimEnabled') or not CurrentTarget then return end
            local pos = GetSAPos()
            if not pos then return end
            pcall(function()
                local hitCF = CFrame.new(pos)
                if sethiddenproperty then
                    sethiddenproperty(mouse, "Hit", hitCF)
                    local tR = CurrentTarget.Character and
                               CurrentTarget.Character:FindFirstChild("HumanoidRootPart")
                    if tR then sethiddenproperty(mouse, "Target", tR) end
                end
            end)
        end)

    elseif method == 'findPartOnRay' then
        -- Hooks the global Instance __namecall once. Guards:
        -- (1) self == workspace — avoids intercepting RemoteFunctions, services, etc.
        -- (2) origin near Camera — avoids redirecting physics/floor-detection raycasts
        --     that originate near the character HRP, not the camera.
        -- Raycast() returns RaycastResult (table form); FindPartOnRay returns tuple.
        if not (hookmetamethod and getrawmetatable and getnamecallmethod) then
            Library:Notify("⚠ findPartOnRay requiere hookmetamethod")
            return
        end
        if not _saHooked then
            _saHooked = true
            _saOrigNC = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
                local m = getnamecallmethod()
                if Tog('SilentAimEnabled') and CurrentTarget and CurrentTarget.Character
                    and self == workspace
                    and (m == "FindPartOnRay" or m == "FindPartOnRayWithIgnoreList" or m == "Raycast") then
                    -- Determine ray origin to distinguish gun shots from physics raycasts
                    local args = {...}
                    local origin
                    if m == "Raycast" then
                        origin = args[1]
                    elseif args[1] and typeof(args[1]) == "Ray" then
                        origin = args[1].Origin
                    end
                    local camPos = Camera.CFrame.Position
                    if origin and typeof(origin) == "Vector3" and (origin - camPos).Magnitude < 15 then
                        local pos = GetSAPos()
                        local tR  = CurrentTarget.Character:FindFirstChild("HumanoidRootPart")
                        if pos and tR then
                            if m == "Raycast" then
                                -- Modern API: caller expects RaycastResult fields
                                return {Instance = tR, Position = pos,
                                        Normal = Vector3.new(0, 1, 0),
                                        Material = Enum.Material.SmoothPlastic}
                            else
                                -- Legacy API: returns (BasePart, Vector3, normal, material)
                                return tR, pos, Vector3.new(0, 1, 0), Enum.Material.SmoothPlastic
                            end
                        end
                    end
                end
                return _saOrigNC(self, ...)
            end))
        end
    end
end

-- ============================================================
-- AlignPosition is a physics constraint processed by Roblox server-side.
-- ReactionForceEnabled=false → pulls OUR body to the target, not vice versa.
-- Heartbeat CFrame mirrors raw (hook-bypassed) position each physics step.
-- Velocity MATCHING (not zeroing): both bodies move identically from the
-- server's view → CFrame delta is physics-plausible → no server rejection.
-- ============================================================

local function rawCFrame(part)
    if not part then return nil end
    local ok, cf = pcall(rawget, part, "CFrame")
    if ok and cf and typeof(cf) == "CFrame" then return cf end
    local ok2, cf2 = pcall(function()
        return gethiddenproperty and gethiddenproperty(part, "CFrame") or nil
    end)
    if ok2 and cf2 and typeof(cf2) == "CFrame" then return cf2 end
    local ok3, pos = pcall(rawget, part, "Position")
    if ok3 and pos and typeof(pos) == "Vector3" then return CFrame.new(pos) end
    local ok4, cf4 = pcall(function() return part.CFrame end)
    return (ok4 and cf4) or nil
end

local function rawPos(part)
    local cf = rawCFrame(part); return cf and cf.Position or nil
end

-- ── Anti-Sit ──────────────────────────────────────────────────────────────
local _antiSitConn = nil
local function enableAntiSit()
    if _antiSitConn then return end
    _antiSitConn = RunService.Heartbeat:Connect(function()
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum and hum.Sit then pcall(function() hum.Sit = false end) end
    end)
end
local function disableAntiSit()
    if _antiSitConn then _antiSitConn:Disconnect(); _antiSitConn = nil end
end

-- ============================================================
-- SERVER WELD
-- ============================================================
local WeldActive  = false
local WeldTarget  = nil
local _weldConn   = nil
local _weldMethod = nil  -- tracks active method for cleanup

local WELD_METHOD_LIST = { "Motor6D", "Connection Exploit" }

local function StopWeld()
    WeldActive = false; WeldTarget = nil
    if _weldConn then _weldConn:Disconnect(); _weldConn = nil end
    if _weldMethod == "Connection Exploit" then
        -- Restoration pulse: set PhysicsRepRootPart back to self for several consecutive
        -- frames. A single one-shot restore can be lost to a stale network packet or a
        -- silent pcall failure; repeating it for ~8 frames guarantees the value sticks.
        local _restMyR = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if _restMyR and sethiddenproperty then
            local _restFrames = 0
            local _restConn
            _restConn = RunService.Heartbeat:Connect(function()
                _restFrames = _restFrames + 1
                pcall(function()
                    if _restMyR and _restMyR.Parent then
                        sethiddenproperty(_restMyR, 'PhysicsRepRootPart', _restMyR)
                    end
                end)
                if _restFrames >= 8 then _restConn:Disconnect() end
            end)
        end
    end
    _weldMethod = nil
end

local function StartWeld(targetOverride, methodOverride)
    if _weldConn then _weldConn:Disconnect(); _weldConn = nil end
    _weldMethod = nil; WeldActive = false; WeldTarget = nil

    local target = targetOverride or (CurrentTarget and CurrentTarget.Character and CurrentTarget) or selectTarget()
    if not target or not target.Character then Library:Notify("⚠ Sin target para Weld."); return end
    local myChar = LocalPlayer.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    local tRoot  = target.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot or not tRoot then Library:Notify("⚠ Sin HRP."); return end

    local method = methodOverride or Opt('WeldMethod', 'Motor6D')

    if method == "Connection Exploit" then
        WeldTarget = target; WeldActive = true; _weldMethod = method
        _weldConn = RunService.Heartbeat:Connect(LPH_NO_VIRTUALIZE(function()
            if not WeldActive then return end
            local tChar = WeldTarget and WeldTarget.Character
            local tR    = tChar and tChar:FindFirstChild("HumanoidRootPart")
            if not tR or not tR.Parent then StopWeld(); return end
            local myR = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if not myR or not myR.Parent then StopWeld(); return end
            pcall(function()
                -- Solo PhysicsRepRootPart: el servidor nos ve en la posición del target.
                -- El strafe y el usuario controlan el CFrame visualmente sin interferencia.
                sethiddenproperty(myR, 'PhysicsRepRootPart', tR)
            end)
        end))
        Library:Notify("🔗 Connection Exploit → " .. target.Name)
    else
        -- Motor6D Hack: zerear joints, luego CFrame + velocity match cada frame
        for _, m in ipairs(myChar:GetDescendants()) do
            if m:IsA("Motor6D") then
                pcall(function() m.C0 = CFrame.new(); m.C1 = CFrame.new() end)
            end
        end
        WeldTarget = target; WeldActive = true; _weldMethod = method
        _weldConn = RunService.Heartbeat:Connect(LPH_NO_VIRTUALIZE(function()
            if not WeldActive then return end
            local tChar = WeldTarget and WeldTarget.Character
            local tR    = tChar and tChar:FindFirstChild("HumanoidRootPart")
            if not tR or not tR.Parent then StopWeld(); return end
            local myR = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if not myR or not myR.Parent then StopWeld(); return end
            local rawCF  = rawCFrame(tR)
            local realCF = rawCF or tR.CFrame
            if not realCF then return end
            pcall(function()
                myR.CFrame = realCF
                myR.AssemblyLinearVelocity = tR.AssemblyLinearVelocity
                State.DesyncLocation = realCF
            end)
        end))
        Library:Notify("bad weld to: " .. target.Name)
    end
end

Players.PlayerRemoving:Connect(function(p)
    if p == WeldTarget then StopWeld() end
end)
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5); StopWeld()
end)

-- Compatibility aliases
local function stopConnection() StopWeld() end
local function destroyWeld()    StopWeld() end

-- ============================================================
-- UI — MAIN TAB  (left: Animation Player)
-- ============================================================
local AnimGroup = Tabs.Main:AddLeftGroupbox('Animation Player')

AnimGroup:AddLabel('Animaciones guardadas', true)
AnimGroup:AddDropdown('AnimPlayerSelected', {
    Values  = GetAnimNames(),
    Default = 1,
    Text    = 'Seleccionar Animación',
    Multi   = false,
})
AnimGroup:AddButton({
    Text = 'Reproducir',
    Func = function()
        local name = Opt('AnimPlayerSelected', '')
        local id   = ANIM_DB[name]
        if not id or id == '' then
            Library:Notify("Sin ID para: " .. tostring(name)); return
        end
        PlayAnimationById(id)
        Library:Notify("Reproduciendo: " .. name)
    end,
})
AnimGroup:AddButton({
    Text = 'Detener animación',
    Func = function()
        StopCurrentAnimation()
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                local animator = hum:FindFirstChildOfClass("Animator")
                if animator then
                    for _, t in ipairs(animator:GetPlayingAnimationTracks()) do
                        pcall(function() t:Stop(0.1) end)
                    end
                end
            end
        end
        Library:Notify("Animación detenida.")
    end,
})
AnimGroup:AddSlider('AnimSpeed', {
    Text     = 'Velocidad',
    Default  = 1.0,
    Min      = 0.1,
    Max      = 5.0,
    Rounding = 1,
    Tooltip  = '1.0 = normal. Se aplica en tiempo real al emote activo.',
})

AnimGroup:AddDivider()
AnimGroup:AddLabel('Agregar animación custom', true)
AnimGroup:AddInput('AnimCustomName', { Text = 'Nombre', Default = '', Placeholder = 'ej: Mi Baile' })
AnimGroup:AddInput('AnimCustomId',
    { Text = 'Asset ID o Catalog ID', Default = '', Placeholder = 'rbxassetid://... o número' })
AnimGroup:AddButton({
    Text = 'Agregar y guardar',
    Func = function()
        local name = Opt('AnimCustomName', '')
        local raw  = Opt('AnimCustomId', '')
        if name == '' then
            Library:Notify("Pon un nombre primero."); return
        end
        if raw == '' then
            Library:Notify("Pon un ID primero."); return
        end

        -- Accept rbxassetid://... or plain number
        local finalId
        if raw:match("^rbxassetid://") then
            finalId = raw
        elseif raw:match("^%d+$") then
            finalId = "rbxassetid://" .. raw
        else
            Library:Notify("Formato inválido. Usa rbxassetid://ID o solo el número.")
            return
        end

        CustomAnimations[name] = finalId
        ANIM_DB[name]          = finalId
        SaveCustomAnimations()
        local newNames = GetAnimNames()
        Options['AnimPlayerSelected']:SetValues(newNames)
        Library:Notify("Guardado: " .. name .. " → " .. finalId)
    end,
})
AnimGroup:AddButton({
    Text = 'Borrar animación seleccionada',
    Func = function()
        local name = Opt('AnimPlayerSelected', '')
        if not CustomAnimations[name] then
            Library:Notify("Solo se pueden borrar animaciones custom, no las predefinidas.")
            return
        end
        CustomAnimations[name] = nil
        ANIM_DB[name]          = nil
        SaveCustomAnimations()
        local newNames = GetAnimNames()
        if #newNames > 0 then
            Options['AnimPlayerSelected']:SetValues(newNames)
        end
        Library:Notify("Borrado: " .. name)
    end,
})
AnimGroup:AddButton({
    Text = 'Reproducir por ID directo',
    Func = function()
        local raw = Opt('AnimCustomId', '')
        if raw == '' then
            Library:Notify("Pon un ID en el campo de arriba."); return
        end
        local finalId
        if raw:match("^rbxassetid://") then
            finalId = raw
        elseif raw:match("^%d+$") then
            finalId = "rbxassetid://" .. raw
        else
            Library:Notify("Formato inválido.")
            return
        end
        PlayAnimationById(finalId)
        Library:Notify("Reproduciendo ID: " .. finalId)
    end,
})

-- ============================================================
-- UI — RAGE TAB
-- ============================================================
-- LEFT: Resolver, AutoFire, RageBait, Backtrack
-- RIGHT: Ragebot (Strafe, ForceHit, Spectate)

local ResolverGroup = Tabs.Rage:AddLeftGroupbox('Resolver')
ResolverGroup:AddToggle('ResolverEnabled', { Text = 'Activar Resolver', Default = false })
ResolverGroup:AddLabel('esto es un consolidado de un resolver que hizo Claude Code, bastante bueno en mi opinion.', true)
ResolverGroup:AddSlider('PingAdjustment', {
    Text     = 'Ping (ms)',
    Default  = 60,
    Min      = 0,
    Max      = 1200,
    Rounding = 0,
    Suffix   = 'ms',
    Tooltip  = 'Compensación de latencia, no puedo auto-ajustar segun tu ping, las lecturas no son correctas, introduce tu ping manualmente.',
})
ResolverGroup:AddSlider('RSVTeleportThresh', {
    Text     = 'Teleport Thresh (st/s)',
    Default  = 12000,
    Min      = 500,
    Max      = 50000,
    Rounding = 0,
    Tooltip  = 'configuración de certeza para resolver, si no sabe que hace no lo toque :p',
})
ResolverGroup:AddLabel('Void Safety', true)
ResolverGroup:AddSlider('OutOfVoidBonus', {
    Text     = 'Void Safety (studs)',
    Default  = 0,
    Min      = 0,
    Max      = 2500,
    Rounding = 1,
    Tooltip  = '0 = ignorar. >0 = clamp de predicción sobre el suelo del void.',
})

local AutoFireGroup = Tabs.Rage:AddLeftGroupbox('Disparo Automático')
AutoFireGroup:AddToggle('AutoFireEnabled', {
    Text    = 'Activar',
    Default = false,
}):AddKeyPicker('AutoFireHotkey', { Default = 'none', Mode = 'Toggle', Text = 'Tecla Auto Fire' })
AutoFireGroup:AddDropdown('AutoFireMethod', {
    Values = { 'Mouse1Click' },
    Default = 1,
    Text = 'Método',
    Multi = false
})
AutoFireGroup:AddDropdown('AutoFirePart', {
    Values = { 'test1' },
    Default = 1,
    Text = 'no hace nada',
    Multi = false
})
AutoFireGroup:AddSlider('AutoFireMinConf',
    { Text = 'Confianza Mínima', Default = 55, Min = 0.01, Max = 100, Rounding = 0, Suffix = '%' })
AutoFireGroup:AddSlider('AutoFireRate',
    { Text = 'Disparos/seg', Default = 10, Min = 0.5, Max = 120, Rounding = 1, Suffix = '/s' })
AutoFireGroup:AddDivider()
AutoFireGroup:AddLabel('test module', true)
AutoFireGroup:AddToggle('AutoFireOnFFRemove', {
    Text    = 'test module',
    Default = true,
    Tooltip = 'test module',
})
AutoFireGroup:AddSlider('FFBurstCount', {
    Text = 'test module',
    Default = 5,
    Min = 1,
    Max = 30,
    Rounding = 0,
    Tooltip = 'test module',
})

local BaitTabbox = Tabs.Rage:AddLeftTabbox()
local BaitGroup  = BaitTabbox:AddTab('Void Spam')

BaitGroup:AddToggle('BaitEnabled', { Text = 'Void Spam', Default = false })
BaitGroup:AddToggle('BaitStandalone', {
    Text    = 'Modo Standalone',
    Default = false,
    Tooltip = 'Activa el Void Spam sin necesidad de Target Strafe activo',
})
BaitGroup:AddToggle('BaitDesyncEnabled', {
    Text    = 'Spoof Pos',
    Default = false,
    Tooltip = 'Usa desync flash en vez de teleport directo',
})
BaitGroup:AddDivider()
BaitGroup:AddLabel('Preset', true)
BaitGroup:AddDropdown('VoidSpamPreset', {
    Text    = 'Modo',
    Default = 'Spin',
    Values  = { 'Spin', 'UpDown', 'NaN', 'Random' },
    Tooltip = 'Spin: órbita a 50M studs | UpDown: ±300M quartersteps | NaN: coordenadas inválidas | Random: π×2147483647',
})
BaitGroup:AddDivider()
BaitGroup:AddLabel('Intervalos', true)
BaitGroup:AddSlider('InVoidTime',  { Text = 'En void',      Default = 0.5, Min = 0.1, Max = 2, Rounding = 2, Suffix = 's' })
BaitGroup:AddSlider('OutOfVoidTime', { Text = 'Fuera de void', Default = 0.5, Min = 0.1, Max = 2, Rounding = 2, Suffix = 's' })

local BTGroup = Tabs.Rage:AddLeftGroupbox('Backtrack Exploit')
BTGroup:AddToggle('AggressiveBacktrack', {
    Text = 'Backtrack',
    Default = false,
    Tooltip = 'client sided weld gimmick'
}
):AddKeyPicker('AggressiveBTKey', { Default = 'none', Mode = 'Toggle', Text = 'Tecla BT Agresivo' })
BTGroup:AddSlider('AggrBTDuration', {
    Text = 'Duración del Freeze',
    Default = 0.25,
    Min = 0.05,
    Max = 2.0,
    Rounding = 2,
    Suffix = 's',
    Tooltip = 'Cuánto tiempo se mantienen congelados los enemigos'
})
BTGroup:AddSlider('AggrBTCooldown', {
    Text = 'Cooldown',
    Default = 1.2,
    Min = 0.2,
    Max = 10.0,
    Rounding = 2,
    Suffix = 's',
    Tooltip = 'Tiempo entre cada activación del backtrack'
})


local RagebotGroup = Tabs.Rage:AddRightGroupbox('Ragebot')
RagebotGroup:AddToggle('TargetStrafe', { Text = 'Target Strafe', Default = false,
}):AddKeyPicker('StrafeHotkey', { Default = 'none', Mode = 'Toggle', Text = 'Tecla Strafe' })
RagebotGroup:AddToggle('StrafDesyncEnabled', { Text = 'Spoof Pos', Default = false })
RagebotGroup:AddToggle('AntiInvisible', {
    Text    = 'Anti-Invisible',
    Default = false,
    Tooltip = 'Orbita alrededor de la Head en vez del HRP para ignorar el truco de invisibilidad que mueve el HRP al vacío',
})
RagebotGroup:AddToggle('ConnectionExploit', {
    Text    = 'Connection Exploit',
    Default = false,
    Tooltip = 'usalo como segunda capa de fuerza para el resolver',
})
RagebotGroup:AddDropdown('StrafeMethod', {
    Values = { 'Normal', 'Hide', 'Random', 'Behind', 'Inside' },
    Default = 1,
    Text = 'Método',
    Multi = false
})
RagebotGroup:AddLabel('Configuración', true)
RagebotGroup:AddSlider('StrafeDistance',
    { Text = 'Distancia', Default = 10, Min = 0, Max = 50, Rounding = 1, Suffix = ' studs' })
RagebotGroup:AddSlider('StrafeHeight', {
    Text = 'Altura',
    Default = 0,
    Min = -20,
    Max = 20,
    Rounding = 5,
    Suffix =
    ' studs'
})
RagebotGroup:AddSlider('StrafeSpeed', { Text = 'Velocidad', Default = 5, Min = 1, Max = 400, Rounding = 1 })
RagebotGroup:AddSlider('RandomRange', {
    Text = 'Rango random',
    Default = 8.5,
    Min = 0,
    Max = 75,
    Rounding = 2,
    Suffix =
    ' studs'
})
RagebotGroup:AddToggle('ReturnToOrigin', { Text = 'Volver al Origen', Default = true })
RagebotGroup:AddDivider()
RagebotGroup:AddLabel('Comportamiento al morir el target', true)
RagebotGroup:AddToggle('FocusDeathFling', {
    Text    = 'Death Fling (al morir target)',
    Default = false,
    Tooltip = 'Al morir el target: usa Connection Exploit para attacharse server-side al cadáver durante el tiempo definido.',
})
RagebotGroup:AddSlider('DeathFlingDuration', {
    Text = 'Duración Pegado (s)',
    Default = 1.0,
    Min = 0.1,
    Max = 5.0,
    Rounding = 1,
    Suffix = 's'
})
RagebotGroup:AddToggle('IdleOnTargetDeath', {
    Text = 'Estado Idle (no retarget)',
    Default = false,
    Tooltip =
    'Al morir el target, strafea en círculo chico esperando que respawnee. Al respawnear, re-lockea automáticamente.'
})
RagebotGroup:AddButton({
    Text = 'Salir de Idle ahora',
    Func = function()
        IdleStateActive = false
        IdleStateTarget = nil
        IdleOrigin      = nil
        FocusTarget     = nil
        CurrentTarget   = nil
        TargetStrafeActive = false
        Library:Notify("Idle limpiado — buscando nuevo objetivo.")
    end,
})

RagebotGroup:AddDivider()
RagebotGroup:AddLabel('Espectador', true)
RagebotGroup:AddToggle('Spectate', { Text = 'Modo Espectador', Default = false }
):AddKeyPicker('SpectateHotkey', { Default = 'none', Mode = 'Toggle', Text = 'Tecla' })
RagebotGroup:AddSlider('CameraDistance', {
    Text = 'Distancia',
    Default = 15,
    Min = 2,
    Max = 80,
    Rounding = 1,
    Suffix =
    ' st'
})
RagebotGroup:AddSlider('CameraHeight',
    { Text = 'Altura', Default = 5, Min = -10, Max = 40, Rounding = 1, Suffix = ' st' })
RagebotGroup:AddDivider()
RagebotGroup:AddLabel('Custom Checks', true)
RagebotGroup:AddToggle('GlobalTeamCheck', {
    Text    = 'Team Check (global)',
    Default = false,
    Tooltip = 'Ignora a todos los jugadores en tu mismo equipo. Se aplica antes de cualquier otro check.',
})
RagebotGroup:AddDropdown('CustomChecks', {
    Values = { 'Forcefield', '"inf" salud', 'dead' }, Default = 1, Text = 'Checks extra', Multi = true,
})

-- RIGHT: Silent Aim
local SAGroup = Tabs.Rage:AddRightGroupbox('Silent Aim')
SAGroup:AddToggle('SilentAimEnabled', {
    Text    = 'Activar Silent Aim',
    Default = false,
    Tooltip = 'Redirige los disparos al target independientemente del crosshair. Sin check de FOV.',
})
SAGroup:AddDropdown('SilentAimMethod', {
    Values  = { 'Mouse.Hit', 'Camera Override', 'findPartOnRay' },
    Default = 1,
    Text    = 'Método',
    Multi   = false,
    Tooltip = 'Mouse.Hit: spoofa el hit del mouse (sin mover cámara). Camera Override: snapea la cámara al target. findPartOnRay: hookea el raycast (más compatible, requiere hookmetamethod).',
})
Toggles.SilentAimEnabled:OnChanged(function(v)
    if v then StartSilentAim() else StopSilentAim() end
end)
Options.SilentAimMethod:OnChanged(function()
    if Tog('SilentAimEnabled') then StartSilentAim() end
end)

-- RIGHT: Hitbox Expander
local HitboxGroup = Tabs.Rage:AddRightGroupbox('Hitbox Expander')
HitboxGroup:AddToggle('HitboxEnabled', {
    Text    = 'Activar',
    Default = false,
    Tooltip = 'Agranda el hitbox de todos los jugadores clientside. Solo visible localmente.',
})
HitboxGroup:AddDropdown('HitboxPart', {
    Values  = { 'HumanoidRootPart', 'Head', 'Torso', 'Left Arm', 'Right Arm', 'Left Leg', 'Right Leg' },
    Default = 1,
    Text    = 'Parte (R6)',
    Multi   = false,
    Tooltip = 'Qué parte expandir. HumanoidRootPart cubre el cuerpo entero.',
})
HitboxGroup:AddSlider('HitboxSize', {
    Text     = 'Tamaño',
    Default  = 10,
    Min      = 1,
    Max      = 30,
    Rounding = 1,
    Suffix   = ' st',
})
Toggles.HitboxEnabled:OnChanged(function(v)
    if not v then _hbxRevertAll() end
end)
Options.HitboxPart:OnChanged(function()
    -- Revierte la parte anterior; el Heartbeat re-expande con la nueva
    if Tog('HitboxEnabled') then _hbxRevertAll() end
end)
Options.HitboxSize:OnChanged(function()
    if not Tog('HitboxEnabled') then return end
    local sz = Opt('HitboxSize', 10)
    for part, _ in pairs(_hbxExpanded) do
        pcall(function()
            if part and part.Parent then part.Size = Vector3.new(sz, sz, sz) end
        end)
    end
end)

-- ============================================================
-- UI — EXPLOITS TAB
-- ============================================================
local ExLeft  = Tabs.Exploits:AddLeftGroupbox('Server Weld')
local ExRight = Tabs.Exploits:AddRightGroupbox('Exploits Extra')

-- ── Server Weld ───────────────────────────────────────────────────────────────
ExLeft:AddDropdown('WeldMethod', {
    Values  = WELD_METHOD_LIST,
    Default = 1,
    Text    = 'Método de Weld',
    Multi   = false,
    Tooltip = 'Motor6D: colapsa joints al HRP + CFrame match (delay de replicacion.) Connection Exploit: Algo Chistoso',
})
ExLeft:AddDivider()
ExLeft:AddToggle('AutoWeld', {
    Text    = 'Auto-Weld al target activo',
    Default = false,
    Tooltip = 'Se suelda al CurrentTarget automáticamente cuando strafe está activo.',
})
ExLeft:AddButton({
    Text = 'start',
    Func = function() StartWeld() end,
})
ExLeft:AddButton({
    Text = 'stop',
    Func = function() StopWeld(); Library:Notify("Weld detenido.") end,
})
-- ── Anti-Sit UI ───────────────────────────────────────────────────────────────
local AntiSitGroup = Tabs.Exploits:AddLeftGroupbox('Anti-Sit')
AntiSitGroup:AddToggle('AntiSit', {
    Text    = 'Anti-Sit',
    Default = false,
    Tooltip = 'Evita que el personaje se siente en asientos o vehículos.',
})
AntiSitGroup:AddLabel('no funciona en juegos r6')

-- PhysicsSenderRate (bonus utility)
ExRight:AddLabel('DFIntS2PhysicsSenderRate', true)
ExRight:AddToggle('PhysicsRateEnabled', { Text = 'Ajustar PhysicsSenderRate', Default = false })
ExRight:AddSlider('PhysicsSenderRate', { Text = 'Tasa', Default = 60, Min = 1, Max = 240, Rounding = 0, Suffix = ' Hz' })
ExRight:AddButton({
    Text = 'Aplicar',
    Func = function()
        if not Tog('PhysicsRateEnabled') then
            Library:Notify("Activa la opción primero."); return
        end
        local rate = Opt('PhysicsSenderRate', 60)
        local ok = pcall(function() setfflag("DFIntS2PhysicsSenderRate", tostring(math.floor(rate))) end)
        if not ok then ok = pcall(function() setfastflag("DFIntS2PhysicsSenderRate", tostring(math.floor(rate))) end) end
        Library:Notify(ok and string.format("PhysicsSenderRate = %d Hz", math.floor(rate)) or "setfflag no soportado.")
    end
})
ExRight:AddButton({
    Text = 'Leer Valor',
    Func = function()
        local ok, val = pcall(function() return getfflag("DFIntS2PhysicsSenderRate") end)
        if not ok then ok, val = pcall(function() return getfastflag("DFIntS2PhysicsSenderRate") end) end
        Library:Notify(ok and ("DFIntS2PhysicsSenderRate = " .. tostring(val)) or "getfflag no soportado.")
    end
})

-- ============================================================
-- UI — VISUALS TAB  v3.3
-- ============================================================

-- LEFT: Aura de Jugador
local AuraGroup = Tabs.Visuals:AddLeftGroupbox('Aura de Jugador')
AuraGroup:AddToggle('AuraEnabled', { Text = 'Activar Aura', Default = false })
AuraGroup:AddDropdown('AuraPreset', {
    Values  = AURA_PRESET_NAMES,
    Default = 1,
    Text    = 'Tipo de Aura',
    Multi   = false,
    Tooltip = 'Fuego Infernal · Tormenta Eléctrica · Sombra Oscura · Divino · Demonio Rojo · Hielo Eterno · Tóxico · Prisma · Alas de Fuego · Void Eternal · Neon Cyberpunk',
})
AuraGroup:AddDivider()
AuraGroup:AddLabel('Parámetros', true)
AuraGroup:AddSlider('AuraIntensity', {
    Text     = 'Intensidad',
    Default  = 1.0,
    Min      = 0.1,
    Max      = 3.0,
    Rounding = 1,
    Suffix   = 'x',
    Tooltip  = 'Multiplica la tasa de partículas y brillo de luces.',
})
AuraGroup:AddSlider('AuraSize', {
    Text     = 'Tamaño',
    Default  = 1.0,
    Min      = 0.1,
    Max      = 3.0,
    Rounding = 1,
    Suffix   = 'x',
    Tooltip  = 'Multiplica el tamaño de partículas, Fire, Smoke y rango de luces.',
})

local function _restartAuraIfOn()
    if Tog('AuraEnabled') then StartAura(Opt('AuraPreset', 'Sin Aura')) end
end

Toggles.AuraEnabled:OnChanged(function(v)
    if v then StartAura(Opt('AuraPreset', 'Sin Aura')) else StopAura() end
end)
Options.AuraPreset:OnChanged(function(v)
    if Tog('AuraEnabled') then StartAura(v) end
end)
Options.AuraIntensity:OnChanged(_restartAuraIfOn)
Options.AuraSize:OnChanged(_restartAuraIfOn)

local IndicatorsGroup = Tabs.Visuals:AddLeftGroupbox('Posiciones de Indicadores')
IndicatorsGroup:AddToggle('ShowActionIndicator', { Text = 'Indicador de Acción', Default = true })
IndicatorsGroup:AddToggle('ShowResolverIndicator', { Text = 'Indicador de Resolver', Default = true })
IndicatorsGroup:AddToggle('ShowAggressiveBTIndicator', { Text = 'Indicador BT Agresivo', Default = true })
IndicatorsGroup:AddSlider('IndicatorX', { Text = 'Acción X', Default = 8, Min = 0, Max = 1920, Rounding = 0 })
IndicatorsGroup:AddSlider('IndicatorY', { Text = 'Acción Y', Default = 8, Min = 0, Max = 1080, Rounding = 0 })
IndicatorsGroup:AddSlider('ResolverIndicatorX', { Text = 'Resolver X', Default = 8, Min = 0, Max = 1920, Rounding = 0 })
IndicatorsGroup:AddSlider('ResolverIndicatorY', { Text = 'Resolver Y', Default = 180, Min = 0, Max = 1080, Rounding = 0 })

-- RIGHT: Impact Effects + Beam Tracers
local HitFXGroup = Tabs.Visuals:AddRightGroupbox('Efectos de Impacto')
HitFXGroup:AddToggle('HitChamsEnabled', { Text = 'Hit Chams', Default = false })
HitFXGroup:AddLabel('Color'):AddColorPicker('HitChamsColor', {
    Default = Color3.fromRGB(255, 50, 50), Title = 'Hit Chams Color', Transparency = 0
})
HitFXGroup:AddSlider('HitChamsDuration', {
    Text = 'Duración Chams', Default = 2, Min = 0.5, Max = 10, Rounding = 1, Suffix = 's'
})
HitFXGroup:AddDivider()
HitFXGroup:AddToggle('HitNotifsEnabled', { Text = 'Notificaciones de Impacto', Default = true })
HitFXGroup:AddToggle('KillNotifsEnabled', { Text = 'Notificaciones de Kill', Default = true })
HitFXGroup:AddDivider()
HitFXGroup:AddToggle('HitParticlesEnabled', { Text = 'Partículas de Impacto', Default = false })
HitFXGroup:AddDropdown('ParticleStyle', {
    Values  = PARTICLE_STYLE_NAMES,
    Default = 1,
    Text    = 'Estilo de Partículas',
    Multi   = false,
})

local TracerGroup = Tabs.Visuals:AddRightGroupbox('Beam Tracers')
TracerGroup:AddToggle('HitTracersEnabled', { Text = 'Beam Tracer (al golpear)', Default = false })
TracerGroup:AddDropdown('HitTracerSource', {
    Values  = { 'HRP Local', 'HRP Desync' },
    Default = 1,
    Text    = 'Origen',
    Multi   = false,
})
TracerGroup:AddDropdown('HitTracerTexture', {
    Values  = BEAM_TRACER_NAMES,
    Default = 1,
    Text    = 'Textura / Estilo',
    Multi   = false,
})
TracerGroup:AddSlider('HitTracerThickness', {
    Text = 'Grosor', Default = 0.2, Min = 0.05, Max = 1.5, Rounding = 2, Suffix = ' st'
})
TracerGroup:AddSlider('HitTracerDuration', {
    Text = 'Duración', Default = 1.5, Min = 0.5, Max = 8, Rounding = 1, Suffix = 's'
})
TracerGroup:AddLabel('Color'):AddColorPicker('HitTracerColor', {
    Default = Color3.fromRGB(220, 50, 50), Title = 'Hit Tracer Color', Transparency = 0
})



-- ============================================================
-- UI — MAIN TAB right: Target Selection + HitSounds
-- ============================================================
local MainRight = Tabs.Main:AddRightGroupbox('Selección de Objetivo')
MainRight:AddDropdown('SelectionMethod', {
    Values = { 'Posicion', 'Mouse' }, Default = 1, Text = 'Método de Selección', Multi = false
})
MainRight:AddDivider()

-- ── Friend List ────────────────────────────────────────────────────────────────
local FriendGroup = Tabs.Main:AddRightGroupbox('Friend List')
FriendGroup:AddLabel('Amigos nunca serán targetados ni en focus.', true)
FriendGroup:AddLabel('Se guarda en: symbolhit_friends.json')
FriendGroup:AddInput('FriendInput', {
    Text        = 'Username',
    Default     = '',
    Placeholder = 'Nombre de usuario exacto',
})
FriendGroup:AddButton({
    Text = '+ Añadir amigo',
    Func = function()
        local name = Opt('FriendInput', '')
        if name == '' then
            Library:Notify("Pon un username primero."); return
        end
        FriendList[name] = true
        saveFriendList()
        -- Clear focus/target if they were focused
        if FocusTarget and (FocusTarget.Name == name or FocusTarget.DisplayName == name) then
            FocusTarget = nil; CurrentTarget = nil
        end
        Library:Notify("✅ " .. name .. " añadido a Friend List.")
    end,
})
FriendGroup:AddButton({
    Text = '- Remover amigo',
    Func = function()
        local name = Opt('FriendInput', '')
        if name == '' then
            Library:Notify("Pon el username a remover."); return
        end
        FriendList[name] = nil
        saveFriendList()
        Library:Notify("❌ " .. name .. " removido de Friend List.")
    end,
})
FriendGroup:AddButton({
    Text = '📋 Listar amigos (Output)',
    Func = function()
        local list = {}
        for name in pairs(FriendList) do table.insert(list, name) end
        if #list == 0 then
            Library:Notify("Friend List vacía.")
        else
            table.sort(list)
            Library:Notify("Amigos: " .. table.concat(list, ", "))
            print("[Symbol.Hit] Friend List:", table.concat(list, ", "))
        end
    end,
})
FriendGroup:AddButton({
    Text = '🗑 Limpiar toda la lista',
    Func = function()
        FriendList = {}
        saveFriendList()
        Library:Notify("Friend List limpiada.")
    end,
})

local HitStuffGroup = Tabs.Main:AddRightGroupbox('Hit Sounds')
HitStuffGroup:AddToggle('Hit_Sounds', { Text = 'Hit Sounds', Default = false })
HitStuffGroup:AddDropdown('Hit_SoundType', {
    Values = HitSoundNames,
    Default = 1,
    Text = 'Seleccionar Sonido',
})
HitStuffGroup:AddSlider('HitSoundVolume', {
    Text     = 'Volumen',
    Default  = 0.5,
    Min      = 0.0,
    Max      = 5.0,
    Rounding = 2,
})
HitStuffGroup:AddButton({
    Text = 'Reproducir seleccionado',
    Func = function()
        local name = Opt('Hit_SoundType', 'resetirl')
        PreviewSound(name)
        Library:Notify("Reproduciendo: " .. name)
    end,
})

-- ============================================================
-- MAIN LOOP (HEARTBEAT - Físicas y Strafe)
-- ============================================================
RunService.Heartbeat:Connect(function()
    State.VoidFlashReady = false
    local strafeOn     = Tog('TargetStrafe')
    local strafeDesync = Tog('StrafDesyncEnabled')
    local spectateOn   = Tog('Spectate')
    local baitOn         = Tog('BaitEnabled')
    local baitDesync     = baitOn and Tog('BaitDesyncEnabled')
    local baitStandalone = baitOn and Tog('BaitStandalone')
    local resolverOn     = Tog('ResolverEnabled')

    -- Hitbox Expander: expand enemy parts every frame (handles respawns automatically)
    if Tog('HitboxEnabled') then
        local _hbxPart = Opt('HitboxPart', 'HumanoidRootPart')
        local _hbxSz   = Opt('HitboxSize', 10)
        for _, _hbxPlr in ipairs(Players:GetPlayers()) do
            if _hbxPlr == LocalPlayer then continue end
            local _hbxChar = _hbxPlr.Character
            if not _hbxChar then continue end
            local _hbxP = _hbxChar:FindFirstChild(_hbxPart)
            if _hbxP and _hbxP:IsA("BasePart") then
                _hbxExpandPart(_hbxP, _hbxSz)
            end
        end
    end

    if baitOn then
        TickVoidSpam()
        -- Standalone + Spoof Pos OFF: teleport directo sin desync
        if baitStandalone and not baitDesync and State.InVoid and not TargetStrafeActive then
            local _bc = LocalPlayer.Character
            local _br = _bc and _bc:FindFirstChild("HumanoidRootPart")
            if _br then pcall(function() _br.CFrame = State.VoidSpamCFrame end) end
        end
    end

    State.StrafeFinalReady = false

    TickAggressiveBacktrack()

    if strafeOn then
        -- ── Target death ──────────────────────────────────────────────────────────
        local isTargetDead = false
        if CurrentTarget and CurrentTarget.Character then
            local hum = CurrentTarget.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health <= 0 then
                isTargetDead = true
            end
        end

        if isTargetDead then
            -- Debounce: algunos juegos disparan la muerte 2 veces en el mismo tick.
            -- Solo procesar acciones una vez cada 4s por jugador.
            local _dname = CurrentTarget and CurrentTarget.Name
            local _now   = tick()
            local _fresh = not _dname
                or not _deathDebounce[_dname]
                or (_now - _deathDebounce[_dname] >= 4)
            if _fresh and _dname then _deathDebounce[_dname] = _now end

            -- Death Fling: Connection Exploit — server ve al jugador en el cadáver
            if _fresh and Tog('FocusDeathFling') then
                local deadTarget = CurrentTarget
                local char       = deadTarget.Character
                local name       = deadTarget.Name
                local now        = tick()

                if not FlingHistory[name] or (now - FlingHistory[name] > 10) then
                    FlingHistory[name] = now
                    task.spawn(function()
                        local torso = char and (char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso"))
                        if not torso then return end
                        local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if not myRoot then return end
                        local duration = Opt('DeathFlingDuration', 1.0)
                        -- Attach server-side via Connection Exploit every frame
                        local flingConn = RunService.Heartbeat:Connect(function()
                            pcall(function()
                                if sethiddenproperty then
                                    sethiddenproperty(myRoot, 'PhysicsRepRootPart', torso)
                                end
                            end)
                        end)
                        task.wait(duration)
                        flingConn:Disconnect()
                        -- Restore own root as PhysicsRepRootPart
                        pcall(function()
                            if sethiddenproperty then
                                sethiddenproperty(myRoot, 'PhysicsRepRootPart', myRoot)
                            end
                        end)
                        Library:Notify("💀 Death Fling aplicado a " .. deadTarget.Name)
                    end)
                end
            end

            -- Congelar espectador (solo en primer disparo del debounce)
            if _fresh and Tog('Spectate') and State.SpectateActive and not State.SpectateFrozen then
                FreezeSpectate(CurrentTarget)
            end

            if _fresh then
                if Tog('IdleOnTargetDeath') then
                    Library:Notify("Target eliminado — modo Idle activado.")
                    IdleStateTarget = CurrentTarget
                    FocusTarget     = CurrentTarget
                    IdleStateActive = true
                    IdleOrigin      = nil
                else
                    IdleStateActive = false
                end
            end
            CurrentTarget = nil
        elseif CurrentTarget and not isValidTarget(CurrentTarget) then
            -- Target is invalid for other reasons (FF, team, etc.) but NOT dead
            if WeldActive then StopWeld() end
            CurrentTarget = nil
            TargetStrafeActive = false
        end

        -- ── Idle active: void-teleport every frame, check respawn ──
        if IdleStateActive then
            TickIdleStrafe()
            -- If TickIdleStrafe exited idle (respawn detected), fall through
            -- to selectTarget below. Otherwise skip all strafe/shoot this frame.
            if IdleStateActive then return end
        end

        -- ── No target: auto-select ──
        if not CurrentTarget then
            CurrentTarget = selectTarget()
        end

        if CurrentTarget and CurrentTarget.Character then
            SetupHitDetect(CurrentTarget)
            if Tog('ConnectionExploit') and WeldTarget ~= CurrentTarget then
                StartWeld(CurrentTarget, 'Connection Exploit')
            elseif Tog('AutoWeld') and WeldTarget ~= CurrentTarget then
                StartWeld(CurrentTarget)
            end
            local char = LocalPlayer.Character
            if char then
                local root = char:FindFirstChild("HumanoidRootPart")
                local hum  = char:FindFirstChildOfClass("Humanoid")
                if root and hum then
                    -- ForceField check (pre-strafe and mid-strafe)
                    local _curFF = CurrentTarget.Character and CurrentTarget.Character:FindFirstChildOfClass("ForceField")
                    if _curFF then
                        local _ffRx = (math.random() * 2 - 1) * IDLE_RANGE
                        local _ffRz = (math.random() * 2 - 1) * IDLE_RANGE
                        local _ffCF = CFrame.new(_ffRx, IDLE_BASE_Y, _ffRz)
                        if Tog('StrafDesyncEnabled') then
                            State.VoidFlashCFrame = _ffCF
                            State.VoidFlashReady  = true
                        else
                            root.CFrame          = _ffCF
                            State.DesyncLocation = _ffCF
                        end
                        if not State._ffWatchConns[CurrentTarget.Name] then
                            watchFFRemoval(CurrentTarget)
                        end
                    else
                        if not TargetStrafeActive then
                            State.OriginalPosition = root.CFrame; TargetStrafeActive = true; watchFFRemoval(CurrentTarget)
                        end
                    end

                    local _antiInvis = Tog('AntiInvisible')
                    local _tHead     = _antiInvis and CurrentTarget.Character:FindFirstChild("Head")
                    -- Resolver muestrea el HRP; si Anti-Invisible está ON ese HRP es el fantasma → saltarlo
                    if resolverOn and not _antiInvis then UpdateResolver(CurrentTarget) end

                    local targetRoot = CurrentTarget.Character:FindFirstChild("HumanoidRootPart")
                    if targetRoot and not _curFF then
                        local targetPos
                        if _antiInvis and _tHead then
                            -- Offset en espacio local de la Head: si el exploit rota el jugador,
                            -- el "abajo local" sigue apuntando al cuerpo real, no al suelo del mundo
                            targetPos = (_tHead.CFrame * CFrame.new(0, -1.6832, 0)).Position
                        else
                            targetPos = targetRoot.Position
                            if resolverOn then
                                local rp = GetResolvedPosition(CurrentTarget); if rp then targetPos = rp end
                            end
                        end

                        -- Motor6D Hack bloquea strafe (controla CFrame directamente).
                        -- Connection Exploit solo controla PhysicsRepRootPart → strafe puede correr.
                        if not WeldActive or _weldMethod == "Connection Exploit" then
                            if strafeDesync then
                                root.Velocity = Vector3.new(0, 0, 0); root.RotVelocity = Vector3.new(0, 0, 0)
                                if baitDesync and State.InVoid then
                                    State.StrafeFinalCFrame = State.VoidSpamCFrame
                                else
                                    local sPos   = GetStrafePosition(targetPos, root.Position)
                                    local lookAt = Vector3.new(targetPos.X, sPos.Y, targetPos.Z)
                                    State.StrafeFinalCFrame = (sPos - lookAt).Magnitude > 0.01
                                        and CFrame.new(sPos, lookAt) or CFrame.new(sPos)
                                end
                                State.StrafeFinalReady = true
                            else
                                root.Velocity = Vector3.new(0, 0, 0); root.RotVelocity = Vector3.new(0, 0, 0)
                                if not baitDesync and baitOn and State.InVoid then
                                    -- Spoof Pos OFF: teleport directo al void
                                    root.CFrame = State.VoidSpamCFrame
                                else
                                    -- Normal strafe; bait+desync lo maneja el Desync Heartbeat
                                    local sPos   = GetStrafePosition(targetPos, root.Position)
                                    local lookAt = Vector3.new(targetPos.X, sPos.Y, targetPos.Z)
                                    root.CFrame  = (sPos - lookAt).Magnitude > 0.01
                                        and CFrame.new(sPos, lookAt) or CFrame.new(sPos)
                                end
                            end
                        end

                        if Tog('AutoFireEnabled') then
                            local conf   = CalculateConfidence(CurrentTarget)
                            local rst    = RSV_State(CurrentTarget.Name)
                            local tRoot  = CurrentTarget.Character and
                                           CurrentTarget.Character:FindFirstChild("HumanoidRootPart")

                            -- Clientside proximity check: if our resolved prediction lands near
                            -- the target's actual client position, the shot will register cleanly.
                            local clientDist = math.huge
                            if tRoot then
                                local resolvedPos = GetResolvedPosition(CurrentTarget)
                                if resolvedPos then
                                    clientDist = (resolvedPos - tRoot.Position).Magnitude
                                end
                            end

                            -- Fire if: normal confidence threshold met
                            --       OR resolved pos is within 8 studs of client position (good registration)
                            --       OR target is currently teleporting (conf=0) and we have history
                            --          → let connection/ragebot handle registration
                            local shouldFire = conf >= Opt('AutoFireMinConf', 55)
                                           or  clientDist <= 8
                                           or  (rst.teleporting and #rst.posLog > 5)

                            if shouldFire then
                                local now = tick(); local rate = Opt('AutoFireRate', 10)
                                if now - State.LastAutoFireTime >= (1 / math.max(rate, 0.1)) then
                                    State.LastAutoFireTime = now
                                    local method = Opt('AutoFireMethod', 'Mouse1Click')
                                    if method == 'Mouse1Click' then
                                        task.spawn(function()
                                            if tRoot then
                                                local sp = Camera:WorldToViewportPoint(tRoot.Position)
                                                if sp.Z > 0 then mouse1click() end
                                            end
                                        end)
                                    end
                                end
                            end
                        end
                    end
                end
            end

            if spectateOn then
                -- Descongelar si el target que murió ha reaparecido
                if State.SpectateFrozen and CurrentTarget == State.SpectateWasTarget then
                    _destroySpectateAnchor()
                    State.SpectateFrozen    = false
                    State.SpectateWasTarget = nil
                    State.SpectateFrozenCF  = nil
                    Camera.CameraType       = Enum.CameraType.Custom
                end
                if not State.SpectateActive then
                    State.OriginalCameraSubject = Camera.CameraSubject; State.SpectateActive = true
                end
                UpdateSpectate(CurrentTarget)
            elseif State.SpectateActive then
                -- No restaurar si la cámara está congelada esperando el respawn
                if not State.SpectateFrozen then
                    RestoreCamera()
                end
            end
        else
            if TargetStrafeActive then
                if Tog('ReturnToOrigin') and State.OriginalPosition then
                    local mr = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if mr then mr.CFrame = State.OriginalPosition end
                end
                local mc = LocalPlayer.Character
                TargetStrafeActive = false; State.OriginalPosition = nil
                TeardownHitDetect()
                if Tog('AutoWeld') or Tog('ConnectionExploit') then StopWeld() end
            end
            -- Espectador: si está congelado esperando respawn, mantener freeze.
            -- Si el target abandonó el juego, restaurar normalmente.
            if State.SpectateActive then
                local wasGone = State.SpectateFrozen
                    and (not State.SpectateWasTarget or not State.SpectateWasTarget.Parent)
                if not State.SpectateFrozen or wasGone then
                    RestoreCamera()
                end
            end
            CurrentTarget = nil
        end
    else
        if TargetStrafeActive then
            if Tog('ReturnToOrigin') and State.OriginalPosition then
                local mr = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if mr then mr.CFrame = State.OriginalPosition end
            end
            local mc = LocalPlayer.Character
            TargetStrafeActive = false; State.OriginalPosition = nil
            TeardownHitDetect()
            if Tog('AutoWeld') or Tog('ConnectionExploit') or WeldActive then StopWeld() end
        end
        -- Strafe apagado manualmente: limpiar freeze sin importar el estado del target
        if State.SpectateFrozen then
            _destroySpectateAnchor()
            State.SpectateFrozen    = false
            State.SpectateWasTarget = nil
            State.SpectateFrozenCF  = nil
            Camera.CameraType       = Enum.CameraType.Custom
        end
        if State.SpectateActive then RestoreCamera() end
        CurrentTarget = nil
    end
end)

-- ============================================================
-- MAIN LOOP (RENDERSTEPPED - Visuales)
-- ============================================================
RunService.RenderStepped:Connect(function()
    local conf = CurrentTarget and CalculateConfidence(CurrentTarget) or 0
    UpdateIndicators(conf)

    -- ── Notification render (hit + kill) ─────────────────────
    local now  = tick()
    local vp2  = Camera.ViewportSize

    -- Anchor to player's projected screen-space position
    local _nc  = LocalPlayer.Character
    local _nr  = _nc and _nc:FindFirstChild("HumanoidRootPart")
    local centerX, baseY
    if _nr then
        local _sp = Camera:WorldToViewportPoint(_nr.Position + Vector3.new(0, 2, 0))
        if _sp.Z > 0 then
            centerX = math.clamp(_sp.X, 80, vp2.X - 80)
            baseY   = math.clamp(_sp.Y, 60, vp2.Y - 60)
        end
    end
    centerX = centerX or vp2.X / 2
    baseY   = baseY   or vp2.Y * 0.55

    -- Kill notifications: stack above player, smooth fade
    for i = #KillNotifList, 1, -1 do
        local e = KillNotifList[i]
        if now - e.spawnT > e.duration then
            pcall(function() e.bg:Remove() end)
            pcall(function() e.accent:Remove() end)
            pcall(function() e.txt:Remove() end)
            table.remove(KillNotifList, i)
        end
    end
    for i, e in ipairs(KillNotifList) do
        local elapsed = now - e.spawnT
        local a_in    = math.min(elapsed / math.max(KILL_FADE_IN, 0.001), 1)
        local remain  = e.duration - elapsed
        local a_out   = (remain < KILL_FADE_OUT) and math.clamp(remain / KILL_FADE_OUT, 0, 1) or 1
        local alpha   = a_in * a_out
        local y       = baseY - 20 - i * (KILL_SLOT_H + NOTIF_SLOT_GAP)
        local w, h    = e.w, e.h
        e.bg.Position         = Vector2.new(centerX - w / 2, y)
        e.bg.Size             = Vector2.new(w, h)
        e.bg.Transparency     = math.clamp(0.35 + (1 - alpha) * 0.65, 0, 1)
        e.bg.Visible          = alpha > 0.01
        e.accent.Position     = Vector2.new(centerX - w / 2, y)
        e.accent.Size         = Vector2.new(3, h)
        e.accent.Transparency = 1 - alpha
        e.accent.Visible      = alpha > 0.01
        e.txt.Position        = Vector2.new(centerX, y + h / 2 - 7)
        e.txt.Transparency    = 1 - alpha
        e.txt.Visible         = alpha > 0.01
    end

    -- Hit notifications: stack below player, smooth fade
    for i = #HitNotifList, 1, -1 do
        local e = HitNotifList[i]
        if now - e.spawnT > e.duration then
            pcall(function() e.bg:Remove() end)
            pcall(function() e.accent:Remove() end)
            pcall(function() e.txt:Remove() end)
            table.remove(HitNotifList, i)
        end
    end
    for i, e in ipairs(HitNotifList) do
        local elapsed = now - e.spawnT
        local a_in    = math.min(elapsed / math.max(NOTIF_FADE_IN, 0.001), 1)
        local remain  = e.duration - elapsed
        local a_out   = (remain < NOTIF_FADE_OUT) and math.clamp(remain / NOTIF_FADE_OUT, 0, 1) or 1
        local alpha   = a_in * a_out
        local y       = baseY + 10 + (i - 1) * (NOTIF_SLOT_H + NOTIF_SLOT_GAP)
        local w, h    = e.w, e.h
        e.bg.Position         = Vector2.new(centerX - w / 2, y)
        e.bg.Size             = Vector2.new(w, h)
        e.bg.Transparency     = math.clamp(0.38 + (1 - alpha) * 0.62, 0, 1)
        e.bg.Visible          = alpha > 0.01
        e.accent.Position     = Vector2.new(centerX - w / 2, y)
        e.accent.Size         = Vector2.new(3, h)
        e.accent.Transparency = 1 - alpha
        e.accent.Visible      = alpha > 0.01
        e.txt.Position        = Vector2.new(centerX, y + h / 2 - 7)
        e.txt.Transparency    = 1 - alpha
        e.txt.Visible         = alpha > 0.01
    end
end)


-- ============================================================
-- DESYNC HEARTBEAT
-- ============================================================
RunService.Heartbeat:Connect(LPH_NO_VIRTUALIZE(function()
    -- Motor6D Hack tiene autoridad total de CFrame; Connection Exploit no bloquea desync.
    if WeldActive and _weldMethod ~= "Connection Exploit" then return end
    local strafeDesync   = Tog('StrafDesyncEnabled')
    local baitOn         = Tog('BaitEnabled')
    local baitDesync     = baitOn and Tog('BaitDesyncEnabled')
    local baitStandalone = baitOn and Tog('BaitStandalone')

    local anyDesync = (strafeDesync and TargetStrafeActive)
        or (baitDesync and TargetStrafeActive)
        or (baitDesync and baitStandalone)
        or State.VoidFlashReady
    if not anyDesync then return end

    local char = LocalPlayer.Character; if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart"); if not root then return end

    local look = root.CFrame.LookVector
    if State.DesyncPrevLook then
        local dot = math.clamp(State.DesyncPrevLook:Dot(look), -1, 1)
        State.DesyncSpinning = math.deg(math.acos(dot)) > 18
    end
    State.DesyncPrevLook = look
    if State.DesyncSpinning then return end

    local flashCFrame = nil
    if strafeDesync and TargetStrafeActive and State.StrafeFinalReady then
        State.DesyncLocation = root.CFrame; flashCFrame = State.StrafeFinalCFrame
    elseif State.VoidFlashReady then
        -- Idle / FF void teleport via spoof pos: flash server to void, client stays in place
        State.DesyncLocation = root.CFrame; flashCFrame = State.VoidFlashCFrame
    elseif baitDesync and (TargetStrafeActive or baitStandalone) then
        State.DesyncLocation = root.CFrame
        if State.InVoid then
            flashCFrame = State.VoidSpamCFrame
        elseif TargetStrafeActive and State.StrafeFinalReady then
            flashCFrame = State.StrafeFinalCFrame
        end
    end
    if not flashCFrame then return end

    local savedVel = root.AssemblyLinearVelocity
    root.CFrame = flashCFrame
    RunService.RenderStepped:Wait()
    root.CFrame = State.DesyncLocation
    pcall(function() root.AssemblyLinearVelocity = savedVel end)
end))

-- ============================================================
-- hookmetamethod
-- ============================================================
local OriginalIndex
OriginalIndex = hookmetamethod(game, "__index", function(self, key)
    if not checkcaller() then
        -- Intercept both CFrame and Position: Roblox's camera module reads .Position
        -- directly on the HRP during each render frame, bypassing the CFrame hook.
        -- Without this, the camera follows the spoof flash position for one frame.
        if not State.DesyncSpinning and (key == "CFrame" or key == "Position") then
            local char = LocalPlayer.Character
            if char and self == char:FindFirstChild("HumanoidRootPart") then
                local anyActive = (Tog('StrafDesyncEnabled') and TargetStrafeActive)
                    or (Tog('BaitEnabled') and Tog('BaitDesyncEnabled') and (TargetStrafeActive or Tog('BaitStandalone')))
                    or State.VoidFlashReady
                if anyActive then
                    if key == "Position" then return State.DesyncLocation.Position end
                    return State.DesyncLocation
                end
            end
        end
    end
    return OriginalIndex(self, key)
end)

local function OnLocalPlayerDied()
    TargetStrafeActive     = false
    State.InVoid           = false
    State.StrafeFinalReady = false
    State.VoidFlashReady   = false
    if Tog('ConnectionExploit') or Tog('AutoWeld') then StopWeld() end
end

LocalPlayer.CharacterAdded:Connect(function(char)
    -- Wire death handler for the new character immediately
    local hum = char:FindFirstChildOfClass("Humanoid")
        or char:WaitForChild("Humanoid", 5)
    if hum then
        hum.Died:Connect(OnLocalPlayerDied)
    end

    task.wait(0.5)
    State.DesyncPrevLook = nil; State.DesyncSpinning = false; State.DesyncLocation = CFrame.new()
    State.StrafeFinalReady = false; State.VoidFlashReady = false; TargetStrafeActive = false; CurrentTarget = nil
    State.VelocityHistory = {}; State.ForgivenessValues = {}; State.ClusterData = {}
    AggressiveFrozenStates = {}
    IdleStateActive = false; IdleOrigin = nil; IdleStateTarget = nil
end)

-- ============================================================
-- UI SETTINGS / SAVE / THEME
-- ============================================================
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })
ThemeManager:SetFolder('RageUtility')
SaveManager:SetFolder('RageUtility')
SaveManager:BuildConfigSection(Tabs['UI Settings'])
ThemeManager:ApplyToTab(Tabs['UI Settings'])
SaveManager:LoadAutoloadConfig()

task.defer(function()
    if Toggles['AntiSit'] then
        Toggles['AntiSit']:OnChanged(function(val)
            if val then enableAntiSit() else disableAntiSit() end
        end)
    end
    if Toggles['AutoWeld'] then
        Toggles['AutoWeld']:OnChanged(function(val)
            if val then
                StartWeld()
            else
                StopWeld()
                Library:Notify("Weld stop.")
            end
        end)
    end
    if Toggles['ConnectionExploit'] then
        Toggles['ConnectionExploit']:OnChanged(function(val)
            if val then
                StartWeld(nil, 'Connection Exploit')
            else
                StopWeld()
                Library:Notify("weld ")
            end
        end)
    end
end)

Library:SetWatermarkVisibility(false) -- using custom drawing watermark instead

-- ── Watermark ──────────────────────────────────────────────────────────────
local WatermarkConn
do
    local _detectedGame = "Unknown"
    pcall(function()
        local ok, info = pcall(function()
            return MarketplaceService:GetProductInfo(game.PlaceId)
        end)
        if ok and info and info.Name then
            _detectedGame = info.Name:sub(1, 28)
        end
    end)

    local _wmBg = Drawing.new("Square")
    _wmBg.Filled = true
    _wmBg.Color = Color3.fromRGB(5, 5, 8)
    _wmBg.Transparency = 0.45
    _wmBg.ZIndex = 20

    local _wmText = Drawing.new("Text")
    _wmText.Center = true
    _wmText.Size = 13
    _wmText.Outline = true
    _wmText.OutlineColor = Color3.fromRGB(0, 0, 0)
    _wmText.Color = Color3.fromRGB(200, 200, 210)
    _wmText.ZIndex = 21

    local function _getHour()
        local h, m
        pcall(function()
            local t = os.date("*t")
            h, m = t.hour, t.min
        end)
        if h then return string.format("%02d:%02d", h, m) end
        return ""
    end

    local FrameTimer, FrameCounter, FPS = tick(), 0, 60
    WatermarkConn = RunService.RenderStepped:Connect(function()
        FrameCounter = FrameCounter + 1
        if tick() - FrameTimer >= 1 then
            FPS = FrameCounter; FrameTimer = tick(); FrameCounter = 0
        end
        local ping = 0
        pcall(function() ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) end)
        local timeStr = _getHour()
        local wmStr = string.format(
            "Symbol.Hit v3.2 Pre Release  |  %s  |  %d fps  |  %d ms  |  %s",
            _detectedGame, math.floor(FPS), ping,
            timeStr ~= "" and timeStr or "??:??"
        )
        _wmText.Text = wmStr
        local vp = Camera.ViewportSize
        local tw = #wmStr * 7 + 20
        local th = 18
        local cx = vp.X / 2
        local y = vp.Y - th - 8
        _wmBg.Position = Vector2.new(cx - tw / 2, y)
        _wmBg.Size = Vector2.new(tw, th)
        _wmText.Position = Vector2.new(cx, y + th / 2 - 7)
        _wmBg.Visible = true
        _wmText.Visible = true
    end)
end

local MenuUI = Tabs['UI Settings']:AddLeftGroupbox('Menú')
MenuUI:AddButton('RAGE QUIT!!! (unload)', function() Library:Unload() end)
MenuUI:AddLabel('Tecla del Menú'):AddKeyPicker('MenuKeybind', { Default = 'End', NoUI = true, Text = 'Tecla Menú' })
Library.ToggleKeybind = Options.MenuKeybind

Library:OnUnload(function()
    StopWeld()
    StopSilentAim()
    StopAura()
    _hbxRevertAll()
    TeardownHitDetect()
    if State.SpectateActive then RestoreCamera() end
    if TargetStrafeActive and Tog('ReturnToOrigin') and State.OriginalPosition then
        local mr = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if mr then pcall(function() mr.CFrame = State.OriginalPosition end) end
    end
    local mc = LocalPlayer.Character
    if mc then
        local r = mc:FindFirstChild("HumanoidRootPart"); if r then pcall(function() r.CFrame = State.DesyncLocation end) end
    end
    for _, data in pairs(AggressiveFrozenStates) do
        if data.root and data.root.Parent then pcall(function() data.root.Anchored = false end) end
    end
    for _, e in ipairs(KillNotifList) do
        pcall(function() e.bg:Remove() end); pcall(function() e.accent:Remove() end); pcall(function() e.txt:Remove() end)
    end
    for _, e in ipairs(HitNotifList) do
        pcall(function() e.bg:Remove() end); pcall(function() e.accent:Remove() end); pcall(function() e.txt:Remove() end)
    end
    for _, e in ipairs(HitChamList) do pcall(function() if e.highlight and e.highlight.Parent then e.highlight:Destroy() end end) end
    for _, d in ipairs({ actionBg, actionLabel, aggressiveBg, aggressiveLabel,
        _xhTop, _xhBot, _xhLeft, _xhRight, _xhDot, _symLbl, _rsvL1, _rsvL2, _voidLbl }) do
        pcall(function() d:Remove() end)
    end
    if Mouse1HeldConnection then Mouse1HeldConnection:Disconnect() end
    WatermarkConn:Disconnect()
    Library.Unloaded = true
end)