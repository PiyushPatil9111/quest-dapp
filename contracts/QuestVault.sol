// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ISimpleERC20 {
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function transfer(address recipient, uint256 amount) external returns (bool);
}

contract QuestVault {
    ISimpleERC20 public immutable fUSDC;
    uint public constant TOKEN_DECIMALS = 6; // Set to your fUSDC decimals (e.g., 6 or 18)
    uint public constant PENALTY_PERCENT = 5; // 5% penalty
    uint public penaltyPool; // <<< Bonus Pool re-added

    struct VaultInfo {
        uint target;    // Smallest unit
        uint deadline;  // Timestamp
        uint saved;     // Smallest unit
        bool active;
    }
    mapping(address => VaultInfo) public userVaults;

    event VaultCreated(address indexed user, uint target, uint deadline);
    event DepositMade(address indexed user, uint amount);
    event WithdrewEarly(address indexed user, uint amountReturned, uint penalty);
    event GoalCompleted(address indexed user, uint amountReturned, uint bonus); // <<< Bonus in event

    constructor(address _fUSDC_address) {
        require(_fUSDC_address != address(0), "Invalid fUSDC address");
        fUSDC = ISimpleERC20(_fUSDC_address);
    }

    function createVault(uint _targetAmountHuman, uint _days) external {
        require(!userVaults[msg.sender].active, "Vault exists");
        require(_days > 0, "Days must be > 0");

        uint targetSmallestUnit = _targetAmountHuman * (10**TOKEN_DECIMALS);
        require(targetSmallestUnit > 0, "Target must be > 0");

        uint deadlineTimestamp = block.timestamp + (_days * 1 days);

        userVaults[msg.sender] = VaultInfo(targetSmallestUnit, deadlineTimestamp, 0, true);
        emit VaultCreated(msg.sender, targetSmallestUnit, deadlineTimestamp);
    }

    function deposit(uint _amountHuman) external {
        VaultInfo storage vault = userVaults[msg.sender];
        require(vault.active && block.timestamp < vault.deadline, "Deposit invalid state");
        require(_amountHuman > 0, "Deposit amount zero");

        uint amountSmallestUnit = _amountHuman * (10**TOKEN_DECIMALS);
        bool success = fUSDC.transferFrom(msg.sender, address(this), amountSmallestUnit);
        require(success, "fUSDC transferFrom failed");

        vault.saved += amountSmallestUnit;
        emit DepositMade(msg.sender, amountSmallestUnit);
    }

    function withdrawEarly() external {
        VaultInfo storage vault = userVaults[msg.sender];
        require(vault.active && block.timestamp < vault.deadline, "Withdraw invalid state");
        require(vault.saved > 0, "Nothing saved");

        uint savedAmount = vault.saved;
        uint penalty = (savedAmount * PENALTY_PERCENT) / 100;
        uint returnAmt = savedAmount - penalty;

        // Delete vault state before transfer
        delete userVaults[msg.sender];

        penaltyPool += penalty; // <<< Add penalty to the pool

        if (returnAmt > 0) {
            bool success = fUSDC.transfer(msg.sender, returnAmt);
            require(success, "fUSDC transfer failed");
        }
        emit WithdrewEarly(msg.sender, returnAmt, penalty);
    }

    function completeGoal() external {
         VaultInfo storage vault = userVaults[msg.sender];
         require(vault.active && block.timestamp >= vault.deadline && vault.saved >= vault.target, "Complete invalid state");

         uint savedAmount = vault.saved;
         uint bonus = 0; // <<< Calculate bonus

         // Basic bonus: 10% of pool, capped at pool amount
         if (penaltyPool > 0) {
            bonus = penaltyPool / 10;
            if (bonus > penaltyPool) { // Ensure we don't try to give more than exists
                bonus = penaltyPool;
            }
         }
         uint returnAmt = savedAmount + bonus; // <<< Add bonus

         // Delete vault state before transfers
         delete userVaults[msg.sender];

         // Reduce pool *before* transfer if bonus is given
         if (bonus > 0) {
             penaltyPool -= bonus; // <<< Decrease pool
         }

         if (returnAmt > 0) {
             bool success = fUSDC.transfer(msg.sender, returnAmt);
             require(success, "fUSDC transfer failed");
         }
         emit GoalCompleted(msg.sender, returnAmt, bonus); // <<< Emit bonus
    }

    function checkMyVault() external view returns (uint target, uint deadline, uint saved, bool active) {
        VaultInfo storage v = userVaults[msg.sender];
        return (v.target, v.deadline, v.saved, v.active);
    }
}