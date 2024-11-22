import Foundation
import SpriteKit

class Credits {
    var pause : Pause
    var creditsBackground : SKShapeNode?
    
    init(_ pause: Pause) {
        self.pause = pause
    }
    
    func setupCredits () {
        creditsBackground = SKShapeNode(rectOf: CGSize(width: pause.gameScene.size.width / 1.2, height: pause.gameScene.size.height / 1.8))
        creditsBackground?.position = .zero
        creditsBackground?.fillColor = .clear
        creditsBackground?.strokeColor = .clear
        creditsBackground?.position.y -= 50
        if let creditsBackground {
            pause.pauseBackground?.addChild(creditsBackground)
        }
        
        let creditsBackground2 = SKSpriteNode(imageNamed: "itemsInventory")
        creditsBackground2.position = .zero
        creditsBackground2.setScale(0.6)
        creditsBackground?.addChild(creditsBackground2)
        
        let creditsTitle = SKLabelNode()
        creditsTitle.text = "Créditos"
        creditsTitle.position = .zero
        creditsTitle.fontName = "Lora-Medium"
        creditsTitle.position.y += creditsBackground2.frame.height / 1.9
        creditsTitle.fontSize = 72
        creditsTitle.zPosition += 1
        creditsTitle.fontColor = .black
        creditsBackground2.addChild(creditsTitle)
        
        let developersTitle = SKLabelNode(text: "Developers")
        developersTitle.fontName = "Lora-Bold"
        developersTitle.position = .zero
        developersTitle.position.y += creditsBackground2.frame.height / 4
        developersTitle.position.x -= creditsBackground2.frame.width / 2
        developersTitle.zPosition += 1
        developersTitle.fontColor = .black
        creditsBackground2.addChild(developersTitle)
        
        let developers = SKLabelNode()
        developers.text = """
            Caio Marques
            João Ângelo
            Chus
        """
        developers.position = .zero
        developers.numberOfLines = 0
        developers.fontName = "Lora-Medium"
        developers.position.x -= creditsBackground2.frame.width / 2.2
        //developers.position.y -= creditsBackground2.frame.height / 6
        developers.zPosition += 1
        developers.fontSize = 20
        developers.fontColor = .black
        creditsBackground2.addChild(developers)
        
        let designersTitle = SKLabelNode()
        designersTitle.text = "Designers"
        designersTitle.fontName = "Lora-Bold"
        designersTitle.position = .zero
        designersTitle.position.y += creditsBackground2.frame.height / 4
        designersTitle.position.x += creditsBackground2.frame.width / 3
        designersTitle.zPosition += 1
        designersTitle.fontColor = .black
        creditsBackground2.addChild(designersTitle)

        let designers = SKLabelNode()
        designers.text = "Vanessa nessa\nSamuel Lima"
        designers.position = .zero
        designers.numberOfLines = 0
        designers.fontName = "Lora-Medium"
        designers.position.x += creditsBackground2.frame.width / 2.8
        //designers.position.y -= creditsBackground2.frame.height / 4
        designers.zPosition += 1
        designers.fontColor = .black
        designers.fontSize = 20
        creditsBackground2.addChild(designers)
        
        creditsBackground?.isHidden  = true
    }

}
