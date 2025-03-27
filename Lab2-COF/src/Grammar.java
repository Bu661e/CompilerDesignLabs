import java.util.ArrayList;
import java.util.Arrays;

import generator.GeneratorLL1;
import generator.GeneratorLR;
import lr0.DFA;
import lr0.ItemSet;
import lr0.LR0Item;

import symbol.GrammarSymbol;
import symbol.NonTerminalSymbol;
import symbol.Production;
import symbol.TerminalSymbol;
import symbol.Cell;

import type.SymbolType;


public class Grammar {

    public NonTerminalSymbol start = null;
    private ArrayList<NonTerminalSymbol> nonTerSyms = new ArrayList<>();
    private ArrayList<TerminalSymbol> terSyms = new ArrayList<>();




    Grammar(String garmmerType) {

        if (garmmerType.equals("LL") || garmmerType.equals("ll")) {
            initLL();
        } else if (garmmerType.equals("LR") || garmmerType.equals("lr")) {
            initLR();
        } else if (garmmerType.equals("SLR") || garmmerType.equals("slr")) {
            initSLR();
        } else {
           throw new IllegalArgumentException("Invalid grammar type: " + garmmerType);
        }
    }

   // 添加文法符号
    GrammarSymbol addSymbol(String name, SymbolType type) {
        if (type == SymbolType.NONTERMINAL) {
            NonTerminalSymbol nonTerminalSymbol = new NonTerminalSymbol(name, type);
            nonTerSyms.add(nonTerminalSymbol);
            return nonTerminalSymbol;
        }
        else {
            TerminalSymbol terminalSymbol = new TerminalSymbol(name, type);
            terSyms.add(terminalSymbol);
            return terminalSymbol;
        }

    }
    // 添加产生式
    Production addProduction(NonTerminalSymbol left, ArrayList<GrammarSymbol> right) {
        Production production = new Production(left, right);
        left.addProduction(production);
        // productions.add(production);
        return production;
    }
    // print
    public void printProductions() {
        System.out.println("产生式表：");
        for (NonTerminalSymbol n: nonTerSyms) {
            System.out.println(n.getName() + ":");
            for (Production p: n.getpProductionTable()) {
                System.out.print("\t");
                p.printInfo();
            }
        }
        System.out.println();
    }
    public void printNonTerminalSymbols() {
        System.out.println("非终结符表：");
        for (NonTerminalSymbol n: nonTerSyms) {
            n.printInfo();
        }
        System.out.println();
    }
    public void printTerminalSymbols() {
        System.out.println("终结符表：");
        for (TerminalSymbol t: terSyms) {
            t.printInfo();
        }
        System.out.println();
    }
    public void printLL1Table() {
        System.out.println("LL1分析表：");
        System.out.println(LL1Table);
        System.out.println();
    }

// LL1 文法转换

    private ArrayList<Cell> LL1Table = new ArrayList<>();

    // 0. 初始化
    void initLL() {
        
        // 非终结符E,E',T,T',F
        NonTerminalSymbol E     = new NonTerminalSymbol("E", SymbolType.NONTERMINAL);
        NonTerminalSymbol E_dot = new NonTerminalSymbol("E'", SymbolType.NONTERMINAL);
        NonTerminalSymbol T     = new NonTerminalSymbol("T", SymbolType.NONTERMINAL);
        NonTerminalSymbol T_dot = new NonTerminalSymbol("T'", SymbolType.NONTERMINAL);
        NonTerminalSymbol F     = new NonTerminalSymbol("F", SymbolType.NONTERMINAL);

        // !!!为了FOLLOW集
        start = E;
        nonTerSyms = new ArrayList<>(Arrays.asList(E, E_dot, T, T_dot, F));
        // 终结符+,*,(,),id,ε
        TerminalSymbol plus     = new TerminalSymbol("+", SymbolType.TERMINAL);
        TerminalSymbol multi    = new TerminalSymbol("*", SymbolType.TERMINAL);
        TerminalSymbol left     = new TerminalSymbol("(", SymbolType.TERMINAL);
        TerminalSymbol right    = new TerminalSymbol(")", SymbolType.TERMINAL);
        TerminalSymbol id       = new TerminalSymbol("id", SymbolType.TERMINAL);
        TerminalSymbol epsilon  = new TerminalSymbol("ε", SymbolType.NULL);

        terSyms = new ArrayList<>(Arrays.asList(plus, multi, left, right, id, epsilon));
        
        // 产生式E->TE'
        E.addProduction(new Production(E, new ArrayList<>(Arrays.asList(T, E_dot))));
        // 产生式E'->+TE'
        E_dot.addProduction(new Production(E_dot, new ArrayList<>(Arrays.asList(plus, T, E_dot))));
        // 产生式E'->ε
        E_dot.addProduction(new Production(E_dot, new ArrayList<>(Arrays.asList(epsilon))));
        // 产生式T->FT'
        T.addProduction(new Production(T, new ArrayList<>(Arrays.asList(F, T_dot))));
        // 产生式T'->*FT'
        T_dot.addProduction(new Production(T_dot , new ArrayList<>(Arrays.asList(multi, F, T_dot))));
        // 产生式T'->ε
        T_dot.addProduction(new Production(T_dot, new ArrayList<>(Arrays.asList(epsilon))));
        // 产生式F->(E)
        F.addProduction(new Production(F, new ArrayList<>(Arrays.asList(left, E, right))));
        // 产生式F->id
        F.addProduction(new Production(F, new ArrayList<>(Arrays.asList(id))));


    }
 
