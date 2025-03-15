package Lab1 

import std.collection.*


class NFA2DFA {

    NFA2DFA(
        var pNFA: Graph,
        var charSetTable: CharSetTable
    ) {
    }




    public func convert(): Graph {
        var dfa = Graph()
        var Q: map = map()
        var workList = LinkedList<HashSet<Int64>>()

        
        func printInfo(info: String) {
            println("printInfo_begin=========================================================")
            println(info)

            println("Q: ")
            for (i in 0..Q.keys.size) {
                println("Q${i}: ${Q.keys[i].toString()}")
                println("Q${i}: ${Q.values[i].toString()}")
                
            }
            println("---------------------------------------------------")
            println("workList: ")

            println("${workList.toString()}")
                

            // println("---------------------------------------------------")
            dfa.printGraph()
            // println("---------------------------------------------------")
            println("printInfo_end  =========================================================")
        }
        // pNFA.printGraph()
        // println("pNFA.getStartState().getStateId(): ${pNFA.getStartState().getStateId()}")
        let Q_0 = eps_closure(HashSet<Int64>([pNFA.getStartState().getStateId()]))
        // println(Q_0.toString())
        let q_0 = stateSet2state(Q_0, dfa)

        Q.add(Q_0, q_0)
        

        dfa.addState(q_0, index: 0)
        dfa.setStartState(q_0)

        workList.append(Q_0)

        // printInfo("before while")
        var index = 1
        while (!workList.isEmpty()) {
            let Q_from = workList.popFirst().getOrThrow()
            let q_from = Q.get(Q_from).getOrThrow()
            for (charsetIndex in 0..charSetTable.getNumOfCharSets()) {

                // let new_Q = eps_closure(move(Q_from, charsetIndex)) 
                let new_Q = dTran(Q_from, charsetIndex)
                let new_q = Q.get(new_Q)
        
                if (new_q.isNone()) {
                    let new_q = stateSet2state(new_Q, dfa)
                    Q.add(new_Q, new_q)
                    // if (new_Q.size > 0) {workList.append(new_Q)}
                    workList.append(new_Q)


                    dfa.addState(new_q, index: -1)
                    // TODO DriverType.NULL 要决定怎么改
                    dfa.addEdge(Edge(q_from.getStateId(), new_q.getStateId(), charsetIndex, charSetTable.getCharsetType(charsetIndex)))

                } else {
                    dfa.addEdge(Edge(q_from.getStateId(), new_q.getOrThrow().getStateId(), charsetIndex, charSetTable.getCharsetType(charsetIndex)))
                }

            }
            // printInfo("index: ${index}")
            index += 1
        }
    
        pNFA = dfa
        return dfa

    }
    // TODO 怎么定义categroy
    public func stateSet2state(Q: HashSet<Int64>, dfa: Graph): State {
        let state = State(dfa.getNextStateId(), StateType.UNMATCH, LexemeCategory.EMPTY)

        for (stateIndex in Q) {
            if (pNFA.pStateTable[stateIndex].getStateType().toString() == StateType.MATCH.toString()) {
                state.setStateType(StateType.MATCH)
                state.setCategory(pNFA.pStateTable[stateIndex].getCategory())

            }
        }
        return state

    }

    public func move(q: HashSet<Int64>, ch: Int64): HashSet<Int64> {
        var res = HashSet<Int64>()

        for (stateIndex in q) {
            for (edge in pNFA.pAdjacencyList[stateIndex]) {
                if (edge.getDriverId() == ch) {
                    res.put(edge.getNextStatus())
                }
            }
        }

        return res

    }

    public func eps_closure(st: HashSet<Int64>): HashSet<Int64> {
        // println("eps_closure begin")

        var visited = HashSet<Int64>()
        // println(visited.toString())
        // println("st: ${st.toString()}")


        func dfsHelper(index: Int64): Unit {
            visited.put(index)
            for (edge in pNFA.pAdjacencyList[index]) {
                // 或者 edge.getDriverId() == -1
                if (edge.getEdgeType().toString() == "NULL" && !visited.contains(edge.getNextStatus())) {
                    dfsHelper(edge.getNextStatus())
                }
            }
        }

        for (stateIndex in st) {
            dfsHelper(stateIndex)
        }
        // println(visited.toString())
        // println("eps_closure end")
        return visited

    }
    
    public func dTran(q: HashSet<Int64>, ch: Int64): HashSet<Int64> {
        return eps_closure(move(q, ch))
    }

