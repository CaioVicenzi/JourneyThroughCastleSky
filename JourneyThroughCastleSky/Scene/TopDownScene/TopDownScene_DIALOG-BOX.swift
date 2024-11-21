//
//  TopDownScene_DIALOG-BOX.swift
//  JourneyThroughCastleSky
//
//  Created by Caio Marques on 25/09/24.
//

import Foundation
import SpriteKit


/// Todas as funções relacionadas ao setup de elementos gráficos relacionados à caixa de diálogo
extension TopDownScene {
    /// Funçõa que cria a caixa de diálogo
    func setupDialogBox () {
        dialogueBox = SKShapeNode(rect: CGRect(origin: .zero, size: CGSize(width: size.width / 1.2, height: 100)))
        
        guard let dialogueBox else {return}
        dialogueBox.position.y = -(size.height / 2.8)
        dialogueBox.position.x = -(size.width / 2.5)

        
        dialogueBox.fillColor = .black
        dialogueBox.strokeColor = .white
        dialogueBox.zPosition = 10
        
        if dialogueBox.parent == nil {
            cameraNode.addChild(dialogueBox)
        }
    }
    
    /// Função que adiciona os textos do diálogo dentro da caixa de diálogo.
    func addDialogToDialogBox (_ dialog : Dialogue) {
        guard let dialogueBox else {return}
        
        // seta o estado do jogo para esperando o diálogo terminar.
        gameState = .WAITING_DIALOG
        
        // setup da label do autor do diálogo.
        let author = SKLabelNode(text: dialog.person)
        author.position = CGPoint(x: 25, y: 70)
        author.horizontalAlignmentMode = .left
        author.fontName = "Lora"
        author.fontSize = 10
        
        // setup da label do texto do diálogo.
        let textLabel = SKLabelNode(text: "")
        textLabel.position = CGPoint(x: 50, y: author.position.y - 50)
        textLabel.fontSize = 12
        textLabel.horizontalAlignmentMode = .left
        
        // adicionando os dois dentro da dialogueBox.
        dialogueBox.addChild(author)
        
        let multilineLabel = SKMultilineLabel(text: "", labelWidth: 700, pos: CGPoint(x: 25, y: 40))
        DialogSystem.typeEffect(dialog.text, velocity: dialog.velocity, label: multilineLabel) { [weak self] in
            self?.gameState = .DIALOG_FINISHED
        }
        
        
        dialogueBox.addChild(multilineLabel)
    }
}
