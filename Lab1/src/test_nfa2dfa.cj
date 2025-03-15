package Lab1

import std.collection.*

public func test_nfa2dfa() {


    var charSetTable :CharSetTable = CharSetTable()
    charSetTable.add(ArrayList<(Rune, Rune)>([(r'a', r'a')]))
    charSetTable.add(ArrayList<(Rune, Rune)>([(r'b', r'b')]))
    // charSetTable.print()

    var p0 = NFAGenerator.generateBasicNFA(DriverType.CHAR, 0, LexemeCategory.EMPTY)
    var p1 = NFAGenerator.generateBasicNFA(DriverType.CHAR, 1, LexemeCategory.EMPTY)
    var p2 = NFAGenerator.generateBasicNFA(DriverType.CHAR, 0, LexemeCategory.EMPTY)
    var p3 = NFAGenerator.generateBasicNFA(DriverType.CHAR, 1, LexemeCategory.EMPTY)
    var p4 = NFAGenerator.generateBasicNFA(DriverType.CHAR, 1, LexemeCategory.EMPTY)

    var p5 = NFAGenerator.union(p0, p1)
    // p5.printGraph()
    var p6 = NFAGenerator.product(p2, p3)
    var p7 = NFAGenerator.product(p6, p4)
    // p7.printGraph()

    var p8 = NFAGenerator.closure(p5)
    // p8.printGraph()
    var p9 = NFAGenerator.product(p8, p7)
    p9.printGraph()

    var nfa2dfa = NFA2DFA(p9, charSetTable)
    nfa2dfa.convert()
    nfa2dfa.pNFA.printGraph()
    
    nfa2dfa.hopcroft_minimize()
    nfa2dfa.pNFA.printGraph()


}

// hopcroft minimization has bug
// https://blog.csdn.net/qq_41112170/article/details/122723414
public func test_nfa2dfa1() {


    var charSetTable :CharSetTable = CharSetTable()
    charSetTable.add(ArrayList<(Rune, Rune)>([(r'a', r'a')]))
    charSetTable.add(ArrayList<(Rune, Rune)>([(r'b', r'b')]))
    // charSetTable.print()

    var p0 = NFAGenerator.generateBasicNFA(DriverType.CHAR, 0, LexemeCategory.EMPTY)
    var p1 = NFAGenerator.generateBasicNFA(DriverType.CHAR, 1, LexemeCategory.EMPTY)
    var p2 = NFAGenerator.zeroOrOne(p0) //
    var p3 = NFAGenerator.closure(p1)
    var p4 = NFAGenerator.product(p2, p3)
    var p5 = NFAGenerator.closure(p4)
    p5.printGraph()

    var nfa2dfa = NFA2DFA(p5, charSetTable)
    nfa2dfa.convert()
    nfa2dfa.pNFA.printGraph()
    
    nfa2dfa.hopcroft_minimize()
    nfa2dfa.pNFA.printGraph()

}
// nfa2dfa has bug
public func test_nfa2dfa2() {


    var charSetTable :CharSetTable = CharSetTable()
    charSetTable.add(ArrayList<(Rune, Rune)>([(r'a', r'a')]))
    charSetTable.add(ArrayList<(Rune, Rune)>([(r'b', r'b')]))
    // charSetTable.print()

    var p0 = NFAGenerator.generateBasicNFA(DriverType.CHAR, 0, LexemeCategory.EMPTY)
    var p1 = NFAGenerator.generateBasicNFA(DriverType.CHAR, 1, LexemeCategory.EMPTY)
    var p2 = NFAGenerator.plusClosure(p0) //
    var p3 = NFAGenerator.closure(p1)
    var p4 = NFAGenerator.product(p2, p3)
    var p5 = NFAGenerator.closure(p4)
    p5.printGraph()

    var nfa2dfa = NFA2DFA(p5, charSetTable)
    nfa2dfa.convert()
    nfa2dfa.pNFA.printGraph()
    
    nfa2dfa.hopcroft_minimize()
    nfa2dfa.pNFA.printGraph()


}