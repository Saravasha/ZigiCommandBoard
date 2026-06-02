export function layoutHexPerfect(items, cols, size) {
  const results = [];

  const width = size;
  const height = (Math.sqrt(3) * size) / 2;

  for (let i = 0; i < items.length; i++) {
    const r = Math.floor(i / cols);
    const q = i % cols;

    // perfect axial projection
    const x = width * (q + r * 0.5);

    // perfect vertical spacing
    const y = height * r;

    results.push({
      ...items[i],
      x,
      y,
    });
  }

  return results;
}
