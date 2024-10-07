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
        actionDescription = SKShapeNode(rect: CGRect(x: 0, y: 0, width: -self.size.width*0.4625, height: self.size.height*0.45))
        
        
        actionDescription.position = CGPoint(x: (self.size.width*0.925)/2, y: -self.size.height*0.45)
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
    
    public func showItems () {
        // PRIMEIRO PASSO: ELIMINAR OS BOTÕES POSSÍVEIS
        buttonSpare.removeFromParent()
        buttonAttack.removeFromParent()
        buttonUseItem.removeFromParent()
        
        var referencia : Int = 150
        var referencia2 : Int = 0
        var itemNumber : Int = 0
        
        let list = User.singleton.inventoryComponent.itens.reduce([]) { partialResult, item in
            print(item)
            var result = partialResult
            result.append(item.labelComponent.label)
            
            return result
        } as [String]
        
        showList(list: list)
        
        // SEGUNDO PASSO: ADICIONAR OS ITENS NA TELA
        User.singleton.inventoryComponent.itens.forEach { item in
            let quadrado = SKShapeNode(rect: CGRect(origin: PositionHelper.singleton.centralizeQuarterLeft(buttonAttack), size: CGSize(width: 100, height: 50)))
            quadrado.position.x += CGFloat(referencia)
            quadrado.fillColor = .gray
            referencia += 150
            
            
            let itemSprite = item.spriteComponent.sprite
            itemSprite.scale(to: CGSize(width: 40, height: 40))
            itemSprite.position = CGPoint(x: 200, y: 150)
            itemSprite.position.x += CGFloat(referencia2)
            referencia2 += 10
            
            quadrado.addChild(itemSprite)
            quadrado.name = "quadradoItem\(itemNumber)"
            itemNumber += 1
            
            addChild(quadrado)
        }
    }
    
    private func showList(list: [String]) {
        let actionDescriptionFrame = actionDescription.calculateAccumulatedFrame()
        for (index, item) in list.enumerated() {
            let label = SKLabelNode(text: item)
            label.position = .init(x: , y: <#T##CGFloat#>)
            
            
            addChild(label)
        }
        
        
    }
    
    private func clearList() {
        
    }
    
    
    // Eu tenho que deletar isso depois
    func voidFunc() {
        
    }
    
    func handleButtonPress(named buttonName: String) {
        let actions = [
            battleSystem.attack,
            showItems,
            voidFunc,
            spare,
            voidFunc,
        ]
        
        let index = Int(buttonName.suffix(1))!
        
        actions[index]()
        
        enemyTurn()
    }
}
