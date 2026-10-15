-- AirshipRadio.luau (clean, final): anchored-rig hover. Clientside.
-- Tool 'Airship Radio' = summon/recall. Board = WASD+QE pilot, Space eject.
local P = game:GetService("Players")
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local player = P.LocalPlayer

local C = {
    ship = { L=26, W=11, H=6,
        altitude = 28, radius = 30, speed = 0.10,
        maxSpeed = 80, turn = 1.4, climb = 12, bob = 0.5,
    },
    spawn = { riseH = 100, dockAlt = 4 },
    pal = { hull=Color3.fromRGB(26,30,42), panel=Color3.fromRGB(38,42,58), frame=Color3.fromRGB(52,56,74),
            accent=Color3.fromRGB(0,220,255), glow=Color3.fromRGB(150,240,255), floor=Color3.fromRGB(28,32,44) },
}

local pal = C.pal

local shipRef = nil
if getgenv().__AIRSHIP then pcall(getgenv().__AIRSHIP.destroy); getgenv().__AIRSHIP = nil end

local function makePart(parent, props)
    local p = Instance.new("Part")
    p.Anchored = true; p.CanCollide = false
    p.CustomPhysicalProperties = PhysicalProperties.new(0.05, 0.3, 0.5, 1, 1)
    p.Parent = parent
    for k, v in pairs(props or {}) do p[k] = v end
    return p
end

local function buildBase(rest)
    return rest
end

-- After build, buildShip fills `ship._rests`.
local function buildShip(origin)
    local m = Instance.new("Model"); m.Name = "Airship"
    local root = Instance.new("Part")
    root.Name = "Root"; root.Size = Vector3.new(C.ship.W, 0.3, C.ship.L)
    root.CFrame = CFrame.new(origin + Vector3.new(0, C.spawn.riseH, 0))
    root.Anchored = true; root.Transparency = 1; root.CanCollide = false
    root.CustomPhysicalProperties = PhysicalProperties.new(0.05, 0.3, 0.5, 1, 1)
    root.Parent = m

    -- convenience
    local L,W,H = C.ship.L, C.ship.W, C.ship.H
    local function add(a, b, c)
        local name, props, pos
        if type(a) == "string" then
            name = a; props = b or {}; pos = c or Vector3.new()
        else
            props = a or {}; name = props.Name; pos = b or Vector3.new()
        end
        props.Name = name
        local part = makePart(m, props)
        part.CFrame = root.CFrame * CFrame.new(pos)
        return part
    end

    add({ Name="ShellTop", Size=Vector3.new(L*0.85,H*0.35,W*0.65), Material=Enum.Material.SmoothPlastic, Color=pal.hull }, Vector3.new(0, H*0.15, 0))
    add({ Name="ShellBot", Size=Vector3.new(L*0.85,H*0.35,W*0.65), Material=Enum.Material.SmoothPlastic, Color=pal.panel }, Vector3.new(0,-H*0.15,0))
    add({ Name="MidBand",  Size=Vector3.new(L*0.92,H*0.25,W*0.92), Material=Enum.Material.SmoothPlastic, Color=pal.frame}, Vector3.new(0,0,0))
    for _, s in ipairs({-1,1}) do
        add(s>0 and "StripR" or "StripL", { Size=Vector3.new(L*0.9,0.15,0.15), Material=Enum.Material.Neon, Color=pal.accent, Transparency=0.15 },
            Vector3.new(s*(W*0.47),0,0))
        add(s>0 and "WingR" or "WingL", { Size=Vector3.new(L*0.5,0.3,8), Material=Enum.Material.Neon, Color=pal.accent, Transparency=0.2 },
            Vector3.new(s*(W*0.5+2), -0.5, -1))
        add(s>0 and "FinR" or "FinL", { Size=Vector3.new(0.6,3.5,4), Material=Enum.Material.SmoothPlastic, Color=pal.frame },
            Vector3.new(s*3.5, 0.7*H, -L*0.35))
        add("Thr_"..(s>0 and "R" or "L"), { Shape=Enum.PartType.Cylinder, Size=Vector3.new(2.4,2.4,4), Material=Enum.Material.SmoothPlastic, Color=pal.hull },
            Vector3.new(s*(W*0.22), 0, -L*0.35))
        add("Glow_"..(s>0 and "R" or "L"), { Shape=Enum.PartType.Cylinder, Size=Vector3.new(0.8,0.8,2.2), Material=Enum.Material.Neon, Color=pal.glow, Transparency=0.15 },
            Vector3.new(s*(W*0.22), 0, -L*0.42))
    end
    add("Cockpit", { Size=Vector3.new(W*0.35, H*0.55, 5), Material=Enum.Material.Glass, Color=pal.accent, Transparency=0.4 },
        Vector3.new(0, H*0.15, L*0.33))
    add("Gondola", { Size=Vector3.new(W*0.5, 0.6, 6), Material=Enum.Material.SmoothPlastic, Color=pal.panel },
        Vector3.new(0, -H*0.5, L*0.15))

    -- ===== interior =====
    add("InteriorFloor", { Size=Vector3.new(L*0.4, 0.18, W*0.3), Material=Enum.Material.SmoothPlastic, Color=pal.floor, Transparency=0.05 },
        Vector3.new(0, -H*0.4, L*0.12))
    add("Dashboard", { Size=Vector3.new(W*0.4, 0.5, 3), Material=Enum.Material.SmoothPlastic, Color=Color3.fromRGB(20,24,32) },
        Vector3.new(0, -H*0.05, L*0.28))
    add("ScreenA", { Size=Vector3.new(0.08, 0.8, 1), Material=Enum.Material.Neon, Color=pal.accent, Transparency=0.1 },
        Vector3.new(-0.5, -H*0.05, L*0.32))
    add("ScreenB", { Size=Vector3.new(0.08, 0.8, 1), Material=Enum.Material.Neon, Color=pal.accent, Transparency=0.1 },
        Vector3.new(0.5, -H*0.05, L*0.32))
    for _, s in ipairs({-1, 1}) do
        add(s>0 and "BenchR" or "BenchL", { Size=Vector3.new(1.2, 0.6, 2.5), Material=Enum.Material.SmoothPlastic, Color=pal.frame },
            Vector3.new(s*(W*0.28), -H*0.4, 0))
    end
    for _, s in ipairs({-1, 1}) do
        add(s>0 and "WallR" or "WallL", { Size=Vector3.new(0.1, H*0.6, L*0.3), Material=Enum.Material.Glass, Color=pal.accent, Transparency=0.6 },
            Vector3.new(s*(W*0.4), -0.2, 0))
    end
    add("EngineCore", { Size=Vector3.new(W*0.6, 1.2, 4), Material=Enum.Material.SmoothPlastic, Color=Color3.fromRGB(20,22,32), Transparency=0.1 },
       Vector3.new(0, -0.9, -L*0.3))

    local light = Instance.new("PointLight")
    light.Brightness = 0.5; light.Color = pal.accent; light.Range = 14; light.Shadows = false; light.Parent = root

    m.Parent = game:FindFirstChild("Workspace") or workspace

    local ship = { root = root, assembly = m, hud = nil, alive = true, conn = nil,
      aimYaw = 0, patrolAngle = 0, pilot = false, ejectDebounce = false }
    local restMap = {}
    for _, c in ipairs(m:GetDescendants()) do
        if c:IsA("BasePart") and c ~= root then
            restMap[c] = root.CFrame:ToObjectSpace(c.CFrame)
        end
    end
    ship._rests = restMap
    return ship

