local hudMap = {'map', 'tv', 'ship', 'mark1', 'mark2', 'mark3', 'mark4', 'mark5'}

local listMark = {
	{marker = 'mark1', checked = false, fakeLocationX = 322, fakeLocationY = 186, markerX = 100, markerY = 653},
	{marker = 'mark2', checked = false, fakeLocationX = 560, fakeLocationY = 277, markerX = 177, markerY = 626},
	{marker = 'mark3', checked = false, fakeLocationX = 623, fakeLocationY = 520, markerX = 201, markerY = 545},
	{marker = 'mark4', checked = false, fakeLocationX = 325, fakeLocationY = 741, markerX = 100, markerY = 477},
	{marker = 'mark5', checked = false, fakeLocationX = 675, fakeLocationY = 828, markerX = 216, markerY = 446}
}

local spriteStates = {}
local checkedLocation = {}

local photoTaken = 0

local cooldown = false

local blocked = false
local botplaySine = 0
local firstOpening = false
local firstPhoto = false
local quarterSong = {}

local peppinoLuck = 0 -- secret lol

local textsEnding = {}

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

	makeLuaSprite('monsta','lung/monsta', 1160, 590)
	scaleObject('monsta', 4, 4)
	setProperty('monsta.visible', false)
	addLuaSprite('monsta', false)

	makeAnimatedLuaSprite('splash', 'lung/splash', 1210, 540)
	addAnimationByPrefix('splash', 'splash', 'Splash', 24, false)
	objectPlayAnimation('splash', 'splash', false)
	scaleObject('splash', 3, 3)
	addLuaSprite('splash', false)
	
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

	makeAnimatedLuaSprite('tv', 'lung/monitor', 850, -80)
	scaleObject('tv', 0.85, 0.85)
	setObjectCamera('tv', 'camHUD')
	setProperty('tv.antialiasing', false)
	addLuaSprite('tv', false)
	
	--gonna try something epic i saw in someone else's code
	local animationData = {
		{name = 'random1', prefix = 'Random', frame = '0'},
		{name = 'random2', prefix = 'Random', frame = '1'},
		{name = 'random3', prefix = 'Random', frame = '2'},
		{name = 'random4', prefix = 'Random', frame = '3'},
		{name = 'randomamongus', prefix = 'Random', frame = '4'},
		{name = 'randommonsta', prefix = 'Random', frame = '5'},
		{name = 'important1', prefix = 'Important', frame = '0'},
		{name = 'important2', prefix = 'Important', frame = '1'},
		{name = 'important3', prefix = 'Important', frame = '2'},
		{name = 'important4', prefix = 'Important', frame = '3'},
		{name = 'important5', prefix = 'Important', frame = '4'},
		{name = 'important2nofish', prefix = 'Important', frame = '5'},
		{name = 'blackscreen', prefix = 'Blackscreen', frame = '0'}
	}
	
	for _, data in ipairs(animationData) do
		addAnimationByIndices('tv', data.name, data.prefix, data.frame, 1)
	end
	--i'm a genius
	
	objectPlayAnimation('tv', 'blackscreen', false)

	makeAnimatedLuaSprite('static','lung/static', 850, -80)
	addAnimationByPrefix('static', 'idle', 'vhs', 24, true)
	objectPlayAnimation('static', 'idle', false)
	scaleObject('static', 0.85, 0.85)
	setObjectCamera('static', 'camHUD')
	setProperty('static.alpha', 0)
	setProperty('static.visible', false)
	setProperty('static.antialiasing', false)
	addLuaSprite('static', false)

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

	makeLuaText('tutorialTxt', 'Press \'TAB\' to open the map', 300, 10, 640)
	setTextColor('tutorialTxt', '00FF00')
	setTextSize('tutorialTxt', 26)
	addLuaText('tutorialTxt', true)

	makeLuaSprite('blackoverlay', '', 0, 0)
	makeGraphic('blackoverlay', 2000, 2000, '000000')
	setObjectCamera('blackoverlay', 'camOther')
	addLuaSprite('blackoverlay', false)

	makeLuaText('mouseText', 'X_?\nY_?', 150, getMouseX('other'), getMouseY('other'))
	setTextSize('mouseText', 18)
	setTextBorder('mouseText', 0)
	setProperty('mouseText.visible', false)
	addLuaText('mouseText', true)

	makeAnimatedLuaSprite('logo', 'mainmenu/menu_iron_lung', 0, 0)
	addAnimationByPrefix('logo', 'idle', 'iron_lung white', 24, true)
	objectPlayAnimation('logo', 'idle', false)
	setObjectCamera('logo', 'camOther')
	screenCenter('logo', 'xy')
	setProperty('logo.visible', false)
	addLuaSprite('logo', false)

	setProperty('skipCountdown', true)
	math.randomseed(os.time())

