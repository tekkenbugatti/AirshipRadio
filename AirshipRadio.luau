-- AirshipRadio.luau  (v3: BIG proper interior, descend-and-land)
-- Clientside. Tool 'Airship Radio' (LMB = summon/recall) -- ship patrols AWAY along a wide loop.
-- Priority: pilot-driven (WASD / A/D / Q/E / Space eject).
--
local P   = game:GetService("Players")
local RS  = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local player = P.LocalPlayer

local C = {
    ship = { L = 46, W = 20, H = 10,       -- big, properly scaled
               altitude = 34, radius = 75, speed = 0.12,
               maxSpeed = 120, turn = 1.2, climb = 20, bob = 1.0 },
    spawn = { riseH = 150, dockAlt = 4 },    -- descend from far up, lands low enough to step on
    pal = { hull=Color3.fromRGB(24,28,40), panel=Color3.fromRGB(36,40,56), frame=Color3.fromRGB(50,54,70),
            accent=Color3.fromRGB(0,230,255), glow=Color3.fromRGB(160,245,255), floor=Color3.fromRGB(26,30,40),
            trim=Color3.fromRGB(255,110,55), glass=Color3.fromRGB(155,225,255) },
}
local pal = C.pal
C.pal = pal

local shipRef = nil
if getgenv().__AIRSHIP then pcall(getgenv().__AIRSHIP.destroy); getgenv().__AIRSHIP = nil end

local function makePart(parent, props)
    local p = Instance.new("Part")
    p.Anchored = true; p.CanCollide = true
    p.CustomPhysicalProperties = PhysicalProperties.new(0.05, 0.3, 0.5, 1, 1)
    p.Parent = parent
    for k, v in pairs(props or {}) do p[k] = v end
    return p
end