end

local function restSnapshot(ship)
    local m = {}
    local root = ship.root
    for _, c in ipairs(ship.assembly:GetDescendants()) do
        if c:IsA("BasePart") and c ~= root then m[c] = root.CFrame:ToObjectSpace(c.CFrame) end
    end
    ship._rests = m
end

local function destroyShip()
    if not shipRef then return end
    if shipRef.conn then shipRef.conn:Disconnect() end
    if shipRef.hud and shipRef.hud.Parent then shipRef.hud:Destroy() end
    if shipRef.assembly and shipRef.assembly.Parent then shipRef.assembly:Destroy() end
    shipRef = nil
    getgenv().__AIRSHIP = nil
end

local function seatOccupiedByPlayer(seat)
    if not (seat and seat.Occupant) then return false end
    local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    return hum and seat.Occupant == hum
end

local function moveRests(ship, cf)
    local root = ship.root
    root.CFrame = cf
    for part, rest in pairs(ship._rests or {}) do
        part.CFrame = root.CFrame * rest
    end
end

local function updateShip(ship, dt)
    local root = ship.root
    if not (root and root.Parent) then return end
    if not ship._rests then return end
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    local playerPos = hrp and hrp.Position or root.Position

    local seated = seatOccupiedByPlayer(ship.seat)
    ship.pilot = seated

    if seated then
        local keys = UserInputService
        local throttle = (keys:IsKeyDown(Enum.KeyCode.W) and 1 or 0) - (keys:IsKeyDown(Enum.KeyCode.S) and 1 or 0)
        local yawDelta = (keys:IsKeyDown(Enum.KeyCode.D) and 1 or 0) - (keys:IsKeyDown(Enum.KeyCode.A) and 1 or 0)
        local vertical = (keys:IsKeyDown(Enum.KeyCode.Q) and 1 or 0) - (keys:IsKeyDown(Enum.KeyCode.E) and 1 or 0)

        ship.aimYaw = ship.aimYaw + yawDelta * C.ship.turn * dt
        local step = CFrame.Angles(0, ship.aimYaw, 0).LookVector * throttle * C.ship.maxSpeed * dt * 0.3
        local newPos = root.Position + step + Vector3.new(0, vertical * C.ship.climb * dt * 0.3, 0)
        moveRests(ship, CFrame.new(newPos) * CFrame.Angles(0, ship.aimYaw, 0))
        if ship.hud and ship.hudHint then ship.hudHint.Text = "Pilot — WASD thrust, Q/E altitude, Space eject." end

        if keys:IsKeyDown(Enum.KeyCode.Space) and not ship.ejectDebounce then
            ship.ejectDebounce = true
            ship.seat.Occupant = nil
            ship.pilot = false
            pcall(function() local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
                if hum then hum.Sit = false end
            end)
        elseif not keys:IsKeyDown(Enum.KeyCode.Space) then
            ship.ejectDebounce = false
        end
    else
        ship.ejectDebounce = false
        ship.patrolAngle = (ship.patrolAngle or 0) + C.ship.speed * dt
        local ga = ship.patrolAngle
        goal = ship.anchorPos + Vector3.new(math.cos(ga)*C.ship.radius, C.ship.altitude, math.sin(ga)*C.ship.radius)
        local mag = (goal - root.Position).Magnitude
        local mv = (mag > 0.1) and (goal - root.Position).Unit * math.min(mag, C.ship.maxSpeed*dt) or Vector3.zero
        local newYaw = ship.aimYaw + (math.atan2(goal.X - root.Position.X, goal.Z - root.Position.Z) - ship.aimYaw) * math.min(1, dt*1.5)
        moveRests(ship, CFrame.new(root.Position + mv) * CFrame.Angles(0, newYaw, 0))
        ship.aimYaw = newYaw
        if ship.hud and ship.hudHint then ship.hudHint.Text = "Autopilot — roaming patrol ~"..math.floor(C.ship.radius)..". Step in: WASD+QE, Space eject." end
    end
