// SPDX-License-Identifier: UNLICENSED
pragma solidity =0.7.6;

import '../interfaces/ISynthraV3PoolDeployer.sol';

import './MockTimeSynthraV3Pool.sol';

contract MockTimeSynthraV3PoolDeployer is ISynthraV3PoolDeployer {
    struct Parameters {
        address factory;
        address token0;
        address token1;
        uint24 fee;
        int24 tickSpacing;
        address protocolFeeRecipient;
    }

    Parameters public override parameters;

    event PoolDeployed(address pool);

    function deploy(
        address factory,
        address token0,
        address token1,
        uint24 fee,
        int24 tickSpacing
    ) external returns (address pool) {
        parameters = Parameters({
            factory: factory, 
            token0: token0, 
            token1: token1, 
            fee: fee, 
            tickSpacing: tickSpacing,
            protocolFeeRecipient: factory  // Use factory as default protocol fee recipient for tests
        });
        pool = address(
            new MockTimeSynthraV3Pool{salt: keccak256(abi.encodePacked(token0, token1, fee, tickSpacing))}()
        );
        emit PoolDeployed(pool);
        delete parameters;
    }
}
