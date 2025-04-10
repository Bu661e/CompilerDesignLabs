package Lab2_CJ.lr0

import std.collections.ArrayList
import std.collections.HashMap
import Lab2_CJ.symbol.GrammarSymbol
import Lab2_CJ.symbol.NonTerminalSymbol
import Lab2_CJ.symbol.TerminalSymbol
import Lab2_CJ.type.SymbolType

class DFA {
    private var pStateTable: ArrayList<ItemSet> = ArrayList<ItemSet>()
    private var pActionTable: HashMap<String, ActionCell> = HashMap<String, ActionCell>()
    private var pGotoTable: HashMap<String, GotoCell> = HashMap<String, GotoCell>()

    public DFA() {}

    public func getpStateTable(): ArrayList<ItemSet> {
        return pStateTable
    }

    public func setpStateTable(pStateTable: ArrayList<ItemSet>): Unit {
        this.pStateTable = pStateTable
    }

    public func getpActionTable(): HashMap<String, ActionCell> {
        return pActionTable
    }

    public func setpActionTable(pActionTable: HashMap<String, ActionCell>): Unit {
        this.pActionTable = pActionTable
    }

    public func getpGotoTable(): HashMap<String, GotoCell> {
        return pGotoTable
    }

    public func setpGotoTable(pGotoTable: HashMap<String, GotoCell>): Unit {
        this.pGotoTable = pGotoTable
    }

    public func addState(state: ItemSet): Unit {
        pStateTable.add(state)
    }

    public func addAction(stateId: Int32, symbol: TerminalSymbol, action: ActionCell): Unit {
        let key = stateId.toString() + "," + symbol.getName()
        pActionTable.put(key, action)
    }

    public func addGoto(stateId: Int32, symbol: NonTerminalSymbol, gotoCell: GotoCell): Unit {
        let key = stateId.toString() + "," + symbol.getName()
        pGotoTable.put(key, gotoCell)
    }

    public func getAction(stateId: Int32, symbol: TerminalSymbol): ?ActionCell {
        let key = stateId.toString() + "," + symbol.getName()
        return pActionTable.get(key)
    }

    public func getGoto(stateId: Int32, symbol: NonTerminalSymbol): ?GotoCell {
        let key = stateId.toString() + "," + symbol.getName()
        return pGotoTable.get(key)
    }

    public func printActionTable(terminalSymbols: ArrayList<TerminalSymbol>): Unit {
        println("ACTION表：")
        print("\t")
        for (symbol in terminalSymbols) {
            print(symbol.getName() + "\t")
        }
        println()

        for (i in 0..pStateTable.size()) {
            print(i.toString() + "\t")
            for (symbol in terminalSymbols) {
                let action = getAction(i, symbol)
                if (action != null) {
                    print(action.getOrThrow().toString() + "\t")
                } else {
                    print("\t")
                }
            }
            println()
        }
    }

    public func printGotoTable(nonTerminalSymbols: ArrayList<NonTerminalSymbol>): Unit {
        println("GOTO表：")
        print("\t")
        for (symbol in nonTerminalSymbols) {
            print(symbol.getName() + "\t")
        }
        println()

        for (i in 0..pStateTable.size()) {
            print(i.toString() + "\t")
            for (symbol in nonTerminalSymbols) {
                let gotoCell = getGoto(i, symbol)
                if (gotoCell != null) {
                    print(gotoCell.getOrThrow().toString() + "\t")
                } else {
                    print("\t")
                }
            }
            println()
        }
    }
}