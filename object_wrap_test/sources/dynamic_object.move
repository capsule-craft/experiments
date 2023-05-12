module objects::dynamic_object {
    use sui::transfer;
    use sui::object::{Self, UID};
    use sui::tx_context::TxContext;

    use sui::dynamic_object_field;

    struct MainObject has key {
        id: UID
    }

    struct DynamicObjectWrapper has key, store { 
        id: UID,
        child: ChildObject 
    }
    
    struct ChildObject has key, store {
        id: UID
    }

    public fun create(key: u64, ctx: &mut TxContext): MainObject {
        let object = MainObject { id: object::new(ctx) };
        let wrapper = DynamicObjectWrapper { 
            id: object::new(ctx), 
            child: create_child(ctx) 
        };

        dynamic_object_field::add<u64, DynamicObjectWrapper>(&mut object.id, key, wrapper);

        object
    }

    public fun create_child(ctx: &mut TxContext): ChildObject {
        ChildObject {
            id: object::new(ctx)
        }
    }

    public fun wrap(key: u64, object: &mut MainObject, ctx: &mut TxContext) {
        let wrapper = DynamicObjectWrapper { 
            id: object::new(ctx),
            child: create_child(ctx)
        };
    
        dynamic_object_field::add<u64, DynamicObjectWrapper>(&mut object.id, key, wrapper)
    }

    public fun remove(key: u64, object: &mut MainObject) {
        transfer::share_object(remove_(key, object));
    }

    public fun remove_(key: u64, object: &mut MainObject): ChildObject {
       let wrapper = dynamic_object_field::remove<u64, DynamicObjectWrapper>(&mut object.id, key);
        let DynamicObjectWrapper { id, child } = wrapper;
        object::delete(id);

        child
    }

    public fun return_and_share(object: MainObject) {
        transfer::share_object(object);
    }
}