end

function onCreatePost()
	triggerEvent('Camera Follow Pos', '1650', '1000') --freeze camera, avoids using setProperty('camFollow.x') and setProperty('camFollow.y')

	for i = 1, #hudMap do
		setProperty(hudMap[i]..'.alpha', 0)
	end

	for _, data in ipairs(listMark) do
		setProperty(data.marker..'.x', data.markerX)
		setProperty(data.marker..'.y', data.markerY)
	end
end

function onSongStart()
	totalSteps = 2367
	totalMvt1 = ((stepCrochet / 1000) * 1024) / 15
	totalMvt2 = ((stepCrochet / 1000) * 512) / 15
	quarterLength = totalSteps / 4

	for i = 1, 3 do
		table.insert(quarterSong, math.floor(quarterLength * i))
	end

	doTweenY('whatyouknowaboutrollingdowninthedeep', 'depthmeter', 375, 32, 'linear')
end

function onUpdatePost(elapsed)
	for _, data in ipairs(listMark) do
		local sprite = data.marker
		local isMouseOverlapping = mouseOverLapsSprite(sprite)
		local currentAlpha = getProperty(sprite..'.alpha')
		local currentState = spriteStates[sprite] or false
	
		if isMouseOverlapping and currentAlpha == 1 and not currentState and data.checked == false then
			loadGraphic(sprite, 'lung/crosshairselect')
			setTextString('mouseText', 'X_'..data.fakeLocationX..'\nY_'..data.fakeLocationY)
			setProperty('mouseText.visible', true)
			spriteStates[sprite] = true
		elseif (not isMouseOverlapping or currentAlpha ~= 1) and currentState and data.checked == false then
			loadGraphic(sprite, 'lung/crosshairunselect')
			setProperty('mouseText.visible', false)
			spriteStates[sprite] = false
		end
	end

	if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.SPACE') and curStep >= 512 and curStep < 2048 and cooldown == false then
		if not firstPhoto then
			firstPhoto = true
		end
		objectPlayAnimation('tv', 'blackscreen', false)
		cooldown = true
		runTimer('printingDelay', 2.4)
		playSound('printing', 1, 'printing')
	end

	if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.TAB') and not blocked then
		blocked = true
	
		local tvAlpha = getProperty('tv.alpha')
		local peppinoAlpha = getProperty('peppino.alpha')
	
		if tvAlpha == 0 and peppinoAlpha == 0 then
			local peppinoLuck = math.random(0, 99)
			hudMap[2] = (peppinoLuck < 99) and 'tv' or 'peppino'
		end
	
		for i = 1, #hudMap do
			local sprite = hudMap[i]
			local alpha = getProperty(sprite..'.alpha')
			local targetAlpha = (alpha == 0) and 1 or 0
			local tweenName = sprite..'Alpha'..((targetAlpha == 1) and 'In' or 'Out')
	
			if hudMap[2] == 'tv' or sprite == 'static' then
				doTweenAlpha('staticAlpha', 'static', targetAlpha, 0.5, 'sineInOut')
			end
			doTweenAlpha(tweenName, sprite, targetAlpha, 0.5, 'sineInOut')
			setPropertyFromClass('flixel.FlxG', 'mouse.visible', targetAlpha == 1)
		end
	
		if not firstOpening then
			firstOpening = true
		end
	end
