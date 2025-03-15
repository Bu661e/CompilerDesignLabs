package Lab1 

import std.collection.*

class NFAGenerator {

    public static  func generateBasicNFA(driverType: DriverType , driverId: Int64,  category: LexemeCategory): Graph {
        let pNFA = Graph()

        let pState0 = pNFA.addState(State(pNFA.getNextStateId(),StateType.UNMATCH, LexemeCategory.EMPTY), index: 0)
        let pState1 = pNFA.addState(State(pNFA.getNextStateId(),StateType.MATCH, LexemeCategory.EMPTY), index: -1)

        pNFA.addEdge(Edge(pState0.getStateId(), pState1.getStateId(), driverId, driverType))

        pNFA.setStartState(pState0)
        pNFA.addEndState(pState1)

        return pNFA
    }

    // TODO 要考虑category的情况
    // TODO 要考虑NFA的终结状态有几个 ，在连接的时候，是哪个终结状态和另一个图的起始连接？
    public static func union(pNFA1: Graph, pNFA2: Graph): Graph {
    
        let aOldStart = pNFA1.getStartState()
        let aOldEnd = pNFA1.getEndState()

        let bOldStart = pNFA2.getStartState()
        let bOldEnd = pNFA2.getEndState()

        let newStart = pNFA1.addState(State(pNFA1.getNextStateId(),StateType.UNMATCH, LexemeCategory.EMPTY), index: 0)
        let newEnd = pNFA2.addState(State(pNFA2.getNextStateId(),StateType.MATCH, LexemeCategory.EMPTY), index: -1)

        pNFA2.resetAllStateId(pNFA1.getStateCnt(), mode: "merge")

        // pNFA1.printGraph()
        // pNFA2.printGraph()

        pNFA1.pStateTable.appendAll(pNFA2.pStateTable)
        pNFA1.pAdjacencyList.appendAll(pNFA2.pAdjacencyList)

        pNFA1.addEdge(Edge(newStart.getStateId(), aOldStart.getStateId(), -1, DriverType.NULL))
        pNFA1.addEdge(Edge(newStart.getStateId(), bOldStart.getStateId(), -1, DriverType.NULL))
        pNFA1.addEdge(Edge(aOldEnd[0].getStateId(), newEnd.getStateId(), -1, DriverType.NULL))
        pNFA1.addEdge(Edge(bOldEnd[0].getStateId(), newEnd.getStateId(), -1, DriverType.NULL))


        pNFA1.setStartState(newStart)
        for (st in pNFA1.pEndStateTable) {
            st.setStateType(StateType.UNMATCH)
        }
        pNFA1.pEndStateTable.clear()
        for (st in pNFA2.pEndStateTable) {
            st.setStateType(StateType.UNMATCH)
        }
        pNFA2.pEndStateTable.clear()

        pNFA1.pEndStateTable.append(newEnd)

        return pNFA1

    }

    // TODO 要考虑category的情况
    // TODO 要考虑NFA的终结状态有几个 ，在连接的时候，是哪个终结状态和另一个图的起始连接？
    public static func product(pNFA1: Graph, pNFA2: Graph): Graph{


        let aOldStart = pNFA1.getStartState()
        let aOldEnd = pNFA1.getEndState()

        let bOldStart = pNFA2.getStartState()
        let bOldEnd = pNFA2.getEndState()


        pNFA2.resetAllStateId(pNFA1.getStateCnt(), mode: "merge")
        pNFA1.pStateTable.appendAll(pNFA2.pStateTable)
        pNFA1.pAdjacencyList.appendAll(pNFA2.pAdjacencyList)
        pNFA1.addEdge(Edge(aOldEnd[0].getStateId(), bOldStart.getStateId(), -1, DriverType.NULL))


        pNFA1.setStartState(aOldStart)
        for (st in pNFA1.pEndStateTable) {
            st.setStateType(StateType.UNMATCH)
        }
        pNFA1.pEndStateTable.clear()
        pNFA1.pEndStateTable.appendAll(pNFA2.pEndStateTable)

        return pNFA1

    }

    public static func plusClosure(pNFA1: Graph): Graph{


        let aOldStart = pNFA1.getStartState()
        let aOldEnd = pNFA1.getEndState()

        let newStart = pNFA1.addState(State(pNFA1.getNextStateId(),StateType.UNMATCH, LexemeCategory.EMPTY), index: 0)
        let newEnd = pNFA1.addState(State(pNFA1.getNextStateId(),StateType.MATCH, LexemeCategory.EMPTY), index: -1)

        pNFA1.addEdge(Edge(newStart.getStateId(), aOldStart.getStateId(), -1, DriverType.NULL))
        pNFA1.addEdge(Edge(aOldEnd[0].getStateId(), newEnd.getStateId(), -1, DriverType.NULL))
        pNFA1.addEdge(Edge(aOldEnd[0].getStateId(), aOldStart.getStateId(), -1, DriverType.NULL))

        pNFA1.setStartState(newStart)
        for (st in pNFA1.pEndStateTable) {
            st.setStateType(StateType.UNMATCH)
        }
        pNFA1.pEndStateTable.clear()
        pNFA1.pEndStateTable.append(newEnd)

        return pNFA1
    }

    public static func zeroOrOne(pNFA1: Graph): Graph {
        let aOldStart = pNFA1.getStartState()
        let aOldEnd = pNFA1.getEndState()

        let newStart = pNFA1.addState(State(pNFA1.getNextStateId(),StateType.UNMATCH, LexemeCategory.EMPTY), index: 0)
        let newEnd = pNFA1.addState(State(pNFA1.getNextStateId(),StateType.MATCH, LexemeCategory.EMPTY), index: -1)

        pNFA1.addEdge(Edge(newStart.getStateId(), aOldStart.getStateId(), -1, DriverType.NULL))
        pNFA1.addEdge(Edge(aOldEnd[0].getStateId(), newEnd.getStateId(), -1, DriverType.NULL))
        pNFA1.addEdge(Edge(newStart.getStateId(), newEnd.getStateId(), -1, DriverType.NULL))

        pNFA1.setStartState(newStart)
        for (st in pNFA1.pEndStateTable) {
            st.setStateType(StateType.UNMATCH)
        }
        pNFA1.pEndStateTable.clear()
        pNFA1.pEndStateTable.append(newEnd)

        return pNFA1

    }
    public static func closure(pNFA1: Graph): Graph {
        
        let aOldStart = pNFA1.getStartState()
        let aOldEnd = pNFA1.getEndState()

        let newStart = pNFA1.addState(State(pNFA1.getNextStateId(),StateType.UNMATCH, LexemeCategory.EMPTY), index: 0)
        let newEnd = pNFA1.addState(State(pNFA1.getNextStateId(),StateType.MATCH, LexemeCategory.EMPTY), index: -1)

        pNFA1.addEdge(Edge(newStart.getStateId(), aOldStart.getStateId(), -1, DriverType.NULL))
        pNFA1.addEdge(Edge(aOldEnd[0].getStateId(), newEnd.getStateId(), -1, DriverType.NULL))
        pNFA1.addEdge(Edge(aOldEnd[0].getStateId(), aOldStart.getStateId(), -1, DriverType.NULL))
        pNFA1.addEdge(Edge(newStart.getStateId(), newEnd.getStateId(), -1, DriverType.NULL))
        


        pNFA1.setStartState(newStart)
        for (st in pNFA1.pEndStateTable) {
            st.setStateType(StateType.UNMATCH)
        }
        pNFA1.pEndStateTable.clear()
        pNFA1.pEndStateTable.append(newEnd)

        return pNFA1



    }

}




