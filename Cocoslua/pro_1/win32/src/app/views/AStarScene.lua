local MainScene = class("MainScene", cc.load("mvc").ViewBase)
local GridNode = import("app.UI.GridNode")

function MainScene:onCreate()

    self:Event()
    self:CreateMap()
    self:CreateGold(StartGold)
    self:CreateGold(EndGold)
    self:setObstacle()
    self:setStartGold()

    --方法1
    self.isWhile = false
    self.num = 0
    local function update(time)
        if not self.isWhile then
            self.isWhile = self:setPath()
            -- self:setPathColor(CloseList.node)
        else
                self:setPathList()
                self:setPathColor(PathList)
        end
        -- print(self.isWhile)
    end
    self:scheduleUpdate(update)

    --方法2
    -- while not self.isWhile do
    --     self.isWhile = self:setPath()
    -- end
    -- -- self:setPathColor(CloseList.node)
    -- self:setPathList()
    -- self:setPathColor(PathList)

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
            -- TileList.node[i][j].M = 10
            TileList.node[i][j].type = KUALTYPE.NORMAL
            TileList.node[i][j]:setGridColor()
        end
    end
end
--设置障碍物颜色
function MainScene:setObstacle()
    for k,v in pairs(Obstacle.tilePos) do
        -- TileList.node[v.x][v.y].M = 20
        TileList.node[v.x][v.y].type = KUALTYPE.OBSTACLE
        TileList.node[v.x][v.y]:setGridColor()
    end
end

--设置主角和目标类型
function MainScene:setGoldTable(GoldTable)
    -- TileList.node[GoldTable.tilePos.x][GoldTable.tilePos.x].M = 20
    TileList.node[GoldTable.tilePos.x][GoldTable.tilePos.x].type = GoldTable.type
end

