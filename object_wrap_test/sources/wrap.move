module wrap_test::wrap {
    use sui::object::{Self, UID, ID};
    use sui::tx_context::{Self, TxContext};
    use sui::dynamic_field;
    use sui::dynamic_object_field;
    use sui::transfer;

    struct MyWrapper<T> has key, store {
        id: UID,
        contents: T
    }

    struct MyObject has key, store {
        id: UID
    }

    struct MyFakeID has store {
        id: ID
    }

    public entry fun create(ctx: &mut TxContext) {
        let object0 = MyObject { id: object::new(ctx) }; // root level
        let object1 = MyObject { id: object::new(ctx) }; // wrapped once
        let object2 = MyObject { id: object::new(ctx) }; // wrapped twice
        let object3 = MyObject { id: object::new(ctx) }; // dynamic field
        let object4 = MyObject { id: object::new(ctx) }; // dynamic object field

        let wrapper1 = MyWrapper { 
            id: object::new(ctx),
            contents: object1 
        };

        let wrapper2 = MyWrapper { 
            id: object::new(ctx), 
            contents: MyWrapper { 
                id: object::new(ctx), 
                contents: object2 
            }
        };

        let wrapper3 = MyWrapper { 
            id: object::new(ctx), 
            contents: 0
        };
        dynamic_field::add(&mut wrapper3.id, true, object3);

        let wrapper4 = MyWrapper { 
            id: object::new(ctx), 
            contents: 0u8
        };
        dynamic_object_field::add(&mut wrapper4.id, 19u8, object4);

        let sender = tx_context::sender(ctx);

        transfer::transfer(object0, sender);
        transfer::transfer(wrapper1, sender);
        transfer::transfer(wrapper2, sender);
        transfer::transfer(wrapper3, sender);
        transfer::transfer(wrapper4, sender);
    }

    // ========== Unwrapping ==========

    public entry fun unwrap_static(wrapper2: MyWrapper<MyObject>, ctx: &mut TxContext) {
        let MyWrapper { id, contents } = wrapper2;
        object::delete(id);
        transfer::transfer(contents, tx_context::sender(ctx));
    }

    public entry fun unwrap_dynamic(wrapper3: MyWrapper<u64>, ctx: &mut TxContext) {
        let MyWrapper { id, contents: _ } = wrapper3;
        let contents = dynamic_field::remove<bool, MyObject>(&mut id, true);
        object::delete(id);
        transfer::transfer(contents, tx_context::sender(ctx));
    }

    public entry fun unwrap_dynamic_object(wrapper4: MyWrapper<u8>, ctx: &mut TxContext) {
        let MyWrapper { id, contents: _ } = wrapper4;
        let contents = dynamic_object_field::remove<u8, MyObject>(&mut id, 19u8);
        object::delete(id);
        transfer::transfer(contents, tx_context::sender(ctx));
    }

    // ========== Wrapping ==========

    public entry fun wrap_static(contents: MyObject, ctx: &mut TxContext) {
        let wrapper = MyWrapper { id: object::new(ctx), contents };
        transfer::transfer(wrapper, tx_context::sender(ctx));
    }

    public entry fun wrap_dynamic(contents: MyObject, ctx: &mut TxContext) {
        let wrapper = MyWrapper { id: object::new(ctx), contents: 0 };
        dynamic_field::add(&mut wrapper.id, true, contents);
        transfer::transfer(wrapper, tx_context::sender(ctx));
    }

    public entry fun wrap_dynamic_object(contents: MyObject, ctx: &mut TxContext) {
        let wrapper = MyWrapper { id: object::new(ctx), contents: 0u8 };
        dynamic_object_field::add(&mut wrapper.id, 19u8, contents);
        transfer::transfer(wrapper, tx_context::sender(ctx));
    }

    // ========== Wrapping ==========

    public entry fun fake_id(ctx: &mut TxContext) {
        let id = MyFakeID { id: object::id_from_address(@0x1234567890abcdef)};
        let wrapper = MyWrapper { id: object::new(ctx), contents: id };
        transfer::transfer(wrapper, tx_context::sender(ctx));
    }
}