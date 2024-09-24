class BattleSystem {

 
    func useItem(_ item: Item) {
        if item.consumableComponent?.effect.type == .CURE {
            User.singleton.healthComponent.health += item.consumableComponent?.effect.amount ?? 0
        
        } else if item.consumableComponent?.effect.type == .DAMAGE {
            User.singleton.fighterComponent.damage += item.consumableComponent?.effect.amount ?? 0
        }
    }
    
}

