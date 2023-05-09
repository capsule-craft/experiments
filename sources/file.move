module ois::file {
    use std::vector;
    use std::string::{Self, String};

    use sui::transfer;
    use sui::object::{Self, UID};
    use sui::tx_context::TxContext;

    struct File has key {
        id: UID,
        data: String
    }

    public fun create(ctx: &mut TxContext): File {
        File {
            id: object::new(ctx),
            data: string::utf8(vector::empty()),
        }
    }

    public fun append(self: &mut File, chunk: vector<u8>) {
        string::append_utf8(&mut self.data, chunk);
    }

    public fun return_and_share(self: File) {
        transfer::share_object(self)
    }
}