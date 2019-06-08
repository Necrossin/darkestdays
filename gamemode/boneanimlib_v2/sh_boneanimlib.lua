--[[

Bone Animations Library
Created by William "JetBoom" Moodhe (williammoodhe@gmail.com / www.noxiousnet.com)
Because I wanted custom, dynamic animations.
Give credit or reference if used in your creations.

]]

TYPE_GESTURE = 0 -- Gestures are keyframed animations that use the current position and angles of the bones. They play once and then stop automatically.
TYPE_POSTURE = 1 -- Postures are static animations that use the current position and angles of the bones. They stay that way until manually stopped. Use TimeToArrive if you want to have a posture lerp.
TYPE_STANCE = 2 -- Stances are keyframed animations that use the current position and angles of the bones. They play forever until manually stopped. Use RestartFrame to specify a frame to go to if the animation ends (instead of frame 1).
TYPE_SEQUENCE = 3 -- Sequences are keyframed animations that use the reference pose. They play forever until manually stopped. Use RestartFrame to specify a frame to go to if the animation ends (instead of frame 1).
-- You can also use StartFrame to specify a starting frame for the first loop.

INTERP_LINEAR = 0 -- Straight linear interp.
INTERP_COSINE = 1 -- Best compatability / quality balance.
INTERP_CUBIC = 2 -- Overall best quality blending but may cause animation frames to go 'over the top'.
INTERP_DEFAULT = INTERP_COSINE

local Animations = {}

function GetLuaAnimations()
	return Animations
end

function RegisterLuaAnimation(sName, tInfo)
	if tInfo.FrameData then
		local BonesUsed = {}
		for iFrame, tFrame in ipairs(tInfo.FrameData) do
			for iBoneID, tBoneTable in pairs(tFrame.BoneInfo) do
				BonesUsed[iBoneID] = (BonesUsed[iBoneID] or 0) + 1
				tBoneTable.MU = tBoneTable.MU or 0
				tBoneTable.MF = tBoneTable.MF or 0
				tBoneTable.MR = tBoneTable.MR or 0
				tBoneTable.RU = tBoneTable.RU or 0
				tBoneTable.RF = tBoneTable.RF or 0
				tBoneTable.RR = tBoneTable.RR or 0
			end
		end

		if #tInfo.FrameData > 1 then
			for iBoneUsed, iTimesUsed in pairs(BonesUsed) do
				for iFrame, tFrame in ipairs(tInfo.FrameData) do
					if not tFrame.BoneInfo[iBoneUsed] then
						tFrame.BoneInfo[iBoneUsed] = {MU = 0, MF = 0, MR = 0, RU = 0, RF = 0, RR = 0}
					end
				end
			end
		end
	end
	Animations[sName] = tInfo
end

-----------------------------
-- Deserialize / Serialize --
-----------------------------
function Deserialize(sIn)
	SRL = nil

	RunString(sIn)

	return SRL
end

local allowedtypes = {}
allowedtypes["string"] = true
allowedtypes["number"] = true
allowedtypes["table"] = true
allowedtypes["Vector"] = true
allowedtypes["Angle"] = true
allowedtypes["boolean"] = true
local function MakeTable(tab, done)
	local str = ""
	local done = done or {}

	local sequential = table.IsSequential(tab)

	for key, value in pairs(tab) do
		local keytype = type(key)
		local valuetype = type(value)

		if allowedtypes[keytype] and allowedtypes[valuetype] then
			if sequential then
				key = ""
			else
				if keytype == "number" or keytype == "boolean" then 
					key ="["..tostring(key).."]="
				else
					key = "["..string.format("%q", tostring(key)).."]="
				end
			end

			if valuetype == "table" and not done[value] then
				done[value] = true
				if type(value._serialize) == "function" then
					str = str..key..value:_serialize()..","
				else
					str = str..key.."{"..MakeTable(value, done).."},"
				end
			else
				if valuetype == "string" then 
					value = string.format("%q", value)
				elseif valuetype == "Vector" then
					value = "Vector("..value.x..","..value.y..","..value.z..")"
				elseif valuetype == "Angle" then
					value = "Angle("..value.pitch..","..value.yaw..","..value.roll..")"
				else
					value = tostring(value)
				end

				str = str .. key .. value .. ","
			end
		end
	end

	if string.sub(str, -1) == "," then
		return string.sub(str, 1, #str - 1)
	else
		return str
	end
end

function Serialize(tIn, bRaw)
	if bRaw then
		return "{"..MakeTable(tIn).."}"
	end

	return "SRL={"..MakeTable(tIn).."}"
end
---------------------------------
-- End Deserialize / Serialize --
---------------------------------

RegisterLuaAnimation('aaaa2', {
	FrameData = {
		{
			BoneInfo = {
				['ValveBiped.Bip01_Spine'] = {
					RU = 30,
					RR = 30
				},
				['ValveBiped.Bip01_Head1'] = {
				}
			},
			FrameRate = 1
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_Spine'] = {
					RU = -30,
					RR = -30
				},
				['ValveBiped.Bip01_Head1'] = {
					RF = 102
				}
			},
			FrameRate = 1
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_Head1'] = {
					RF = -227
				},
				['ValveBiped.Bip01_Spine'] = {
				}
			},
			FrameRate = 1
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_Head1'] = {
					RF = 128
				},
				['ValveBiped.Bip01_Spine'] = {
				}
			},
			FrameRate = 1
		}
	},
	RestartFrame = 1,
	Type = TYPE_STANCE
})

