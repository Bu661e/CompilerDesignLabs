package Lab2_CJ.symbol

import Lab2_CJ.type.SymbolType

class GrammarSymbol {
    private var name: String
    private var type: SymbolType

    public GrammarSymbol(name: String, type: SymbolType) {
        this.name = name
        this.type = type
    }

    public func getName(): String {
        return name
    }

    public func setName(name: String): Unit {
        this.name = name
    }

    public func getType(): SymbolType {
        return type
    }

    public func setType(type: SymbolType): Unit {
        this.type = type
    }

    public func toString(): String {
        return this.getName()
    }
}