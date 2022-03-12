class("Block").extends(Object)

function Block:init(xTet, yTet, sprite)
    self.xTet = xTet
    self.yTet = yTet
    self.sprite = sprite
end

function Block:copy()
    return Block(self.xTet, self.yTet, self.sprite:copy())
end

function Block:add()
    self.sprite:add()
end

function Block:remove()
    self.sprite:remove()
end

function Block:gridToScreen(xGrid, yGrid)
    local x = xGrid * kSpriteSize + self.xTet * kSpriteSize
    local y = yGrid * kSpriteSize + self.yTet * kSpriteSize
    return x, y
end

function Block:checkCollisions(xGrid, yGrid)
    local x, y = self:gridToScreen(xGrid, yGrid)
    _, _, collisions, length = self.sprite:checkCollisions(x, y)
    return collisions, length
end

function Block:moveTo(xGrid, yGrid)
    local x, y = self:gridToScreen(xGrid, yGrid)
    self.sprite:moveTo(x, y)
end

function Block:isOverlapping()
    local sprites = self.sprite:overlappingSprites()
    return #sprites > 0
end
