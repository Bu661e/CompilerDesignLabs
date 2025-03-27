package Lab2
import std.collection.*


public enum SymbolType <: ToString {
    // 终结符
    TERMINAL |
    // 非终结符
    NONTERMINAL |
    // 空
    NULL

    public func toString() {
        match (this) {
            case TERMINAL => "TERMINAL"
            case NONTERMINAL => "NONTERMINAL"
            case NULL => "NULL"
        }
    }
}

public enum LexemeCategory <: ToString {
    // 空字符
    EMPTY |
    // 整数常量
    INTEGER_CONST |
    // 实数常量
    FLOAT_CONST |
    // 科学计数法常量
    SCIENTIFIC_CONST |
    // 数值运算词
    NUMERIC_OPERATOR |
    // 注释
    NOTE |
    // 字符串常量
    STRING_CONST |
    // 空格常量
    SPACE_CONST |
    // 比较运算词
    COMPARE_CONST |
    // 变量词
    ID |
    // 逻辑运算词
    LOGIC_OPERATOR |
    // 关键字
    KEYWORD

    public func toString() {
        match (this) {
            case EMPTY => "EMPTY"
            case INTEGER_CONST => "INTEGER_CONST"
            case FLOAT_CONST => "FLOAT_CONST"
            case SCIENTIFIC_CONST => "SCIENTIFIC_CONST"
            case NUMERIC_OPERATOR => "NUMERIC_OPERATOR"
            case NOTE => "NOTE"
            case STRING_CONST => "STRING_CONST"
            case SPACE_CONST => "SPACE_CONST"
            case COMPARE_CONST => "COMPARE_CONST"
            case ID => "ID"
            case LOGIC_OPERATOR => "LOGIC_OPERATOR"
            case KEYWORD => "KEYWORD"
        }
    }
}

class GrammarSymbol {
    // 名字
    var name: String = ""
    // 文法符的类别
    var symbolType: SymbolType

    init(name: String, st: SymbolType) {
        this.name = name
        this.symbolType = st
    }

    public func getName(): String {
        return this.name
    }

    public func setName(name: String) {
        this.name = name
    }

    public func getType(): SymbolType {
        return symbolType
    }

    public func setType(st: SymbolType) {
        this.symbolType = st
    }

    public func toString(): String {
        return "GrammarSymbol{name='" + name + "', type=" + symbolType.toString() + "}"
    }
}


class TerminalSymbol <: ToString & Hashable & Equatable<TerminalSymbol> {

    // 名字
    var name: String = ""
    // 文法符的类别
    var symbolType: SymbolType
    // 终结符的类别
    var category: LexemeCategory

    init(name: String, st: SymbolType) {
        this.name = name
        this.symbolType = st
        this.category = LexemeCategory.EMPTY  // 默认值，假设 LexemeCategory 有一个 EMPTY 枚举值
    }

    public func getCategory(): LexemeCategory {
        return this.category
    }

    public func setCategory(category: LexemeCategory) {
        this.category = category
    }
    public func getName(): String {
        return this.name
    }

    public func setName(name: String) {
        this.name = name
    }

    public func getType(): SymbolType {
        return symbolType
    }

    public func setType(st: SymbolType) {
        this.symbolType = st
    }

    public func toString(): String {
        return "${this.getName()}"
    }
    
    // 下面实现 Hashable 和 Equatable 接口，以便 Rotation 作为 HashMap 的 Key
    public func hashCode(): Int64 {
        this.toString().hashCode()
    }

    public operator func ==(that: TerminalSymbol): Bool {
        this.toString() == that.toString()
    }

    public operator func !=(that: TerminalSymbol): Bool {
        this.toString() != that.toString()
    }

}



class NonTerminalSymbol <: ToString & Hashable & Equatable<NonTerminalSymbol>{
    // 名字
    var name: String = ""
    // 文法符的类别
    var symbolType: SymbolType
    // 有关非终结符构成的产生式
    var pProductionTable: ArrayList<Production> = ArrayList<Production>()
    // 产生式的个数
    var numOfProduction: Int = 0
    
