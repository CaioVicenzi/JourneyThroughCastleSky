struct AttackResult {
    let enemyDodged: Bool
}


class BattleSystem {
    var enemyDodge = false
    var enemy: Enemy!
 
    func useItem(_ item: Item) {
        if item.consumableComponent?.effect.type == .CURE {
            User.singleton.healthComponent.health += item.consumableComponent?.effect.amount ?? 0
        
        } else if item.consumableComponent?.effect.type == .DAMAGE {
            User.singleton.fighterComponent.damage += item.consumableComponent?.effect.amount ?? 0
        }
    }
    
    func attack() -> AttackResult {
        
        let result = AttackResult(enemyDodged: enemyDodge)
        
        
        if (enemyDodge) {
            enemyDodge = false
        } else {
            enemy.healthComponent.health -= User.singleton.fighterComponent.damage
        }
        
        
        return result
        
    }
    
}

