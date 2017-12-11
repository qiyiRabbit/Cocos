
local MainScene = class("MainScene", cc.load("mvc").ViewBase)
local visibleSize=cc.Director:getInstance():getVisibleSize()
local actionData=require("app.views.Data")
function MainScene:onCreate()
    self.data={}
    self.nodeTable={}
    self.nodeTables={}

    self:Event()
    self:createObject("","player","players",cc.p(100,100))                      

    for i=1,3 do
        local enemy=string.format("enemys_%d",i)
        self:createObject("","enemy_1",enemy,cc.p(140+50*(i-1),115))   
        self:playAnimate ("",enemy,"stand")
    end

    -- local enemy_1Box=self:getObjectData("","enemys_1")[2]
    -- self:setObjectData("","box2",enemy_1Box)


        -- local box2=cc.LayerColor:create(cc.c4b(90,90,90,255))
        -- self:addChild(box2,2)
        -- box2:setContentSize(cc.size(25,30));
        -- box2:setAnchorPoint(cc.p(0.5,0.5))  --0.43
        -- box2:setPosition(cc.p(140,115))
        -- box2:setVisible(true)
        -- self:setObjectData("","box2",box2)

end

function MainScene:Event()
    --按下键盘
    local function onKeyPressed(keyCode, event)
        --a-124,d-127,w-146,s-142,j-133,k-134,l-135,i-132
        if keyCode==124 then
            self:moveOfDirection(-1)
            -- self:playAnimate ("","players","walk")
        end
        if keyCode==127 then
            self:moveOfDirection(1)
            -- self:playAnimate ("","players","walk")
        end
        if keyCode==133 then
            self:playAnimate ("","players","attack1")
            self.boundingBoxs=self:boundingBox("players","palyerBoundingBox","create",30)           --创建碰撞盒--1、主角标签，2、主角包围盒标签，3、创建或删除标签，4、为碰撞盒X位置
            self:collisionDetection("palyerBoundingBox","enemys_1")
        end
    end
    --抬起键盘
    local function onKeyReleased(keyCode, event)
        self:stopAnimate ("","players","stand")
        if keyCode==133 then
            self.boundingBoxs=self:boundingBox("players","palyerBoundingBox","remove",nil)            --删除碰撞盒
        end
    end
    --注册键盘事件
    self:keyEventDispatcher(onKeyPressed,onKeyReleased)
end

--注册键盘事件
function MainScene:keyEventDispatcher(onKeyPressed,onKeyReleased)
    --注册键盘事件
    local listener = cc.EventListenerKeyboard:create()
    listener:registerScriptHandler(onKeyPressed, cc.Handler.EVENT_KEYBOARD_PRESSED )
    listener:registerScriptHandler(onKeyReleased, cc.Handler.EVENT_KEYBOARD_RELEASED )
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
end
--移动及朝向
function MainScene:moveOfDirection(dir)
    self:setObjectData("","direction",dir)                              --存储人物朝向
    local players=self:getObjectData("","players")[2]
    players:setScaleX(dir) 
end
--碰撞检测
function MainScene:collisionDetection(boundingBox,nodeBox)
    local palyerBoundingBox=self:getObjectData("",boundingBox)
    local playerBox=self:getObjectData("",nodeBox)[2]
    -- local playerBox=self:getObjectData("",nodeBox)
    if palyerBoundingBox and playerBox then
        print("开启碰撞检测")
        -- local palyerBoundingBoxRect=palyerBoundingBox:getBoundingBox()
        --获取对象碰撞盒的位置及大小并画出包围盒
        local pos=palyerBoundingBox:getParent():convertToWorldSpace(cc.p(palyerBoundingBox:getPosition()))      
        local size=palyerBoundingBox:getContentSize()
        local palyerBoundingBoxRect=cc.rect(pos.x,pos.y,size.width,size.height)
        --获取被碰撞的对象包围盒大小
        local playerBoxRect=playerBox:getBoundingBox()
        -- dump(palyerBoundingBoxRect)
        -- dump(playerBoxRect)
        if cc.rectContainsPoint(palyerBoundingBoxRect,playerBoxRect) then
            print("碰撞成功")
        end
    end
    -- if palyerBoundingBox and playerBox then
    --     print("开启")
    --     local palyerBoundingBoxRect=palyerBoundingBox:getBoundingBox()
    --     local playerBoxRect=playerBox:getBoundingBox()
    --     dump(palyerBoundingBoxRect)
    --     dump(playerBoxRect)
    --     if cc.rectContainsPoint(palyerBoundingBoxRect,playerBoxRect) then
    --         print("碰撞成功")
    --     end
    -- end
