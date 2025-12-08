type Coord3D = {
  x: number;
  y: number;
  z: number;
};

type Cable = {
  from: Coord3D;
  to: Coord3D;
  length: number;
};

const input: Coord3D[] = (await Bun.file("input.txt").text())
  .split("\n")
  .map((line) => line.split(","))
  .map((line) => ({
    x: Number(line[0]),
    y: Number(line[1]),
    z: Number(line[2]),
  }));

function get3DDistance(a: Coord3D, b: Coord3D) {
  return Math.sqrt(
    Math.pow(a.x - b.x, 2) + Math.pow(a.y - b.y, 2) + Math.pow(a.z - b.z, 2)
  );
}

function getId(coord: Coord3D) {
  return `x:${coord.x},y:${coord.y},z:${coord.z}`;
}

function sortCable(a: Cable, b: Cable) {
  return a.length - b.length;
}

const distances = input.reduce((acc, cur, index, originalArray) => {
  const arrayToIterate = originalArray.slice(index + 1);
  const wipSet = arrayToIterate.reduce((acc2, cur2) => {
    acc2 = [
      ...acc2,
      {
        from: cur,
        to: cur2,
        length: get3DDistance(cur, cur2),
      },
    ];
    return acc2;
  }, [] as Cable[]);

  return [...acc, ...wipSet];
}, [] as Cable[]);

distances.sort(sortCable);

const circuits: Set<string>[] = [];
let lastDistanceChecked = undefined;

while ((circuits[0]?.size ?? 0) < input.length) {
  const shortestCable = distances.shift();
  lastDistanceChecked = shortestCable;

  const impactedCircuits = circuits.filter(
    (circuit) =>
      circuit.has(getId(shortestCable.from)) ||
      circuit.has(getId(shortestCable.to))
  );

  // Both junction boxes are not in any circuit, create a new circuit
  if (impactedCircuits.length === 0) {
    const newCircuit = new Set<string>();
    newCircuit.add(getId(shortestCable.from));
    newCircuit.add(getId(shortestCable.to));
    circuits.push(newCircuit);

    continue;
  }

  if (impactedCircuits.length === 1) {
    const impactedCircuit = impactedCircuits[0];

    // Both junction boxes are in the same circuit, do nothing
    // Actually do use a cable for nothing...
    if (
      impactedCircuit.has(getId(shortestCable.from)) &&
      impactedCircuit.has(getId(shortestCable.to))
    ) {
      continue;
    }
    // One junction box is in a circuit, the other is not
    else {
      impactedCircuit.add(getId(shortestCable.from));
      impactedCircuit.add(getId(shortestCable.to));
      continue;
    }
  }

  if (impactedCircuits.length === 2) {
    const impactedCircuit1 = impactedCircuits[0];
    const impactedCircuit2 = impactedCircuits[1];

    // Remove both circuits from the array
    circuits.splice(circuits.indexOf(impactedCircuit1), 1);
    circuits.splice(circuits.indexOf(impactedCircuit2), 1);

    // Add the merged circuit
    circuits.push(impactedCircuit1.union(impactedCircuit2));

    continue;
  }
}

const { from, to } = lastDistanceChecked;
console.log(from.x * to.x);
