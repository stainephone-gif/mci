import SpriteKit

class Pipe: SKNode {

    let pipeWidth: CGFloat = 100
    let gap: CGFloat = 200
    let speed: CGFloat = 3
    var passed = false

    init(screenHeight: CGFloat, xPosition: CGFloat) {
        super.init()

        // Random height for gap
        let minHeight: CGFloat = 100
        let maxHeight = screenHeight - gap - 100
        let topHeight = CGFloat.random(in: minHeight...maxHeight)

        // Create top pipe
        let topPipe = SKShapeNode(rect: CGRect(x: 0, y: topHeight, width: pipeWidth, height: screenHeight - topHeight))
        topPipe.fillColor = NSColor(red: 0.13, green: 0.55, blue: 0.13, alpha: 1.0) // Forest Green
        topPipe.strokeColor = NSColor(red: 0.0, green: 0.39, blue: 0.0, alpha: 1.0)
        topPipe.lineWidth = 2
        topPipe.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: pipeWidth, height: screenHeight - topHeight),
                                            center: CGPoint(x: pipeWidth/2, y: topHeight + (screenHeight - topHeight)/2))
        topPipe.physicsBody?.isDynamic = false
        topPipe.physicsBody?.categoryBitMask = 2

        // Create bottom pipe
        let bottomY: CGFloat = 0
        let bottomHeight = topHeight - gap
        let bottomPipe = SKShapeNode(rect: CGRect(x: 0, y: bottomY, width: pipeWidth, height: bottomHeight))
        bottomPipe.fillColor = NSColor(red: 0.13, green: 0.55, blue: 0.13, alpha: 1.0)
        bottomPipe.strokeColor = NSColor(red: 0.0, green: 0.39, blue: 0.0, alpha: 1.0)
        bottomPipe.lineWidth = 2
        bottomPipe.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: pipeWidth, height: bottomHeight),
                                               center: CGPoint(x: pipeWidth/2, y: bottomHeight/2))
        bottomPipe.physicsBody?.isDynamic = false
        bottomPipe.physicsBody?.categoryBitMask = 2

        self.addChild(topPipe)
        self.addChild(bottomPipe)
        self.position = CGPoint(x: xPosition, y: 0)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update() {
        self.position.x -= speed
    }
}