end
--攻击碰撞盒
function MainScene:boundingBox(node,nodeBox,state,attackPos)
    if self.box==nil and state=="create" then
        local playerBox=self:getObjectData("",node)[2]
        local dir=self:getObjectData("","direction") 
        self.box=cc.LayerColor:create(cc.c4b(75,75,125,255))
        playerBox:addChild(self.box,2)
        self.box:setContentSize(cc.size(15,20));
        self.box:setAnchorPoint(cc.p(0.5,0.5))  --0.43
        self.box:setPosition(cc.p(attackPos,15))
        -- self.box:setVisible(true)
        -- self.box:setZOrder(1000)
        self:setObjectData("",nodeBox,self.box) 
        return self.box
    elseif self.box~=nil and state=="remove" then
        self.box:removeSelf()
        self.box=nil
        self:setObjectData("",nodeBox,self.box) 
        return self.box
    end
end
--创建人物
function MainScene:createObject(tables,type,key,pos)--1、存放特殊表里--一般为“”,2、对象配表Key，3、对象标签，4、对象所在位置
    local actPlayer = actionData[type]
    local node,player = self:createNode(actPlayer,pos)
    self:setObjectData(tables,key,{actPlayer,node,player})
    self:setObjectData("","direction",1)                                    --存储初始化人物朝向
end
--初步创建人物节点
function MainScene:createNode(actPlayer,nodePos)
    local actNode = actPlayer["stand"]
    local actName = actNode[1]
    local sizeNode = actPlayer["sizeNode"]
    local anchorX = actPlayer["anchorX"]
    local pos = actPlayer["pos"]
    local scale = actPlayer["scale"]

    -- if self:getData(playerKey)~=nil then
    --     self:getData(playerKey):removeSelf()
    --     self:setData(playerKey,nil)
    -- end
    local node=cc.LayerColor:create(cc.c4b(255,255,0,255))
    self:addChild(node)
    node:setContentSize(sizeNode);
    node:setAnchorPoint(cc.p(anchorX,0))  --0.43
    node:setPosition(nodePos)
    local nameInit = string.format(actName,1)
    local player=cc.Sprite:create(nameInit)
    node:addChild(player)
    player:setPosition(pos)
    player:setAnchorPoint(cc.p(0.5,0))
    player:setScale(scale)
    -- self:setData("playerKey",player)
    return node,player
end
--播放动画
function MainScene:playAnimate(tables,key,animState)
    local playerData=self:getObjectData(tables,key)[1]
    -- local playerBox=self:getObjectData(tables,key)[2]
    local playerChild=self:getObjectData(tables,key)[3]
    self:playAction(playerChild,playerData,animState)
end
--播放序列
function MainScene:playAction(node,acNodeBase,act)
    node:stopAllActions()
    local actNode = acNodeBase[act]
    local actName = actNode[1]
    local actNum = actNode[2]
    local actTime = actNode[4]

    self.animation = cc.Animation:create()
    for i = 1, actNum do
        local name = string.format(actName,i)
        self.animation:addSpriteFrameWithFile(name)
    end
    self.animation:setDelayPerUnit(actTime)
    self.animation:setRestoreOriginalFrame(true)
    self.animation:setLoops(-1)
    local animate = cc.Animate:create(self.animation)
    self:setObjectData("","playersAima",self.animation)
    node:runAction(animate)
end
--停止动画
function MainScene:stopAnimate(tables,key,animState)
    local playerData=self:getObjectData(tables,key)[1]
    -- local playerBox=self:getObjectData(tables,key)[2]
    local playerChild=self:getObjectData(tables,key)[3]
    self:stopAction(playerChild)
end
--停止序列
function MainScene:stopAction(node)
    node:stopAllActions()
    self:playAnimate ("","players","stand")
end
--临时数据存储
function MainScene:setData(key,value)
    if value==nil then
        self.data[key]=key
    else
        self.data[key]=value
    end
end
function MainScene:getData(key)
    return self.data[key]
end
--临时数据存储
function MainScene:setObjectData(tables,key,value)
    if type(tables)=="table" then
        tables[key]=value
    else
        self.nodeTable[key]=value
    end       
end
function MainScene:getObjectData(tables,key)
    if type(tables)=="table" then
        return tables[key]
    else
        return self.nodeTable[key]
    end
end
return MainScene



-- local node,player = self:createObject(self.enemyTable,"enemy_1",cc.p(150+50*(i-1),100))