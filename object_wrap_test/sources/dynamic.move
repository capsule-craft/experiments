module objects::dynamic {
    use sui::transfer;
    use sui::object::{Self, UID};
    use sui::tx_context::TxContext;

    use sui::dynamic_field;

    struct MainObject has key {
        id: UID
    }

    struct DynamicWrapper has store { 
        child: ChildObject 
    }
    
    struct ChildObject has key, store {
        id: UID
    }

    public fun create(key: u64, ctx: &mut TxContext): MainObject {
        let object = MainObject { id: object::new(ctx) };
        let wrapper = DynamicWrapper { child: create_child(ctx) };

        dynamic_field::add<u64, DynamicWrapper>(&mut object.id, key, wrapper);

        object
    }

    public fun wrap(key: u64, object: &mut MainObject, ctx: &mut TxContext) {
        let wrapper = DynamicWrapper { child: create_child(ctx) };
        dynamic_field::add<u64, DynamicWrapper>(&mut object.id, key, wrapper)
    }

    public fun create_child(ctx: &mut TxContext): ChildObject {
        ChildObject {
            id: object::new(ctx)
        }
    }

    public fun remove(key: u64, object: &mut MainObject) {
        transfer::share_object(remove_(key, object));
    }

    public fun remove_(key: u64, object: &mut MainObject): ChildObject {
       let wrapper = dynamic_field::remove<u64, DynamicWrapper>(&mut object.id, key);
        let DynamicWrapper { child } = wrapper;

        child
    }

    public fun return_and_share(object: MainObject) {
        transfer::share_object(object);
    }
}