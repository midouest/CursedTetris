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

local wallSize<const> = 10
local xGridInit<const> = 0
local yGridInit<const> = math.floor(kGridHeight / 2)

local function setupTet()
    if tet ~= nil then
        tet:remove()
    end

    tetIdx = math.random(1, #tets)
    tet = tets[tetIdx]:copy()
    tet:moveTo(xGridInit, yGridInit)
    tet:add()
end

function setupGame()
    math.randomseed(pd.getSecondsSinceEpoch())

    tets = loadTets()
    grid = Grid(kGridWidth, kGridHeight)

    wall1 = gfx.sprite
                .addEmptyCollisionSprite(0, -wallSize, kLCDWidth, wallSize)
    wall2 = gfx.sprite.addEmptyCollisionSprite(0, kLCDHeight, kLCDWidth,
                                               wallSize)
    floor = gfx.sprite.addEmptyCollisionSprite(kLCDWidth, 0, wallSize,
                                               kLCDHeight)

    setupGridCollision(wall1)
    setupGridCollision(wall2)
    setupGridCollision(floor)

    setupTet()
end

setupGame()

function pd.update()
    if pd.buttonJustPressed(pd.kButtonLeft) then
        tet:moveBy(-1, 0)
    elseif pd.buttonJustPressed(pd.kButtonRight) then
        local _, len = tet:checkCollisionsBy(1, 0)
        if len == 0 then
            tet:moveBy(1, 0)
        else
            grid:addBlocks(tet:getBlocks())
            setupTet()
        end
    elseif pd.buttonJustPressed(pd.kButtonUp) then
        local _, len = tet:checkCollisionsBy(0, -1)
        if len == 0 then
            tet:moveBy(0, -1)
        end
    elseif pd.buttonJustPressed(pd.kButtonDown) then
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
