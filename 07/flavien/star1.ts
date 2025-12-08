const input: string[][] = (await Bun.file("input.txt").text())
  .split("\n")
  .map((line) => line.split(""));

function getChar({ x, y }: { x: number; y: number }) {
  return input?.[y]?.[x];
}

function setChar({ x, y }: { x: number; y: number }, char: string) {
  if (input?.[y]?.[x]) input[y][x] = char;
}

function canSplitBeam({ x, y }: { x: number; y: number }) {
  return getChar({ x, y }) === "^" && getChar({ x, y: y - 1 }) === "|";
}

function progressBeam({ x, y }: { x: number; y: number }) {
  return getChar({ x, y }) === "." && getChar({ x, y: y - 1 }) === "|";
}

const initialCursor = {
  x: input[0].indexOf("S"),
  y: 0,
};

setChar(initialCursor, "|");

console.log(
  input.reduce((acc, line, y) => {
    return (
      acc +
      line.reduce((acc2, char, x) => {
        if (canSplitBeam({ x, y })) {
          setChar({ x: x - 1, y }, "|");
          setChar({ x: x + 1, y }, "|");
          return acc2 + 1;
        }
        if (progressBeam({ x, y })) {
          setChar({ x, y }, "|");
        }
        return acc2;
      }, 0)
    );
  }, 0)
);
