library EffectLib

	function PlayEffectOnUnit takes unit whichUnit, string attachPoint, string effectPath returns nothing
		call DestroyEffect(AddSpecialEffectTarget(effectPath, whichUnit, attachPoint))

	endfunction
	
	function PlayEffectOnPosition takes unit whichUnit, string effectPath, integer animMode returns nothing
		local effect eff = AddSpecialEffect(effectPath, GetUnitX(whichUnit), GetUnitY(whichUnit))
        
		if animMode == 0 then
			call BlzPlaySpecialEffect(eff, ANIM_TYPE_STAND)
                
        elseif animMode == 1 then
            call BlzPlaySpecialEffect(eff, ANIM_TYPE_BIRTH)
            
        elseif animMode == 2 then
            call BlzPlaySpecialEffect(eff, ANIM_TYPE_DEATH)
                
        endif
        call DestroyEffect(eff)

	endfunction

endlibrary