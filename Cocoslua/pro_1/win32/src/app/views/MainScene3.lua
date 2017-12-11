
local MainScene = class("MainScene", cc.load("mvc").ViewBase)
local visibleSize=cc.Director:getInstance():getVisibleSize()
local actionData=require("app.views.Data")
function MainScene:onCreate()
    self.data={}
    self.actPlayer=actionData["player"]
    self:setData("actData",self.actPlayer)
    self:playAction("stand",true)
    self:playMove("",false)
    self:Event()
end

function MainScene:Event()
    --按下键盘
    local function onKeyPressed(keyCode, event)
        --a-124,d-127,w-146,s-142,j-133,k-134,l-135,i-132
        self:KeyEvent(keyCode,124,"walk","left",true)
        self:KeyEvent(keyCode,127,"walk","right",true)
        self:KeyEvent(keyCode,146,"walk","up",true)
        self:KeyEvent(keyCode,142,"walk","down",true)
        self:KeyEvent(keyCode,133,"attack1",nil,true)
        self:KeyEvent(keyCode,134,"attack2",nil,true)
        self:KeyEvent(keyCode,135,"hit",nil,true)
        self:KeyEvent(keyCode,132,"die",nil,true)
    end
    --抬起键盘
    local function onKeyReleased(keyCode, event)
         self:KeyEvent(keyCode,0,"stand","",true)
    end
    --注册键盘事件
    local listener = cc.EventListenerKeyboard:create()
    listener:registerScriptHandler(onKeyPressed, cc.Handler.EVENT_KEYBOARD_PRESSED )
    listener:registerScriptHandler(onKeyReleased, cc.Handler.EVENT_KEYBOARD_RELEASED )
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
end
--动作事件
function MainScene:KeyEvent(keyCode,key,actState,moveState,openState)
    local function actRun(openMove)
        self:playAction(actState,openState)
        if actState~="walk" or actState~="die" then
            self:boundingBox(actState)
        end   
        if moveState~=nil then
            self:playMove(moveState,openMove)
        end
    end
    if keyCode==key then
            actRun(openState)
    end
    if key==0 then
            actRun(not openState)
    end
end
--执行当前动画状态的动作
function MainScene:playAction(_actState , _actOpen)
    local actData=self:getData("actData")
    local _stateEvent=actData[_actState][3]
    if _actOpen and _stateEvent == _actState then
        self:setData(_stateEvent)                   --存储当前的状态
        local actState=actData[_stateEvent]                                            --获取对应的动画状态
        local superKey=actData["super"]                                             --获取动画的人物父节点
        local childKey=actData["child"]                                                --获取动画人物的节点
        local anchorX=actData["anchorX"] 
        local scale=actData["scale"] 
        local size=actData["size"] 
        local pos=actData["pos"] 
        local colorBox=actData["colorBox"] 
        self:actionState(superKey,childKey,size,pos,colorBox,anchorX,scale,actState[1],actState[2],actState[3],actState[4])     --执行动画状态机
        -- print(superKey,childKey,anchorX)         
    end
end
--执行当前移动状态的动作
function MainScene:playMove(_moveState,_moveOpen)
        local actData=self:getData("actData")
        local superKey = actData["super"]
        if _moveOpen then
            local posRoll = actData["move"][_moveState]
            self.roll=posRoll[1]
            self.movePos=posRoll[2]
            self.anchorX=posRoll[3]  
        else
            self.roll=nil
            self.movePos=nil
            self.anchorX=nil
        end

        self:moveState(superKey,self.roll,self.movePos,self.anchorX,_moveOpen)
end
--人物动画状态机
function MainScene:actionState(superKey,playerKey,size,pos,colorBox,anchorX,scale,actName,actNum,actState,actTime)
    if self.node==nil then
        -- self.node=cc.Layer:create()
        if colorBox then
            self.node=cc.LayerColor:create(cc.c4b(255,255,0,255))
        else
            self.node=cc.LayerColor:create()
        end
        self:addChild(self.node)
        self.node:setContentSize(size);
        self.node:setAnchorPoint(cc.p(anchorX,0))  --0.43
        self.node:setPosition(display.center)
        self:setData(superKey,self.node)
    end
    if self:getData(playerKey)~=nil then
        self:getData(playerKey):removeSelf()
        self:setData(playerKey,nil)
    end
    local nameInit = string.format(actName,1)
    self.player=cc.Sprite:create(nameInit)
    self.node:addChild(self.player)
    self.player:setPosition(pos)
    self.player:setAnchorPoint(cc.p(0.5,0))
    self.player:setScale(scale)
    self:setData(playerKey,self.player)

    self.animation = cc.Animation:create()
    for i = 1, actNum do
        local name = string.format(actName,i)
        self.animation:addSpriteFrameWithFile(name)
    end
    self.animation:setDelayPerUnit(actTime)
    self.animation:setRestoreOriginalFrame(true)
    local animate = cc.Animate:create(self.animation)
    self.player:runAction(cc.RepeatForever:create(animate))