end

function checkNearbySprite()
	local nearby = 0
	local shipX, shipY = getProperty('ship.x'), getProperty('ship.y')

	for _, data in ipairs(listMark) do
		local sprite = data.marker
		local spriteX, spriteY = getProperty(sprite..'.x'), getProperty(sprite..'.y')

		local distanceX = math.abs(shipX - spriteX)
		local distanceY = math.abs(shipY - spriteY)

		if distanceX <= 8 and distanceY <= 8 then
			nearby = _
			break
		end
	end

	if nearby >= 1 then
		printImportant(nearby)
	else
		printRandom()
	end

	runTimer('resetScreen', 8)
end

function printImportant(num)
	local animationName = (photoTaken == 2 and num == 2) and 'important2nofish' or 'important'..num
	loadGraphic('mark'..num, 'lung/check')
	listMark[num].checked = true
	objectPlayAnimation('tv', animationName, false)
	if animationName ~= 'important2nofish' then
		photoTaken = photoTaken + 1
	end
end

function printRandom()
	if not monstaMoment then
		local randomPhoto = (math.random(1, 100) == 100) and 'amongus' or math.random(1, 4)
		objectPlayAnimation('tv', 'random'..randomPhoto, false)
		if randomPhoto == 'amongus' then
			playSound('vineboom', 0.5, 'vineboom')
		end
	else
		objectPlayAnimation('tv', 'randommonsta', false)
		cancelTimer('noMoreMonsta')
		monstaMoment = false
	end
end

function onUpdate(elapsed)
	setProperty('mouseText.x', getMouseX('other') - 30)
	setProperty('mouseText.y', getMouseY('other') - 18)
	
	if luaTextExists('tutorialTxt') == true then
		botplaySine = botplaySine + 180 * elapsed
		setProperty('tutorialTxt.alpha', 1 - math.sin((math.pi * botplaySine) / 180)) --actually took that from the Psych source code lol
	elseif botplaySine ~= nil then
		botplaySine = nil
	end

	if firstOpening == true and getProperty('tutorialTxt.alpha') < 0.01 then -- falling on the 0 alpha is pretty rare using sinus, so i'll set it to be at least lower than 0.01 cuz it always does and it's barelly visible by the human eye
		setProperty('tutorialTxt.x', 900)
		setProperty('tutorialTxt.y', 260)
		setTextString('tutorialTxt', 'Press \'Space\' to take a picture')
		if curStep < 512 then
			setProperty('tutorialTxt.visible', false)
		end
		firstOpening = nil
	end
	
	if firstPhoto == true and getProperty('tutorialTxt.alpha') < 0.01 then
		removeLuaText('tutorialTxt', true)
		firstPhoto = nil
	end
end

