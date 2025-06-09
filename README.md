# Synthra V3 Core

This repository contains the core smart contracts for the Synthra V3 Protocol, a fork of Uniswap V3 with enhanced protocol fee mechanisms.

## Key Features

### 🚀 Enhanced Protocol Fee System
- **Automatic Protocol Fee Collection**: Protocol fees are automatically transferred to the designated recipient during swaps and flash loans
- **Default 1/3 Protocol Fee**: All pools are initialized with a 1/3 protocol fee (33.33% of total swap fees go to the protocol)
- **Real-time Fee Distribution**: No need for manual collection - fees are sent immediately to the protocol fee recipient
- **Configurable Fee Recipient**: Factory owner can update the protocol fee recipient address

### 📊 Fee Distribution
- **Liquidity Providers**: Receive 2/3 (66.67%) of swap fees
- **Protocol**: Automatically receives 1/3 (33.33%) of swap fees
- **Immediate Transfer**: Protocol fees are transferred in real-time during transactions

## Architecture Overview

The Synthra V3 protocol consists of:

- **SynthraV3Factory**: Deploys pool contracts and manages protocol settings
- **SynthraV3Pool**: Individual AMM pools with concentrated liquidity and automatic fee collection
- **SynthraV3PoolDeployer**: Helper contract for deterministic pool deployment

## Protocol Fee Mechanism

Unlike standard Uniswap V3 where protocol fees accumulate and require manual collection, Synthra V3 implements:

1. **Automatic Initialization**: All pools start with `feeProtocol = 51` (3 + (3 << 4)) = 1/3 fee for both tokens
2. **Real-time Transfers**: During swaps and flash loans, protocol fees are immediately sent to `protocolFeeRecipient`
3. **Gas Efficiency**: Single transaction handles both user swap and protocol fee transfer

## Technical Details

### Modified Components

#### SynthraV3Pool.sol
- Added `protocolFeeRecipient` immutable variable
- Modified `initialize()` to set default protocol fee to 1/3
- Enhanced `swap()` function with automatic fee transfers
- Enhanced `flash()` function with automatic fee transfers

#### SynthraV3Factory.sol
- Added `protocolFeeRecipient` state variable
- Added `setProtocolFeeRecipient()` function for owner
- Modified `createPool()` to pass protocol fee recipient

#### SynthraV3PoolDeployer.sol
- Extended `Parameters` struct to include `protocolFeeRecipient`
- Updated `deploy()` function signature

## Deployment Guide

### Local Deployment

To deploy Synthra V3 to a local testnet:

```typescript
import {
  abi as FACTORY_ABI,
  bytecode as FACTORY_BYTECODE,
} from './artifacts/contracts/SynthraV3Factory.sol/SynthraV3Factory.json'

// Deploy the factory
const factory = await deployContract(FACTORY_BYTECODE, FACTORY_ABI);

// The factory owner will be the deployer by default
// Protocol fee recipient will also be the deployer by default

// Optional: Set a different protocol fee recipient
await factory.setProtocolFeeRecipient(protocolFeeRecipientAddress);
```

### Protocol Configuration

After deployment, the factory owner can:

```typescript
// Change protocol fee recipient
await factory.setProtocolFeeRecipient("0x...");

// Transfer ownership
await factory.setOwner("0x...");

// Enable new fee tiers (if needed)
await factory.enableFeeAmount(fee, tickSpacing);
```

### Pool Creation

Pools are created with automatic protocol fees enabled:

```typescript
// Create a new pool - protocol fees are automatically enabled
const poolAddress = await factory.createPool(
  tokenA.address,
  tokenB.address,
  3000 // 0.3% fee tier
);

// Protocol fees (1/3 of swap fees) will automatically be sent to protocolFeeRecipient
```

## Using Solidity Interfaces

The Synthra V3 interfaces can be imported into your smart contracts:

```solidity
import './contracts/interfaces/ISynthraV3Pool.sol';
import './contracts/interfaces/ISynthraV3Factory.sol';

contract MyContract {
    ISynthraV3Pool pool;
    ISynthraV3Factory factory;

    function interactWithPool() {
        // All swaps automatically send 1/3 of fees to protocol recipient
        pool.swap(
            recipient,
            zeroForOne,
            amountSpecified,
            sqrtPriceLimitX96,
            data
        );
    }
    
    function getProtocolFeeRecipient() external view returns (address) {
        return factory.protocolFeeRecipient();
    }
}
```

## Integration Examples

### For DEX Aggregators
```solidity
// Protocol fees are automatically handled - no additional logic needed
pool.swap(user, true, amountIn, sqrtPriceLimit, swapData);
```



## Security Considerations

- **Protocol Fee Recipient**: Must be a valid address that can receive tokens
- **Automatic Transfers**: Protocol fees are transferred using `TransferHelper.safeTransfer`
- **Gas Costs**: Additional gas cost per swap for the automatic fee transfer
- **Fee Calculation**: Uses the same denominator system as Uniswap V3 (1/x where x=3 means 1/3 of fees)
