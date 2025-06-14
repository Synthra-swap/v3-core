// SPDX-License-Identifier: BUSL-1.1
pragma solidity =0.7.6;

import './interfaces/ISynthraV3PoolDeployer.sol';

import './SynthraV3Pool.sol';

contract SynthraV3PoolDeployer is ISynthraV3PoolDeployer {
    struct Parameters {
        address factory;
        address token0;
        address token1;
        uint24 fee;
        int24 tickSpacing;
        address protocolFeeRecipient;
    }

    /// @inheritdoc ISynthraV3PoolDeployer
    Parameters public override parameters;

    /// @dev Deploys a pool with the given parameters by transiently setting the parameters storage slot and then
    /// clearing it after deploying the pool.
    /// @param factory The contract address of the Synthra V3 factory
    /// @param token0 The first token of the pool by address sort order
    /// @param token1 The second token of the pool by address sort order
    /// @param fee The fee collected upon every swap in the pool, denominated in hundredths of a bip
    /// @param tickSpacing The spacing between usable ticks
    /// @param protocolFeeRecipient The address that receives protocol fees
    function deploy(
        address factory,
        address token0,
        address token1,
        uint24 fee,
        int24 tickSpacing,
        address protocolFeeRecipient
    ) internal returns (address pool) {
        parameters = Parameters({
            factory: factory, 
            token0: token0, 
            token1: token1, 
            fee: fee, 
            tickSpacing: tickSpacing,
            protocolFeeRecipient: protocolFeeRecipient
        });
        pool = address(new SynthraV3Pool{salt: keccak256(abi.encode(token0, token1, fee))}());
        delete parameters;
    }
}
