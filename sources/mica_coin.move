/// Create a simple coin with icon.
module mica_coin::mica_coin {
    use sui::coin::{Self, TreasuryCap};
    use sui::tx_context::{sender, TxContext};
    use sui::transfer;
    use std::option;
    use sui::url::{Self, Url};

    /// The coin type for Mica Coin.
    struct MICA_COIN has drop {}

    /// Initialize the Mica Coin and mint initial supply to sender.
    fun init(coin_type: MICA_COIN, ctx: &mut TxContext) {
        let treasury_cap = create_currency(coin_type, ctx);
        transfer::public_transfer(treasury_cap, sender(ctx));
    }

    /// Internal helper to create the Mica Coin currency.
    fun create_currency<T: drop>(
        coin_type: T,
        ctx: &mut TxContext
    ): TreasuryCap<T> {
        let url = url::new_unsafe_from_bytes(b"https://micacoin.org/assets/icon.png");

        let (treasury_cap, metadata) = coin::create_currency(
            coin_type,
            9,
            b"MCN",
            b"Mica Coin",
            b"Milcahana's First Coin",
            option::some(url),
            ctx
        );

        transfer::public_freeze_object(metadata);
        treasury_cap
    }

    /// Mint `amount` of Mica Coin and send to `recipient`.
    public entry fun mint(
        cap: &mut TreasuryCap<MICA_COIN>,
        amount: u64,
        recipient: address,
        ctx: &mut TxContext
    ) {
        coin::mint_and_transfer(cap, amount, recipient, ctx);
    }

    #[test_only]
    public fun init_for_test(ctx: &mut TxContext) {
        init(MICA_COIN{}, ctx);
    }
}