    public func hopcroft_minimize(): Graph {
        // 初始化划分：接受状态和非接受状态
        var accStates: HashSet<Int64> = HashSet<Int64>()
        var nonAccStates: HashSet<Int64> = HashSet<Int64>()
        for (st in pNFA.pStateTable) {
            if (st.getStateType().toString() == StateType.MATCH.toString()) {
                accStates.put(st.getStateId())
            } else {
                nonAccStates.put(st.getStateId())
            }
        }

        var partition: ArrayList<HashSet<Int64>> = ArrayList<HashSet<Int64>>()
        // TODO 这俩顺序不能颠倒，为什么？
        partition.append(accStates)
        partition.append(nonAccStates)



        // 标记是否需要继续细化划分
        var changed: Bool = true

        while (changed) {
            changed = false
            var new_partition: ArrayList<HashSet<Int64>> = ArrayList<HashSet<Int64>>()

            for (state_set in partition) {
                for (ch in 0..charSetTable.getNumOfCharSets()) {
                    // 获取当前状态集合在字符 ch 上的转移目标集合
                    var next_states: HashSet<Int64> = HashSet<Int64>()
                    for (state in state_set) {
                        for (edge in pNFA.pAdjacencyList[state]) {
                            if (edge.getDriverId() == ch) {
                                next_states.put(edge.getNextStatus())
                            }
                        }
                    }

                    // 检查转移目标是否属于同一个划分集合(也就是 对于同一个ch，next_state是否属于同一个partition)
                    var belongs_to_same_partition: Bool = true
                    var first_next_state: Int64 = -1
                    for (next_state in next_states) {
                        if (first_next_state == -1) {
                            first_next_state = next_state
                        } else {
                            var found_partition: Bool = false
                            for (part in partition) {
                                if (part.contains(next_state) && part.contains(first_next_state)) {
                                    found_partition = true
                                    break
                                }
                            }
                            if (!found_partition) {
                                belongs_to_same_partition = false
                                break
                            }
                        }
                    }
                    // println(belongs_to_same_partition)

                    // TODO 分割这一部分代码存疑
                    if (!belongs_to_same_partition) {
                        // 如果转移目标不属于同一个划分集合，需要分裂
                        changed = true
                        for (next_state in next_states) {
                            // println(next_state.toString())
                            var split_set: HashSet<Int64> = HashSet<Int64>()
                            for (state in state_set) {
                                // println("   ${state.toString()}")
                                for (edge in pNFA.pAdjacencyList[state]) {
                                    if (edge.getDriverId() == ch && edge.getNextStatus() == next_state) {
                                        // println("       put ${state.toString()}")
                                        split_set.put(state)
                                    }
                                }
                            }
                            new_partition.append(split_set)
                            // println(partition.toString())
                            // println(new_partition.toString())
                        }
                        break
                    }
                }
                if (!changed) {
                    new_partition.append(state_set)
                    // println(partition.toString())
                    // println(new_partition.toString())

                }
            }
            // println(partition.toString())
            // println(new_partition.toString())
            partition = new_partition

        }
        // println(partition.toString())

        // 构建最小 DFA
        var min_dfa: Graph = Graph()

        // 构建最小 DFA 的状态集合
        var state_map: map = map()  // 用于记录原 DFA 状态到最小 DFA 状态的映射
        for (i in 0..partition.size) {
            var state_set: HashSet<Int64> = partition[i]
            var new_state: State = State(min_dfa.getNextStateId(), StateType.UNMATCH, LexemeCategory.EMPTY)
            for (state in state_set) {
                if (pNFA.pStateTable[state].getStateType().toString() == StateType.MATCH.toString()) {
                    new_state.setStateType(StateType.MATCH)
                    new_state.setCategory(pNFA.pStateTable[state].getCategory())
                    break
                }
            }
            min_dfa.addState(new_state, index: -1)
            state_map.add(state_set, new_state)
        }

        for (i in 0..state_map.keys.size) {
            println("{ ${state_map.keys[i].toString()}: ${state_map.values[i].toString()} }")   
        }

        // 构建最小 DFA 的转移函数
        for (i in 0..partition.size) {
            var state_set: HashSet<Int64> = partition[i]
            var current_state: State = state_map.get(state_set).getOrThrow()
            for (ch in 0..charSetTable.getNumOfCharSets()) {
                var next_set: HashSet<Int64> = HashSet<Int64>()
                for (state in state_set) {
                    for (edge in pNFA.pAdjacencyList[state]) {
                        if (edge.getDriverId() == ch) {
                            next_set.put(edge.getNextStatus())
                        }
                    }
                }
                if (next_set.size > 0) {
                    var next_state_set: HashSet<Int64> = HashSet<Int64>()  //

                    for (s in partition) {
                        if (s.containsAll(next_set)) {
                            next_state_set = s
                        }
                    }
                    var next_state: State = state_map.get(next_state_set).getOrThrow()
                    min_dfa.addEdge(Edge(current_state.getStateId(), next_state.getStateId(), ch, charSetTable.getCharsetType(ch)))
                }
            }
        }
        


        // 设置最小 DFA 的初始状态和接受状态
        var initial_set: HashSet<Int64> = HashSet<Int64>()
        for (s in partition) {
            if (s.contains(0)) {
                initial_set = s
            }
        }
        var initial_state: State = state_map.get(initial_set).getOrThrow()
        min_dfa.setStartState(initial_state)

        for (i in 0..partition.size) {
            var state_set: HashSet<Int64> = partition[i]
            var state: State = state_map.get(state_set).getOrThrow()
            if (state.getStateType().toString() == StateType.MATCH.toString()) {
                min_dfa.addEndState(state)
            }
        }
        // min_dfa.printGraph()
        pNFA = min_dfa
        return min_dfa
    }

}

class map {
    var keys: ArrayList<HashSet<Int64>>
    var values: ArrayList<State>

    init() {
        this.keys = ArrayList<HashSet<Int64>>()
        this.values = ArrayList<State>()
    }

    public func add(newKey: HashSet<Int64>, newValue: State): Bool {
        if (this.keys.contains(newKey)) {
            return false
        } else {
            this.keys.append(newKey)
            this.values.append(newValue)
            return true
        }
    }

    public func get(pre_key: HashSet<Int64>): ?State {
        for (i in 0..this.keys.size) {
            if (this.keys[i] == pre_key) {
                return this.values[i]
            }
        }
        return None
    }

}