import { TransactionBlock } from "@mysten/sui.js";
import { packageId, signer } from "./config";
import { splitFile } from "./fs";

async function main() {
  const parts = await splitFile("./file.jpeg");
  const txb = new TransactionBlock();

  const fileId = "0x976640eea2ca672a7ba52c1ff05388e2987908993c539626ab01c20ec9cc8605";

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
