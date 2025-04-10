package Lab2_CJ.generator

import std.collections.ArrayList
import std.collections.HashMap
import std.collections.HashSet
import Lab2_CJ.symbol.Cell
import Lab2_CJ.symbol.GrammarSymbol
import Lab2_CJ.symbol.NonTerminalSymbol
import Lab2_CJ.symbol.Production
import Lab2_CJ.symbol.TerminalSymbol
import Lab2_CJ.type.SymbolType

class GeneratorLL1 {
    static public func leftRecursion(nonTerminalSymbol: NonTerminalSymbol): NonTerminalSymbol {
        // 获取产生式左部的非终结符A
        let name = nonTerminalSymbol.getName()

        // 保存A=>Aα的链表，用于存储所有左递归的产生式（即产生式右部以该非终结符开头的产生式）
        let recursiveExpression = ArrayList<Production>()

        // 保存A=>β的链表，用于存储所有非左递归的产生式。
        let NonRecursiveExpression = ArrayList<Production>()

        // 遍历传入非终结符的所有产生式，根据产生式右部的第一个符号是否与该非终结符同名，将产生式分别添加到 left 或 constant 列表中。
        for (production in nonTerminalSymbol.getpProductionTable()) {
            // 产生式右部的头部文法符名字为A，则将其放入left;否则放入constant
            if (production.getpBodySymbolTable().get(0).getName() == name) {
                recursiveExpression.add(production)
            } else {
                NonRecursiveExpression.add(production)
            }
        }
        // left为空，说明不含有左递归
        if (recursiveExpression.isEmpty()) {
            println("left recursion not exists")
            return null
        }

        // 新建一个非终结符A'
        let S_dot = NonTerminalSymbol(nonTerminalSymbol.getName() + "'", SymbolType.NONTERMINAL)
        // 将A=>β变化为A=>βA'
        for (production in NonRecursiveExpression) {
            production.addSymbolAtLast(S_dot)
        }
        // 将A=>Aα变化为A'=>αA'
        for (production in recursiveExpression) {
            // 非终结符A移除产生式
            nonTerminalSymbol.removeProduction(production)
            // 产生式头部去除A
            production.removeFirstSymbol(nonTerminalSymbol)
            // 产生式尾部加上A'
            production.addSymbolAtLast(S_dot)
            // 添加到非终结符A'的产生式集合中
            S_dot.addProduction(production)
        }
        // 添加A'=>ε
        let production = Production()
        let epsilon = GrammarSymbol("ε", SymbolType.NULL)
        production.addSymbolAtLast(epsilon)
        // 加入非终结符A'的产生式集合中
        S_dot.addProduction(production)
        return S_dot
    }

    static public func leftCommonFactor(symbol: NonTerminalSymbol): ArrayList<NonTerminalSymbol> {
        let head = HashMap<GrammarSymbol, ArrayList<Production>>()
        var flag = false
        for (production in symbol.getpProductionTable()) {
            let s = production.getpBodySymbolTable().get(0)
            // 不存在该头部信息，则表示其第一次出现，加入map中
            if (head.get(s) == null) {
                let p = ArrayList<Production>()
                p.add(production)
                head.put(s, p)
            }
            // 说明已经出现过，此时存在左公因子
            else {
                head.get(s).getOrThrow().add(production)
                flag = true
            }
        }
        if (flag == false) {
            println("left common factor not exists")
            return null
        }

        let ans = ArrayList<NonTerminalSymbol>()
        // 遍历所有头部信息
        for (key in head.keySet()) {
            // 判断具有相同头部信息的个数
            if (head.get(key).getOrThrow().size() > 1) {
                // 新建一个非终结符A'
                let A_dot = NonTerminalSymbol(symbol.getName() + "'", SymbolType.NONTERMINAL)
                // 新建一个产生式A->key A'
                let p = Production()
                p.addSymbolAtLast(key)
                p.addSymbolAtLast(A_dot)
                symbol.addProduction(p)
                // 遍历左公因子
                for (production in head.get(key).getOrThrow()) {
                    // 删除A->key ……中的key
                    production.removeFirstSymbol(key)
                    // 删除A->……的产生式左部
                    symbol.removeProduction(production)
                    // 产生式左部为A'->……
                    A_dot.addProduction(production)
                }
                // 添加新的非终结符
                ans.add(A_dot)
            }
        }
        return ans
    }

