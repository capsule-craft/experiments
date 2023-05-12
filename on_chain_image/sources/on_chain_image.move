module on_chain_image::file {
    use std::string::String;
    use std::vector;

    // use sui::transfer;
    use sui::object::{Self, UID};
    use sui::tx_context::TxContext;

    struct File has key, store {
        id: UID,
        image_url: vector<String>
    }

    public fun create(chunk: String, ctx: &mut TxContext): File {
        File {
            id: object::new(ctx),
            image_url: vector[chunk]
        }
    }

    public fun append(self: &mut File, chunk: String) {
        vector::push_back(&mut self.image_url, chunk);
    }

    // public fun return_and_share(self: File) {
    //     transfer::share_object(self)
    // }
}