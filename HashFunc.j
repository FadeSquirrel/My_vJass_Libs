library HashLib
	
	globals
        
        key k_caster
        key k_target
        key k_timer
        key k_id
        
        key k_x
        key k_y
        key k_newX
        key k_newY
        key k_baseX
        key k_baseY
        key k_casterX
        key k_casterY
        key k_targetX
        key k_targetY
        key k_angle
        key k_newAngle
        key k_distance
        key k_newDistance
        key k_speed
        key k_newSpeed
        
        key k_duration
		key k_accumulatedDuration
        key k_time
        key k_expiredTime
        
        key k_group
        key k_tempGroup
        key k_targetGroup
        key k_enemyGroup
        key k_allyGroup
        
        key k_heal
        key k_damage
        key k_aoe
        key k_radius
        key k_range
        key k_AT
        key k_attackType
        key k_DT
        key k_damageType
        
        key k_effect
        key k_casterEffect
        key k_targetEffect
        key k_effectPath
        key k_attachPoint
        
        key k_bool
        key k_cond
        
        key k_count
        key k_i
        key k_j
        key k_ij

    endglobals
	
	function SwitchBool takes hashtable hash, integer parentKey, integer childKey returns nothing
		call SaveBoolean(hash, parentKey, childKey, not LoadBoolean(hash, parentKey, childKey))
			
	endfunction
	
    function SU takes hashtable hash, integer parentKey, integer childKey, unit u returns nothing
        call SaveUnitHandle(hash, parentKey, childKey, u)
    endfunction

    function SG takes hashtable hash, integer parentKey, integer childKey, group g returns nothing
        call SaveGroupHandle(hash, parentKey, childKey, g)
    endfunction

    function SI takes hashtable hash,integer parentKey, integer childKey, integer i returns nothing
        call SaveInteger(hash, parentKey, childKey, i)
    endfunction

    function SS takes hashtable hash, integer parentKey, integer childKey, string s returns nothing
        call SaveStr(hash, parentKey, childKey, s)
    endfunction

    function SE takes hashtable hash, integer parentKey, integer childKey, effect e returns nothing
        call SaveEffectHandle(hash, parentKey, childKey, e)
    endfunction

    function SR takes hashtable hash, integer parentKey, integer childKey, real r returns nothing
        call SaveReal(hash, parentKey, childKey, r)
    endfunction

    function SB takes hashtable hash,integer parentKey, integer childKey, boolean b returns nothing
        call SaveBoolean(hash, parentKey, childKey, b)
    endfunction

    function ST takes hashtable hash, integer parentKey, integer childKey, timer t returns nothing
        call SaveTimerHandle(hash, parentKey, childKey, t)
    endfunction

    function STrig takes hashtable hash, integer parentKey, integer childKey, trigger t returns nothing
        call SaveTriggerHandle(hash, parentKey, childKey, t)
    endfunction

    function SD takes hashtable hash, integer parentKey, integer childKey, dialog d returns nothing
        call SaveDialogHandle(hash, parentKey, childKey, d)
    endfunction

    function SButt takes hashtable hash, integer parentKey, integer childKey, button b returns nothing
        call SaveButtonHandle(hash, parentKey, childKey, b)
    endfunction

    function SL takes hashtable hash, integer parentKey, integer childKey, lightning l returns nothing
        call SaveLightningHandle(hash, parentKey, childKey, l)
    endfunction

    function LL takes hashtable hash, integer parentKey, integer childKey returns lightning
        return LoadLightningHandle(hash, parentKey, childKey)
    endfunction

    function LU takes hashtable hash, integer parentKey, integer childKey returns unit
        return LoadUnitHandle(hash, parentKey, childKey)
    endfunction

    function LG takes hashtable hash, integer parentKey, integer childKey returns group
        return LoadGroupHandle(hash, parentKey, childKey)
    endfunction

    function LI takes hashtable hash, integer parentKey, integer childKey returns integer
        return LoadInteger(hash, parentKey, childKey)
    endfunction

    function LS takes hashtable hash, integer parentKey, integer childKey returns string
        return LoadStr(hash, parentKey, childKey)
    endfunction

    function LE takes hashtable hash, integer parentKey, integer childKey returns effect
        return LoadEffectHandle(hash, parentKey, childKey)
    endfunction

    function LR takes hashtable hash, integer parentKey, integer childKey returns real
        return LoadReal(hash, parentKey, childKey)
    endfunction

    function LB takes hashtable hash, integer parentKey, integer childKey returns boolean
        return LoadBoolean(hash, parentKey, childKey)
    endfunction

    function LT takes hashtable hash, integer parentKey, integer childKey returns timer
        return LoadTimerHandle(hash, parentKey, childKey)
    endfunction

    function LTrig takes hashtable hash, integer parentKey, integer childKey returns trigger
        return LoadTriggerHandle(hash, parentKey, childKey)
    endfunction

    function LD takes hashtable hash, integer parentKey, integer childKey returns dialog
        return LoadDialogHandle(hash, parentKey, childKey)
    endfunction

    function LButt takes hashtable hash, integer parentKey, integer childKey returns button
        return LoadButtonHandle(hash, parentKey, childKey)
    endfunction
	
	
	globals
		
		key k_AT_CHAOS
		key k_AT_MELEE
		key k_AT_HERO
		key k_AT_NORMAL
		key k_AT_MAGIC
		key k_AT_SIEGE
		
	endglobals
	
    function LAT takes hashtable hash, integer  parentKey, integer childKey returns attacktype
        local integer attackTypeId = LoadInteger(hash,  parentKey, childKey)
        if attackTypeId == k_AT_CHAOS then
            return ATTACK_TYPE_CHAOS
        elseif attackTypeId == k_AT_MELEE then
            return ATTACK_TYPE_MELEE
        elseif attackTypeId == k_AT_HERO then
            return ATTACK_TYPE_HERO
        elseif attackTypeId == k_AT_NORMAL then
            return ATTACK_TYPE_NORMAL
        elseif attackTypeId == k_AT_MAGIC then
            return ATTACK_TYPE_MAGIC
        elseif attackTypeId == k_AT_SIEGE then
            return ATTACK_TYPE_SIEGE
        endif
        return null
    endfunction

    function SAT takes hashtable hash, integer  parentKey, integer childKey, attacktype attackType returns nothing
        local integer attackTypeId = k_AT_CHAOS
        
        if attackType == ATTACK_TYPE_CHAOS then
            set attackTypeId = k_AT_CHAOS
        elseif attackType == ATTACK_TYPE_MELEE then
            set attackTypeId = k_AT_MELEE
        elseif attackType == ATTACK_TYPE_HERO then
            set attackTypeId = k_AT_HERO
        elseif attackType == ATTACK_TYPE_NORMAL then
            set attackTypeId = k_AT_NORMAL
        elseif attackType == ATTACK_TYPE_MAGIC then
            set attackTypeId = k_AT_MAGIC
        elseif attackType == ATTACK_TYPE_SIEGE then
            set attackTypeId = k_AT_SIEGE
        endif
        call SaveInteger(hash,  parentKey, childKey, attackTypeId)
    endfunction

	globals
		
		key k_DT_UNIVERSAL
		key k_DT_NORMAL
		key k_DT_MAGIC
		key k_DT_UNKNOWN
		
	endglobals
	
    function LDT takes hashtable hash, integer  parentKey, integer childKey returns damagetype
        local integer attackTypeId = LoadInteger(hash,  parentKey, childKey)
        if attackTypeId == k_DT_UNIVERSAL then
            return DAMAGE_TYPE_UNIVERSAL
        elseif attackTypeId == k_DT_NORMAL then
            return DAMAGE_TYPE_NORMAL
        elseif attackTypeId == k_DT_MAGIC then
            return DAMAGE_TYPE_MAGIC
        elseif attackTypeId == k_DT_UNKNOWN then
            return DAMAGE_TYPE_UNKNOWN
        endif
        return null
    endfunction

    function SDT takes hashtable hash, integer  parentKey, integer childKey, damagetype attackType returns nothing
        local integer attackTypeId = 0
        
        if attackType == DAMAGE_TYPE_UNIVERSAL then
            set attackTypeId = k_DT_UNIVERSAL
        elseif attackType == DAMAGE_TYPE_NORMAL then
            set attackTypeId = k_DT_NORMAL
        elseif attackType == DAMAGE_TYPE_MAGIC then
            set attackTypeId = k_DT_MAGIC
        elseif attackType == DAMAGE_TYPE_UNIVERSAL then
            set attackTypeId = k_DT_UNKNOWN
        endif
        call SaveInteger(hash,  parentKey, childKey, attackTypeId)
    endfunction
	
	function SU_SH takes hashtable hash, integer parentKey, string str, unit u returns nothing
        call SaveUnitHandle(hash, parentKey, StringHash(str), u)
    endfunction

    function SG_SH takes hashtable hash, integer parentKey, string str, group g returns nothing
        call SaveGroupHandle(hash, parentKey, StringHash(str), g)
    endfunction

    function SI_SH takes hashtable hash,integer parentKey, string str, integer i returns nothing
        call SaveInteger(hash, parentKey, StringHash(str), i)
    endfunction

    function SS_SH takes hashtable hash, integer parentKey, string str, string s returns nothing
        call SaveStr(hash, parentKey, StringHash(str), s)
    endfunction

    function SE_SH takes hashtable hash, integer parentKey, string str, effect e returns nothing
        call SaveEffectHandle(hash, parentKey, StringHash(str), e)
    endfunction

    function SR_SH takes hashtable hash, integer parentKey, string str, real r returns nothing
        call SaveReal(hash, parentKey, StringHash(str), r)
    endfunction

    function SB_SH takes hashtable hash,integer parentKey, string str, boolean b returns nothing
        call SaveBoolean(hash, parentKey, StringHash(str), b)
    endfunction

    function ST_SH takes hashtable hash, integer parentKey, string str, timer t returns nothing
        call SaveTimerHandle(hash, parentKey, StringHash(str), t)
    endfunction

    function STrig_SH takes hashtable hash, integer parentKey, string str, trigger t returns nothing
        call SaveTriggerHandle(hash, parentKey, StringHash(str), t)
    endfunction

    function SD_SH takes hashtable hash, integer parentKey, string str, dialog d returns nothing
        call SaveDialogHandle(hash, parentKey, StringHash(str), d)
    endfunction

    function SButt_SH takes hashtable hash, integer parentKey, string str, button b returns nothing
        call SaveButtonHandle(hash, parentKey, StringHash(str), b)
    endfunction

    function SL_SH takes hashtable hash, integer parentKey, string str, lightning l returns nothing
        call SaveLightningHandle(hash, parentKey, StringHash(str), l)
    endfunction

    function LL_SH takes hashtable hash, integer parentKey, string str returns lightning
        return LoadLightningHandle(hash, parentKey, StringHash(str))
    endfunction

    function LU_SH takes hashtable hash, integer parentKey, string str returns unit
        return LoadUnitHandle(hash, parentKey, StringHash(str))
    endfunction

    function LG_SH takes hashtable hash, integer parentKey, string str returns group
        return LoadGroupHandle(hash, parentKey, StringHash(str))
    endfunction

    function LI_SH takes hashtable hash, integer parentKey, string str returns integer
        return LoadInteger(hash, parentKey, StringHash(str))
    endfunction

    function LS_SH takes hashtable hash, integer parentKey, string str returns string
        return LoadStr(hash, parentKey, StringHash(str))
    endfunction

    function LE_SH takes hashtable hash, integer parentKey, string str returns effect
        return LoadEffectHandle(hash, parentKey, StringHash(str))
    endfunction

    function LR_SH takes hashtable hash, integer parentKey, string str returns real
        return LoadReal(hash, parentKey, StringHash(str))
    endfunction

    function LB_SH takes hashtable hash, integer parentKey, string str returns boolean
        return LoadBoolean(hash, parentKey, StringHash(str))
    endfunction

    function LT_SH takes hashtable hash, integer parentKey, string str returns timer
        return LoadTimerHandle(hash, parentKey, StringHash(str))
    endfunction

    function LTrig_SH takes hashtable hash, integer parentKey, string str returns trigger
        return LoadTriggerHandle(hash, parentKey, StringHash(str))
    endfunction

    function LD_SH takes hashtable hash, integer parentKey, string str returns dialog
        return LoadDialogHandle(hash, parentKey, StringHash(str))
    endfunction

    function LButt_SH takes hashtable hash, integer parentKey, string str returns button
        return LoadButtonHandle(hash, parentKey, StringHash(str))
    endfunction
	
endlibrary