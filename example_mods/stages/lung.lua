local hudMap = {'map', 'tv', 'ship', 'mark1', 'mark2', 'mark3', 'mark4', 'mark5'}
local markerX = {100, 177, 201, 100, 216}
local markerY = {653, 626, 545, 477, 446}

local fakeLocationX = {322, 560, 623, 325, 675}
local fakeLocationY = {186, 277, 520, 741, 828}

local spriteStates = {}

local cooldown = false

local blocked = false
local botplaySine = 0
local firstOpening = false
local quarterSong = {}

local peppinoLuck = 0 -- secret lol

function onCreate()

	precacheSound('oxygen')

	makeLuaSprite('ocean', 'lung/bloodocean', 775, 375)
	addLuaSprite('ocean', false)

	makeLuaSprite('frontdoor', 'lung/doorthingy', 775, 700)
	addLuaSprite('frontdoor', false)

	makeLuaSprite('bg','lung/ironlung', 775, 375)
	addLuaSprite('bg', false)

	makeLuaSprite('tubes','lung/tubes', 775, 375)
	addLuaSprite('tubes', false)

	makeLuaSprite('table','lung/table', 775, 375)
	addLuaSprite('table', false)

	makeLuaSprite('depth','lung/depth', 775, 375)
	addLuaSprite('depth', false)

	makeLuaSprite('depthmeter','lung/meter', 775, 220)
	--scaleObject('depthmeter', 1.1, 1)
	addLuaSprite('depthmeter', false)

	makeLuaSprite('oxygenmeter','lung/oxygenmeter', 775, 375)
	addLuaSprite('oxygenmeter', false)

	makeLuaSprite('curoxygen','lung/oxygen1', 775, 375)
	addLuaSprite('curoxygen', false)
	
	makeLuaSprite('lamp','lung/lamp', 775, 375)
	addLuaSprite('lamp', false)

	makeLuaSprite('light','lung/light', 620, 395)
	scaleObject('light', 1.2, 1.2)
	--setBlendMode('light', 'add')
	addLuaSprite('light', true)

	makeLuaSprite('vignette','lung/vignette', 775, 375)
	addLuaSprite('vignette', true)

	makeLuaSprite('map','lung/MapTex', 0, 395) --took from the original game's resources
	scaleObject('map', 0.325, 0.325)
	setObjectCamera('map', 'camHUD')
	addLuaSprite('map', false)

	makeLuaSprite('tv','lung/monitor', 875, -80) --took from the original game's resources
	scaleObject('tv', 0.85, 0.85)
	setObjectCamera('tv', 'camHUD')
	addLuaSprite('tv', false)

	makeAnimatedLuaSprite('peppino','funni/peppino_tv', 850, -80)
	addAnimationByPrefix('peppino', 'idle', 'Idle', 24, true)
	objectPlayAnimation('pepino', 'idle', false)
	scaleObject('peppino', 1.6, 1.6)
	setObjectCamera('peppino', 'camHUD')
	setProperty('peppino.antialiasing', false)
	setProperty('peppino.alpha', 0)
	addLuaSprite('peppino', false)

	for i = 1, 5 do
		makeLuaSprite('mark'..i,'lung/crosshairunselect', 0, 0) --taken from the original game's resources
		scaleObject('mark'..i, 0.6, 0.6)
		setObjectCamera('mark'..i, 'camHUD')
		setObjectOrder('mark'..i, getObjectOrder('map') + 1)
		addLuaSprite('mark'..i, false)
	end

	makeLuaSprite('ship','lung/shiplocation', 52, 675) --taken from the original game's resources
	scaleObject('ship', 0.5, 0.5)
	setObjectCamera('ship', 'camHUD')
	setObjectOrder('ship', getObjectOrder('map') + 1)
	setProperty('ship.angle', -90)
	addLuaSprite('ship', false)

	makeLuaText('presstab', 'Press \'TAB\' to open the map', 300, 10, 640)
	setTextSize('presstab', 26)
	addLuaText('presstab', true)

	makeLuaSprite('blackoverlay', '', 0, 0)
	makeGraphic('blackoverlay', 2000, 2000, '000000')
	setObjectCamera('blackoverlay', 'camOther')
	addLuaSprite('blackoverlay', false)

	makeLuaText('mouseText', 'X_?\nY_?', 150, getMouseX('other'), getMouseY('other'))
	setTextSize('mouseText', 18)
	setTextBorder('mouseText', 0)
	setProperty('mouseText.visible', false)
	addLuaText('mouseText', true)

	setProperty('skipCountdown', true)
	math.randomseed(os.time())

