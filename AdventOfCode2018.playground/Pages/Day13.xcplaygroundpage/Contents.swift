/*
 --- Day 13: Mine Cart Madness ---

 A crop of this size requires significant logistics to transport produce, soil, fertilizer, and so on. The Elves are very busy pushing things around in carts on some kind of rudimentary system of tracks they've come up with.

 Seeing as how cart-and-track systems don't appear in recorded history for another 1000 years, the Elves seem to be making this up as they go along. They haven't even figured out how to avoid collisions yet.

 You map out the tracks (your puzzle input) and see where you can help.

 Tracks consist of straight paths (| and -), curves (/ and \), and intersections (+). Curves connect exactly two perpendicular pieces of track; for example, this is a closed loop:

 /----\
 |    |
 |    |
 \----/

 Intersections occur when two perpendicular paths cross. At an intersection, a cart is capable of turning left, turning right, or continuing straight. Here are two loops connected by two intersections:

 /-----\
 |     |
 |  /--+--\
 |  |  |  |
 \--+--/  |
 |     |
 \-----/

 Several carts are also on the tracks. Carts always face either up (^), down (v), left (<), or right (>). (On your initial map, the track under each cart is a straight path matching the direction the cart is facing.)

 Each time a cart has the option to turn (by arriving at any intersection), it turns left the first time, goes straight the second time, turns right the third time, and then repeats those directions starting again with left the fourth time, straight the fifth time, and so on. This process is independent of the particular intersection at which the cart has arrived - that is, the cart has no per-intersection memory.

 Carts all move at the same speed; they take turns moving a single step at a time. They do this based on their current location: carts on the top row move first (acting from left to right), then carts on the second row move (again from left to right), then carts on the third row, and so on. Once each cart has moved one step, the process repeats; each of these loops is called a tick.

 For example, suppose there are two carts on a straight track:

 |  |  |  |  |
 v  |  |  |  |
 |  v  v  |  |
 |  |  |  v  X
 |  |  ^  ^  |
 ^  ^  |  |  |
 |  |  |  |  |

 First, the top cart moves. It is facing down (v), so it moves down one square. Second, the bottom cart moves. It is facing up (^), so it moves up one square. Because all carts have moved, the first tick ends. Then, the process repeats, starting with the first cart. The first cart moves down, then the second cart moves up - right into the first cart, colliding with it! (The location of the crash is marked with an X.) This ends the second and last tick.

 Here is a longer example:

 /->-\
 |   |  /----\
 | /-+--+-\  |
 | | |  | v  |
 \-+-/  \-+--/
 \------/

 /-->\
 |   |  /----\
 | /-+--+-\  |
 | | |  | |  |
 \-+-/  \->--/
 \------/

 /---v
 |   |  /----\
 | /-+--+-\  |
 | | |  | |  |
 \-+-/  \-+>-/
 \------/

 /---\
 |   v  /----\
 | /-+--+-\  |
 | | |  | |  |
 \-+-/  \-+->/
 \------/

 /---\
 |   |  /----\
 | /->--+-\  |
 | | |  | |  |
 \-+-/  \-+--^
 \------/

 /---\
 |   |  /----\
 | /-+>-+-\  |
 | | |  | |  ^
 \-+-/  \-+--/
 \------/

 /---\
 |   |  /----\
 | /-+->+-\  ^
 | | |  | |  |
 \-+-/  \-+--/
 \------/

 /---\
 |   |  /----<
 | /-+-->-\  |
 | | |  | |  |
 \-+-/  \-+--/
 \------/

 /---\
 |   |  /---<\
 | /-+--+>\  |
 | | |  | |  |
 \-+-/  \-+--/
 \------/

 /---\
 |   |  /--<-\
 | /-+--+-v  |
 | | |  | |  |
 \-+-/  \-+--/
 \------/

 /---\
 |   |  /-<--\
 | /-+--+-\  |
 | | |  | v  |
 \-+-/  \-+--/
 \------/

 /---\
 |   |  /<---\
 | /-+--+-\  |
 | | |  | |  |
 \-+-/  \-<--/
 \------/

 /---\
 |   |  v----\
 | /-+--+-\  |
 | | |  | |  |
 \-+-/  \<+--/
 \------/

 /---\
 |   |  /----\
 | /-+--v-\  |
 | | |  | |  |
 \-+-/  ^-+--/
 \------/

 /---\
 |   |  /----\
 | /-+--+-\  |
 | | |  X |  |
 \-+-/  \-+--/
 \------/

 After following their respective paths for a while, the carts eventually crash. To help prevent crashes, you'd like to know the location of the first crash. Locations are given in X,Y coordinates, where the furthest left column is X=0 and the furthest top row is Y=0:

 111
 0123456789012
 0/---\
 1|   |  /----\
 2| /-+--+-\  |
 3| | |  X |  |
 4\-+-/  \-+--/
 5  \------/

 In this example, the location of the first crash is 7,3.

 --- Part Two ---

 There isn't much you can do to prevent crashes in this ridiculous system. However, by predicting the crashes, the Elves know where to be in advance and instantly remove the two crashing carts the moment any crash occurs.

 They can proceed like this for a while, but eventually, they're going to run out of carts. It could be useful to figure out where the last cart that hasn't crashed will end up.

 For example:

 />-<\
 |   |
 | /<+-\
 | | | v
 \>+</ |
 |   ^
 \<->/

 /---\
 |   |
 | v-+-\
 | | | |
 \-+-/ |
 |   |
 ^---^

 /---\
 |   |
 | /-+-\
 | v | |
 \-+-/ |
 ^   ^
 \---/

 /---\
 |   |
 | /-+-\
 | | | |
 \-+-/ ^
 |   |
 \---/

 After four very expensive crashes, a tick ends with only one cart remaining; its final location is 6,4.

 What is the location of the last cart at the end of the first tick where it is the only cart left?

 */

