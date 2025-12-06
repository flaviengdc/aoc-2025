const input = (await Bun.file("input.txt").text()).split("\n").map(lines => {
    return lines.split(" ").filter(el => el)
})

const operations: Array<"*" | "+"> = input.at(-1)
const numbers: Array<number> = input.slice(0, -1).map(numbers => numbers.map(Number))

function operation(char: "+" | "*") {
    switch(char) {
        case "+": return (a: number, b: number) => a + b
        case "*": return (a: number, b: number) => a * b
        default: throw new Error("Impossiblu")
    }
}

console.log(operations.reduce((acc, cur, index) => {
    return acc + numbers.reduce((accNumbers, curNumbers) => {
        return accNumbers === undefined ? curNumbers[index] : operation(cur)(accNumbers, curNumbers[index])
    }, undefined)
}, 0))