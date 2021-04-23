dfx canister call stock getAllItems
dfx canister call stock createItem '(record {name="MBP"; description="serialnumber=C02XXXXXX";})'
dfx canister call stock createItem '(record {name="MBP 2"; description="serialnumber=C03XXXXXX";})'
dfx canister call stock getAllItems
dfx canister call stock borrowItem '1'
# dfx canister call stock unborrowItem '3'
# dfx canister call stock unborrowItem '2'
# dfx canister call stock unborrowItem '1'
