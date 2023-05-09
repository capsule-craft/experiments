import { TransactionBlock } from "@mysten/sui.js";
import { packageId, signer } from "./config";
import { fileToDataURI, splitData } from "./fs";

async function main() {
  const data = await fileToDataURI("./file.jpeg");
  const parts = await splitData(data);
  const txb = new TransactionBlock();

  const fileId = "0x73df9f1b7020ca3b5aac3630eb6d3624ab20d808e9991ff8ff865eb58337384b";

  // start from 7 to add the remaining part
  for (let i = 7; i < 15; i++) {
    const part = parts[i];

    txb.moveCall({
      typeArguments: [],
      arguments: [txb.object(fileId), txb.pure(part)],
      target: `${packageId}::file::append`,
    });
  }

  txb.setGasBudget(10000000000);
  const resp = await signer.signAndExecuteTransactionBlock({ transactionBlock: txb });
  console.log(resp);
}

main();
