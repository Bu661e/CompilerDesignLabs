package Lab2_CJ.symbol

import std.collections.HashSet
import std.collections.ArrayList

class Production {
    private var productionId: Int32
    private var bodySize: Int32 = 0
    private var left: GrammarSymbol = GrammarSymbol("not set", null)
    private var pBodySymbolTable: ArrayList<GrammarSymbol> = ArrayList<GrammarSymbol>()
    private var pFirstSet: HashSet<TerminalSymbol> = HashSet<TerminalSymbol>()

    static var idNum: Int32 = 0

    public Production() {
        productionId = idNum++
    }

    public Production(gs: GrammarSymbol, al_gs: ArrayList<GrammarSymbol>) {
        productionId = idNum++
        left = gs
        pBodySymbolTable = al_gs
        bodySize = al_gs.size()
    }

    public func getProductionId(): Int32 {
        return productionId
    }

    public func setProductionId(productionId: Int32): Unit {
        this.productionId = productionId
    }

    public func getLeft(): GrammarSymbol {
        return left
    }

    public func setLeft(gs: GrammarSymbol): Unit {
        this.left = gs
    }

    public func getBodySize(): Int32 {
        return bodySize
    }

    public func setBodySize(bodySize: Int32): Unit {
        this.bodySize = bodySize
    }

    public func getpBodySymbolTable(): ArrayList<GrammarSymbol> {
        return pBodySymbolTable
    }

    public func setpBodySymbolTable(pBodySymbolTable: ArrayList<GrammarSymbol>): Unit {
        this.pBodySymbolTable = pBodySymbolTable
    }

    public func getpFirstSet(): HashSet<TerminalSymbol> {
        return pFirstSet
    }

    public func setpFirstSet(pFirstSet: HashSet<TerminalSymbol>): Unit {
        this.pFirstSet = pFirstSet
    }

    public func addSymbolAtLast(symbol: GrammarSymbol): Unit {
        pBodySymbolTable.add(symbol)
        bodySize++
    }

    public func removeFirstSymbol(symbol: GrammarSymbol): Unit {
        if (pBodySymbolTable.size() > 0 && pBodySymbolTable.get(0).getName() == symbol.getName()) {
            pBodySymbolTable.remove(0)
            bodySize--
        }
    }

    public func printInfo(): Unit {
        print(left.getName() + " -> ")
        for (symbol in pBodySymbolTable) {
            print(symbol.getName() + " ")
        }
        println()
    }

    public func toString(): String {
        var ans = left.getName() + " -> "
        for (symbol in pBodySymbolTable) {
            ans += symbol.getName() + " "
        }
        return ans
    }
}