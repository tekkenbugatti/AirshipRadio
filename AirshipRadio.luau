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

local function buildShip(origin)
    local m = Instance.new("Model"); m.Name = "Airship_Harmony"
    local L,W,H = 54,22,11
    local root = Instance.new("Part")
    root.Name = "Root"; root.Size = Vector3.new(1,1,1)
    root.CFrame = CFrame.new(0,0,0)
    root.Anchored = true; root.Transparency = 1; root.CanCollide=false
    root.CustomPhysicalProperties = PhysicalProperties.new(0.05,0.3,0.5,1,1)
    root.Parent = m

    local function add(p, pos)
        local nn = Instance.new("Part")
        nn.Anchored=p.Anchored~=nil and p.Anchored or true
        nn.CanCollide=p.CanCollide~=nil and p.CanCollide or true
        nn.CustomPhysicalProperties = PhysicalProperties.new(0.05,0.3,0.5,1,1)
        for k,v in pairs(p) do if k ~= "Anchored" and k ~= "CanCollide" then nn[k]=v end end
        nn.CFrame = CFrame.new(pos)
        nn.Parent = m
        return nn
    end

    -- === exterior ===
    local hull = add({Name="Hull_Upper",Size=Vector3.new(L,H,W),Color=Color3.fromRGB(235,238,242),Material=Enum.Material.SmoothPlastic,Transparency=0}, Vector3.new(0,0,0))
    local hullLow = add({Name="Hull_Belly",Size=Vector3.new(L*0.98,H*0.55,W*0.92),Color=Color3.fromRGB(14,16,22),Material=Enum.Material.Metal}, Vector3.new(0,-H*0.32,0))
    local keel = add({Name="Keel", Size=Vector3.new(L*0.7,H*0.25,W*0.25),Color=Color3.fromRGB(30,35,45),Material=Enum.Material.Metal}, Vector3.new(0,-H*0.48,0))
    local nose = add({Name="Nose", Size=Vector3.new(W*0.4,H*0.95,L*0.22),Color=Color3.fromRGB(235,238,242),Material=Enum.Material.Glass,Transparency=0.35}, Vector3.new(0,H*0.05,L*0.42))
    local tail = add({Name="TailBoom", Size=Vector3.new(W*0.35,H*0.6,L*0.25),Color=Color3.fromRGB(14,16,22),Material=Enum.Material.Metal}, Vector3.new(0,H*0.05,-L*0.38))
    local stabL = add({Name="StabL", Size=Vector3.new(1,H*1.5,W*0.55),Color=Color3.fromRGB(235,238,242),Material=Enum.Material.SmoothPlastic}, Vector3.new(0,H*0.7,-L*0.42))
    local stabR = add({Name="StabR", Size=Vector3.new(1,H*1.5,W*0.55),Color=Color3.fromRGB(235,238,242),Material=Enum.Material.SmoothPlastic}, Vector3.new(0,H*0.7,-L*0.42)) -- same lift tube placeholder
    -- observation deck
    add({Name="ObsDeck", Size=Vector3.new(W*0.45,H*0.15,L*0.55),Color=Color3.fromRGB(32,36,44),Material=Enum.Material.Glass,Transparency=0.3}, Vector3.new(0,H*0.42,0))
    add({Name="GlassRail", Size=Vector3.new(W*0.45,0.4,L*0.55),Color=Color3.fromRGB(100,200,255),Material=Enum.Material.Glass,Transparency=0.5}, Vector3.new(0,H*0.5,L*0.05))
    -- engine pods back rear port+starboard
    for _, s in ipairs({-1,1}) do
        add({Name="EngPod_"..(s>0 and "R" or "L"), Size=Vector3.new(5,4,10),Color=Color3.fromRGB(20,24,30),Material=Enum.Material.Metal}, Vector3.new(s*(W*0.55),-H*0.05,-L*0.32))
        add({Name="EngGlow_"..(s>0 and "R" or "L"), Size=Vector3.new(2.2,2.2,3.2),Color=Color3.fromRGB(120,230,255),Material=Enum.Material.Neon,Transparency=0.15}, Vector3.new(s*(W*0.55),-H*0.05,-L*0.38))
    end
    -- exterior trim neon stripes
    for _, s in ipairs({-1,1}) do
        add({Name="StripeSide_"..(s>0 and "R" or "L"), Size=Vector3.new(L*0.92,0.25,0.25),Color=Color3.fromRGB(120,230,255),Material=Enum.Material.Neon,Transparency=0.15}, Vector3.new(0,-H*0.05,s*(W*0.48)))
    end
    add({Name="StripeBottom", Size=Vector3.new(L*0.92,0.25,0.25),Color=Color3.fromRGB(120,230,255),Material=Enum.Material.Neon,Transparency=0.15}, Vector3.new(0,-H*0.42,0))

    -- === interior ===
    -- floor
    add({Name="Int_Floor", Size=Vector3.new(L*0.62,H*0.15,W*0.43),Color=Color3.fromRGB(9,12,16),Material=Enum.Material.SmoothPlastic}, Vector3.new(0,-H*0.18,0))
    add({Name="Int_Floor2", Size=Vector3.new(L*0.62,H*0.08,W*0.43),Color=Color3.fromRGB(14,18,26),Material=Enum.Material.SmoothPlastic}, Vector3.new(0,-H*0.3,0))
    -- grid strips
    for _, x in ipairs({-18,-12,-6,0,6,12,18}) do
        add({Name="FloorStrip_"..x, Size=Vector3.new(0.2,H*0.05,W*0.43),Color=Color3.fromRGB(210,215,230),Material=Enum.Material.Neon,Transparency=0.4}, Vector3.new(x, -H*0.07, 0))
    end
    -- interior side walls with glass windows
    for _, s in ipairs({-1,1}) do
        add({Name="Wall_"..(s>0 and "R" or "L"), Size=Vector3.new(L*0.55,H*0.7,0.4),Color=Color3.fromRGB(18,22,30),Material=Enum.Material.SmoothPlastic}, Vector3.new(0,-H*0.02,s*(W*0.21)))
        for _, z in ipairs({-18,-10,0,10,18}) do
            add({Name="Window_"..(s>0 and "R" or "L").."_"..z, Size=Vector3.new(L*0.12,H*0.35,0.08),Color=Color3.fromRGB(120,200,255),Material=Enum.Material.Glass,Transparency=0.55}, Vector3.new(L*0.0, -H*0.05, s*(W*0.215)+z*0.35)) -- simplified
        end
    end
    -- cockpit dashboard & screens
    add({Name="Dashboard", Size=Vector3.new(W*0.32,1.6,0.5),Color=Color3.fromRGB(10,12,16),Material=Enum.Material.SmoothPlastic}, Vector3.new(0,H*0.05,L*0.35))
    add({Name="DashMid", Size=Vector3.new(W*0.32,0.35,3.2),Color=Color3.fromRGB(14,18,24),Material=Enum.Material.Metal}, Vector3.new(0,-H*0.1,L*0.24))
    for _, z in ipairs({-2.2,-0.8,0.8,2.2}) do
        add({Name="Screen_"..(z>0 and "R" or "L")..z, Size=Vector3.new(0.15,H*0.45,1.8),Color=Color3.fromRGB(100,200,255),Material=Enum.Material.Neon,Transparency=0.15}, Vector3.new(-L*0.16,H*0.05,L*0.28+z))
    end
    -- benches & passenger seats
    for _, i in ipairs({1,2,3}) do
        add({Name="Couch_"..i, Size=Vector3.new(4,1,8),Color=Color3.fromRGB(14,18,26),Material=Enum.Material.Fabric}, Vector3.new(4,H*0.02,( -L*0.2 +(i-1)*8 )))
    end
    for _, i in ipairs({1,2,3}) do
        add({Name="CouchL_"..i, Size=Vector3.new(4,1,8),Color=Color3.fromRGB(14,18,26),Material=Enum.Material.Fabric}, Vector3.new(-4,H*0.02,( -L*0.2 +(i-1)*8 )))
    end
    -- central aisle light strips
    add({Name="Aisle", Size=Vector3.new(2,0.2,L*0.6),Color=Color3.fromRGB(220,225,235),Material=Enum.Material.Neon,Transparency=0.25}, Vector3.new(0,-H*0.03,0))
    -- engine room rear
    add({Name="EngineCore", Size=Vector3.new(8,5,8),Color=Color3.fromRGB(7,10,14),Material=Enum.Material.Metal}, Vector3.new(0, -H*0.1,-L*0.3))
    add({Name="EngineRing", Size=Vector3.new(9,0.4,9),Color=Color3.fromRGB(120,230,255),Material=Enum.Material.Neon,Transparency=0.2}, Vector3.new(0,-H*0.1,-L*0.3))
    -- boarding ramp/door
    add({Name="RearRamp", Size=Vector3.new(12,0.6,W*0.45),Color=Color3.fromRGB(32,36,44),Material=Enum.Material.Glass,Transparency=0.4}, Vector3.new(0,-H*0.1,L*0.34))
    -- storage crates
    for _, z in ipairs({-6,0,6}) do
        add({Name="Crate_"..z, Size=Vector3.new(3,2.2,3),Color=Color3.fromRGB(32,36,46),Material=Enum.Material.Metal}, Vector3.new(W*0.09,-H*0.15, z*0.6))
    end
    -- ceiling recessed lights
    for _, x in ipairs({-18,-6,6,18}) do
        add({Name="CeilLight_"..x, Size=Vector3.new(3,0.25,1),Color=Color3.fromRGB(210,230,255),Material=Enum.Material.Neon,Transparency=0.1}, Vector3.new(x,H*0.32,0))
    end

    local light = Instance.new("PointLight")
    light.Brightness=0.8; light.Color=Color3.fromRGB(120,220,255); light.Range=62; light.Shadows=false; light.Parent=root
    m.Parent = workspace

    local restMap={}
    for _,c in ipairs(m:GetDescendants()) do
       if c:IsA("BasePart") and c~=root and c.Name ~= "RearRamp" then
           restMap[c]=root.CFrame:ToObjectSpace(c.CFrame)
       end
    end

    local ship={root=root,assembly=m,seat=nil,hud=nil,alive=true,conn=nil,aimYaw=0,patrolAngle=0,pilot=false,ejectDebounce=false}
    ship._rests=restMap
    local rampPart = (function() for _,c in ipairs(m:GetDescendants()) do if c.Name=="RearRamp" then return c end end end)()
    ship.rampPart = rampPart
    ship.rampPivot = CFrame.new(0, -H*0.08, L*0.36)
    ship.rampRot = math.rad(0)
    ship.rampTarget = math.rad(0)
    ship.rampOpened = false
    ship.rampSchedule = tick() + 2.2
    local seat=Instance.new("VehicleSeat")
    seat.Name="PilotSeat"; seat.Size=Vector3.new(2.5,1.4,2.5)
    seat.Material=Enum.Material.SmoothPlastic; seat.BrickColor=BrickColor.new("Black")
    seat.MaxSpeed=0; seat.SteerFloat=0; seat.ThrottleFloat=0; seat.CanCollide=true; seat.Anchored=false
    seat.CFrame = CFrame.new(0,0.5,L*0.27)
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
    if ship.rampPart and ship.rampPart.Parent then
        if not ship.rampOpened and tick() >= ship.rampSchedule then
            ship.rampOpened = true
            ship.rampTarget = math.rad(135)
        end
        local rate = 2.8
        local dlt = ship.rampTarget - ship.rampRot
        if math.abs(dlt) > 1e-4 then
            local st = math.clamp(dlt, -rate*(dt or 0.016), rate*(dt or 0.016))
            ship.rampRot = ship.rampRot + st
        end
        ship.rampPart.CFrame = ship.root.CFrame * ship.rampPivot * CFrame.Angles(ship.rampRot,0,0)
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
    -- Spawn straight at dock height (no pop-in wait/rely risk).
    moveParts(ship, CFrame.new(origin.X, origin.Y + C.spawn.dockAlt, origin.Z))
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
