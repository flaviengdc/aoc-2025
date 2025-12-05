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

console.log((await Bun.file("input.txt").text())
    .split("\n").map(line=>line.split(""))
    .reduce((acc, row, y, originalMap) => acc + row.reduce((acc2, char, x) => acc2 + (char === '@' && countRollsAround({x, y}, originalMap) < 4 ? 1 : 0), 0), 0)
)