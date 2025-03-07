package Lab1.test

import Lab1.*

func testCharSetTable_append(): Unit {
    println(charSetTable.add(ArrayList<(Rune, Rune)>([(r'a', r'z'), (r'A', r'Z')])))

    
}
func testCharSetTable_range(): Unit {
    println(charSetTable.range(r'a', r'z'))
    println(charSetTable.range(r'e', r'e'))

}

func testCharSetTable_union_c(): Unit {

    println(charSetTable.union(r'a', r'z'))
    println(charSetTable.union(r'e', r'e'))
    
}

func testCharSetTable_union_c_charSetId(): Unit {
    println(charSetTable.range(r'a', r'z'))
    println(charSetTable.union(r'a', r'z'))

    println(charSetTable.union(0, r'a'))
    println(charSetTable.union(1, r'0'))
}

func testCharSetTable_union_charSetId_charSetId(): Unit {
    println(charSetTable.range(r'a', r'z'))
    println(charSetTable.union(r'a', r'z'))
    println(charSetTable.range(r'a', r'z'))
    println(charSetTable.union(r'A', r'Z'))

    println(charSetTable.union(0, 1))
    println(charSetTable.union(0, 3))
}

func testCharSetTable_difference(): Unit {
    println(charSetTable.add(ArrayList<(Rune, Rune)>([(r'a', r'a')])))
    println(charSetTable.add(ArrayList<(Rune, Rune)>([(r'a', r'z')])))
    println(charSetTable.add(ArrayList<(Rune, Rune)>([(r'a', r'z')])))
    println(charSetTable.add(ArrayList<(Rune, Rune)>([(r'a', r'z')])))
    println(charSetTable.add(ArrayList<(Rune, Rune)>([(r'a', r'z')])))


    println(charSetTable.difference(0, r'a'))
    println(charSetTable.difference(1, r'a'))
    println(charSetTable.difference(2, r'z'))
    println(charSetTable.difference(3, r'f'))
    println(charSetTable.difference(4, r'0'))

}