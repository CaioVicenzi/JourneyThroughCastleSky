struct AttackResult {
    let enemyDodged: Bool
    var cancelled: Bool = false
}


class CombatSystem {
    var enemyDodge = false
    var enemy: Enemy!
 
    func start(enemy: Enemy) {
        self.enemy = enemy
    }
    
    @discardableResult
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
    
    func useSkill(skill: Skill) {
        User.singleton.skillComponent.skills.append(skill)
        skill.use(target: User.singleton)
        
        removeSkillFromInventory(skill)
    }
    
    private func removeSkillFromInventory(_ skill: Skill) {
        let index = User.singleton.inventoryComponent.skills.firstIndex(where: { _skill in
            type(of: skill) == type(of: _skill)
        })
        User.singleton.inventoryComponent.skills.remove(at: index!)
    }
    
    func enemyTurn() {
        User.singleton.skillComponent.skills.forEach { skill in
            skill.update()
            
            if (!skill.isActive) {
                skill.onExpire()
            }
        }
        
        User.singleton.skillComponent.skills.removeAll { skill in
            !skill.isActive
        }
    }
    
}

