//
//  TopDownScene.swift
//  JourneyThroughCastleSky
//
//  Created by Victor Soares on 26/09/24.
//
import Foundation
import SpriteKit

/// Classe genérica que vai conter todos os atributos e métodos que são compartilhados por todas as cenas que contém o modo TopDown de exploração de ambiente.
/// - parameters
///   - enemies: são uma lista contendo todos os inimigos que se deseja colocar dentro da cena;
///   - itens: são uma lista contendo todos os itens que se deseja colocar dentro da cena;
///   - friendliest: são uma lista contendo todos os amigáveis que se deseja colocar dentro da cena;
///   - background: um sprite que contém o fundo da cena.
class TopDownScene : SKScene, SKPhysicsContactDelegate {
    var enemies : [Enemy]
    //let itens : [Item]
    var inventoryItemSelected = 0
    
    var dialogueBox : SKShapeNode?
    var viewItemDescription : SKShapeNode?
    var inventory : SKShapeNode?
    //var buttonCatch : SKShapeNode?
    var catchLabel : SKLabelNode?
    
    internal var cameraNode : SKCameraNode!
    
    internal let movementSystem : MovementSystem
    internal let itemSystem : ItemSystem
    internal let dialogSystem : DialogSystem
    internal let friendlySystem : FriendlySystem
    
    var dialogsToPass : [Dialogue] = []
    var descriptionsToPass : [DescriptionToPass] = []
    
    var gameState : GameState = .NORMAL
    
    let pauseUIComponent : PauseMenu = PauseMenu()
    
    private init(enemies : [Enemy], itens : [Item], friendlies : [Friendly]) {
        self.enemies = enemies
        self.movementSystem = MovementSystem()
        self.dialogSystem = DialogSystem()
        self.friendlySystem = FriendlySystem(friendlies: friendlies)
        self.itemSystem = ItemSystem(items: itens)
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        //fatalError("init?(coder aDecoder : NSCoder) não implementado")
        
        self.enemies = []
        self.movementSystem = MovementSystem()
        self.dialogSystem = DialogSystem()
        self.friendlySystem = FriendlySystem(friendlies: [])
        self.itemSystem = ItemSystem(items: [])
        
        super.init(coder: aDecoder)
        
    }
    
    init(size: CGSize, enemies : [Enemy], itens : [Item], friendlies : [Friendly]) {
        self.enemies = enemies
        
        self.movementSystem = MovementSystem()
        self.dialogSystem = DialogSystem()
        
        
        self.itemSystem = ItemSystem(items: itens)
        self.friendlySystem = FriendlySystem(friendlies: friendlies)

        super.init(size: size)
    }
    
    internal func config () {
        // permite receber input do teclado
        self.view?.window?.makeFirstResponder(self)
        
        // configurando os systems
        dialogSystem.config(self)
        movementSystem.config(self)
        itemSystem.config(self)
        friendlySystem.config(self)
        
        // inicializando o cameraNode.
        cameraNode = childNode(withName: "cameraNode")! as! SKCameraNode
        
        
        self.physicsWorld.gravity = .zero
        self.physicsWorld.contactDelegate = self
    }
    
    internal func setupNodes () {
        setupCamera()
        //setupBackground()
        setupSprite()
        setupEnemies()
        setupItems()
        setupFriendlies()
    }
}
