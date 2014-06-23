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
        
        //Setup Spaceship
        self.xScale = 0.15
        self.yScale = 0.15
        self.life = 100
    }
}

class Gun : SKSpriteNode
{
    var life: Int!
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
        
        //Setup Gun
        self.xScale = 0.25
        self.yScale = 0.25
        self.life = 100
        
    }
    
    func shoot()
    {
        var bullet = SKSpriteNode(imageNamed: "spark")
        self.parent.parent.addChild(bullet)
        bullet.physicsBody = SKPhysicsBody(circleOfRadius: 1)
        bullet.xScale = 0.1
        bullet.yScale = 0.1
        
        var offset : CGFloat = CGFloat(π/2)
        var angulo = self.zRotation + self.parent.zRotation + offset
        var vector = CGVectorMake(10.0 * cos(angulo), 10.0 * sin(angulo) )
        
        bullet.physicsBody.applyForce( vector )
       
        bullet.position =  CGPoint(x: self.parent.position.x + 50 * cos(angulo) , y: self.parent.position.y + 50 * sin(angulo) )
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
    var gun: Gun!
    
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
        gun = Gun(imageNamed: "Turret")
        
        player1.life = 100
        player2.life = 100
        gun.life = 100
    
        //player1.objective = player2
        player2.objective = player1
        gun.objective = player2
        
        player1.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame) - 200)
        player2.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame) + 200)
        gun.position = CGPointZero
        
        self.addChild(player1)
        self.addChild(player2)
        self.player1.addChild(gun)
        
        var range : SKRange = SKRange(constantValue:-π / 2)
        var constraintToObjective : SKConstraint = SKConstraint.orientToPoint(player2.position, inNode: self, offset: range) // SKConstraint.orientToNode(player2, offset:range)
        constraintToObjective.referenceNode = gun
        gun.constraints = [constraintToObjective]


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
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)

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
        
    }
   
    override func update(currentTime: CFTimeInterval)
    {

    }
    
    func didBeginContact(contact: SKPhysicsContact!)
    {
        
    }
    

}
