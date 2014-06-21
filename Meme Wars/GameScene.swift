//
//  GameScene.swift
//  Meme Wars
//
//  Created by Julio César Guzman on 6/15/14.
//  Copyright (c) 2014 Julio César Guzman. All rights reserved.
//

import SpriteKit
import CoreGraphics

var π = 3.141592

var contador = 0
class Spaceship : SKSpriteNode
{
    var lifeLabel : SKLabelNode!
    var life: Int!
    {
        didSet
        {
            lifeLabel.text = "❤️\(self.life)%"
        }
    }
    
    init(texture: SKTexture!, color: UIColor!, size: CGSize)
    {
        super.init(texture: texture, color: color, size: size)
    }
    
    init(texture: SKTexture!)
    {
        super.init(texture: texture)
    }
    
    init(imageNamed name: String!)
    {
        super.init(imageNamed: name )
        
        // Setup physics body
        self.physicsBody = SKPhysicsBody(circleOfRadius: 200)
        self.physicsBody.dynamic = true;
        self.physicsBody.contactTestBitMask = 1
        
        // Setup Label
        lifeLabel = SKLabelNode(fontNamed:"Chalkduster")
        let midscreen = CGPoint(x: 200.0, y:100.0);
        lifeLabel.fontSize = 65;
        lifeLabel.position = midscreen
        lifeLabel.fontColor = UIColor.whiteColor()
        self.addChild(lifeLabel)
        
        //Setup Player
        self.xScale = 0.15
        self.yScale = 0.15
        self.life = 100
    }
    
    func shoot()
    {
        var bullet = SKSpriteNode(imageNamed: "spark")
        self.parent.addChild(bullet)
        bullet.physicsBody = SKPhysicsBody(circleOfRadius: 1)
        bullet.xScale = 1
        bullet.yScale = 1
        
        var offset : CGFloat = CGFloat(π/2)
        var vector = CGVectorMake(0.0, 10.0 * sin(self.zRotation + offset) )
        bullet.physicsBody.applyForce( vector )
        bullet.position =  CGPoint(x: self.position.x , y: self.position.y + 50 )
     
    }
}


class GameScene: SKScene, SKPhysicsContactDelegate
{
    var player1: Spaceship!
    var player2: Spaceship!
    override func didMoveToView(view: SKView)
    {
        /* Setup your scene here */
        self.backgroundColor = UIColor.blackColor()
        self.physicsWorld.gravity = CGVector(0,0)
        self.physicsWorld.contactDelegate = self
        
        player1 = Spaceship(imageNamed:"Spaceship")
        player2 = Spaceship(imageNamed:"Spaceship")
        self.addChild(player1)
        self.addChild(player2)
        
        player2.zRotation = CGFloat(π)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent)
    {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            
            if location.y >= 768/2
                
            {
                player2.shoot()
            }
            else
            {
                player1.shoot()
            }
        }

        
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent)
    {
        for touch: AnyObject in touches
        {
            let location = touch.locationInNode(self)
            if location.y >= 768/2
                
            {
                player2.runAction(SKAction.moveTo(location,duration: 0.1))
            }
            else
            {
                player1.runAction(SKAction.moveTo(location,duration: 0.1))
            }
        }
    }
   
    override func update(currentTime: CFTimeInterval)
    {
        /* Called before each frame is rendered */
    }
    
    func didBeginContact(contact: SKPhysicsContact!)
    {
       // NSLog("Contact detected")
        if contact.bodyA.node is Spaceship
        {
            let a : Spaceship = contact.bodyA.node as Spaceship
            a.life = a.life - 1
        }
     
    }
    
    
    
}
