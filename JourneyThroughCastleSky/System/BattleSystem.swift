struct AttackResult {
    let enemyDodged: Bool
    var cancelled: Bool = false
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
        
        var result = AttackResult(enemyDodged: enemyDodge)
        
        if (enemyDodge) {
            enemyDodge = false
            return result
        }
        
        
        let currentStamina = User.singleton.staminaComponent.stamina
        let requiredStamina = 10
        
        if (currentStamina < requiredStamina) {
            result.cancelled = true
            return result
        }
        
        enemy.healthComponent.health -= User.singleton.fighterComponent.damage
        User.singleton.staminaComponent.stamina = max(
            0,
            currentStamina - requiredStamina
        )
        
        return result
        
    }
    
}