    // 非终结符的 FIRST 函数值
    var pFirstSet: HashSet<TerminalSymbol> = HashSet<TerminalSymbol>()
    // 非终结符的 FOLLOW 函数值
    var pFollowSet: HashSet<TerminalSymbol> = HashSet<TerminalSymbol>()
    // 求非终结符的 FOLLOW 函数值时，存放所依赖的非终结符。
    var pDependentSetInFollow: HashSet<NonTerminalSymbol> = HashSet<NonTerminalSymbol>()

    init(name: String, st: SymbolType) {
        this.name = name
        this.symbolType = st
    }

    public func getpProductionTable(): ArrayList<Production> {
        return this.pProductionTable
    }

    public func setpProductionTable(pProductionTable: ArrayList<Production>) {
        this.pProductionTable = pProductionTable
    }

    public func getNumOfProduction(): Int {
        return this.numOfProduction
    }

    public func setNumOfProduction(numOfProduction: Int) {
        this.numOfProduction = numOfProduction
    }

    public func getpFirstSet(): HashSet<TerminalSymbol> {
        return this.pFirstSet
    }

    public func setpFirstSet(pFirstSet: HashSet<TerminalSymbol>) {
        this.pFirstSet = pFirstSet
    }

    public func getpFollowSet(): HashSet<TerminalSymbol> {
        return this.pFollowSet
    }

    public func setpFollowSet(pFollowSet: HashSet<TerminalSymbol>) {
        this.pFollowSet = pFollowSet
    }

    public func getpDependentSetInFollow(): HashSet<NonTerminalSymbol> {
        return this.pDependentSetInFollow
    }

    public func setpDependentSetInFollow(pDependentSetInFollow: HashSet<NonTerminalSymbol>) {
        this.pDependentSetInFollow = pDependentSetInFollow
    }

    public func getName(): String {
        return this.name
    }

    public func removeProduction(production: Production) {
        this.pProductionTable.remove(production)
        this.numOfProduction -= 1
    }

    public func addProduction(production: Production) {
        this.pProductionTable.append(production)
        this.numOfProduction += 1
    }

    public func addDependentSetFollow(symbol: NonTerminalSymbol) {
        if (symbol.getName() != this.getName()) {
            this.pDependentSetInFollow.add(symbol)
        }
    }

    public func addFollowSet(follow: HashSet<TerminalSymbol>) {
        this.pFollowSet.addAll(follow)
    }

    public func addFollow(follow: TerminalSymbol) {
        this.pFollowSet.add(follow)
    }

    public func removeEpsilon(): HashSet<TerminalSymbol> {
        var first: HashSet<TerminalSymbol> = HashSet<TerminalSymbol>(this.pFirstSet)
        for (symbol in first) {
            if (symbol.getName() == "ε") {
                first.remove(symbol)
                break
            }
        }
        return first
    }

    public func containsEpsilon(): Bool {
        for (symbol in this.pFirstSet) {
            if (symbol.getName() == "ε") {
                return true
            }
        }
        return false
    }

    public func addFollowDependent() {
        for (symbol in this.pDependentSetInFollow) {
            this.addFollowSet(symbol.pFollowSet)
        }
    }

    // public func toString(): String {
    //     var first: String = "{"
    //     for (s in this.pFirstSet) {
    //         first += s.getName() + " "
    //     }
    //     first += "}"
    //     // follow集合
    //     var follow: String = "{"
    //     for (s in this.pFollowSet) {
    //         follow += s.getName() + " "
    //     }
    //     follow += "}"
    //     // follow dependent集合
    //     var dependent: String = "{"
    //     for (s in this.pDependentSetInFollow) {
    //         dependent += s.getName() + " "
    //     }
    //     dependent += "}"
    //     return this.getName() + "{\n" +
    //         "\tpProductionTable=" + this.pProductionTable.toString() +
    //         ", \nnumOfProduction=" + this.numOfProduction +
    //         ", pFirstSet=" + first +
    //         ", pFollowSet=" + follow +
    //         ", \npDependentSetInFollow=" + dependent +
    //         "}"
    // }

    public func toString(): String {
        return "${this.getName()}"
    }
    
    // 下面实现 Hashable 和 Equatable 接口，以便 Rotation 作为 HashMap 的 Key
    public func hashCode(): Int64 {
        this.toString().hashCode()
    }

    public operator func ==(that: NonTerminalSymbol): Bool {
        this.toString() == that.toString()
    }

    public operator func !=(that: NonTerminalSymbol): Bool {
        this.toString() != that.toString()
    }
}