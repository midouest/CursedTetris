import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

local pd<const> = playdate
local gfx<const> = pd.graphics

local fontPath<const> = "/System/Fonts/Asheville-Sans-14-Bold.pft"
local font = nil

function setupGame()
    font = gfx.font.new(fontPath)
end

setupGame()

local textWidth<const> = 86
local textHeight<const> = 16

local x = (400 - textWidth) / 2
local y = (240 - textHeight) / 2
local dx = 1
local dy = 2

function pd.update()
    gfx.clear(gfx.kColorWhite)
    gfx.setFont(font)
    gfx.drawText("Hello World!", x, y)

    x = x + dx
    y = y + dy

    if x < 0 or x > (400 - textWidth) then
        dx = -dx
    end

    if y < 0 or y > 240 - textHeight then
        dy = -dy
    end

    pd.drawFPS(0, 0)
end
