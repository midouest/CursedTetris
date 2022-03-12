class("Rot").extends(Object)

function Rot:init(blocks)
    self.blocks = blocks
end

function Rot:copy()
    return Rot(self:getBlocks())
end

function Rot:getBlocks()
    local blocks = table.create(#self.blocks, 0)
    for i, block in ipairs(self.blocks) do
        blocks[i] = block:copy()
    end
    return blocks
end

function Rot:isOverlapping()
    for _, block in ipairs(self.blocks) do
        if block:isOverlapping() then
            return true
        end
    end
    return false
end

function Rot:add()
    for _, block in ipairs(self.blocks) do
        block:add()
    end
end

function Rot:remove()
    for _, block in ipairs(self.blocks) do
        block:remove()
    end
end

function Rot:checkCollisions(xGrid, yGrid)
    local allCollisions = {}
    local total = 0
    for _, block in ipairs(self.blocks) do
        local collisions, length = block:checkCollisions(xGrid, yGrid)
        total = total + length
        for _, collision in ipairs(collisions) do
            table.insert(allCollisions, collision)
        end
    end
    return allCollisions, total
end

function Rot:moveTo(xGrid, yGrid)
    for _, block in ipairs(self.blocks) do
        block:moveTo(xGrid, yGrid)
    end
end
