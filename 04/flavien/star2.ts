function isARoll({x, y}, originalMap) {
  return originalMap?.[y]?.[x] === '@'
}

function countRollsAround({x,y}, originalMap) {
  return [
    {x: x-1, y: y-1},
    {x: x+1, y: y-1},
    {x: x-1, y: y+1},
    {x: x+1, y: y+1},
    {x: x, y: y-1},
    {x: x, y: y+1},
    {x: x-1, y: y},
    {x: x+1, y: y},
  ].reduce((acc, {x, y}) => acc + (isARoll({x, y}, originalMap) ? 1 : 0), 0)
}

function makeCopy(array: any[][]) {
    return array.map(row => [...row])
}

let parsedInput = (await Bun.file("input.txt").text())
    .split("\n").map(line=>line.split(""))
let parsedInputCopy
let removedTotal = 0
let removedNow = undefined

while(removedNow !== 0) {
    removedNow = 0
    parsedInputCopy = makeCopy(parsedInput)
    parsedInput.forEach((row, y) => {
      row.forEach((char, x) => {
        if (char === '@' && countRollsAround({x, y}, parsedInput) < 4) {
          parsedInputCopy[y][x] = '.'
          removedTotal++
          removedNow = removedNow ? removedNow + 1 : 1
        }
      })
    })

    parsedInput = makeCopy(parsedInputCopy)
}

console.log(removedTotal)

