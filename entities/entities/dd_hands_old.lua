//Because I can
AddCSLuaFile()

ENT.Type			= "anim"
ENT.RenderGroup		= RENDERGROUP_OTHER


function ENT:Initialize()
	
	hook.Add( "OnViewModelChanged", self, self.ViewModelChanged )

	self:SetNotSolid( true )
	self:DrawShadow( false )
	self:SetTransmitWithParent( true ) -- Transmit only when the viewmodel does!
	
end

function ENT:DoSetup( ply )

	-- Set these hands to the player
	ply:SetHands( self )
	self:SetOwner( ply )

	-- Which hands should we use?
	/*local info = ply:GetHandsModel()
	if ( info ) then
		self:SetModel( info.model )
		self:SetSkin( info.skin )
		self:SetBodyGroups( info.body )
	end*/
	
	self:SetModel( ply:GetModel() )

	-- Attach them to the viewmodel
	local vm = ply:GetViewModel( 0 )
	self:AttachToViewmodel( vm )

	vm:DeleteOnRemove( self )
	ply:DeleteOnRemove( self )

end

function ENT:GetPlayerColor()
	
	--
	-- Make sure there's an owner and they have this function
	-- before trying to call it!
	--
	local owner = self:GetOwner()
	if ( !IsValid( owner ) ) then return Vector(1,1,1) end
	if ( !owner.GetPlayerColor ) then return Vector(1,1,1) end
	
	return owner:GetPlayerColor()

end

function ENT:ViewModelChanged( vm, old, new )

	-- Ignore other peoples viewmodel changes!
	if ( vm:GetOwner() != self:GetOwner() ) then return end

	self:AttachToViewmodel( vm )

end

local bones ={
	"ValveBiped.Bip01_Pelvis",
	"ValveBiped.Bip01_Spine",
	"ValveBiped.Bip01_Spine1",
	"ValveBiped.Bip01_Spine2",
	"ValveBiped.Bip01_Spine4",
	"ValveBiped.Bip01_Neck1",
	"ValveBiped.Bip01_Head1",
	"ValveBiped.Bip01_R_Thigh",
	"ValveBiped.Bip01_R_Calf",
	"ValveBiped.Bip01_R_Foot",
	"ValveBiped.Bip01_R_Toe0",
	"ValveBiped.Bip01_L_Thigh",
	"ValveBiped.Bip01_L_Calf",
	"ValveBiped.Bip01_L_Foot",
	"ValveBiped.Bip01_L_Toe0",
	"ValveBiped.Bip01_Hair1",
	"ValveBiped.Bip01_Hair2",
	"ValveBiped.Bip01_Neck1"
}

local ToMerge = {
	["ValveBiped.Bip01_L_Forearm"] = "Bone02",
	["ValveBiped.Bip01_L_Hand"] = "Bone03",
}


function ENT:AttachToViewmodel( vm )
	
	self:AddEffects( EF_BONEMERGE )
	self:SetParent( vm )
	self:SetMoveType( MOVETYPE_NONE )
	
	for i = 0, self:GetBoneCount() - 1 do
		local name = self:GetBoneName(i)
		//print(name)
		local bone = self:LookupBone(name)
		if not table.HasValue(bones,name) then continue end
		//if bone then
			/*if name == "ValveBiped.Bip01_Head1" or name == "ValveBiped.Bip01_Hair1" or name == "ValveBiped.Bip01_Hair2" then
				self:ManipulateBonePosition( bone, vm:GetAngles():Forward() * 40 )
				self:ManipulateBonePosition( bone, vm:GetAngles():Forward() * 40 )
				self:ManipulateBonePosition( bone, vm:GetAngles():Forward() * 40 )
			end*/
			self:ManipulateBoneScale( i, Vector(0, 0, 0) )
			self:ManipulateBoneScale( i, Vector(0, 0, 0) )
			self:ManipulateBoneScale( i, Vector(0, 0, 0) )
		//end
	end
	
	self:SetPos( Vector( 0, 0, 0 ) )
	self:SetAngles( Angle( 0, 0, 0 ) )

end
