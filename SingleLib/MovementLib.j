library MovementLib
    
    globals
        
        private location DynamicLocation = Location(0, 0)
        
    endglobals
	
	function IsCorInRect takes real x, real y, rect r returns boolean
		return (GetRectMinX(r) <= x) and (x <= GetRectMaxX(r)) and (GetRectMinY(r) <= y) and (y <= GetRectMaxY(r))
		
	endfunction
	
	function GetUnitPathingType takes unit whichUnit returns pathingtype
		if IsUnitType(whichUnit, UNIT_TYPE_GROUND) then
			return PATHING_TYPE_WALKABILITY
			
		elseif IsUnitType(whichUnit, UNIT_TYPE_FLYING) then
			return PATHING_TYPE_FLYABILITY
			
		endif
		return null
		
	endfunction
	
	function IsCorPathable takes real x, real y, pathingtype pathingType returns boolean
		return not IsTerrainPathable(x, y, pathingType)
		
	endfunction
	
	function GetLocZ takes real x, real y returns real 
		call MoveLocation(DynamicLocation, x, y)
		return GetLocationZ(DynamicLocation)
		
	endfunction
	
	function GetUnitZ takes unit whichUnit returns real 
		return GetUnitFlyHeight(whichUnit) + GetLocZ(GetUnitX(whichUnit), GetUnitX(whichUnit))
		
	endfunction
	
	function SetUnitZ takes unit whichUnit, real z returns nothing 
		call SetUnitFlyHeight(whichUnit, z - GetLocZ(GetUnitX(whichUnit), GetUnitX(whichUnit)), 0)
		
	endfunction
    
	function GetPolarOffsetX takes real targetX, real distance, real angle returns real
        return targetX + distance * Cos(angle * bj_DEGTORAD)
        
    endfunction
	
	function GetPolarOffsetY takes real targetY, real distance, real angle returns real
        return targetY + distance * Sin(angle * bj_DEGTORAD)
        
    endfunction
	
    function Parabola takes real maxHeight, real maxDistance, real currentDistance returns real
		return (4 * maxHeight / maxDistance) * (maxDistance - currentDistance) * (currentDistance / maxDistance)
		
	endfunction
	
	function AngleBetween takes real x0, real y0, real x1, real y1 returns real 
		return bj_RADTODEG * Atan2(y1 - y0, x1 - x0) 
		
	endfunction
	
	function DistanceBetween takes real x0, real y0, real x1, real y1 returns real 
		return SquareRoot((x0 - x1) * (x0 - x1) + (y0 - y1) * (y0 - y1))
		
	endfunction
	
	function GetCastAngle takes unit caster, real targetX, real targetY returns real
        if GetUnitX(caster) == targetX and GetUnitY(caster) == targetY then
			return GetUnitFacing(caster)
			
		endif
		return AngleBetween(GetUnitX(caster), GetUnitY(caster), targetX, targetY)
		
    endfunction
	
	function GetMidAngle takes real angle1, real angle2 returns real
		local real difference = RAbsBJ(angle1) - RAbsBJ(angle2)
		
		if difference == 180 or difference == -180 then
			return angle1 + angle2 / 2.
			
		else
			set angle1 = angle1 * bj_DEGTORAD
			set angle2 = angle2 * bj_DEGTORAD
			return Atan2(Sin(angle1) + Sin(angle2), Cos(angle1) + Cos(angle2)) * bj_RADTODEG
		endif
		
	endfunction
	
	function MoveXY takes unit whichUnit, real x, real y returns nothing
		call SetUnitX(whichUnit, x)
		call SetUnitY(whichUnit, y)
		
	endfunction
	
	function MoveXYZ takes unit whichUnit, real x, real y, real z returns nothing
		call SetUnitX(whichUnit, x)
		call SetUnitY(whichUnit, y)
		call SetUnitZ(whichUnit, z)
		
	endfunction
    
	function Move2 takes unit whichUnit, real distance, real angle returns nothing
		call SetUnitX(whichUnit, GetPolarOffsetX(GetUnitX(whichUnit), distance, angle))
		call SetUnitY(whichUnit, GetPolarOffsetY(GetUnitY(whichUnit), distance, angle))
		
	endfunction
	
	function Move2WithNormalizeCond takes unit whichUnit, real distance, real angle, boolean corCond, boolean pathCond returns boolean
		local real newX = GetPolarOffsetX(GetUnitX(whichUnit), distance, angle)
		local real newY = GetPolarOffsetY(GetUnitY(whichUnit), distance, angle)
		
		if (not corCond or IsCorInRect(newX, newY, bj_mapInitialPlayableArea)) and (not pathCond or IsCorPathable(newX, newY, GetUnitPathingType(whichUnit))) then
			call MoveXY(whichUnit, newX, newY)
			return true
			
		else
			return false
			
		endif
	endfunction
	
	function Move2WithCond takes unit whichUnit, real distance, real angle, boolean cond returns boolean
		local real newX = GetPolarOffsetX(GetUnitX(whichUnit), distance, angle)
		local real newY = GetPolarOffsetY(GetUnitY(whichUnit), distance, angle)
		
		if cond then
			call MoveXY(whichUnit, newX, newY)
			return true
			
		else
			return false
			
		endif
		
	endfunction

	
endlibrary