// @flow strict

import fs from "node:fs/promises";

opaque type Mat2d = Array<Array<string>>;

async function getGrid(): Promise<Mat2d> {
  const contents = await fs
    .readFile("./example.txt")
    .then((buf) => buf.toString());

  const grid = contents
    .split(/\n|\r|\r\n/)
    .filter(Boolean)
    .map((row) => row.split(""));

  return grid;
}

function countMovableRolls(grid: Mat2d): number {
  let result = 0;

  for (const [i, row] of grid.entries()) {
    for (const [j, cell] of row.entries()) {
      if (cell === ".") continue;

      const neighbors = [
        grid[i - 1]?.[j - 1],
        grid[i - 1]?.[j],
        grid[i - 1]?.[j + 1],

        grid[i][j - 1],
        grid[i][j + 1],

        grid[i + 1]?.[j - 1],
        grid[i + 1]?.[j],
        grid[i + 1]?.[j + 1],
      ].filter(Boolean);

      const count = neighbors.filter((neighbor) => neighbor !== ".").length;

      if (count < 4) {
        grid[i][j] = "x";
        result++;
      }
    }
  }

  return result;
}

void main();

async function main() {
  const grid = await getGrid();
  const result = countMovableRolls(grid);
  console.log(result);
}