end

local function buildHUD(ship)
    if ship.hud then pcall(function() ship.hud:Destroy() end) end
    local sg = Instance.new("ScreenGui")
    sg.Name = "AirshipHUD"; sg.ResetOnSpawn = false; sg.IgnoreGuiInset = true
    sg.Parent = player:WaitForChild("PlayerGui")
    local fr = Instance.new("Frame")
    fr.Size = UDim2.new(0, 390, 0, 74); fr.AnchorPoint = Vector2.new(0.5, 1)
    fr.Position = UDim2.new(0.5,0,0.94,0); fr.BackgroundTransparency = 0.32
    fr.BackgroundColor3 = Color3.fromRGB(14,18,32); fr.BorderSizePixel = 0; fr.Parent = sg
    local t = Instance.new("TextLabel")
    t.Size = UDim2.new(1,-12,0,18); t.Position = UDim2.new(0,6,0,5); t.BackgroundTransparency = 1
    t.TextXAlignment = Enum.TextXAlignment.Left
    t.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json"); t.TextSize = 14
    t.TextColor3 = Color3.fromRGB(0,220,255); t.Text = "KESTREL — Air Mobility"
    t.Parent = fr
    local h = Instance.new("TextLabel")
    h.Size = UDim2.new(1,-12,0,44); h.Position = UDim2.new(0,6,0,26); h.BackgroundTransparency = 1
    h.TextXAlignment = Enum.TextXAlignment.Left; h.TextYAlignment = Enum.TextYAlignment.Top
    h.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json"); h.TextSize = 12
    h.TextWrapped = true; h.TextColor3 = Color3.fromRGB(170,180,210)
    h.Text = "Patrol. Step onto the gondola to take control.\nPilot: WASD thrust, Q/E altitude, Space eject."
    h.Parent = fr
    ship.hud = sg; ship.hudHint = h
end

