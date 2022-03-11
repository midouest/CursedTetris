class("Grid").extends(Object)

function setupGridCollision(sprite)
    sprite:setGroups({kGroupGrid})
    sprite:setCollidesWithGroups({kGroupTet})
end

function Grid:init(x, y, w, h)
    self.x = x
    self.y = y
    self.w = w
    self.h = h
    self.sprites = table.create(w * h, 0)
end

function Grid:remove()
    for i = 1, self.w * self.h do
        local sprite = self.sprites[i]
        if sprite ~= nil then
            sprite:remove()
        end
    end
end

function Grid:gridToIndex(x, y)
    return (y - self.y) * self.w + (x - self.x) + 1
end

function Grid:addBlocks(xGrid, yGrid, blocks)
    for _, block in ipairs(blocks) do
        local x = xGrid + block.xTet
        local y = yGrid + block.yTet
        local i = self:gridToIndex(x, y)
        local sprite = block.sprite
        setupGridCollision(sprite)
        self.sprites[i] = sprite
    end

    self:updateFilledRows()
end

function Grid:updateFilledRows()
    local i = 1
    local filledRows = {}
    local filledCount = 0
    for y = 1, self.h do
        local filled = true
        for _ = 1, self.w do
            if self.sprites[i] == nil then
                filled = false
            end
            i = i + 1
        end

        if filled then
            filledRows[y] = true
            filledCount = filledCount + 1
        end
    end

    if filledCount == 0 then
        return
    end

    for y, _ in pairs(filledRows) do
        for x = 1, self.w do
            local i = (y - 1) * self.w + x
            local sprite = self.sprites[i]
            sprite:remove()
            self.sprites[i] = nil
        end
    end

    local shiftDown = 0
    for y = self.h, 1, -1 do
        if filledRows[y] then
            shiftDown = shiftDown + 1
        elseif shiftDown > 0 then
            for x = 1, self.w do
                local i = (y - 1) * self.w + x
                local sprite = self.sprites[i]
                if sprite ~= nil then
                    self.sprites[i] = nil
                    sprite:moveBy(0, shiftDown * kSpriteSize)
                    local j = (y - 1 + shiftDown) * self.w + x
                    self.sprites[j] = sprite
                end
            end
        end
    end
end
