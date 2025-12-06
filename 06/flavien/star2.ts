const input = (await Bun.file("input.txt").text()).split("\n").map(el => el.split(""))

function operation(char: "+" | "*") {
    switch (char) {
        case "+": return (a: number, b: number) => a + b
        case "*": return (a: number, b: number) => a * b
        default: throw new Error("Impossiblu")
    }
}

const rotatedInput = []

for (let col = 0; col < input[0].length; col++) {
    const newRow = []
    for (let row = 0; row < input.length; row++) {
        newRow.push(input[row][col])
    }
    rotatedInput.push(newRow)
}

console.log(
    rotatedInput.map(e => e.join(""))
        .map(col => col.trim().length === 0 ? "\n" : col)
        .join("")
        .split("\n")
        .reduce((acc, cur) => {
            const operationSymbol = cur.includes("*") ? "*" : "+"
            const numbers = cur.replace(operationSymbol, " ").split(" ").filter(e => e).map(Number)

            return acc + numbers.reduce((accNumber, curNumber) => {
                return accNumber === undefined ? curNumber : operation(operationSymbol)(accNumber, curNumber)
            }, undefined)
        }, 0)
)
