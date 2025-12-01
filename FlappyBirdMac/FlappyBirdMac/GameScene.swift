import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {

    var bird: Bird!
    var pipes: [Pipe] = []
    var score = 0
    var bestScore = 0
    var isGameOver = false
    var isGameStarted = false

    var scoreLabel: SKLabelNode!
    var messageLabel: SKLabelNode!
    var bestScoreLabel: SKLabelNode!

    var frameCount = 0

    override func didMove(to view: SKView) {
        setupScene()
        setupLabels()
        loadBestScore()
    }

    func setupScene() {
        // Background color
        self.backgroundColor = NSColor(red: 0.53, green: 0.81, blue: 0.92, alpha: 1.0) // Sky Blue

        // Physics
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self

        // Ground and ceiling (invisible boundaries)
        let ground = SKNode()
        ground.position = CGPoint(x: 0, y: 0)
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width, height: 1))
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.categoryBitMask = 4
        self.addChild(ground)

        let ceiling = SKNode()
        ceiling.position = CGPoint(x: 0, y: self.size.height)
        ceiling.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width, height: 1))
        ceiling.physicsBody?.isDynamic = false
        ceiling.physicsBody?.categoryBitMask = 4
        self.addChild(ceiling)

        // Bird
        bird = Bird(position: CGPoint(x: self.size.width / 4, y: self.size.height / 2))
        self.addChild(bird)
    }

    func setupLabels() {
        // Score label
        scoreLabel = SKLabelNode(fontNamed: "Helvetica-Bold")
        scoreLabel.fontSize = 48
        scoreLabel.fontColor = .white
        scoreLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height - 80)
        scoreLabel.text = "0"
        scoreLabel.zPosition = 100
        self.addChild(scoreLabel)

        // Message label
        messageLabel = SKLabelNode(fontNamed: "Helvetica")
        messageLabel.fontSize = 32
        messageLabel.fontColor = .white
        messageLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2 + 50)
        messageLabel.text = "Click to Start"
        messageLabel.zPosition = 100
        self.addChild(messageLabel)

        // Best score label
        bestScoreLabel = SKLabelNode(fontNamed: "Helvetica")
        bestScoreLabel.fontSize = 24
        bestScoreLabel.fontColor = .white
        bestScoreLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2 - 50)
        bestScoreLabel.text = "Best: \(bestScore)"
        bestScoreLabel.zPosition = 100
        self.addChild(bestScoreLabel)
    }

    override func update(_ currentTime: TimeInterval) {
        if !isGameStarted || isGameOver {
            return
        }

        // Update bird
        bird.update()

        // Update pipes
        for (index, pipe) in pipes.enumerated().reversed() {
            pipe.update()

            // Check if bird passed pipe
            if !pipe.passed && bird.position.x > pipe.position.x + pipe.pipeWidth {
                pipe.passed = true
                score += 1
                scoreLabel.text = "\(score)"
            }

            // Remove off-screen pipes
            if pipe.position.x + pipe.pipeWidth < 0 {
                pipe.removeFromParent()
                pipes.remove(at: index)
            }
        }

        // Add new pipes
        frameCount += 1
        if frameCount % 90 == 0 {
            let pipe = Pipe(screenHeight: self.size.height, xPosition: self.size.width)
            pipes.append(pipe)
            self.addChild(pipe)
        }
    }

    override func mouseDown(with event: NSEvent) {
        if !isGameStarted {
            startGame()
        } else if isGameOver {
            restartGame()
        } else {
            bird.jump()
        }
    }

    override func keyDown(with event: NSEvent) {
        if event.keyCode == 49 { // Space key
            if !isGameStarted {
                startGame()
            } else if isGameOver {
                restartGame()
            } else {
                bird.jump()
            }
        }
    }

    func startGame() {
        isGameStarted = true
        messageLabel.isHidden = true
        bestScoreLabel.isHidden = true
    }

    func restartGame() {
        // Remove all pipes
        for pipe in pipes {
            pipe.removeFromParent()
        }
        pipes.removeAll()

        // Reset bird
        bird.reset(at: CGPoint(x: self.size.width / 4, y: self.size.height / 2))

        // Reset game state
        score = 0
        frameCount = 0
        isGameOver = false
        isGameStarted = false

        scoreLabel.text = "0"
        messageLabel.text = "Click to Start"
        messageLabel.isHidden = false
        bestScoreLabel.text = "Best: \(bestScore)"
        bestScoreLabel.isHidden = false
    }

    func gameOver() {
        isGameOver = true

        // Save best score
        if score > bestScore {
            bestScore = score
            saveBestScore()
        }

        messageLabel.text = "Game Over!\nScore: \(score)\nBest: \(bestScore)\n\nClick to Restart"
        messageLabel.isHidden = false
    }

    func didBegin(_ contact: SKPhysicsContact) {
        if !isGameOver {
            gameOver()
        }
    }

    func loadBestScore() {
        bestScore = UserDefaults.standard.integer(forKey: "bestScore")
    }

    func saveBestScore() {
        UserDefaults.standard.set(bestScore, forKey: "bestScore")
    }
}
