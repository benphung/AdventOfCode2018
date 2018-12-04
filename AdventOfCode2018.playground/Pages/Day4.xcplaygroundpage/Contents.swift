/*
 --- Day 4: Repose Record ---

 You've sneaked into another supply closet - this time, it's across from the prototype suit manufacturing lab. You need to sneak inside and fix the issues with the suit, but there's a guard stationed outside the lab, so this is as close as you can safely get.

 As you search the closet for anything that might help, you discover that you're not the first person to want to sneak in. Covering the walls, someone has spent an hour starting every midnight for the past few months secretly observing this guard post! They've been writing down the ID of the one guard on duty that night - the Elves seem to have decided that one guard was enough for the overnight shift - as well as when they fall asleep or wake up while at their post (your puzzle input).

 For example, consider the following records, which have already been organized into chronological order:

 [1518-11-01 00:00] Guard #10 begins shift
 [1518-11-01 00:05] falls asleep
 [1518-11-01 00:25] wakes up
 [1518-11-01 00:30] falls asleep
 [1518-11-01 00:55] wakes up
 [1518-11-01 23:58] Guard #99 begins shift
 [1518-11-02 00:40] falls asleep
 [1518-11-02 00:50] wakes up
 [1518-11-03 00:05] Guard #10 begins shift
 [1518-11-03 00:24] falls asleep
 [1518-11-03 00:29] wakes up
 [1518-11-04 00:02] Guard #99 begins shift
 [1518-11-04 00:36] falls asleep
 [1518-11-04 00:46] wakes up
 [1518-11-05 00:03] Guard #99 begins shift
 [1518-11-05 00:45] falls asleep
 [1518-11-05 00:55] wakes up

 Timestamps are written using year-month-day hour:minute format. The guard falling asleep or waking up is always the one whose shift most recently started. Because all asleep/awake times are during the midnight hour (00:00 - 00:59), only the minute portion (00 - 59) is relevant for those events.

 Visually, these records show that the guards are asleep at these times:

 Date   ID   Minute
             000000000011111111112222222222333333333344444444445555555555
             012345678901234567890123456789012345678901234567890123456789
 11-01  #10  .....####################.....#########################.....
 11-02  #99  ........................................##########..........
 11-03  #10  ........................#####...............................
 11-04  #99  ....................................##########..............
 11-05  #99  .............................................##########.....

 The columns are Date, which shows the month-day portion of the relevant day; ID, which shows the guard on duty that day; and Minute, which shows the minutes during which the guard was asleep within the midnight hour. (The Minute column's header shows the minute's ten's digit in the first row and the one's digit in the second row.) Awake is shown as ., and asleep is shown as #.

 Note that guards count as asleep on the minute they fall asleep, and they count as awake on the minute they wake up. For example, because Guard #10 wakes up at 00:25 on 1518-11-01, minute 25 is marked as awake.

 If you can figure out the guard most likely to be asleep at a specific time, you might be able to trick that guard into working tonight so you can have the best chance of sneaking in. You have two strategies for choosing the best guard/minute combination.

 Strategy 1: Find the guard that has the most minutes asleep. What minute does that guard spend asleep the most?

 In the example above, Guard #10 spent the most minutes asleep, a total of 50 minutes (20+25+5), while Guard #99 only slept for a total of 30 minutes (10+10+10). Guard #10 was asleep most during minute 24 (on two days, whereas any other minute the guard was asleep was only seen on one day).

 While this example listed the entries in chronological order, your entries are in the order you found them. You'll need to organize them before they can be analyzed.

 What is the ID of the guard you chose multiplied by the minute you chose? (In the above example, the answer would be 10 * 24 = 240.)
*/

import Foundation

struct SleepRecord {
    let guardId: Int
    let startMinute: Int
    let endMinute: Int
    let duration: Int

    init(guardId: Int, startMinute: Int, endMinute: Int) {
        self.guardId = guardId
        self.startMinute = startMinute
        self.endMinute = endMinute
        self.duration = endMinute - startMinute
    }
}

extension String {
    subscript(r: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: r.lowerBound)
        let end = index(startIndex, offsetBy: r.upperBound)
        return String(self[start..<end])
    }

    subscript(range: NSRange) -> String {
        return self[range.location..<range.location+range.length]
    }
}