end

function onCreatePost()
	triggerEvent('Camera Follow Pos', '1650', '1000') --freeze camera, avoids using setProperty('camFollow.x') and setProperty('camFollow.y')

	for i = 1, #hudMap do
		setProperty(hudMap[i]..'.alpha', 0)
	end

	for j = 4, #hudMap do
		setProperty(hudMap[j]..'.x', markerX[j-3])
		setProperty(hudMap[j]..'.y', markerY[j-3])
	end
end

function onSongStart()
	totalSteps = 2367
	quarterLength = totalSteps / 4

	for i = 1, 3 do
		table.insert(quarterSong, math.floor(quarterLength * i))
	end

	doTweenY('whatyouknowaboutrollingdowninthedeep', 'depthmeter', 375, 32, 'linear')
end

function onUpdatePost(elapsed)
	for i = 1, #quarterSong do
		if curStep == quarterSong[i] then
			switchOxygenState(i)
			break
		end
	end

	for j = 4, #hudMap do
		local sprite = hudMap[j]
		local isMouseOverlapping = mouseOverLapsSprite(sprite)
		local currentAlpha = getProperty(sprite..'.alpha')
		local currentState = spriteStates[sprite] or false
	
		if isMouseOverlapping and currentAlpha == 1 and not currentState then
			loadGraphic(sprite, 'lung/crosshairselect')
			setTextString('mouseText', 'X_'..fakeLocationX[j - 3]..'\nY_'..fakeLocationY[j - 3])
			setProperty('mouseText.visible', true)
			spriteStates[sprite] = true
		elseif (not isMouseOverlapping or currentAlpha ~= 1) and currentState then
			loadGraphic(sprite, 'lung/crosshairunselect')
			setProperty('mouseText.visible', false)
			spriteStates[sprite] = false
		end
	end

	if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.SPACE') and cooldown == false then
		cooldown = true
		runTimer('printingDelay', 2.4)
		playSound('printing', 1, 'printing')
	end

	if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.TAB') and blocked == false then
		blocked = true

		local tvAlpha = getProperty('tv.alpha')
		local peppinoAlpha = getProperty('peppino.alpha')
	
		if tvAlpha == 0 and peppinoAlpha == 0 then
			peppinoLuck = math.random(0, 50)
			hudMap[2] = (peppinoLuck < 50) and 'tv' or 'peppino'
		end
	
		for i = 1, #hudMap do
			local alpha = getProperty(hudMap[i]..'.alpha')
			local targetAlpha = (alpha == 0) and 1 or 0
			local tweenName = hudMap[i]..'Alpha'..((targetAlpha == 1) and 'In' or 'Out')
	
			doTweenAlpha(tweenName, hudMap[i], targetAlpha, 0.5, 'sineInOut')
			setPropertyFromClass('flixel.FlxG', 'mouse.visible', targetAlpha == 1)
		end
	
		firstOpening = not firstOpening
	end
end

function checkNearbySprite()
	local nearby = 0
	local shipX, shipY = getProperty('ship.x'), getProperty('ship.y')

	for i = 4, #hudMap do
		local sprite = hudMap[i]
		local spriteX, spriteY = getProperty(sprite..'.x'), getProperty(sprite..'.y')

		local distanceX = math.abs(shipX - spriteX)
		local distanceY = math.abs(shipY - spriteY)

		if distanceX <= 10 and distanceY <= 10 then
			nearby = i - 3
			break
		end
	end

	if nearby >= 1 then
		printImportant(nearby)
	else
		printRandom()
	end
