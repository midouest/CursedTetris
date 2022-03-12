class("Tet").extends(Object)

function Tet:init(xGrid, yGrid, rots, rotIdx)
    self.xGrid = xGrid
    self.yGrid = yGrid
    self.rots = rots
    self.rotIdx = rotIdx or 1
    self.rot = self.rots[self.rotIdx]
end

function Tet:copy()
    local rots = table.create(#self.rots, 0)
    for i, rot in ipairs(self.rots) do
        rots[i] = rot:copy()
    end
    return Tet(self.xGrid, self.yGrid, rots, self.rotIdx)
end

function Tet:getBlocks()
    return self.xGrid, self.yGrid, self.rot:getBlocks()
end

function Tet:add()
    self.rot:add()
end

function Tet:remove()
    self.rot:remove()
end

function Tet:checkCollisionsBy(dXGrid, dYGrid)
    return self:checkCollisions(self.xGrid + dXGrid, self.yGrid + dYGrid)
end

function Tet:checkCollisions(xGrid, yGrid)
    return self.rot:checkCollisions(xGrid, yGrid)
end

function Tet:moveBy(dXGrid, dYGrid)
    self:moveTo(self.xGrid + dXGrid, self.yGrid + dYGrid)
end

function Tet:moveTo(xGrid, yGrid)
    self.xGrid = xGrid
    self.yGrid = yGrid
    self.rot:moveTo(xGrid, yGrid)
end

function Tet:rotateIndex(clockwise)
    local delta = clockwise and 1 or -1
    local rotIdx = self.rotIdx + delta
    if rotIdx < 1 then
        rotIdx = #self.rots
    elseif rotIdx > #self.rots then
        rotIdx = 1
    end
    return rotIdx
end

function Tet:isOverlapping()
    return self.rot:isOverlapping()
end

function Tet:checkRotateOverlaps(clockwise)
    local nextRotIdx = self:rotateIndex(clockwise)
    if nextRotIdx == self.rotIdx then
        return {}, 0
    end

    local rot = self.rots[nextRotIdx]
    rot:moveTo(self.xGrid, self.yGrid)
    rot:add()
    local overlapping = rot:isOverlapping()
    rot:remove()
    return overlapping
end

function Tet:rotate(clockwise)
    local nextRotIdx = self:rotateIndex(clockwise)
    if nextRotIdx == self.rotIdx then
        return
    end

    self.rot:remove()

    self.rotIdx = nextRotIdx
    self.rot = self.rots[self.rotIdx]
    self.rot:moveTo(self.xGrid, self.yGrid)
    self.rot:add()
end
