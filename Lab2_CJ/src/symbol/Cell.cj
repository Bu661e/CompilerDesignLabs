package Lab2_CJ.symbol

class Cell {
    private var nonTerminalSymbol: NonTerminalSymbol
    private var terminalSymbol: TerminalSymbol
    private var production: Production

    public Cell(nonTerminalSymbol: NonTerminalSymbol, terminalSymbol: TerminalSymbol, production: Production) {
        this.nonTerminalSymbol = nonTerminalSymbol
        this.terminalSymbol = terminalSymbol
        this.production = production
    }

    public func getNonTerminalSymbol(): NonTerminalSymbol {
        return nonTerminalSymbol
    }

    public func setNonTerminalSymbol(nonTerminalSymbol: NonTerminalSymbol): Unit {
        this.nonTerminalSymbol = nonTerminalSymbol
    }

    public func getTerminalSymbol(): TerminalSymbol {
        return terminalSymbol
    }

    public func setTerminalSymbol(terminalSymbol: TerminalSymbol): Unit {
        this.terminalSymbol = terminalSymbol
    }

    public func getProduction(): Production {
        return production
    }

    public func setProduction(production: Production): Unit {
        this.production = production
    }

    public func toString(): String {
        return "[" + nonTerminalSymbol.getName() + ", " + terminalSymbol.getName() + "] -> " + production.toString()
    }
}