library UnitLib requires MathLib
	
	function IsUnitAlive takes unit whichUnit returns boolean
		return GetWidgetLife(whichUnit) > 0.405 and not IsUnitType(whichUnit, UNIT_TYPE_DEAD)

	endfunction
	
	function Heal takes unit whichUnit, real amount returns boolean
		if whichUnit != null then
			call SetUnitState(whichUnit, UNIT_STATE_LIFE, GetUnitState(whichUnit, UNIT_STATE_LIFE) + amount)
			return true
		endif
		return false

	endfunction
	
	function ResetAbilityCooldown takes unit whichUnit, integer abilityId returns nothing
		local integer level = GetUnitAbilityLevel(whichUnit, abilityId)
		
		call UnitRemoveAbility(whichUnit, abilityId)
		call UnitAddAbility(whichUnit, abilityId)
		call SetUnitAbilityLevel(whichUnit, abilityId, level)
		
	endfunction

endlibrary