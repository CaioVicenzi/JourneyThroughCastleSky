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
        let numberOfRows = 4
        let totalHeightAvailable = self.size.height * 0.45
        let rowHeight = totalHeightAvailable / CGFloat(numberOfRows)
        
        var rowNodes: [SKShapeNode] = []
        
        for i in 0..<numberOfRows {
            let individualRow = SKShapeNode(rect: CGRect(x: -(self.size.width * 0.925) / 2,
                                                         y: (-self.size.height * 0.45)/5 - (CGFloat(i) * rowHeight),
                                                         width: self.size.width * 0.4625,
                                                         height: rowHeight))
            
            individualRow.fillColor = .gray
            individualRow.strokeColor = .black
            
            //individualRow.isUserInteractionEnabled = true
            
            individualRow.name = "rowButton\(i)"
            
            let label = SKLabelNode(text: returnButtonLabel(i))
            
            label.position.x = 0 - (individualRow.frame.width / 2)
            label.position.y = 0 - (individualRow.frame.height / 2) - (label.frame.height / 2)
            label.position.y -= CGFloat(Int(rowHeight) * i)

            individualRow.addChild(label)
            
            addChild(individualRow)
            rowNodes.append(individualRow)
        }
        updateColorChooseOption()
    }
    
    func setupItemRows () {
        guard let actionDescription else {return}
        
        var i = 0
        for item in User.singleton.inventoryComponent.itens {
            var rowNodes: [SKShapeNode] = []
            
            let individualRow = SKShapeNode(rectOf: CGSize(width: actionDescription.frame.width, height: 100))
            individualRow.position = .zero
            
            individualRow.position.x += (individualRow.frame.width / 2) - 3
            individualRow.position.y -= (individualRow.frame.height / 2)
            individualRow.position.y -= (individualRow.frame.height) * CGFloat(i)
            if i != 0 {
                individualRow.position.y -= 2
            }
            
            individualRow.fillColor = .gray
            individualRow.strokeColor = .black
                
                
            individualRow.name = "itemRow\(i)"
                
            let label = SKLabelNode(text: item.consumableComponent?.nome)
                
            label.position.x = .zero
            label.position.y = .zero

            individualRow.addChild(label)
                
            addChild(individualRow)
            rowNodes.append(individualRow)
            i += 1
        }
        
        refreshItemState()
    }
    
    func returnButtonLabel (_ index : Int) -> String {
        if index == 0 {
            return "Attack"
        } else if index == 1 {
            return "Items"
        } else if index == 2 {
            return "Dodge"
        } else {
            return "Run"
        }
    }
        
    func setupActionDescription(){
        actionDescription = SKShapeNode(rect: CGRect(x: (self.size.width*0.925)/2, y: -self.size.height*0.45, width: -self.size.width*0.4625, height: self.size.height*0.45))
        
        guard let actionDescription else {return}
            
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
        
    func setupStaminaBar(){
        let staminaBar = SKShapeNode(rect: CGRect(x: -(self.size.width*0.925)/2, y: 0, width: self.size.width*0.925, height: self.size.height*0.045))
        
        staminaBar.fillColor = .purple
        staminaBar.strokeColor = .black
        
        addChild(staminaBar)
    }
    
    func handleButtonPress(named buttonName: String) {
        print("\(buttonName) foi pressionado")
            
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
