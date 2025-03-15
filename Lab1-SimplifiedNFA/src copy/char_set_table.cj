package Lab1

import std.collection.*

public class CharSetTable {
    static var indexId = -1
    private var pCharSetTable: ArrayList<CharSet> = ArrayList<CharSet>([])

    public func add(charSets: ArrayList<(Rune, Rune)>): Int64 {
        let indexId = getNewIndexId()

        for (i in 0..charSets.size) {
            let segmentId = i
            pCharSetTable.append(CharSet(indexId, segmentId, charSets[i][0], charSets[i][1]))
        }
        print()
        return indexId
    }

    private func find(charSetId: Int64): ArrayList<(Rune, Rune)> {
        var res = ArrayList<(Rune, Rune)>([])

        for (cs in pCharSetTable) {
            if (cs.indexId == charSetId) {
                res.append((cs.fromChar, cs.toChar))
            }
        }
        return res
    }

    private func getNewIndexId(): Int64 {
        indexId += 1
        return indexId
    }

    public func print(): Unit {
        println("==========================================")

        for (cs in pCharSetTable) {
            println("IndexId: ${cs.indexId} SegmentId: ${cs.segmentId} FromChar: ${cs.fromChar} ToChar: ${cs.toChar}")
        }
    }

    public func range(fromChar: Rune, toChar: Rune): Int64 {
        return add(ArrayList([(fromChar, toChar)]))
    }

    public func union(c1: Rune, c2: Rune): Int64 {
        var newCharSets = ArrayList<(Rune, Rune)>([(c1, c1)])
        if (c1 != c2) {
            newCharSets.append((c2, c2))
        }
        return add(newCharSets)
    }

    public func union(charSetId: Int64, c: Rune): Int64 {
        let charSets = find(charSetId)
        var newCharSets = ArrayList<(Rune, Rune)>(charSets)
        var cInCharSets = false
        for (cs in charSets) {
            if (c >= cs[0] && c <= cs[1]) {
                cInCharSets = true
            }
        }

        if (!cInCharSets) {
            newCharSets.append((c, c))
        }
        return add(newCharSets)
    }

    // TODO
    // 现在实现的是直接把两个字符集合并，但是有些字符集之间可能有重叠，需要处理一下

    public func union(charSetId1: Int64, charSetId2: Int64): Int64 {
        let charSets1 = find(charSetId1)
        let charSets2 = find(charSetId2)
        var newCharSets = ArrayList<(Rune, Rune)>(charSets1)
        newCharSets.appendAll(charSets2)

        return add(newCharSets)
    }

    public func difference(charSetId: Int64, c: Rune): Int64 {
        let charSets = find(charSetId)
        var newCharSets = ArrayList<(Rune, Rune)>(charSets)
        for (index in 0..charSets.size) {
            if (c < charSets[index][0] || c > charSets[index][1]) {
                continue
            }
            let left = charSets[index][0]
            let right = charSets[index][1]

            let len = UInt32(right) - UInt32(left) + 1
            match (len) {
                // TODO
                // 空字符集怎么表示，如果要表示的话append也要改,这里如果是空字符，在表中没有数据，charSetId会跳过
                case 1 => newCharSets.remove(index)
                case _ where c == left => newCharSets[index] = (Rune(UInt32(left) + 1), right)
                case _ where c == right => newCharSets[index] = (left, Rune(UInt32(right) - 1))
                case _ =>
                    newCharSets[index] = (left, Rune(UInt32(c) - 1))
                    newCharSets.append((Rune(UInt32(c) + 1), right))
            }

            break
        }
        return add(newCharSets)
    }
    
}
