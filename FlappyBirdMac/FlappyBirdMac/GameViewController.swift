import Cocoa
import SpriteKit

class GameViewController: NSViewController {

    override func loadView() {
        self.view = SKView(frame: NSRect(x: 0, y: 0, width: 800, height: 600))
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let view = self.view as? SKView {
            // Create and configure the scene
            let scene = GameScene(size: CGSize(width: 800, height: 600))
            scene.scaleMode = .aspectFill

            // Present the scene
            view.presentScene(scene)

            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
}
