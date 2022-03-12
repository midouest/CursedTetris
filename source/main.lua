import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

import "constants"
import "loadTets"
import "Block"
import "Grid"
import "Rot"
import "Tet"

local pd<const> = playdate
local gfx<const> = pd.graphics
local snd<const> = pd.sound

local function chooseNextTetIdx()
    return math.random(1, #tets)
end

local function setupTet()
    if tet ~= nil then
        tet:remove()
    end

    if nextTet ~= nil then
        nextTet:remove()
    end

    tetIdx = nextTetIdx
    nextTetIdx = chooseNextTetIdx()

    tet = tets[tetIdx]:copy()
    tet:moveTo(kXGridInit + tet.xStart, kYGridInit + tet.yStart)
    tet:add()

    nextTet = tets[nextTetIdx]:copy()
    nextTet:moveTo(kXGridNext + tet.xStart, kYGridNext + tet.yStart)
    nextTet:add()

    if tick ~= nil then
        tick:reset()
    end
end

local function moveLeft()
    local _, len = tet:checkCollisionsBy(-1, 0)
    if len == 0 then
        tet:moveBy(-1, 0)
    end
end

function pd.leftButtonDown()
    leftRepeatTimer = pd.timer.keyRepeatTimerWithDelay(300, kRepeatDelay,
                                                       moveLeft)
end

function pd.leftButtonUp()
    leftRepeatTimer:remove()
end

local function moveRight()
    local _, len = tet:checkCollisionsBy(1, 0)
    if len == 0 then
        tet:moveBy(1, 0)
    end
end

function pd.rightButtonDown()
    rightRepeatTimer = pd.timer.keyRepeatTimerWithDelay(kInitialDelay,
                                                        kRepeatDelay, moveRight)
end

function pd.rightButtonUp()
    rightRepeatTimer:remove()
end

local function moveDown()
    local _, len = tet:checkCollisionsBy(0, 1)
    if len == 0 then
        tet:moveBy(0, 1)
    else
        grid:addBlocks(tet:getBlocks())
        setupTet()
        if tet:isOverlapping() then
            setupGame()
        end
    end
end

function pd.downButtonDown()
    downRepeatTimer = pd.timer.keyRepeatTimerWithDelay(kInitialDelay,
                                                       kRepeatDelay, moveDown)
end

function pd.downButtonUp()
    downRepeatTimer:remove()
end

local function rotateCW()
    local overlapping = tet:checkRotateOverlaps(kCW)
    if not overlapping then
        tet:rotate(kCW)
    end
end

function pd.AButtonDown()
    cwRepeatTimer = pd.timer.keyRepeatTimerWithDelay(kInitialDelay,
                                                     kRepeatDelay, rotateCW)
end

function pd.AButtonUp()
    cwRepeatTimer:remove()
end

local function rotateCCW()
    local overlapping = tet:checkRotateOverlaps(kCCW)
    if not overlapping then
        tet:rotate(kCCW)
    end
end

function pd.BButtonDown()
    ccwRepeatTimer = pd.timer.keyRepeatTimerWithDelay(kInitialDelay,
                                                      kRepeatDelay, rotateCCW)
end

function pd.BButtonUp()
    ccwRepeatTimer:remove()
end

function setupGame()
    if tet ~= nil then
        tet:remove()
    end
    if nextTet ~= nil then
        nextTet:remove()
    end
    if grid ~= nil then
        grid:remove()
    end
    if tick ~= nil then
        tick:remove()
    end

    if tets == nil then
        tets = loadTets()
    end

    math.randomseed(pd.getSecondsSinceEpoch())

    grid = Grid(kGridX, kGridY, kGridTilesX, kGridTilesY)

    wall1 = gfx.sprite.addEmptyCollisionSprite(kWall1X, kWall1Y, kWall1W,
                                               kWall1H)
    wall2 = gfx.sprite.addEmptyCollisionSprite(kWall2X, kWall2Y, kWall2W,
                                               kWall2H)
    floor = gfx.sprite.addEmptyCollisionSprite(kFloorX, kFloorY, kFloorW,
                                               kFloorH)

    setupGridCollision(wall1)
    setupGridCollision(wall2)
    setupGridCollision(floor)

    gfx.sprite.setBackgroundDrawingCallback(function()
        gfx.fillRect(kWall1X, kWall1Y, kWall1W, kWall1H)
        gfx.fillRect(kWall2X, kWall2Y, kWall2W, kWall2H)
    end)

    nextTetIdx = chooseNextTetIdx()
    setupTet()

    tick = pd.timer.new(1000)
    tick.discardOnCompletion = false
    tick.repeats = true
    tick.timerEndedCallback = moveDown
end

function setupSounds()
    seq = snd.sequence.new("data/korobeiniki.mid")
    seq:setTempo(1024)
    local startStep<const> = 0
    local endStep<const> = seq:getLength()
    seq:setLoops(startStep, endStep)

    for i = 1, seq:getTrackCount() do
        local t<const> = seq:getTrackAtIndex(i)
        local n<const> = t:getPolyphony()
        if n > 0 then
            local inst<const> = snd.instrument.new()
            for _ = 1, n do
                local s<const> = snd.synth.new(snd.kWaveSquare)
                s:setVolume(0.2)
                s:setADSR(0, 0.15, 0.2, 0)
                inst:addVoice(s)
            end
            t:setInstrument(inst)
        end
    end

    seq:play()
end

setupGame()
setupSounds()

function pd.update()
    if pd.buttonJustPressed(pd.kButtonUp) then
        local stopped = false
        while not stopped do
            local _, len = tet:checkCollisionsBy(0, 1)
            if len == 0 then
                tet:moveBy(0, 1)
            else
                stopped = true
            end
        end

        grid:addBlocks(tet:getBlocks())
        setupTet()
        if tet:isOverlapping() then
            setupGame()
        end
    end

    gfx.sprite.update()
    pd.timer.updateTimers()
    pd.drawFPS(0, 0)
end