//Pistol!
RegisterLuaAnimation('cast_revolver', {
	FrameData = {
		{
			BoneInfo = {
				['ValveBiped.Bip01_L_Clavicle'] = {
				},
				['ValveBiped.Bip01_L_UpperArm'] = {
				},
				['ValveBiped.Bip01_L_Hand'] = {
				},
				['ValveBiped.Bip01_L_Forearm'] = {
				}
			},
			FrameRate = 10
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_L_Clavicle'] = {
					RU = 5,
					RR = 10,
					RF = 3
				},
				['ValveBiped.Bip01_L_UpperArm'] = {
					RU = -11,
					RR = -33,
					RF = -1
				},
				['ValveBiped.Bip01_L_Hand'] = {
					RU = -25,
					RR = -33,
					RF = 50
				},
				['ValveBiped.Bip01_L_Forearm'] = {
					RU = 45,
					RR = 1,
					RF = 24
				}
			},
			FrameRate = 3.3333333333333
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_L_Clavicle'] = {
					RU = 5,
					RR = 10,
					RF = 3
				},
				['ValveBiped.Bip01_L_UpperArm'] = {
					RU = -11,
					RR = -33,
					RF = -1
				},
				['ValveBiped.Bip01_L_Hand'] = {
					RU = -20,
					RR = -60,
					RF = 68
				},
				['ValveBiped.Bip01_L_Forearm'] = {
					RU = 45,
					RR = 4,
					RF = 24
				}
			},
			FrameRate = 3.3333333333333
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_L_Clavicle'] = {
				},
				['ValveBiped.Bip01_L_UpperArm'] = {
				},
				['ValveBiped.Bip01_L_Hand'] = {
				},
				['ValveBiped.Bip01_L_Forearm'] = {
				}
			},
			FrameRate = 5
		}
	},
	Type = TYPE_GESTURE
})

//shotgun
RegisterLuaAnimation('cast_shotgun', {
	FrameData = {
		{
			BoneInfo = {
				['ValveBiped.Bip01_L_Clavicle'] = {
				},
				['ValveBiped.Bip01_L_UpperArm'] = {
				},
				['ValveBiped.Bip01_L_Hand'] = {
				},
				['ValveBiped.Bip01_L_Forearm'] = {
				}
			},
			FrameRate = 10
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_L_Clavicle'] = {
				},
				['ValveBiped.Bip01_L_UpperArm'] = {
					RU = 10,
					RR = -54,
					RF = 3
				},
				['ValveBiped.Bip01_L_Hand'] = {
					RU = 22,
					RR = -32,
					RF = 42
				},
				['ValveBiped.Bip01_L_Forearm'] = {
					RU = 40,
					RR = -44,
					RF = 15
				}
			},
			FrameRate = 3.3333333333333
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_L_Clavicle'] = {
				},
				['ValveBiped.Bip01_L_UpperArm'] = {
					RR = -48,
					RF = 10
				},
				['ValveBiped.Bip01_L_Hand'] = {
					RU = 29,
					RR = -48,
					RF = 55
				},
				['ValveBiped.Bip01_L_Forearm'] = {
					RU = 40,
					RR = -33,
					RF = 21
				}
			},
			FrameRate = 3.3333333333333
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_L_Clavicle'] = {
				},
				['ValveBiped.Bip01_L_UpperArm'] = {
				},
				['ValveBiped.Bip01_L_Hand'] = {
				},
				['ValveBiped.Bip01_L_Forearm'] = {
				}
			},
			FrameRate = 3.3333333333333
		}
	},
	Type = TYPE_GESTURE
})

//ar2
RegisterLuaAnimation('cast_ar2', {
	FrameData = {
		{
			BoneInfo = {
				['ValveBiped.Bip01_L_Clavicle'] = {
				},
				['ValveBiped.Bip01_L_UpperArm'] = {
				},
				['ValveBiped.Bip01_L_Hand'] = {
				},
				['ValveBiped.Bip01_L_Forearm'] = {
				}
			},
			FrameRate = 10
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_L_Clavicle'] = {
					RR = -1,
					RF = 10
				},
				['ValveBiped.Bip01_L_UpperArm'] = {
					RU = -24,
					RR = -42,
					RF = 2
				},
				['ValveBiped.Bip01_L_Hand'] = {
					RU = 7,
					RR = -75,
					RF = 64
				},
				['ValveBiped.Bip01_L_Forearm'] = {
					RU = 38,
					RR = 6,
					RF = 54
				}
			},
			FrameRate = 4
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_L_Clavicle'] = {
					RR = -1,
					RF = 10
				},
				['ValveBiped.Bip01_L_UpperArm'] = {
					RU = -24,
					RR = -42,
					RF = 2
				},
				['ValveBiped.Bip01_L_Hand'] = {
					RU = 7,
					RR = -75,
					RF = 64
				},
				['ValveBiped.Bip01_L_Forearm'] = {
					RU = 38,
					RR = 6,
					RF = 54
				}
			},
			FrameRate = 4
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_L_Clavicle'] = {
				},
				['ValveBiped.Bip01_L_UpperArm'] = {
				},
				['ValveBiped.Bip01_L_Hand'] = {
				},
				['ValveBiped.Bip01_L_Forearm'] = {
				}
			},
			FrameRate = 3.3333333333333
		}
	},
	Type = TYPE_GESTURE
})

