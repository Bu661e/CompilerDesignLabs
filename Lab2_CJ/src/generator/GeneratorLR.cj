package Lab2_CJ.generator

import std.collections.ArrayList
import std.collections.ArrayDeque
import std.collections.HashMap
import std.collections.HashSet
import std.collections.Stack
import std.collections.Vector
import std.collections.Set
import std.collections.Map
import std.collections.Deque
import Lab2_CJ.lr0.ActionCategory
import Lab2_CJ.lr0.ActionCell
import Lab2_CJ.lr0.DFA
import Lab2_CJ.lr0.GotoCell
import Lab2_CJ.lr0.ItemSet
import Lab2_CJ.lr0.LR0Item
import Lab2_CJ.lr0.ProductionInfo
import Lab2_CJ.lr0.TransitionEdge
import Lab2_CJ.symbol.GrammarSymbol
import Lab2_CJ.symbol.NonTerminalSymbol
import Lab2_CJ.symbol.Production
import Lab2_CJ.symbol.TerminalSymbol
import Lab2_CJ.type.ItemCategoy
import Lab2_CJ.type.SymbolType

class GeneratorLR {
    // LR语法分析表的ACTION部分
    static private let pActionCellTable = ArrayList<ActionCell>()
    // LR语法分析表的GOTO部分
    static private let pGotoCellTable = ArrayList<GotoCell>()

    static private let allItemSet = ArrayList<ItemSet>()

    static private let newItemSet = ArrayList<ItemSet>()

    static public func getClosure(itemSet: ItemSet): Unit {
        // 栈：用于保存未求其后续文法符的项目
        let item = Stack<LR0Item>()
        // 将所有核心项推入栈中
        for (lr in itemSet.getpItemTable()) {
            item.push(lr)
        }
        while (!item.isEmpty()) {
            let lr = item.pop()
            let pos = lr.getDotPosition()
            // pos在产生式最后面，说明为规约项目
            if (pos == lr.getProduction().getBodySize()) {
                continue
            }
            else {
                // 找到后续文法符
                let symbol = lr.getProduction().getpBodySymbolTable().get(pos)
                // 该文法符为非终结符，说明为待约项目
                if (symbol.getType() == SymbolType.NONTERMINAL) {
                    // 遍历该非终结符的每个产生式
                    for (production in (symbol as NonTerminalSymbol).getpProductionTable()) {
                        if (!itemSet.containItem(production, 0)) {
                            // 新建一个非核心项，原点位置为0
                            let newItem = LR0Item(symbol as NonTerminalSymbol, production, 0, ItemCategoy.NONCORE)
                            // 添加进闭包
                            itemSet.addItem(newItem)
                            // 推入栈中
                            item.push(newItem)
                        }
                    }
                }
            }
        }
    }

    static public func addItemSet(set: ItemSet): Unit {
        allItemSet.add(set)
    }

    static public func getAllItemSet(): ArrayList<ItemSet> {
        return allItemSet
    }
 
    // 删除这些重复定义的成员变量，因为在文件开头已经定义过了
    // static private let pActionCellTable = ArrayList<ActionCell>()
    // static private let pGotoCellTable = ArrayList<GotoCell>()
    // static private let allItemSet = ArrayList<ItemSet>()
    // static private let newItemSet = ArrayList<ItemSet>()

    static public func exhaustTransition(itemSet: ItemSet): ArrayList<TransitionEdge> {
        // 保存新创建的变迁边
        let edges = ArrayList<TransitionEdge>()
        let map = HashMap<GrammarSymbol, Vector<LR0Item>>()
        // 穷举所有驱动符，并将其保存在map中
        for (item in itemSet.getpItemTable()) {
            let pos = item.getDotPosition()
            // 当前项目为规约项目
            if (pos == item.getProduction().getBodySize()) {
                continue
            }
            // 获得后续文法符
            let symbol = item.getProduction().getpBodySymbolTable().get(pos)
            // 该文法符未出现，则新创建一个vector对象
            if (map.get(symbol) == null) {
                let v = Vector<LR0Item>()
                v.add(item)
                map.put(symbol, v)
            }
            // 之前出现过，则在后面添加item
            else {
                map.get(symbol).add(item)
            }
        }
        // 遍历所有驱动符
        for (symbol in map.keySet()) {
            // 下一项集的建立,id为-1（防止重复导致的状态序号不连续）
            let toSet = ItemSet(-1)
            for (item in map.get(symbol)) {
                // 新建一个核心项，其type为CORE，pos加一
                let lr = LR0Item(item)
                toSet.addItem(lr)
            }
            // 求该项集的闭包
            getClosure(toSet)
            // 判断下一项集是否为新项集
            let isExist = false
            for (set in allItemSet) {
                if (toSet.isSame(set)) {
                    isExist = true
                    toSet = set
                    break
                }
            }
            // 该项集为新项集
            if (!isExist) {
                // 设置该项集为新的项集id，保证连续
                toSet.setStateId()
                allItemSet.add(toSet)
                newItemSet.add(toSet)
            }
            // 创建一条变迁边
            let edge = TransitionEdge(symbol, itemSet, toSet)
            edges.add(edge)
        }
        return edges
    }

