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
    
    private func proccessExecutionTimeAttack(attack: Attack) {
        let executionTime = attack.executionTime.executionTime
        
        User.singleton.fighterComponent.actionInQueue = attack
    }
    
    @discardableResult
    func attack() -> AttackResult {
        
        var result = AttackResult(enemyDodged: enemyDodge)
        
        var attack = User.singleton.fighterComponent.attacks[0]
        
        if (
            attack.executionTime.executionTime > 0 && !User.singleton.fighterComponent
                .hasActionInQueue) {
            proccessExecutionTimeAttack(attack: attack)
            return result
        }
        
        if (User.singleton.fighterComponent.hasActionInQueue) {
            
            let action = User.singleton.fighterComponent.actionInQueue
            
            if (action?.executionTime.roundsRemaining != 0) {
                action?.executionTime.roundsRemaining -= 1
                
                return result
            } else {
                attack = User.singleton.fighterComponent.actionInQueue as! Attack
                User.singleton.fighterComponent.actionInQueue = nil
            }
            
        }
        
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
        print("Inimigo Jogou")
        
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

