import Nat "mo:base/Nat";
import Hash "mo:base/Hash";
import HashMap "mo:base/HashMap";
import Array "mo:base/Array";
import Result "mo:base/Result";

actor Stock {

    public type CreateItemDto = {
        name: Text;
        description: Text;
    };
    public type Item = {
        id: Nat;
        name: Text;
        description: Text;
        borrower: ?Principal;
    };

    object itemCounter {
        var count = 0;
        public func inc() { count += 1 };
        public func read() : Nat { count };
        public func bump() : Nat {
            inc();
            read()
        };
    };

    let inventory = HashMap.HashMap<Nat, Item>(1, Nat.equal, Hash.hash);

    public func createItem(item: CreateItemDto) : async Result.Result<Nat, Text> {
        let _id = itemCounter.bump();
        inventory.put(_id, {
            id=_id;
            name=item.name;
            description=item.description;
            borrower=null;
        });
        #ok(_id);
    };

    public query func getAllItems(): async [Item] {
        var items: [Item] = [];
        for((id, item) in inventory.entries()) {
            items := Array.append<Item>(items, [item]);
        };
        return items;
    };
};
