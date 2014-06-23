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
    var objective: Spaceship!
    {
        didSet
        {
            var range : SKRange = SKRange(constantValue: -π / 2)
            var constraintToObjective : SKConstraint = SKConstraint.orientToNode(self.objective, offset:range)
            self.constraints = [constraintToObjective]
            
            // Add objective to gun
            gun.objective = objective
        }
    }
    var gun: Gun!
    
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
        
        //Setup Spaceship
        self.xScale = 0.15
        self.yScale = 0.15
        self.life = 100
        
        //Setup Guns
        gun = Gun(imageNamed: "Turret")
        gun.position = CGPoint(x:500.0, y:0.0)
        gun.xScale = 0.25
        gun.yScale = 0.25
        
        
        self.addChild(gun)
        
    }
    
    func shoot()
    {
        var shoot = SKAction.runBlock({
            
             self.gun.shoot()
        })
        
        var wait = SKAction.waitForDuration(0.1)
        var sequence = SKAction.sequence([shoot, wait])
        var repeat = SKAction.repeatActionForever(sequence)
        
        self.runAction(repeat)
        
    }
}

class Ammunition : SKSpriteNode
{
    var damage: Int = 1
    
    init()
    {
        super.init(imageNamed: "spark")
        self.physicsBody = SKPhysicsBody(circleOfRadius: 1)
        self.xScale = 0.1
        self.yScale = 0.1
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
        super.init(imageNamed: name)
    }
    
    
}

class Gun : SKSpriteNode
{
    var life: Int!
    var objective: Spaceship!
    {
        didSet
        {
            var target = SKNode()
            objective.addChild(target)
            var range : SKRange = SKRange(constantValue: -π / 2 )
            var constraintToObjective : SKConstraint = SKConstraint.orientToPoint(CGPointZero, inNode: target, offset:range)
            self.constraints = [constraintToObjective]
        }
    }
    
    init()
    {
        super.init()
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
        
        //Setup Gun
        self.xScale = 1
        self.yScale = 1
        self.life = 100
        
    }
    
    func shoot()
    {
    
        var bullet = Ammunition()
        self.parent.parent.addChild(bullet)
        
        var offset : CGFloat = CGFloat(π/2)
        var angulo = self.zRotation + self.parent.zRotation + offset
        var vector = CGVectorMake(500.0 * cos(angulo), 500.0 * sin(angulo) )
        
        bullet.physicsBody.velocity = vector
        var point = self.convertPoint(CGPointZero, toNode: self.parent.parent)
        bullet.position = CGPoint(x: point.x + 5 * cos(angulo) , y: point.y + 5 * sin(angulo))
    }
    
    
    func die()
    {
        self.removeFromParent()
    }
}

class GameScene: SKScene, SKPhysicsContactDelegate
{
    var player1: Spaceship!
    var player2: Spaceship!
    
    func clean()
    {
        for sprite:AnyObject in self.children
        {
            sprite.removeFromParent()
        }
    }
    
    func setup()
    {
        //Setup Spaceships
        player1 = Spaceship(imageNamed: "Spaceship")
        player2 = Spaceship(imageNamed: "Spaceship")
        
        player1.life = 100
        player2.life = 100
     
        player1.objective = player2
        player2.gun.objective = player1
        
        player1.shoot()
        
        
        player1.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame) - 200)
        player2.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame) + 200)
        
        self.addChild(player1)
        self.addChild(player2)

    }
    
    override func didMoveToView(view: SKView)
    {
        /* Setup your scene here */
        self.backgroundColor = UIColor.blackColor()
        self.physicsWorld.gravity = CGVector(0,0)
        self.physicsWorld.contactDelegate = self

        self.setup()
        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent)
    {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches
        {
            let location = touch.locationInNode(self)
            self.physicsWorld.speed = 1.0
        }
        
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent)
    {
        for touch: AnyObject in touches
        {
            let location = touch.locationInNode(self)

            player1.runAction(SKAction.moveTo(location,duration: 0.1))
        }
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent)
    {
        self.physicsWorld.speed = 0.2
    }
   
    override func update(currentTime: CFTimeInterval)
    {
        for child : AnyObject in self.children
        {
            if child.position.x > self.size.width
            {
                child.removeFromParent()
            }
            if child.position.x < 0
            {
                 child.removeFromParent()
            }
            if child.position.y > self.size.height
            {
                child.removeFromParent()
            }
            if child.position.y < 0
            {
                child.removeFromParent()
            }
            
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact!)
    {
        if  contact.bodyA.node is Spaceship
        {
            let ship = contact.bodyA.node as Spaceship
            if contact.bodyB.node is Ammunition
            {
                let ammo = contact.bodyB.node as Ammunition
                ship.life = ship.life - ammo.damage
            }
            
        }
        
        
    }
    

}
