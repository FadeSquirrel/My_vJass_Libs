library GroupLib requires UnitLib, DamageLib
    
    globals
        
		private group LastGroup
        private unit array UnitList
        private integer UnitListMax
		
		private unit Source
		private real Damage
		private attacktype AttackType
		private damagetype DamageType
		private integer DamageCategory
		private string AttachPoint
		private string EffectPath
		
		private player TriggerPlayer
		private boolean IsAlive = false
		private boolean IsEnemy = false
		private boolean IsStructure = false
		private boolean IsHero = false
		private boolean IsMagicImmune = false
		private boolean IsPaused = false
        
    endglobals
	
	function DestroyLastGroup takes nothing returns nothing
        call DestroyGroup(LastGroup)
		
    endfunction
	
	function SetMatchSettings takes boolean isAlive, boolean isEnemy, boolean isMagicImmune, boolean isHero, boolean isStructure, boolean isPaused returns nothing
        set IsAlive = isAlive
		set IsEnemy = isEnemy
		set IsStructure = isStructure
		set IsHero = isHero
		set IsMagicImmune = isMagicImmune
		set IsPaused = isPaused
        
    endfunction
	
	private function GroupFilter takes nothing returns boolean
        return IsUnitEnemy(GetFilterUnit(), TriggerPlayer) and not IsUnitType(GetFilterUnit(), UNIT_TYPE_DEAD) and not IsUnitType(GetFilterUnit(), UNIT_TYPE_MAGIC_IMMUNE) and not IsUnitType(GetFilterUnit(), UNIT_TYPE_STRUCTURE)
        
    endfunction
	
	private function GroupFilterWithSettings takes nothing returns boolean
        return (not IsAlive or not IsUnitType(GetFilterUnit(), UNIT_TYPE_DEAD)) and (not IsEnemy or IsUnitEnemy(GetFilterUnit(), TriggerPlayer)) and (not IsPaused or IsUnitPaused(GetFilterUnit())) and (not IsHero or IsUnitType(GetFilterUnit(), UNIT_TYPE_HERO)) and (not IsMagicImmune or IsUnitType(GetFilterUnit(), UNIT_TYPE_MAGIC_IMMUNE)) and (not IsStructure or IsUnitType(GetFilterUnit(), UNIT_TYPE_STRUCTURE)) 
        
    endfunction
	
	function GetGroupBoolexr takes nothing returns boolexpr
        return Condition(function GroupFilterWithSettings)
        
    endfunction
	
	function GroupEnumFilterUnitsInRange takes player whichPlayer, real x, real y, real radius, boolean specialSettings returns group
		local boolexpr bexpr
		
		set TriggerPlayer = whichPlayer
		set LastGroup = CreateGroup()
		
		if specialSettings then
			set bexpr = GetGroupBoolexr()
			
		else
			set bexpr = Condition(function GroupFilter)
			
		endif
		
		call GroupEnumUnitsInRange(LastGroup, x, y, radius, bexpr)
		call DestroyBoolExpr(bexpr)
		
		return LastGroup
	
	endfunction
    
    function CopyGroup takes group g returns group
        set bj_groupAddGroupDest = CreateGroup()
        call ForGroup(bj_groupAddGroupDest, function GroupAddGroupEnum)
        return bj_groupAddGroupDest
        
    endfunction
    
    private function AddUnitsToList takes nothing returns nothing
        set UnitListMax = UnitListMax + 1
        set UnitList[UnitListMax] = GetEnumUnit()
        
    endfunction
    
	//Альтернативный вариант bj-функции GroupPickRandomUnit 
    function GetRandomUnit takes group whichGroup returns unit
        set UnitListMax = 0
        call ForGroup(whichGroup, function AddUnitsToList)
        
        if UnitListMax == 0 then
            return null
            
        else
            return UnitList[GetRandomInt(1, UnitListMax)]
            
        endif
        
    endfunction
	
	//only for wc3 reforged
	function BlzGetRandomUnit takes group whichGroup returns unit
        return BlzGroupUnitAt(whichGroup, GetRandomInt(1, BlzGroupGetSize(whichGroup)))
        
    endfunction
    
    private function DamageUnits takes nothing returns nothing
		call DamageTo(Source, GetEnumUnit(), Damage, AttackType, DamageType, DamageCategory)
		
    endfunction
    
    function UnitDamageGroup takes unit whichUnit, group whichGroup, real amount, attacktype AT, damagetype DT, integer damageCategory returns nothing
        set Source = whichUnit
		set Damage = amount
		set AttackType = AT
		set DamageType = DT
		set DamageCategory = damageCategory
        call ForGroup(whichGroup, function DamageUnits)
        
    endfunction
	
	private function PlayEffectOnUnits takes nothing returns nothing
		call DestroyEffect(AddSpecialEffectTarget(EffectPath, GetEnumUnit(), AttachPoint))
    endfunction
    
    function PlayEffectOnGroup takes group whichGroup, string attachPoint, string effectPath returns nothing
        set AttachPoint = attachPoint
		set EffectPath = effectPath
        call ForGroup(whichGroup, function PlayEffectOnUnits)
        
    endfunction
	
	private function DamageAndPlayEffectOnUnits takes nothing returns nothing
		call DamageTo(Source, GetEnumUnit(), Damage, AttackType, DamageType, DamageCategory)
		call DestroyEffect(AddSpecialEffectTarget(EffectPath, GetEnumUnit(), AttachPoint))
    endfunction
	
	function DamageAndPlayEffectOnGroup takes unit whichUnit, group whichGroup, real amount, attacktype AT, damagetype DT, integer damageCategory, string attachPoint, string effectPath returns nothing
        set Source = whichUnit
		set Damage = amount
		set AttackType = AT
		set DamageType = DT
		set DamageCategory = damageCategory
		set AttachPoint = attachPoint
		set EffectPath = effectPath
        call ForGroup(whichGroup, function DamageAndPlayEffectOnUnits)
        
    endfunction
    
endlibrary