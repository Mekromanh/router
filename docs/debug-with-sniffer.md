Debug With Sniffer
==================

Confirm router runtime behavior using a virtual LoRaWAN device with a
software-based protocol sniffer.

## Dependencies

1. Ensure [Router](https://github.com/helium/router.git) is running and
   [Console](https://github.com/helium/console.git) is connected to it.
1. The wallet to be used requires enough HNT to burn for joining the virtual
   device to the network.
   + It's the same fee as for a physical device.
   + See
   [Setup Data Only Hotspot](https://docs.helium.com/mine-hnt/data-only-hotspots/#transactions--cost)
1. Clone each of these repos:
    + [virtual-lorawan-device](https://github.com/helium/virtual-lorawan-device)
    + [lorawan-sniffer](https://github.com/helium/lorawan-sniffer)
    + [gateway-rs](https://github.com/helium/gateway-rs)
    + [helium-wallet-rs](https://github.com/helium/helium-wallet-rs)

Those packages require [Rust](https://rust-lang.org/) when building from
source.

Everything may run locally on a laptop/workstation, or use just the
Rust-based tools locally for connecting to a remote Router & Console.

## Overview

The approximate sequence:

1. Create a virtual device
1. Use the wallet to pay for joining a device to the network
1. Device gets added via Console, which then will be "pending" for about 15 minutes
1. Start local data-only hotspot
1. Configure sniffer to use that hotspot
1. Connect the virtual device to sniffer
1. Wait for "pending" to resolve on Console
1. Finally, the virtual device joins the network

Order of operations below is significant.

# Setup

## Compile

Because there are multiple repos each in their own subdirectory, examples
below assume everything is located beneath the `~/helium/` path.

Ensure everything compiles successfully.

    cd ~/helium/

    git clone https://github.com/helium/helium-wallet-rs.git
    cd helium-wallet-rs/
    cargo build --release

    cd ..

    git clone https://github.com/helium/gateway-rs.git
    cd gateway-rs/
    cargo build --release

    cd ..

    git clone https://github.com/helium/virtual-lorawan-device.git
    cd virtual-lorawan-device/
    cargo build --release

    cd ..

    git clone https://github.com/helium/lorawan-sniffer.git
    cd lorawan-sniffer/
    cargo build --release

Those may be built in any order but are in sequence as used below.

## Confirm Wallet Balance

Later steps require the command-line interface (CLI) version of a wallet.

For using a wallet already attached to an existing hotspot, that wallet can
be [connected](https://github.com/helium/helium-wallet-rs#create-a-wallet)
to this one using the `--seed` option.

Run:

    cd ~/helium/helium-wallet-rs/
    ./target/release/helium-wallet create basic

Follow its [README](https://github.com/helium/helium-wallet-rs) or other
[instructions](https://docs.helium.com/mine-hnt/data-only-hotspots/) for
creating and **funding this wallet**.

View details of the *funded* CLI wallet:

    ./target/release/helium-wallet info

See `Balance` field, and confirm having enough HNT to burn 1000000 (six
zeros) data credits.  One whole HNT is more than sufficient with prevailing
exchange rates in early 2022.

Copy the value from the `Address` field:
`WalletADDRESS...` will be used as the example in excerpts below.

## Join Device To Network

Use the `WalletADDRESS...` from the earlier wallet "info" command.

Arguments to both the owner and payer options will be your wallet address
(as with a self-signed certificate).

Run:

    cd ~/helium/gateway-rs/
    ./target/release/helium_gateway add --mode dataonly \
        --owner WalletADDRESS... \
        --payer WalletADDRESS...

Output from that command will include a transaction ID associated with the
`txn` field.  Copy this value (without quotes) which is referred to as
`TxnID...` below for use with the CLI wallet.

Accommodate cache, which isn't strictly necessary for purposes here:

    mkdir cache
    echo 'store = "'$(pwd)'/cache"' > config/settings.toml

The gateway service will be started below, after adding the device.

## Join Hotspot Using Wallet

Use the `TxnID...` from the previous step.

Add the hotspot to the network, which requires burning data credits (DC) and
must use the CLI wallet.

Always perform a dry-run (*without* the commit flag) first:

    cd ~/helium/helium-wallet-rs/
    ./target/release/helium-wallet hotspots add TxnID...

Confirm that the staking fee in DC is `1000000` (six zeros), and then repeat
same command plus `--commit` flag:

    !! --commit

## Console

Log on to Console, and
[create a new device](https://docs.helium.com/use-the-network/console/adding-devices/).

When successful, Console should indicate "Pending" for this device.

This *pending* status persists until the next XOR operation by the Router,
**which may take 15 minutes** or so.

Both the sniffer and virtual device may be configured during this wait.

Get the following values from Console for your device:

1. Device EUI
1. App EUI
1. App Key

(You may also want the "Device ID" for tracing via SSH session on the router
instance itself.)

Each value gets associated with the appropriate key in different
configuration files for sniffer and virtual device.

## Configure Virtual LoRaWAN Device

Using those same values from Console, each value should be associated with
the appropriate key within a **TOML** file:  
`~/helium/virtual-lorawan-device/settings/settings.toml`

Example:

```toml
[device.one.credentials]
dev_eui = "DevEUIHexValue..."
app_eui = "AppEUIHexValue..."
app_key = "AppKeyLongHexValue..."

[packet_forwarder.default]
host = "localhost:1600"
```

While editing that TOML file, also indicate that it should talk to your
instance of `gateway-rs` as the packet-forwarder (typically on IP Port
`1600`).

Keep the `defaults.toml` file unmodified for ease of `git pull` in future.

## Configure LoRaWAN Sniffer

Each value above from Console should be associated with the appropriate key
within a **JSON** file:  
`~/helium/lorawan-sniffer/lorawan-devices.json`

Example:

```json
[
    {
        "dev_eui": "DevEUIHexValue...",
        "app_eui": "AppEUIHexValue...",
        "app_key": "AppKeyLongHexValue..."
    }
]
```

## Wait For XOR

Again: the Console may indicate "Pending" from having added the new device.

Wait until that message clears before proceeding.

# Live Debugging

There will be *a lot* of output from each command, so consider using
separate Terminal tabs/windows.

## Start Hotspot

Run in its own Terminal window:

    cd ~/helium/gateway-rs/
    ./target/release/helium_gateway -c config server

## Start Sniffer

Run in its own Terminal window:

    cd ~/helium/lorawan-sniffer/
    ./target/release/lorawan-sniffer --host 127.0.0.1:1680

If the gateway restarts, the sniffer may need to be restarted also.

## Start Device

Run in its own Terminal window:

    cd ~/helium/virtual-lorawan-device/
    ./target/release/virtual-lorawan-device

Each start of this program begins with a fresh LoRaWAN Join, so expect to
see a matching Join-Accept response from the router.

Consider making changes to settings within
[configuration profiles](https://docs.helium.com/use-the-network/console/profiles/)
in Console for this device, such as `rx_delay`.

## Router Trace

This is optional.

From Console, get the "Device ID" value, which is a UUID string.

Run in its own Terminal window:

    ssh router-dev

Start tracing for your device:

    router device trace --id=4e698917-b44c-abcd-b258-afaf579a2099

When finished, conclude tracing for your device:

    router device trace --id=4e698917-b44c-abcd-b258-afaf579a2099 --stop

Or extract from logs in the usual way:

    grep 4e698917-b44c-abcd-b258-afaf579a2099 /var/data/log/router.log
