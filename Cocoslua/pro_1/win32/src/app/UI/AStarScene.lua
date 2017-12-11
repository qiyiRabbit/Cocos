local MainScene = class("MainScene", cc.load("mvc").ViewBase)
local GridNode = import("app.UI.GridNode")
local num = 0
function MainScene:onCreate()

    self:Event()
    self:CreateMap()
    self:CreateGold(StartGold)
    self:CreateGold(EndGold)

    -- StartGold.node:setVisible(false)

    self:setObstacle()

    self:setFirstClose()

    self.isWhile = false
    self.isFirst = false
    local function update(time)
        if not self.isWhile then
            self.isWhile = self:setPath()
            -- self:setPathColor()
        else
            -- if not self.isFirst then
            --     self.isFirst = true
            --     self:setPathList()
            --     self:setPathColor2()
            -- end
            
        end
    end
    -- self:scheduleUpdate(update)
    -- self:schedule(update , 0 , 0 , 5)

    -- self.isWhile = self:setPath()
    -- self:setPathColor()

    while not self.isWhile do
        self.isWhile = self:setPath()
    end
    -- self:setPathColor()
    self:setPathList2()
    self:setPathColor2()

    -- print(#CloseList.node)
    -- for k,v in pairs(CloseList.node) do
    -- for k,v in pairs(PathList) do
    --     -- if v.F == 0 then
    --         print(k,"["..v.X,v.Y.."]","G="..v.G,"H="..v.H,"F="..v.F , "P=".."["..v.P.X,v.P.Y.."]")
    --     -- end
    -- end

end
--创建地图
function MainScene:CreateMap()
    for i = 1 , 8 do
        TileList.node[i] = {}
        for j = 1 , 8 do
            local gridNode = GridNode:create("kuai.png")
            gridNode:setScale(0.2)
            gridNode:setPosition(38 + 35 *(i - 1) , 120+ 35 *(j - 1))
            self:addChild(gridNode)
            gridNode.X = i
            gridNode.Y = j
            -- gridNode.type = KUALTYPE.NORMAL
            -- gridNode:setGridColor()

            table.insert(TileList.node[i] , gridNode)
        end
    end

    self:setNormal()
end
--创建主角和目标
function MainScene:CreateGold(GoldTable)
    GoldTable.node = GridNode:create("kuai.png")
    GoldTable.node:setScale(0.2)
    self:addChild(GoldTable.node)
    self:setGold(GoldTable)
    return GoldTable
end

--设置主角和目标位置
function MainScene:setGold(GoldTable)
    GoldTable.node.type = GoldTable.type
    GoldTable.node:setGridColor()
    GoldTable.node:setPosition(TileList.node[GoldTable.tilePos.x][GoldTable.tilePos.y]:getPosition())
    self:setGoldTable(GoldTable)
end

--设置地块颜色
function MainScene:setNormal()
    for i = 1 , 8 do
        for j = 1 , 8 do
            TileList.node[i][j].M = 10
            TileList.node[i][j].type = KUALTYPE.NORMAL
            TileList.node[i][j]:setGridColor()
        end
    end
end
--设置障碍物颜色
function MainScene:setObstacle()
    for k,v in pairs(Obstacle.tilePos) do
        TileList.node[v.x][v.y].M = 20
        TileList.node[v.x][v.y].type = KUALTYPE.OBSTACLE
        TileList.node[v.x][v.y]:setGridColor()
    end
end

--设置主角和目标类型
function MainScene:setGoldTable(GoldTable)
    TileList.node[GoldTable.tilePos.x][GoldTable.tilePos.x].M = 20
    TileList.node[GoldTable.tilePos.x][GoldTable.tilePos.x].type = GoldTable.type
        -- TileList.node[GoldTable.tilePos.x][GoldTable.tilePos.xj]:setGridColor()
end

function MainScene:Event()
    --抬起键盘
    local function onKeyReleased(keyCode, event)
        --a-124,d-127,w-146,s-142,j-133,k-134,l-135,i-132
         if keyCode==124 then
            norGoldList = {}
            for i = 1 , 8 do
                for j = 1 , 8 do
                    if TileList.node[i][j].type == KUALTYPE.NORMAL then
                        table.insert(norGoldList , TileList.node[i][j])
                        -- print(TileList.node[i][j].type)
                    end
                end
            end

            StartGold.tilePos = {["x"] = 2 , ["y"] = 2}
            self:setNormal()
            self:setObstacle()
            self:setGold(StartGold)
            
            local normal = norGoldList[math.random(1,#norGoldList)]
            local xx = normal.X
            local yy = normal.Y
            EndGold.tilePos = {["x"] = xx,["y"]=yy}
            self:setGold(EndGold)
            
            CloseList.node = {}
            PathList = {}
            -- self.isWhile = true
            self.isWhile = false
            num = 0
            self.isFirst = false

            -- while not self.isWhile do
            --     self.isWhile = self:setPath()
            -- end
            -- -- self:setPathColor()
            -- self:setPathList2()
            -- self:setPathColor2()
        end
    end
    --注册键盘事件
    local listener = cc.EventListenerKeyboard:create()
    -- listener:registerScriptHandler(onKeyPressed, cc.Handler.EVENT_KEYBOARD_PRESSED )
    listener:registerScriptHandler(onKeyReleased, cc.Handler.EVENT_KEYBOARD_RELEASED )
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
end


--查找最优路径
function MainScene:setPathList()
    -- local num = 0
    -- while (CloseList.node[#CloseList.node - num].P.X ~= StartGold.tilePos.x or CloseList.node[#CloseList.node - num].P.Y ~= StartGold.tilePos.y) do
    --     table.insert(PathList , CloseList.node[#CloseList.node - num])
    --     num = num + 1
    -- end

    
    while (#CloseList.node > 0 and CloseList.node[#CloseList.node - num] and (CloseList.node[#CloseList.node - num].P.X ~= StartGold.tilePos.x or CloseList.node[#CloseList.node - num].P.Y ~= StartGold.tilePos.y)) do
        for k,v in pairs(CloseList.node) do
            -- print(v.type)
            if v.X == CloseList.node[#CloseList.node - num].P.X and v.Y == CloseList.node[#CloseList.node - num].P.Y then
                table.insert(PathList , v)
            end
        end
        num = num + 1
    end

    for k1,v1 in pairs(CloseList.node) do
        if (v1.X == StartGold.tilePos.x and v1.Y == StartGold.tilePos.y) or (v1.X == EndGold.tilePos.x and v1.Y == EndGold.tilePos.y) then
            table.insert(PathList , v1)
        end
    end

    --排序
    local function _sort(a,b)
        return a.G < b.G
    end
    table.sort(PathList ,_sort)
end

--查找最优路径
function MainScene:setPathList2()
    -- local num = 0
    -- while (CloseList.node[#CloseList.node - num].P.X ~= StartGold.tilePos.x or CloseList.node[#CloseList.node - num].P.Y ~= StartGold.tilePos.y) do
    --     table.insert(PathList , CloseList.node[#CloseList.node - num])
    --     num = num + 1
    -- end

    while (CloseList.node[#CloseList.node - num].P.X ~= StartGold.tilePos.x or CloseList.node[#CloseList.node - num].P.Y ~= StartGold.tilePos.y) do
        for k,v in pairs(CloseList.node) do
            -- print(v.type)
            if v.X == CloseList.node[#CloseList.node - num].P.X and v.Y == CloseList.node[#CloseList.node - num].P.Y then
                table.insert(PathList , v)
            end
        end
        num = num + 1
    end

    -- while (CloseList.node[#CloseList.node - num].X ~= StartGold.tilePos.x or CloseList.node[#CloseList.node - num].Y ~= StartGold.tilePos.y) do
    --     -- for k,v in pairs(CloseList.node) do
    --         -- if v.X == CloseList.node[#CloseList.node - num].P.X and v.Y == CloseList.node[#CloseList.node - num].P.Y then
    --             table.insert(PathList , CloseList.node[#CloseList.node - num])
    --         -- end
    --     -- end
    --     num = num + 1
    -- end

    -- for k,v in pairs(CloseList.node) do
    --     if v.P.X > 0 and v.P.Y > 0 and (v.P.X ~= StartGold.tilePos.x or v.P.Y ~= StartGold.tilePos.y) then
    --          table.insert(PathList , v)
    --     end
    -- end

    for k1,v1 in pairs(CloseList.node) do
        if (v1.X == StartGold.tilePos.x and v1.Y == StartGold.tilePos.y) or (v1.X == EndGold.tilePos.x and v1.Y == EndGold.tilePos.y) then
            table.insert(PathList , v1)
        end
    end

    --排序
    local function _sort(a,b)
        return a.G < b.G
    end
    table.sort(PathList ,_sort)

    -- print(#CloseList.node , #PathList)
end

--显示路径
function MainScene:setPathColor()
    for k,v in pairs(CloseList.node) do
        v.type = KUALTYPE.PATN
        v:setGridColor()
    end
end

--显示路径2
function MainScene:setPathColor2()
    for k,v in pairs(PathList) do
        v.type = KUALTYPE.PATN
        v:setGridColor()
        -- print(k,v.X , v.Y , v.P.X , v.P.Y)
    end
    -- TileList.node[2][1]:setVisible(false)
    -- CloseList.node[#CloseList.node]:setScale(1)
end

function MainScene:setFirstClose()
    local tile = StartGold.tilePos
    table.insert(GoldList , TileList.node[tile.x][tile.y])

    TileList.node[tile.x][tile.y].G = 0
    TileList.node[tile.x][tile.y].H = 0
    TileList.node[tile.x][tile.y].F = 0
    TileList.node[tile.x][tile.y].P = { ["X"] = 0 , ["Y"] = 0}
    -- TileList.node[tile.x][tile.y].type = KUALTYPE.START
    -- self:setGoldF(TileList.node[tile.x][tile.y] , StartGold.node.G + 1 , tile)
    -- table.insert(CloseList.node , TileList.node[tile.x][tile.y])
end

function MainScene:setPath()

    while #GoldList > 0 do
        -- print(self.isPath , #GoldList)
        
        table.insert(CloseList.node , GoldList[1])
        GoldList[1].type = KUALTYPE.PATN
        table.remove(GoldList , 1)

        local tile = CloseList.node[#CloseList.node]
        for i =-1 , 1 do
            for j =-1 , 1 do
                if math.abs(i) + math.abs(j) > 0 and math.abs(i) ~= math.abs(j) then
                    if tile.X + i ~= 0 and tile.Y + j ~= 0 and tile.X + i ~= 9 and tile.Y + j ~= 9  then
                        if TileList.node[tile.X + i][tile.Y + j].type ~= KUALTYPE.OBSTACLE and 
                            -- TileList.node[tile.X + i][tile.Y + j].type ~= KUALTYPE.END and 
                            TileList.node[tile.X + i][tile.Y + j].type ~= KUALTYPE.PATN then
                            if not self:isListHaveGold(OpenList , tile.X + i , tile.Y + j ) then
                                TileList.node[tile.X + i][tile.Y + j].X = tile.X + i
                                TileList.node[tile.X + i][tile.Y + j].Y = tile.Y + j
                                if not self:isListHaveGold(OpenList , tile.X + i , tile.Y + j ) then
                                    -- self:setGoldF(TileList.node[tile.X + i][tile.Y + j] , StartGold.node.G + 1 , tile)
                                    self:setGoldF(TileList.node[tile.X + i][tile.Y + j] , TileList.node[tile.X][tile.Y].G + 0.1 , tile)
                                    table.insert(OpenList.node , TileList.node[tile.X + i][tile.Y + j])
                                end
                            else
                                self:setGoldF({["X"] = tile.X + i , ["Y"] = tile.Y + j} , nil , tile)
                            end  
                            -- print(tile.X + i , tile.Y + j)
                        -- elseif TileList.node[tile.X + i][tile.Y + j].type == KUALTYPE.END then
                        --     -- print("22222")
                        --     return true                     
                        end
                    end
                end
            end
        end
    end


    

    --排序
    local function _sort(a,b)
        return a.F < b.F
    end
    table.sort(OpenList.node ,_sort)

    -- CloseList.node = OpenList.node

    GoldList = {}
    -- print("##--------------##",#OpenList.node )
    -- for n , m in pairs(OpenList.node) do
    --     print(n,m.X,m.Y,m.G,m.H,m.F)
    -- end

    self.first = 0
    for k , v in pairs(OpenList.node) do
        -- if k == 1 then
        --     self.first = OpenList.node[1].F
        -- end

        if k == 1 then
            -- table.insert(CloseList.node , v)
            table.insert(GoldList , v)
            table.remove(OpenList.node , k)
            -- v.type = KUALTYPE.PATN
        elseif k ~= 1 and v.F == GoldList[1].F then
            -- table.insert(CloseList.node , v)
            table.insert(GoldList , v)
            table.remove(OpenList.node , k)
            -- v.type = KUALTYPE.PATN
        end
        -- print(k,v.X,v.Y,v.G,v.H,v.F , GoldList[1].F , #OpenList.node)
    end

    if #OpenList.node == 1 and OpenList.node[1].F == GoldList[1].F then
        table.insert(GoldList , OpenList.node[1])
        table.remove(OpenList.node , 1)
        -- OpenList.node[1].type = KUALTYPE.PATN
    end

    -- for k5,v5 in pairs(OpenList.node) do
    --     if v5.type == KUALTYPE.PATN then
    --         table.remove(OpenList.node , k5)
    --     end
    -- end

    -- for k2,v2 in pairs(GoldList) do
        -- print(v2.X,v2.Y,v2.G,v2.H,v2.F)
        -- print(k2 , v2.F , GoldList[1].F)
    -- end

    -- table.insert(CloseList.node , GoldList[math.random(1 , #GoldList)])

    -- print("###",#GoldList , #OpenList.node , #CloseList.node)
    -- for k2,v2 in pairs(CloseList.node) do
    --     print(v2.X,v2.Y,v2.G,v2.H,v2.F)
    -- end
    -- print("##################",EndGold.tilePos.x , EndGold.tilePos.y ,self:isListHaveGold(CloseList , EndGold.tilePos.x , EndGold.tilePos.y ))
    return self:isListHaveGold(CloseList , EndGold.tilePos.x , EndGold.tilePos.y )
end

function MainScene:isListHaveGold(List , x , y )
    for k,v in pairs(List.node) do
        if v.X == x and v.Y == y then
            return true
        end
    end
    return false
end

function MainScene:setGoldF(tile,goldG , parentPos)
    local _goldG = (goldG and type(goldG) == "number") and goldG or (TileList.node[tile.X][tile.Y].G + 1)
    TileList.node[tile.X][tile.Y].G = _goldG--StartGold.node.G
    TileList.node[tile.X][tile.Y].H = self:computeH(tile.X,tile.Y) 
    TileList.node[tile.X][tile.Y].F = self:computeF(TileList.node[tile.X][tile.Y].G , TileList.node[tile.X][tile.Y].H)
    TileList.node[tile.X][tile.Y].P = { ["X"] = parentPos.X , ["Y"] = parentPos.Y}
end

-- --查找路径
-- function MainScene:setPath()
--     local tile = StartGold.tilePos
--     --判断是否查找到终点目标
--     if tile.x == EndGold.tilePos.x and tile.y == EndGold.tilePos.y then
--         return false
--     end
--     -- print("=============================")
--     StartGold.node.G = self:computeG()
--     for i =-1 , 1 do
--         for j =-1 , 1 do
--             -- if math.abs(i) + math.abs(j) > 0 then
--             if math.abs(i) + math.abs(j) > 0 and math.abs(i) ~= math.abs(j) then
--                 if tile.x + i ~= 0 and tile.y + j ~= 0 and tile.x + i ~= 9 and tile.y + j ~= 9  then
--                     if TileList.node[tile.x + i][tile.y + j].type ~= KUALTYPE.OBSTACLE and TileList.node[tile.x + i][tile.y + j].type ~= KUALTYPE.START then
--                         if not self:isHaveGold(tile.x + i,tile.y + j) then
--                             TileList.node[tile.x + i][tile.y + j].X = tile.x + i
--                             TileList.node[tile.x + i][tile.y + j].Y = tile.y + j
--                             TileList.node[tile.x + i][tile.y + j].G = StartGold.node.G
--                             TileList.node[tile.x + i][tile.y + j].H = self:computeH(tile.x + i,tile.y + j) --* TileList.node[tile.x + i][tile.y + j].M
--                             TileList.node[tile.x + i][tile.y + j].F = self:computeF(TileList.node[tile.x + i][tile.y + j].G , TileList.node[tile.x + i][tile.y + j].H)
--                             table.insert(OpenList.node , TileList.node[tile.x + i][tile.y + j])
--                             -- print("###55555##>>>>",tile.x + i,tile.y + j)
--                         end
--                     end
--                 end 
--             end
--         end
--     end

--     --排序
--     local function _sort(a,b)
--         return a.F < b.F
--     end
--     table.sort(OpenList.node ,_sort)

--     --筛选F值最小的值,且存放到CloseList表中
--     for k = 1 , #OpenList.node do
--         local v = OpenList.node[k]
--         if k > 1 then
--             if OpenList.node[1] == v then
--                 table.insert(self.list , v)
--             end
--         else
--             self.list = {}
--             table.insert(self.list , OpenList.node[1])
--         end
--         -- print(v.X , v.Y , v.G,v.H , v.F)
--     end

--     --将其筛选的最佳对象存放到CloseList表中
--     if #self.list > 1 then
--         table.insert(CloseList.node , OpenList.node[math.random(1,#self.list)])
--     else
--         table.insert(CloseList.node , OpenList.node[1])
--     end

--     --清除筛选最佳位置的缓存
--     OpenList.node = {}
--     -- table.remove(OpenList.node  , 1)

--     --将最佳位置坐标赋值给开始位置坐标，以便下次查找
--     StartGold.tilePos = {["x"] = CloseList.node[#CloseList.node].X , ["y"] = CloseList.node[#CloseList.node].Y}
--     print(#self.list)
--     return true
-- end

-- --检测是否走过的坐标
-- function MainScene:isHaveGold(X,Y)
--     for k,v in pairs(CloseList.node) do
--         if X == v.X and Y == v.Y then
--             return true
--         end
--     end
--     return false
-- end


--生成路径

--计算G值
function MainScene:computeG()
    return StartGold.node.G + 1
end
--计算H值
function MainScene:computeH(x,y)
    return math.abs (EndGold.tilePos.x - x) + math.abs (EndGold.tilePos.y - y)
end
--计算F值
function MainScene:computeF(G,H)
    return math.abs (G) + math.abs (H)
end
return MainScene