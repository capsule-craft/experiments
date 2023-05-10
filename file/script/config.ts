import { Connection, JsonRpcProvider, Ed25519Keypair, RawSigner } from "@mysten/sui.js";

// Setup connection
const mnemonics = "invest half dress clay green task scare hood quiz good glory angry";

const connection = new Connection({ fullnode: "http://127.0.0.1:9000" });
const keypair = Ed25519Keypair.deriveKeypair(mnemonics);
export const provider = new JsonRpcProvider(connection);
export const signer = new RawSigner(keypair, provider);
export const packageId = "0x7f4527c0f317a0e0e228aa42fae34fa7ffe18e15ac76042ad63c07048cdeadda";
