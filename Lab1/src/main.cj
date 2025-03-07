package Lab1

import std.collection.*

var charSetTable = CharSetTable()
var g = Graph()

main(): Int64 {

    // testCharSetTable_append()
    // testCharSetTable_range()
    // testCharSetTable_union_c()
    // testCharSetTable_union_c_charSetId()
    // testCharSetTable_union_charSetId_charSetId()
    // testCharSetTable_difference()

    // testGraphInitAddStateEdge()
    // testResetAllStateId()
    // testSimplified()
    // testUnion()
    // testGraphInitAddStateEdge()

    // g.printGraph()
    // testUnion()
    testProduct()



    return 0
}


func testGraphInitAddStateEdge(): Graph {
    var g1 = Graph()
    let st0 = g1.addState(StateType.UNMATCH, LexemeCategory.EMPTY, index: -1)
    g1.setStartState(st0.getStateId())
    let st1 = g1.addState(StateType.MATCH, LexemeCategory.EMPTY, index: -1)

    let st2 = g1.addState(StateType.UNMATCH, LexemeCategory.EMPTY, index: -1)
    let st3 = g1.addState(StateType.UNMATCH, LexemeCategory.EMPTY, index: -1)
    let st4 = g1.addState(StateType.UNMATCH, LexemeCategory.EMPTY, index: -1)
    g1.setEndState(st4.getStateId())
    g1.addEdge(st0.getStateId(), st1.getStateId(), 0, DriverType.CHAR)
    g1.addEdge(st0.getStateId(), st2.getStateId(), 0, DriverType.CHAR)
    g1.addEdge(st1.getStateId(), st3.getStateId(), 0, DriverType.CHAR)
    g1.addEdge(st2.getStateId(), st4.getStateId(), 0, DriverType.CHAR)
    g1.addEdge(st4.getStateId(), st0.getStateId(), 0, DriverType.CHAR)
    // g1.printGraph()
    return g1

}

func testGraphInitAddStateEdge1(): Graph {
    var g1 = Graph()
    let st0 = g1.addState(StateType.UNMATCH, LexemeCategory.EMPTY, index: -1)
    let st1 = g1.addState(StateType.UNMATCH, LexemeCategory.EMPTY, index: -1)
    let st2 = g1.addState(StateType.UNMATCH, LexemeCategory.EMPTY, index: -1)
    g1.setStartState(st0.getStateId())
    g1.setEndState(st2.getStateId())
    g1.addEdge(st0.getStateId(), st1.getStateId(), 0, DriverType.CHAR)
    g1.addEdge(st1.getStateId(), st2.getStateId(), 0, DriverType.CHAR)
    // g1.addEdge(st2.getStateId(), st0.getStateId(), 0, DriverType.CHAR)
    // g1.printGraph()
    return g1

}

func testResetAllStateId(): Unit{
    testGraphInitAddStateEdge()
    g.addState(StateType.MATCH, LexemeCategory.EMPTY, index: -1)
    g.resetAllStateId(1, mode: "simplified")


}

func testSimplified(): Unit{
    testGraphInitAddStateEdge()
    g.simplified()
}

func testUnion(): Unit{
    // NFAGenerator.union(NFAGenerator.generateBasicNFA(DriverType.CharSet, 0, LexemeCategory.EMPTY), NFAGenerator.generateBasicNFA(DriverType.CharSet, 1, LexemeCategory.EMPTY))

    let pNFA1 = testGraphInitAddStateEdge()
    let pNFA2 = testGraphInitAddStateEdge()
    let pNFA3 = NFAGenerator.union(pNFA1, pNFA2)
    pNFA1.printGraph()
    pNFA2.printGraph()
    pNFA3.printGraph()

}

func testProduct(): Unit{
    let pNFA1 = testGraphInitAddStateEdge1()
    let pNFA2 = testGraphInitAddStateEdge1()
    let pNFA3 = NFAGenerator.product(pNFA1, pNFA2)
    pNFA1.printGraph()
    pNFA2.printGraph()
    pNFA3.printGraph()
}
