
local GridNode = class("GridNode",function(img)
    return cc.Sprite:create(img)
end)

function GridNode:ctor()
    self.type = KUALTYPE.NORMAL
    self.X = 0
    self.Y = 0
    self.F = 0
    self.G = 0
    self.H = 0
    self.M = 0
    self.P = {}
end

function GridNode:setGridColor()
    local switch = {
        [KUALTYPE.NORMAL] = function()
            self:setColor(cc.c3b(0,100,0))
        end,
        [KUALTYPE.OBSTACLE] = function()
            self:setColor(cc.c3b(255,0,0))
        end,
        [KUALTYPE.START] = function()
            self:setColor(cc.c3b(0,255,0))
        end,
        [KUALTYPE.END] = function()
            self:setColor(cc.c3b(0,0,255))
        end,
        [KUALTYPE.PATN] = function()
            self:setColor(cc.c3b(255,255,255))
        end,  
    }
    switch[self.type]()
end

return GridNode