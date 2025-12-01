BEGIN {pos = 50; code = 0}

END {print code}

/L[0-9]+/ {gsub(/[^0-9]/, ""); pos = mod(pos - $0, 100)}
/R[0-9]+/ {gsub(/[^0-9]/, ""); pos = mod(pos + $0, 100)}

pos == 0 {code += 1}

function mod(n, max) {
  if (n < 0) {return mod(max + n, max)}
  if (n >= max) {return mod(n - max, max)}
  return n
}
