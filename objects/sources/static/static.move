module objects::static {
    use sui::transfer;
    use sui::object::{Self, UID};
    use sui::tx_context::TxContext;

    struct StaticObject has key {
        id: UID,
        child: ChildObject
    }

    struct ChildObject has key, store {
        id: UID
    }

    public fun create(ctx: &mut TxContext): StaticObject {
        StaticObject {
            id: object::new(ctx),
            child: create_child(ctx)
        }
    }

    public fun create_child(ctx: &mut TxContext): ChildObject {
        ChildObject {
            id: object::new(ctx)
        }
    }

    public fun remove(object: StaticObject) {
        transfer::share_object(remove_(object));
    }

    public fun remove_(object: StaticObject): ChildObject {
        let StaticObject { id, child } = object;
        object::delete(id);

        child
    }

    public fun return_and_share(object: StaticObject) {
        transfer::share_object(object);
    }
}