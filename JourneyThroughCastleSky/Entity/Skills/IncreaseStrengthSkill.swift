class IncreaseStrengthSkill: Skill {
    
    var target: Entity!
    var duration: Int = 2 {
        didSet {
            if (duration <= 0) {
                isActive = false
            }
        }
    }
    var isActive: Bool = true
    
    func use(target: Entity) {
        self.target = target
        let fighterComponent = target.getComponent(
            FighterComponent.self
        ) as? FighterComponent
        
        if let fighterComponent = fighterComponent {
            fighterComponent.damage += 10
        }
    }
    
    func update() {
        duration -= 1
    }
    
    func onExpire() {
        let fighterComponent = target.getComponent(
            FighterComponent.self
        ) as? FighterComponent
        
        
        if let fighterComponent = fighterComponent {
            fighterComponent.damage -= 10
        }
    }
    
    
    
    
}
