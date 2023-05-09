import fs from "fs/promises";

export async function splitFile(path: string): Promise<number[][]> {
  const maxSize = 16 * 1000;
  const fileBuffer = await fs.readFile(path);
  const fileBufferArray = Array.from(fileBuffer);

  let currentId = 0;
  let currentPart: number[] = [];
  let parts: number[][] = [];

  for (let i = 0; i < fileBufferArray.length; i++) {
    currentPart.push(fileBufferArray[i]);
    currentId++;

    if (maxSize - currentId == 0 || i == fileBufferArray.length - 1) {
      parts.push(currentPart);

      currentId = 0;
      currentPart = [];
    }
  }

  return parts;
}
