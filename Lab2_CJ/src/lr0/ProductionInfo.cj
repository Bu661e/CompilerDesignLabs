package Lab2_CJ.lr0

import Lab2_CJ.symbol.Production

class ProductionInfo {
    private var production: Production
    private var dotPosition: Int32

    public ProductionInfo(production: Production, dotPosition: Int32) {
        this.production = production
        this.dotPosition = dotPosition
    }

    public func getProduction(): Production {
        return production
    }

    public func setProduction(production: Production): Unit {
        this.production = production
    }

    public func getDotPosition(): Int32 {
        return dotPosition
    }

    public func setDotPosition(dotPosition: Int32): Unit {
        this.dotPosition = dotPosition
    }

    public func toString(): String {
        var ans = production.getLeft().getName() + " -> "
        let bodySymbolTable = production.getpBodySymbolTable()
        for (i in 0..bodySymbolTable.size()) {
            if (i == dotPosition) {
                ans += "· "
            }
            if (i < bodySymbolTable.size()) {
                ans += bodySymbolTable.get(i).getName() + " "
            }
        }
        if (dotPosition == bodySymbolTable.size()) {
            ans += "· "
        }
        return ans
    }
}