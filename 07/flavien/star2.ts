const input: (string | number)[][] = (await Bun.file("input.txt").text())
  .split("\n")
  .map((line) => line.split(""));

function getChar({ x, y }: { x: number; y: number }) {
  return input?.[y]?.[x];
}

function setChar({ x, y }: { x: number; y: number }, char: string | number) {
  if (input?.[y]?.[x]) input[y][x] = char;
}

function canSplitBeam({ x, y }: { x: number; y: number }) {
  return (
    getChar({ x, y }) === "^" && typeof getChar({ x, y: y - 1 }) === "number"
  );
}

function progressBeam({ x, y }: { x: number; y: number }) {
  return (
    getChar({ x, y }) !== "^" && typeof getChar({ x, y: y - 1 }) === "number"
  );
}

function addToNumber(char1: string | number, char2: string | number) {
  if (char1 === ".") return char2;
  if (typeof char1 === "number") return (char1 as number) + (char2 as number);
}

const initialCursor = {
  x: input[0].indexOf("S"),
  y: 0,
};

setChar(initialCursor, 1);

input.reduce((acc, line, y) => {
  return (
    acc +
    line.reduce<number>((acc2, char, x) => {
      const currentCharCoords = { x, y };
      const leftCharCoords = { x: x - 1, y };
      const rightCharCoords = { x: x + 1, y };

      const leftChar = getChar(leftCharCoords);
      const rightChar = getChar(rightCharCoords);
      const aboveChar = getChar({ x, y: y - 1 });

      const setLeftChar = (char: string | number) =>
        setChar(leftCharCoords, char);
      const setRightChar = (char: string | number) =>
        setChar(rightCharCoords, char);

      if (canSplitBeam(currentCharCoords)) {
        setLeftChar(addToNumber(leftChar, aboveChar));
        setRightChar(addToNumber(rightChar, aboveChar));
      }
      if (progressBeam(currentCharCoords))
        setChar(currentCharCoords, addToNumber(char, aboveChar));

      return acc2;
    }, 0)
  );
}, 1);

console.log(
  input.at(-1).reduce<number>((acc, char) => {
    return acc + (typeof char === "number" ? char : 0);
  }, 0)
);
