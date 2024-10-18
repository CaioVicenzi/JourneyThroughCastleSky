protocol HasExecutionTime {
    var executionTime: ExecutionTimeComponent {get}
}

class Attack: Entity, HasExecutionTime, IsAction {
    var actionComponent: ActionComponent {
        return getComponent(
            ActionComponent.self
        ) as! ActionComponent
    }

    var executionTime: ExecutionTimeComponent {
        return getComponent(
            ExecutionTimeComponent.self
        ) as! ExecutionTimeComponent
    }
    
    var damageComponent: DamageComponent {
        return getComponent(
            DamageComponent.self
        ) as! DamageComponent
    }
    
    init(damage: Int, executionTime: Int = 0) {
        super.init()
        addComponent(DamageComponent(damage: damage))
        addComponent(ExecutionTimeComponent(executionTime: executionTime))
    }
}