function onStepHit()
	if curStep == 48 then
		doTweenAlpha('byeoverlay', 'blackoverlay', 0, 4, 'linear')
	end

	if curStep == 276 then
		doTweenColor('oceangodarker', 'ocean', '555555', 6, 'linear')
	end

	if curStep == 340 then
		doTweenY('closingFrontHoleShilding', 'frontdoor', 375, 4, 'sineInOut') --started slightly offset to make the animation slower, and by doing so, more realistic
	end

	if curStep == 362 then
		cameraShake('camGame', 0.0025, 2.2)
	end

	if curStep == 512 then
		doTweenY('boatstarts', 'ship', 656, totalMvt1, 'sineInOut')
		setProperty('static.visible', true)
		setProperty('tutorialTxt.visible', true)
	end

	if curStep == 1536 then
		cancelTween('151')
		cancelTween('152')
		setProperty('ship.x', 60)
		setProperty('ship.y', 502)
		setProperty('ship.angle', -90)
		monstaMoment = true
		runTimer('noMoreMonsta', 10)
		doTweenAngle('boatstartspart2', 'ship', 0, 2, 'sineInOut')
	end

	for i = 1, #quarterSong do
		if curStep == quarterSong[i] then
			loadGraphic('curoxygen', 'lung/oxygen'..i+1)
			playSound('oxygen', 0.25, 'oxygen') --took from the original game's resources
		end
	end

	if curStep == 2048 then
		setProperty('static.visible', false)
		cancelTween('340')
		if photoTaken >= 4 then
		    setProperty('monsta.visible', true)
			objectPlayAnimation('splash', 'splash', false)
			doTweenX('bigMonstaX', 'monsta.scale', 5, 0.7, 'linear')
			doTweenY('bigMonstaY', 'monsta.scale', 5, 0.7, 'linear')
			doTweenY('movingIllusion', 'monsta', getProperty('monsta.y') + 60, 0.7, 'linear')
			playSound('jumpscare', 1, 'jumpscare')
			cameraShake('camGame', 0.025, 0.7)
			runTimer('pre-ending', 0.7)
			textsEnding = {'A huge beast destroyed your ship.', 'No photographies has been recovered.', 'Somewhere in the void, there must be hope...'}
		else
			setProperty('camGame.visible', false)
			setProperty('camHUD.visible', false)
			textsEnding = {'You crashed into a wall...', 'You haven\'t taken all the required photographies.', 'Somewhere in the void, there must be hope...'}
		end
		runTimer('ending', (crochet / 1000) * 17)
	end
end

