class("Grid").extends(Object)

function setupGridCollision(sprite)
    sprite:setGroups({kGroupGrid})
    sprite:setCollidesWithGroups({kGroupTet})
end

function Grid:init(w, h)
    self.w = w
    self.h = h
    self.sprites = table.create(w * h, 0)
end

function Grid:index(x, y)
    return x * self.h + y + 1
end

function Grid:addBlocks(xGrid, yGrid, blocks)
    for _, block in ipairs(blocks) do
        local x = xGrid + block.xTet
        local y = yGrid + block.yTet
        local i = self:index(x, y)
        local sprite = block.sprite
        setupGridCollision(sprite)
        self.sprites[i] = sprite
    end
end
