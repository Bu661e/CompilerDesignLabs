class DFA:
    def __init__(self, states, alphabet, transitions, start_state, accept_states):
        """
        初始化 DFA。
        :param states: 状态集合
        :param alphabet: 字母表
        :param transitions: 转移函数，格式为 {state: {char: next_state}}
        :param start_state: 初始状态
        :param accept_states: 接受状态集合
        """
        self.states = states
        self.alphabet = alphabet
        self.transitions = transitions
        self.start_state = start_state
        self.accept_states = accept_states


def hopcroft_minimize(dfa):
    """
    使用 Hopcroft 算法最小化 DFA。
    """
    # 初始化划分：接受状态和非接受状态
    accept_states = set(dfa.accept_states)
    non_accept_states = set(dfa.states) - accept_states
    partition = [accept_states, non_accept_states]  # 初始划分集合

    # 标记是否需要继续细化划分
    changed = True

    while changed:
        changed = False
        new_partition = []  # 用于存储新的划分集合

        for state_set in partition:
            # 遍历当前划分集合中的每个状态集合
            for char in dfa.alphabet:
                # 遍历字母表中的每个字符
                next_states = set()  # 用于存储通过字符转移后的状态集合
                for state in state_set:
                    if char in dfa.transitions[state]:
                        next_states.add(dfa.transitions[state][char])

                if len(next_states) > 1:
                    # 如果通过字符转移后有多个不同的状态，则需要分裂
                    changed = True
                    for next_state in next_states:
                        split_set = set()
                        for state in state_set:
                            if char in dfa.transitions[state] and dfa.transitions[state][char] == next_state:
                                split_set.add(state)
                        new_partition.append(split_set)
                    break
            else:
                # 如果当前状态集合不需要分裂，则直接加入新的划分集合
                new_partition.append(state_set)

        partition = new_partition  # 更新划分集合

    # 构建最小 DFA 的状态集合
    min_states = [tuple(sorted(s)) for s in partition]

    # 构建最小 DFA 的转移函数
    min_transitions = {}
    for i, state_set in enumerate(partition):
        for char in dfa.alphabet:
            next_state_set = set()
            for state in state_set:
                if char in dfa.transitions[state]:
                    next_state_set.add(dfa.transitions[state][char])
            if next_state_set:
                next_state_index = min_states.index(tuple(sorted(next_state_set)))
                min_transitions[(i, char)] = next_state_index

    # 构建最小 DFA 的接受状态集合
    min_accept_states = []
    for i, state_set in enumerate(partition):
        for state in state_set:
            if state in accept_states:
                min_accept_states.append(i)
                break

    # 返回最小 DFA
    return DFA(
        states=min_states,
        alphabet=dfa.alphabet,
        transitions=min_transitions,
        start_state=0,  # 假设原 DFA 的初始状态在最小 DFA 中的索引为 0
        accept_states=min_accept_states
    )


# 示例 DFA
states = {0, 1, 2, 3}
alphabet = {'a', 'b'}
transitions = {
    0: {'a': 1, 'b': 2},
    1: {'a': 3, 'b': 3},
    2: {'a': 3, 'b': 3},
    3: {'a': 3, 'b': 3}
}
start_state = 0
accept_states = {3}

dfa = DFA(states, alphabet, transitions, start_state, accept_states)
min_dfa = hopcroft_minimize(dfa)

print("Minimized DFA States:", min_dfa.states)
print("Minimized DFA Transitions:", min_dfa.transitions)
print("Minimized DFA Accept States:", min_dfa.accept_states)