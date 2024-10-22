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
        excludeAll("friendlyGuy")
        
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
            self.setupSpritePosition(enemyCriado.spriteComponent, enemyCriado.positionComponent, scale: CGSize(width: 100, height: 200))
        }
        
        excludeAll(name)
    }
    
    /// Função que posiciona todos os amigáveis dentro da lista de friendlies dentro do mapa
    internal func setupFriendlies () {
        setupFriendly("friendlyGuy", spriteName: "weerdman")
    }
    
    private func setupFriendly(_ name: String, spriteName: String) {
        self.enumerateChildNodes(withName: name) { [self] node, _ in
            guard node is SKSpriteNode else {print("Erro na hora de inicializar o corpo físico dos elementos"); return}
            
            let weerdman = Friendly(
                spriteName: spriteName,
                xPosition: Int(465.311),
                yPosition: Int(-40.816),
                dialogs: [Dialogue(text: "Irmão!", person: "Weerdman", velocity: 50), Dialogue(text: "Eu não sou seu irmão.", person: "O Desconhecido", velocity: 50),Dialogue(text: "É o meu jeito de me expressar.", person: "Weerdman", velocity: 50),Dialogue(text: "Certo... Quem é você?", person: "O Desconhecido", velocity: 50),Dialogue(text: "Weerdman, à sua disposição. O que um soldado com uma bela e brilhante armadura está fazendo aqui nas ruínas esquecidas desse antigo mundo?", person: "Weerdman", velocity: 50),Dialogue(text: "Eu não sei.", person: "O Desconhecido", velocity: 50),Dialogue(text: "Você não sabe?", person: "Weerdman", velocity: 50),Dialogue(text: "Eu não me lembro… Eu não me lembro de nada…", person: "O Desconhecido", velocity: 50),Dialogue(text: "Interessante! Memorance, talvez… Sim, sim… Memorance! Posso ver os seus olhos brilharem com a corrupção blasfema de Leville. Ela te envolve como um véu invisível. Fascinante!", person: "Weerdman", velocity: 50),Dialogue(text: "O que é isso?.", person: "O Desconhecido", velocity: 50),Dialogue(text: "Ah… Memorance! Maldito feitiço! Apaga sua memória. É como o vento soprando grãos de areia. Faz com que seu cérebro se torne um quebra-cabeças a ser desvendado. Um sussurro etéreo distante nas profundezas do seu ser. Apenas eu posso desfazê-lo!", person: "Weerdman", velocity: 50), Dialogue(text: "Você?", person: "O Desconhecido", velocity: 50), Dialogue(text: "Sim! Quem mais? Mas… Preciso de um favor, ou melhor, favores em troca.", person: "Weerdman", velocity: 50), Dialogue(text: "E se eu não aceitar?", person: "O Desconhecido", velocity: 50), Dialogue(text: "Bom… então vague por essas terras sozinho. E procure por alguém gentil o suficiente para ajudá-lo. Não creio que encontrará, irmão. Tolo é aquele que tem uma joia rara nas mãos e sai para procurar pedras.", person: "Weerdman", velocity: 50),Dialogue(text: "Hum… e você acha que eu vou conseguir realizar esses favores para você?", person: "O Desconhecido", velocity: 50), Dialogue(text: "Olha para você! Quase um herói de armadura! Parece que veio diretamente de um conto de fadas.", person: "Weerdman", velocity: 50), Dialogue(text: "De que favores estamos falando?", person: "O Desconhecido", velocity: 50), Dialogue(text: "Preciso que recupere cristais. Pedras antigas de uma era distante!", person: "Weerdman", velocity: 50), Dialogue(text: "Entendo… Parece ser uma troca justa.", person: "O Desconhecido", velocity: 50), Dialogue(text: "Esse é o espírito! Ah, mas esteja avisado. Não sou nenhum tolo. Existem quatro cristais. A cada cristal que pegar, eu tiro um pouco da corrupção. No final, será novinho em folha! He he…", person: "Weerdman", velocity: 50), Dialogue(text: "Entendo. Por onde eu começo?", person: "O Desconhecido", velocity: 50), Dialogue(text: "O primeiro cristal está no calabouço. Mas tome cuidado… Mítico é o herói que busca o perigo sem se importar com sua reputação, armado apenas com bravura e caráter e a vontade de mudar o mundo. E no seu caso… uma espada!", person: "Weerdman", velocity: 50), Dialogue(text: "Certo?...", person: "O Desconhecido", velocity: 50), Dialogue(text: "Vá com cuidado, irmão! Mantenha seu corpo e mente afiados.", person: "Weerdman", velocity: 50), Dialogue(text: "Antes de ir, com o que esse cristal se parece?", person: "O Desconhecido", velocity: 50), Dialogue(text: "Você saberá quando vê-lo. Seu brilho pode ser visto pelos reinos como o Bombardeamento Celeste na era de Skyrise. Boa sorte!", person: "Weerdman", velocity: 50)]
            )
            
            let spriteFriendly = weerdman.spriteComponent.sprite
            let friendlyWidth = spriteFriendly.size.width
            let friendlyHeight = spriteFriendly.size.height
            
            spriteFriendly.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: friendlyWidth, height: friendlyHeight))
            spriteFriendly.physicsBody?.categoryBitMask = PhysicCategory.enemy
            spriteFriendly.physicsBody?.collisionBitMask = PhysicCategory.character
            spriteFriendly.physicsBody?.contactTestBitMask = PhysicCategory.character
            spriteFriendly.physicsBody?.affectedByGravity = false
            spriteFriendly.physicsBody?.isDynamic = false
            spriteFriendly.physicsBody?.allowsRotation = false
            
            friendlySystem.friendlies.append(weerdman)
            self.setupSpritePosition(weerdman.spriteComponent, weerdman.positionComponent, scale: CGSize(width: 100, height: 100))
        }
        
        excludeAll(name)
    }
    
    override func keyUp(with event: NSEvent) {
        movementSystem.keyUp(event)
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
    
    private func setupWalls () {
        enumerateChildNodes(withName: "wall") { node, _ in
            Wall.setupPhysicsBody(node as! SKSpriteNode)
        }
    }
    
    private func setupCheckpoint () {
        for child in children {
            if let childName = child.name {
                if childName.starts(with: "checkpoint") {
                    child.physicsBody = SKPhysicsBody(rectangleOf: child.frame.size)
                    child.physicsBody?.categoryBitMask = PhysicCategory.checkpoint
                    child.physicsBody?.collisionBitMask = PhysicCategory.character
                    child.physicsBody?.contactTestBitMask = PhysicCategory.character
                    child.physicsBody?.affectedByGravity = false
                    child.physicsBody?.isDynamic = false // não se move
                }
            }
            
        }
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
        
        // inicializando o cameraNode.
        cameraNode = childNode(withName: "cameraNode") as? SKCameraNode
        
        self.physicsWorld.gravity = .zero
        self.physicsWorld.contactDelegate = self
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
        
        let collidedWithEnemy = primeiroBody.categoryBitMask == PhysicCategory.character && segundoBody.categoryBitMask == PhysicCategory.enemy
        
        
        let collidedWithDoorNextScene = primeiroBody.categoryBitMask == PhysicCategory.character && segundoBody.categoryBitMask == PhysicCategory.checkpoint
        if collidedWithDoorNextScene {
            // se dependendo do nome do checkpoint, é possível redirecionar o usuário para a cena correta.
            if segundoBody.node?.name == "checkpoint_HallOfRelics" {
                goNextScene(.HALL_OF_RELICS)
            }
            if segundoBody.node?.name == "checkpoint_Dungeon" {
                goNextScene(.DUNGEON)
            }
            if segundoBody.node?.name == "checkpoint_MainHall" {
                goNextScene(.MAIN_HALL_SCENE)
            }
        }
        if collidedWithEnemy { collideWithEnemy(segundoBody) }
    }
     
    
    internal func goNextScene (_ scene : GamePhase) {
        let transition = SKTransition.fade(withDuration: 1.0)
        
        print(scene.rawValue)
        
        let sceneName = scene.rawValue + ".sks"
        
        // primeiramente a gente descobre em qual fase ele tá.
        let nextScene = SKScene(fileNamed: sceneName)
        User.singleton.currentPhase = scene
        
        
        nextScene?.scaleMode = .aspectFill
        //nextScene?.size = view!.frame.size

        // preparar user
        #warning("Isso aqui não é muito bom, a posição do usuário pode ser ajustada de outra forma.")
        User.singleton.positionComponent.xPosition = 10
        User.singleton.positionComponent.yPosition = 50
        User.singleton.spriteComponent.sprite.removeFromParent()
        self.removeAllParents(self)
        
        if let nextScene {
            self.view?.presentScene(nextScene, transition: transition)
        }
    }
    
    private func removeAllParents (_ scene : SKScene) {
        for child in scene.children {
            if let childName = child.name, childName.contains("Enemy") {
                child.removeFromParent()
            }
        }
    }
    
    private func populateGameSceneData () {
        GameSceneData.shared = GameSceneData(enemies: enemies, friendlies: friendlySystem.friendlies, items: itemSystem.items)
    }
    
    private func removeAllChilds () {
        for child in self.children {
            child.removeFromParent()
        }
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
    
    // TODO: Otimizar a quantidade de nodes com colisão
    private func setupTileColliders() {
        
        let nodes = children
        
        for case let node as SKTileMapNode in nodes {
            guard node.userData?.value(forKey: "hasCollision") as? Int == 1 else {
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
