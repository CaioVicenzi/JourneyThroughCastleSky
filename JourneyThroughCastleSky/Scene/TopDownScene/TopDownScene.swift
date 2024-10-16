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
    
    var bounds: CGRect {
        
        let boundsNode = self.childNode(withName: "bounds")!
        
        return boundsNode.frame
        
    }
    
    var enemies : [Enemy]
    var inventoryItemSelected = 0
    
    var dialogueBox : SKShapeNode?
    var viewItemDescription : SKShapeNode?
    var inventory : SKShapeNode?
    var catchLabel : SKLabelNode?
    var titleSelectedItem : SKLabelNode?
    var descriptionSelectedItem : SKLabelNode?
    
    internal var cameraNode : SKCameraNode!
    
    internal let movementSystem : MovementSystem
    internal let itemSystem : ItemSystem
    internal let dialogSystem : DialogSystem
    internal let friendlySystem : FriendlySystem
    internal let menuSystem : MenuSystem
    internal let positionSystem : PositionSystem
    internal let inventorySystem : InventorySystem
    
    var descriptionsToPass : [DescriptionToPass] = []
    
    var gameState : GameState = .NORMAL
    
    let pauseUIComponent : PauseMenu = PauseMenu()
    
    var useItemLabel : SKLabelNode?
    
    required init?(coder aDecoder: NSCoder) {
        //fatalError("init?(coder aDecoder : NSCoder) não implementado")
        
        self.enemies = []
        self.movementSystem = MovementSystem()
        self.dialogSystem = DialogSystem()
        self.friendlySystem = FriendlySystem(friendlies: [])
        self.itemSystem = ItemSystem(items: [])
        self.menuSystem = MenuSystem()
        self.positionSystem = PositionSystem()
        self.inventorySystem = InventorySystem()
        
        
        super.init(coder: aDecoder)
        
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        config()
        setupNodes()
        setupTileColliders()
    }
    
    internal func config () {
        // permite receber input do teclado
        self.view?.window?.makeFirstResponder(self)
        
        
        
        // configurando os systems
        dialogSystem.config(self)
        movementSystem.config(self)
        itemSystem.config(self)
        friendlySystem.config(self)
        menuSystem.config(self)
        inventorySystem.config(self)
        inventorySystem.config(self)
        
        // inicializando o cameraNode.
        cameraNode = childNode(withName: "cameraNode") as? SKCameraNode
        
        
        self.physicsWorld.gravity = .zero
        self.physicsWorld.contactDelegate = self
    }
    
    
    
    // TODO: Otimizar a quantidade de nodes com colisão
    private func setupTileColliders() {
        
        let nodes = children
        
        for case let node as SKTileMapNode in nodes {
            guard node.userData?.value(forKey: "hasCollision") as? Int == 1 else {
                print("coco bosta")
                continue
            }
           
            let nodeSize = CGSize(
                width: node.numberOfColumns,
                height: node.numberOfRows
            )
            
            
            for y in 0..<Int(nodeSize.height) {
                for x in 0..<Int(nodeSize.width) {
                    
                    let tileDefinition = node.tileDefinition(atColumn: x, row: y)
                    
                    
                    if let texture = tileDefinition?.textures[0] {
                        let tileWorldCoord = node.centerOfTile(atColumn: x, row: y)
                        let collisionNode = SKNode()
                        collisionNode.position = tileWorldCoord
                        
                        let physicsBody: SKPhysicsBody = .init(
                            rectangleOf: texture.size()
                        )
                        physicsBody.friction = 0
                        physicsBody.categoryBitMask = PhysicCategory.wall
                        
                        physicsBody.isDynamic = false
                        
                        collisionNode.physicsBody = physicsBody
                        
                        addChild(collisionNode)
                        
                        
                    }
                    
                }
            }
            
            
        }
        
    }
    
    internal func setupNodes () {
        self.camera = cameraNode
        setupSprite()
    }
    
    override func update(_ currentTime: TimeInterval) {
        movementSystem.movePlayer()
        itemSystem.showCatchLabel()
        if gameState == .INVENTORY {
            updateInventorySquares()
        }
        updateSelectedItemLabels()
    }
}
