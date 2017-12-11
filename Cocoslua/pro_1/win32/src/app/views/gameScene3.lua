local gameScene3 = class("GameScene", cc.load("mvc").ViewBase)

function gameScene3:onCreate()
    local visibleSize = cc.Director:getInstance():getWinSize()
    -- local edgeBody = cc.PhysicsBody:createEdgeBox( visibleSize, cc.PhysicsMaterial( 1,1 ,0), 3)  
    -- local edgeNode = cc.Node:create()  
    -- self:addChild(edgeNode)  
    -- edgeNode:setPosition(display.center)--(visibleSize.width * 0.5 , visibleSize.height * 0.5 )  
    -- edgeNode:setPhysicsBody(edgeBody)
    -- self:getPhysicsWorld():setDebugDrawMask(cc.PhysicsWorld.DEBUGDRAW_ALL) 


    -- local scene = cc.Scene:createWithPhysics()  
    -- self:addChild(scene)
    -- scene:getPhysicsWorld():setGravity(cc.vertex2F(0,-1000))
    -- scene:getPhysicsWorld():setDebugDrawMask(cc.PhysicsWorld.DEBUGDRAW_ALL) 
    
    -- local wallBox = display.newNode()
    -- wallBox:setAnchorPoint(cc.p(0.5, 0.5))
    -- wallBox:setPosition(display.cx, display.cy)
    -- scene:addChild(wallBox)
    -- -- -- local body = cc.PhysicsBody:createCircle(10,cc.PhysicsMaterial(0,0,0))
    -- -- -- wallBox:setPhysicsBody(body)--(cc.size(display.width ,display.height),cc.PhysicsMaterial(0,1,0),6))

    -- local body = cc.PhysicsBody:createEdgeBox(cc.size(display.width ,display.height),cc.PhysicsMaterial(0,1,0),6)
    -- wallBox:setPhysicsBody(body)

    -- -- -- local physicsBody = cc.PhysicsBody:create(PHYSICS_INFINITY, PHYSICS_INFINITY)
    -- -- -- wallBox:setPhysicsBody(physicsBody)
    
--创建一个围绕屏幕四周的物理边界  
local node=cc.Node:create()  
    node:setPhysicsBody(cc.PhysicsBody:createEdgeBox(visibleSize,cc.PHYSICSBODY_MATERIAL_DEFAULT,5))  
    node:setPosition(visibleSize.width/2,visibleSize.height/2)  
    self:addChild(node) 


    print(visibleSize.width,visibleSize.height,physicsBody)
end

return gameScene3