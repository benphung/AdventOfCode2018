/*
 --- Day 3: No Matter How You Slice It ---

 The Elves managed to locate the chimney-squeeze prototype fabric for Santa's suit (thanks to someone who helpfully wrote its box IDs on the wall of the warehouse in the middle of the night). Unfortunately, anomalies are still affecting them - nobody can even agree on how to cut the fabric.

 The whole piece of fabric they're working on is a very large square - at least 1000 inches on each side.

 Each Elf has made a claim about which area of fabric would be ideal for Santa's suit. All claims have an ID and consist of a single rectangle with edges parallel to the edges of the fabric. Each claim's rectangle is defined as follows:

 The number of inches between the left edge of the fabric and the left edge of the rectangle.
 The number of inches between the top edge of the fabric and the top edge of the rectangle.
 The width of the rectangle in inches.
 The height of the rectangle in inches.

 A claim like #123 @ 3,2: 5x4 means that claim ID 123 specifies a rectangle 3 inches from the left edge, 2 inches from the top edge, 5 inches wide, and 4 inches tall. Visually, it claims the square inches of fabric represented by # (and ignores the square inches of fabric represented by .) in the diagram below:

 ...........
 ...........
 ...#####...
 ...#####...
 ...#####...
 ...#####...
 ...........
 ...........
 ...........

 The problem is that many of the claims overlap, causing two or more claims to cover part of the same areas. For example, consider the following claims:

 #1 @ 1,3: 4x4
 #2 @ 3,1: 4x4
 #3 @ 5,5: 2x2

 Visually, these claim the following areas:

 ........
 ...2222.
 ...2222.
 .11XX22.
 .11XX22.
 .111133.
 .111133.
 ........

 The four square inches marked with X are claimed by both 1 and 2. (Claim 3, while adjacent to the others, does not overlap either of them.)

 If the Elves all proceed with their own plans, none of them will have enough fabric. How many square inches of fabric are within two or more claims?

 */

import Foundation

struct Claim {
    let id, x, y, width, height: Int
}

func claimsFromInput(_ input: String) -> [Claim] {
    let claimStrings = input.split(separator: "\n").map { String($0) }

    let pattern = "#(\\d+) @ (\\d+),(\\d+): (\\d+)x(\\d+)"
    let regex = try! NSRegularExpression(pattern: pattern)

    var claims = [Claim]()

    for claimString in claimStrings {
        let result = regex.matches(in: claimString, range:NSMakeRange(0, claimString.count))[0]

        let id = Int(claimString[result.range(at: 1)])!
        let x = Int(claimString[result.range(at: 2)])!
        let y = Int(claimString[result.range(at: 3)])!
        let width = Int(claimString[result.range(at: 4)])!
        let height = Int(claimString[result.range(at: 5)])!

        claims.append(Claim(id: id, x: x, y: y, width: width, height: height))
    }

    return claims
}

extension String {
    subscript(i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }

    subscript(r: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: r.lowerBound)
        let end = index(startIndex, offsetBy: r.upperBound)
        return String(self[start..<end])
    }

    subscript(range: NSRange) -> String {
        return self[range.location..<range.location+range.length]
    }
}


let claims = claimsFromInput(input)

let fabricWidth = 1000
let fabricHeight = 1000
var fabric = Array<Int>(repeating: 0, count: fabricWidth * fabricHeight)
markFabric()


func markFabric() {
    let claims = claimsFromInput(input)

    for claim in claims {
        for y in claim.y..<claim.y + claim.height {
            for x in claim.x..<claim.x + claim.width {
                let index = y * fabricWidth + x
                fabric[index] = fabric[index] + 1
            }
        }
    }
}

func overlapCount() -> Int {
    return fabric.filter { $0 > 1 }.count
}

print(overlapCount()) // 104241

/*
 --- Part Two ---

 Amidst the chaos, you notice that exactly one claim doesn't overlap by even a single square inch of fabric with any other claim. If you can somehow draw attention to it, maybe the Elves will be able to make Santa's suit after all!

 For example, in the claims above, only claim 3 is intact after all claims are made.

 What is the ID of the only claim that doesn't overlap?

 */

func findClaimWithoutOverlap() -> Claim? {
    return claims.first { claimHasOverlap($0, in: fabric) }
}

func claimHasOverlap(_ claim: Claim, in fabric: [Int]) -> Bool {
    for y in claim.y..<claim.y+claim.height {
        for x in claim.x..<claim.x+claim.width {
            let index = y * fabricWidth + x
            if fabric[index] > 1 {
                return false
            }
        }
    }
    return true
}

print(findClaimWithoutOverlap()!.id) // 806