    // 1. 左递归式 return A'
    public NonTerminalSymbol leftRecursion(NonTerminalSymbol A) {
        NonTerminalSymbol A_ = GeneratorLL1.leftRecursion(A);
        nonTerSyms.add(A_);
        return A_;
        
    }

    // 2. 左公因子
    public ArrayList<NonTerminalSymbol> leftCommonFactor(NonTerminalSymbol A) {
        ArrayList<NonTerminalSymbol> newSymbols =  GeneratorLL1.leftCommonFactor(A);
        for (NonTerminalSymbol nonTerminalSymbol : newSymbols) {
            nonTerSyms.add(nonTerminalSymbol);
        }
        return newSymbols;
    }

    //3.  生成非终结符的 FIRST 集合
    public void generateFirstOfNonTerminal() {
        for (NonTerminalSymbol n: nonTerSyms) {
            GeneratorLL1.firstOfSymbol(n);
        }
    }

    // 4. 生成 Production 的 FIRST 集合
    public void generateFirstOfProduction() {
        for (NonTerminalSymbol n: nonTerSyms) {
            for (Production p: n.getpProductionTable()) {
                GeneratorLL1.firstOfProduction(p);
            }
        }

    }

    // 5. 求FOLLOW集
    public void generateFollowOfNonTerminal() {
        TerminalSymbol end  = new TerminalSymbol("#", SymbolType.TERMINAL);
        if (start == null) {
            System.err.println("start is null");
        }
        System.out.println("start: " + start.getName() + " end: " + end.getName());
        start.addFollow(end);
        for (NonTerminalSymbol n: nonTerSyms) {
            GeneratorLL1.followOfSymbol(n);
        }
    }
    
    // 5.1 求FOLLOW集的依赖
    public void generateFollowDependent() {
        for (NonTerminalSymbol n: nonTerSyms) {
            n.addFollowDependent();
        }
    }

    // 6. 判断是否为 LL1 文法
    public Boolean isLL1() {
        for (NonTerminalSymbol n: nonTerSyms) {
            Boolean ans = GeneratorLL1.isLL1(n);
            System.out.println(n.getName() + ": " + ans);
            if (!ans) { System.out.println("it is not LL1");return false; }
        }

        System.out.println("it is  LL1");
        return true;
    }

    // 7. 构造 LL1 分析表
    public void generateParseTable() {
        ArrayList<NonTerminalSymbol> pNonTerminalSymbolTable = new ArrayList<>();
        pNonTerminalSymbolTable.addAll(nonTerSyms);
        LL1Table = GeneratorLL1.parseTable(pNonTerminalSymbolTable);
        // System.out.println(LL1Table);
    }

// LR0 文法转换

    ArrayList<ItemSet> itemSets = new ArrayList<>();
    DFA dfa = new DFA();
    public ItemSet addItemSet() {
        ItemSet itemSet = new ItemSet();
        itemSets.add(itemSet);
        return itemSet;
    }

    public LR0Item addLr0Item(ItemSet itemSet, LR0Item lr0Item) {
        itemSet.addItem(lr0Item);
        return lr0Item;
    }

    public void printItemSets() {
        System.out.println("ItemSets:");
        System.out.println("状态数量:" + itemSets.size());
        System.out.println("pos表示圆点的位置");
        System.out.println(itemSets);
        for (ItemSet itemSet: itemSets) {
            itemSet.printInfo();
        }
        System.out.println();
    }
    
