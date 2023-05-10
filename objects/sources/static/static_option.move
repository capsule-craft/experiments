module objects::static_option {
    use std::option::{Self, Option};

    use sui::transfer;
    use sui::object::{Self, UID};
    use sui::tx_context::TxContext;

    struct StaticObject has key {
        id: UID,
        child: Option<ChildObject>
    }

    struct ChildObject has key, store {
        id: UID
    }

    const EChildAreadyExist: u64 = 0;

    public fun create(ctx: &mut TxContext): StaticObject {
        StaticObject {
            id: object::new(ctx),
            child: option::some(create_child(ctx))
        }
    }

    public fun wrap(object: &mut StaticObject, ctx: &mut TxContext) {
        assert!(option::is_none(&object.child), EChildAreadyExist);
        option::fill(&mut object.child, create_child(ctx))
    }

    public fun create_(ctx: &mut TxContext): StaticObject {
        StaticObject {
            id: object::new(ctx),
            child: option::none()
        }
    }

    public fun create_child(ctx: &mut TxContext): ChildObject {
        ChildObject {
            id: object::new(ctx)
        }
    }

    public fun remove(object: &mut StaticObject) {
        let child = option::extract(&mut object.child);
        transfer::share_object(child)
    }

    public fun remove_(object: &mut StaticObject): ChildObject {
        option::extract(&mut object.child)
    }
}