function MainScene:Event()
    --抬起键盘
    local function onKeyReleased(keyCode, event)
        --a-124,d-127,w-146,s-142,j-133,k-134,l-135,i-132
         if keyCode==124 then
            norGoldList = {}
            CloseList.node = {}
            OpenList.node = {}
            GoldList = {}
            PathList = {}

            --重新更新所有格子坐标
            self:setNormal()
            --重新更新障碍物格子坐标
            self:setObstacle()
            --重新更新开始格子属性
            self:setStartGold()
            --重新更新开始格子位置
            self:setGold(StartGold)

            --搜索出全部普通格子
            for i = 1 , 8 do
                for j = 1 , 8 do
                    print(TileList.node[i][j].type)
                    if TileList.node[i][j].type == KUALTYPE.NORMAL then
                        table.insert(norGoldList , TileList.node[i][j])
                    end
                end
            end
            
            --随机一个普通格子
            local normal = norGoldList[math.random(1,#norGoldList)]
            local xx = normal.X
            local yy = normal.Y
            EndGold.tilePos = {["x"] = xx,["y"]=yy}

            --重新更新目标格子位置
            self:setGold(EndGold)
            
            --重置变量
            self.isWhile = false
            self.num = 0
        end
    end
    --注册键盘事件
    local listener = cc.EventListenerKeyboard:create()
    -- listener:registerScriptHandler(onKeyPressed, cc.Handler.EVENT_KEYBOARD_PRESSED )
    listener:registerScriptHandler(onKeyReleased, cc.Handler.EVENT_KEYBOARD_RELEASED )
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
end


--查找最优路径方法1
function MainScene:setPathList()
    
    while (#CloseList.node > 0 and CloseList.node[#CloseList.node - self.num] and (CloseList.node[#CloseList.node - self.num].P.X ~= StartGold.tilePos.x or CloseList.node[#CloseList.node - self.num].P.Y ~= StartGold.tilePos.y)) do
        for k,v in pairs(CloseList.node) do
            -- print(v.type)
            if v.X == CloseList.node[#CloseList.node - self.num].P.X and v.Y == CloseList.node[#CloseList.node - self.num].P.Y then
                table.insert(PathList , v)
            end
        end
        self.num = self.num + 1
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

-- --查找最优路径方法2
-- function MainScene:setPathList2()
--     while (CloseList.node[#CloseList.node - num].P.X ~= StartGold.tilePos.x or CloseList.node[#CloseList.node - num].P.Y ~= StartGold.tilePos.y) do
--         for k,v in pairs(CloseList.node) do
--             -- print(v.type)
--             if v.X == CloseList.node[#CloseList.node - num].P.X and v.Y == CloseList.node[#CloseList.node - num].P.Y then
--                 table.insert(PathList , v)
--             end
--         end
--         num = num + 1
--     end

--     for k1,v1 in pairs(CloseList.node) do
--         if (v1.X == StartGold.tilePos.x and v1.Y == StartGold.tilePos.y) or (v1.X == EndGold.tilePos.x and v1.Y == EndGold.tilePos.y) then
--             table.insert(PathList , v1)
--         end
--     end

--     --排序
--     local function _sort(a,b)
--         return a.G < b.G
--     end
--     table.sort(PathList ,_sort)

--     -- print(#CloseList.node , #PathList)
-- end

--显示路径
function MainScene:setPathColor(list)
    for k,v in pairs(list) do
        v.type = KUALTYPE.PATN
        v:setGridColor()
    end
end

function MainScene:setStartGold()
    local tile = StartGold.tilePos
    table.insert(GoldList , TileList.node[tile.x][tile.y])

    TileList.node[tile.x][tile.y].G = 0
    TileList.node[tile.x][tile.y].H = 0
    TileList.node[tile.x][tile.y].F = 0
    TileList.node[tile.x][tile.y].P = { ["X"] = 0 , ["Y"] = 0}
end

--路径数据
function MainScene:setPath()
    while #GoldList > 0 do
        --对筛选的格子进行全部存储
        table.insert(CloseList.node , GoldList[1])
        GoldList[1].type = KUALTYPE.PATN
        table.remove(GoldList , 1)

        --对下一个格子进行继续筛选四周格子数据
        local tile = CloseList.node[#CloseList.node]
        for i =-1 , 1 do
            for j =-1 , 1 do
                if math.abs(i) + math.abs(j) > 0 and math.abs(i) ~= math.abs(j) then
                    if tile.X + i ~= 0 and tile.Y + j ~= 0 and tile.X + i ~= 9 and tile.Y + j ~= 9  then
                        if TileList.node[tile.X + i][tile.Y + j].type ~= KUALTYPE.OBSTACLE and 
                            TileList.node[tile.X + i][tile.Y + j].type ~= KUALTYPE.PATN then
                            if not self:isListHaveGold(OpenList , tile.X + i , tile.Y + j ) then
                                TileList.node[tile.X + i][tile.Y + j].X = tile.X + i
                                TileList.node[tile.X + i][tile.Y + j].Y = tile.Y + j
                                if not self:isListHaveGold(OpenList , tile.X + i , tile.Y + j ) then
                                    self:setGoldF(TileList.node[tile.X + i][tile.Y + j] , TileList.node[tile.X][tile.Y].G , tile)--StartGold.node.G 
                                    table.insert(OpenList.node , TileList.node[tile.X + i][tile.Y + j])
                                end
                            else
                                self:setGoldF({["X"] = tile.X + i , ["Y"] = tile.Y + j} , nil , tile)
                            end               
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

    --存储格子四周的格子坐标
    GoldList = {}
    for k , v in pairs(OpenList.node) do
        if k == 1 then
            table.insert(GoldList , v)
            table.remove(OpenList.node , k)
        elseif k ~= 1 and v.F == GoldList[1].F then
            table.insert(GoldList , v)
            table.remove(OpenList.node , k)
        end
    end

    --存储剩下的一个坐标数据
    if #OpenList.node == 1 and OpenList.node[1].F == GoldList[1].F then
        table.insert(GoldList , OpenList.node[1])
        table.remove(OpenList.node , 1)
    end
    return self:isListHaveGold(CloseList , EndGold.tilePos.x , EndGold.tilePos.y )
end

--判断是否已经有该坐标
function MainScene:isListHaveGold(List , x , y )
    for k,v in pairs(List.node) do
        if v.X == x and v.Y == y then
            return true
        end
    end
    return false
end

--计算F = G + H
function MainScene:setGoldF(tile,goldG , parentPos)
    local _goldG = (goldG and type(goldG) == "number") and goldG or (TileList.node[tile.X][tile.Y].G + 1)
    TileList.node[tile.X][tile.Y].G = self:computeG(_goldG)
    TileList.node[tile.X][tile.Y].H = self:computeH(tile.X,tile.Y) 
    TileList.node[tile.X][tile.Y].F = self:computeF(TileList.node[tile.X][tile.Y].G , TileList.node[tile.X][tile.Y].H)
    TileList.node[tile.X][tile.Y].P = { ["X"] = parentPos.X , ["Y"] = parentPos.Y}
end

--计算G值
function MainScene:computeG(G)
    return G + 0.1  --StartGold.node.G
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