    public void printDFA() {
        System.out.println("DFA:");
        dfa.printInfo();
        System.out.println();
    }
    // 0.初始化LR0的数据
    public void initLR() {
        // 非终结符E',E,T,F，
        NonTerminalSymbol E_dot = new NonTerminalSymbol("E'", SymbolType.NONTERMINAL);
        NonTerminalSymbol E = new NonTerminalSymbol("E", SymbolType.NONTERMINAL);
        NonTerminalSymbol T = new NonTerminalSymbol("T", SymbolType.NONTERMINAL);
        NonTerminalSymbol F = new NonTerminalSymbol("F", SymbolType.NONTERMINAL);
        // 终结符+,*,(,),id,ε
        TerminalSymbol plus = new TerminalSymbol("+", SymbolType.TERMINAL);
        TerminalSymbol multi = new TerminalSymbol("*", SymbolType.TERMINAL);
        TerminalSymbol left = new TerminalSymbol("(", SymbolType.TERMINAL);
        TerminalSymbol right = new TerminalSymbol(")", SymbolType.TERMINAL);
        TerminalSymbol id = new TerminalSymbol("id", SymbolType.TERMINAL);

        // !!!为了FOLLOW集
        start = E_dot;
        nonTerSyms = new ArrayList<>(Arrays.asList(E_dot, E, T, F));
        terSyms = new ArrayList<>(Arrays.asList(plus, multi, left, right, id));


        // 产生式E'->E
        E_dot.addProduction(new Production(E_dot, new ArrayList<>(Arrays.asList(E))));
        
        // 产生式E->E+T
        E.addProduction(new Production(E, new ArrayList<>(Arrays.asList(E, plus, T))));
        // 产生式E->T
        E.addProduction(new Production(E, new ArrayList<>(Arrays.asList(T))));


        // 产生式T->T*F
        T.addProduction(new Production(T, new ArrayList<>(Arrays.asList(T,multi, F))));
        // 产生式T->F
        T.addProduction(new Production(T , new ArrayList<>(Arrays.asList(F))));


        // 产生式F->(E)
        F.addProduction(new Production(F, new ArrayList<>(Arrays.asList(left, E, right))));
        // 产生式F->id
        F.addProduction(new Production(F, new ArrayList<>(Arrays.asList(id))));

        
    } 
    // 1. 求某个状态的闭包
    public void getClosure(ItemSet itemSet) {
        GeneratorLR.getClosure(itemSet);
        // itemSets = GeneratorLR.getAllItemSet();

    }
    // 2. 求某个状态的所有后继状态
    public void exhaustTransition(ItemSet itemSet) {
        // !!!GeneratorLR在处理exhaustTransition的时候是用自己内部的数据，所以要把itemSet穿进去
        GeneratorLR.addItemSet(itemSet);

        GeneratorLR.exhaustTransition(itemSet);
        itemSets = GeneratorLR.getAllItemSet();
        
    }
    // 3. 构造 DFA
    public void getDFA(ItemSet itemSet) {

        GeneratorLR.addItemSet(itemSet);

        dfa = GeneratorLR.getDFA(itemSets.get(0));
        itemSets = GeneratorLR.getAllItemSet();
        
    }

//  SLR文法转化
    void initSLR() {
        // 非终结符Z', Z
        NonTerminalSymbol Z_dot = new NonTerminalSymbol("Z'", SymbolType.NONTERMINAL);
        NonTerminalSymbol Z = new NonTerminalSymbol("Z", SymbolType.NONTERMINAL);
        // 终结符a,c,d
        TerminalSymbol a = new TerminalSymbol("a", SymbolType.TERMINAL);
        TerminalSymbol c = new TerminalSymbol("c", SymbolType.TERMINAL);
        TerminalSymbol d = new TerminalSymbol("d", SymbolType.TERMINAL);

        // !!!为了FOLLOW集
        start = Z_dot;
        nonTerSyms = new ArrayList<>(Arrays.asList(Z_dot, Z));
        terSyms = new ArrayList<>(Arrays.asList(a, c, d));


        // 产生式Z'->Z

        // 产生式Z->d

        // 产生式Z->cZa

        // 产生式Z->Za

        Z_dot.addProduction(new Production(Z_dot, new ArrayList<>(Arrays.asList(Z))));
        Z.addProduction(new Production(Z, new ArrayList<>(Arrays.asList(d))));
        Z.addProduction(new Production(Z, new ArrayList<>(Arrays.asList(c, Z, a))));
        Z.addProduction(new Production(Z, new ArrayList<>(Arrays.asList(Z, a))));
        

    }

    public Boolean isSLR1() {
        return GeneratorLR.isSLR1();
    }
}