end
--人物移动状态机
function MainScene:moveState(superKey,roll,pos,rollback,moveOpen)
    self.person=self:getData(superKey)
    -- person:setPositionX(person:getPositionX()+pos)
    local function moveBy(node)
        if moveOpen then
            if roll=="left" or roll=="right" then
                self.person:setScaleX(rollback)
                local moveBy=cc.MoveBy:create(0.5,cc.p(pos,0))
                node:runAction(cc.RepeatForever:create(moveBy))
            elseif roll=="up" or roll=="down" then
                local moveBy=cc.MoveBy:create(0.5,cc.p(0,pos))
                node:runAction(cc.RepeatForever:create(moveBy))
            end
        else
            node:stopAllActions()
        end
    end
    moveBy(self.person)
    -- print(self.person,pos,rollback,self.person:getPositionX())
    -- dump(self:getData("player"):getBoundingBox())
    -- dump(self.person:getBoundingBox())
end
--攻击时的碰撞盒
function MainScene:boundingBox(actState)
    local actData=self:getData("actData")
    local superKey = actData["super"]
    local node=self:getData(superKey)
    if self.box==nil then
        self.box=cc.LayerColor:create(cc.c4b(75,75,125,255))
        node:addChild(self.box,2)
        self.box:setContentSize(cc.size(15,20));
        self.box:setAnchorPoint(cc.p(0.5,0.5))  --0.43
        self.box:setPosition(cc.p(25,15))
        self.box:setVisible(false)
        self:setData("box",self.box)
    end
    local function callBack1()
        self.box:setVisible(true)
    end
    local function callBack2()
        self.box:setVisible(false)
    end
    local time1=cc.DelayTime:create(0.2)
    local time2=cc.DelayTime:create(0.2)
    local call_1=cc.CallFunc:create(callBack1)
    local call_2=cc.CallFunc:create(callBack2)
    local seq=cc.Sequence:create(time1,call_1,time2,call_2)
    self.box:runAction(cc.RepeatForever:create(seq))
    if actState=="stand" then
        self.box:stopAllActions()
        self.box:setVisible(false)
        self.box:removeSelf()
        self.box=nil
    end
    -- dump(self.box:getBoundingBox())
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

return MainScene







        -- local switch={
        --     [124]=function()
        --         self:playAction("walk",true)
        --         self:playMove("left",true)
        --     end,
        --     [127]=function()
        --         self:playAction("walk",true)
        --         self:playMove("right",true)
        --     end,
        --     [146]=function()
        --         self:playAction("walk",true)
        --         self:playMove("up",true)
        --     end,
        --     [142]=function()
        --         self:playAction("walk",true)
        --         self:playMove("down",true)
        --     end,
        --     [133]=function()
        --         self:playAction("attack1",true)
        --     end,
        --     [134]=function()
        --         self:playAction("attack2",true)
        --     end,
        --     [135]=function()
        --         self:playAction("hit",true)
        --     end,
        --     [132]=function()
        --         self:playAction("die",true)
        --     end,
        -- }
        -- switch[keyCode]()







-- function MainScene:actionState2(actName,actNum,openAct)
--     if self:getData("player")==nil then
--         -- self:getData("player"):removeSelf()
--         -- self:setData("player",nil)
--         self.player=cc.Sprite:create()
--         self:addChild(self.player)
--         self.player:setPosition(display.center)
--         self.player:setAnchorPoint(0.5,0)
--         self.player:setScale(0.5)
--         self:setData("player",self.player)
--     else
--         self.player=self:getData("player")
--     end
--     -- if self.animation~=nil then
--     --     self.animation:removeSelf()
--     -- end
--     self.animation = cc.Animation:create()
--     for i = 1, actNum do
--         local name = string.format(actName,i)
--         self.animation:addSpriteFrameWithFile(name)
--     end
--     self.animation:setDelayPerUnit(2.8 / 28.0)
--     self.animation:setRestoreOriginalFrame(true)
--     local action = cc.Animate:create(self.animation)
--     -- if openAct then
--         self.player:runAction(cc.RepeatForever:create(action))
--     -- else
--     --     local function stop()
--     --         self.player:stopAllActions()
--     --     end
--     --     local callFunc=cc.CallFunc:create(stop)
--     --     local time=cc.DelayTime:create(0.5)
--     --     self.player:runAction(cc.Sequence:create(action,time,callFunc))
--     -- end
    
-- end



-- function MainScene:actFrame(actState)
--     local actData=self:getData("actData")
--     local superKey = actData["super"]
--     local node=self:getData(superKey)
--     if self.box==nil then
--         self.box=cc.LayerColor:create(cc.c4b(75,75,125,255))
--         node:addChild(self.box,2)
--         self.box:setContentSize(cc.size(15,20));
--         self.box:setAnchorPoint(cc.p(0.5,0.5))  --0.43
--         self.box:setPosition(cc.p(20,30))
--     else

--     end

--     print(actState)
--     local function callBack()
--         -- if actState=="stand" then
--             self.box:removeSelf()
--             self.box=nil
--         -- else
--         --     self.box:setPosition(cc.p(20,30))
--         -- end     
--     end
--     local move1=cc.MoveBy:create(0.4,cc.p(12,-15))
--     local move2=cc.MoveBy:create(0.4,cc.p(-12,-15))
--     local callFunc=cc.CallFunc:create(callBack)
--     local action=cc.Sequence:create(move1,move2,callFunc)
--     self.box:runAction(cc.RepeatForever:create(action))
--     -- self.box:runAction(action)
-- end