-- AirshipRadio.luau  (v3: BIG proper interior, descend-and-land)
-- Clientside. Tool 'Airship Radio' (LMB = summon/recall) -- ship patrols AWAY along a wide loop.
-- Priority: pilot-driven (WASD / A/D / Q/E / Space eject).
--
local P   = game:GetService("Players")
local RS  = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local player = P.LocalPlayer
local MODEL_PARTS = {
  { N='Keel_Core', S=Vector3.new(24,5,62), C=CFrame.new(0,0,0, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(24,31,43), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Upper_Armor', S=Vector3.new(20,2,54), C=CFrame.new(0,3,0, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(66,78,91), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Lower_Keel', S=Vector3.new(15,2,49), C=CFrame.new(0,-3,1, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(12,17,24), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Armored_Nose_00', S=Vector3.new(16,4,5), C=CFrame.new(0,1,34, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(66,78,91), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Armored_Nose_01', S=Vector3.new(12,3,5), C=CFrame.new(0,1,39, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(24,31,43), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Armored_Nose_02', S=Vector3.new(8,2,5), C=CFrame.new(0,1,43, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(66,78,91), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Armored_Nose_03', S=Vector3.new(4,1.5,5), C=CFrame.new(0,1,46, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(24,31,43), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Tail_Taper_00', S=Vector3.new(16,4,5), C=CFrame.new(0,1,-32, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(24,31,43), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Tail_Taper_01', S=Vector3.new(12,3,5), C=CFrame.new(0,1,-37, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(24,31,43), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Tail_Taper_02', S=Vector3.new(8,2,5), C=CFrame.new(0,1,-41, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(24,31,43), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Tail_Taper_03', S=Vector3.new(4,1.5,5), C=CFrame.new(0,1,-44, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(24,31,43), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Side_Armor_-1_0', S=Vector3.new(1.3,4.2,7), C=CFrame.new(-11.4,0,-27, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(66,78,91), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Yellow_Identification_-1_0', S=Vector3.new(0.12,1.4,3.4), C=CFrame.new(-12.12,0.2,-27, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(255,185,35), Mat=Enum.Material.Neon, Sh=Enum.PartType.Block, T=0.05, CC=false, A=true },
  { N='Side_Armor_-1_1', S=Vector3.new(1.3,4.2,7), C=CFrame.new(-11.4,0,-18, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(24,31,43), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Yellow_Identification_-1_1', S=Vector3.new(0.12,1.4,3.4), C=CFrame.new(-12.12,0.2,-18, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(255,185,35), Mat=Enum.Material.Neon, Sh=Enum.PartType.Block, T=0.05, CC=false, A=true },
  { N='Side_Armor_-1_2', S=Vector3.new(1.3,4.2,7), C=CFrame.new(-11.4,0,-9, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(66,78,91), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Yellow_Identification_-1_2', S=Vector3.new(0.12,1.4,3.4), C=CFrame.new(-12.12,0.2,-9, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(255,185,35), Mat=Enum.Material.Neon, Sh=Enum.PartType.Block, T=0.05, CC=false, A=true },
  { N='Side_Armor_-1_3', S=Vector3.new(1.3,4.2,7), C=CFrame.new(-11.4,0,0, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(24,31,43), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Yellow_Identification_-1_3', S=Vector3.new(0.12,1.4,3.4), C=CFrame.new(-12.12,0.2,0, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(255,185,35), Mat=Enum.Material.Neon, Sh=Enum.PartType.Block, T=0.05, CC=false, A=true },
  { N='Side_Armor_-1_4', S=Vector3.new(1.3,4.2,7), C=CFrame.new(-11.4,0,9, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(66,78,91), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Yellow_Identification_-1_4', S=Vector3.new(0.12,1.4,3.4), C=CFrame.new(-12.12,0.2,9, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(255,185,35), Mat=Enum.Material.Neon, Sh=Enum.PartType.Block, T=0.05, CC=false, A=true },
  { N='Side_Armor_-1_5', S=Vector3.new(1.3,4.2,7), C=CFrame.new(-11.4,0,18, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(24,31,43), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Yellow_Identification_-1_5', S=Vector3.new(0.12,1.4,3.4), C=CFrame.new(-12.12,0.2,18, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(255,185,35), Mat=Enum.Material.Neon, Sh=Enum.PartType.Block, T=0.05, CC=false, A=true },
  { N='Side_Armor_-1_6', S=Vector3.new(1.3,4.2,7), C=CFrame.new(-11.4,0,27, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(66,78,91), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Yellow_Identification_-1_6', S=Vector3.new(0.12,1.4,3.4), C=CFrame.new(-12.12,0.2,27, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(255,185,35), Mat=Enum.Material.Neon, Sh=Enum.PartType.Block, T=0.05, CC=false, A=true },
  { N='Side_Light_-1', S=Vector3.new(0.25,0.25,34), C=CFrame.new(-10.7,2.15,0, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(0,255,231), Mat=Enum.Material.Neon, Sh=Enum.PartType.Block, T=0, CC=false, A=true },
  { N='Engine_Pod_-1_0', S=Vector3.new(5.4,4.2,4.2), C=CFrame.new(-14.5,-1,-25, -0.4480736161291701,-0.8939966636005579,0.0, 0.8939966636005579,-0.4480736161291701,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(12,17,24), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Cylinder, T=0, CC=true, A=true },
  { N='Engine_Rim_-1_0', S=Vector3.new(0.6,4.3,4.3), C=CFrame.new(-14.5,-1,-27.15, -0.4480736161291701,-0.8939966636005579,0.0, 0.8939966636005579,-0.4480736161291701,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(66,78,91), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Cylinder, T=0, CC=true, A=true },
  { N='Engine_Core_-1_0', S=Vector3.new(0.35,2.8,2.8), C=CFrame.new(-14.5,-1,-27.5, -0.4480736161291701,-0.8939966636005579,0.0, 0.8939966636005579,-0.4480736161291701,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(0,174,255), Mat=Enum.Material.Neon, Sh=Enum.PartType.Cylinder, T=0, CC=true, A=true },
  { N='Engine_Pod_-1_1', S=Vector3.new(5.4,4.2,4.2), C=CFrame.new(-14.5,-1,-12, -0.4480736161291701,-0.8939966636005579,0.0, 0.8939966636005579,-0.4480736161291701,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(12,17,24), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Cylinder, T=0, CC=true, A=true },
  { N='Engine_Rim_-1_1', S=Vector3.new(0.6,4.3,4.3), C=CFrame.new(-14.5,-1,-14.15, -0.4480736161291701,-0.8939966636005579,0.0, 0.8939966636005579,-0.4480736161291701,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(66,78,91), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Cylinder, T=0, CC=true, A=true },
  { N='Engine_Core_-1_1', S=Vector3.new(0.35,2.8,2.8), C=CFrame.new(-14.5,-1,-14.5, -0.4480736161291701,-0.8939966636005579,0.0, 0.8939966636005579,-0.4480736161291701,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(0,174,255), Mat=Enum.Material.Neon, Sh=Enum.PartType.Cylinder, T=0, CC=true, A=true },
  { N='Engine_Pod_-1_2', S=Vector3.new(5.4,4.2,4.2), C=CFrame.new(-14.5,-1,12, -0.4480736161291701,-0.8939966636005579,0.0, 0.8939966636005579,-0.4480736161291701,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(12,17,24), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Cylinder, T=0, CC=true, A=true },
  { N='Engine_Rim_-1_2', S=Vector3.new(0.6,4.3,4.3), C=CFrame.new(-14.5,-1,14.15, -0.4480736161291701,-0.8939966636005579,0.0, 0.8939966636005579,-0.4480736161291701,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(66,78,91), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Cylinder, T=0, CC=true, A=true },
  { N='Engine_Core_-1_2', S=Vector3.new(0.35,2.8,2.8), C=CFrame.new(-14.5,-1,14.5, -0.4480736161291701,-0.8939966636005579,0.0, 0.8939966636005579,-0.4480736161291701,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(0,174,255), Mat=Enum.Material.Neon, Sh=Enum.PartType.Cylinder, T=0, CC=true, A=true },
  { N='Engine_Pod_-1_3', S=Vector3.new(5.4,4.2,4.2), C=CFrame.new(-14.5,-1,25, -0.4480736161291701,-0.8939966636005579,0.0, 0.8939966636005579,-0.4480736161291701,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(12,17,24), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Cylinder, T=0, CC=true, A=true },
  { N='Engine_Rim_-1_3', S=Vector3.new(0.6,4.3,4.3), C=CFrame.new(-14.5,-1,27.15, -0.4480736161291701,-0.8939966636005579,0.0, 0.8939966636005579,-0.4480736161291701,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(66,78,91), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Cylinder, T=0, CC=true, A=true },
  { N='Engine_Core_-1_3', S=Vector3.new(0.35,2.8,2.8), C=CFrame.new(-14.5,-1,27.5, -0.4480736161291701,-0.8939966636005579,0.0, 0.8939966636005579,-0.4480736161291701,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(0,174,255), Mat=Enum.Material.Neon, Sh=Enum.PartType.Cylinder, T=0, CC=true, A=true },
  { N='Side_Armor_1_0', S=Vector3.new(1.3,4.2,7), C=CFrame.new(11.4,0,-27, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(66,78,91), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Yellow_Identification_1_0', S=Vector3.new(0.12,1.4,3.4), C=CFrame.new(12.12,0.2,-27, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(255,185,35), Mat=Enum.Material.Neon, Sh=Enum.PartType.Block, T=0.05, CC=false, A=true },
  { N='Side_Armor_1_1', S=Vector3.new(1.3,4.2,7), C=CFrame.new(11.4,0,-18, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(24,31,43), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Yellow_Identification_1_1', S=Vector3.new(0.12,1.4,3.4), C=CFrame.new(12.12,0.2,-18, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(255,185,35), Mat=Enum.Material.Neon, Sh=Enum.PartType.Block, T=0.05, CC=false, A=true },
  { N='Side_Armor_1_2', S=Vector3.new(1.3,4.2,7), C=CFrame.new(11.4,0,-9, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(66,78,91), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Yellow_Identification_1_2', S=Vector3.new(0.12,1.4,3.4), C=CFrame.new(12.12,0.2,-9, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(255,185,35), Mat=Enum.Material.Neon, Sh=Enum.PartType.Block, T=0.05, CC=false, A=true },
  { N='Side_Armor_1_3', S=Vector3.new(1.3,4.2,7), C=CFrame.new(11.4,0,0, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(24,31,43), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Yellow_Identification_1_3', S=Vector3.new(0.12,1.4,3.4), C=CFrame.new(12.12,0.2,0, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(255,185,35), Mat=Enum.Material.Neon, Sh=Enum.PartType.Block, T=0.05, CC=false, A=true },
  { N='Side_Armor_1_4', S=Vector3.new(1.3,4.2,7), C=CFrame.new(11.4,0,9, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(66,78,91), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Yellow_Identification_1_4', S=Vector3.new(0.12,1.4,3.4), C=CFrame.new(12.12,0.2,9, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(255,185,35), Mat=Enum.Material.Neon, Sh=Enum.PartType.Block, T=0.05, CC=false, A=true },
  { N='Side_Armor_1_5', S=Vector3.new(1.3,4.2,7), C=CFrame.new(11.4,0,18, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(24,31,43), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Yellow_Identification_1_5', S=Vector3.new(0.12,1.4,3.4), C=CFrame.new(12.12,0.2,18, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(255,185,35), Mat=Enum.Material.Neon, Sh=Enum.PartType.Block, T=0.05, CC=false, A=true },
  { N='Side_Armor_1_6', S=Vector3.new(1.3,4.2,7), C=CFrame.new(11.4,0,27, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(66,78,91), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Yellow_Identification_1_6', S=Vector3.new(0.12,1.4,3.4), C=CFrame.new(12.12,0.2,27, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(255,185,35), Mat=Enum.Material.Neon, Sh=Enum.PartType.Block, T=0.05, CC=false, A=true },
  { N='Side_Light_1', S=Vector3.new(0.25,0.25,34), C=CFrame.new(10.7,2.15,0, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(0,255,231), Mat=Enum.Material.Neon, Sh=Enum.PartType.Block, T=0, CC=false, A=true },
  { N='Engine_Pod_1_0', S=Vector3.new(5.4,4.2,4.2), C=CFrame.new(14.5,-1,-25, -0.4480736161291701,-0.8939966636005579,0.0, 0.8939966636005579,-0.4480736161291701,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(12,17,24), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Cylinder, T=0, CC=true, A=true },
  { N='Engine_Rim_1_0', S=Vector3.new(0.6,4.3,4.3), C=CFrame.new(14.5,-1,-27.15, -0.4480736161291701,-0.8939966636005579,0.0, 0.8939966636005579,-0.4480736161291701,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(66,78,91), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Cylinder, T=0, CC=true, A=true },
  { N='Engine_Core_1_0', S=Vector3.new(0.35,2.8,2.8), C=CFrame.new(14.5,-1,-27.5, -0.4480736161291701,-0.8939966636005579,0.0, 0.8939966636005579,-0.4480736161291701,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(0,174,255), Mat=Enum.Material.Neon, Sh=Enum.PartType.Cylinder, T=0, CC=true, A=true },
  { N='Engine_Pod_1_1', S=Vector3.new(5.4,4.2,4.2), C=CFrame.new(14.5,-1,-12, -0.4480736161291701,-0.8939966636005579,0.0, 0.8939966636005579,-0.4480736161291701,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(12,17,24), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Cylinder, T=0, CC=true, A=true },
  { N='Engine_Rim_1_1', S=Vector3.new(0.6,4.3,4.3), C=CFrame.new(14.5,-1,-14.15, -0.4480736161291701,-0.8939966636005579,0.0, 0.8939966636005579,-0.4480736161291701,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(66,78,91), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Cylinder, T=0, CC=true, A=true },
  { N='Engine_Core_1_1', S=Vector3.new(0.35,2.8,2.8), C=CFrame.new(14.5,-1,-14.5, -0.4480736161291701,-0.8939966636005579,0.0, 0.8939966636005579,-0.4480736161291701,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(0,174,255), Mat=Enum.Material.Neon, Sh=Enum.PartType.Cylinder, T=0, CC=true, A=true },
  { N='Engine_Pod_1_2', S=Vector3.new(5.4,4.2,4.2), C=CFrame.new(14.5,-1,12, -0.4480736161291701,-0.8939966636005579,0.0, 0.8939966636005579,-0.4480736161291701,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(12,17,24), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Cylinder, T=0, CC=true, A=true },
  { N='Engine_Rim_1_2', S=Vector3.new(0.6,4.3,4.3), C=CFrame.new(14.5,-1,14.15, -0.4480736161291701,-0.8939966636005579,0.0, 0.8939966636005579,-0.4480736161291701,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(66,78,91), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Cylinder, T=0, CC=true, A=true },
  { N='Engine_Core_1_2', S=Vector3.new(0.35,2.8,2.8), C=CFrame.new(14.5,-1,14.5, -0.4480736161291701,-0.8939966636005579,0.0, 0.8939966636005579,-0.4480736161291701,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(0,174,255), Mat=Enum.Material.Neon, Sh=Enum.PartType.Cylinder, T=0, CC=true, A=true },
  { N='Engine_Pod_1_3', S=Vector3.new(5.4,4.2,4.2), C=CFrame.new(14.5,-1,25, -0.4480736161291701,-0.8939966636005579,0.0, 0.8939966636005579,-0.4480736161291701,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(12,17,24), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Cylinder, T=0, CC=true, A=true },
  { N='Engine_Rim_1_3', S=Vector3.new(0.6,4.3,4.3), C=CFrame.new(14.5,-1,27.15, -0.4480736161291701,-0.8939966636005579,0.0, 0.8939966636005579,-0.4480736161291701,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(66,78,91), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Cylinder, T=0, CC=true, A=true },
  { N='Engine_Core_1_3', S=Vector3.new(0.35,2.8,2.8), C=CFrame.new(14.5,-1,27.5, -0.4480736161291701,-0.8939966636005579,0.0, 0.8939966636005579,-0.4480736161291701,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(0,174,255), Mat=Enum.Material.Neon, Sh=Enum.PartType.Cylinder, T=0, CC=true, A=true },
  { N='Dorsal_Spine', S=Vector3.new(5,2,35), C=CFrame.new(0,5,0, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(12,17,24), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Dorsal_Light', S=Vector3.new(0.45,0.15,29), C=CFrame.new(0,6.1,0, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(0,174,255), Mat=Enum.Material.Neon, Sh=Enum.PartType.Block, T=0, CC=false, A=true },
  { N='Radar_Base_-15', S=Vector3.new(1.2,0.7,1.2), C=CFrame.new(0,6,-15, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(66,78,91), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Cylinder, T=0, CC=true, A=true },
  { N='Radar_Dish_-15', S=Vector3.new(0.2,3.2,3.2), C=CFrame.new(0,6.8,-15, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(132,151,164), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Cylinder, T=0, CC=true, A=true },
  { N='Radar_Base_15', S=Vector3.new(1.2,0.7,1.2), C=CFrame.new(0,6,15, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(66,78,91), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Cylinder, T=0, CC=true, A=true },
  { N='Radar_Dish_15', S=Vector3.new(0.2,3.2,3.2), C=CFrame.new(0,6.8,15, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(132,151,164), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Cylinder, T=0, CC=true, A=true },
  { N='Swept_Wing_-1', S=Vector3.new(17,1.4,12), C=CFrame.new(-12,1,-28, 0.9781476007338057,-0.0,-0.20791169081775934, 0.0,1.0,-0.0, 0.20791169081775934,0.0,0.9781476007338057), Col=Color3.fromRGB(24,31,43), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Wing_Stripe_-1', S=Vector3.new(12,0.12,0.55), C=CFrame.new(-13,1.78,-28, 0.9781476007338057,-0.0,-0.20791169081775934, 0.0,1.0,-0.0, 0.20791169081775934,0.0,0.9781476007338057), Col=Color3.fromRGB(255,185,35), Mat=Enum.Material.Neon, Sh=Enum.PartType.Block, T=0, CC=false, A=true },
  { N='Tail_Fin_-1', S=Vector3.new(1.2,7,10), C=CFrame.new(-5,4,-36, 0.984807753012208,-0.0,-0.17364817766693033, 0.0,1.0,-0.0, 0.17364817766693033,0.0,0.984807753012208), Col=Color3.fromRGB(66,78,91), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Swept_Wing_1', S=Vector3.new(17,1.4,12), C=CFrame.new(12,1,-28, 0.9781476007338057,0.0,0.20791169081775934, 0.0,1.0,0.0, -0.20791169081775934,0.0,0.9781476007338057), Col=Color3.fromRGB(24,31,43), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Wing_Stripe_1', S=Vector3.new(12,0.12,0.55), C=CFrame.new(13,1.78,-28, 0.9781476007338057,0.0,0.20791169081775934, 0.0,1.0,0.0, -0.20791169081775934,0.0,0.9781476007338057), Col=Color3.fromRGB(255,185,35), Mat=Enum.Material.Neon, Sh=Enum.PartType.Block, T=0, CC=false, A=true },
  { N='Tail_Fin_1', S=Vector3.new(1.2,7,10), C=CFrame.new(5,4,-36, 0.984807753012208,0.0,0.17364817766693033, 0.0,1.0,0.0, -0.17364817766693033,0.0,0.984807753012208), Col=Color3.fromRGB(66,78,91), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Bridge_Base', S=Vector3.new(13,3,10), C=CFrame.new(0,4,25, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(12,17,24), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Bridge_Front_Glass', S=Vector3.new(10,2.2,0.35), C=CFrame.new(0,5.5,29.8, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(27,68,84), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0.25, CC=false, A=true },
  { N='Bridge_Side_Glass_-1', S=Vector3.new(0.3,2,6), C=CFrame.new(-6.5,5.4,26, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(27,68,84), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0.25, CC=false, A=true },
  { N='Bridge_Frame_-1', S=Vector3.new(0.35,0.25,4), C=CFrame.new(-5.3,6.7,28, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(0,174,255), Mat=Enum.Material.Neon, Sh=Enum.PartType.Block, T=0, CC=false, A=true },
  { N='Bridge_Side_Glass_1', S=Vector3.new(0.3,2,6), C=CFrame.new(6.5,5.4,26, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(27,68,84), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0.25, CC=false, A=true },
  { N='Bridge_Frame_1', S=Vector3.new(0.35,0.25,4), C=CFrame.new(5.3,6.7,28, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(0,174,255), Mat=Enum.Material.Neon, Sh=Enum.PartType.Block, T=0, CC=false, A=true },
  { N='Cargo_Bay_Frame', S=Vector3.new(17,1.2,32), C=CFrame.new(0,-4,0, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(66,78,91), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Cargo_Bay_Door_Left', S=Vector3.new(7,0.35,29), C=CFrame.new(-4.1,-4.8,0, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(12,17,24), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Cargo_Bay_Door_Right', S=Vector3.new(7,0.35,29), C=CFrame.new(4.1,-4.8,0, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(12,17,24), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Landing_Gear_-1_-21', S=Vector3.new(1.4,5,1.4), C=CFrame.new(-7,-6,-21, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(66,78,91), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Cylinder, T=0, CC=true, A=true },
  { N='Landing_Foot_-1_-21', S=Vector3.new(3,1.1,2.5), C=CFrame.new(-7,-8.6,-21, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(12,17,24), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Ball, T=0, CC=true, A=true },
  { N='Landing_Gear_-1_21', S=Vector3.new(1.4,5,1.4), C=CFrame.new(-7,-6,21, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(66,78,91), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Cylinder, T=0, CC=true, A=true },
  { N='Landing_Foot_-1_21', S=Vector3.new(3,1.1,2.5), C=CFrame.new(-7,-8.6,21, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(12,17,24), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Ball, T=0, CC=true, A=true },
  { N='Landing_Gear_1_-21', S=Vector3.new(1.4,5,1.4), C=CFrame.new(7,-6,-21, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(66,78,91), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Cylinder, T=0, CC=true, A=true },
  { N='Landing_Foot_1_-21', S=Vector3.new(3,1.1,2.5), C=CFrame.new(7,-8.6,-21, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(12,17,24), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Ball, T=0, CC=true, A=true },
  { N='Landing_Gear_1_21', S=Vector3.new(1.4,5,1.4), C=CFrame.new(7,-6,21, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(66,78,91), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Cylinder, T=0, CC=true, A=true },
  { N='Landing_Foot_1_21', S=Vector3.new(3,1.1,2.5), C=CFrame.new(7,-8.6,21, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(12,17,24), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Ball, T=0, CC=true, A=true },
  { N='Interior_Main_Deck', S=Vector3.new(15.5,0.6,30), C=CFrame.new(0,-1.6,0, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(132,151,164), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Deck_Panel_-13', S=Vector3.new(14.5,0.08,3.5), C=CFrame.new(0,-1.22,-13, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(66,78,91), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Deck_Center_Light_-13', S=Vector3.new(0.16,0.06,2.6), C=CFrame.new(0,-1.14,-13, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(0,255,231), Mat=Enum.Material.Neon, Sh=Enum.PartType.Block, T=0, CC=false, A=true },
  { N='Deck_Panel_-9', S=Vector3.new(14.5,0.08,3.5), C=CFrame.new(0,-1.22,-9, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(66,78,91), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Deck_Center_Light_-9', S=Vector3.new(0.16,0.06,2.6), C=CFrame.new(0,-1.14,-9, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(0,255,231), Mat=Enum.Material.Neon, Sh=Enum.PartType.Block, T=0, CC=false, A=true },
  { N='Deck_Panel_-5', S=Vector3.new(14.5,0.08,3.5), C=CFrame.new(0,-1.22,-5, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(66,78,91), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Deck_Center_Light_-5', S=Vector3.new(0.16,0.06,2.6), C=CFrame.new(0,-1.14,-5, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(0,255,231), Mat=Enum.Material.Neon, Sh=Enum.PartType.Block, T=0, CC=false, A=true },
  { N='Deck_Panel_-1', S=Vector3.new(14.5,0.08,3.5), C=CFrame.new(0,-1.22,-1, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(66,78,91), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Deck_Center_Light_-1', S=Vector3.new(0.16,0.06,2.6), C=CFrame.new(0,-1.14,-1, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(0,255,231), Mat=Enum.Material.Neon, Sh=Enum.PartType.Block, T=0, CC=false, A=true },
  { N='Deck_Panel_3', S=Vector3.new(14.5,0.08,3.5), C=CFrame.new(0,-1.22,3, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(66,78,91), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Deck_Center_Light_3', S=Vector3.new(0.16,0.06,2.6), C=CFrame.new(0,-1.14,3, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(0,255,231), Mat=Enum.Material.Neon, Sh=Enum.PartType.Block, T=0, CC=false, A=true },
  { N='Deck_Panel_7', S=Vector3.new(14.5,0.08,3.5), C=CFrame.new(0,-1.22,7, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(66,78,91), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Deck_Center_Light_7', S=Vector3.new(0.16,0.06,2.6), C=CFrame.new(0,-1.14,7, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(0,255,231), Mat=Enum.Material.Neon, Sh=Enum.PartType.Block, T=0, CC=false, A=true },
  { N='Deck_Panel_11', S=Vector3.new(14.5,0.08,3.5), C=CFrame.new(0,-1.22,11, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(66,78,91), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Deck_Center_Light_11', S=Vector3.new(0.16,0.06,2.6), C=CFrame.new(0,-1.14,11, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(0,255,231), Mat=Enum.Material.Neon, Sh=Enum.PartType.Block, T=0, CC=false, A=true },
  { N='Interior_Bulkhead_-15', S=Vector3.new(15,5,0.6), C=CFrame.new(0,1,-15, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(24,31,43), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Bulkhead_Sign_Light_-15', S=Vector3.new(7,0.18,0.15), C=CFrame.new(0,3.4,-15, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(255,185,35), Mat=Enum.Material.Neon, Sh=Enum.PartType.Block, T=0, CC=false, A=true },
  { N='Interior_Bulkhead_15', S=Vector3.new(15,5,0.6), C=CFrame.new(0,1,15, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(24,31,43), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Bulkhead_Sign_Light_15', S=Vector3.new(7,0.18,0.15), C=CFrame.new(0,3.4,15, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(255,185,35), Mat=Enum.Material.Neon, Sh=Enum.PartType.Block, T=0, CC=false, A=true },
  { N='Cargo_Crate_-5_-10', S=Vector3.new(3.4,3.2,3.2), C=CFrame.new(-5,0.4,-10, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(12,17,24), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Crate_Label_-5_-10', S=Vector3.new(1.6,0.08,0.9), C=CFrame.new(-5,2.05,-10, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(255,185,35), Mat=Enum.Material.Neon, Sh=Enum.PartType.Block, T=0, CC=false, A=true },
  { N='Crate_Rib_-5_-10_-1.2', S=Vector3.new(0.12,3.25,3.25), C=CFrame.new(-6.2,0.4,-10, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(66,78,91), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Crate_Rib_-5_-10_1.2', S=Vector3.new(0.12,3.25,3.25), C=CFrame.new(-3.8,0.4,-10, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(66,78,91), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Cargo_Crate_-5_-4', S=Vector3.new(3.4,3.2,3.2), C=CFrame.new(-5,0.4,-4, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(12,17,24), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Crate_Label_-5_-4', S=Vector3.new(1.6,0.08,0.9), C=CFrame.new(-5,2.05,-4, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(255,185,35), Mat=Enum.Material.Neon, Sh=Enum.PartType.Block, T=0, CC=false, A=true },
  { N='Crate_Rib_-5_-4_-1.2', S=Vector3.new(0.12,3.25,3.25), C=CFrame.new(-6.2,0.4,-4, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(66,78,91), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Crate_Rib_-5_-4_1.2', S=Vector3.new(0.12,3.25,3.25), C=CFrame.new(-3.8,0.4,-4, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(66,78,91), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Cargo_Crate_-5_4', S=Vector3.new(3.4,3.2,3.2), C=CFrame.new(-5,0.4,4, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(12,17,24), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Crate_Label_-5_4', S=Vector3.new(1.6,0.08,0.9), C=CFrame.new(-5,2.05,4, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(255,185,35), Mat=Enum.Material.Neon, Sh=Enum.PartType.Block, T=0, CC=false, A=true },
  { N='Crate_Rib_-5_4_-1.2', S=Vector3.new(0.12,3.25,3.25), C=CFrame.new(-6.2,0.4,4, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(66,78,91), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Crate_Rib_-5_4_1.2', S=Vector3.new(0.12,3.25,3.25), C=CFrame.new(-3.8,0.4,4, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(66,78,91), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Cargo_Crate_-5_10', S=Vector3.new(3.4,3.2,3.2), C=CFrame.new(-5,0.4,10, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(12,17,24), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Crate_Label_-5_10', S=Vector3.new(1.6,0.08,0.9), C=CFrame.new(-5,2.05,10, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(255,185,35), Mat=Enum.Material.Neon, Sh=Enum.PartType.Block, T=0, CC=false, A=true },
  { N='Crate_Rib_-5_10_-1.2', S=Vector3.new(0.12,3.25,3.25), C=CFrame.new(-6.2,0.4,10, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(66,78,91), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Crate_Rib_-5_10_1.2', S=Vector3.new(0.12,3.25,3.25), C=CFrame.new(-3.8,0.4,10, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(66,78,91), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Cargo_Crate_5_-10', S=Vector3.new(3.4,3.2,3.2), C=CFrame.new(5,0.4,-10, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(12,17,24), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Crate_Label_5_-10', S=Vector3.new(1.6,0.08,0.9), C=CFrame.new(5,2.05,-10, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(255,185,35), Mat=Enum.Material.Neon, Sh=Enum.PartType.Block, T=0, CC=false, A=true },
  { N='Crate_Rib_5_-10_-1.2', S=Vector3.new(0.12,3.25,3.25), C=CFrame.new(3.8,0.4,-10, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(66,78,91), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Crate_Rib_5_-10_1.2', S=Vector3.new(0.12,3.25,3.25), C=CFrame.new(6.2,0.4,-10, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(66,78,91), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Cargo_Crate_5_-4', S=Vector3.new(3.4,3.2,3.2), C=CFrame.new(5,0.4,-4, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(12,17,24), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Crate_Label_5_-4', S=Vector3.new(1.6,0.08,0.9), C=CFrame.new(5,2.05,-4, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(255,185,35), Mat=Enum.Material.Neon, Sh=Enum.PartType.Block, T=0, CC=false, A=true },
  { N='Crate_Rib_5_-4_-1.2', S=Vector3.new(0.12,3.25,3.25), C=CFrame.new(3.8,0.4,-4, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(66,78,91), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Crate_Rib_5_-4_1.2', S=Vector3.new(0.12,3.25,3.25), C=CFrame.new(6.2,0.4,-4, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(66,78,91), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Cargo_Crate_5_4', S=Vector3.new(3.4,3.2,3.2), C=CFrame.new(5,0.4,4, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(12,17,24), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Crate_Label_5_4', S=Vector3.new(1.6,0.08,0.9), C=CFrame.new(5,2.05,4, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(255,185,35), Mat=Enum.Material.Neon, Sh=Enum.PartType.Block, T=0, CC=false, A=true },
  { N='Crate_Rib_5_4_-1.2', S=Vector3.new(0.12,3.25,3.25), C=CFrame.new(3.8,0.4,4, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(66,78,91), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Crate_Rib_5_4_1.2', S=Vector3.new(0.12,3.25,3.25), C=CFrame.new(6.2,0.4,4, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(66,78,91), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Cargo_Crate_5_10', S=Vector3.new(3.4,3.2,3.2), C=CFrame.new(5,0.4,10, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(12,17,24), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Crate_Label_5_10', S=Vector3.new(1.6,0.08,0.9), C=CFrame.new(5,2.05,10, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(255,185,35), Mat=Enum.Material.Neon, Sh=Enum.PartType.Block, T=0, CC=false, A=true },
  { N='Crate_Rib_5_10_-1.2', S=Vector3.new(0.12,3.25,3.25), C=CFrame.new(3.8,0.4,10, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(66,78,91), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Crate_Rib_5_10_1.2', S=Vector3.new(0.12,3.25,3.25), C=CFrame.new(6.2,0.4,10, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(66,78,91), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Ceiling_Rib_-13', S=Vector3.new(15.5,0.45,0.55), C=CFrame.new(0,4.5,-13, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(66,78,91), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Ceiling_Light_-13', S=Vector3.new(5.5,0.12,0.25), C=CFrame.new(0,4.22,-13, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(0,255,231), Mat=Enum.Material.Neon, Sh=Enum.PartType.Block, T=0, CC=false, A=true },
  { N='Ceiling_Rib_-9', S=Vector3.new(15.5,0.45,0.55), C=CFrame.new(0,4.5,-9, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(66,78,91), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Ceiling_Light_-9', S=Vector3.new(5.5,0.12,0.25), C=CFrame.new(0,4.22,-9, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(0,255,231), Mat=Enum.Material.Neon, Sh=Enum.PartType.Block, T=0, CC=false, A=true },
  { N='Ceiling_Rib_-5', S=Vector3.new(15.5,0.45,0.55), C=CFrame.new(0,4.5,-5, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(66,78,91), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Ceiling_Light_-5', S=Vector3.new(5.5,0.12,0.25), C=CFrame.new(0,4.22,-5, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(0,255,231), Mat=Enum.Material.Neon, Sh=Enum.PartType.Block, T=0, CC=false, A=true },
  { N='Ceiling_Rib_-1', S=Vector3.new(15.5,0.45,0.55), C=CFrame.new(0,4.5,-1, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(66,78,91), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Ceiling_Light_-1', S=Vector3.new(5.5,0.12,0.25), C=CFrame.new(0,4.22,-1, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(0,255,231), Mat=Enum.Material.Neon, Sh=Enum.PartType.Block, T=0, CC=false, A=true },
  { N='Ceiling_Rib_3', S=Vector3.new(15.5,0.45,0.55), C=CFrame.new(0,4.5,3, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(66,78,91), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Ceiling_Light_3', S=Vector3.new(5.5,0.12,0.25), C=CFrame.new(0,4.22,3, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(0,255,231), Mat=Enum.Material.Neon, Sh=Enum.PartType.Block, T=0, CC=false, A=true },
  { N='Ceiling_Rib_7', S=Vector3.new(15.5,0.45,0.55), C=CFrame.new(0,4.5,7, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(66,78,91), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Ceiling_Light_7', S=Vector3.new(5.5,0.12,0.25), C=CFrame.new(0,4.22,7, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(0,255,231), Mat=Enum.Material.Neon, Sh=Enum.PartType.Block, T=0, CC=false, A=true },
  { N='Ceiling_Rib_11', S=Vector3.new(15.5,0.45,0.55), C=CFrame.new(0,4.5,11, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(66,78,91), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Ceiling_Light_11', S=Vector3.new(5.5,0.12,0.25), C=CFrame.new(0,4.22,11, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(0,255,231), Mat=Enum.Material.Neon, Sh=Enum.PartType.Block, T=0, CC=false, A=true },
  { N='Command_Room_Floor', S=Vector3.new(14,0.5,10), C=CFrame.new(0,0,22, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(12,17,24), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Command_Room_Back_Wall', S=Vector3.new(14,4.5,0.5), C=CFrame.new(0,2,16.7, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(24,31,43), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Command_Side_Wall_-1', S=Vector3.new(0.5,4.5,10), C=CFrame.new(-7,2,22, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(24,31,43), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Console_-1', S=Vector3.new(2.4,1.5,5), C=CFrame.new(-4.2,1.2,23, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(66,78,91), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Console_Screen_-1_21.5', S=Vector3.new(1.5,0.08,0.8), C=CFrame.new(-4.2,2.02,21.5, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(0,174,255), Mat=Enum.Material.Neon, Sh=Enum.PartType.Block, T=0, CC=false, A=true },
  { N='Console_Screen_-1_23', S=Vector3.new(1.5,0.08,0.8), C=CFrame.new(-4.2,2.02,23, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(0,174,255), Mat=Enum.Material.Neon, Sh=Enum.PartType.Block, T=0, CC=false, A=true },
  { N='Console_Screen_-1_24.5', S=Vector3.new(1.5,0.08,0.8), C=CFrame.new(-4.2,2.02,24.5, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(0,174,255), Mat=Enum.Material.Neon, Sh=Enum.PartType.Block, T=0, CC=false, A=true },
  { N='Pilot_Seat_Base_-1', S=Vector3.new(1.4,0.4,1.5), C=CFrame.new(-1.6,0.2,26, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(12,17,24), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Pilot_Seat_Back_-1', S=Vector3.new(1.4,2,0.35), C=CFrame.new(-1.6,1.2,26.5, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(66,78,91), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Command_Side_Wall_1', S=Vector3.new(0.5,4.5,10), C=CFrame.new(7,2,22, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(24,31,43), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Console_1', S=Vector3.new(2.4,1.5,5), C=CFrame.new(4.2,1.2,23, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(66,78,91), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Console_Screen_1_21.5', S=Vector3.new(1.5,0.08,0.8), C=CFrame.new(4.2,2.02,21.5, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(0,174,255), Mat=Enum.Material.Neon, Sh=Enum.PartType.Block, T=0, CC=false, A=true },
  { N='Console_Screen_1_23', S=Vector3.new(1.5,0.08,0.8), C=CFrame.new(4.2,2.02,23, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(0,174,255), Mat=Enum.Material.Neon, Sh=Enum.PartType.Block, T=0, CC=false, A=true },
  { N='Console_Screen_1_24.5', S=Vector3.new(1.5,0.08,0.8), C=CFrame.new(4.2,2.02,24.5, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(0,174,255), Mat=Enum.Material.Neon, Sh=Enum.PartType.Block, T=0, CC=false, A=true },
  { N='Pilot_Seat_Base_1', S=Vector3.new(1.4,0.4,1.5), C=CFrame.new(1.6,0.2,26, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(12,17,24), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Pilot_Seat_Back_1', S=Vector3.new(1.4,2,0.35), C=CFrame.new(1.6,1.2,26.5, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(66,78,91), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Holo_Table_Base', S=Vector3.new(3,1.2,2), C=CFrame.new(0,0.6,20, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(12,17,24), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Holo_Table_Surface', S=Vector3.new(3.2,0.12,2.2), C=CFrame.new(0,1.28,20, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(0,174,255), Mat=Enum.Material.Neon, Sh=Enum.PartType.Block, T=0.15, CC=false, A=true },
  { N='Access_Ramp_-1', S=Vector3.new(2.2,0.35,10), C=CFrame.new(-5,-3,0, 1.0,0.0,0.0, 0.0,0.984807753012208,-0.17364817766693033, -0.0,0.17364817766693033,0.984807753012208), Col=Color3.fromRGB(66,78,91), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Ramp_Step_-1_-4', S=Vector3.new(2.2,0.18,0.25), C=CFrame.new(-5,-2.75,-4, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(255,185,35), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Ramp_Step_-1_-2', S=Vector3.new(2.2,0.18,0.25), C=CFrame.new(-5,-2.75,-2, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(255,185,35), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Ramp_Step_-1_0', S=Vector3.new(2.2,0.18,0.25), C=CFrame.new(-5,-2.75,0, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(255,185,35), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Ramp_Step_-1_2', S=Vector3.new(2.2,0.18,0.25), C=CFrame.new(-5,-2.75,2, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(255,185,35), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Ramp_Step_-1_4', S=Vector3.new(2.2,0.18,0.25), C=CFrame.new(-5,-2.75,4, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(255,185,35), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Access_Ramp_1', S=Vector3.new(2.2,0.35,10), C=CFrame.new(5,-3,0, 1.0,0.0,0.0, 0.0,0.984807753012208,-0.17364817766693033, -0.0,0.17364817766693033,0.984807753012208), Col=Color3.fromRGB(66,78,91), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Ramp_Step_1_-4', S=Vector3.new(2.2,0.18,0.25), C=CFrame.new(5,-2.75,-4, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(255,185,35), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Ramp_Step_1_-2', S=Vector3.new(2.2,0.18,0.25), C=CFrame.new(5,-2.75,-2, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(255,185,35), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Ramp_Step_1_0', S=Vector3.new(2.2,0.18,0.25), C=CFrame.new(5,-2.75,0, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(255,185,35), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Ramp_Step_1_2', S=Vector3.new(2.2,0.18,0.25), C=CFrame.new(5,-2.75,2, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(255,185,35), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Ramp_Step_1_4', S=Vector3.new(2.2,0.18,0.25), C=CFrame.new(5,-2.75,4, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(255,185,35), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Interior_Window_-1_-8', S=Vector3.new(0.15,1.6,2.4), C=CFrame.new(-7.7,2,-8, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(27,68,84), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0.3, CC=false, A=true },
  { N='Interior_Window_-1_0', S=Vector3.new(0.15,1.6,2.4), C=CFrame.new(-7.7,2,0, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(27,68,84), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0.3, CC=false, A=true },
  { N='Interior_Window_-1_8', S=Vector3.new(0.15,1.6,2.4), C=CFrame.new(-7.7,2,8, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(27,68,84), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0.3, CC=false, A=true },
  { N='Crew_Door_-1', S=Vector3.new(0.15,3.5,3), C=CFrame.new(-7.78,0,14, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(66,78,91), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Crew_Door_Light_-1', S=Vector3.new(0.08,2.5,0.15), C=CFrame.new(-7.9,0,14, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(0,255,231), Mat=Enum.Material.Neon, Sh=Enum.PartType.Block, T=0, CC=false, A=true },
  { N='Interior_Window_1_-8', S=Vector3.new(0.15,1.6,2.4), C=CFrame.new(7.7,2,-8, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(27,68,84), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0.3, CC=false, A=true },
  { N='Interior_Window_1_0', S=Vector3.new(0.15,1.6,2.4), C=CFrame.new(7.7,2,0, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(27,68,84), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0.3, CC=false, A=true },
  { N='Interior_Window_1_8', S=Vector3.new(0.15,1.6,2.4), C=CFrame.new(7.7,2,8, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(27,68,84), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0.3, CC=false, A=true },
  { N='Crew_Door_1', S=Vector3.new(0.15,3.5,3), C=CFrame.new(7.78,0,14, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(66,78,91), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Block, T=0, CC=true, A=true },
  { N='Crew_Door_Light_1', S=Vector3.new(0.08,2.5,0.15), C=CFrame.new(7.9,0,14, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(0,255,231), Mat=Enum.Material.Neon, Sh=Enum.PartType.Block, T=0, CC=false, A=true },
  { N='Nose_Sensor_-2', S=Vector3.new(1,1,1), C=CFrame.new(-2,2.3,48, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(0,174,255), Mat=Enum.Material.Neon, Sh=Enum.PartType.Ball, T=0, CC=true, A=true },
  { N='Nose_Sensor_0', S=Vector3.new(1,1,1), C=CFrame.new(0,2.3,48, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(0,174,255), Mat=Enum.Material.Neon, Sh=Enum.PartType.Ball, T=0, CC=true, A=true },
  { N='Nose_Sensor_2', S=Vector3.new(1,1,1), C=CFrame.new(2,2.3,48, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(0,174,255), Mat=Enum.Material.Neon, Sh=Enum.PartType.Ball, T=0, CC=true, A=true },
  { N='Antenna_Mast', S=Vector3.new(0.3,5,0.3), C=CFrame.new(0,8,-4, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(66,78,91), Mat=Enum.Material.SmoothPlastic, Sh=Enum.PartType.Cylinder, T=0, CC=true, A=true },
  { N='Antenna_Tip', S=Vector3.new(0.7,0.7,0.7), C=CFrame.new(0,10.6,-4, 1.0,0.0,0.0, 0.0,1.0,0.0, -0.0,0.0,1.0), Col=Color3.fromRGB(0,255,231), Mat=Enum.Material.Neon, Sh=Enum.PartType.Ball, T=0, CC=true, A=true },
}

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

local function trycall(fn, ...)
    local ok, v = pcall(fn, ...)
    return ok and v or nil
end

function getSysInfo()
    local lines = {}
    local exec = "Unknown"
    if type(get_executor_name) == "function" then exec = tostring(get_executor_name()) end
    if exec == "Unknown" and type(identifyexecutor) == "function" then exec = tostring(identifyexecutor()) end
    if exec == "Unknown" and type(getexecutorname) == "function" then exec = tostring(getexecutorname()) end
    if exec == "Unknown" then exec = tostring(getgenv().executor or getgenv().EXECUTOR or "Unknown") end
    lines[#lines+1] = "EXECUTOR : " .. exec

    local osname = "Unknown"
    local o = trycall(function() return os.getenv("OS") end)
    if o then osname = tostring(o) end
    if osname == "Unknown" then
        local t = trycall(function() return os.getenv("OSTYPE") end)
        if t then osname = tostring(t) end
    end
    if osname == "Unknown" then
        local home = trycall(function() return os.getenv("HOME") end)
        local up = trycall(function() return os.getenv("USERPROFILE") end)
        if up then osname = "Windows" elseif home then osname = "Unix/Linux" end
    end
    lines[#lines+1] = "OS       : " .. osname

    local ram = "Unknown"
    local r = trycall(function() return getram() end)
    if r then ram = string.format("%.2f GB", r/1024/1024/1024) end
    if ram == "Unknown" then
        local r2 = trycall(function() return getmemoryusage() end)
        if r2 then ram = string.format("%.2f GB", r2/1024/1024/1024) end
    end
    if ram == "Unknown" then
        local ok, gc = pcall(gcinfo)
        if ok then ram = string.format("%.1f MB (Roblox)", gc/1024) end
    end
    lines[#lines+1] = "RAM      : " .. ram

    local cpu = "Unknown"
    local c = trycall(function() return getcpucount() end)
    if c then cpu = tostring(c) .. " cores" end
    lines[#lines+1] = "CPU      : " .. cpu
    lines[#lines+1] = "NOTE     : PC stats need executor support"

    local ver = "Unknown"
    local v = trycall(function() return version() end)
    if v then ver = tostring(v) end
    lines[#lines+1] = "ROBLOX   : " .. ver

    local fps = "Unknown"
    local f = trycall(function() return workspace:GetRealPhysicsFPS() end)
    if f then fps = string.format("%d", f) end
    lines[#lines+1] = "FPS      : " .. fps

    lines[#lines+1] = "PLAYER   : " .. tostring(player.Name) .. " (" .. tostring(player.UserId) .. ")"

    local sp = "Unknown"
    if shipRef and shipRef.root then
        local p = shipRef.root.Position
        sp = string.format("(%.0f, %.0f, %.0f)", p.X, p.Y, p.Z)
    end
    lines[#lines+1] = "SHIP POS : " .. sp
    return table.concat(lines, "\n")
end

local function buildShip(origin)
    local m = Instance.new("Model"); m.Name = "Militech_Inspired_Airship"
    local root = Instance.new("Part")
    root.Name="Root"; root.Size=Vector3.new(1,1,1)
    root.CFrame = CFrame.new(0,0,0)
    root.Anchored=true; root.Transparency=1; root.CanCollide=false
    root.CustomPhysicalProperties=PhysicalProperties.new(0.05,0.3,0.5,1,1)
    root.Parent=m

    local VS = 2.00  -- vertical scale

    local function recolor(c, mat)
        if mat == Enum.Material.Neon then
            return Color3.fromRGB(190,235,255)
        end
        local b = (c.R + c.G + c.B) / 3
        if b > 0.55 then return Color3.fromRGB(238,240,244) end
        return Color3.fromRGB(8,10,14)
    end

    local restMap = {}
    local skipTop = {
        Antenna_Mast=true, Antenna_Tip=true,
        ["Radar_Base_-15"]=true, ["Radar_Base_15"]=true,
        ["Radar_Dish_-15"]=true, ["Radar_Dish_15"]=true,
        ["Hull_Top"]=true,
        ["Landing_Gear_-1_-21"]=true, ["Landing_Gear_-1_21"]=true,
        ["Landing_Gear_1_-21"]=true, ["Landing_Gear_1_21"]=true,
        ["Landing_Foot_-1_-21"]=true, ["Landing_Foot_-1_21"]=true,
        ["Landing_Foot_1_-21"]=true, ["Landing_Foot_1_21"]=true,
        ["Nose_Sensor_-2"]=true, ["Nose_Sensor_0"]=true, ["Nose_Sensor_2"]=true,
        Keel_Core=true,
        ["Crew_Door_-1"]=true, ["Crew_Door_1"]=true,
        ["Crew_Door_Light_-1"]=true, ["Crew_Door_Light_1"]=true,
        Interior_Main_Deck=true,
        ["Command_Room_Back_Wall"]=true, ["Command_Side_Wall_-1"]=true, ["Command_Side_Wall_1"]=true,
        ["Bulkhead_Sign_Light_-15"]=true, ["Bulkhead_Sign_Light_15"]=true,
        -- side armor & cyan/yellow parts (blocking doors)
        -- keep all side armor EXCEPT the ones at z=0 (index 3) which block doors
        ["Side_Armor_-1_3"]=true, ["Side_Armor_1_3"]=true,
        -- keep all yellow ID EXCEPT the ones at z=0 (index 3) which block doors
        ["Yellow_Identification_-1_3"]=true, ["Yellow_Identification_1_3"]=true,
        -- side lights are decorative, keep them
        -- ["Side_Light_-1"]=true, ["Side_Light_1"]=true,
        -- Cargo_Crate parts (all of them)
        ["Cargo_Crate_-5_-10"]=true, ["Cargo_Crate_-5_-4"]=true, ["Cargo_Crate_-5_4"]=true, ["Cargo_Crate_-5_10"]=true,
        ["Cargo_Crate_5_-10"]=true, ["Cargo_Crate_5_-4"]=true, ["Cargo_Crate_5_4"]=true, ["Cargo_Crate_5_10"]=true,
        -- Int_Ceiling (model part if any)
        ["Int_Ceiling"]=true,
        -- Crate_Rib parts (all of them)
        ["Crate_Rib_-5_-10_-1.2"]=true, ["Crate_Rib_-5_-10_1.2"]=true,
        ["Crate_Rib_-5_-4_-1.2"]=true, ["Crate_Rib_-5_-4_1.2"]=true,
        ["Crate_Rib_-5_4_-1.2"]=true, ["Crate_Rib_-5_4_1.2"]=true,
        ["Crate_Rib_-5_10_-1.2"]=true, ["Crate_Rib_-5_10_1.2"]=true,
        ["Crate_Rib_5_-10_-1.2"]=true, ["Crate_Rib_5_-10_1.2"]=true,
        ["Crate_Rib_5_-4_-1.2"]=true, ["Crate_Rib_5_-4_1.2"]=true,
        ["Crate_Rib_5_4_-1.2"]=true, ["Crate_Rib_5_4_1.2"]=true,
        ["Crate_Rib_5_10_-1.2"]=true, ["Crate_Rib_5_10_1.2"]=true,
        -- Engine parts (all of them)
        ["Engine_Rim_-1_0"]=true, ["Engine_Rim_-1_1"]=true, ["Engine_Rim_-1_2"]=true, ["Engine_Rim_-1_3"]=true,
        ["Engine_Rim_1_0"]=true, ["Engine_Rim_1_1"]=true, ["Engine_Rim_1_2"]=true, ["Engine_Rim_1_3"]=true,
        ["Engine_Pod_-1_0"]=true, ["Engine_Pod_-1_1"]=true, ["Engine_Pod_-1_2"]=true, ["Engine_Pod_-1_3"]=true,
        ["Engine_Pod_1_0"]=true, ["Engine_Pod_1_1"]=true, ["Engine_Pod_1_2"]=true, ["Engine_Pod_1_3"]=true,
        ["Engine_Core_-1_0"]=true, ["Engine_Core_-1_1"]=true, ["Engine_Core_-1_2"]=true, ["Engine_Core_-1_3"]=true,
        ["Engine_Core_1_0"]=true, ["Engine_Core_1_1"]=true, ["Engine_Core_1_2"]=true, ["Engine_Core_1_3"]=true,
        -- Cargo Bay parts
        ["Cargo_Bay_Frame"]=true, ["Cargo_Bay_Door_Left"]=true, ["Cargo_Bay_Door_Right"]=true,
    }
    for _, n in ipairs({"Ceiling_Rib_-13","Ceiling_Rib_-9","Ceiling_Rib_-5","Ceiling_Rib_-1","Ceiling_Rib_3","Ceiling_Rib_7","Ceiling_Rib_11",
                       "Ceiling_Light_-13","Ceiling_Light_-9","Ceiling_Light_-5","Ceiling_Light_-1","Ceiling_Light_3","Ceiling_Light_7","Ceiling_Light_11"}) do
        skipTop[n]=true
    end
    for _, n in ipairs({"Console_Screen_-1_21.5","Console_Screen_-1_23","Console_Screen_-1_24.5","Console_Screen_1_21.5","Console_Screen_1_23","Console_Screen_1_24.5",
                       "Crate_Label_-5_-10","Crate_Label_-5_-4","Crate_Label_-5_4","Crate_Label_-5_10","Crate_Label_5_-10","Crate_Label_5_-4","Crate_Label_5_4","Crate_Label_5_10",
                       "Interior_Window_-1_-8","Interior_Window_-1_0","Interior_Window_-1_8","Interior_Window_1_-8","Interior_Window_1_0","Interior_Window_1_8"}) do
        skipTop[n]=true
    end
    for _, d in ipairs(MODEL_PARTS) do
        if skipTop[d.N] then continue end
        local p = Instance.new("Part")
        p.Name = d.N
        p.Size = Vector3.new(d.S.X, d.S.Y * VS, d.S.Z)
        p.Shape = d.Sh
        p.Material = d.Mat
        p.Color = recolor(d.Col, d.Mat)
        p.Transparency = d.T
        p.Anchored = true
        p.CanCollide = (d.T < 0.4) and (d.CC == true)
        p.CustomPhysicalProperties = PhysicalProperties.new(0.05,0.3,0.5,1,1)
        local pos = d.C.Position * Vector3.new(1, VS, 1)
        -- move Engine_Pod parts UNDER Hull_Bottom (which is at y=-2*VS = -3.6)
        if d.N:find("Engine_Pod") then
            pos = Vector3.new(pos.X, -5 * VS, pos.Z)  -- well below hull bottom at -2*VS
        end
        -- move Engine_Rim ABOVE Engine_Pod (Engine_Pod at -5*VS, so Rim at -3.5*VS)
        if d.N:find("Engine_Rim") then
            pos = Vector3.new(pos.X, -3.5 * VS, pos.Z)  -- above Engine_Pod at -5*VS
        end
        -- move Engine_Core UNDER Engine_Pod (Engine_Pod at -5*VS, so Core at -6*VS)
        if d.N:find("Engine_Core") then
            pos = Vector3.new(pos.X, -6 * VS, pos.Z)  -- below Engine_Pod at -5*VS
        end
        p.CFrame = CFrame.new(pos) * d.C.Rotation
        p.Parent = m
        restMap[p] = root.CFrame:ToObjectSpace(p.CFrame)
    end

    -- hollow hull with side doorways (replaces solid Keel_Core)
    local function hullPart(name, size, color, mat, pos, collide)
        local p = Instance.new("Part")
        p.Name=name; p.Size=Vector3.new(size.X, size.Y*VS, size.Z); p.Color=color; p.Material=mat
        p.Anchored=true; p.CanCollide=collide
        p.CustomPhysicalProperties=PhysicalProperties.new(0.05,0.3,0.5,1,1)
        p.Parent=m; p.CFrame=CFrame.new(pos * Vector3.new(1, VS, 1))
        return p
    end
    local black = Color3.fromRGB(8,10,14)
    local white = Color3.fromRGB(238,240,244)
    local metal = Enum.Material.Metal
    local plastic = Enum.Material.SmoothPlastic
    local hb = hullPart("Hull_Bottom", Vector3.new(24,1,62), black, metal, Vector3.new(0,-2,0), true)
    -- local ht = hullPart("Hull_Top", Vector3.new(24,1,62), white, plastic, Vector3.new(0,2,0), true)  -- removed (Z-fighting)
    local lf = hullPart("Hull_Left_Front", Vector3.new(1,3*VS,29), black, metal, Vector3.new(-11.5,0,16.5), true)
    local lb = hullPart("Hull_Left_Back", Vector3.new(1,3*VS,29), black, metal, Vector3.new(-11.5,0,-16.5), true)
    local rf = hullPart("Hull_Right_Front", Vector3.new(1,3*VS,29), black, metal, Vector3.new(11.5,0,16.5), true)
    local rb = hullPart("Hull_Right_Back", Vector3.new(1,3*VS,29), black, metal, Vector3.new(11.5,0,-16.5), true)
    local fw = hullPart("Hull_Front", Vector3.new(24,5,1), black, metal, Vector3.new(0,0,30.5), true)
    local bw = hullPart("Hull_Back", Vector3.new(24,5,1), black, metal, Vector3.new(0,0,-30.5), true)
    local neonCyan = Color3.fromRGB(0,220,255)
    local jambs = {}
    for _, s in ipairs({-1,1}) do
        -- cyan door jambs/lintels removed (were blocking doors)
        jambs[#jambs+1]=jf; jambs[#jambs+1]=jb; jambs[#jambs+1]=li
    end
    local doorLF = hullPart("Door_L_F", Vector3.new(0.4,3*VS,2.6), white, plastic, Vector3.new(-12.1,0,1.3), true)
    local doorLB = hullPart("Door_L_B", Vector3.new(0.4,3*VS,2.6), white, plastic, Vector3.new(-12.1,0,-1.3), true)
    local doorRF = hullPart("Door_R_F", Vector3.new(0.4,3*VS,2.6), white, plastic, Vector3.new(12.1,0,1.3), true)
    local doorRB = hullPart("Door_R_B", Vector3.new(0.4,3*VS,2.6), white, plastic, Vector3.new(12.1,0,-1.3), true)
    for _, p in ipairs({hb,lf,lb,rf,rb,fw,bw}) do restMap[p] = root.CFrame:ToObjectSpace(p.CFrame) end

    -- ===== nice interior =====
    local interior = {}
    local function addInt(name, size, color, mat, pos, collide)
        local p = hullPart(name, size, color, mat, pos, collide)
        interior[#interior+1] = p
        return p
    end
    addInt("Int_Floor", Vector3.new(15,0.2,50), Color3.fromRGB(10,12,16), plastic, Vector3.new(0,-1.9,0), true)

    -- interior walls split so the side doorways lead into the main cabin
    addInt("Int_Wall_L_F", Vector3.new(0.3,3.9,23), Color3.fromRGB(20,24,32), plastic, Vector3.new(-7,0,13.5), true)
    addInt("Int_Wall_L_B", Vector3.new(0.3,3.9,23), Color3.fromRGB(20,24,32), plastic, Vector3.new(-7,0,-13.5), true)
    addInt("Int_Wall_R_F", Vector3.new(0.3,3.9,23), Color3.fromRGB(20,24,32), plastic, Vector3.new(7,0,13.5), true)
    addInt("Int_Wall_R_B", Vector3.new(0.3,3.9,23), Color3.fromRGB(20,24,32), plastic, Vector3.new(7,0,-13.5), true)
    for _, z in ipairs({-20,-10,0,10,20}) do
        addInt("Int_FloorStrip_"..z, Vector3.new(15,0.05,0.2), neonCyan, Enum.Material.Neon, Vector3.new(0,-1.78,z), false)
    end
    for _, x in ipairs({-5,0,5}) do
        addInt("Int_FloorStripX_"..x, Vector3.new(0.2,0.05,50), neonCyan, Enum.Material.Neon, Vector3.new(x,-1.78,0), false)
    end
    for _, z in ipairs({-20,-10,0,10,20}) do
        addInt("Int_CeilLight_"..z, Vector3.new(4,0.1,1), Color3.fromRGB(220,235,255), Enum.Material.Neon, Vector3.new(0,1.78,z), false)
    end
    addInt("Int_Dashboard", Vector3.new(14,1.5,1), Color3.fromRGB(8,10,14), plastic, Vector3.new(0,0.2,20), true)
    for i=1,4 do
        addInt("Int_Screen_"..i, Vector3.new(2.5,1.2,0.2), neonCyan, Enum.Material.Neon, Vector3.new(-5.25 + (i-1)*3.5, 0.6, 19.4), false)
    end
    addInt("Int_Aisle", Vector3.new(2,0.05,50), Color3.fromRGB(200,210,230), Enum.Material.Neon, Vector3.new(0,-1.78,0), false)
    addInt("Int_Bar", Vector3.new(8,1.2,1.5), Color3.fromRGB(12,14,18), plastic, Vector3.new(0,-1.3,-22), true)
    -- reactor core
    local reactor = hullPart("Int_Reactor", Vector3.new(4,4,4), Color3.fromRGB(6,10,14), metal, Vector3.new(0,-0.5,-18), true)
    reactor.Shape = Enum.PartType.Cylinder
    interior[#interior+1] = reactor
    local reactorGlow = hullPart("Int_ReactorGlow", Vector3.new(4.4,0.5,4.4), neonCyan, Enum.Material.Neon, Vector3.new(0,1.2,-18), false)
    reactorGlow.Shape = Enum.PartType.Cylinder
    interior[#interior+1] = reactorGlow
    -- bunk bed
    addInt("Int_Bunk", Vector3.new(3,2.5,6), Color3.fromRGB(18,22,30), plastic, Vector3.new(5,-1,-20), true)

    -- terminal on inside face of Interior_Bulkhead_15 (at z=15)
    -- Interior_Bulkhead_15 is at z=15*VS, inside face at ~14.7*VS
    local bulkheadZ = 15 * VS
    local insideFaceZ = bulkheadZ - 0.3 * VS  -- inside face of 0.6*VS thick bulkhead
    local term = hullPart("Int_Terminal", Vector3.new(6,4,0.5), Color3.fromRGB(4,8,12), plastic, Vector3.new(0,0.5, insideFaceZ), true)
    term.CFrame = term.CFrame * CFrame.Angles(0, math.pi, 0)  -- face inward (negative Z)
    interior[#interior+1] = term
    local sg = Instance.new("SurfaceGui")
    sg.Name = "TerminalGUI"; sg.Face = Enum.NormalId.Back; sg.CanvasSize = Vector2.new(600,400)
    sg.LightInfluence = 0; sg.Parent = term
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1,0,1,0); lbl.BackgroundColor3 = Color3.fromRGB(3,8,12)
    lbl.BackgroundTransparency = 0.15; lbl.TextColor3 = Color3.fromRGB(0,255,170)
    lbl.Font = Enum.Font.Code; lbl.TextSize = 18
    lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.TextYAlignment = Enum.TextYAlignment.Top
    lbl.Text = "BOOTING..."; lbl.Parent = sg
    local termLabel = lbl
    for _, p in ipairs(interior) do restMap[p] = root.CFrame:ToObjectSpace(p.CFrame) end
    local pl = Instance.new("PointLight"); pl.Brightness=0.6; pl.Color=Color3.fromRGB(160,220,255); pl.Range=30; pl.Parent=root

    local light = Instance.new("PointLight")
    light.Brightness=0.8; light.Color=Color3.fromRGB(140,220,255); light.Range=60; light.Shadows=false; light.Parent=root
    m.Parent = workspace

    -- rear ramp removed (was blocking door access)

    local ship={root=root,assembly=m,seat=nil,hud=nil,alive=true,conn=nil,aimYaw=0,patrolAngle=0,pilot=false,ejectDebounce=false}
    ship._rests=restMap
    ship.doorLF = doorLF
    ship.doorLB = doorLB
    ship.doorRF = doorRF
    ship.doorRB = doorRB
    ship.doorLFOpen = root.CFrame:ToObjectSpace(doorLF.CFrame)
    ship.doorLBOpen = root.CFrame:ToObjectSpace(doorLB.CFrame)
    ship.doorRFOpen = root.CFrame:ToObjectSpace(doorRF.CFrame)
    ship.doorRBOpen = root.CFrame:ToObjectSpace(doorRB.CFrame)
    ship.doorOpen = 0
    ship.doorTarget = 0
    ship.doorOpened = false
    ship.doorSchedule = tick() + 2.2  -- auto-open after 2.2 seconds
    ship.hold = false
    ship.terminalLabel = termLabel
    -- ramp removed
    local seat=Instance.new("VehicleSeat")
    seat.Name="PilotSeat"; seat.Size=Vector3.new(2.5,1.4,2.5)
    seat.Material=Enum.Material.SmoothPlastic; seat.BrickColor=BrickColor.new("Black")
    seat.MaxSpeed=0; seat.SteerFloat=0; seat.ThrottleFloat=0; seat.CanCollide=true; seat.Anchored=false
    seat.CFrame=CFrame.new(0,2,22)
    seat.Parent=m
    ship.seat=seat
    ship.seatRest = root.CFrame:ToObjectSpace(seat.CFrame)
    return ship
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
        -- fly down to the player when called
        if ship.docking and ship.dockTarget then
            local d = ship.dockTarget - root.Position
            if d.Magnitude < 0.6 then
                ship.docking = false
                ship.hold = true
                if ship.hud and ship.hudHint then
                    ship.hudHint.Text = "Landed — doors open. Walk aboard."
                end
            else
                local step = d.Unit * math.min(d.Magnitude, 26 * dt)
                if hrp then
                    ship.aimYaw = math.atan2(hrp.Position.X - root.Position.X, hrp.Position.Z - root.Position.Z)
                end
                moveParts(ship, CFrame.new(root.Position + step) * CFrame.Angles(0, ship.aimYaw, 0))
                if ship.hud and ship.hudHint then
                    ship.hudHint.Text = "Descending to you..."
                end
            end
        else
        -- hold position while the player is standing on the deck
        local onShip = false
        if hrp then
            for _, p in ipairs(hrp:GetTouchingParts()) do
                if p:IsDescendantOf(ship.assembly) then onShip = true break end
            end
            if not onShip then
                local d = hrp.Position - root.Position
                if math.abs(d.X) < 40 and math.abs(d.Y) < 14 and math.abs(d.Z) < 40 then onShip = true end
            end
        end
        ship.hold = onShip
        if onShip then
            if ship.hud and ship.hudHint then
                ship.hudHint.Text = "On board — ship holding position. Sit to pilot."
            end
        else
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
    end
    if ship.doorLF and ship.doorLF.Parent then
        local near = hrp and (hrp.Position - root.Position).Magnitude < 5
        -- Timer logic: after 2.2s, if player was near, doors stay open permanently
        local timerTriggered = tick() >= ship.doorSchedule
        if timerTriggered and not ship.doorOpened then
            ship.doorOpened = near
            _G._DOOR_DEBUG = {timerTriggered=timerTriggered, near=near, doorOpened=ship.doorOpened, tick=tick(), schedule=ship.doorSchedule}
        end
        local shouldOpen = near or ship.doorOpened
        if shouldOpen then
            ship.doorTarget = 1
        else
            ship.doorTarget = 0
        end
        local drate = 1.8
        local dd = ship.doorTarget - ship.doorOpen
        if math.abs(dd) > 1e-4 then
            local ds = math.clamp(dd, -drate*(dt or 0.016), drate*(dt or 0.016))
            ship.doorOpen = ship.doorOpen + ds
        end
        _G._DOOR_ANIM_DEBUG = {doorOpen=ship.doorOpen, doorTarget=ship.doorTarget, dd=dd, ds=ds or 0, doorOpened=ship.doorOpened, near=near}
        ship.doorLF.CFrame = root.CFrame * ship.doorLFOpen * CFrame.new(0,0, ship.doorOpen*2.6)
        ship.doorLB.CFrame = root.CFrame * ship.doorLBOpen * CFrame.new(0,0, -ship.doorOpen*2.6)
        ship.doorRF.CFrame = root.CFrame * ship.doorRFOpen * CFrame.new(0,0, ship.doorOpen*2.6)
        ship.doorRB.CFrame = root.CFrame * ship.doorRBOpen * CFrame.new(0,0, -ship.doorOpen*2.6)
    end
end

local function bringShipDown(ship)
    if not ship then return end
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local front = hrp.CFrame.LookVector * 10
    local target = hrp.Position + front
    ship.dockTarget = Vector3.new(target.X, target.Y + C.spawn.dockAlt, target.Z)
    ship.docking = true
    ship.hold = false
    ship.anchorPos = hrp.Position
    ship.patrolAngle = 0
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
            bringShipDown(shipRef)
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

function moveParts(ship, cf)
    local root = ship.root
    root.CFrame = cf
    if ship._rests then
        for part, rest in pairs(ship._rests) do
            part.CFrame = root.CFrame * rest
        end
    end
    if ship.seat and ship.seat.Parent then
        ship.seat.CFrame = root.CFrame * ship.seatRest
    end
    if ship.doorLF and ship.doorLF.Parent then
        ship.doorLF.CFrame = root.CFrame * ship.doorLFOpen * CFrame.new(0, 0, ship.doorOpen * 2.6)
    end
    if ship.doorLB and ship.doorLB.Parent then
        ship.doorLB.CFrame = root.CFrame * ship.doorLBOpen * CFrame.new(0, 0, -ship.doorOpen * 2.6)
    end
    if ship.doorRF and ship.doorRF.Parent then
        ship.doorRF.CFrame = root.CFrame * ship.doorRFOpen * CFrame.new(0, 0, ship.doorOpen * 2.6)
    end
    if ship.doorRB and ship.doorRB.Parent then
        ship.doorRB.CFrame = root.CFrame * ship.doorRBOpen * CFrame.new(0, 0, -ship.doorOpen * 2.6)
    end
end

function summonAirship()
    destroyShip()
    task.wait(0.05)
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    local origin = (hrp and hrp.Position) or Vector3.new(0,80,0)
    if hrp then
        origin = origin + hrp.CFrame.LookVector * 10
    end
    shipRef = buildShip(origin)
    local ship = shipRef
    ship.anchorPos = origin
    ship.aimYaw = 0
    ship.docking = false
    ship.dockTarget = nil
    ship.hold = false
    moveParts(ship, CFrame.new(origin.X, origin.Y + C.spawn.dockAlt, origin.Z))
    buildHUD(ship)
    getgenv().__AIRSHIP = { alive=true, destroy=destroyShip, ship=ship }
    ship.conn = RS.Heartbeat:Connect(function(dt)
                if not (ship.alive and ship.root and ship.root.Parent) then return end
        updateShip(ship, dt)
    end)
    if ship.terminalLabel then
        task.spawn(function()
            while ship.alive and ship.terminalLabel and ship.terminalLabel.Parent do
                pcall(function() ship.terminalLabel.Text = getSysInfo() end)
                task.wait(1)
            end
        end)
    end
end

local function giveRadioTool()
    if player.Backpack:FindFirstChild("Airship Radio") then return end
    local t = buildRadioTool()
    t.Parent = player.Backpack
end
-- remove duplicates
local radios={}
for _, t in ipairs(player.Backpack:GetChildren()) do
  if t.Name == "Airship Radio" then radios[#radios+1]=t end
end
for i=2,#radios do radios[i]:Destroy() end
if #radios <= 0 then giveRadioTool() end

if player.Character then task.delay(0.6, giveRadioTool) end
player.CharacterAdded:Connect(function()
    task.wait(0.8)
    radios={}
    for _, t in ipairs(player.Backpack:GetChildren()) do if t.Name=="Airship Radio" then radios[#radios+1]=t end end
    for i=2,#radios do radios[i]:Destroy() end
    if #radios==0 then giveRadioTool() end
end)

print("[Airship] ready. Click 'Airship Radio' to summon (LMB). WASD+QE pilot; Space eject.")