//smg
RegisterLuaAnimation('cast_smg', {
	FrameData = {
		{
			BoneInfo = {
				['ValveBiped.Bip01_L_UpperArm'] = {
				},
				['ValveBiped.Bip01_L_Hand'] = {
				},
				['ValveBiped.Bip01_L_Forearm'] = {
				}
			},
			FrameRate = 10
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_L_UpperArm'] = {
					RU = 6,
					RR = -25,
					RF = -2
				},
				['ValveBiped.Bip01_L_Hand'] = {
					RU = 41,
					RR = -29,
					RF = 29
				},
				['ValveBiped.Bip01_L_Forearm'] = {
					RU = 20
				}
			},
			FrameRate = 3.3333333333333
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_L_UpperArm'] = {
					RU = 6,
					RR = -25,
					RF = -2
				},
				['ValveBiped.Bip01_L_Hand'] = {
					RU = 41,
					RR = -29,
					RF = 29
				},
				['ValveBiped.Bip01_L_Forearm'] = {
					RU = 20
				}
			},
			FrameRate = 3.3333333333333
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_L_UpperArm'] = {
				},
				['ValveBiped.Bip01_L_Hand'] = {
				},
				['ValveBiped.Bip01_L_Forearm'] = {
				}
			},
			FrameRate = 5
		}
	},
	Type = TYPE_GESTURE
})

//crossbow
RegisterLuaAnimation('cast_crossbow', {
	FrameData = {
		{
			BoneInfo = {
				['ValveBiped.Bip01_L_UpperArm'] = {
				},
				['ValveBiped.Bip01_L_Hand'] = {
				},
				['ValveBiped.Bip01_L_Forearm'] = {
				}
			},
			FrameRate = 10
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_L_UpperArm'] = {
					RU = -11,
					RR = -58,
					RF = -13
				},
				['ValveBiped.Bip01_L_Hand'] = {
					RU = 5,
					RR = -60,
					RF = 74
				},
				['ValveBiped.Bip01_L_Forearm'] = {
					RU = 27,
					RR = -9,
					RF = 30
				}
			},
			FrameRate = 3.3333333333333
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_L_UpperArm'] = {
					RU = -11,
					RR = -58,
					RF = -13
				},
				['ValveBiped.Bip01_L_Hand'] = {
					RU = 5,
					RR = -60,
					RF = 74
				},
				['ValveBiped.Bip01_L_Forearm'] = {
					RU = 27,
					RR = -9,
					RF = 30
				}
			},
			FrameRate = 3.3333333333333
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_L_UpperArm'] = {
				},
				['ValveBiped.Bip01_L_Hand'] = {
				},
				['ValveBiped.Bip01_L_Forearm'] = {
				}
			},
			FrameRate = 5
		}
	},
	Type = TYPE_GESTURE
})

//roll!
RegisterLuaAnimation('roll', {
	FrameData = {
		{
			BoneInfo = {
				['ValveBiped.Bip01_Spine2'] = {
				},
				['ValveBiped.Bip01_Pelvis'] = {
				}
			},
			FrameRate = 14
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_Spine2'] = {
					RU = 78.955341028598
				},
				['ValveBiped.Bip01_Pelvis'] = {
					RF = 54.162392153687
				}
			},
			FrameRate = 14
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_Spine2'] = {
					RU = 78.955341028598
				},
				['ValveBiped.Bip01_Pelvis'] = {
					MU = -1.430643773264,
					RF = 131.48823637521
				}
			},
			FrameRate = 14
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_Spine2'] = {
					RU = 78.955341028598
				},
				['ValveBiped.Bip01_Pelvis'] = {
					MU = -5.3347083681082,
					RF = 192.75567192718
				}
			},
			FrameRate = 14
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_Spine2'] = {
					RU = 78.955341028598
				},
				['ValveBiped.Bip01_Pelvis'] = {
					MU = -7.950579786573,
					RF = 235.48087148308
				}
			},
			FrameRate = 14
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_Spine2'] = {
					RU = 78.955341028598
				},
				['ValveBiped.Bip01_Pelvis'] = {
					MU = -7.950579786573,
					RF = 297.04672252115
				}
			},
			FrameRate = 14
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_Spine2'] = {
					RU = 78.955341028598
				},
				['ValveBiped.Bip01_Pelvis'] = {
					MU = -4.2442135559418,
					RF = 329.24175943415
				}
			},
			FrameRate = 14
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_Spine2'] = {
					RU = 35.560587500262
				},
				['ValveBiped.Bip01_Pelvis'] = {
					RF = 360
				}
			},
			FrameRate = 14
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_Spine2'] = {
				},
				['ValveBiped.Bip01_Pelvis'] = {
					RF = 360
				}
			},
			FrameRate = 14
		}
	},
	Type = TYPE_GESTURE
})


