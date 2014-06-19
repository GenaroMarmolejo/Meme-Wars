//
//  GameScene.swift
//  Meme Wars
//
//  Created by Julio César Guzman on 6/15/14.
//  Copyright (c) 2014 Julio César Guzman. All rights reserved.
//

import SpriteKit

class GameScene: SKScene
{
    var player: SKSpriteNode!
    
    override func didMoveToView(view: SKView)
    {
        /* Setup your scene here */
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        let midscreen = CGPoint(x:200.0, y:100.0);
        myLabel.text = "100%";
        myLabel.fontSize = 65;
        myLabel.position = midscreen
        
        player = SKSpriteNode(imageNamed:"Spaceship")
            
        player.xScale = 0.25
        player.yScale = 0.25
        player.position = midscreen

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
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            
            player.runAction(SKAction.moveTo(location,duration: 0.1))
            //SKAction.followPath(path: CGPath!, speed: 1.0)
            //sprite.runAction(SKAction.repeatActionForever(action))
        }
    }
   
    override func update(currentTime: CFTimeInterval)
    {
        /* Called before each frame is rendered */
       
    }
}
