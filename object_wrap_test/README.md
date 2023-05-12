To test:

- Object wrapped in field
- Object wrapped in in wrapped-field
- Object wrapped in dynamic field
- Object wrapped in dynamic object field

Commands:

`sui client call --package 0x5031bc23fffb061741418473edead94c2c1a928001794b2c4c0f41f5d23068f4 --module wrap --function create --gas-budget 60000000`

Costs 15 milliSUI to esentially do nothing

**Wrapper Objects:**
0x050ab699c064ce235e71125098097b23875effc2ccd22deaae0eb7d99a8a1664 <-- Wrapper 1 (static)

```
id: 0x050ab699c064ce235e71125098097b23875effc2ccd22deaae0eb7d99a8a1664
contents: {
  "type": "0x5031bc23fffb061741418473edead94c2c1a928001794b2c4c0f41f5d23068f4::wrap::MyObject",
  "fields": {
    "id": {
      "id": "0x6d8afa7a06db754b0a598c77e9e301f198e6c66ced5e26b293df3d1fb3bd97ee"
    }
  }
}
```

Contains a single object: 0x615217c2ea2b3b6f23bc3fbaa35bef3414e138a4d6922b204766ba1915b5b627, which cannot be found in the Sui explorer

0xee44f39d49b3c9e4b34f7d90684dde514609aebb085f89197c0ee832094c1471 <-- Wrapper 2 (static, static)

```
id: 0xee44f39d49b3c9e4b34f7d90684dde514609aebb085f89197c0ee832094c1471
{
  "type": "0x5031bc23fffb061741418473edead94c2c1a928001794b2c4c0f41f5d23068f4::wrap::MyWrapper<0x5031bc23fffb061741418473edead94c2c1a928001794b2c4c0f41f5d23068f4::wrap::MyObject>",
  "fields": {
    "contents": {
      "type": "0x5031bc23fffb061741418473edead94c2c1a928001794b2c4c0f41f5d23068f4::wrap::MyObject",
      "fields": {
        "id": {
          "id": "0x32454bd2279e70acb330c9b0fcd07c9af1d55fec8d9f88545c3f103e87f704f9"
        }
      }
    },
    "id": {
      "id": "0x3b456ba95ebb40150c9391ee581247e1531171fd6185befced2401169654b7d6"
    }
  }
}
```

Contains two objects: 0x3b456ba95ebb40150c9391ee581247e1531171fd6185befced2401169654b7d6 which is the wrapper, and then 0x32454bd2279e70acb330c9b0fcd07c9af1d55fec8d9f88545c3f103e87f704f9 which exists inside this wrapper. Neither of them can be found in the Sui explorer.

0x3205495b72497d118b014d6ed793515e130481d990d321ab42029ee82425a6f6 <-- wrapper 3 (dynamic object)

Has a dynamic field 0xa423c17239d1717fb598fd585d3732f236d3e696ebd70b89b49cd3c5047e9c77, and its child 0x2824750cab9177d1781d0e7b45882adef4874226e86ef96242b1572f3cffe680

The dynamic field object can be found, but its value (child) cannot for some reason

0x8c635009ffb72b1c487d73abb00b0bcfabdfd65f62e5bc9d3a42ddf64920c483 <-- Wrapper 4 (dynamic object)

Has a single dynamic field, 0x8a4616924ed11a6b556c01460911c762905c6a1881db92520b7de1c0516e058d which has a single object inside of it 0x681b0f148bef20f34d5cf3d6263689fe56eb21a79300438532228ac11f1853b9

Both the dynamic field object and its object-contents can be found in the Sui explorer.

**Embedded Objects:**
??? <-- MyObject 0

0xa423c17239d1717fb598fd585d3732f236d3e696ebd70b89b49cd3c5047e9c77 <-- dynamic field 1
0x8a4616924ed11a6b556c01460911c762905c6a1881db92520b7de1c0516e058d <-- dynamic field 2
0x681b0f148bef20f34d5cf3d6263689fe56eb21a79300438532228ac11f1853b9 <-- value of dynamic field 2

**Modified Objects:**

Static Wrapper:
0x906dc8047e84c7ae0317fd9b0281cab416b8d314773fc4a35053fe6d2c52382b - destroyed static wrapper
0xac755240d4fc787355c89a6c292130b31ad4b34df0081f9a1ce621200a12bc4c - unwrapped

Dynamic Field:
0xcc1bb203a0aaacb603b6de0e1624ffb0bcc02e0e89e2952e86eb709b66204802 - destroyed dynamic wrapper
0xcc1bb203a0aaacb603b6de0e1624ffb0bcc02e0e89e2952e86eb709b66204802 - destroyed dynamic field
0xc9ed730311bdf645e643a20724115e8582228e63fb648a0b5e8e0ed0674b5de4 - unwrapped
