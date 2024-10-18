//
//  TopDownScene_UI.swift
//  JourneyThroughCastleSky
//
//  Created by Caio Marques on 25/09/24.
//

import Foundation
import SpriteKit


/// Como a TopDownScene estava ficando muito gigantesca e enorme, eu decidi dividir as partes que renderizam a UI do jogo para esse arquivo.
extension TopDownScene {
    /// Função que faz o setup do sprite do usuário, posicionando ele dentro do mapa..
    internal func setupSprite () {
        setupSpritePosition(User.singleton.spriteComponent, User.singleton.positionComponent, scale: CGSize(width: 75, height: 75))
        
        let sprite = User.singleton.spriteComponent.sprite
        
        
        let xSize = sprite.size.width / 2
        let ySize = sprite.size.height / 2
        
        sprite.zPosition = 10
        
        sprite.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: xSize, height: ySize))
        sprite.physicsBody?.categoryBitMask  = PhysicCategory.character
        sprite.physicsBody?.collisionBitMask = PhysicCategory.wall
        sprite.physicsBody?.contactTestBitMask = PhysicCategory.wall
        sprite.physicsBody?.affectedByGravity = false
        sprite.physicsBody?.isDynamic = true // pode se mover
        sprite.physicsBody?.allowsRotation = false
        
    }
    /*
    // MARK: FUNÇÕES QUE POSICIONAM ELEMENTOS EM LISTA DENTRO DO MAPA (ITENS, INIMIGOS E AMIGÁVEIS).
    /// Função que posiciona todos os inimigos dentro da lista de enemies dentro do mapa.
    internal func setupEnemies () {
        setupEnemy("strongEnemy", spriteName: "papyrus")
        setupEnemy("weakEnemy", spriteName: "enemy")
    }
    
    private func setupEnemy (_ name : String, spriteName : String) {
        self.enumerateChildNodes(withName: name) { node, _ in
            guard let node = node as? SKSpriteNode else {print("Erro na hora de inicializar o corpo físico dos elementos"); return}
            node.removeFromParent()
            
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
            node.removeFromParent()
            self.setupSpritePosition(createdItem.spriteComponent, createdItem.positionComponent, scale: CGSize(width: 75, height: 75))
        }
    }
    */
    
    /// Função que faz o setup de qualquer elemento que contenha um sprite, um posicionamento e uma escala.
    func setupSpritePosition (_ spriteComponent : SpriteComponent, _ positionComponent : PositionComponent, scale : CGSize = CGSize(width: 100, height: 100)) {
        let sprite = spriteComponent.sprite
        sprite.position.y = CGFloat(positionComponent.yPosition)
        sprite.position.x = CGFloat(positionComponent.xPosition)
        
        sprite.scale(to: scale)
        addChild(sprite)
    }
    
    // MARK: FUNÇÕES QUE FAZEM O SETUP DE OUTROS ELEMENTOS DENTRO DO MAPA.
    
    func setupCatchLabel () {
        self.catchLabel = SKLabelNode()
        catchLabel?.text = "Press Enter to catch item"
        catchLabel?.fontColor = .blue
        catchLabel?.fontName = "Helvetica-Bold"
        catchLabel?.fontSize = 12
        catchLabel?.position = CGPoint(x: -(self.size.width / 3.47), y: -(self.size.height / 3))
        catchLabel?.zPosition = 3
        
        if let catchLabel {
            if catchLabel.parent == nil {
                cameraNode.addChild(catchLabel)
            }
        }
    }
}
