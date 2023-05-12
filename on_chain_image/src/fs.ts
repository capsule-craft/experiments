import fs from 'fs/promises';
import mime from 'mime';

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

export async function fileToDataURI(filePath: string) {
  const fileContent = await fs.readFile(filePath, 'base64');
  const mimeType = mime.getType(filePath);

  return `data:${mimeType};base64,${fileContent}`;
}

export async function splitData(data: string): Promise<number[][]> {
  const maxSize = 16 * 1000;
  const dataBufferArray = Array.from(Buffer.from(data));

  let currentId = 0;
  let currentPart: number[] = [];
  let parts: number[][] = [];

  for (let i = 0; i < dataBufferArray.length; i++) {
    currentPart.push(dataBufferArray[i]);
    currentId++;

    if (maxSize - currentId == 0 || i == dataBufferArray.length - 1) {
      parts.push(currentPart);

      currentId = 0;
      currentPart = [];
    }
  }

  return parts;
}
