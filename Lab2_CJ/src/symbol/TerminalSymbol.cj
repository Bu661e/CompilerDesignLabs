package Lab2_CJ.symbol

import Lab2_CJ.type.LexemeCategory
import Lab2_CJ.type.SymbolType

class TerminalSymbol <: GrammarSymbol {
    private var category: ?LexemeCategory = None

    public TerminalSymbol(name: String, type: SymbolType) {
        super(name, type)
    }

    public func printInfo(): String {
        let ans = this.getName() + "{"
            + "\ntype=" + getType()
            + ", \ncategory=" + category
            + "}"
        println(ans)
        return ans
    }

    public func getCategory(): ?LexemeCategory {
        return category
    }

    public func setCategory(category: LexemeCategory): Unit {
        this.category = Some(category)
    }
}