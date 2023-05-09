import { Connection, JsonRpcProvider, Ed25519Keypair, RawSigner } from "@mysten/sui.js";

// Setup connection
const mnemonics = "invest half dress clay green task scare hood quiz good glory angry";

const connection = new Connection({ fullnode: "http://127.0.0.1:9000" });
const keypair = Ed25519Keypair.deriveKeypair(mnemonics);
export const provider = new JsonRpcProvider(connection);
export const signer = new RawSigner(keypair, provider);
export const packageId = "0x6764ce0fa896e011985d537e344db7759c0ac4da7e9eeba7befc672578ee555a";
