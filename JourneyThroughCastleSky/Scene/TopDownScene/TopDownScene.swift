//
//  TopDownScene.swift
//  JourneyThroughCastleSky
//
//  Created by Caio Marques on 25/09/24.
//

import Foundation
import SpriteKit

/// Classe genérica que vai conter todos os atributos e métodos que são compartilhados por todas as cenas que contém o modo TopDown de exploração de ambiente.
/// - parameters
///   - enemies: são uma lista contendo todos os inimigos que se deseja colocar dentro da cena;
///   - itens: são uma lista contendo todos os itens que se deseja colocar dentro da cena;
///   - friendliest: são uma lista contendo todos os amigáveis que se deseja colocar dentro da cena;
///   - background: um sprite que contém o fundo da cena.
class TopDownScene : SKScene {
    let enemies : [Enemy]
    let itens : [Item]
    let frindlies : [Friendly]
    
    var background : SKSpriteNode?
    var dialogueBox : SKShapeNode?
    var viewItemDescription : SKShapeNode?
    var inventory : SKShapeNode?
    var buttonCatch : SKShapeNode?
    
    internal var cameraNode : SKCameraNode!
    
    internal let movementSystem : MovementSystem
    internal let itemSystem : ItemSystem
    internal let dialogSystem : DialogSystem
    
    var dialogsToPass : [Dialogue] = []
    var descriptionsToPass : [DescriptionToPass] = []
    
    var gameState : GameState = .NORMAL
    
    private init(enemies : [Enemy], itens : [Item], friendlies : [Friendly], background : SKSpriteNode) {
        self.enemies = enemies
        self.itens = itens
        self.frindlies = friendlies
        self.background = background
        
        self.movementSystem = MovementSystem()
        self.itemSystem = ItemSystem()
        self.dialogSystem = DialogSystem()
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init?(coder aDecoder : NSCoder) não implementado")
    }
    
    init(size: CGSize, enemies : [Enemy], itens : [Item], friendlies : [Friendly], background : SKSpriteNode) {
        self.enemies = enemies
        self.itens = itens
        self.frindlies = friendlies
        self.background = background
        
        self.movementSystem = MovementSystem()
        self.itemSystem = ItemSystem()
        self.dialogSystem = DialogSystem()
        super.init(size: size)
    }
    
    internal func config () {
        // permite receber input do teclado
        self.view?.window?.makeFirstResponder(self)
        
        // configurando os systems
        dialogSystem.config(self)
        movementSystem.config(self)
        itemSystem.config(self)
        
        // inicializando o cameraNode.
        cameraNode = SKCameraNode()
    }
        
    internal func setupNodes () {
        setupCamera()
        setupBackground()
        setupSprite()
        setupEnemies()
        setupItems()
        setupButtonInventory()
        setupFriendlies()
    }
}
