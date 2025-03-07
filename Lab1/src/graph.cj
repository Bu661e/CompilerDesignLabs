package Lab1


import std.collection.*

class Graph {
    static var numOfGraph = -1

    var graphId = 0
    // var numOfStatus: Int64 = 0
    // var numOfEdge: Int64 = 0

    var pStateTable: ArrayList<State> = ArrayList<State>()
    var pAdjacencyList: ArrayList<ArrayList<Edge>> = ArrayList<ArrayList<Edge>>()
    var pReverseList: ArrayList<ArrayList<Edge>> = ArrayList<ArrayList<Edge>>()

    var pStartState: Int64 = -1
    var pEndState: Int64 = -1

    public init() {
        numOfGraph += 1
        this.graphId = numOfGraph
    }

    public func printGraph() {
        println("==========================================")
        println("Graph Id: ${this.graphId}")
        println("Number of Status: ${getStateCnt()}")
        println("Number of Edge: ${getEdgeCnt()}\n")
        println("Start State: ${getStartState()}")
        println("End   State: ${getEndState()}")
        for (i in 0..this.pStateTable.size) {
            println("[index ${i}] : [${pStateTable[i].getStateId()},  ${pStateTable[i].stateType.toString()}, ${pStateTable[i].category.toString()}]")
        }
        println("\nAdjacency List:")
        for (i in 0..this.pAdjacencyList.size) {
            println("State ${i}:")
            for (j in this.pAdjacencyList[i]) {
                println("  Edge: [${j.getFromStatus()} -> ${j.getNextStatus()}, DriverId: ${j.driverId}, EdgeType: ${j.edgeType.toString()}]")
            }
        }

        println("\nReverse List:")
        for (i in 0..this.pReverseList.size) {
            println("index ${i}:")
            for (j in this.pReverseList[i]) {
                println("  Edge: [${j.getFromStatus()} -> ${j.getNextStatus()}, DriverId: ${j.driverId}, EdgeType: ${j.edgeType.toString()}]")
            }
        }
    }

        // 添加状态节点
    public func addState(stateType: StateType, category: LexemeCategory, index!: Int64): State {
        let newState = State(getNextStateId(), stateType, category)
        // println("addState: ${newState.stateId}stateType: ${stateType.toString()}, category: ${category.toString()}, index: ${index}")

        // if (stateType.toString() == StateType.MATCH.toString() && getEndState() == -1) {
        //     setEndState(newState.getStateId())
        // }
        match (index) {
            case -1 =>  
                        this.pStateTable.append(newState)
                        this.pAdjacencyList.append(ArrayList<Edge>([]))
                        this.pReverseList.append(ArrayList<Edge>([]))
            case 0 =>   
                        this.pStateTable.prepend(newState)
                        this.pAdjacencyList.prepend(ArrayList<Edge>([]))
                        this.pReverseList.prepend(ArrayList<Edge>([]))
                        resetAllStateId(1, mode: "simplified")  
            case _ =>  throw Exception("addState: index error, it should to be -1 or 0")
        }
        return newState;
    }


    public func addEdge(fromState: Int64, nextState: Int64, driverId: Int64, edgeType: DriverType): Edge {

        let newEdge = Edge(fromState, nextState, driverId, edgeType)
        
        // println("addEdge: fromState: ${fromState}, nextState: ${nextState}, driverId: ${driverId}, edgeType: ${edgeType.toString()}")
        this.pAdjacencyList[fromState].append(newEdge)
        this.pReverseList[nextState].append(newEdge)

        return newEdge
    }



