function EFFECT:Init( data )

	
	
	local wep = data:GetEntity()
	
	if !IsValid(wep) then return end
		
	local ent = wep:GetOwner() == MySelf and not GAMEMODE.ThirdPerson and MySelf:GetViewModel() or wep
	
	//local start = ent.GetActiveWeapon and IsValid(ent:GetActiveWeapon()) and ent:GetActiveWeapon():GetAttachment(1) and ent:GetActiveWeapon():GetAttachment(1).Pos or ent:GetShootPos()
	local endpos = data:GetOrigin()
	
	local att = ent:GetAttachment(1)
	
	//local vm = ent:GetViewModel()
	//local att = IsValid(vm) and vm:LookupAttachment( 1 ) or 1
	
	local tracer = "dd_tracer"
	
	if data:GetScale() and math.Round(data:GetScale()) == 1 then
		tracer = "dd_tracer_cursed"
	end
	
	if att and att.Pos then
		//util.ParticleTracer( tracer, att.Pos, endpos, true ) 
		util.ParticleTracerEx( tracer, att.Pos,endpos, true, self:EntIndex(), 1 )
	end
	
	//if LocalPlayer() == ent and not GAMEMODE.ThirdPerson then //temp fix
	
		//util.ParticleTracer( tracer, start, endpos, true ) 
		//util.ParticleTracerEx( tracer, start,endpos, true, ent:GetActiveWeapon():EntIndex(), att  )
	
	//end
	
	
end

function EFFECT:Think( )
	//return !self.finish
end

function EFFECT:Render( )
	
	/*if not self.finish then
		util.ParticleTracerEx( "dd_tracer", self.wep:GetAttachment(1).Pos,self.endpos, true, self.wep:EntIndex(), 1  )
		self.finish = true
	end*/
	
end
