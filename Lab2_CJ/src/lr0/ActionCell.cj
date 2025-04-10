package Lab2_CJ.lr0

import Lab2_CJ.symbol.Production

class ActionCell {
    private var category: ActionCategory
    private var stateId: Int32
    private var production: ?Production = None

    public ActionCell(category: ActionCategory, stateId: Int32) {
        this.category = category
        this.stateId = stateId
    }

    public ActionCell(category: ActionCategory, stateId: Int32, production: Production) {
        this.category = category
        this.stateId = stateId
        this.production = Some(production)
    }

    public func getCategory(): ActionCategory {
        return category
    }

    public func setCategory(category: ActionCategory): Unit {
        this.category = category
    }

    public func getStateId(): Int32 {
        return stateId
    }

    public func setStateId(stateId: Int32): Unit {
        this.stateId = stateId
    }

    public func getProduction(): ?Production {
        return production
    }

    public func setProduction(production: Production): Unit {
        this.production = Some(production)
    }

    public func toString(): String {
        if (category == ActionCategory.SHIFT) {
            return "s" + stateId
        } else if (category == ActionCategory.REDUCE) {
            return "r" + production?.getProductionId()
        } else if (category == ActionCategory.ACCEPT) {
            return "acc"
        } else {
            return "error"
        }
    }
}