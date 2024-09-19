//
//  GameScene.swift
//  JourneyThroughCastleSky
//
//  Created by Caio Marques on 11/09/24.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    let enemy = Enemy(x: 0, y: 0, damage: 10, health: 100, spriteName: "enemy")
    let item1 = Item(name: "balloon", spriteName: "balloon", dialogs: [], effect: Effect(type: .DAMAGE, amount: 10), x: 200, y: 200)
    let item2 = Item(name: "cupcake", spriteName: "cupcake", dialogs: [], effect: Effect(type: .CURE, amount: 15), x: 300, y: 300)
    
    var enemySprite : SKSpriteNode? = nil
    var item1Sprite : SKSpriteNode? = nil
    var item2Sprite : SKSpriteNode? = nil
    var playerSprite : SKSpriteNode? = nil
    var background : SKSpriteNode? = nil
    
    var inventory : SKShapeNode?
    internal var cameraNode : SKCameraNode!
    
    var buttonCatch : SKShapeNode? = nil
    
    private let movementSystem = MovementSystem()
    private let itemSystem = ItemSystem()

    override func didMove(to view: SKView) {
        config()
        movementSystem.config(self)
        itemSystem.config(self)
        
        setupCamera()
        setupBackground()
        setupSprite()
        setupEnemy()
        setupBalloon()
        setupCupcake()
        setupButtonInventory()
    }
    
    func config () {
        // permite receber input do teclado
        self.view?.window?.makeFirstResponder(self)
        playerSprite = User.singleton.spriteComponent.sprite
        enemySprite = enemy.spriteComponent.sprite
        item1Sprite = item1.spriteComponent.sprite
        item2Sprite = item2.spriteComponent.sprite
        background = SKSpriteNode(imageNamed: "background")
        cameraNode = SKCameraNode()
    }
    
    override func keyDown(with event: NSEvent) {
        movementSystem.keyDown(event)
    }
    
    override func keyUp(with event: NSEvent) {
        movementSystem.keyUp(event)
    }

    override func update(_ currentTime: TimeInterval) {
        movementSystem.movePlayer()
        movementSystem.updateCameraPosition()
        
        movementSystem.checkColision ()
        itemSystem.verifyButtonCatch()
    }
    
    // MARK: SETUP ELEMENTS
    
    private func setupCamera () {
        cameraNode.position = .zero
        addChild(cameraNode)
        self.camera = cameraNode
    }
    
    private func setupBackground () {
        guard let background else {
            print("Não temos background")
            return
        }
        
        background.position = CGPoint(x: size.width, y: size.height)
        background.size = CGSize(width: size.width * 2, height: size.height * 2)
        background.zPosition = -1
        addChild(background)
    }
    
    private func setupSprite () {
        guard let playerSprite else {
            print("Não temos sprite do player")
            return
        }
        
        playerSprite.setScale(0.2)
        let xPosition = User.singleton.positionComponent.xPosition
        let yPosition = User.singleton.positionComponent.yPosition
        
        playerSprite.position = CGPoint(x: xPosition, y: yPosition)
        self.scene?.addChild(playerSprite)
    }
    
    private func setupEnemy () {
        guard let enemySprite else {print("Não temos o sprite do inimigo"); return}
    
        enemySprite.setScale(0.2)
        
        enemy.positionComponent.xPosition = Int(PositionHelper.singleton.centralizeQuarterRight(enemySprite).x)
        enemy.positionComponent.yPosition = Int(PositionHelper.singleton.centralizeQuarterRight(enemySprite).y)
        enemySprite.position = CGPoint(x: enemy.positionComponent.xPosition, y: enemy.positionComponent.yPosition)
        self.addChild(enemySprite)
    }
    
    private func setupBalloon () {
        
        guard let item1Sprite else {
            print("Não temos o sprite do item")
            return
        }
        
        item1Sprite.setScale(0.2)
        
        let xPosition = item1.positionComponent.xPosition
        let yPosition = item1.positionComponent.yPosition
        item1Sprite.position = CGPoint(x: xPosition, y: yPosition)
        
        item1Sprite.name = "balloon"
        
        self.addChild(item1Sprite)
         
    }
    
    private func setupCupcake () {
        
        guard let item2Sprite else {
            print("Não temos o sprite do item")
            return
        }
        
        
        let xPosition = item2.positionComponent.xPosition
        let yPosition = item2.positionComponent.yPosition
        item2Sprite.position = CGPoint(x: xPosition, y: yPosition)
        item2Sprite.setScale(0.07)

        item2Sprite.name = "cupcake"
        
        self.addChild(item2Sprite)
         
    }
    
    func setupButtonCatch () {
        self.buttonCatch = SKShapeNode(rectOf: CGSize(width: 50, height: 50))
        
        guard let buttonCatch else {return}
        
        buttonCatch.fillColor = .blue
        buttonCatch.strokeColor = .white
        
        print("Tela tamanho: \(self.size.width), \(self.size.height)")
        buttonCatch.position = CGPoint(x: -(self.size.width / 3.47), y: -(self.size.height / 3))
        buttonCatch.zPosition = 3
        buttonCatch.name = "buttonCatch"
        
        cameraNode.addChild(buttonCatch)
    }
    
    private func setupButtonInventory () {
        let buttonInventory = SKShapeNode(rectOf: CGSize(width: 40, height: 40))
        buttonInventory.fillColor = .gray.withAlphaComponent(0.8)
        buttonInventory.strokeColor = .black
        buttonInventory.position = CGPoint(x: (self.size.width / 2) - 100, y: (self.size.height / 2) - 100)
        buttonInventory.name = "buttonInventory"
        buttonInventory.zPosition = 3
        cameraNode.addChild(buttonInventory)
    }
     
    
    internal func setupInventory () {
        // Definir o tamanho do inventário (80% da largura e 80% da altura da tela)
        let inventorySize = CGSize(width: size.width * 0.5, height: size.height * 0.5)
                
        // Cria o inventário como um SKShapeNode (um retângulo com bordas arredondadas)
        inventory = SKShapeNode(rectOf: inventorySize, cornerRadius: 20)
        guard let inventory else {return}
        
        // Configura a cor do inventário
        inventory.fillColor = .gray
        inventory.strokeColor = .white
        inventory.lineWidth = 5
        inventory.zPosition = 10
                
        // Centraliza o inventário na tela
        inventory.position = .zero//CGPoint(x: size.width / 2, y: size.height / 2)
        inventory.name = "inventory"
                
        // Adiciona o inventário à cena
        cameraNode.addChild(inventory)
        
        // LABEL DO INVENTÓRIO
        let inventoryLabel = SKLabelNode(text: "Inventário")
        inventoryLabel.position = .zero
        inventoryLabel.position.y += (inventory.frame.height / 2) - 70
        inventory.addChild(inventoryLabel)
        
                
        // Adiciona alguns itens ao inventário
        addInventoryItems()
    }
    
    private func addInventoryItems () {
        var reference = -100
        User.singleton.inventoryComponent.itens.forEach({ item in
            let node = item.spriteComponent.sprite
            node.scale(to: CGSize(width: 100, height: 100))
            node.position = .zero
            node.position.x += CGFloat(reference)
            reference += 100
            inventory?.addChild(node)
        })
    }
    
    // END MARK
    
    override func mouseDown(with event: NSEvent) {
        let location = event.location(in: self)
        let clickedNode = self.atPoint(location)
        
        
        if clickedNode.name == "buttonCatch"{
            itemSystem.catchItem()
        }
        
        
        if clickedNode.name == "buttonInventory" {
            self.itemSystem.inventoryButtonPressed()
        }
    }
}
