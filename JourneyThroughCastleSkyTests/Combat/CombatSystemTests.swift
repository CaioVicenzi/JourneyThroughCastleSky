//
//  CombatSyste,.swift
//  JourneyThroughCastleSky
//
//  Created by Victor Soares on 26/09/24.
//

import Testing

@Suite(.serialized)
class CombatSystemTests {

    var combatSystem: CombatSystem
    
    init() async throws {
        
        User.singleton.skillComponent.skills = [] 
        User.singleton.inventoryComponent.itens = []
        User.singleton.inventoryComponent.skills = []
        User.singleton.fighterComponent.damage = 5
        User.singleton.staminaComponent.stamina = 100
        
        combatSystem = CombatSystem()
        let enemy = Enemy(x: 0, y: 0, damage: 10, health: 100, spriteName: "")
        let skill = IncreaseStrengthSkill()
        User.singleton.inventoryComponent.skills.append(skill)
        combatSystem.enemy = enemy
        
        
    }

    
    @Test func testIfSkillIncreasesStrength() async throws {
        let originalDamage = User.singleton.fighterComponent
            .damage
        combatSystem.useSkill(skill: IncreaseStrengthSkill())
        
        let strength = User.singleton.fighterComponent.damage
        
        #expect(strength == originalDamage + 10)
    }
    
    @Test func testIfSkillIsRemovedFromPlayersInventory() async throws {
        
        
        #expect(User.singleton.inventoryComponent.skills.count == 1)
        let skill = User.singleton.inventoryComponent.skills[0]
        combatSystem.useSkill(skill: skill)
        
        
        #expect(User.singleton.inventoryComponent.skills.count == 0)
        
    }
    
    @Test func testIfSkillIsDeactivatedAfterDuration() async throws {
        #expect(User.singleton.inventoryComponent.skills.count == 1)
        let skill = User.singleton.inventoryComponent.skills[0]
        let initialDamage = User.singleton.fighterComponent.damage
        combatSystem.useSkill(skill: skill)
        #expect(User.singleton.skillComponent.skills.count == 1)
        let duration = skill.duration
        
        
        
        for _ in 0..<(duration) {

            
            combatSystem.enemyTurn()
        }
        
        
        #expect(User.singleton.fighterComponent.damage == initialDamage)
        #expect(User.singleton.skillComponent.skills.count == 0)
    
        
    }
    
    @Test func testIfStaminaDecreasesWhenPlayerAttacks() async throws {
        
        #expect(User.singleton.staminaComponent.stamina == 100)
        
        combatSystem.attack()
        
        #expect(User.singleton.staminaComponent.stamina == 90)
    }
    
    
    @Test func testIfAttackCancelsIfInsufficientStamina() async throws {
        User.singleton.staminaComponent.stamina = 0
        
        let result = combatSystem.attack()
        
        #expect(result.cancelled)
    }
    

}