end

function printImportant(num)
	debugPrint('important'..num)
end

function printRandom()
	debugPrint('nope')
end

function switchOxygenState(num) -- created this because playSound on Update is not a good idea, even if it's depending on the curStep
	loadGraphic('curoxygen', 'lung/oxygen'..num+1)
	playSound('oxygen', 0.25, 'oxygen') --took from the original game's resources
end

function onUpdate(elapsed)
	if luaTextExists('presstab') == true then
		botplaySine = botplaySine + 180 * elapsed
		setProperty('presstab.alpha', 1 - math.sin((math.pi * botplaySine) / 180)) --actually took that from the Psych source code lol
	elseif botplaySine ~= nil and firstOpening ~= nil then
		botplaySine = nil
		firstOpening = nil
	end

	if firstOpening == true and getProperty('presstab.alpha') < 0.01 then -- falling on the 0 alpha is pretty rare using sinus, so i'll set it to be at least lower than 0.01 cuz it always does and it's barelly visible by the human eye
		removeLuaText('presstab', true)
	end

	setProperty('mouseText.x', getMouseX('other') - 30)
	setProperty('mouseText.y', getMouseY('other') - 18)
end

function onStepHit()
	if curStep == 48 then
		doTweenAlpha('byeoverlay', 'blackoverlay', 0, 4, 'linear')
	end

	if curStep == 340 then
		doTweenY('closingFrontHoleShilding', 'frontdoor', 375, 4, 'sineInOut') --started slightly offset to make the animation slower, and by doing so, more realistic
	end

	if curStep == 362 then
		cameraShake('camGame', 0.0025, 2.2)
	end

	if curStep == 512 then
		doTweenY('boatstarts', 'ship', 656, 2, 'sineIn')
	end
end

function onTweenCompleted(tag, loops, loopsLeft)
	if tag == 'mapAlphaIn' or tag == 'mapAlphaOut' then
		blocked = false
	end

	if tag == 'byeoverlay' then
		removeLuaSprite('blackoverlay', true)
	end

	if tag == 'boatstarts' then
		doTweenY('boatgoesrightup', 'ship', 647.5, 2, 'sineInOut')
		doTweenX('boatgoesright', 'ship', 63, 2, 'sineInOut')
		doTweenAngle('boatgoesrightangle', 'ship', -45, 2, 'sineInOut')
	elseif tag == 'boatgoesright' then
		doTweenAngle('boatrotating', 'ship', 25, 2, 'sineInOut')
	elseif tag == 'boatrotating' then
		doTweenX('boatgoingtothatmarker1x', 'ship', 100, 2, 'sineInOut')
		doTweenY('boatgoingtothatmarker1y', 'ship', 653, 2, 'sineInOut')
		doTweenAngle('boatgoingtothatmarker1angle', 'ship', 25, 2, 'sineInOut')
	elseif tag == 'boatgoingtothatmarker1angle' then
		doTweenAngle('boatrotatingagain', 'ship', -79, 2, 'sineInOut')
	end
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'disableCooldown' then
		cooldown = false
	end

	if tag == 'printingDelay' then
		checkNearbySprite()
		runTimer('disableCooldown', 1)
	end
end

function onDestroy()
	setPropertyFromClass('flixel.FlxG', 'mouse.visible', false)
end

function posOverlaps(
    x1, y1, w1, h1, --r1,
    x2, y2, w2, h2 --r2
)
    return (
        x1 + w1 >= x2 and x1 < x2 + w2 and
        y1 + h1 >= y2 and y1 < y2 + h2
    )
end

function mouseOverLapsSprite(spr, cam)
    local mouseX, mouseY = getMouseX(cam or "other"), getMouseY(cam or "other")
    
    local x, y, w, h = getProperty(spr .. ".x"), getProperty(spr .. ".y"), getProperty(spr .. ".width"), getProperty(spr .. ".height")
    
    return posOverlaps(
        mouseX, mouseY, 1, 1,
        x, y, w, h
    )
end