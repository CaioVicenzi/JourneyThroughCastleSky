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
    
    // MARK:
    ///Função que faz o setup da câmera do topdown, que vai seguir o usuário ao longo da caminhada dele.
    internal func setupCamera () {
        //cameraNode.position = .zero
        //addChild(cameraNode)
        self.camera = cameraNode
    }
    
    /*
    ///Função que faz o setup do background, setando as propriedades da posição dele, do tamanho e da zPosition, colocando-a abaixo de todos os nodes.
    internal func setupBackground () {
        guard let background else {
            print("Não temos background")
            return
        }
        
        background.position = CGPoint(x: size.width, y: size.height)
        background.size = CGSize(width: size.width * 2, height: size.height * 2)
        background.zPosition = -1
        addChild(background)
    }
     */
    
    /// Função que faz o setup do sprite do usuário, posicionando ele dentro do mapa..
    internal func setupSprite () {
        setupSpritePosition(User.singleton.spriteComponent, User.singleton.positionComponent, scale: 0.2)
        
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
    
    // MARK: FUNÇÕES QUE POSICIONAM ELEMENTOS EM LISTA DENTRO DO MAPA (ITENS, INIMIGOS E AMIGÁVEIS).
    /// Função que posiciona todos os inimigos dentro da lista de enemies dentro do mapa.
    internal func setupEnemies () {
        self.enumerateChildNodes(withName: "strongEnemy") { node, _ in
            guard let node = node as? SKSpriteNode else {print("Erro na hora de inicializar o corpo físico dos elementos"); return}
            self.enemies.append(Enemy(x: Int(node.position.x), y: Int(node.position.y), damage: 10, health: 100, spriteName: "papyrus"))
        }
        
        self.enumerateChildNodes(withName: "weakEnemy") { node, _ in
            guard let node = node as? SKSpriteNode else {print("Erro na hora de inicializar o corpo físico dos elementos"); return}
            self.enemies.append(Enemy(x: Int(node.position.x), y: Int(node.position.y), damage: 10, health: 100, spriteName: "papyrus"))
        }
    }
    
    /// Função que posiciona todos os amigáveis dentro da lista de friendlies dentro do mapa.
    internal func setupFriendlies () {
        friendlySystem.friendlies.forEach { friendly in
            setupSpritePosition(friendly.spriteComponent, friendly.positionComponent, scale: 0.1)
        }
    }
    
    /// Função que posiciona todos os itens dentro da lista de itens dentro do mapa.
    internal func setupItems () {
        self.enumerateChildNodes(withName: "cure") { node, _ in
            guard let node = node as? SKSpriteNode else {print("Erro na hora de inicializar o corpo físico dos elementos"); return}
            self.itemSystem.items.append(Item(name: "Bolinho brabo", spriteName: "cupcake", effect: Effect(type: .CURE, amount: 10), x: Int(node.position.x), y: Int(node.position.y), description: "Um bolinho que pode recuperar a sua vida 10"))
        }
        
        self.enumerateChildNodes(withName: "damage") { node, _ in
            guard let node = node as? SKSpriteNode else {print("Erro na hora de inicializar o corpo físico dos elementos"); return}
            self.itemSystem.items.append(Item(name: "Balão de guerra", spriteName: "balloon", effect: Effect(type: .DAMAGE, amount: 10), x: Int(node.position.x), y: Int(node.position.y), description: "Um bolinho que pode aumentar o ataque em 10 dmg"))
        }
        
        self.enumerateChildNodes(withName: "estamina") { node, _ in
            guard let node = node as? SKSpriteNode else {print("Erro na hora de inicializar o corpo físico dos elementos"); return}
            self.itemSystem.items.append(Item(name: "Maçã de diamante", spriteName: "diamondApple", effect: Effect(type: .STAMINE, amount: 10), x: Int(node.position.x), y: Int(node.position.y), description: "Uma maçã de diamante que pode aumentar a estamina em 10 stm"))
        }
    }
    
    
    /// Função que faz o setup de qualquer elemento que contenha um sprite, um posicionamento e uma escala.
    func setupSpritePosition (_ spriteComponent : SpriteComponent, _ positionComponent : PositionComponent, scale : CGFloat = 1) {
        let sprite = spriteComponent.sprite
        sprite.position.y = CGFloat(positionComponent.yPosition)
        sprite.position.x = CGFloat(positionComponent.xPosition)
        sprite.setScale(scale)
        addChild(sprite)
    }
    
    // MARK: FUNÇÕES QUE FAZEM O SETUP DE OUTROS ELEMENTOS DENTRO DO MAPA.
    
    func setupCatchLabel () {
        self.catchLabel = SKLabelNode()
        
        if itemSystem.isAnyItemNear() {
            catchLabel?.text = "Press Enter to catch item"
        }
        
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
