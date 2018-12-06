/*
 --- Day 6: Chronal Coordinates ---

 The device on your wrist beeps several times, and once again you feel like you're falling.

 "Situation critical," the device announces. "Destination indeterminate. Chronal interference detected. Please specify new target coordinates."

 The device then produces a list of coordinates (your puzzle input). Are they places it thinks are safe or dangerous? It recommends you check manual page 729. The Elves did not give you a manual.

 If they're dangerous, maybe you can minimize the danger by finding the coordinate that gives the largest distance from the other points.

 Using only the Manhattan distance, determine the area around each coordinate by counting the number of integer X,Y locations that are closest to that coordinate (and aren't tied in distance to any other coordinate).

 Your goal is to find the size of the largest area that isn't infinite. For example, consider the following list of coordinates:

 1, 1
 1, 6
 8, 3
 3, 4
 5, 5
 8, 9

 If we name these coordinates A through F, we can draw them on a grid, putting 0,0 at the top left:

 ..........
 .A........
 ..........
 ........C.
 ...D......
 .....E....
 .B........
 ..........
 ..........
 ........F.

 This view is partial - the actual grid extends infinitely in all directions. Using the Manhattan distance, each location's closest coordinate can be determined, shown here in lowercase:

 aaaaa.cccc
 aAaaa.cccc
 aaaddecccc
 aadddeccCc
 ..dDdeeccc
 bb.deEeecc
 bBb.eeee..
 bbb.eeefff
 bbb.eeffff
 bbb.ffffFf

 Locations shown as . are equally far from two or more coordinates, and so they don't count as being closest to any.

 In this example, the areas of coordinates A, B, C, and F are infinite - while not shown here, their areas extend forever outside the visible grid. However, the areas of coordinates D and E are finite: D is closest to 9 locations, and E is closest to 17 (both including the coordinate's location itself). Therefore, in this example, the size of the largest area is 17.

 What is the size of the largest area that isn't infinite?

 */
import Foundation

struct Point {
    let x: Int
    let y: Int
    let id: Int
}

func parsePoints(_ input: String) -> [Point] {
    var points = [Point]()
    let pointStrings = input.split(separator: "\n").map { String($0) }
    var id = 0
    for pointString in pointStrings {
        let scanner = Scanner(string: pointString)
        var x = 0
        var y = 0
        scanner.scanInt(&x)
        scanner.scanUpTo(" ", into: nil)
        scanner.scanInt(&y)
        points.append(Point(x: x, y: y, id: id))
        id += 1
    }
    return points
}

func pointsClosestTo(x: Int, y: Int, points: [Point]) -> [Point] {
    var minDistance = Int.max
    var closestPoints = [Point]()
    for point in points {
        let distance = abs(point.x - x) + abs(point.y - y)
        if distance < minDistance {
            minDistance = distance
            closestPoints = [point]
        }
        else if distance == minDistance {
            closestPoints += [point]
        }
    }

    return closestPoints
}

func part1(points: [Point]) -> Int {
    let minX = points.map { $0.x }.min()!
    let minY = points.map { $0.y }.min()!
    let maxX = points.map { $0.x }.max()!
    let maxY = points.map { $0.y }.max()!

    var infiniteAreaPoints = Set<Int>()
    var pointIdToCount = [Int: Int]()
    for y in minY...maxY {
        for x in minX...maxX {
            let points = pointsClosestTo(x: x, y: y, points: points)

            if points.count == 1 {
                let pointId = points.first!.id
                if x == minX || y == minY || x == maxX || y == maxY {
                    infiniteAreaPoints.insert(pointId)
                }
                else {
                    pointIdToCount[pointId] = (pointIdToCount[pointId] ?? 0) + 1
                }
            }
        }
    }

    return pointIdToCount
        .filter { !infiniteAreaPoints.contains($0.key) }
        .max { $0.value < $1.value }!
        .value
}

let points = parsePoints(input)
print(part1(points: points)) // 3871


/*
 --- Part Two ---

 On the other hand, if the coordinates are safe, maybe the best you can do is try to find a region near as many coordinates as possible.

 For example, suppose you want the sum of the Manhattan distance to all of the coordinates to be less than 32. For each location, add up the distances to all of the given coordinates; if the total of those distances is less than 32, that location is within the desired region. Using the same coordinates as above, the resulting region looks like this:

 ..........
 .A........
 ..........
 ...###..C.
 ..#D###...
 ..###E#...
 .B.###....
 ..........
 ..........
 ........F.

 In particular, consider the highlighted location 4,3 located at the top middle of the region. Its calculation is as follows, where abs() is the absolute value function:

 Distance to coordinate A: abs(4-1) + abs(3-1) =  5
 Distance to coordinate B: abs(4-1) + abs(3-6) =  6
 Distance to coordinate C: abs(4-8) + abs(3-3) =  4
 Distance to coordinate D: abs(4-3) + abs(3-4) =  2
 Distance to coordinate E: abs(4-5) + abs(3-5) =  3
 Distance to coordinate F: abs(4-8) + abs(3-9) = 10
 Total distance: 5 + 6 + 4 + 2 + 3 + 10 = 30

 Because the total distance to all coordinates (30) is less than 32, the location is within the region.

 This region, which also includes coordinates D and E, has a total size of 16.

 Your actual region will need to be much larger than this example, though, instead including all locations with a total distance of less than 10000.

 What is the size of the region containing all locations which have a total distance to all given coordinates of less than 10000?

 */

func part2(points: [Point]) -> Int {
    let minX = points.map { $0.x }.min()!
    let minY = points.map { $0.y }.min()!
    let maxX = points.map { $0.x }.max()!
    let maxY = points.map { $0.y }.max()!

    var count = 0
    for y in minY...maxY {
        for x in minX...maxX {
            let totalDistance = points
                .map { abs($0.x - x) + abs($0.y - y) }
                .reduce(0, +)

            if totalDistance < 10000 {
                count += 1
            }
        }
    }
    return count
}
print(part2(points: points)) // 44667
