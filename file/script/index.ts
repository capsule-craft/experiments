import { TransactionBlock } from "@mysten/sui.js";
import { packageId, signer } from "./config";
import { fileToDataURI, splitData } from "./fs";

async function main() {
  const data = await fileToDataURI("./file.jpeg");
  const parts = await splitData(data);
  const txb = new TransactionBlock();

  const [file] = txb.moveCall({
    arguments: [],
    typeArguments: [],
    target: `${packageId}::file::create`,
  });

  for (let i = 0; i < 7; i++) {
    const part = parts[i];

    txb.moveCall({
      typeArguments: [],
      arguments: [file, txb.pure(Buffer.from(part).toString())],
      target: `${packageId}::file::append`,
    });
  }

  txb.moveCall({
    typeArguments: [],
    arguments: [file],
    target: `${packageId}::file::return_and_share`,
  });

  txb.setGasBudget(10000000000);
  const resp = await signer.signAndExecuteTransactionBlock({ transactionBlock: txb });
  console.log(resp);
}

main();
