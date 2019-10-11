function EFFECT:Init( data )

	local wep = data:GetEntity()
	local att = data:GetAttachment()
	
	if !IsValid(wep) then return end
		
	local ent = wep:GetOwner() == MySelf and not GAMEMODE.ThirdPerson and MySelf:GetViewModel() or wep
	local endpos = data:GetOrigin()
	
	//local att = ent:GetAttachment( 1 )
	
	if not att then return end
	
	local att_pos = self:GetTracerShootPos(wep:GetPos(), ent, att)//att.Pos
	
	if ent and ent == MySelf:GetViewModel() and wep.GetTracerOrigin then
		att_pos = wep:GetTracerOrigin()
	end
	
	local tracer = "dd_tracer"
	
	if data:GetScale() and math.Round(data:GetScale()) == 1 then
		tracer = "dd_tracer_cursed"
	end
	
	if att and att_pos then
		util.ParticleTracerEx( tracer, att_pos, endpos, true, self:EntIndex(), att )
	end
	
end

function EFFECT:Think( )
end

function EFFECT:Render( )
end
