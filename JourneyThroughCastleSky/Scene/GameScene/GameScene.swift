//
//  GameScene.swift
//  JourneyThroughCastleSky
//
//  Created by Caio Marques on 11/09/24.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    let enemies : [Enemy] = [
        Enemy(x: 600, y: 500, damage: 10, health: 100, spriteName: "enemy"),
        Enemy(x: 1000, y: 800, damage: 5, health: 1000, spriteName: "monster"),
    ]
    let itens : [Item] = [
        Item(
            name: "balloon",
            spriteName: "balloon",
            dialogs: [
                Dialogue(text: "Esse é um balão", person: "", velocity: 30),
                Dialogue(text: "Quando usado, ele é capaz de aumentar seu ataque", person: "", velocity: 30),
            ],
            effect: Effect(type: .DAMAGE, amount: 10),
            x: 200,
            y: 200),
        Item(
            name: "Cupcake",
            spriteName: "cupcake",
            dialogs: [
                Dialogue(text: "Esse é um cupcake", person: "", velocity: 30),
                Dialogue(text: "Quando usado, ele é capaz de aumentar sua vida", person: "", velocity: 30),
            ],
            effect: Effect(type: .CURE, amount: 15),
            x: 300,
            y: 300),
        
        Item(
            name: "Diamond Apple",
             spriteName: "diamondApple",
            dialogs: [
                Dialogue(text: "Essa é uma maçã de diamante", person: "", velocity: 10),
                Dialogue(text: "Ela é muito roubada, aumentando seu ataque em 30 pts", person: "", velocity: 30)
            ],
            effect: Effect(type: .DAMAGE, amount: 50),
            x: 500,
            y: 200)
    ]
    let frindlies : [Friendly] = [
        Friendly(spriteName: "papyrus", xPosition: 1000, yPosition: 500, dialogs: [
            Dialogue(text: "Olá, eu sou papyrus", person: "Papyrus", velocity: 20),
            Dialogue(text: "Eu sou seu amigo", person: "Papyrus", velocity: 20),
        ])
    ]
    
    var background : SKSpriteNode? = nil
    var dialogueBox : SKShapeNode? = nil
    var inventory : SKShapeNode?
    var buttonCatch : SKShapeNode? = nil
    
    internal var cameraNode : SKCameraNode!
    
    private let movementSystem = MovementSystem()
    private let itemSystem = ItemSystem()
    private let dialogSystem = DialogSystem()
    
    var dialogsToPass : [Dialogue] = []
    var gameState : GameState = .NORMAL

    override func didMove(to view: SKView) {
        config()
        setupNodes()
    }
    
    private func setupNodes () {
        setupCamera()
        setupBackground()
        setupSprite()
        setupEnemies()
        setupItems()
        setupButtonInventory()
        setupFriendlies()
    }
    
    private func config () {
        // permite receber input do teclado
        self.view?.window?.makeFirstResponder(self)
        dialogSystem.config(self)
        movementSystem.config(self)
        itemSystem.config(self)
        
        background = SKSpriteNode(imageNamed: "background")
        cameraNode = SKCameraNode()
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
        setupSpritePosition(User.singleton.spriteComponent, User.singleton.positionComponent, scale: 0.2)
    }
    
    private func setupEnemies () {
        enemies.forEach { enemy in
            setupSpritePosition(enemy.spriteComponent, enemy.positionComponent, scale: 0.2)
        }
    }
    
    private func setupFriendlies () {
        frindlies.forEach { friendly in
            setupSpritePosition(friendly.spriteComponent, friendly.positionComponent, scale: 0.1)
        }
    }
    
    private func setupItems () {
        itens.forEach { item in
            setupSpritePosition(item.spriteComponent, item.positionComponent, scale: 0.1)
        }
    }
    
    func setupSpritePosition (_ spriteComponent : SpriteComponent, _ positionComponent : PositionComponent, scale : CGFloat = 1) {
        let sprite = spriteComponent.sprite
        sprite.position.y = CGFloat(positionComponent.yPosition)
        sprite.position.x = CGFloat(positionComponent.xPosition)
        sprite.setScale(scale)
        addChild(sprite)
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
    
    func setupDialogBox () {
        dialogueBox = SKShapeNode(rect: CGRect(origin: .zero, size: CGSize(width: size.width / 1.2, height: 100)))
        
        guard let dialogueBox else {return}
        dialogueBox.position.y = -(size.height / 2.8)
        dialogueBox.position.x = -(size.width / 2.5)

        
        dialogueBox.fillColor = .gray.withAlphaComponent(0.9)
        dialogueBox.strokeColor = .white
        dialogueBox.zPosition = 3
        
        if dialogueBox.parent == nil {
            cameraNode.addChild(dialogueBox)
        }
    }
    
    func addDialogToDialogBox (_ dialog : Dialogue) {
        guard let dialogueBox else {return}
        
        gameState = .WAITING_DIALOG
        
        let author = SKLabelNode(text: dialog.person)
        author.position = CGPoint(x: 50, y: 75)
        author.horizontalAlignmentMode = .left
        
        let textLabel = SKLabelNode(text: "")
        textLabel.position = CGPoint(x: 50, y: author.position.y - 50)
        textLabel.fontSize = 12
        textLabel.horizontalAlignmentMode = .left
        dialogSystem.typeEffect(dialog, label: textLabel)

        dialogueBox.addChild(author)
        dialogueBox.addChild(textLabel)
    }
    
    // MARK: INTERAÇÕES COM TECLADO E MOUSE
    
    override func mouseDown(with event: NSEvent) {
        let location = event.location(in: self)
        let clickedNode = self.atPoint(location)
        
        
        if clickedNode.name == "buttonCatch"{
            itemSystem.catchItem()
            dialogSystem.nextDialogue()
        }
        
        
        if clickedNode.name == "buttonInventory" {
            self.itemSystem.inventoryButtonPressed()
        }
    }
    
    override func keyDown(with event: NSEvent) {
        if gameState == .NORMAL {
            movementSystem.keyDown(event)
        }
        
        if event.keyCode == 36 {
            if gameState == .NORMAL {
                frindlies.forEach { friendly in
                    if movementSystem.isOtherNearPlayer(friendly.positionComponent, range: 30) {
                        dialogsToPass.append(contentsOf: friendly.dialogueComponent.dialogs)
                        dialogSystem.nextDialogue()
                    }
                }
            } else {
                dialogSystem.nextDialogue()
            }
        }
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
}