RegisterLuaAnimation('melee_block', {
	FrameData = {
		/*{
			BoneInfo = {
				['ValveBiped.Bip01_R_UpperArm'] = {
				},
				['ValveBiped.Bip01_R_Hand'] = {
				},
				['ValveBiped.Bip01_L_UpperArm'] = {
				},
				['ValveBiped.Bip01_L_Hand'] = {
					RU = 0.0092952150854315
				},
				['ValveBiped.Bip01_L_Forearm'] = {
				},
				['ValveBiped.Bip01_R_Forearm'] = {
				}
			},
			FrameRate = 10
		},*/
		{
			/*BoneInfo = {
				['ValveBiped.Bip01_Spine2'] = {
					RU = -5.7340510235554,
					RF = -10.226772762414
				},
				['ValveBiped.Bip01_L_Clavicle'] = {
					RU = -31.738438393088,
					RR = -7.0240865127609,
					RF = -37.108412108579
				},
				['ValveBiped.Bip01_L_Forearm'] = {
					RU = 20.727464491322,
					RR = -9.3466894062965,
					RF = 33.994404710983
				},
				['ValveBiped.Bip01_R_UpperArm'] = {
					RU = 2.0943097958618,
					RR = 38.163714057126,
					RF = -18.584123547523
				},
				['ValveBiped.Bip01_L_Hand'] = {
					RU = 54.325530154007,
					RR = 4.8127955643584,
					RF = -16.021912431484
				},
				['ValveBiped.Bip01_L_UpperArm'] = {
					RU = -31.663556365361,
					RR = -14.559716223098,
					RF = 55.841764581884
				},
				['ValveBiped.Bip01_Spine4'] = {
					RU = 8,
					RF = -3.8306214273718
				},
				['ValveBiped.Bip01_R_Forearm'] = {
					RU = 1.0118546463376,
					RR = -1.0065727096195,
					RF = 23.96788695199
				},
				['ValveBiped.Bip01_R_Clavicle'] = {
					RU = -7,
					RR = 17.291796067501,
					RF = 37.95492536376
				},
				['ValveBiped.Bip01_R_Hand'] = {
					RU = 17.265505229023,
					RR = -35.64488323792,
					RF = -14.812559200041
				}
			},*/
			BoneInfo = {
				['ValveBiped.Bip01_Spine2'] = {
					RU = -5.7340510235554,
					RF = -10.226772762414
				},
				['ValveBiped.Bip01_R_Clavicle'] = {
					RU = -7,
					RR = 21.454073727669,
					RF = 37.95492536376
				},
				['ValveBiped.Bip01_L_Forearm'] = {
					RU = 20.727464491322,
					RR = -9.3466894062965,
					RF = 33.994404710983
				},
				['ValveBiped.Bip01_L_UpperArm'] = {
				},
				['ValveBiped.Bip01_L_Hand'] = {
					RU = 54.325530154007,
					RR = 4.8127955643584,
					RF = -16.021912431484
				},
				['ValveBiped.Bip01_R_UpperArm'] = {
					RU = -12.498049351385,
					RR = 5.2673811939227,
					RF = -21.412550672269
				},
				['ValveBiped.Bip01_Spine4'] = {
					RU = 8,
					RF = -3.8306214273718
				},
				['ValveBiped.Bip01_R_Forearm'] = {
					RU = 10.515726450747,
					RR = -8.2917960675006,
					RF = 14.96788695199
				},
				['ValveBiped.Bip01_L_Clavicle'] = {
				},
				['ValveBiped.Bip01_R_Hand'] = {
					RU = 14.164560597692,
					RR = -16.417582272665,
					RF = -58.713765670824
				}
			},
			FrameRate = 8
		}
	},
	ShouldPlay = function(pl, sGestureName, tGestureTable, iCurFrame, tFrameData)
		return pl:IsDefending()
	end,
	TimeToArrive = 0.15,
	Type = TYPE_POSTURE
})

RegisterLuaAnimation('melee_swing', {
	FrameData = {
		{
			BoneInfo = {
				['ValveBiped.Bip01_R_Clavicle'] = {
					RR = 8.7020132209632,
					RF = 64.878828005926
				}
			},
			FrameRate = 1
		}
	},
	ShouldPlay = function(pl, sGestureName, tGestureTable, iCurFrame, tFrameData)
		local wep = pl:GetActiveWeapon():IsValid() and pl:GetActiveWeapon()
		return wep and wep.IsSwinging and wep:IsSwinging()
	end,
	TimeToArrive = 0.16,
	OverrideTimeToArrive = function( pl )
		local wep = pl:GetActiveWeapon():IsValid() and pl:GetActiveWeapon()
		if wep and wep.IsSwinging and wep:IsSwinging() then
			return wep.SwingTime
		end
		return 0.16
	end,
	Type = TYPE_POSTURE
})

