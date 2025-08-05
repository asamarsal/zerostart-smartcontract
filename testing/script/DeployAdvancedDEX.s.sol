// ============ Foundry Deployment Script ============
// script/DeployAdvancedDEX.s.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Script.sol";
import "../src/AdvancedDEX.sol";

contract DeployAdvancedDEX is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address tokenA = vm.envAddress("TOKEN_A_ADDRESS"); // Your ZERO token
        address tokenB = vm.envAddress("TOKEN_B_ADDRESS"); // USDT address
        uint256 rewardPerSecond = vm.envUint("REWARD_PER_SECOND"); // e.g., 1000000000000000 (0.001 tokens per second)
        
        vm.startBroadcast(deployerPrivateKey);
        
        AdvancedDEX dex = new AdvancedDEX(tokenA, tokenB, rewardPerSecond);
        
        console.log("AdvancedDEX deployed to:", address(dex));
        console.log("Token A (ZERO):", tokenA);
        console.log("Token B (USDT):", tokenB);
        console.log("Reward per second:", rewardPerSecond);
        
        vm.stopBroadcast();
    }
}

// ============ TypeScript Types & ABI ============

export const ADVANCED_DEX_ABI = [
  // ====== Core AMM Functions ======
  {
    "inputs": [
      {"internalType": "uint256", "name": "amountA", "type": "uint256"},
      {"internalType": "uint256", "name": "amountB", "type": "uint256"},
      {"internalType": "uint256", "name": "minLPTokens", "type": "uint256"}
    ],
    "name": "addLiquidity",
    "outputs": [{"internalType": "uint256", "name": "lpTokens", "type": "uint256"}],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      {"internalType": "uint256", "name": "lpTokens", "type": "uint256"},
      {"internalType": "uint256", "name": "minAmountA", "type": "uint256"},
      {"internalType": "uint256", "name": "minAmountB", "type": "uint256"}
    ],
    "name": "removeLiquidity",
    "outputs": [
      {"internalType": "uint256", "name": "amountA", "type": "uint256"},
      {"internalType": "uint256", "name": "amountB", "type": "uint256"}
    ],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      {"internalType": "uint256", "name": "amountAIn", "type": "uint256"},
      {"internalType": "uint256", "name": "minAmountBOut", "type": "uint256"}
    ],
    "name": "swapAforB",
    "outputs": [{"internalType": "uint256", "name": "amountBOut", "type": "uint256"}],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      {"internalType": "uint256", "name": "amountBIn", "type": "uint256"},
      {"internalType": "uint256", "name": "minAmountAOut", "type": "uint256"}
    ],
    "name": "swapBforA",
    "outputs": [{"internalType": "uint256", "name": "amountAOut", "type": "uint256"}],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  
  // ====== Staking Functions ======
  {
    "inputs": [{"internalType": "uint256", "name": "amount", "type": "uint256"}],
    "name": "stakeLPTokens",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [{"internalType": "uint256", "name": "amount", "type": "uint256"}],
    "name": "unstakeLPTokens",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "claimRewards",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },

  // ====== View Functions ======
  {
    "inputs": [{"internalType": "uint256", "name": "amountAIn", "type": "uint256"}],
    "name": "getQuoteAforB",
    "outputs": [
      {"internalType": "uint256", "name": "amountBOut", "type": "uint256"},
      {"internalType": "uint256", "name": "fee", "type": "uint256"}
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [{"internalType": "uint256", "name": "amountBIn", "type": "uint256"}],
    "name": "getQuoteBforA",
    "outputs": [
      {"internalType": "uint256", "name": "amountAOut", "type": "uint256"},
      {"internalType": "uint256", "name": "fee", "type": "uint256"}
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "getPriceAinB",
    "outputs": [{"internalType": "uint256", "name": "", "type": "uint256"}],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "getPriceBinA",
    "outputs": [{"internalType": "uint256", "name": "", "type": "uint256"}],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [{"internalType": "address", "name": "user", "type": "address"}],
    "name": "getPendingRewards",
    "outputs": [{"internalType": "uint256", "name": "", "type": "uint256"}],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "getCurrentAPR",
    "outputs": [{"internalType": "uint256", "name": "", "type": "uint256"}],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "getPoolInfo",
    "outputs": [{
      "components": [
        {"internalType": "address", "name": "tokenA", "type": "address"},
        {"internalType": "address", "name": "tokenB", "type": "address"},
        {"internalType": "string", "name": "tokenASymbol", "type": "string"},
        {"internalType": "string", "name": "tokenBSymbol", "type": "string"},
        {"internalType": "uint256", "name": "reserveA", "type": "uint256"},
        {"internalType": "uint256", "name": "reserveB", "type": "uint256"},
        {"internalType": "uint256", "name": "totalLiquidity", "type": "uint256"},
        {"internalType": "uint256", "name": "totalStaked", "type": "uint256"},
        {"internalType": "uint256", "name": "currentAPR", "type": "uint256"},
        {"internalType": "uint256", "name": "priceAinB", "type": "uint256"},
        {"internalType": "uint256", "name": "priceBinA", "type": "uint256"}
      ],
      "internalType": "struct AdvancedDEX.PoolInfo",
      "name": "",
      "type": "tuple"
    }],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [{"internalType": "address", "name": "user", "type": "address"}],
    "name": "getUserInfo",
    "outputs": [{
      "components": [
        {"internalType": "uint256", "name": "lpBalance", "type": "uint256"},
        {"internalType": "uint256", "name": "stakedAmount", "type": "uint256"},
        {"internalType": "uint256", "name": "pendingRewards", "type": "uint256"},
        {"internalType": "uint256", "name": "stakingTime", "type": "uint256"},
        {"internalType": "uint256", "name": "shareOfPool", "type": "uint256"}
      ],
      "internalType": "struct AdvancedDEX.UserInfo",
      "name": "",
      "type": "tuple"
    }],
    "stateMutability": "view",
    "type": "function"
  },

  // ====== State Variables ======
  {
    "inputs": [],
    "name": "reserveA",
    "outputs": [{"internalType": "uint256", "name": "", "type": "uint256"}],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "reserveB",
    "outputs": [{"internalType": "uint256", "name": "", "type": "uint256"}],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "totalLPSupply",
    "outputs": [{"internalType": "uint256", "name": "", "type": "uint256"}],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [{"internalType": "address", "name": "", "type": "address"}],
    "name": "lpBalances",
    "outputs": [{"internalType": "uint256", "name": "", "type": "uint256"}],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [{"internalType": "address", "name": "", "type": "address"}],
    "name": "stakedLP",
    "outputs": [{"internalType": "uint256", "name": "", "type": "uint256"}],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "totalStaked",
    "outputs": [{"internalType": "uint256", "name": "", "type": "uint256"}],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "rewardPerSecond",
    "outputs": [{"internalType": "uint256", "name": "", "type": "uint256"}],
    "stateMutability": "view",
    "type": "function"
  }
] as const;

// ============ TypeScript Types ============

export interface PoolInfo {
  tokenA: string;
  tokenB: string;
  tokenASymbol: string;
  tokenBSymbol: string;
  reserveA: bigint;
  reserveB: bigint;
  totalLiquidity: bigint;
  totalStaked: bigint;
  currentAPR: bigint;
  priceAinB: bigint;
  priceBinA: bigint;
}

export interface UserInfo {
  lpBalance: bigint;
  stakedAmount: bigint;
  pendingRewards: bigint;
  stakingTime: bigint;
  shareOfPool: bigint;
}

// ============ React Hooks untuk Wagmi + Viem ============

import { useReadContract, useReadContracts, useWriteContract, useWaitForTransactionReceipt } from 'wagmi';
import { formatUnits, parseUnits } from 'viem';
import { useMemo } from 'react';

// Configuration
export const DEX_ADDRESS = '0xYourDeployedDEXAddress'; // Update after deployment
export const LISK_SEPOLIA_CHAIN_ID = 4202;

// ====== Hook untuk Pool Data ======
export function usePoolData() {
  const { data: poolInfo, isLoading, error, refetch } = useReadContract({
    address: DEX_ADDRESS,
    abi: ADVANCED_DEX_ABI,
    functionName: 'getPoolInfo',
    chainId: LISK_SEPOLIA_CHAIN_ID,
  });

  const processedData = useMemo(() => {
    if (!poolInfo) return null;

    const info = poolInfo as PoolInfo;
    
    return {
      tokenA: info.tokenA,
      tokenB: info.tokenB,
      tokenASymbol: info.tokenASymbol,
      tokenBSymbol: info.tokenBSymbol,
      reserveA: parseFloat(formatUnits(info.reserveA, 18)),
      reserveB: parseFloat(formatUnits(info.reserveB, 6)), // Assuming USDT 6 decimals
      totalLiquidity: parseFloat(formatUnits(info.totalLiquidity, 18)),
      totalStaked: parseFloat(formatUnits(info.totalStaked, 18)),
      currentAPR: Number(info.currentAPR) / 100, // Convert from basis points to percentage
      priceAinB: parseFloat(formatUnits(info.priceAinB, 18)),
      priceBinA: parseFloat(formatUnits(info.priceBinA, 18)),
      totalLiquidityUSD: parseFloat(formatUnits(info.reserveA, 18)) * parseFloat(formatUnits(info.priceAinB, 18)) * 2,
    };
  }, [poolInfo]);

  return {
    data: processedData,
    isLoading,
    error,
    refetch,
  };
}

// ====== Hook untuk User Data ======
export function useUserData(userAddress?: string) {
  const { data: userInfo, isLoading, error, refetch } = useReadContract({
    address: DEX_ADDRESS,
    abi: ADVANCED_DEX_ABI,
    functionName: 'getUserInfo',
    args: userAddress ? [userAddress] : undefined,
    chainId: LISK_SEPOLIA_CHAIN_ID,
    enabled: !!userAddress,
  });

  const processedData = useMemo(() => {
    if (!userInfo) return null;

    const info = userInfo as UserInfo;
    
    return {
      lpBalance: parseFloat(formatUnits(info.lpBalance, 18)),
      stakedAmount: parseFloat(formatUnits(info.stakedAmount, 18)),
      pendingRewards: parseFloat(formatUnits(info.pendingRewards, 18)),
      stakingTime: Number(info.stakingTime),
      shareOfPool: Number(info.shareOfPool) / 100, // Convert from basis points to percentage
    };
  }, [userInfo]);

  return {
    data: processedData,
    isLoading,
    error,
    refetch,
  };
}

// ====== Hook untuk Price Quotes ======
export function useSwapQuote(fromToken: 'A' | 'B', amount: string) {
  const amountBigInt = amount ? parseUnits(amount, fromToken === 'A' ? 18 : 6) : BigInt(0);
  
  const { data: quoteData } = useReadContract({
    address: DEX_ADDRESS,
    abi: ADVANCED_DEX_ABI,
    functionName: fromToken === 'A' ? 'getQuoteAforB' : 'getQuoteBforA',
    args: amount && Number(amount) > 0 ? [amountBigInt] : undefined,
    chainId: LISK_SEPOLIA_CHAIN_ID,
    enabled: amount && Number(amount) > 0,
  });

  const processedQuote = useMemo(() => {
    if (!quoteData || !Array.isArray(quoteData)) return null;

    const [outputAmount, fee] = quoteData;
    const outputDecimals = fromToken === 'A' ? 6 : 18;

    return {
      outputAmount: parseFloat(formatUnits(outputAmount, outputDecimals)),
      fee: parseFloat(formatUnits(fee, fromToken === 'A' ? 18 : 6)),
      priceImpact: 0, // Calculate if needed
    };
  }, [quoteData, fromToken]);

  return processedQuote;
}

// ====== Write Contract Hooks ======
export function useAddLiquidity() {
  const { writeContract, data: hash, isPending, error } = useWriteContract();
  
  const { isLoading: isConfirming, isSuccess } = useWaitForTransactionReceipt({
    hash,
  });

  const addLiquidity = async (amountA: string, amountB: string, slippage: number = 5) => {
    const amountABigInt = parseUnits(amountA, 18);
    const amountBBigInt = parseUnits(amountB, 6);
    
    // Calculate minimum LP tokens with slippage
    const minLPTokens = BigInt(0); // Simplified, should calculate based on current pool
    
    writeContract({
      address: DEX_ADDRESS,
      abi: ADVANCED_DEX_ABI,
      functionName: 'addLiquidity',
      args: [amountABigInt, amountBBigInt, minLPTokens],
    });
  };

  return {
    addLiquidity,
    hash,
    isPending,
    isConfirming,
    isSuccess,
    error,
  };
}

export function useRemoveLiquidity() {
  const { writeContract, data: hash, isPending, error } = useWriteContract();
  
  const { isLoading: isConfirming, isSuccess } = useWaitForTransactionReceipt({
    hash,
  });

  const removeLiquidity = async (lpTokens: string, slippage: number = 5) => {
    const lpTokensBigInt = parseUnits(lpTokens, 18);
    
    // Calculate minimum amounts with slippage (simplified)
    const minAmountA = BigInt(0);
    const minAmountB = BigInt(0);
    
    writeContract({
      address: DEX_ADDRESS,
      abi: ADVANCED_DEX_ABI,
      functionName: 'removeLiquidity',
      args: [lpTokensBigInt, minAmountA, minAmountB],
    });
  };

  return {
    removeLiquidity,
    hash,
    isPending,
    isConfirming,
    isSuccess,
    error,
  };
}

export function useSwap() {
  const { writeContract, data: hash, isPending, error } = useWriteContract();
  
  const { isLoading: isConfirming, isSuccess } = useWaitForTransactionReceipt({
    hash,
  });

  const swap = async (fromToken: 'A' | 'B', amount: string, slippage: number = 5) => {
    const isAtoB = fromToken === 'A';
    const amountBigInt = parseUnits(amount, isAtoB ? 18 : 6);
    
    // Get quote for minimum output calculation
    // This should be done with the quote hook in practice
    const minOutput = BigInt(0); // Simplified
    
    writeContract({
      address: DEX_ADDRESS,
      abi: ADVANCED_DEX_ABI,
      functionName: isAtoB ? 'swapAforB' : 'swapBforA',
      args: [amountBigInt, minOutput],
    });
  };

  return {
    swap,
    hash,
    isPending,
    isConfirming,
    isSuccess,
    error,
  };
}

export function useStaking() {
  const { writeContract, data: hash, isPending, error } = useWriteContract();
  
  const { isLoading: isConfirming, isSuccess } = useWaitForTransactionReceipt({
    hash,
  });

  const stakeLPTokens = async (amount: string) => {
    const amountBigInt = parseUnits(amount, 18);
    
    writeContract({
      address: DEX_ADDRESS,
      abi: ADVANCED_DEX_ABI,
      functionName: 'stakeLPTokens',
      args: [amountBigInt],
    });
  };

  const unstakeLPTokens = async (amount: string) => {
    const amountBigInt = parseUnits(amount, 18);
    
    writeContract({
      address: DEX_ADDRESS,
      abi: ADVANCED_DEX_ABI,
      functionName: 'unstakeLPTokens',
      args: [amountBigInt],
    });
  };

  const claimRewards = async () => {
    writeContract({
      address: DEX_ADDRESS,
      abi: ADVANCED_DEX_ABI,
      functionName: 'claimRewards',
    });
  };

  return {
    stakeLPTokens,
    unstakeLPTokens,
    claimRewards,
    hash,
    isPending,
    isConfirming,
    isSuccess,
    error,
  };
}

// ============ Deployment Commands ============

/*
# .env file
PRIVATE_KEY=your_private_key
TOKEN_A_ADDRESS=0xYourZeroTokenAddress
TOKEN_B_ADDRESS=0xUSDTAddressLiskSepolia
REWARD_PER_SECOND=1000000000000000  # 0.001 tokens per second

# Deploy command
forge script script/DeployAdvancedDEX.s.sol:DeployAdvancedDEX \
    --rpc-url https://rpc.sepolia-api.lisk.com \
    --broadcast \
    --verify

# Add initial liquidity (after deployment)
cast send $DEX_ADDRESS "addLiquidity(uint256,uint256,uint256)" \
    1000000000000000000 \  # 1 ZERO
    1000000 \               # 1 USDT  
    0 \                     # minLPTokens
    --rpc-url https://rpc.sepolia-api.lisk.com \
    --private-key $PRIVATE_KEY

# Check pool info
cast call $DEX_ADDRESS "getPoolInfo()" --rpc-url https://rpc.sepolia-api.lisk.com

# Check price (1 ZERO in USDT)
cast call $DEX_ADDRESS "getPriceAinB()" --rpc-url https://rpc.sepolia-api.lisk.com
*/