enum Turn {
    case left, straight, right
}

enum Direction {
    case up, down, left, right
}

class Cart {
    var x: Int
    var y: Int
    var direction: Direction
    var lastTakenTurnAtIntersection: Turn?
    var crashed = false

    init(x: Int, y: Int, direction: Direction) {
        self.x = x
        self.y = y
        self.direction = direction
    }
}

func directionForCharacter(_ character: Character, cart: Cart) -> Direction {
    switch character {
    case "-", ">", "<":
        return cart.direction
    case "|", "v", "^":
        return cart.direction
    case "\\":
        switch cart.direction {
        case .left:
            return .up
        case .right:
            return .down
        case .up:
            return .left
        case .down:
            return .right
        }
    case "/":
        switch cart.direction {
        case .left:
            return .down
        case .right:
            return .up
        case .up:
            return .right
        case .down:
            return .left
        }
    case "+":
        return nextDirectionAtIntersectionForCart(cart)
    default:
        fatalError()
    }
}

func nextDirectionAtIntersectionForCart(_ cart: Cart) -> Direction {
    let nextTurn = nextTurnForCart(cart)

    switch cart.direction {
    case .up:
        switch nextTurn {
        case .left:
            return .left
        case .right:
            return .right
        case .straight:
            return .up
        }
    case .down:
        switch nextTurn {
        case .left:
            return .right
        case .right:
            return .left
        case .straight:
            return .down
        }
    case .left:
        switch nextTurn {
        case .left:
            return .down
        case .right:
            return .up
        case .straight:
            return .left
        }
    case .right:
        switch nextTurn {
        case .left:
            return .up
        case .right:
            return .down
        case .straight:
            return .right
        }
    }
}

func nextTurnForCart(_ cart: Cart) -> Turn {
    let nextTurn: Turn
    if let lastTakenTurnAtIntersection = cart.lastTakenTurnAtIntersection {
        switch lastTakenTurnAtIntersection {
        case .left:
            nextTurn = .straight
        case .right:
            nextTurn = .left
        case .straight:
            nextTurn = .right
        }
    }
    else {
        nextTurn = .left
    }
    return nextTurn
}

var lines = input.split(separator: "\n").map { String($0) }
var carts = [Cart]()

for y in 0..<lines.count {
    let line = lines[y]
    for x in 0..<line.count {
        switch line[x] {
        case ">":
            carts.append(Cart(x: x, y: y, direction: .right))
        case "^":
            carts.append(Cart(x: x, y: y, direction: .up))
        case "<":
            carts.append(Cart(x: x, y: y, direction: .left))
        case "v":
            carts.append(Cart(x: x, y: y, direction: .down))
        default:
            break
        }
    }
}

func day13(carts: [Cart]) {
    var carts = carts
    var hasCrashedBefore = false
    while true {
        for cart in carts {
            var nextX = cart.x
            var nextY = cart.y
            switch cart.direction {
            case .left:
                nextX -= 1
            case .right:
                nextX += 1
            case .up:
                nextY -= 1
            case .down:
                nextY += 1
            }

            let secondCrashedCart = carts
                .filter { $0 !== cart }
                .first { $0.x == nextX && $0.y == nextY}

            if let secondCrashedCart = secondCrashedCart {
                // Print for Part 1
                if !hasCrashedBefore {
                    print("\(nextX),\(nextY)")
                    hasCrashedBefore = true
                }

                cart.crashed = true
                secondCrashedCart.crashed = true
                continue
            }

            cart.x = nextX
            cart.y = nextY
            cart.direction = directionForCharacter(lines[nextY][nextX], cart: cart)
            if lines[nextY][nextX] == "+" {
                cart.lastTakenTurnAtIntersection = nextTurnForCart(cart)
            }
        }

        carts = carts
            .filter { !$0.crashed }
            .sorted(by: { (c1, c2) -> Bool in
                if c1.y == c2.y {
                    return c1.x < c2.x
                }
                return c1.y < c2.y
            })

        if carts.count == 1 {
            print("\(carts[0].x),\(carts[0].y)")
            return
        }
    }
}

// 113,136
// 114,136
day13(carts: carts)