RegisterLuaAnimation('melee_swing_left', {
	FrameData = {
		{
			BoneInfo = {
				['ValveBiped.Bip01_L_UpperArm'] = {
				},
				['ValveBiped.Bip01_Spine1'] = {
					RF = -22.01490529635
				},
				['ValveBiped.Bip01_R_Forearm'] = {
					RU = 29.842780095934,
					RR = -17.12728859144,
					RF = 29.773552830133
				},
				['ValveBiped.Bip01_Spine4'] = {
				},
				['ValveBiped.Bip01_R_Clavicle'] = {
					RU = -28.500088677812,
					RR = -16.289991048781,
					RF = 15.240628999381
				},
				['ValveBiped.Bip01_Spine2'] = {
				},
				['ValveBiped.Bip01_R_Hand'] = {
					RU = -17.429846228625,
					RR = 29.723627571397,
					RF = 21.3916809598
				}
			},
			FrameRate = 1
		}
	},
	ShouldPlay = function(pl, sGestureName, tGestureTable, iCurFrame, tFrameData)
		local wep = pl:GetActiveWeapon():IsValid() and pl:GetActiveWeapon()
		return wep and wep.IsSwinging and wep:IsSwinging()
	end,
	TimeToArrive = 0.16,
	OverrideTimeToArrive = function( pl )
		local wep = pl:GetActiveWeapon():IsValid() and pl:GetActiveWeapon()
		if wep and wep.IsSwinging and wep:IsSwinging() then
			return wep.SwingTime
		end
		return 0.16
	end,
	Type = TYPE_POSTURE
})

RegisterLuaAnimation('melee_swing_right', {
	FrameData = {
		{
			BoneInfo = {
				['ValveBiped.Bip01_R_UpperArm'] = {
					RU = -15.193184497174,
					RR = 27.835057971954,
					RF = 1.6509674340158
				},
				['ValveBiped.Bip01_R_Clavicle'] = {
					RU = 1.9946437110031,
					RR = 70.754784439612,
					RF = -5.2478164194936
				},
				['ValveBiped.Bip01_R_Forearm'] = {
					RU = -13.209420053327,
					RR = -15.430875879683,
					RF = -63.823461942869
				},
				['ValveBiped.Bip01_R_Hand'] = {
					RR = -37.012117291362,
					RF = -0.29195018788059
				}
			},
			FrameRate = 1
		}
	},
	ShouldPlay = function(pl, sGestureName, tGestureTable, iCurFrame, tFrameData)
		local wep = pl:GetActiveWeapon():IsValid() and pl:GetActiveWeapon()
		return wep and wep.IsSwinging and wep:IsSwinging()
	end,
	TimeToArrive = 0.16,
	OverrideTimeToArrive = function( pl )
		local wep = pl:GetActiveWeapon():IsValid() and pl:GetActiveWeapon()
		if wep and wep.IsSwinging and wep:IsSwinging() then
			return wep.SwingTime
		end
		return 0.16
	end,
	Type = TYPE_POSTURE
})


RegisterLuaAnimation('melee_idle_2hand', {
	FrameData = {
		{
			BoneInfo = {
				['ValveBiped.Bip01_R_UpperArm'] = {
					RU = -9.8311496302121,
					RR = 5.4953660262655,
					RF = -16.154631831986
				},
				['ValveBiped.Bip01_L_Hand'] = {
				},
				['ValveBiped.Bip01_R_Forearm'] = {
					RU = 16.150762707537
				},
				['ValveBiped.Bip01_R_Clavicle'] = {
					RU = 5,
					RR = 31.932782392288,
					RF = 26.700105720448
				},
				['ValveBiped.Bip01_L_Clavicle'] = {
					RR = 43.645842678516
				},
				['ValveBiped.Bip01_R_Hand'] = {
					RU = 15.506565389079,
					RR = -14.7639320225
				},
				['ValveBiped.Bip01_L_Forearm'] = {
					RU = 10.915215172652
				}
			},
			FrameRate = 1
		}
	},
	ShouldPlay = function(pl, sGestureName, tGestureTable, iCurFrame, tFrameData)
		local wep = IsValid(pl:GetActiveWeapon()) and pl:GetActiveWeapon()
		
		if pl:IsDefending() then
			return false
		end
		
		if pl:IsSliding() then
			return false
		end
		
		if pl:IsWallrunning() then
			return false
		end
		
		if pl:IsRolling() then
			return false
		end
				
		if pl:IsSprinting() then
			return false
		end
		
		if !pl:Alive() then
			return false
		end
		
		if wep and !wep.IsMelee then
			return false
		end
		
		return true
	end,
	Type = TYPE_POSTURE
})

