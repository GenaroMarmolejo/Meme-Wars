//
//  GameScene.swift
//  Meme Wars
//
//  Created by Julio César Guzman on 6/15/14.
//  Copyright (c) 2014 Julio César Guzman. All rights reserved.
//

import SpriteKit

class Spaceship : SKSpriteNode
{
    var lifeText: String!
    var life: Int
    {
        get{ return self.life }
        set{ lifeText = "❤️\(newValue)%" }
    }
    
    
    init(imageNamed name: String!)
    {
        super.init(imageNamed: name )
    }
}


class GameScene: SKScene
{
    var player: SKSpriteNode!
    
    override func didMoveToView(view: SKView)
    {
        
        self.backgroundColor = UIColor.whiteColor()
        
        /* Setup your scene here */
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        let midscreen = CGPoint(x:200.0, y:100.0);
        myLabel.text = "100%";
        myLabel.fontSize = 65;
        myLabel.position = midscreen
        myLabel.fontColor = UIColor.blackColor()
        //player = Spaceship()
        player = SKSpriteNode(imageNamed:"Spaceship")
        player.xScale = 0.15
        player.yScale = 0.15
        player.position = midscreen
        Spaceship(imageNamed:"Spaceship")
       
        player.addChild(myLabel)
        self.addChild(player)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent)
    {
        /* Called when a touch begins */
        /*
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            
            player.runAction(SKAction.moveTo(location,duration: 0.1))
            //SKAction.followPath(path: CGPath!, speed: 1.0)
            //sprite.runAction(SKAction.repeatActionForever(action))
        }
        */
        
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent)
    {
        for touch: AnyObject in touches
        {
            let location = touch.locationInNode(self)
            player.runAction(SKAction.moveTo(location,duration: 0.1))
        }
    }
   
    override func update(currentTime: CFTimeInterval)
    {
        /* Called before each frame is rendered */
       
    }
}
