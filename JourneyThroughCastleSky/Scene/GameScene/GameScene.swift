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
        
        super.config()
        super.setupNodes()
        setupWalls()
        setupCheckpoint()
        
        if GameSceneData.shared == nil {
            setupEnemies()
            setupItems()
            setupFriendlies()
        } else {
            populateDataFromGameSceneData()
        }
        movementSystem.updateCameraPosition()

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
        
        let collidedWithDoorNextScene = primeiroBody.categoryBitMask == PhysicCategory.character && segundoBody.categoryBitMask == PhysicCategory.checkpoint
        let collidedWithEnemy = primeiroBody.categoryBitMask == PhysicCategory.character && segundoBody.categoryBitMask == PhysicCategory.enemy
        
        if collidedWithDoorNextScene {
            if User.singleton.inventoryComponent.itens.contains(where: { item in
                item.consumableComponent?.nome == "Chaves"
            }) {
                self.view?.presentScene(SKScene(), transition: SKTransition.fade(withDuration: 1.0))
            } else {
                self.dialogSystem.inputDialog("Preciso da chave para entrar aqui...", person: "You", velocity: 20)
                dialogSystem.nextDialogue()
            }
        }
        if collidedWithEnemy { collideWithEnemy(segundoBody) }
    }
    
    private func collideWithEnemy (_ enemyPhysicsBody : SKPhysicsBody) {
        self.enemies.forEach { enemy in
            if enemy.spriteComponent.sprite.physicsBody == enemyPhysicsBody {
                populateGameSceneData()
                
                // Troca para a cena da batalha
                let nextScene = BatalhaScene(size: size)
                nextScene.config(enemy: enemy)
                nextScene.position = .zero
                enemy.spriteComponent.sprite.removeFromParent()
                nextScene.scaleMode = .aspectFill
                        
                let transition = SKTransition.fade(withDuration: 1.0)
                nextScene.config(self)
                nextScene.zPosition = 100
                self.view?.presentScene(nextScene, transition: transition)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                    self.removeAllChilds()
                })
                
            }
        }
    }
    
    private func removeAllChilds () {
        for child in self.children {
            child.removeFromParent()
        }
    }
    
    private func populateGameSceneData () {
        GameSceneData.shared = GameSceneData(enemies: enemies, friendlies: friendlySystem.friendlies, items: itemSystem.items)
    }
    
    private func populateDataFromGameSceneData () {
        guard let shared = GameSceneData.shared else {return}
        
        self.enemies = shared.enemies
        self.itemSystem.items = shared.items
        self.friendlySystem.friendlies = shared.friendlies
        
        excludeAll("strongEnemy")
        excludeAll("weakEnemy")
        excludeAll("cure")
        excludeAll("damage")
        excludeAll("estamina")
        excludeAll("key")
        
        for enemy in shared.enemies {
            addChild(enemy.spriteComponent.sprite)
        }
        
        for friendly in shared.friendlies {
            addChild(friendly.spriteComponent.sprite)
        }
        
        for item in shared.items {
            addChild(item.spriteComponent.sprite)
        }
    }
    
    
    /// Função que posiciona todos os inimigos dentro da lista de enemies dentro do mapa.
    internal func setupEnemies () {
        setupEnemy("strongEnemy", spriteName: "papyrus")
        setupEnemy("weakEnemy", spriteName: "monster")
    }
    
    private func setupEnemy (_ name : String, spriteName : String) {
        self.enumerateChildNodes(withName: name) { node, _ in
            guard let node = node as? SKSpriteNode else {print("Erro na hora de inicializar o corpo físico dos elementos"); return}
            
            let enemyCriado = Enemy(x: Int(node.position.x), y: Int(node.position.y), damage: 10, health: 100, spriteName: spriteName)
            
            let spriteInimigo = enemyCriado.spriteComponent.sprite
            let enemyWidth = spriteInimigo.size.width
            let enemyHeight = spriteInimigo.size.height
            
            spriteInimigo.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: enemyWidth, height: enemyHeight))
            spriteInimigo.physicsBody?.categoryBitMask  = PhysicCategory.enemy
            spriteInimigo.physicsBody?.collisionBitMask = PhysicCategory.character
            spriteInimigo.physicsBody?.contactTestBitMask = PhysicCategory.character
            spriteInimigo.physicsBody?.affectedByGravity = false
            spriteInimigo.physicsBody?.isDynamic = false
            spriteInimigo.physicsBody?.allowsRotation = false
            
            self.enemies.append(enemyCriado)
            self.setupSpritePosition(enemyCriado.spriteComponent, enemyCriado.positionComponent, scale: CGSize(width: 100, height: 100))
        }
        
        excludeAll(name)
    }
    
    /// Função que posiciona todos os amigáveis dentro da lista de friendlies dentro do mapa.
    internal func setupFriendlies () {
        friendlySystem.friendlies.forEach { friendly in
            setupSpritePosition(friendly.spriteComponent, friendly.positionComponent, scale: CGSize(width: 100, height: 100))
        }
    }
    
    /// Função que posiciona todos os itens dentro da lista de itens dentro do mapa.
    internal func setupItems () {
        
        setupItem("cure", spriteName: "cupcake", effect: Effect(type: .CURE, amount: 10))
        setupItem("damage", spriteName: "balloon", effect: Effect(type: .DAMAGE, amount: 10))
        setupItem("estamina", spriteName: "diamondApple", effect: Effect(type: .STAMINE, amount: 10))
        setupItem("key", spriteName: "key", effect: Effect(type: .NONE, amount: 0))
    }
    
    private func setupItem (_ name : String, spriteName : String, effect : Effect) {
        enumerateChildNodes(withName: name) { node, _ in
            guard let node = node as? SKSpriteNode else {print("Erro na hora de inicializar o corpo físico dos elementos"); return}
            
            var nameItem : String
            var descriptionItem : String
            
            switch effect.type {
            case .CURE: nameItem = "Bolinho lendário"; descriptionItem = "Um bolinho lendário que recupera sua vida em 10"
            case .DAMAGE: nameItem = "Balão de guerra"; descriptionItem = "Um balão que aumenta seu ataque em 10"
            case .STAMINE: nameItem = "Maçã de diamante"; descriptionItem = "Uma maçã que aumenta sua estamina em 10"
            case .NONE: nameItem = "Chaves"; descriptionItem = "Uma chave misteriosa"
            }
            
            
            let createdItem = Item(name: nameItem, spriteName: spriteName, effect: effect, x: Int(node.position.x), y: Int(node.position.y), description: descriptionItem)
            
            self.itemSystem.items.append(createdItem)
            self.setupSpritePosition(createdItem.spriteComponent, createdItem.positionComponent, scale: CGSize(width: 75, height: 75))
        }
        
        excludeAll(name)
    }
    
    private func excludeAll (_ spriteName : String) {
        enumerateChildNodes(withName: spriteName) { node, _ in
            node.removeFromParent()
        }
    }
    
    private func setupNodesInList () {
        for item in itemSystem.items {
            addChild(item.spriteComponent.sprite)
        }
        
        for friendly in friendlySystem.friendlies {
            addChild(friendly.spriteComponent.sprite)
        }
        
        for enemy in self.enemies {
            addChild(enemy.spriteComponent.sprite)
        }
    }
}
