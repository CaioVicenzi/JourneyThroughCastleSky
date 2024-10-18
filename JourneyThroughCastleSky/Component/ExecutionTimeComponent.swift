class ExecutionTimeComponent: Component {
    var executionTime: Int
    var roundsRemaining: Int
    
    init(executionTime: Int) {
        self.executionTime = executionTime
        self.roundsRemaining = executionTime
    }
}
