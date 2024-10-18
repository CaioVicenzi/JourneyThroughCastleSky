

class CombatSystem {
    struct ActionResult {
        let enemyDodged: Bool
        
        var cancelled: Bool = false
    }

    var enemyDodge = false
    var enemy: Enemy!
    
    func start(enemy: Enemy) {
        self.enemy = enemy
    }
    
    private func proccessExecutionTimeAttack(attack: Attack) {
        User.singleton.fighterComponent.actionInQueue = attack
    }
    
    @discardableResult
    func attack() -> ActionResult {
        
        return runAction(
            fighter: User.singleton,
            action: User.singleton.fighterComponent
                .attacks[0])
    }
    
    func runAction(fighter: IsFighter, action: IsAction) -> ActionResult {
        
        
        var result = ActionResult(enemyDodged: enemyDodge)
        
        var attack = action as! Attack
        
        if (
            attack.executionTime.executionTime > 0 && !User.singleton.fighterComponent
                .hasActionInQueue) {
            proccessExecutionTimeAttack(attack: attack)
            return result
        }
        
        if (fighter.fighterComponent.hasActionInQueue) {
            
            let action = fighter.fighterComponent.actionInQueue
            
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
        
        if let fighter = fighter as? any HasStamina  {
            let currentStamina = fighter.staminaComponent.stamina
            let requiredStamina = 10
            
            if (currentStamina < requiredStamina) {
                result.cancelled = true
                return result
            }
            
            User.singleton.staminaComponent.stamina = max(
                0,
                currentStamina - requiredStamina
            )
        }
        
      
        
        enemy.healthComponent.health -= User.singleton.fighterComponent.damage
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

