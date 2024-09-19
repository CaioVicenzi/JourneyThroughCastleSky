//
//  YouWinScene.swift
//  JourneyThroughCastleSky
//
//  Created by Caio Marques on 12/09/24.
//

import Foundation
import SpriteKit

class YouWinScene : SKScene {
    override func didMove(to view: SKView) {
        let parabensLabel = SKLabelNode(text: "Você venceu!!")
        parabensLabel.position = PositionHelper.singleton.centralize(parabensLabel)
        addChild(parabensLabel)
    }
}
