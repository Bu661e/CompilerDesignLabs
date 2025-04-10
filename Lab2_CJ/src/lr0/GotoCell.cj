package Lab2_CJ.lr0

class GotoCell {
    private var stateId: Int32

    public GotoCell(stateId: Int32) {
        this.stateId = stateId
    }

    public func getStateId(): Int32 {
        return stateId
    }

    public func setStateId(stateId: Int32): Unit {
        this.stateId = stateId
    }

    public func toString(): String {
        return stateId.toString()
    }
}