import { Connection, JsonRpcProvider, Ed25519Keypair, RawSigner } from "@mysten/sui.js";

// Setup connection
const mnemonics = "invest half dress clay green task scare hood quiz good glory angry";

const connection = new Connection({ fullnode: "http://127.0.0.1:9000" });
const provider = new JsonRpcProvider(connection);
const keypair = Ed25519Keypair.deriveKeypair(mnemonics);
export const signer = new RawSigner(keypair, provider);
export const packageId = "0x9e33d385f66c7b15ad5f4cbce19077266df445df16c6abd9c9cddf065c60b95d";
