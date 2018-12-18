
import Foundation

func printAnswerForGrid(_ grid: [[Character]]) {
    var treeCount = 0
    var lumberyardCount = 0
    for y in 0..<grid.count {
        for x in 0..<grid.first!.count {
            if grid[y][x] == "|" {
                treeCount += 1
            }
            if grid[y][x] == "#" {
                lumberyardCount += 1
            }
        }
    }

    print(lumberyardCount * treeCount)
}

public func day18(minutes: Int) {
    var grid = input.split(separator: "\n").map { Array(String($0)) }
    var previousGrids: [[[Character]]] = [grid]
    let height = grid.count
    let width = grid.first!.count
    for currentMinute in 1...minutes {
        var nextGrid: [[Character]] = Array<Array<Character>>(repeating: Array<Character>(repeating: " ", count: width), count: height)
        for y in 0..<height {
            for x in 0..<width {

                // Count surrounding including current position
                var lumberyardCount = 0
                var treeCount = 0
                var groundCount = 0
                for y2 in y-1...y+1 {
                    for x2 in x-1...x+1 {
                        guard x2 >= 0 && x2 < width && y2 >= 0 && y2 < height else {
                            continue
                        }
                        switch grid[y2][x2] {
                        case ".":
                            groundCount += 1
                        case "#":
                            lumberyardCount += 1
                        case "|":
                            treeCount += 1
                        default:
                            break
                        }
                    }
                }

                // Update resulting grid for current position
                nextGrid[y][x] = grid[y][x]
                switch grid[y][x] {
                case ".":
                    if treeCount >= 3 {
                        nextGrid[y][x] = "|"
                    }
                case "#":
                    if lumberyardCount <= 1 || treeCount < 1 {
                        nextGrid[y][x] = "."
                    }
                case "|":
                    if lumberyardCount >= 3 {
                        nextGrid[y][x] = "#"
                    }
                default:
                    nextGrid[y][x] = grid[y][x]
                }
            }
        }

        grid = nextGrid

        if currentMinute == minutes {
            printAnswerForGrid(grid)
            return
        }
        else if let previousIndex = previousGrids.firstIndex(of: grid) {
            let diff = currentMinute - previousIndex
            let offset = (minutes - previousIndex) % diff
            printAnswerForGrid(previousGrids[previousIndex+offset])
            return
        }
        else {
            previousGrids += [grid]
        }
    }
}
