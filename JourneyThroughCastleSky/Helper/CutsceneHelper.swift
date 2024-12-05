//
//  CutsceneHelper.swift
//  JourneyThroughCastleSky
//
//  Created by Caio Marques on 29/10/24.
//

import Foundation
import SpriteKit

// o cutsceneHelper vai ter alguns atributos dentro dele que serão a lista das cutscenes do jogo.
class CutsceneHelper {
    let cutsceneOne = [
        Cutscene(background: SKSpriteNode(imageNamed: "cutscene1_1"), displayText: ""),
        Cutscene(background: SKSpriteNode(imageNamed: "cutscene1_2"), displayText: ""),
        Cutscene(background: SKSpriteNode(imageNamed: "cutscene1_3"), displayText: ""),
        Cutscene(background: SKSpriteNode(imageNamed: "cutscene1_4"), displayText: ""),
        Cutscene(background: SKSpriteNode(imageNamed: "cutscene1_5"), displayText: ""),
        Cutscene(background: SKSpriteNode(imageNamed: "cutscene1_6"), displayText: ""),
    ]
    
    let cutsceneTwo : [Cutscene] = [
        Cutscene(background: SKSpriteNode(imageNamed: "cutscene2_1"), displayText: ""),
        Cutscene(background: SKSpriteNode(imageNamed: "cutscene2_2"), displayText: ""),
        Cutscene(background: SKSpriteNode(imageNamed: "cutscene2_3"), displayText: ""),
        Cutscene(background: SKSpriteNode(imageNamed: "cutscene2_4"), displayText: ""),
        Cutscene(background: SKSpriteNode(imageNamed: "cutscene2_5"), displayText: ""),
        Cutscene(background: SKSpriteNode(imageNamed: "cutscene2_6"), displayText: ""),
    ]
    
    let cutsceneThree : [Cutscene] = [
        Cutscene(background: SKSpriteNode(imageNamed: "cutscene3_1"), displayText: ""),
        Cutscene(background: SKSpriteNode(imageNamed: "cutscene3_2"), displayText: ""),
        Cutscene(background: SKSpriteNode(imageNamed: "cutscene3_3"), displayText: ""),
        Cutscene(background: SKSpriteNode(imageNamed: "cutscene3_4"), displayText: ""),
        Cutscene(background: SKSpriteNode(imageNamed: "cutscene3_5"), displayText: ""),
        Cutscene(background: SKSpriteNode(imageNamed: "cutscene3_6"), displayText: ""),
    ]
}