func parseSleepRecords(from input: String) -> [SleepRecord] {
    let chronologicallySortedRecords = input.split(separator: "\n").map { String($0) }.sorted()

    var guardId: Int!
    var startMinute: Int!
    var endMinute: Int!

    let beginShiftPattern = "\\[(.*)\\] Guard #(\\d+).*"
    let beginShiftRegex = try! NSRegularExpression(pattern: beginShiftPattern)

    let fallsAsleepPattern = "\\[.*:(.*)\\] falls asleep"
    let fallsAsleepRegex = try! NSRegularExpression(pattern: fallsAsleepPattern)

    let wakesUpPattern = "\\[.*:(.*)\\] wakes up"
    let wakesUpRegex = try! NSRegularExpression(pattern: wakesUpPattern)

    var sleepRecords = [SleepRecord]()

    for record in chronologicallySortedRecords {
        let beginShiftResult = beginShiftRegex.matches(in: record, range: NSMakeRange(0, record.count))
        if !beginShiftResult.isEmpty {
            guardId = Int(record[beginShiftResult[0].range(at: 2)])!
            continue
        }

        let fallsAsleepResult = fallsAsleepRegex.matches(in: record, range: NSMakeRange(0, record.count))
        if !fallsAsleepResult.isEmpty {
            startMinute = Int(record[fallsAsleepResult[0].range(at: 1)])!
            continue
        }

        let wakesUpResult = wakesUpRegex.matches(in: record, range: NSMakeRange(0, record.count))
        if !wakesUpResult.isEmpty {
            endMinute = Int(record[wakesUpResult[0].range(at: 1)])!
            sleepRecords.append(SleepRecord(guardId: guardId, startMinute: startMinute, endMinute: endMinute))
        }
    }
    return sleepRecords
}

func findGuardThatSleptMost(in sleepRecords: [SleepRecord]) -> Int {
    var guardIdToDurations = [Int: Int]()
    for sleepRecord in sleepRecords {
        guardIdToDurations[sleepRecord.guardId] = (guardIdToDurations[sleepRecord.guardId]  ?? 0) + sleepRecord.duration
    }

    return guardIdToDurations.max { return $0.value < $1.value }!.key
}

func findMostFrequentlyAsleepMinute(records: [SleepRecord], guardId: Int) -> (Int, Int) {
    let minuteCounter = NSCountedSet()
    sleepRecords
        .filter { $0.guardId == guardId }
        .forEach {
            for i in $0.startMinute..<$0.endMinute {
                minuteCounter.add(i)
            }
        }

    let mostFrequentlyAsleepMinute = minuteCounter.allObjects.max { return minuteCounter.count(for: $0) < minuteCounter.count(for: $1) } as! Int
    let frequency = minuteCounter.count(for: mostFrequentlyAsleepMinute)
    return (mostFrequentlyAsleepMinute, frequency)
}

let sleepRecords = parseSleepRecords(from: input)
let guardIdThatSleptMost = findGuardThatSleptMost(in: sleepRecords)
let mostFrequentlyAsleepMinute = findMostFrequentlyAsleepMinute(records: sleepRecords, guardId: guardIdThatSleptMost).0
print(guardIdThatSleptMost * mostFrequentlyAsleepMinute) // 109659


/*
 --- Part Two ---

 Strategy 2: Of all guards, which guard is most frequently asleep on the same minute?

 In the example above, Guard #99 spent minute 45 asleep more than any other guard or minute - three times in total. (In all other cases, any guard spent any minute asleep at most twice.)

 What is the ID of the guard you chose multiplied by the minute you chose? (In the above example, the answer would be 99 * 45 = 4455.)

 */

var guardIdToMinuteCountedSet = [Int: NSCountedSet]()
sleepRecords
    .forEach {
        let minuteCountedSet = guardIdToMinuteCountedSet[$0.guardId] ?? NSCountedSet()
        for i in $0.startMinute..<$0.endMinute {
            minuteCountedSet.add(i)
        }
        guardIdToMinuteCountedSet[$0.guardId] = minuteCountedSet
    }
let result = guardIdToMinuteCountedSet
    .mapValues { minuteCountedSet -> (Int, Int) in
        let mostFrequentlyAsleepMinute = minuteCountedSet.allObjects.max { return minuteCountedSet.count(for: $0) < minuteCountedSet.count(for: $1) } as! Int
        let frequency = minuteCountedSet.count(for: mostFrequentlyAsleepMinute)
        return (mostFrequentlyAsleepMinute, frequency)
    }
    .max { return $0.value.1 < $1.value.1 }!
let guardMostFrequentlyAsleepOnSameMinute = result.key
let minute = result.value.0
print(guardMostFrequentlyAsleepOnSameMinute * minute) // 36371
