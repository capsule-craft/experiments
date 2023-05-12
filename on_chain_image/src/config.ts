import { Connection, JsonRpcProvider, Ed25519Keypair, RawSigner } from '@mysten/sui.js';

// Public key: 0xfa85b344263a7a9c694f78990fbf48ab2d24842cc7dd07d539d3d90647c6e178
const mnemonics = 'invest half dress clay green task scare hood quiz good glory angry';

const connection = new Connection({ fullnode: 'https://rpc-sui-testnet.cosmostation.io/' });
const keypair = Ed25519Keypair.deriveKeypair(mnemonics);
export const provider = new JsonRpcProvider(connection);
export const signer = new RawSigner(keypair, provider);
export const packageId = '0x5001bee9baf10632686828854480009e88cdf7e7b3efaa8ff058addd22bb859c';
