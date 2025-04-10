package Lab2_CJ.lr0

import std.collections.ArrayList
import std.collections.HashSet
import Lab2_CJ.symbol.GrammarSymbol

class ItemSet {
    private var stateId: Int32
    private var pItemTable: ArrayList<LR0Item> = ArrayList<LR0Item>()
    private var pCoreItemTable: ArrayList<LR0Item> = ArrayList<LR0Item>()
    private var pTransitionTable: ArrayList<TransitionEdge> = ArrayList<TransitionEdge>()

    public ItemSet(stateId: Int32) {
        this.stateId = stateId
    }

    public func getStateId(): Int32 {
        return stateId
    }

    public func setStateId(stateId: Int32): Unit {
        this.stateId = stateId
    }

    public func getpItemTable(): ArrayList<LR0Item> {
        return pItemTable
    }

    public func setpItemTable(pItemTable: ArrayList<LR0Item>): Unit {
        this.pItemTable = pItemTable
    }

    public func getpCoreItemTable(): ArrayList<LR0Item> {
        return pCoreItemTable
    }

    public func setpCoreItemTable(pCoreItemTable: ArrayList<LR0Item>): Unit {
        this.pCoreItemTable = pCoreItemTable
    }

    public func getpTransitionTable(): ArrayList<TransitionEdge> {
        return pTransitionTable
    }

    public func setpTransitionTable(pTransitionTable: ArrayList<TransitionEdge>): Unit {
        this.pTransitionTable = pTransitionTable
    }

    public func addItem(item: LR0Item): Unit {
        pItemTable.add(item)
    }

    public func addCoreItem(item: LR0Item): Unit {
        pCoreItemTable.add(item)
    }

    public func addTransition(edge: TransitionEdge): Unit {
        pTransitionTable.add(edge)
    }

    public func equals(obj: ?Object): Bool {
        if (obj == null) {
            return false
        }
        if (obj is ItemSet) {
            let other = obj as ItemSet
            if (pCoreItemTable.size() != other.getpCoreItemTable().size()) {
                return false
            }
            for (item in pCoreItemTable) {
                var found = false
                for (otherItem in other.getpCoreItemTable()) {
                    if (item.equals(otherItem)) {
                        found = true
                        break
                    }
                }
                if (!found) {
                    return false
                }
            }
            return true
        }
        return false
    }

    public func toString(): String {
        var ans = "I" + stateId + ":\n"
        for (item in pItemTable) {
            ans += "\t" + item.toString() + "\n"
        }
        return ans
    }

    public func getNextSymbols(): HashSet<GrammarSymbol> {
        let symbols = HashSet<GrammarSymbol>()
        for (item in pItemTable) {
            let dotPosition = item.getDotPosition()
            let production = item.getProduction()
            if (dotPosition < production.getBodySize()) {
                symbols.add(production.getpBodySymbolTable().get(dotPosition))
            }
        }
        return symbols
    }
}