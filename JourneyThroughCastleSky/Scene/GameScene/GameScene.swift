//
//  GameScene.swift
//  JourneyThroughCastleSky
//
//  Created by Caio Marques on 11/09/24.
//

import SpriteKit
import GameplayKit

protocol Command {
    func execute() -> Void
}

class Consumable: Command {
    func execute() {
        
    }
}

class GameScene: TopDownScene {
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        setupWalls()
        setupCheckpoint()
    }
    
    private func setupWalls () {
        enumerateChildNodes(withName: "wall") { node, _ in
            Wall.setupPhysicsBody(node as! SKSpriteNode)
        }
    }
    
    private func setupCheckpoint () {
        //self.checkpoint = Checkpoint(xPosition: 1000, yPosition: 100, nextScene: GameScene(size: self.size, enemies: [], itens: [], friendlies: []))
        //checkpoint?.addToScene(self)
        
        let checkPoint = childNode(withName: "checkpoint") as? SKSpriteNode
        guard let checkPoint else {print("Não existe o checkpoint");return}
        
        checkPoint.physicsBody = SKPhysicsBody(rectangleOf: checkPoint.size)
        checkPoint.physicsBody?.categoryBitMask = PhysicCategory.checkpoint
        checkPoint.physicsBody?.collisionBitMask = PhysicCategory.character
        checkPoint.physicsBody?.contactTestBitMask = PhysicCategory.character
        checkPoint.physicsBody?.affectedByGravity = false
        checkPoint.physicsBody?.isDynamic = false // não se move
    }
    
    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
    }
    
    override func keyDown(with event: NSEvent) {
        super.keyDown(with: event)
    }
    
    override func keyUp(with event: NSEvent) {
        movementSystem.keyUp(event)
    }

    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let primeiroBody: SKPhysicsBody
        let segundoBody: SKPhysicsBody
                
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            primeiroBody = contact.bodyA
            segundoBody = contact.bodyB
        } else {
            primeiroBody = contact.bodyB
            segundoBody = contact.bodyA
        }
        
        
        if primeiroBody.categoryBitMask == PhysicCategory.character && segundoBody.categoryBitMask == PhysicCategory.checkpoint {
            if User.singleton.inventoryComponent.itens.contains(where: { item in
                item.consumableComponent?.nome == "Chaves"
            }) {
                self.view?.presentScene(SKScene(), transition: SKTransition.fade(withDuration: 1.0))
            } else {
                self.dialogsToPass.append(Dialogue(text: "Preciso da chave para entrar aqui...", person: "you", velocity: 20))
                dialogSystem.nextDialogue()
            }
        }
        
        if primeiroBody.categoryBitMask == PhysicCategory.character && segundoBody.categoryBitMask == PhysicCategory.enemy {
            self.enemies.forEach { enemy in
                if enemy.spriteComponent.sprite.physicsBody == segundoBody {
                    // Troca para a próxima cena
                    let nextScene = BatalhaScene(size: size)
                    nextScene.config(enemy: enemy)
                    enemy.spriteComponent.sprite.removeFromParent()
                    nextScene.scaleMode = .aspectFill
                            
                    let transition = SKTransition.fade(withDuration: 1.0)
                    nextScene.config(self)
                    self.view?.presentScene(nextScene, transition: transition)
                }
            }
        }
    }
}
