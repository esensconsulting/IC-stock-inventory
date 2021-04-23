import Nat "mo:base/Nat";
import Hash "mo:base/Hash";
import HashMap "mo:base/HashMap";
import Array "mo:base/Array";
import Result "mo:base/Result";
import Option "mo:base/Option";
import Principal "mo:base/Principal";

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

    public shared ({ caller }) func borrowItem(itemId: Nat) : async Result.Result<Item, Text> {
        switch(inventory.get(itemId)) {
            case null {
                #err("Item with id " # Nat.toText(itemId) # " doesn't exit.");
            };
            case (?(item)) {
                if(Option.isNull(item.borrower)) {
                    let itemBorrowed : Item = {
                        id=item.id;
                        name=item.name;
                        description=item.description;
                        borrower=?(caller);
                    };
                    inventory.put(itemId, itemBorrowed);
                    #ok(itemBorrowed);
                } else {
                    #err("Item already borrowed.");
                }     
            }
        }
    };

    public shared ({ caller }) func unborrowItem(itemId: Nat) : async Result.Result<Item, Text> {
        switch(inventory.get(itemId)) {
            case null {
                #err("Item with id " # Nat.toText(itemId) # " doesn't exit.");
            };
            case (?(item)) {
                if(Option.isNull(item.borrower)) {
                    #err("There is no current borrower.");
                } else if (Option.unwrap(item.borrower) != caller) {
                    #err("You are not the current borrower.");
                } else {
                    let itemBorrowed : Item = {
                        id=item.id;
                        name=item.name;
                        description=item.description;
                        borrower=null;
                    };
                    inventory.put(itemId, itemBorrowed);
                    #ok(itemBorrowed);
                }
            }
        }
    };
};
