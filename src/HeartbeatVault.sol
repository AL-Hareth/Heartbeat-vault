// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.37;

error Unauthorized(address caller);
error InvalidAmount(uint256 amount); 
error InvalidInterval(uint256 interval); 
error PastTimeLimit(uint256 timeLimit);
error BeforeTimeLimit(uint256 timeLimit);
error AlreadyClaimed();
error WrongBeneficiary(address wrongBeneficiaryAddress);
error SendingFailed(address receiverAddress, uint256 amount);
error EmptyVault();

contract HeartbeatVault {
    address immutable vaultOwner;
    uint256 public lastCheckIn;
    address public beneficiary;
    uint256 interval;
    uint256 gracePeriod;
    bool claimed;

    event SetBeneficiary(address indexed beneficiaryAddress);
    event Deposited(uint256 amount);
    event Withdrawn(uint256 amount);
    event Claimed(uint256 amount, address indexed beneficiaryAddress);
    event CheckedIn();
    event ChangedInterval(uint256 newInterval);
    event ChangedGracePeriod(uint256 newGracePeriod);

    modifier onlyOwner() {
        if (msg.sender != vaultOwner) {
            revert Unauthorized({ caller: msg.sender });
        }
        _;
    }

    modifier onlyBeneficiary() {
        if (msg.sender != beneficiary) {
            revert Unauthorized({ caller: msg.sender });
        }
        _;
    }

    modifier notExpired() {
        if(block.timestamp > expiryTimestamp()) {
            revert PastTimeLimit({ timeLimit: expiryTimestamp() });
        }
        _;
    }

    constructor(address _beneficiary, uint256 _interval, uint256 _gracePeriod) {
        vaultOwner = msg.sender;
        lastCheckIn = block.timestamp;
        beneficiary = _beneficiary;
        interval = _interval;
        gracePeriod = _gracePeriod;
        claimed = false;
    }

    function expiryTimestamp() public view returns(uint256) {
        return deadline() + gracePeriod;
    }

    function setBeneficiary(address _beneficiary) public onlyOwner notExpired {
    }

    receive() external payable onlyOwner notExpired {
    }

    function withdraw(uint256 amount) public onlyOwner notExpired {
    }

    function claim() public onlyBeneficiary {
    }

    function checkIn() public onlyOwner notExpired {
    }

    function changeInterval(uint256 newInterval) public onlyOwner notExpired {
    }

    function changeGracePeriod(uint256 period) public onlyOwner notExpired {
    }

    function deadline() public view returns(uint256) {
    }

    function vaultStatus() public view returns(bool) {
    }

}
