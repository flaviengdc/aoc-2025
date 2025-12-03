console.log(
  (await Bun.file("input.txt").text())
    .split("\n")
    .map((line) => line.split("").map(Number))
    .map((line) => {
      const firstDigitIndex = line.indexOf(Math.max(...line.slice(0, -1)));
      return Number(
        `${line[firstDigitIndex]}${Math.max(
          ...line.slice(firstDigitIndex + 1)
        )}`
      );
    })
    .reduce((a, b) => a + b, 0)
);
