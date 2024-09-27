//
//  UIBatalhaScene.swift
//  JourneyThroughCastleSky
//
//  Created by Caio Marques on 13/09/24.
//

import Foundation
import SpriteKit

extension BatalhaScene{
    
    // MARK: SETUP UI
    
    func setupEnemyScreen(){
        let enemyScreen = SKShapeNode(rect: CGRect(x: -(self.size.width*0.925)/2, y: 0, width: self.size.width*0.925, height: self.size.height*0.45))
        
        enemyScreen.fillColor = .red
        enemyScreen.strokeColor = .black
        
        addChild(enemyScreen)
    }
    
    func setupRows() {
        let numberOfRows = 5
        let totalHeightAvailable = self.size.height * 0.45
        let rowHeight = totalHeightAvailable / CGFloat(numberOfRows)
        
        let buttonLabels = [
            
            "Atacar",
            "Itens",
            "Habilidades",
            "Fugir",
            "Esquivar",
        ]
        
        var rowNodes: [SKShapeNode] = []
        
        for (i, label) in buttonLabels.enumerated() {
            let individualRow = SKShapeNode(rect: CGRect(x: 0,
                                                         y: 0,
                                                         width: self.size.width * 0.4625,
                                                         height: rowHeight))
            
            individualRow.fillColor = .blue
            individualRow.strokeColor = .black
            
            individualRow.isUserInteractionEnabled = false
            individualRow.position = .init(x: -(self.size.width * 0.925) / 2, y: (-self.size.height * 0.45)/5 - (CGFloat(i) * rowHeight))
            let label = SKLabelNode(text: label)
            label.verticalAlignmentMode = .center
            label.position = .init(
                x: individualRow.position.x + individualRow
                    .calculateAccumulatedFrame().width * 0.5,
                y: individualRow
                    .position.y + individualRow
                    .calculateAccumulatedFrame().height * 0.5)
            print(individualRow.position)
            
            
            individualRow.name = "rowButton\(i)"
            
    
            rowNodes.append(individualRow)
            addChild(individualRow)
            addChild(label)
        }
    }
        
    func setupActionDescription(){
        let actionDescription = SKShapeNode(rect: CGRect(x: (self.size.width*0.925)/2, y: -self.size.height*0.45, width: -self.size.width*0.4625, height: self.size.height*0.45))
            
        actionDescription.fillColor = .yellow
        actionDescription.strokeColor = .black
            
        addChild(actionDescription)
    }
        
    func setupHealthBar(){
        let healthBar = SKShapeNode(rect: CGRect(x: -(self.size.width*0.925)/2, y: 0, width: self.size.width*0.4625, height: self.size.height*0.045))
            
        healthBar.fillColor = .green
        healthBar.strokeColor = .black
            
        addChild(healthBar)
    }
        
    func setupStaminaBar() {
        let staminaBar = SKShapeNode(rect: CGRect(x: -(self.size.width*0.925)/2, y: 0, width: self.size.width*0.925, height: self.size.height*0.045))
        
        staminaBar.fillColor = .purple
        staminaBar.strokeColor = .black
        
        addChild(staminaBar)
    }
    
    func handleButtonPress(named buttonName: String) {
        print("\(buttonName) foi pressionado")
        
        
        let actions = [
            attack
        ]
        
        let index = Int(buttonName.suffix(1))!
        
        actions[index]()
        
        switch buttonName {
        case "rowButton0":
            // Ação para o botão 0
            print("Ação do botão 0")
        case "rowButton1":
            // Ação para o botão 1
            print("Ação do botão 1")
        // Continue para os outros botões
        default:
            break
        }
    }
}
