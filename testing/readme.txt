Perintah Deploy Dex AMM :
forge script script/DeployDEXAMMPool.s.sol:DeployDEXAMMPool \
    --rpc-url https://rpc.sepolia-api.lisk.com \
    --broadcast \
    --verify
    
Contoh berhasil :
 == Logs ==
  === FIXED DEX AMM Pool Deployment ===
  Deployer address: 0x3eEDe3FE85f32d013e368d02db07C0662390EADd
  ZeroStart Token: 0x0E5cf4661Bc46dA84Efb649Ce2f5c0Ee3C47c3B2
  USDT Token: 0x2728DD8B45B788e26d12B13Db5A244e5403e7eda
  Network: Lisk Sepolia
  
  === Deployment Successful ===
  DEXAMMPool deployed at: 0x91EB5Dd37767925c7E764F9DC08ecBbe3Ed56f88
  Owner: 0x3eEDe3FE85f32d013e368d02db07C0662390EADd
  Token A: 0x0E5cf4661Bc46dA84Efb649Ce2f5c0Ee3C47c3B2
  Token B: 0x2728DD8B45B788e26d12B13Db5A244e5403e7eda
  Trading Fee: 30 basis points
  Reward Rate: 1000 basis points
  === Contract Verification Info ===
  Contract Address: 0x91EB5Dd37767925c7E764F9DC08ecBbe3Ed56f88
  Constructor Args:
    _tokenA: 0x0E5cf4661Bc46dA84Efb649Ce2f5c0Ee3C47c3B2
    _tokenB: 0x2728DD8B45B788e26d12B13Db5A244e5403e7eda


Perintah Add Liquidity :
forge script script/AddLiquidityAMM.s.sol:AddLiquidityScript \
    --rpc-url https://rpc.sepolia-api.lisk.com \
    --broadcast

Perintah Remove Liquidity :
forge script script/RemoveLiquidityAMM.s.sol:RemoveLiquidityScript \
    --rpc-url https://rpc.sepolia-api.lisk.com \
    --broadcast

Cek Pool Info :
cast call 0x91EB5Dd37767925c7E764F9DC08ecBbe3Ed56f88 \
    "getPoolInfo()" \
    --rpc-url https://rpc.sepolia-api.lisk.com

Cek LP Token Balance Anda :
cast call 0x91EB5Dd37767925c7E764F9DC08ecBbe3Ed56f88 \
    "balanceOf(address)" 0x3eEDe3FE85f32d013e368d02db07C0662390EADd \
    --rpc-url https://rpc.sepolia-api.lisk.com