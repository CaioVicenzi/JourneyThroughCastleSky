//
//  GameSceneData.swift
//  JourneyThroughCastleSky
//
//  Created by Caio Marques on 10/10/24.
//

import Foundation

extension TopDownScene {
    /// Vai ser uma classe para conter todos os dados que serão recuperados da
    class GameSceneData {
        static var shared : GameSceneData?
        
        var enemies : [Enemy]
        var friendlies : [Friendly]
        var items : [Item]
        
        init(enemies: [Enemy], friendlies: [Friendly], items: [Item]) {
            self.enemies = enemies
            self.friendlies = friendlies
            self.items = items
        }
    }
}