    static public func firstOfProduction(production: Production): HashSet<TerminalSymbol> {
        // ε是否持续
        var nullStand = true
        var i = 0
        let pFirstSet = HashSet<TerminalSymbol>()
        let pBodySymbolTable = production.getpBodySymbolTable()
        // 新建一个ε文法符用于判断
        let epsilon = TerminalSymbol("ε", SymbolType.NULL)
        // 当前面文法符FIRST都包含ε时
        while (nullStand && i < production.getBodySize()) {
            // 获取当前文法符的FIRST
            let firstY = firstOfSymbol(pBodySymbolTable.get(i))
            // 判断当前文法符FIRST是否包含ε
            if (firstY.contains(epsilon)) {
                // 跳转到下一个文法符，去掉ε
                i++
                firstY.remove(epsilon)
            } else {
                // ε不再持续
                nullStand = false
            }
            // 把当前文法符的FIRST加入结果中
            pFirstSet.addAll(firstY)
        }
        // 如果最终能推导出ε，则FIRST集合中包含ε
        if (nullStand && i == production.getBodySize()) {
            pFirstSet.add(epsilon)
        }
        // 设置产生式的FIRST集合
        production.setpFirstSet(pFirstSet)
        return pFirstSet
    }

    static public func firstOfSymbol(symbol: GrammarSymbol): HashSet<TerminalSymbol> {
        // 如果是终结符，则FIRST集合就是其本身
        if (symbol.getType() == SymbolType.TERMINAL || symbol.getType() == SymbolType.NULL) {
            let firstSet = HashSet<TerminalSymbol>()
            firstSet.add(symbol as TerminalSymbol)
            return firstSet
        }
        // 如果是非终结符，则需要递归计算
        let nonTerminalSymbol = symbol as NonTerminalSymbol
        // 如果已经计算过，则直接返回
        if (!nonTerminalSymbol.getpFirstSet().isEmpty()) {
            return nonTerminalSymbol.getpFirstSet()
        }
        // 遍历该非终结符的每个产生式
        for (production in nonTerminalSymbol.getpProductionTable()) {
            // 获取产生式的FIRST集合
            let firstSet = firstOfProduction(production)
            // 将产生式的FIRST集合加入到非终结符的FIRST集合中
            nonTerminalSymbol.getpFirstSet().addAll(firstSet)
        }
        return nonTerminalSymbol.getpFirstSet()
    }

    static public func followOfSymbol(symbol: NonTerminalSymbol): HashSet<TerminalSymbol> {
        // 如果已经计算过，则直接返回
        if (!symbol.getpFollowSet().isEmpty()) {
            return symbol.getpFollowSet()
        }
        // 遍历所有非终结符
        for (production in symbol.getpProductionTable()) {
            // 遍历产生式右部的每个符号
            for (i in 0..production.getBodySize()) {
                // 如果是最后一个符号，则跳过
                if (i == production.getBodySize()) {
                    break
                }
                // 获取当前符号
                let currentSymbol = production.getpBodySymbolTable().get(i)
                // 如果当前符号是非终结符
                if (currentSymbol.getType() == SymbolType.NONTERMINAL) {
                    // 获取当前符号的FOLLOW集合
                    let currentNonTerminalSymbol = currentSymbol as NonTerminalSymbol
                    // 如果是最后一个符号，则将产生式左部的FOLLOW集合加入到当前符号的FOLLOW集合中
                    if (i == production.getBodySize() - 1) {
                        // 如果产生式左部和当前符号不同，则将产生式左部的FOLLOW集合加入到当前符号的FOLLOW集合中
                        if (production.getLeft().getName() != currentSymbol.getName()) {
                            currentNonTerminalSymbol.addDependentSetFollow(symbol)
                        }
                    } else {
                        // 获取下一个符号
                        let nextSymbol = production.getpBodySymbolTable().get(i + 1)
                        // 获取下一个符号的FIRST集合
                        let firstSet = firstOfSymbol(nextSymbol)
                        // 新建一个ε文法符用于判断
                        let epsilon = TerminalSymbol("ε", SymbolType.NULL)
                        // 如果下一个符号的FIRST集合包含ε
                        if (firstSet.contains(epsilon)) {
                            // 如果产生式左部和当前符号不同，则将产生式左部的FOLLOW集合加入到当前符号的FOLLOW集合中
                            if (production.getLeft().getName() != currentSymbol.getName()) {
                                currentNonTerminalSymbol.addDependentSetFollow(symbol)
                            }
                            // 将下一个符号的FIRST集合（去掉ε）加入到当前符号的FOLLOW集合中
                            firstSet.remove(epsilon)
                            currentNonTerminalSymbol.addFollowSet(firstSet)
                        } else {
                            // 将下一个符号的FIRST集合加入到当前符号的FOLLOW集合中
                            currentNonTerminalSymbol.addFollowSet(firstSet)
                        }
                    }
                }
            }
        }
        return symbol.getpFollowSet()
    }