    static public func getDFA(start: ItemSet): DFA {
        // 新建一个DFA
        let dfa = DFA(start)
        // 保存未穷举状态的项集
        let queue = ArrayDeque<ItemSet>()
        queue.push(start)
        while (!queue.isEmpty()) {
            let current = queue.pop()
            // 对当前项集进行穷举，得到变迁边
            let edges = exhaustTransition(current)
            queue.addAll(newItemSet)
            newItemSet.clear()
            // 添加所有变迁表到dfa中
            dfa.addEdges(edges)
        }
        return dfa
    }

    static public func isSLR1(): Boolean {
        // 遍历每个项集
        for (set in allItemSet) {
            // 设置规约项目和移入终结符集合
            let reduce = ArrayList<LR0Item>()
            let shift = ArrayList<TerminalSymbol>()
            // 遍历项集里面的每个项目
            for (item in set.getpItemTable()) {
                let production = item.getProduction()
                let pos = item.getDotPosition()
                // 该项目为规约项目，添加该项目到规约项目集合
                if (pos == production.getBodySize()) {
                    reduce.add(item)
                }
                // 该项目为移入项目，添加终结符到移入终结符集合
                else if (production.getpBodySymbolTable().get(pos).getType() == SymbolType.TERMINAL) {
                    shift.add(production.getpBodySymbolTable().get(pos) as TerminalSymbol)
                }
            }
            // 判断规约-移入冲突
            if (shift.size() > 0 && reduce.size() > 0) {
                // 遍历每个规约项目
                for (item in reduce) {
                    // 求其产生式左部的非终结符的FOLLOW集合
                    let follow = item.getNonTerminalSymbol().getpFollowSet()
                    // FOLLOW集合不能与移入终结符集合相交，否则不为SLR(1)文法
                    for (symbol in follow) {
                        if (shift.contains(symbol)) {
                            return false
                        }
                    }
                }
            }
            // 判断规约-规约冲突
            if (reduce.size() > 1) {
                let followReduce = HashSet<TerminalSymbol>()
                for (item in reduce) {
                    // 求其产生式左部的非终结符的FOLLOW集合
                    let follow = item.getNonTerminalSymbol().getpFollowSet()
                    for (symbol in follow) {
                        // 若该FOLLOW集合中的元素在其他规约项目的FOLLOW集中出现过，则存在规约-规约冲突
                        if (followReduce.contains(symbol)) {
                            return false
                        }
                        // 若未出现，则加入
                        else {
                            followReduce.add(symbol)
                        }
                    }
                }
            }
        }
        return true
    }

    static public func getpActionCellTable(): ArrayList<ActionCell> {
        return pActionCellTable
    }

    static public func getpGotoCellTable(): ArrayList<GotoCell> {
        return pGotoCellTable
    }

    static public func getCell(dfa: DFA): Unit {
        // 遍历所有状态集合
        for (set in allItemSet) {
            // 遍历每个项集下的所有项目
            for (item in set.getpItemTable()) {
                let production = item.getProduction()
                // 原点所处位置
                let pos = item.getDotPosition()
                // 该项目为规约项目，找到FOLLOW集合填r
                if (pos == production.getBodySize()) {
                    // 其中该项目为接受项目，在"#"上填a
                    if (item.getProduction().getProductionId() == 0) {
                        // 创建对应ACTION
                        let cell = ActionCell(set.getStateId(), "#", ActionCategory.a, 0)
                        pActionCellTable.add(cell)
                    }
                    // 求其产生式左部的非终结符的FOLLOW集合
                    let follow = item.getNonTerminalSymbol().getpFollowSet()
                    // 遍历FOLLOW集合中的每个终结符
                    for (symbol in follow) {
                        // 创建对应ACTION
                        let cell = ActionCell(set.getStateId(), symbol.getName(), ActionCategory.r, item.getProduction().getProductionId())
                        pActionCellTable.add(cell)
                    }
                    continue
                }
                // 原点后的文法符
                let symbol = production.getpBodySymbolTable().get(pos)
                // 找到该文法符驱动的下一状态
                let nextSet = dfa.findNextSet(set, symbol)
                // 该项目为移入项目，找到终结符填s
                if (symbol.getType() == SymbolType.TERMINAL) {
                    // 创建对应ACTION
                    let cell = ActionCell(set.getStateId(), symbol.getName(), ActionCategory.s, nextSet.getStateId())
                    pActionCellTable.add(cell)
                }
                // 该项目为待约项目，找到非终结符在GOTO填状态序号
                else {
                    // 创建对应GOTO
                    let cell = GotoCell(set.getStateId(), symbol.getName(), nextSet.getStateId())
                    pGotoCellTable.add(cell)
                }
            }
        }
    }

    static public func createInfo(symbol: NonTerminalSymbol): ArrayList<ProductionInfo> {
        let productionInfoTable = ArrayList<ProductionInfo>()
        for (production in symbol.getpProductionTable()) {
            let info = ProductionInfo(symbol.getName(), production.getBodySize())
            productionInfoTable.add(info)
        }
        return productionInfoTable
    }
}