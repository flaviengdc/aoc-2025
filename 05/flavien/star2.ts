type Range = {min: number, max: number}

function overlap(range1: Range, range2: Range) {
    return !(range1.min > range2.max||range2.min > range1.max)
}

function mergeRanges(range1: Range, range2: Range): Range {
    return {
        min: Math.min(range1.min, range2.min),
        max: Math.max(range1.max, range2.max)
    }
}

const ranges = (await Bun.file("input.txt").text()).split("\n\n")[0].split("\n")

const initialStack: Array<Range> = ranges.map(range => {
    const [min, max] = range.split("-").map(Number)
    return {min, max}
})
const mergedStack: Array<Range> = []

while(initialStack.length) {
    const rangeToAdd = initialStack.pop()
    const candidateIndex = mergedStack.findIndex(rangeCandidate => overlap(rangeCandidate, rangeToAdd))
    candidateIndex === -1
        ? mergedStack.push(rangeToAdd)
        : initialStack.push(mergeRanges(rangeToAdd, mergedStack.splice(candidateIndex, 1)[0]))
}

console.log(mergedStack.reduce((acc, cur) => acc + cur.max - cur.min + 1, 0))