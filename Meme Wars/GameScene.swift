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



class Gun : SKSpriteNode
{
    var lifeLabel : SKLabelNode!
    var life: Int!
    {
        didSet
        {
            lifeLabel.text = "❤️\(self.life)%"
        }
    }
    var objective: SKNode!
    {
        didSet
        {
            var range : SKRange = SKRange(constantValue: -π / 2)
            var constraintToObjective : SKConstraint = SKConstraint.orientToNode(self.objective, offset:range)
            self.constraints = [constraintToObjective]
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
        
        //Setup Force Field
//        var field = SKFieldNode.radialGravityField()
//        field.strength = 100
//        field.falloff = 0.5
//        self.addChild(field)
//        self.physicsBody.fieldBitMask = 0
        
    }
    
    func shoot()
    {
        var bullet = SKSpriteNode(imageNamed: "spark")
        self.parent.addChild(bullet)
        bullet.physicsBody = SKPhysicsBody(circleOfRadius: 1)
        bullet.xScale = 0.1
        bullet.yScale = 0.1
        
        var offset : CGFloat = CGFloat(π/2)
        var vector = CGVectorMake(10.0 * cos(self.zRotation + offset), 10.0 * sin(self.zRotation + offset) )
        bullet.physicsBody.applyForce( vector )
        bullet.position =  CGPoint(x: self.position.x + 50 * cos(self.zRotation + offset) , y: self.position.y + 50 * sin(self.zRotation + offset) )
    }
    
    func die()
    {
        self.removeFromParent()
    }
}


class GameScene: SKScene, SKPhysicsContactDelegate
{
    var gun1: Gun!
    var gun2: Gun!
    override func didMoveToView(view: SKView)
    {
        /* Setup your scene here */
        self.backgroundColor = UIColor.blackColor()
        self.physicsWorld.gravity = CGVector(0,0)
        self.physicsWorld.contactDelegate = self
        
        gun1 = Gun(imageNamed:"Turret")
        gun2 = Gun(imageNamed:"Turret")
        
        gun1.objective = gun2
        gun2.objective = gun1
        
        self.addChild(gun1)
        self.addChild(gun2)
        
        
        gun2.zRotation = CGFloat(π)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent)
    {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            
            if location.y >= 768/2
            {
                gun2.shoot()
            }
            else
            {
                gun1.shoot()
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
                gun2.runAction(SKAction.moveTo(location,duration: 0.1))
            }
            else
            {
                gun1.runAction(SKAction.moveTo(location,duration: 0.1))
            }
        }
    }
   
    override func update(currentTime: CFTimeInterval)
    {
        /* Called before each frame is rendered */
    }
    
    func didBeginContact(contact: SKPhysicsContact!)
    {
        if contact.bodyA.node is Gun
        {
            let a : Gun = contact.bodyA.node as Gun
            a.life = a.life - 1
            if contact.bodyB.node is Gun
            {
            }
            else
            {
                 contact.bodyB.node.removeFromParent()
            }
        }
       
     
    }
    
    
    
}
