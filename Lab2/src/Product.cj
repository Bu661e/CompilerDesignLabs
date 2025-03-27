package Lab2

import std.collection.*


class Production {
    // 产生式序号，起标识作用
    var productionId: Int
    // 产生式体中包含的文法符个数
    var bodySize: Int
    // 产生式体中包含的文法符
    var pBodySymbolTable: ArrayList<GrammarSymbol> = ArrayList<GrammarSymbol>()
    // 产生式的 FIRST 函数值
    var pFirstSet: HashSet<TerminalSymbol> = HashSet<TerminalSymbol>()

    // 静态变量，用于生成唯一的产生式序号
    static var idNum: Int = 0

    init() {
        this.productionId = idNum++
        this.bodySize = 0
    }

    public func getProductionId(): Int {
        return this.productionId
    }

    public func setProductionId(productionId: Int) {
        this.productionId = productionId
    }

    public func getBodySize(): Int {
        return this.bodySize
    }

    public func setBodySize(bodySize: Int) {
        this.bodySize = bodySize
    }

    public func getpBodySymbolTable(): ArrayList<GrammarSymbol> {
        return this.pBodySymbolTable
    }

    public func setpBodySymbolTable(pBodySymbolTable: ArrayList<GrammarSymbol>) {
        this.pBodySymbolTable = pBodySymbolTable
    }

    public func getpFirstSet(): HashSet<TerminalSymbol> {
        return this.pFirstSet
    }

    public func setpFirstSet(pFirstSet: HashSet<TerminalSymbol>) {
        this.pFirstSet = pFirstSet
    }

    public func addSymbolAtLast(symbol: GrammarSymbol) {
        this.pBodySymbolTable.append(symbol)
        this.bodySize += 1
    }

    public func removeFirstSymbol(symbol: GrammarSymbol) {
        this.pBodySymbolTable.remove(symbol)
        this.bodySize -= 1
    }

    public func isEpsilon(): Bool {
        if (this.bodySize == 1 && this.pBodySymbolTable[0].getName() == "ε") {
            return true
        }
        return false
    }

    public func toString(): String {
        var s: String = ""
        for (symbol in this.pBodySymbolTable) {
            s += symbol.getName()
        }
        return "{\n" +
            "\tproductionId=" + this.productionId + ",\n" +
            "\tbodySize=" + this.bodySize + ",\n" +
            "\tpBodySymbolTable=" + s +
            "}"
    }
}