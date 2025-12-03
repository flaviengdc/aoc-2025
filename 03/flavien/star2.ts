function recursivelyFindHighestJoltage(
  line: number[],
  voltageSize: number,
  highestJoltage: number
) {
  if (voltageSize === 1) return Number(`${highestJoltage}${Math.max(...line)}`);

  const currentDigitLine = line.slice(0, -1 * (voltageSize - 1));
  const highestDigitIndex = currentDigitLine.findIndex(
    (d) => d === Math.max(...currentDigitLine)
  );
  const highestDigit = currentDigitLine[highestDigitIndex];
  const newHighestJoltage = Number(`${highestJoltage}${highestDigit}`);

  return recursivelyFindHighestJoltage(
    line.slice(highestDigitIndex + 1),
    voltageSize - 1,
    newHighestJoltage
  );
}

console.log(
  (await Bun.file("input.txt").text())
    .split("\n")
    .map((line) => line.split("").map(Number))
    .map((line) => recursivelyFindHighestJoltage(line, 12, 0))
    .reduce((a, b) => a + b, 0)
);
