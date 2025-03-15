package Lab1

func testInitSimpleNFA() {
    var g1 = Graph()

    let st0 = g1.addState(State(g1.getNextStateId(),StateType.UNMATCH, LexemeCategory.EMPTY), index: -1)
    let st1 = g1.addState(State(g1.getNextStateId(),StateType.MATCH, LexemeCategory.EMPTY), index: -1)

    g1.addEdge(Edge(st0.getStateId(), st1.getStateId(), 0, DriverType.CHAR))

    g1.setStartState(st0)
    g1.addEndState(st1)

    // g1.printGraph()
    return g1

}

func testUnion(): Unit{
   
    let pNFA1 = testInitSimpleNFA()
    let pNFA2 = testInitSimpleNFA()
    pNFA1.printGraph()
    pNFA2.printGraph()

    let pNFA3 = NFAGenerator.union(pNFA1, pNFA2)
    pNFA3.printGraph()

}

func testProduct(): Unit{
    let pNFA1 = testInitSimpleNFA()
    let pNFA2 = testInitSimpleNFA()
    pNFA1.printGraph()
    pNFA2.printGraph()

    let pNFA3 = NFAGenerator.product(pNFA1, pNFA2)
    pNFA3.printGraph()
}

func testPlusClosure(): Unit{
    let pNFA1 = testInitSimpleNFA()
    pNFA1.printGraph()

    let pNFA3 = NFAGenerator.plusClosure(pNFA1)
    pNFA3.printGraph()
}

func testZeorOrOne(): Unit {
    let pNFA1 = testInitSimpleNFA()
    pNFA1.printGraph()

    let pNFA3 = NFAGenerator.zeroOrOne(pNFA1)
    pNFA3.printGraph()

}

func testClosure(): Unit{
    let pNFA1 = testInitSimpleNFA()
    pNFA1.printGraph()

    let pNFA3 = NFAGenerator.closure(pNFA1)
    pNFA3.printGraph()
}
