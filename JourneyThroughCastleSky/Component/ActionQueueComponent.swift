class ActionQueueComponent: Component {
    
    var hasAction: Bool {
        return action != nil
    }
    
    var action: HasExecutionTime?
    
}
