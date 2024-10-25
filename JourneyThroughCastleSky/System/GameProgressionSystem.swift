//
//  GameProgressionSystem.swift
//  JourneyThroughCastleSky
//
//  Created by Caio Marques on 24/10/24.
//

import Foundation


/*
A GameProgressionSystem é um fenômeno, porque ela serve para controlar em qual estágio do jogo o usuário está, os estágios são os seguintes:
 -> 0 - O usuário pode explorar a MainHallScene e conversar com o Weerdman
 Depois da conversa com o Weerdman ela aumenta de estágio.
 -> 1 - O usuário pode ir para a HallOfRelics, e se ele conversar com o Weerdman vai ser aquele mesmo diálogo da anterior,
 Quando o usuário entregar o cristal para o Weerdman, ele aumenta de estágio.
 -> 2 - O usuário pode ir para a Dungeon, ele não pode voltar para a HallOfRelics.
 Quando o usuário entregar o cristal para o Weerdman, ele aumenta de estágio.
 -> 3 - Acabou o jogo basicamente.
*/
class GameProgressionSystem {
    var estage : Int = 0
    static let singleton : GameProgressionSystem = GameProgressionSystem()
    
    func upStage () {
        
        print("Upou estágio")
        if estage < 3 {
            estage += 1
        } else {
            print("Não foi possível aumentar o estágio da GameProgressionSystem")
        }
    }
    
    func isMaxStage () -> Bool {
        return estage >= 3
    }
}
