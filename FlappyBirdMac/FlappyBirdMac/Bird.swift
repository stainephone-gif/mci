import SpriteKit

class Bird: SKShapeNode {

    var velocity: CGFloat = 0
    let gravity: CGFloat = 0.6
    let jumpStrength: CGFloat = -12.0

    init(position: CGPoint) {
        super.init()

        // Create circular bird
        let circle = SKShapeNode(circleOfRadius: 30)
        circle.fillColor = NSColor(red: 1.0, green: 0.84, blue: 0.0, alpha: 1.0) // Gold
        circle.strokeColor = NSColor(red: 1.0, green: 0.65, blue: 0.0, alpha: 1.0) // Orange
        circle.lineWidth = 2

        self.addChild(circle)
        self.position = position

        // Physics
        self.physicsBody = SKPhysicsBody(circleOfRadius: 30)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.categoryBitMask = 1
        self.physicsBody?.contactTestBitMask = 2 | 4
        self.physicsBody?.collisionBitMask = 0
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update() {
        velocity += gravity
        self.position.y -= velocity
    }

    func jump() {
        velocity = jumpStrength
    }

    func reset(at position: CGPoint) {
        self.position = position
        velocity = 0
    }
}