    public func resetAllStateId(off: Int64, mode!: String): Unit{
        let MOD: Int64
        match (mode) {
            case "simplified" => MOD = getStateCnt()
            case "merge" => MOD =  1000000007
            case _ => throw Exception("resetAllStateId: mode error, it should to be simplified or merge")
        }

        for (index in 0..this.pStateTable.size) {
            var st = this.pStateTable[index]
            st.setStateId((st.getStateId() + off) % MOD)
        }

        for (i in this.pAdjacencyList) {
            for (j in i) {
                j.setFromStatus((j.getFromStatus() + off) % MOD)
                j.setNextStatus((j.getNextStatus() + off) % MOD)
            }
        }
        setStartState((getStartState() + off ) % MOD)
        setEndState((getEndState() + off ) % MOD)


    }

    public func simplified(): Unit{
        // println("simplified: start ${this.pStartState}, end ${this.pEndState}")
        if (haveInSide(this.pStartState)) {
            let newStartState = this.addState(StateType.UNMATCH, LexemeCategory.EMPTY, index: 0)
            let newEdge = this.addEdge(newStartState.getStateId(), getStartState(), 0, DriverType.NULL)
            setStartState(newStartState.getStateId())
        }

        if (haveOutSide(this.pEndState)) {
            let newEndState = this.addState(StateType.MATCH, LexemeCategory.EMPTY, index: -1)
            let newEdge = this.addEdge(getEndState(), newEndState.getStateId(), 0, DriverType.NULL)
            setEndState(newEndState.getStateId())

        }
    }



    // public func union(other: Graph): Graph {
    //     var newGraph = Graph()
    //     newGraph.pStateTable = this.pStateTable.clone()
    //     newGraph.pAdjacencyList = this.pAdjacencyList.clone()
    //     newGraph.pReverseList = this.pReverseList.clone()
    //     newGraph.pStartState = this.pStartState
    //     newGraph.pEndState = this.pEndState

    //     var off = this.getStateCnt() - 2
    //     // other.printGraph()
    //     other.resetAllStateId(off, mode: "merge")
    //     other.printGraph()

    //     newGraph.pStateTable.appendAll(other.pStateTable)


    //     return newGraph



    // }

    public func getStateCnt(): Int64 {
        return this.pStateTable.size
    }

    public func getEdgeCnt(): Int64 {
        return this.pAdjacencyList.size
    }

    private func getNextStateId(): Int64 {
        return getStateCnt()
    }


    public func getStartState(): Int64 {
        return this.pStartState
    }

    public func setEndState(endState: Int64) {
        this.pEndState = endState
    }

    public func getEndState(): Int64 {
        return this.pEndState
    }

    public func setStartState(startState: Int64) {
        this.pStartState = startState
    }

    public func haveInSide(stateId: Int64): Bool{
        return this.pReverseList[stateId].size > 0
    }

    public func haveOutSide(stateId: Int64): Bool{
        return this.pAdjacencyList[stateId].size >  0
    }



}

class Edge {
    public Edge(
        var fromState: Int64,
        var nextState: Int64,
        // 输入符号
        let driverId: Int64,
        let edgeType: DriverType
    ) {}

    public func getFromStatus(): Int64 {
        return fromState
    }
    public func setFromStatus(fromStatus: Int64) {
        return this.fromState = fromStatus
    }

    public func getNextStatus(): Int64 {    
        return nextState
    }
    public func setNextStatus(nextState: Int64) {
        return this.nextState = nextState
    }


}

class State {
    public State(
        var stateId: Int64,
        let stateType: StateType,
        let category: LexemeCategory
    ) {}

    public func getStateId(): Int64 {
        return stateId
    }
    public func setStateId(stateId: Int64) {
        return this.stateId = stateId
    }

}

enum DriverType <: ToString {
    NULL | CHAR | CharSet
    public func toString() {
        match (this) {
            case NULL => "NULL"
            case CHAR => "CHAR"
            case CharSet => "CharSet"
        }
    }

}

enum StateType <: ToString{
    MATCH | UNMATCH
    public func toString() {
        match (this) {
            case MATCH => "MATCH"
            case UNMATCH => "UNMATCH"
        }

    }
}

enum LexemeCategory <: ToString{
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

