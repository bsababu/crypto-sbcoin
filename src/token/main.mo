import Principal "mo:base/Principal";
import Text "mo:base/Text";
import HashMap "mo:base/HashMap";
import Prelude "mo:base/Prelude";
import Debug "mo:base/Debug";
import Iter "mo:base/Iter";




actor Token {
    let owner: Principal = Principal.fromText("i6pib-koi47-x2uah-uzcws-wn6wk-mvuhy-o5rci-uti63-wr4zj-qmdhf-7ae");
    let totalSupply: Nat = 1000000000;
    let symbol: Text = "SBCOIN";
    Debug.print(debug_show("debugging"));
    private stable var balanceEntries: [(Principal, Nat)] = [];

    private var balances = HashMap.HashMap<Principal, Nat>(1, Principal.equal, Principal.hash); //hashmap<key, value>

    

    public query func balanceOf(who: Principal): async Nat {

        let balance: Nat = switch(balances.get(who)){
            case null 0;
            case (?result) result;

        };
        return balance;
    };

    public query func getSymbol(): async Text{
        return symbol;
    };

    public shared(msg) func payOut(): async Text {
        Debug.print(debug_show(msg.caller));
        var amount = 20000;

        if(balances.get(msg.caller)==null) {
            //balances.put(msg.caller, amount);
            let result = await transfer(msg.caller, amount);
            return result;
        } else {
            return "Already consumed";
        };
    };

    public shared(msg) func transfer(to: Principal, amount: Nat): async Text {
        let from_balance = await balanceOf(msg.caller);

        if (amount < from_balance ) {
            let newBal: Nat = from_balance - amount;
            balances.put(msg.caller, newBal);

            let toreceiver = await balanceOf(to);
            let newReceiverBal = toreceiver + amount;
            balances.put(to, newReceiverBal);
            return "success";
        } else {return "insufficient";};
    };

    system func preupgrade(){
        balanceEntries := Iter.toArray(balances.entries());
    };

    system func postupgrade() {
        balances :=HashMap.fromIter<Principal, Nat>(balanceEntries.vals(),1,Principal.equal,Principal.hash);
        if(balances.size() < 1){
            balances.put(owner, totalSupply);
        }
    }

};