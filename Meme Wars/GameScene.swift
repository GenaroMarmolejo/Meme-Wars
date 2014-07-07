//
//  GameScene.swift
//  Meme Wars
//
//  Created by Julio César Guzman on 6/15/14.
//  Copyright (c) 2014 Julio César Guzman. All rights reserved.
//

import SpriteKit
import CoreGraphics

let π = 3.141592

let heroCategory: UInt32 =  0x1 << 0;
let enemyCategory: UInt32 =  0x1 << 1;
let heroTurretCategory: UInt32 =  0x1 << 2;
let enemyTurretCategory: UInt32 =  0x1 << 3;

class Spaceship : SKSpriteNode
{
    var gun: Gun!
    var lifeLabel : SKLabelNode!
    var maximumLife : Float! = 100
    var life: Float!
    {
        didSet
        {
            lifeLabel.text = "\(Int(self.lifePercentaje))%❤️"
        }
    }
    
    var lifePercentaje : Float!
    {
        set
        {
            life =  newValue / 100 * maximumLife
        }
        get
        {
            return Float(self.life)/Float(self.maximumLife) * 100
        }
    }
    
    var objective: SKSpriteNode!
    {
        didSet
        {
            self.gun.objective = objective
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
        self.setup()
 
    }
    
    func setup()
    {
        // Setup physics body
        self.physicsBody = SKPhysicsBody(circleOfRadius: 200)
     
        
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
        gun.position = CGPoint(x:0.0, y:0.0)
        gun.xScale = 0.25
        gun.yScale = 0.25
        
        self.addChild(gun)

    }
    
    func shoot()
    {
        self.gun.shooting = true
    }
}

class Ammunition : SKSpriteNode
{
    var damage : Float!
    init()
    {
        super.init(imageNamed: "spark")
        self.physicsBody = SKPhysicsBody(circleOfRadius: 1)
        self.xScale = 0.1
        self.yScale = 0.1
        self.damage = 10
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
    var objective: SKSpriteNode!
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
    
    var bulletsPerSecond = 100.0
    
    var shooting : Bool!
    {
        didSet
        {
            if shooting == true
            {
                var shoot = SKAction.runBlock({ self.shoot() })
                
                var wait = SKAction.waitForDuration( 1.0 / bulletsPerSecond )
                var sequence = SKAction.sequence([shoot, wait])
                var repeat = SKAction.repeatActionForever(sequence)
                
                self.runAction(repeat, withKey: "shoot")
            }
            else
            {
                self.removeActionForKey("shoot")
            }
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
        self.setup()
    }
    
    func setup()
    {
        self.physicsBody = SKPhysicsBody(circleOfRadius:10)
        self.physicsBody.pinned = true
        
        self.physicsBody.categoryBitMask = heroTurretCategory
        self.physicsBody.contactTestBitMask = 0
        self.physicsBody.collisionBitMask = 0
    }
    
    func shoot()
    {
        var bullet = Ammunition()
        self.parent.parent.addChild(bullet)
        
        var offset : CGFloat = CGFloat(π/2)
        var angulo = self.zRotation + self.parent.zRotation + offset
        var vector = CGVectorMake( 1000.0 * cos(angulo), 1000.0 * sin(angulo) )
        
        bullet.physicsBody.velocity = vector
        var point = self.convertPoint(CGPointZero, toNode: self.parent.parent)
        bullet.position = CGPoint(x: point.x + 1 * cos(angulo) , y: point.y + 1 * sin(angulo))
        
        bullet.physicsBody.categoryBitMask = self.parent.physicsBody.categoryBitMask
        bullet.physicsBody.contactTestBitMask = 0
        bullet.physicsBody.collisionBitMask = 0
        
    }
    

}

class GameScene: SKScene, SKPhysicsContactDelegate
{
    var player1: Spaceship!
    var slowMotion : Bool!
    {
        didSet
        {
            if slowMotion == false
            {
                self.physicsWorld.speed = 1.0
            }
            else
            {
                self.physicsWorld.speed = 0.1
            }
            self.setSpeedOnChildren()
        }
    }
    
    func setSpeedOnChildren()
    {
        for child : AnyObject in self.children
        {
            let node = child as SKNode
            node.speed = self.physicsWorld.speed
        }
    }
    
    func setup()
    {

        //
        var trollAtlas = SKTextureAtlas(named:"troll")
        var textures = [trollAtlas.textureNamed("1"),
                        trollAtlas.textureNamed("2"),
                        trollAtlas.textureNamed("3")]
        
        var animation = SKAction.animateWithTextures(textures, timePerFrame:0.1)
        var animateForever = SKAction.repeatActionForever(animation)
        
        
        
        //Setup Spaceships
        player1 = Spaceship(imageNamed: "Spaceship")
        //player1.runAction(animateForever)
        var player2 = Spaceship(imageNamed: "Spaceship")
        
        player1.lifePercentaje = 100
        player2.lifePercentaje = 100

        player1.physicsBody.categoryBitMask = heroCategory
        player1.physicsBody.contactTestBitMask = enemyCategory
        player1.physicsBody.collisionBitMask = 0//enemyCategory
        
        player2.physicsBody.categoryBitMask = enemyCategory
        player2.physicsBody.contactTestBitMask = heroCategory
        player2.physicsBody.collisionBitMask = 0//heroCategory
        
        //player1.objective = player2
        player2.objective = player1
        
        player1.shoot()
        player2.shoot()
        
        player1.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame) - 200)
        player2.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame) + 200)
        
        self.addChild(player1)
        self.addChild(player2)
        
        player2.zRotation = π
        
        self.slowMotion = false
    }
    
    func clean()
    {
        for sprite:AnyObject in self.children
        {
            sprite.removeFromParent()
        }
    }
    
    func movePlayer1ToLocation( location : CGPoint )
    {
        var velocity = 1000.0
        var move = SKAction.moveTo(location, duration: self.distanceBetweenPoints(pointA: player1.position, pointB: location) / velocity)
        player1.runAction(move)//, withKey:"move")
    }
    
    func distanceBetweenPoints(#pointA: CGPoint, pointB: CGPoint) -> (distance:Double)
    {
        var dx = pointA.x - pointB.x
        var dy = pointA.y - pointB.y
        return sqrt(dx * dx + dy * dy)
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
            
            self.movePlayer1ToLocation(location)
            
            self.slowMotion = false

        }
        
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent)
    {
        for touch: AnyObject in touches
        {
            let location = touch.locationInNode(self)
            self.movePlayer1ToLocation(location)
            self.slowMotion = false
        }
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent)
    {
        self.slowMotion = true
        player1.removeAllActions()
        player1.shoot()
    }
   
    override func update(currentTime: CFTimeInterval)
    {
        // Clean nodes
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
                ammo.removeFromParent()
            }
        }
        
        if contact.bodyA.node is Ammunition
        {
            if contact.bodyB.node is Ammunition
            {
                let ammoA = contact.bodyA.node as Ammunition
                let ammoB = contact.bodyB.node as Ammunition
               // ammoA.removeFromParent()
               // ammoB.removeFromParent()
            }
        }

        
    }
    

}
