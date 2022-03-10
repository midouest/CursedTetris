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
    tet:moveTo(kXGridInit, kYGridInit)
    tet:add()
end

function setupGame()
    if grid ~= nil then
        grid:remove()
    end

    math.randomseed(pd.getSecondsSinceEpoch())

    tets = loadTets()
    grid = Grid(kGridWidth, kGridHeight)

    wall1 = gfx.sprite.addEmptyCollisionSprite(0, -kWallSize, kLCDWidth,
                                               kWallSize)
    wall2 = gfx.sprite.addEmptyCollisionSprite(0, kLCDHeight, kLCDWidth,
                                               kWallSize)
    floor = gfx.sprite.addEmptyCollisionSprite(kLCDWidth, 0, kWallSize,
                                               kLCDHeight)

    setupGridCollision(wall1)
    setupGridCollision(wall2)
    setupGridCollision(floor)

    setupTet()
end

setupGame()

function pd.update()
    if pd.buttonIsPressed(pd.kButtonLeft) then
        tet:moveBy(-1, 0)
    elseif pd.buttonIsPressed(pd.kButtonRight) then
        local _, len = tet:checkCollisionsBy(1, 0)
        if len == 0 then
            tet:moveBy(1, 0)
        else
            grid:addBlocks(tet:getBlocks())
            setupTet()
        end
    elseif pd.buttonIsPressed(pd.kButtonUp) then
        local _, len = tet:checkCollisionsBy(0, -1)
        if len == 0 then
            tet:moveBy(0, -1)
        end
    elseif pd.buttonIsPressed(pd.kButtonDown) then
        local _, len = tet:checkCollisionsBy(0, 1)
        if len == 0 then
            tet:moveBy(0, 1)
        end
    elseif pd.buttonJustPressed(pd.kButtonB) then
        local overlapping = tet:checkRotateOverlaps(kCCW)
        if not overlapping then
            tet:rotate(kCCW)
        end
    elseif pd.buttonJustPressed(pd.kButtonA) then
        local overlapping = tet:checkRotateOverlaps(kCW)
        if not overlapping then
            tet:rotate(kCW)
        end
    end

    gfx.sprite.update()
    pd.drawFPS(0, 0)
    pd.timer.updateTimers()
end
