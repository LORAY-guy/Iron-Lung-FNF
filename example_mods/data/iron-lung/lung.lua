function onCreatePost()
    setProperty('dad.visible', false)
    setProperty('iconP2.visible', false)
    setProperty('boyfriend.flipX', false)
    setProperty('boyfriend.y', 1155)
    setProperty('boyfriend.alpha', 0)
end

function onStepHit()
    if curStep == 64 then
        doTweenY('boyfriendUp', 'boyfriend', 755, 4, 'quadInOut')
        doTweenAlpha('boyfriendAlphaIn', 'boyfriend', 1, 4, 'quadInOut')
    end

    if curStep == 72 then
        if not middlescroll then
            noteTweenX('4X', 4, defaultPlayerStrumX0 - 320, 4, 'quadInOut')
            noteTweenX('5X', 5, defaultPlayerStrumX1 - 320, 4, 'quadInOut')
            noteTweenX('6X', 6, defaultPlayerStrumX2 - 320, 4, 'quadInOut')
            noteTweenX('7X', 7, defaultPlayerStrumX3 - 320, 4, 'quadInOut')
    
            for i = 4,7 do
                noteTweenAngle(i..'Angle', i, 360, 4, 'quadInOut')
            end
    
            for j = 0,3 do
                noteTweenAlpha(j..'alpha', j, 0, 4, 'quadInOut')
            end
        end
    end

    if curStep == 1536 then
        triggerEvent('Screen Shake', '0.2, 0.15', '0.2, 0.15')
    end
end

function onTweenCompleted(tag)
    if tag == '4Angle' then
        for i = 4, 7 do
            setPropertyFromGroup('strumLineNotes', i, 'angle', 0)
        end
    end
end