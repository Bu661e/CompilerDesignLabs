package Lab1


import std.collection.*

class Graph {
    static var numOfGraph = -1

    var graphId = 0

    var pStateTable: ArrayList<State> = ArrayList<State>()
    var pAdjacencyList: ArrayList<ArrayList<Edge>> = ArrayList<ArrayList<Edge>>()


    var pStartState: State = State(-1, StateType.UNMATCH, LexemeCategory.EMPTY)
    var pEndStateTable: ArrayList<State> = ArrayList<State>()

    public init() {
        numOfGraph += 1
        this.graphId = numOfGraph
    }

    public func printGraph() {
        println("============ printGraph_begin========================")
        println("Graph Id: ${this.graphId}")
        println("Number of Status: ${getStateCnt()}")
        println("Number of Edge: ${getEdgeCnt()}\n")
        println("Start State ID: ${getStartState().getStateId()}")
        println("EndStateTable List:")
        for (i in 0..this.pEndStateTable.size) {
            println("[index ${i}] : [${pEndStateTable[i].getStateId()},  ${pEndStateTable[i].stateType.toString()}, ${pEndStateTable[i].category.toString()}]")
        }

        println("\nStateTable List:")
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
        println("============ printGraph_end  ========================")



    }



    public func addState(newState: State, index!: Int64): State {

        match (index) {
            case -1 =>  
                        this.pStateTable.append(newState)
                        this.pAdjacencyList.append(ArrayList<Edge>([]))
            case 0 =>   
                        this.pStateTable.prepend(newState)
                        this.pAdjacencyList.prepend(ArrayList<Edge>([]))
                        resetAllStateId(1, mode: "simplified")  
            case _ =>  throw Exception("addState: index error, it should to be -1 or 0")
        }
        return newState;
    }

    public func addEdge(newEdge: Edge): Edge {

        
        // println("addEdge: fromState: ${fromState}, nextState: ${nextState}, driverId: ${driverId}, edgeType: ${edgeType.toString()}")
        this.pAdjacencyList[newEdge.fromState].append(newEdge)

        return newEdge
    }


    public func resetAllStateId(off: Int64, mode!: String): Unit{
        let MOD: Int64
        match (mode) {
            case "simplified" => MOD = getStateCnt()
            case "merge" => MOD =  1000000007
            case _ => throw Exception("resetAllStateId: mode error, it should to be simplified or merge")
        }


        for (st in this.pStateTable) {
            st.setStateId((st.getStateId() + off) % MOD)
        }

        for (i in this.pAdjacencyList) {
            for (j in i) {
                j.setFromStatus((j.getFromStatus() + off) % MOD)
                j.setNextStatus((j.getNextStatus() + off) % MOD)
            }
        }




    }


    public func getStateCnt(): Int64 {
        return this.pStateTable.size
    }

    public func getEdgeCnt(): Int64 {
        return this.pAdjacencyList.size
    }

    public func getNextStateId(): Int64 {
        return getStateCnt()
    }


    public func getStartState(): State {
        return this.pStartState
    }

    public func getEndState(): ArrayList<State> {
        return this.pEndStateTable
    }

    public func setStartState(startState: State) {
        this.pStartState = startState
    }
    public func addEndState(state: State) {
        this.pEndStateTable.append(state)
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
        var driverId: Int64,
        var edgeType: DriverType
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
    public func getDriverId(): Int64 {
        return driverId
    }
    public func setDriverId(driverId: Int64) {
        return this.driverId = driverId
    }
    public func getEdgeType(): DriverType {
        return edgeType
    }
    public func setEdgeType(edgeType: DriverType) {
        return this.edgeType = edgeType
    }


}

class State {
    public State(
        var stateId: Int64,
        var stateType: StateType,
        var category: LexemeCategory
    ) {}

    public func getStateId(): Int64 {
        return stateId
    }
    public func setStateId(stateId: Int64) {
        return this.stateId = stateId
    }
    public func getStateType(): StateType {
        return stateType
    }
    public func getCategory(): LexemeCategory {
        return category
    }
    public func setCategory(category: LexemeCategory) {
        return this.category = category
    }
    public func setStateType(stateType: StateType) {
        return this.stateType = stateType
    }
    public func toString(): String {
        return "State(stateId: ${stateId}, stateType: ${stateType.toString()}, category: ${category.toString()})"
    }



}

public enum DriverType <: ToString {
    NULL | CHAR | ChARSET
    public func toString() {
        match (this) {
            case NULL => "NULL"
            case CHAR => "CHAR"
            case ChARSET => "CHARSET"
        }
    }

}

public enum StateType <: ToString{
    MATCH | UNMATCH
    public func toString() {
        match (this) {
            case MATCH => "MATCH"
            case UNMATCH => "UNMATCH"
        }

    }
}

public enum LexemeCategory <: ToString{
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