local function buildRadioTool()
    local tool = Instance.new("Tool")
    tool.Name = "Airship Radio"; tool.RequiresHandle = true; tool.CanBeDropped = false

    local h = Instance.new("Part")
    h.Name = "Handle"
    h.Size = Vector3.new(0.9, 0.4, 0.35)
    h.Color = Color3.fromRGB(18, 20, 26)
    h.Material = Enum.Material.SmoothPlastic
    h.Anchored = false; h.CanCollide = false
    h.Parent = tool

    local body = Instance.new("Part")
    body.Name = "Body"
    body.Size = Vector3.new(0.95, 1.2, 0.35)
    body.Color = Color3.fromRGB(24, 28, 34)
    body.Material = Enum.Material.SmoothPlastic
    body.Anchored = false; body.CanCollide = false
    body.CFrame = h.CFrame * CFrame.Angles(0, math.rad(90), math.rad(90)) * CFrame.new(0, -0.3, 0)
    body.Parent = tool
    local w0 = Instance.new("WeldConstraint"); w0.Part0 = h; w0.Part1 = body; w0.Parent = h

    local plate = Instance.new("Part")
    plate.Name = "Plate"
    plate.Size = Vector3.new(0.85, 1.1, 0.02)
    plate.Color = Color3.fromRGB(40, 46, 60)
    plate.Material = Enum.Material.SmoothPlastic
    plate.Anchored = false; plate.CanCollide = false
    plate.CFrame = body.CFrame * CFrame.new(0, 0, -0.07)
    plate.Parent = tool
    local w1 = Instance.new("WeldConstraint"); w1.Part0 = h; w1.Part1 = plate; w1.Parent = h

    -- neon accent bar across the body
    local neonBar = Instance.new("Part")
    neonBar.Name = "NeonBar"
    neonBar.Size = Vector3.new(0.75, 0.05, 0.03)
    neonBar.Color = Color3.fromRGB(0, 220, 255)
    neonBar.Material = Enum.Material.Neon
    neonBar.Anchored = false; neonBar.CanCollide = false
    neonBar.CFrame = body.CFrame * CFrame.new(0, -0.45, -0.07)
    neonBar.Parent = tool
    local wa = Instance.new("WeldConstraint"); wa.Part0 = h; wa.Part1 = neonBar; wa.Parent = h

    -- antenna up top
    local ant = Instance.new("Part")
    ant.Name = "Antenna"
    ant.Size = Vector3.new(0.05, 1.1, 0.05)
    ant.Color = Color3.fromRGB(40, 40, 46)
    ant.Material = Enum.Material.SmoothPlastic
    ant.Anchored = false; ant.CanCollide = false
    ant.CFrame = body.CFrame * CFrame.new(0.35, 0.55, 0) * CFrame.Angles(0,0,0)
    ant.Parent = tool
    local wb = Instance.new("WeldConstraint"); wb.Part0 = h; wb.Part1 = ant; wb.Parent = h

    local tip = Instance.new("Part")
    tip.Name = "AntennaTip"
    tip.Size = Vector3.new(0.12, 0.12, 0.12)
    tip.Material = Enum.Material.Neon
    tip.Color = Color3.fromRGB(255, 100, 60)
    tip.Anchored = false; tip.CanCollide = false
    tip.Shape = Enum.PartType.Ball
    tip.CFrame = body.CFrame * CFrame.new(0.35, 1.1, 0)
    tip.Parent = tool
    local wc = Instance.new("WeldConstraint"); wc.Part0 = h; wc.Part1 = tip; wc.Parent = h

    local indicator = Instance.new("Part")
    indicator.Name = "Indicator"
    indicator.Size = Vector3.new(0.4, 0.05, 0.02)
    indicator.Color = Color3.fromRGB(0, 220, 255)
    indicator.Material = Enum.Material.Neon
    indicator.Anchored = false; indicator.CanCollide = false
    indicator.Transparency = 0.1
    indicator.CFrame = body.CFrame * CFrame.new(-0.2, -0.35, -0.07)
    indicator.Parent = tool
    local wi = Instance.new("WeldConstraint"); wi.Part0 = h; wi.Part1 = indicator; wi.Parent = h

    tool.Activated:Connect(function()
        if shipRef then
            destroyShip()
            task.wait(0.2)
            summonAirship()
        else
            summonAirship()
        end
    end)
    return tool
end

print("[Airship] ready. Click 'Airship Radio' to summon; WASD/QE + Space to pilot.")

local function giveRadioTool()
    if player.Backpack:FindFirstChild("Airship Radio") then return end
    local tool = buildRadioTool()
    tool.Parent = player.Backpack
end
getgenv().__GIVE_RADIO = giveRadioTool
if player.Character then task.delay(0.6, giveRadioTool) end
player.CharacterAdded:Connect(function()
    task.wait(0.8)
    for _, t in ipairs(player.Backpack:GetChildren()) do
        if t.Name == "Airship Radio" then t:Destroy() end
    end
    giveRadioTool()
end)