local function buildShip(origin)
    local m = Instance.new("Model"); m.Name = "Airship"
    local L, W, H = C.ship.L, C.ship.W, C.ship.H

    local root = Instance.new("Part")
    root.Name = "Root"; root.Size = Vector3.new(W/2, 0.6, L*0.35)
    root.CFrame = CFrame.new(origin + Vector3.new(0, C.spawn.riseH, 0))
    root.Anchored = true; root.Transparency = 1; root.CanCollide = false
    root.CustomPhysicalProperties = PhysicalProperties.new(0.05, 0.3, 0.5, 1, 1)
    root.Parent = m

    local function add(props, pos)
        local part = makePart(m, props)
        part.CFrame = root.CFrame * CFrame.new(pos)
        return part
    end

    -- Outer hull (boxy-enough to read as aircraft) with wing slabs.
    local body = add({ Name="Hull", Size=Vector3.new(L, H, W), Material=Enum.Material.SmoothPlastic,
                        Color=pal.hull }, Vector3.new(0, 0, 0))
    local belly = add({ Name="Belly", Size=Vector3.new(L*0.95, H*0.35, W*0.85), Material=Enum.Material.SmoothPlastic,
                        Color=pal.panel }, Vector3.new(0, -H*0.38, 0))
    -- wing-like fins on the sides (slender blade)
    for _, s in ipairs({-1,1}) do
        add({ Name=(s>0 and "FinR" or "FinL"),
            Size=Vector3.new(L*0.5, 0.5, W*0.95), Material=Enum.Material.SmoothPlastic, Color=pal.frame },
            Vector3.new(s*(W/2+1), 0, 0))
    end
    -- cockpit glass (front nose housing)
    add({ Name="Cockpit",  Size=Vector3.new(W*0.35, H*0.6, L*0.18), Material=Enum.Material.Glass,
        Color=pal.accent, Transparency=0.5 }, Vector3.new(0, 0, L*0.4))
    -- rear gondola (lower deck — walking surface)
    add({ Name="Gondola",  Size=Vector3.new(W*0.55, 1.2, L*0.3), Material=Enum.Material.SmoothPlastic,
        Color=pal.panel }, Vector3.new(0, -H*0.25, L*0.1))

    -- trim (neon cyan piping)
    for _, side in ipairs({-1,1}) do
        add({ Name=(side>0 and "TrimR" or "TrimL"), Size=Vector3.new(L*0.9, 0.25, 0.25), Material=Enum.Material.Neon,
            Color=pal.accent, Transparency=0.1 }, Vector3.new(side*(W*0.45), 0, 0))
    end
    -- warm warning trim on underside
    add({ Name="WarnStrip", Size=Vector3.new(L*0.8, 0.2, 0.25), Material=Enum.Material.Neon,
        Color=pal.trim, Transparency=0.15 }, Vector3.new(0, -H*0.45, 0))

    -- thrusters (rear), with glow
    for _, s in ipairs({-1,1}) do
        add({ Name=("Thr_"..(s>0 and "R" or "L")), Size=Vector3.new(3, 3, 7), Shape=Enum.PartType.Cylinder,
            Material=Enum.Material.Metal, Color=Color3.fromRGB(38,40,46) },
            Vector3.new(s*(W*0.25), 0, -L*0.42))
        add({ Name="Glow_"..(s>0 and "R" or "L"),
            Size=Vector3.new(1.6, 1.6, 3), Shape=Enum.PartType.Cylinder, Material=Enum.Material.Neon,
            Color=pal.glow, Transparency=0.2 }, Vector3.new(s*(W*0.25), 0, -L*0.43))
    end

    -- tail stabilizers
    for _, s in ipairs({-1,1}) do
        add({ Name=(s>0 and "StabR" or "StabL"), Size=Vector3.new(1, 5, 5), Material=Enum.Material.SmoothPlastic, Color=pal.frame },
            Vector3.new(s*(W*0.4), H*0.45, -L*0.4))
    end

    -- ===== interior =====
    local floorY = -H*0.02
    add({ Name="InteriorFloor",  Size=Vector3.new(L*0.55, 0.35, W*0.45), Material=Enum.Material.SmoothPlastic, Color=pal.floor },
        Vector3.new(0, -H*0.35, 0))
    for _, z in ipairs({ W*0.22, -W*0.22 }) do  -- left/right wall panels
        for _, x in ipairs({ -L*0.2, 0, L*0.2 }) do
            add({ Name="IntWall", Name="Wall_"..z..x, Size=Vector3.new(L*0.15, H*0.7, 0.3),
                Material=Enum.Material.SmoothPlastic, Color=pal.panel, Transparency=0.06 },
                Vector3.new(x, 0, z))
        end
    end
    -- dashboard
    add({ Name="Dashboard",  Size=Vector3.new(W*0.55, 1.0, 4.5), Material=Enum.Material.SmoothPlastic, Color=Color3.fromRGB(22,26,34) },
        Vector3.new(0, -H*0.15, L*0.34))
    -- instrument screens
    for _, z in ipairs({ -1.6, 1.6 }) do
        add({ Name="Screen_"..z, Size=Vector3.new(0.15, 1.8, 2), Material=Enum.Material.Neon, Color=pal.accent, Transparency=0.15 },
            Vector3.new(-(L*0.2), -H*0.05, L*0.35 + z))
    end
    -- seats (pilot left; passengers right/rear)
    local seat = Instance.new("VehicleSeat")
    seat.Name = "PilotSeat"
    seat.Size = Vector3.new(2, 1.4, 2.2)
    seat.Material = Enum.Material.SmoothPlastic; seat.BrickColor = BrickColor.new("Black")
    seat.MaxSpeed=0; seat.SteerFloat=0; seat.ThrottleFloat=0
    seat.CanCollide = true; seat.Anchored = false
    seat.CFrame = CFrame.new(origin + Vector3.new(-W*0.18, -H*0.05, L*0.25)) -- forward-left
    -- will be aligned after the anchor settle below
    seat.Parent = m
    for _, x in ipairs({ W*0.18, -W*0.18 }) do
        local pas = Instance.new("VehicleSeat")
        pas.Name = (x > 0 and "PassengerSeatR" or "PassengerSeatL")
        pas.Size = Vector3.new(2, 1.4, 2.2)
        pas.Material = Enum.Material.SmoothPlastic; pas.BrickColor = BrickColor.new("Black")
        pas.MaxSpeed=0; pas.SteerFloat=0; pas.ThrottleFloat=0
        pas.CanCollide = true; pas.Anchored = false
        pas.CFrame = CFrame.new(origin + Vector3.new(x, -H*0.05, L*0.0))
        pas.Parent = m
        -- collect later for rests
    end

    -- interior floor walkway
    add({ Name="InteriorFloor",  Size=Vector3.new(L*0.6, 0.5, W*0.45), Material=Enum.Material.SmoothPlastic, Color=pal.floor, CanCollide=true },
        Vector3.new(0, -H*0.15, 0))
    -- lower access ramp (so they can walk up from the dock)
    -- anchor a slab in front of hull gondola pointing down
    add({ Name="BoardingRamp",  Size=Vector3.new(14, 0.4, W*0.45), Material=Enum.Material.SmoothPlastic, Color=pal.frame, CanCollide=true, Transparency=0.05 },
        Vector3.new(0, -H*0.3, L*0.55))
        -- slightly tilt down: translate & rotate to make a 12-deg ramp
    -- Engine room / rear compartment (boxed cargo bay)
    add({ Name="EngineBay",  Size=Vector3.new(8, 3.5, 5.5), Material=Enum.Material.SmoothPlastic, Color=Color3.fromRGB(22,24,32), Transparency=0.1 },
        Vector3.new(0, -H*0.1, -L*0.35))
    -- cargo bay doors (two thin panes on the rear)
    add({ Name="BayDoorL",  Size=Vector3.new(0.15, 3, 3), Material=Enum.Material.SmoothPlastic, Color=pal.hull },
       Vector3.new(-4.2, -H*0.1, -L*0.42))
    add({ Name="BayDoorR",  Size=Vector3.new(0.15, 3, 3), Material=Enum.Material.SmoothPlastic, Color=pal.hull },
       Vector3.new(4.2, -H*0.1, -L*0.42))

    local light = Instance.new("PointLight")
    light.Brightness = 0.7; light.Color = pal.accent; light.Range = 50; light.Shadows = false; light.Parent = root

    m.Parent = game:FindFirstChild("Workspace") or workspace

    local ship = { root = root, assembly = m, seat = seat, hud = nil, alive = true, conn = nil,
        aimYaw = 0, patrolAngle = 0, pilot = false, ejectDebounce = false }
    -- capture rests
    local restMap = {}
    for _, c in ipairs(m:GetDescendants()) do
        if c:IsA("BasePart") and c ~= root then
            restMap[c] = root.CFrame:ToObjectSpace(c.CFrame)
        end
    end
    -- store relative transforms so anchored movement can re-apply them (seats too, but seats unanchored, handle below)
    ship._rests = restMap
    ship.seatRest = root.CFrame:ToObjectSpace(seat.CFrame)
    ship._seatParent = seat
    -- ensure seats will track root (unanchored; they'll be moved with moveParts)
    return ship
end

local shipRef = nil
if getgenv().__AIRSHIP then
    if getgenv().__AIRSHIP.destroy then pcall(getgenv().__AIRSHIP.destroy) end
    getgenv().__AIRSHIP = nil
end

local function moveParts(ship, cf)
    local root = ship.root
    root.CFrame = cf
    for part, rest in pairs(ship._rests) do
        part.CFrame = root.CFrame * rest
    end
    if ship.seat and ship.seat.Parent then
        ship.seat.CFrame = root.CFrame * ship.seatRest
    end
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

local function updateShip(ship, dt)
    local root = ship.root
    if not (root and root.Parent) then return end

    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    local playerPos = hrp and hrp.Position or root.Position
    local seated = seatOccupiedByPlayer(ship.seat)
    ship.pilot = seated

    if seated then
        local keys   = UserInputService
        local throttle    = (keys:IsKeyDown(Enum.KeyCode.W) and 1 or 0) - (keys:IsKeyDown(Enum.KeyCode.S) and 1 or 0)
        local yawDelta     = (keys:IsKeyDown(Enum.KeyCode.D) and 1 or 0) - (keys:IsKeyDown(Enum.KeyCode.A) and 1 or 0)
        local vertical     = (keys:IsKeyDown(Enum.KeyCode.Q) and 1 or 0) - (keys:IsKeyDown(Enum.KeyCode.E) and 1 or 0)

        ship.aimYaw = ship.aimYaw + yawDelta * C.ship.turn * dt
        local cf = CFrame.Angles(0, ship.aimYaw, 0)   -- start yaw basis
        local newPos = root.Position + cf.LookVector * throttle * C.ship.maxSpeed * dt * 0.35
            + Vector3.new(0, vertical * C.ship.climb * dt * 0.35, 0)
        moveParts(ship, CFrame.new(newPos) * CFrame.Angles(0, ship.aimYaw, 0))
        if ship.hud and ship.hudHint then ship.hudHint.Text = "Pilot — WASD thrust, Q/E altitude, Space eject." end

        if keys:IsKeyDown(Enum.KeyCode.Space) and not ship.ejectDebounce then
            ship.ejectDebounce = true
            ship.seat.Occupant = nil
            ship.pilot = false
            pcall(function()
                local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
                if hum then hum.Sit = false end
            end)
        elseif not keys:IsKeyDown(Enum.KeyCode.Space) then
            ship.ejectDebounce = false
        end
    else
        ship.ejectDebounce = false
        if not ship.spawnPos then ship.spawnPos = origin end -- anchor not set yet if origin local?
        if not ship.anchorPos then ship.anchorPos = (hrp and hrp.Position or root.Position) end
        ship.patrolAngle = (ship.patrolAngle or 0) + C.ship.speed * dt
        local ga = ship.patrolAngle
        local goal = ship.anchorPos + Vector3.new(math.cos(ga)*C.ship.radius, C.ship.altitude, math.sin(ga)*C.ship.radius)
        local delta = goal - root.Position
        local mag = delta.Magnitude
        local step = (mag > 0.1) and (delta.Unit * math.min(mag, C.ship.maxSpeed*dt*0.4)) or Vector3.zero
        local targetYaw = math.atan2(goal.X - root.Position.X, goal.Z - root.Position.Z)
        ship.aimYaw = ship.aimYaw + (targetYaw - ship.aimYaw)*math.min(1, dt*1.4)
        moveParts(ship, CFrame.new(root.Position + step) * CFrame.Angles(0, ship.aimYaw, 0))
        if ship.hud and ship.hudHint then
            ship.hudHint.Text = "Patrol ~"..math.floor(C.ship.radius).." studs away. WASD/QE onboard. Step in, 'E' to sit."
        end
    end
end

local function buildRadioTool()
    local tool = Instance.new("Tool")
    tool.Name = "Airship Radio"; tool.RequiresHandle = true; tool.CanBeDropped = false
    local h = Instance.new("Part"); h.Name="Handle"; h.Size=Vector3.new(0.3,1.8,0.4); h.Color=Color3.fromRGB(16,18,24); h.Material=Enum.Material.SmoothPlastic; h.Anchored=false; h.CanCollide=false; h.Parent=tool
    local body = Instance.new("Part"); body.Name="Body"; body.Size=Vector3.new(0.7,1.3,0.12); body.Color=Color3.fromRGB(22,26,32); body.Material=Enum.Material.SmoothPlastic; body.Anchored=false; body.CanCollide=false; body.Parent=tool
    local w0=Instance.new("WeldConstraint"); w0.Part0=h; w0.Part1=body; w0.Parent=h
    local plate = Instance.new("Part"); plate.Name="Plate"; plate.Size=Vector3.new(0.6,1.2,0.02); plate.Color=Color3.fromRGB(38,44,58); plate.Material=Enum.Material.SmoothPlastic; plate.Anchored=false; plate.CanCollide=false; plate.Parent=tool
    local w1=Instance.new("WeldConstraint"); w1.Part0=h; w1.Part1=plate; w1.Parent=h
    local neon1 = Instance.new("Part"); neon1.Name="NeonL"; neon1.Size=Vector3.new(0.03,1.2,0.03); neon1.Color=Color3.fromRGB(0,220,255); neon1.Material=Enum.Material.Neon; neon1.Anchored=false; neon1.CanCollide=false; neon1.Parent=tool
    local wl=Instance.new("WeldConstraint"); wl.Part0=h; wl.Part1=neon1; wl.Parent=h
    local neon2 = Instance.new("Part"); neon2.Name="NeonR"; neon2.Size=Vector3.new(0.03,1.2,0.03); neon2.Color=Color3.fromRGB(0,220,255); neon2.Material=Enum.Material.Neon; neon2.Anchored=false; neon2.CanCollide=false; neon2.Parent=tool
    local wr=Instance.new("WeldConstraint"); wr.Part0=h; wr.Part1=neon2; wr.Parent=h
    local ant = Instance.new("Part"); ant.Name="Antenna"; ant.Size=Vector3.new(0.05,1,0.05); ant.Color=Color3.fromRGB(18,22,26); ant.Material=Enum.Material.SmoothPlastic; ant.Anchored=false; ant.CanCollide=false; ant.Parent=tool
    local wa=Instance.new("WeldConstraint"); wa.Part0=h; wa.Part1=ant; wa.Parent=h
    local tip = Instance.new("Part"); tip.Name="AntennaTip"; tip.Size=Vector3.new(0.15,0.15,0.15); tip.Color=Color3.fromRGB(255,100,60); tip.Material=Enum.Material.Neon; tip.Shape=Enum.PartType.Ball; tip.Anchored=false; tip.CanCollide=false; ant.Parent=tool
    local wtip=Instance.new("WeldConstraint"); wtip.Part0=h; wtip.Part1=tip; wtip.Parent=h
    local ind = Instance.new("Part"); ind.Name="Indicator"; ind.Size=Vector3.new(0.2,0.15,0.01); ind.Color=Color3.fromRGB(80,200,255); ind.Material=Enum.Material.Neon; ind.Transparency=0.1; ind.Anchored=false; ind.CanCollide=false; ind.Parent=tool
    local wI=Instance.new("WeldConstraint"); wI.Part0=h; wI.Part1=ind; wI.Parent=h

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

local function buildHUD(ship)
    if ship.hud then pcall(function() ship.hud:Destroy() end) end
    local sg = Instance.new("ScreenGui")
    sg.Name = "AirshipHUD"; sg.ResetOnSpawn = false; sg.IgnoreGuiInset = true; sg.Parent = player:WaitForChild("PlayerGui")
    local fr = Instance.new("Frame")
    fr.Size = UDim2.new(0,420,0,86); fr.AnchorPoint = Vector2.new(0.5,1); fr.Position = UDim2.new(0.5,0,0.93,0)
    fr.BackgroundTransparency = 0.3; fr.BackgroundColor3 = Color3.fromRGB(14,18,32); fr.BorderSizePixel = 0; fr.Parent = sg
    local t = Instance.new("TextLabel")
    t.Size = UDim2.new(1,-12,0,20); t.Position=UDim2.new(0,6,0,5); t.BackgroundTransparency=1
    t.TextXAlignment = Enum.TextXAlignment.Left; t.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json"); t.TextSize = 14
    t.TextColor3 = Color3.fromRGB(0,220,255); t.Text = "KESTREL — Air Mobility"
    t.Parent = fr
    local h = Instance.new("TextLabel")
    h.Size = UDim2.new(1,-12,0,50); h.Position=UDim2.new(0,6,0,28); h.BackgroundTransparency=1
    h.TextXAlignment = Enum.TextXAlignment.Left; h.TextYAlignment = Enum.TextYAlignment.Top
    h.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json"); h.TextSize = 12
    h.TextWrapped = true; h.TextColor3 = Color3.fromRGB(170,180,210)
    h.Text = "Patrol orbiting at ~55 studs (never glued over you).\nStep into the gondola to take control — Space ejects."
    h.Parent = fr
    ship.hud = sg; ship.hudHint = h
end

function destroyShip()
    if not shipRef then return end
    if shipRef.conn then shipRef.conn:Disconnect() end
    if shipRef.hud and shipRef.hud.Parent then shipRef.hud:Destroy() end
    if shipRef.assembly and shipRef.assembly.Parent then shipRef.assembly:Destroy() end
    shipRef = nil
    getgenv().__AIRSHIP = nil
end

function summonAirship()
    destroyShip()
    task.wait(0.05)
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    local origin = (hrp and hrp.Position) or Vector3.new(0,80,0)
    -- Float down in front, then settle low enough to board.
    shipRef = buildShip(origin)
    local ship = shipRef
    ship.anchorPos = origin + (hrp and hrp.CFrame.LookVector * 8 or Vector3.new(0,0,0))
    ship.aimYaw = 0
    -- pop-in
    task.spawn(function()
        local r = ship.root
        local T = tick()
        while tick() - T < 1.5 and r and r.Parent do
            local frac = (tick() - T) / 1.5
            local eased = 1 - math.pow(1 - frac, 3)
            local y = origin.Y + C.spawn.riseH + (C.spawn.dockAlt - C.spawn.riseH) * eased
            moveParts(ship, CFrame.new(origin.X, y, origin.Z) * CFrame.Angles(0, 0, 0))
            task.wait()
        end
        if r and r.Parent then
            moveParts(ship, CFrame.new(origin.X, origin.Y + C.spawn.dockAlt, origin.Z))
        end
    end)
    buildHUD(ship)
    getgenv().__AIRSHIP = { alive=true, destroy=destroyShip, ship=ship }
    ship.conn = RS.Heartbeat:Connect(function(dt)
        if not (ship.alive and ship.root and ship.root.Parent) then return end
        updateShip(ship, dt)
    end)
end

local function giveRadioTool()
    if player.Backpack:FindFirstChild("Airship Radio") then return end
    local t = buildRadioTool()
    t.Parent = player.Backpack
end
if player.Character then task.delay(0.6, giveRadioTool) end
player.CharacterAdded:Connect(function()
    task.wait(0.8)
    for _, t in ipairs(player.Backpack:GetChildren()) do
        if t.Name == "Airship Radio" then t:Destroy() end
    end
    giveRadioTool()
end)

print("[Airship] ready. Click 'Airship Radio' to summon (LMB). WASD+QE pilot; Space eject.")