RegisterLuaAnimation('slide', {
	FrameData = {
		{
			BoneInfo = {
				['ValveBiped.Bip01_Pelvis'] = {
					RF = -20,
					MU = -30,
				},
				['ValveBiped.Bip01_Spine4'] = {
					RU = 20
				}
			},
			FrameRate = 1
		}
	},
	ShouldPlay = function(pl, sGestureName, tGestureTable, iCurFrame, tFrameData)
		return pl:IsSliding()
	end,
	Type = TYPE_POSTURE
})

RegisterLuaAnimation('martialarts', {
	FrameData = {
		{
			BoneInfo = {
				['ValveBiped.Bip01_R_Finger11'] = {
					RU = 81.963208356596
				},
				['ValveBiped.Bip01_R_Clavicle'] = {
					RU = 11.567769435976,
					RR = -2.8035055197414,
					RF = 24.999484408653
				},
				['ValveBiped.Bip01_R_Finger01'] = {
					RU = 14.833776847172,
					RR = 3.7406007639561
				},
				['ValveBiped.Bip01_R_Finger22'] = {
					RU = 90.040624490262
				},
				['ValveBiped.Bip01_L_Finger0'] = {
					RU = 7.6475942712289,
					RR = -3.6698409571754
				},
				['ValveBiped.Bip01_L_Finger21'] = {
					RU = 83.219361529277
				},
				['ValveBiped.Bip01_R_Finger1'] = {
					RU = 79.044161603634
				},
				['ValveBiped.Bip01_R_Finger21'] = {
					RU = 80.228278645299
				},
				['ValveBiped.Bip01_L_Finger12'] = {
					RU = 84.640628503519
				},
				['ValveBiped.Bip01_L_Finger11'] = {
					RU = 75.911778762406
				},
				['ValveBiped.Bip01_L_Finger1'] = {
					RU = 88.755214189034
				},
				['ValveBiped.Bip01_L_Clavicle'] = {
					RU = 4.3764694831051,
					RR = 6.2036647611,
					RF = -26.488708820819
				},
				['ValveBiped.Bip01_R_Forearm'] = {
					RU = 5.6693105212827,
					RR = 0.48745476587547,
					RF = -0.17246519858016
				},
				['ValveBiped.Bip01_R_Finger2'] = {
					RU = 78.113559979051
				},
				['ValveBiped.Bip01_L_Finger01'] = {
					RU = -0.35977899510674
				},
				['ValveBiped.Bip01_L_Finger22'] = {
					RU = 70.90712464509
				},
				['ValveBiped.Bip01_L_Finger2'] = {
					RU = 83.664730253346
				},
				['ValveBiped.Bip01_L_Finger02'] = {
					RU = 37.316584736633
				},
				['ValveBiped.Bip01_R_Finger12'] = {
					RU = 69.920962816266
				},
				['ValveBiped.Bip01_R_Finger02'] = {
					RU = 33.103193851149
				},
				['ValveBiped.Bip01_R_Finger0'] = {
					RU = 8.0387323482629,
					RR = 3.0871416516769,
					RF = -13.726701540944
				}
			},
			FrameRate = 1
		}
	},
	ShouldPlay = function(pl, sGestureName, tGestureTable, iCurFrame, tFrameData)
		local wep = IsValid(pl:GetActiveWeapon()) and pl:GetActiveWeapon()
		
		if pl:IsWallrunning() then
			return false
		end
		
		if pl:IsRolling() then
			return false
		end
		
		if pl:IsSliding() then
			return false
		end
				
		if pl:IsSprinting() then
			return false
		end
		
		if !pl:Alive() then
			return false
		end
		
		if wep and !wep.IsMelee then
			return false
		end
		
		return true
	end,
	Type = TYPE_POSTURE
})


/*RegisterLuaAnimation('melee_block', {
	FrameData = {
		{
			BoneInfo = {
				['ValveBiped.Bip01_Spine2'] = {
					RU = -5.7340510235554,
					RF = -10.226772762414
				},
				['ValveBiped.Bip01_L_Clavicle'] = {
					RU = -31.738438393088,
					RR = -7.0240865127609,
					RF = -37.108412108579
				},
				['ValveBiped.Bip01_L_Forearm'] = {
					RU = 20.727464491322,
					RR = -9.3466894062965,
					RF = 33.994404710983
				},
				['ValveBiped.Bip01_R_UpperArm'] = {
					RU = 2.0943097958618,
					RR = 38.163714057126,
					RF = -18.584123547523
				},
				['ValveBiped.Bip01_L_Hand'] = {
					RU = 54.325530154007,
					RR = 4.8127955643584,
					RF = -16.021912431484
				},
				['ValveBiped.Bip01_L_UpperArm'] = {
					RU = -31.663556365361,
					RR = -14.559716223098,
					RF = 55.841764581884
				},
				['ValveBiped.Bip01_Spine4'] = {
					RU = 8,
					RF = -3.8306214273718
				},
				['ValveBiped.Bip01_R_Forearm'] = {
					RU = 1.0118546463376,
					RR = -1.0065727096195,
					RF = 23.96788695199
				},
				['ValveBiped.Bip01_R_Clavicle'] = {
					RU = -7,
					RR = 17.291796067501,
					RF = 37.95492536376
				},
				['ValveBiped.Bip01_R_Hand'] = {
					RU = 17.265505229023,
					RR = -35.64488323792,
					RF = -14.812559200041
				}
			},
			FrameRate = 8
		}
	},
	Type = TYPE_POSTURE
})*/

