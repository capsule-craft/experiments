import { TransactionBlock } from '@mysten/sui.js';
import { packageId, signer } from './config';
import { fileToDataURI, splitData } from './fs';
import path from 'path';

async function main(fileName: string) {
  const data = await fileToDataURI(`./images/${fileName}`);
  const parts = await splitData(data);
  const txb = new TransactionBlock();

  let address = await signer.getAddress();

  console.log(`Creating image as ${address}`);

  const [file] = txb.moveCall({
    arguments: [txb.pure(Buffer.from(parts[0]).toString())],
    typeArguments: [],
    target: `${packageId}::file::create`
  });

  for (let i = 1; i < parts.length; i++) {
    const part = parts[i];

    txb.moveCall({
      typeArguments: [],
      arguments: [file, txb.pure(Buffer.from(part).toString())],
      target: `${packageId}::file::append`
    });
  }

  txb.transferObjects([file], txb.pure(await signer.getAddress()));

  // txb.moveCall({
  //   typeArguments: [],
  //   arguments: [file],
  //   target: `${packageId}::file::return_and_share`
  // });

  txb.setGasBudget(700_000_000);
  const resp = await signer.signAndExecuteTransactionBlock({ transactionBlock: txb });
  console.log(resp);
}

main(process.argv[2] || '7KB.webp');
