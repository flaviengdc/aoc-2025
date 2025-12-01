BEGIN {pos = 50; code = 0}

END {print code}

/L[0-9]+/ {line(-1)}
/R[0-9]+/ {line(1)}

function line(step) {
  gsub(/[^0-9]/, "");
  div = mod(pos, $0 * step, 100);
  if (pos == 0) code -= 1
  pos = div
}

function mod(pos, distance, max) {
  if (pos == 0) code += 1;

  if (distance == 0) return pos;

  if (distance > 0) {
    if ((pos+1) >= max) pos = -1;
    return mod(pos + 1, distance - 1, max);
  }

  if (pos == 0) pos = max;
  return mod(pos - 1, distance + 1, max);
}