function onTweenCompleted(tag, loops, loopsLeft)
	if tag == 'mapAlphaIn' or tag == 'mapAlphaOut' then
		blocked = false
	end

	if tag == 'byeoverlay' then
		removeLuaSprite('blackoverlay', true)
	end

	--boat movements
	if tag == 'boatstarts' then
		doTweenAngle('boatrotate', 'ship', -45, totalMvt1 / 2, 'sineInOut')
	elseif tag == 'boatrotate' then	
		doTweenY('11', 'ship', 647.5, totalMvt1 / 2, 'sineInOut')
		doTweenX('12', 'ship', 63, totalMvt1 / 2, 'sineInOut')
	elseif tag == '11' then
		doTweenAngle('2', 'ship', 25, totalMvt1 / 2, 'sineInOut')
	elseif tag == '2' then
		doTweenX('31', 'ship', 100, totalMvt1, 'sineInOut')
		doTweenY('32', 'ship', 653, totalMvt1, 'sineInOut')
	elseif tag == '31' then
		doTweenAngle('4', 'ship', -79, totalMvt1 / 2, 'sineInOut')
	elseif tag == '4' then
		doTweenX('51', 'ship', 118, totalMvt1 * 1.5, 'sineInOut')
		doTweenY('52', 'ship', 609, totalMvt1 * 1.5, 'sineInOut')
	elseif tag == '51' then
		doTweenAngle('6', 'ship', 13, totalMvt1 / 2, 'sineInOut')
	elseif tag == '6' then
		doTweenX('71', 'ship', 150, totalMvt1, 'sineInOut')
		doTweenY('72', 'ship', 610, totalMvt1, 'sineInOut')
	elseif tag == '71' then
		doTweenAngle('8', 'ship', 45, totalMvt1 / 2, 'sineInOut')
	elseif tag == '8' then
		doTweenX('91', 'ship', 177, totalMvt1, 'sineInOut')
		doTweenY('92', 'ship', 626, totalMvt1, 'sineInOut')
	elseif tag == '91' then
		doTweenAngle('10', 'ship', -86, totalMvt1 / 2, 'sineInOut')
	elseif tag == '10' then
		doTweenX('111', 'ship', 183, totalMvt1 * 2.5, 'sineInOut')
		doTweenY('112', 'ship', 555, totalMvt1 * 2.5, 'sineInOut')
	elseif tag == '111' then
		doTweenAngle('120', 'ship', -35, totalMvt1 / 2, 'sineInOut')
	elseif tag == '120' then
		doTweenX('131', 'ship', 201, totalMvt1, 'sineInOut')
		doTweenY('132', 'ship', 545, totalMvt1, 'sineInOut')
	elseif tag == '131' then
		doTweenAngle('14', 'ship', -193, totalMvt1 / 1.5, 'sineInOut')
	elseif tag == '14' then
		doTweenX('151', 'ship', 167, totalMvt1, 'sineInOut')
		doTweenY('152', 'ship', 553, totalMvt1, 'sineInOut')
	end

	if tag == 'boatstartspart2' then
		doTweenX('200', 'ship', 100, totalMvt2, 'sineInOut')
	elseif tag == '200' then
		doTweenAngle('210', 'ship', -90, totalMvt2 / 1.5, 'sineInOut')
	elseif tag == '210' then
		doTweenY('220', 'ship', 477, totalMvt2, 'sineInOut')
	elseif tag == '220' then
		doTweenAngle('230', 'ship', 0, totalMvt2, 'sineInOut')
	elseif tag == '230' then
		doTweenX('240', 'ship', 137, totalMvt2, 'sineInOut')
	elseif tag == '240' then
		doTweenAngle('250', 'ship', 45, totalMvt2 / 2, 'sineInOut')
	elseif tag == '250' then
		doTweenX('261', 'ship', 150, totalMvt2, 'sineInOut')
		doTweenY('262', 'ship', 490, totalMvt2, 'sineInOut')
	elseif tag == '261' then
		doTweenAngle('270', 'ship', 0, totalMvt2 / 2, 'sineInOut')
	elseif tag == '270' then
		doTweenX('280', 'ship', 179, totalMvt2, 'sineInOut')
	elseif tag == '280' then
		doTweenAngle('290', 'ship', -65, totalMvt2 / 1.5, 'sineInOut')
	elseif tag == '290' then
		doTweenX('301', 'ship', 194, totalMvt2, 'sineInOut')
		doTweenY('302', 'ship', 467, totalMvt2, 'sineInOut')
	elseif tag == '301' then
		doTweenAngle('310', 'ship', -10, totalMvt2 / 2, 'sineInOut')
	elseif tag == '310' then
		doTweenX('320', 'ship', 215, totalMvt2, 'sineInOut')
		doTweenY('340', 'ship', 462, totalMvt2, 'sineInOut')
	elseif tag == '320' then
		doTweenAngle('330', 'ship', -90, totalMvt2 / 2, 'sineInOut')
	elseif tag == '330' then
		doTweenY('340', 'ship', 446, totalMvt2, 'sineInOut')
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

	if tag == 'resetScreen' then
		objectPlayAnimation('tv', 'blackscreen', false)
	end

	if tag == 'pre-ending' then
		setProperty('camGame.visible', false)
		setProperty('camHUD.visible', false)
	end

	if tag == 'ending' then
		makeLuaText('endingTxt', textsEnding[1], 750, 0, 0)
		setObjectCamera('endingTxt', 'camOther')
		setTextSize('endingTxt', 62)
		screenCenter('endingTxt', 'xy')
		setTextColor('endingTxt', '00FF00')
		addLuaText('endingTxt', false)
		runTimer('ending2', (crochet / 1000) * 16)
	end

	if tag == 'ending2' then
		setTextString('endingTxt', textsEnding[2])
		screenCenter('endingTxt', 'xy')
		runTimer('ending3', (crochet / 1000) * 16)
	end

	if tag == 'ending3' then
		setTextString('endingTxt', textsEnding[3])
		screenCenter('endingTxt', 'xy')
		runTimer('logoReveal', (crochet / 1000) * 16)
	end

	if tag == 'logoReveal' then
		removeLuaText('endingTxt', true)
		setProperty('logo.visible', true)
	end

	if tag == 'noMoreMonsta' then
		monstaMoment = false
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