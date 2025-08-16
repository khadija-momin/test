module AptosFrameworkptos::AttendanceProof {
    use aptos_framework::signer;

    /// Minimal attendance proof stored under a user's account.
    struct Proof has key, store { times: u64 }

    /// Mark attendance for the caller:
    /// - Creates Proof{1} if absent, else increments.
    public entry fun attend(user: &signer) acquires Proof {
        let addr = signer::address_of(user);
        if (!exists<Proof>(addr)) {
            move_to(user, Proof { times: 1 });
        } else {
            let p = borrow_global_mut<Proof>(addr);
            p.times = p.times + 1;
        };
    }

    /// Read how many times an address attended (0 if none).
    public fun get_proof(addr: address): u64 acquires Proof {
        if (exists<Proof>(addr)) {
            borrow_global<Proof>(addr).times
        } else {
            0
        }
    }
}
