import { TransactionBlock } from "@mysten/sui.js";
import { packageId, signer } from "./config";
import { splitFile } from "./fs";

async function main() {
  const parts = await splitFile("./file.jpeg");
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
      arguments: [file, txb.pure(part)],
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
