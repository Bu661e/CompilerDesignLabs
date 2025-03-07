package Lab1 

import std.collection.*

class NFAGenerator {

    public static  func generateBasicNFA(driverType: DriverType , driverId: Int64,  category: LexemeCategory): Graph {
        let pNFA = Graph()

        let pState0 = pNFA.addState(StateType.UNMATCH, LexemeCategory.EMPTY, index: 0)
        let pState1 = pNFA.addState(StateType.MATCH, category, index: 0)
        pNFA.addEdge(pState0.getStateId(), pState1.getStateId(), driverId, driverType)
        pNFA.setStartState(pState0.getStateId())
        pNFA.setEndState(pState1.getStateId())
        return pNFA
    }

// TODO 并运算要考虑category的情况
    public static func union(pNFA1: Graph, pNFA2: Graph): Graph {
    

        pNFA1.simplified()
        pNFA2.simplified()
        // pNFA1.printGraph()

        let aOldStart = pNFA1.pStartState
        let aOldEnd = pNFA1.pEndState

        let bOldStart = pNFA2.pStartState
        let bOldEnd = pNFA2.pEndState

        pNFA2.resetAllStateId(pNFA1.pStateTable.size - 2, mode: "merge")
        // pNFA2.printGraph()

        let newStart = pNFA1.pStartState
        let newEnd = pNFA2.pEndState

        // b的start -> st 解决
        for (i in pNFA2.pAdjacencyList[bOldStart] ) {
            i.fromState = newStart
        }

        // a的 st -> end 解决
        for (i in pNFA1.pAdjacencyList ) {
            for (j in i) {
                if (j.nextState == pNFA1.pEndState) {
                    j.nextState = newEnd
                }
            }
        }
        pNFA1.pAdjacencyList[newStart].appendAll(pNFA2.pAdjacencyList[bOldStart])
        pNFA2.pAdjacencyList.remove(bOldStart)
        pNFA1.pAdjacencyList.remove(aOldEnd)
        
        pNFA1.pAdjacencyList.appendAll(pNFA2.pAdjacencyList)

        pNFA1.pStateTable.remove(aOldEnd)
        pNFA2.pStateTable.remove(bOldStart)
        pNFA1.pStateTable.appendAll(pNFA2.pStateTable)

        pNFA1.setEndState(newEnd)
        pNFA1.setStartState(newStart)

        pNFA1.pReverseList.clear()
        for (i in pNFA1.pAdjacencyList) {
            pNFA1.pReverseList.append(ArrayList<Edge>())
        }

        // println(pNFA1.)
        for (i in pNFA1.pAdjacencyList) {
            for (j in i) {
                pNFA1.pReverseList[j.nextState].append(j)
            }
        }

        // pNFA1.printGraph()

        return pNFA1

    }

    public static func product(pNFA1: Graph, pNFA2: Graph): Graph{
        // pNFA1.simplified()
        // pNFA2.simplified()

        let aOldStart = pNFA1.pStartState
        let aOldEnd = pNFA1.pEndState

        let bOldStart = pNFA2.pStartState
        let bOldEnd = pNFA2.pEndState

        let newStart: Int64
        let newEnd: Int64


        if (pNFA1.haveOutSide(aOldEnd) && pNFA2.haveInSide(bOldStart)) {
            pNFA2.resetAllStateId(pNFA1.pStateTable.size, mode: "merge")

            newStart = pNFA1.pStartState
            newEnd = pNFA2.pEndState

            pNFA1.pStateTable.appendAll(pNFA2.pStateTable)
            pNFA1.pAdjacencyList.appendAll(pNFA2.pAdjacencyList)
            pNFA1.pReverseList.appendAll(pNFA2.pReverseList)
            pNFA1.pStartState = newStart
            pNFA1.pEndState = newEnd
        } else {
            pNFA2.resetAllStateId(pNFA1.pStateTable.size - 1, mode: "merge")

            newStart = pNFA1.pStartState
            newEnd = pNFA2.pEndState

            pNFA1.pStateTable.remove(aOldEnd)
            pNFA1.pStateTable.appendAll(pNFA2.pStateTable)

            pNFA1.pAdjacencyList[aOldEnd].appendAll(pNFA2.pAdjacencyList[bOldStart])
            pNFA2.pAdjacencyList.remove(bOldStart)
            pNFA1.pAdjacencyList.appendAll(pNFA2.pAdjacencyList)

            pNFA1.pReverseList.clear()
            for (i in pNFA1.pAdjacencyList) {
                pNFA1.pReverseList.append(ArrayList<Edge>())
            }
            for (i in pNFA1.pAdjacencyList) {
                for (j in i) {
                    pNFA1.pReverseList[j.nextState].append(j)
                }
            }
        }

        pNFA1.setEndState(newEnd)
        pNFA1.setStartState(newStart)

        return pNFA1




    }

    public static func plusClosure(pNFA1: Graph, pNFA2: Graph): Graph{
        // pNFA1.simplified()
        // pNFA2.simplified()

        let aOldStart = pNFA1.pStartState
        let aOldEnd = pNFA1.pEndState

        let bOldStart = pNFA2.pStartState
        let bOldEnd = pNFA2.pEndState

        let newStart: Int64
        let newEnd: Int64




        return pNFA1




    }


}


