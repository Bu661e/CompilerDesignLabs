package Lab2_CJ.symbol

import std.collections.ArrayList
import std.collections.HashSet
import Lab2_CJ.type.SymbolType

class NonTerminalSymbol <: GrammarSymbol {
    // 有关非终结符构成的产生式
    private var pProductionTable: ArrayList<Production> = ArrayList<Production>()
    private var numOfProduction: Int32 = 0
    private var pFirstSet: HashSet<TerminalSymbol> = HashSet<TerminalSymbol>()
    private var pFollowSet: HashSet<TerminalSymbol> = HashSet<TerminalSymbol>()
    // 求非终结符的 FOLLOW 函数值时，存放所依赖的非终结符
    private var pDependentSetInFollow: HashSet<NonTerminalSymbol> = HashSet<NonTerminalSymbol>()

    public NonTerminalSymbol(name: String, type: SymbolType) {
        super(name, type)
    }

    public func removeProduction(production: Production): Unit {
        pProductionTable.remove(production)
        numOfProduction--
    }

    public func addProduction(production: Production): Unit {
        pProductionTable.add(production)
        numOfProduction++
    }

    public func addDependentSetFollow(symbol: NonTerminalSymbol): Unit {
        if (symbol.getName() != getName()) {
            pDependentSetInFollow.add(symbol)
        }
    }

    public func addFollowSet(follow: HashSet<TerminalSymbol>): Unit {
        pFollowSet.addAll(follow)
    }

    public func addFollow(follow: TerminalSymbol): Unit {
        pFollowSet.add(follow)
    }

    public func removeEpsilon(): HashSet<TerminalSymbol> {
        let first = HashSet<TerminalSymbol>(pFirstSet)
        for (symbol in first) {
            if (symbol.getName() == "ε") {
                first.remove(symbol)
                break
            }
        }
        return first
    }

    public func containsEpsilon(): Bool {
        for (symbol in pFirstSet) {
            if (symbol.getName() == "ε") {
                return true
            }
        }
        return false
    }

    public func addFollowDependent(): Unit {
        for (symbol in pDependentSetInFollow) {
            addFollowSet(symbol.getpFollowSet())
        }
    }

    public func printInfo(): String {
        let ans = this.getName() + ":\n"
            + "\tProductions = " + pProductionTable
            + ", \n\tnumOfProductions = " + numOfProduction
            + ", \n\tFirstSet = " + this.pFirstSet
            + ", \n\tFollowSet = " + this.pFollowSet
            + ", \n\tDependentSetInFollow = " + this.pDependentSetInFollow
        println(ans)
        return ans
    }

    public func getpProductionTable(): ArrayList<Production> {
        return pProductionTable
    }

    public func setpProductionTable(pProductionTable: ArrayList<Production>): Unit {
        this.pProductionTable = pProductionTable
    }

    public func getNumOfProduction(): Int32 {
        return numOfProduction
    }

    public func setNumOfProduction(numOfProduction: Int32): Unit {
        this.numOfProduction = numOfProduction
    }

    public func getpFirstSet(): HashSet<TerminalSymbol> {
        return pFirstSet
    }

    public func setpFirstSet(pFirstSet: HashSet<TerminalSymbol>): Unit {
        this.pFirstSet = pFirstSet
    }

    public func getpFollowSet(): HashSet<TerminalSymbol> {
        return pFollowSet
    }

    public func setpFollowSet(pFollowSet: HashSet<TerminalSymbol>): Unit {
        this.pFollowSet = pFollowSet
    }

    public func getpDependentSetInFollow(): HashSet<NonTerminalSymbol> {
        return pDependentSetInFollow
    }

    public func setpDependentSetInFollow(pDependentSetInFollow: HashSet<NonTerminalSymbol>): Unit {
        this.pDependentSetInFollow = pDependentSetInFollow
    }
}