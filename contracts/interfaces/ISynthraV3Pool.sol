// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity >=0.5.0;

import './pool/ISynthraV3PoolImmutables.sol';
import './pool/ISynthraV3PoolState.sol';
import './pool/ISynthraV3PoolDerivedState.sol';
import './pool/ISynthraV3PoolActions.sol';
import './pool/ISynthraV3PoolOwnerActions.sol';
import './pool/ISynthraV3PoolEvents.sol';

/// @title The interface for a Synthra V3 Pool
/// @notice A Synthra pool facilitates swapping and automated market making between any two assets that strictly conform
/// to the ERC20 specification
/// @dev The pool interface is broken up into many smaller pieces
interface ISynthraV3Pool is
    ISynthraV3PoolImmutables,
    ISynthraV3PoolState,
    ISynthraV3PoolDerivedState,
    ISynthraV3PoolActions,
    ISynthraV3PoolOwnerActions,
    ISynthraV3PoolEvents
{

}
