package Lab2_CJ.lr0

import Lab2_CJ.symbol.GrammarSymbol

class TransitionEdge {
    private var symbol: GrammarSymbol
    private var targetState: ItemSet

    public TransitionEdge(symbol: GrammarSymbol, targetState: ItemSet) {
        this.symbol = symbol
        this.targetState = targetState
    }

    public func getSymbol(): GrammarSymbol {
        return symbol
    }

    public func setSymbol(symbol: GrammarSymbol): Unit {
        this.symbol = symbol
    }

    public func getTargetState(): ItemSet {
        return targetState
    }

    public func setTargetState(targetState: ItemSet): Unit {
        this.targetState = targetState
    }

    public func toString(): String {
        return symbol.getName() + " -> I" + targetState.getStateId()
    }
}