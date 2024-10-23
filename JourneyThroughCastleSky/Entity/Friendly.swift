//
//  Friendly.swift
//  JourneyThroughCastleSky
//
//  Created by Caio Marques on 20/09/24.
//

import Foundation

/// Amigáveis são uma entidade de personagens especiais que o usuário pode diálogar com eles, mas eles não podem combater com o usuário nem se mover (se houver alguma alteração futura que pode fazer o amigável se locomover, aqui deverá ser feito essa alteração.
/// - parameters
///   - spriteComponent: os amigáveis terão um sprite associado a eles para serem adicionados em uma cena.
///   - positionComponent: os amigáveis terão um posicionamento dentro do mapa.
///   - dialogueComponent: contém os diálogos que serão acionados caso o usuário interaja com o amigável.
class Friendly{
    let spriteComponent : SpriteComponent
    let positionComponent : PositionComponent
    let dialogueComponent : DialogueComponent
    let dialogueComponentTwo : DialogueComponent
    let dialogueComponentThree : DialogueComponent
    
    init(spriteName: String, xPosition: Int, yPosition : Int, dialogs : [Dialogue], dialogsTwo : [Dialogue], dialogsThree : [Dialogue]) {
        self.spriteComponent = SpriteComponent(spriteName)
        self.dialogueComponent = DialogueComponent(dialogs: dialogs)
        self.dialogueComponentTwo = DialogueComponent(dialogs: dialogsTwo)
        self.dialogueComponentThree = DialogueComponent(dialogs: dialogsThree)
        self.positionComponent = PositionComponent(xPosition: xPosition, yPosition: yPosition)
    }
}