RegisterLuaAnimation('melee_block_bullet', {
	FrameData = {
		/*{
			BoneInfo = {
				['ValveBiped.Bip01_R_UpperArm'] = {
					RU = -14.158474164993,
					RR = 38.163714057126,
					RF = -32.245287691479
				},
				['ValveBiped.Bip01_R_Hand'] = {
					RU = 17.265505229023,
					RR = -35.994601698047,
					RF = -14.812559200041
				},
				['ValveBiped.Bip01_L_Forearm'] = {
					RU = 57.828427124746,
					RR = -28.717016379131,
					RF = -36.529483435807
				},
				['ValveBiped.Bip01_L_Hand'] = {
					RU = 0.0092952150854315,
					RR = -26.773227237586,
					RF = -16.021912431484
				},
				['ValveBiped.Bip01_L_UpperArm'] = {
					RU = -22.343145750508,
					RR = 25.006572709619,
					RF = 34.08640753373
				},
				['ValveBiped.Bip01_R_Forearm'] = {
					RU = -4.8284271247462,
					RR = -1.0065727096195,
					RF = 23.96788695199
				}
			},
			FrameRate = 8
		},*/
		{
			BoneInfo = {
				['ValveBiped.Bip01_R_UpperArm'] = {
					RU = -29.100551772367,
					RR = 24.875788981552,
					RF = 5.3966132622495
				},
				['ValveBiped.Bip01_R_Forearm'] = {
					RU = -4.8284271247462,
					RR = -1.0065727096195,
					RF = 23.96788695199
				},
				['ValveBiped.Bip01_L_UpperArm'] = {
					RU = -49.03815755479,
					RR = 14.592359147246,
					RF = 28.429553284238
				},
				['ValveBiped.Bip01_R_Hand'] = {
					RU = 17.265505229023,
					RR = -35.994601698047,
					RF = -14.812559200041
				},
				['ValveBiped.Bip01_L_Forearm'] = {
					RU = 57.828427124746,
					RR = -28.717016379131,
					RF = -36.529483435807
				},
				['ValveBiped.Bip01_L_Hand'] = {
					RU = 0.0092952150854315,
					RR = -26.773227237586,
					RF = -16.021912431484
				}
			},
			FrameRate = 5
		},
	
	},
	//ShouldPlay = function(pl, sGestureName, tGestureTable, iCurFrame, tFrameData)
	//	return pl:IsDefending()
	//end,
	Type = TYPE_GESTURE
})

RegisterLuaAnimation('cast_melee2', {
	FrameData = {
		{
			BoneInfo = {
				['ValveBiped.Bip01_L_UpperArm'] = {
				},
				['ValveBiped.Bip01_L_Clavicle'] = {
				},
				['ValveBiped.Bip01_L_Hand'] = {
				},
				['ValveBiped.Bip01_L_Forearm'] = {
				}
			},
			FrameRate = 5
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_L_UpperArm'] = {
					RU = -1.2273009652547,
					RR = -29.387876014917,
					RF = -28.640986324787
				},
				['ValveBiped.Bip01_L_Clavicle'] = {
					RU = 5,
					RR = 30.398345637668,
					RF = 12.790316278935
				},
				['ValveBiped.Bip01_L_Hand'] = {
					RU = -3.6093979711507,
					RR = -73,
					RF = 48.211255338696
				},
				['ValveBiped.Bip01_L_Forearm'] = {
					RU = 44.414213562373,
					RR = -3.4142135623731,
					RF = 24
				}
			},
			FrameRate = 9
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_L_UpperArm'] = {
					RU = -1.2273009652547,
					RR = -29.387876014917,
					RF = -28.640986324787
				},
				['ValveBiped.Bip01_L_Clavicle'] = {
					RU = 5,
					RR = 30.398345637668,
					RF = 12.790316278935
				},
				['ValveBiped.Bip01_L_Forearm'] = {
					RU = 44.414213562373,
					RR = -3.4142135623731,
					RF = 24
				},
				['ValveBiped.Bip01_L_Hand'] = {
					RU = -3.6093979711507,
					RR = -73,
					RF = 48.211255338696
				}
			},
			FrameRate = 5
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_L_UpperArm'] = {
				},
				['ValveBiped.Bip01_L_Clavicle'] = {
				},
				['ValveBiped.Bip01_L_Forearm'] = {
				},
				['ValveBiped.Bip01_L_Hand'] = {
				}
			},
			FrameRate = 5
		}
	},
	Type = TYPE_GESTURE
})

