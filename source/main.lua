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

local function setupTet()
    if tet ~= nil then
        tet:remove()
    end

    tetIdx = math.random(1, #tets)
    tet = tets[tetIdx]:copy()
    tet:moveTo(kXGridInit + tet.xStart, kYGridInit + tet.yStart)
    tet:add()
end

local function moveLeft()
    local _, len = tet:checkCollisionsBy(-1, 0)
    if len == 0 then
        tet:moveBy(-1, 0)
    end
end

function pd.leftButtonDown()
    leftRepeatTimer = pd.timer.keyRepeatTimerWithDelay(300, 50, moveLeft)
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
    rightRepeatTimer = pd.timer.keyRepeatTimerWithDelay(200, 50, moveRight)
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
    downRepeatTimer = pd.timer.keyRepeatTimerWithDelay(200, 50, moveDown)
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
    cwRepeatTimer = pd.timer.keyRepeatTimerWithDelay(200, 50, rotateCW)
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
    ccwRepeatTimer = pd.timer.keyRepeatTimerWithDelay(200, 50, rotateCCW)
end

function pd.BButtonUp()
    ccwRepeatTimer:remove()
end

function setupGame()
    if grid ~= nil then
        grid:remove()
    end

    math.randomseed(pd.getSecondsSinceEpoch())

    tets = loadTets()
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

    gfx.sprite.setBackgroundDrawingCallback(
        function(x, y, w, h)
            if x ~= 0 or y ~= 0 or w ~= kLCDWidth or h ~= kLCDHeight then
                return
            end

            gfx.fillRect(kWall1X, kWall1Y, kWall1W, kWall1H)
            gfx.fillRect(kWall2X, kWall2Y, kWall2W, kWall2H)
        end)

    setupTet()

    if tick ~= nil then
        tick:remove()
    end

    tick = pd.timer.new(1000)
    tick.discardOnCompletion = false
    tick.repeats = true
    tick.timerEndedCallback = moveDown
end

setupGame()

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
