
-- local GameScenes = class("GameScenes", cc.load("mvc").ViewBase)
--     local visibleSize=cc.Director:getInstance():getVisibleSize()

-- function GameScenes:onCreate()

-- end
-- return GameScenes

local MainScene = class("MainScene", cc.load("mvc").ViewBase)
    local visibleSize=cc.Director:getInstance():getVisibleSize()
function MainScene:onCreate()

    -- add background image
    -- local img=display.newSprite("HelloWorld.png")
    -- img:setPosition(display.center)
    -- self:addChild(img)

    -- -- add HelloWorld label
    -- cc.Label:createWithSystemFont("Hello World", "Arial", 40)
    --     :move(display.cx, display.cy + 200)
    --     :addTo(self)
    -- -- local agent = AgentManager:getInstance()

    -- local moveRight=cc.MoveBy:create(1,cc.p(100,0))
    -- local moveLeft=cc.MoveBy:create(1,cc.p(-100,0))
    -- local seq=cc.RepeatForever:create(cc.Sequence:create(moveRight,moveLeft,moveLeft,moveRight))
    -- -- img:runAction(seq)
    -- local num=0
    -- local count=0
    -- local function update(dt)
    --     num=num+1
    --     if num==24 then
    --         count=count+1
    --         print(count.." "..(count/12)%2)
    --         num=0
    --         -- print(os.date())
    --         if (count/24)%2<=1 then
    --             img:setPositionX(img:getPositionX()+2)
    --         elseif (count/24)%2>=1 then
    --             img:setPositionX(img:getPositionX()-2)
    --         end
            
    --     end        
    -- end
    -- self:scheduleUpdate(update)

    -- local bg=self:sceneBg(1,4,2,visibleSize.width/2+55*4/2,visibleSize.height/2+55*4/2)




    -- local player=self:sceneBg(-1,1,2,visibleSize.width/2,visibleSize.height/2)

    -- local player=self:sceneBg(-1,1,2,visibleSize.width/2,visibleSize.height/2)
    -- print(player[-1][0])

--[[
    local dir={
        Left=1,
        Right=2,
        Up=3,
        Down=4
    }

    local dirCard={
        {type=1,dir="Left"    ,ratation=-90 ,visible=false},
        {type=2,dir="Right"  ,ratation=90  ,visible=false},
        {type=3,dir="Up"      ,ratation=0    ,visible=false},
        {type=4,dir="Down" ,ratation=180,visible=false},
    }

    -- local player,cardMove=self:playerCard(dir)
   
   dump(dirCard)

            local direction=cc.Scale9Sprite:create("HelloWorld.png")
            direction:setPosition(cc.p(visibleSize.width/2,visibleSize.height/2))
            direction:setContentSize(cc.size(50,50))
            self:addChild(direction)
            direction:setRotation(dirCard[1].ratation)
]]

    -- local size=player:getContentSize()
    -- local direction=ccui.ImageView:create()
    -- direction:setScale9Enabled(true)
    -- direction:setPosition(cc.p(size.width/2,size.height/2))
    -- direction:setContentSize(cc.size(50,50))
    -- direction:loadTexture("HelloWorld.png")
    -- player:addChild(direction)

    -- local num=0
    -- local count=0
    -- local function update(dt)
    --     num=num+1
    --     if num==24 then
    --         local dirRandom=math.random(1,4)
            -- local switch={
            --     [1]=function()
            --         direction:setPosition(cc.p(size.width/2-55,size.height/2))
            --     end,
            --     [2]=function()
            --         direction:setPosition(cc.p(size.width/2+55,size.height/2))
            --     end,
            --     [3]=function()
            --         direction:setPosition(cc.p(size.width/2,size.height/2+55))
            --     end,
            --     [4]=function()
            --         direction:setPosition(cc.p(size.width/2,size.height/2-55))
            -- end
            -- }
            -- switch[dirRandom]()
            
    --         print(dirRandom)
    --         num=0
    --     end        
    -- end
    -- self:scheduleUpdate(update)


    -- print(cardMove["Left"])
    -- print(cardMove[1])
end
--[[
function MainScene:playerCard(dir)
    local cardMove={}
    local player=self:cardSprite(self,50,50,visibleSize.width/2,visibleSize.height/2,"")
    -- cardMove["Center"]=player
    -- for k,v in pairs(dir) do
    for v=1,4 do
        local switch={
            [1]=function()
            print(k)
                cardMove[v]=self:cardSprite(player,50,50,-55,0,"")
            end,
            [2]=function()
                cardMove[v]=self:cardSprite(player,50,50,55,0,"")
            end,
            [3]=function()
                cardMove[v]=self:cardSprite(player,50,50,0,55,"")
            end,
            [4]=function()
                cardMove[v]=self:cardSprite(player,50,50,0,-55,"")
            end
        }
        switch[v]()
    end
    return player,cardMove
end
function MainScene:cardSprite(node,width,height,x,y,img)
        local card=cc.LayerColor:create(cc.c4b(200, 190, 180, 255),width,height)
        card:setPosition(cc.p(x,y))
        if img~="" then
            local direction=cc.Scale9Sprite:create(img)
            direction:setPosition(cc.p(width/2,height/2))
            direction:setContentSize(cc.size(width-10,height-5))
            card:addChild(direction)
        end
        node:addChild(card)
        return card
end
function MainScene:sceneBg(startNum,endNum,typeCard,xx,yy,img)
    local cardSprite={}
    for i=startNum,endNum do
        cardSprite[i]={}
        for j=startNum,endNum do
            if typeCard==1 then
                cardSprite[i][j]=self:cardSprite(50,50,xx-i*55,yy-j*55,"")
            elseif typeCard==2 then
                local nun=math.abs(i)+math.abs(j)
                if nun~=2 then
                    cardSprite[i][j]=self:cardSprite(50,50,xx-i*55,yy-j*55,"")
                end  
            end
            
        end
    end
    return cardSprite
end
]]
return MainScene