RegisterLuaAnimation('wallrun_left', {
	FrameData = {
		{
			BoneInfo = {
				['ValveBiped.Bip01_Pelvis'] = {
					RU = 28.3731,
					RF = 10.4142
				},
				['ValveBiped.Bip01_Spine1'] = {
					RU = -12.9767,
					RR = -28.0433,
					RF = -4.637
				},
				['ValveBiped.Bip01_Spine'] = {
					RR = -8.6952
				}
			},
			FrameRate = 1
		}
	},
	ShouldPlay = function(pl, sGestureName, tGestureTable, iCurFrame, tFrameData)
		if IsValid(pl) then
			pl.RollLeft = CurTime() + 0.05
		end
		return IsValid(pl) and IsValid(pl._efWallRun) and pl._efWallRun.IsActive and pl._efWallRun:IsActive() == true
	end,
	Type = TYPE_POSTURE
})

RegisterLuaAnimation('wallrun_right', {
	FrameData = {
		{
			BoneInfo = {
				['ValveBiped.Bip01_Pelvis'] = {
					RU = -27.867738930699,
					RF = -9.7458
				},
				['ValveBiped.Bip01_Spine1'] = {
					RU = 3.5198681952272,
					RR = 27.921697633329,
					RF = 4.93421672498
				},
				['ValveBiped.Bip01_Spine'] = {
					RR = -5.3540520520277
				}
			},
			FrameRate = 1
		}
	},
	ShouldPlay = function(pl, sGestureName, tGestureTable, iCurFrame, tFrameData)
		if IsValid(pl) then
			pl.RollRight = CurTime() + 0.05
		end
		return IsValid(pl) and IsValid(pl._efWallRun) and pl._efWallRun.IsActive and pl._efWallRun:IsActive() == true
	end,
	Type = TYPE_POSTURE
})

/* EXAMPLES!

-- If your animation is only used on one model, use numbers instead of bone names (cache the lookup).
-- If it's being used on a wide array of models (including default player models) then you should use bone names.
-- You can use Callback as a function instead of MU, RR, etc. which will allow you to do some interesting things.
-- See cl_boneanimlib.lua for the full format.

STANCE: stancetest
A simple looping stance that stretches the model's spine up and down until stopped.

RegisterLuaAnimation("stancetest", {
	FrameData = {
		{
			BoneInfo = {
				["ValveBiped.Bip01_Spine"] = {
					MU = 64
				}
			},
			FrameRate = 0.25
		},
		{
			BoneInfo = {
				["ValveBiped.Bip01_Spine"] = {
					MU = -32
				}
			},
			FrameRate = 1.5
		},
		{
			BoneInfo = {
				["ValveBiped.Bip01_Spine"] = {
					MU = 32
				}
			},
			FrameRate = 4
		}
	},
	RestartFrame = 2,
	Type = TYPE_STANCE
})

--[[
STANCE: staffholdspell
To be used with the ACT_HL2MP_IDLE_MELEE2 animation.
Player holds the staff so that their left hand is over the top of it.
]]

RegisterLuaAnimation("staffholdspell", {
	FrameData = {
		{
			BoneInfo = {
				["ValveBiped.Bip01_R_Forearm"] = {
					RU = 40,
					RF = -40
				},
				["ValveBiped.Bip01_R_Upperarm"] = {
					RU = 40
				},
				["ValveBiped.Bip01_R_Hand"] = {
					RU = -40
				},
				["ValveBiped.Bip01_L_Forearm"] = {
					RU = 40
				},
				["ValveBiped.Bip01_L_Hand"] = {
					RU = -40
				}
			},
			FrameRate = 6
		},
		{
			BoneInfo = {
				["ValveBiped.Bip01_R_Forearm"] = {
					RU = 2,
				},
				["ValveBiped.Bip01_R_Upperarm"] = {
					RU = 1
				},
				["ValveBiped.Bip01_R_Hand"] = {
					RU = -10
				},
				["ValveBiped.Bip01_L_Forearm"] = {
					RU = 8
				},
				["ValveBiped.Bip01_L_Hand"] = {
					RU = -12
				}
			},
			FrameRate = 0.4
		},
		{
			BoneInfo = {
				["ValveBiped.Bip01_R_Forearm"] = {
					RU = -2,
				},
				["ValveBiped.Bip01_R_Upperarm"] = {
					RU = -1
				},
				["ValveBiped.Bip01_R_Hand"] = {
					RU = 10
				},
				["ValveBiped.Bip01_L_Forearm"] = {
					RU = -8
				},
				["ValveBiped.Bip01_L_Hand"] = {
					RU = 12
				}
			},
			FrameRate = 0.1
		}
	},
	RestartFrame = 2,
	Type = TYPE_STANCE,
	ShouldPlay = function(pl, sGestureName, tGestureTable, iCurFrame, tFrameData)
		local wepstatus = pl.WeaponStatus
		return wepstatus and wepstatus:IsValid() and wepstatus:GetSkin() == 1 and wepstatus.IsStaff
	end
})

*/
