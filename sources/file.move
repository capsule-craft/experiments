module ois::file {
    use std::vector;

    use sui::transfer;
    use sui::object::{Self, UID};
    use sui::table::{Self, Table};
    use sui::tx_context::TxContext;

    struct File has key {
        id: UID,
        size: u64,
        content: Table<u64, Buffer>
    }

    struct Buffer has store {
        content: vector<u8>,
        size: u64
    }

    const MAX_BUFFER_SIZE: u64 = 255 * 1000;

    public fun create(ctx: &mut TxContext): File {
        File {
            id: object::new(ctx),
            content: table::new(ctx),
            size: 0u64,
        }
    }

    public fun append(self: &mut File, chunk: vector<u8>) {
        let chunk_size = vector::length(&chunk);

        if(!table::is_empty(&self.content)) {
            let last_buffer_id = table::length(&self.content) - 1;
            let last_buffer = table::borrow_mut(&mut self.content, last_buffer_id);

            if((last_buffer.size + chunk_size) > MAX_BUFFER_SIZE) {
                add_chunk_internal(self, chunk);
            } else {
                vector::reverse(&mut chunk);
                update_buffer_internal(last_buffer, chunk);
            }
        } else {
            add_chunk_internal(self, chunk);
        };

        self.size = self.size + chunk_size;
    }

    public fun return_and_share(self: File) {
        transfer::share_object(self)
    }

    fun update_buffer_internal(buffer: &mut Buffer, chunk: vector<u8>) {
        let (i, available_space) = (0, MAX_BUFFER_SIZE - buffer.size);

        loop {
            if(vector::is_empty(&chunk)) break;
            if(i == available_space) break;

            let byte = vector::pop_back(&mut chunk);
            vector::push_back(&mut buffer.content, byte);
            i = i + 1;
        };

        buffer.size = buffer.size + available_space;
    }

    fun add_chunk_internal(self: &mut File, chunk: vector<u8>) {
        let size = vector::length(&chunk);
        let id = table::length(&self.content);

        table::add(&mut self.content, id, Buffer { content: chunk, size })
    }
}