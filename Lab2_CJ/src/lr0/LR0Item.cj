package Lab2_CJ.lr0

import Lab2_CJ.symbol.NonTerminalSymbol
import Lab2_CJ.symbol.Production
import Lab2_CJ.type.ItemCategoy

class LR0Item {
    private var nonTerminalSymbol: NonTerminalSymbol
    private var production: Production
    // 圆点的位置
    private var dotPosition: Int32
    // CORE(核心项）；NONCORE(非核心项）
    private var type: ItemCategoy

    public LR0Item(nonTerminalSymbol: NonTerminalSymbol, production: Production, dotPosition: Int32,
        type: ItemCategoy) {
        this.nonTerminalSymbol = nonTerminalSymbol
        this.production = production
        this.dotPosition = dotPosition
        this.type = type
    }

    public LR0Item(item: LR0Item) {
        this.nonTerminalSymbol = item.getNonTerminalSymbol()
        this.production = item.getProduction()
        this.dotPosition = item.getDotPosition() + 1
        this.type = ItemCategoy.CORE
    }

    public func getNonTerminalSymbol(): NonTerminalSymbol {
        return nonTerminalSymbol
    }

    public func setNonTerminalSymbol(nonTerminalSymbol: NonTerminalSymbol): Unit {
        this.nonTerminalSymbol = nonTerminalSymbol
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

    public func getType(): ItemCategoy {
        return type
    }

    public func setType(type: ItemCategoy): Unit {
        this.type = type
    }

    public func equals(obj: ?Object): Bool {
        if (obj == null) {
            return false
        }
        if (obj is LR0Item) {
            let other = obj as LR0Item
            return nonTerminalSymbol.getName() == other.getNonTerminalSymbol().getName() &&
                   production.getProductionId() == other.getProduction().getProductionId() &&
                   dotPosition == other.getDotPosition()
        }
        return false
    }

    public func toString(): String {
        var ans = nonTerminalSymbol.getName() + " -> "
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