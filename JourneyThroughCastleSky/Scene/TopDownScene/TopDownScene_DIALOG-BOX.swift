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

        
        dialogueBox.fillColor = .gray.withAlphaComponent(0.9)
        dialogueBox.strokeColor = .white
        dialogueBox.zPosition = 3
        
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
        author.position = CGPoint(x: 50, y: 75)
        author.horizontalAlignmentMode = .left
        
        // setup da label do texto do diálogo.
        let textLabel = SKLabelNode(text: "")
        textLabel.position = CGPoint(x: 50, y: author.position.y - 50)
        textLabel.fontSize = 12
        textLabel.horizontalAlignmentMode = .left
        dialogSystem.typeEffect(dialog.text, velocity: dialog.velocity, label: textLabel) { [weak self] in
            self?.gameState = .DIALOG_FINISHED
        }

        // adicionando os dois dentro da dialogueBox.
        dialogueBox.addChild(author)
        dialogueBox.addChild(textLabel)
    }
}