    static public func isLL1(symbol: NonTerminalSymbol): Bool {
        // 遍历该非终结符的每个产生式
        for (i in 0..symbol.getpProductionTable().size()) {
            let production1 = symbol.getpProductionTable().get(i)
            // 获取产生式1的FIRST集合
            let firstSet1 = production1.getpFirstSet()
            // 新建一个ε文法符用于判断
            let epsilon = TerminalSymbol("ε", SymbolType.NULL)
            // 遍历该非终结符的每个产生式
            for (j in 0..symbol.getpProductionTable().size()) {
                // 如果是同一个产生式，则跳过
                if (i == j) {
                    continue
                }
                let production2 = symbol.getpProductionTable().get(j)
                // 获取产生式2的FIRST集合
                let firstSet2 = production2.getpFirstSet()
                // 判断两个产生式的FIRST集合是否有交集
                for (terminal1 in firstSet1) {
                    for (terminal2 in firstSet2) {
                        if (terminal1.getName() == terminal2.getName() && terminal1.getName() != "ε") {
                            return false
                        }
                    }
                }
                // 如果产生式1的FIRST集合包含ε，则判断产生式2的FIRST集合和产生式1的FOLLOW集合是否有交集
                if (firstSet1.contains(epsilon)) {
                    for (terminal1 in symbol.getpFollowSet()) {
                        for (terminal2 in firstSet2) {
                            if (terminal1.getName() == terminal2.getName()) {
                                return false
                            }
                        }
                    }
                }
                // 如果产生式2的FIRST集合包含ε，则判断产生式1的FIRST集合和产生式2的FOLLOW集合是否有交集
                if (firstSet2.contains(epsilon)) {
                    for (terminal1 in firstSet1) {
                        for (terminal2 in symbol.getpFollowSet()) {
                            if (terminal1.getName() == terminal2.getName()) {
                                return false
                            }
                        }
                    }
                }
            }
        }
        return true
    }

    static public func generateLL1Table(nonTerminalSymbols: ArrayList<NonTerminalSymbol>, terminalSymbols: ArrayList<TerminalSymbol>): ArrayList<Cell> {
        let LL1Table = ArrayList<Cell>()
        // 遍历所有非终结符
        for (nonTerminalSymbol in nonTerminalSymbols) {
            // 遍历该非终结符的每个产生式
            for (production in nonTerminalSymbol.getpProductionTable()) {
                // 获取产生式的FIRST集合
                let firstSet = production.getpFirstSet()
                // 新建一个ε文法符用于判断
                let epsilon = TerminalSymbol("ε", SymbolType.NULL)
                // 遍历产生式的FIRST集合
                for (terminalSymbol in firstSet) {
                    // 如果是ε，则跳过
                    if (terminalSymbol.getName() == "ε") {
                        continue
                    }
                    // 将产生式加入到LL1分析表中
                    LL1Table.add(Cell(nonTerminalSymbol, terminalSymbol, production))
                }
                // 如果产生式的FIRST集合包含ε，则将产生式加入到LL1分析表中
                if (firstSet.contains(epsilon)) {
                    // 遍历该非终结符的FOLLOW集合
                    for (terminalSymbol in nonTerminalSymbol.getpFollowSet()) {
                        // 将产生式加入到LL1分析表中
                        LL1Table.add(Cell(nonTerminalSymbol, terminalSymbol, production))
                    }
                }
            }
        }
        return LL1Table
    }
}