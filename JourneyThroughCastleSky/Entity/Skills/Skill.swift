protocol Skill {
    var duration: Int { get set }
    var isActive: Bool { get }

    func use(target: Entity) -> Void
    func update() -> Void
    func onExpire() -> Void
}
