// SPDX-License-Identifier: UNLICENSED
pragma solidity =0.7.6;

import '../interfaces/IERC20Minimal.sol';

import '../interfaces/callback/ISynthraV3SwapCallback.sol';
import '../interfaces/ISynthraV3Pool.sol';

contract SynthraV3PoolSwapTest is ISynthraV3SwapCallback {
    int256 private _amount0Delta;
    int256 private _amount1Delta;

    function getSwapResult(
        address pool,
        bool zeroForOne,
        int256 amountSpecified,
        uint160 sqrtPriceLimitX96
    )
        external
        returns (
            int256 amount0Delta,
            int256 amount1Delta,
            uint160 nextSqrtRatio
        )
    {
        (amount0Delta, amount1Delta) = ISynthraV3Pool(pool).swap(
            address(0),
            zeroForOne,
            amountSpecified,
            sqrtPriceLimitX96,
            abi.encode(msg.sender)
        );

        (nextSqrtRatio, , , , , , ) = ISynthraV3Pool(pool).slot0();
    }

    function synthraV3SwapCallback(
        int256 amount0Delta,
        int256 amount1Delta,
        bytes calldata data
    ) external override {
        address sender = abi.decode(data, (address));

        if (amount0Delta > 0) {
            IERC20Minimal(ISynthraV3Pool(msg.sender).token0()).transferFrom(sender, msg.sender, uint256(amount0Delta));
        } else if (amount1Delta > 0) {
            IERC20Minimal(ISynthraV3Pool(msg.sender).token1()).transferFrom(sender, msg.sender, uint256(amount1Delta));
        }
    }
}
