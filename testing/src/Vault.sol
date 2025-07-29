// pragma solidity ^0.8.20;

// import { ERC20 } from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
// import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
// import { ISwapRouter } from "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";

// interface IVault {
//     function deposit(uint256 amount) external;
//     function withdraw(uint256 shares) external;
//     function distributeYield(uint256 amount) external;
// }

// interface AggregatorV3Interface {

//   function decimals() external view returns (uint8);
//   function description() external view returns (string memory);
//   function version() external view returns (uint256);

//   function getRoundData(uint80 _roundId)
//     external
//     view
//     returns (
//       uint80 roundId,
//       int256 answer,
//       uint256 startedAt,
//       uint256 updatedAt,
//       uint80 answeredInRound
//     );
//   function latestRoundData()
//     external
//     view
//     returns (
//       uint80 roundId,
//       int256 answer,
//       uint256 startedAt,
//       uint256 updatedAt,
//       uint80 answeredInRound
//     );

// }