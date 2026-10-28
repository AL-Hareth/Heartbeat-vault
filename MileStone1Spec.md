“every owner action counts as a check-in”

# State variables
- address vaultOwner = the address of the person who deployed the contract (msg.sender of the constructor)
- uint256 lastCheckIn = the last time the owner checked in (defaults to now on deployment)
- address beneficiary = the address of the single beneficiary (constructor argument)
- uint256 interval = the initial timeframe before starting the grace perdiod. (constructor argument)
- uint256 gracePeriod = the grace period after the deadline. (constructor argument)
- bool claimed = set to true when the beneficiary claims the ETH (only-once policy)
 
the only immutable one of these is the vault_owner

# Modefiers
- onlyOwner: self explained
- onlyBeneficiary: self explained
- afterDeadline: a modifier the returns true if we are past the deadline.

# Functions
|Function| Who can call | Payable? | Reverts When | State Changes | Event |
|--------|--------------|----------|--------------|---------------|-------|
| constructor | owner of course | no | invalid beneficiary address, invalid interval | vaultOwner, lastCheckIn, beneficiary, interval, gracePeriod, claimed | nothing |
| setBeneficiary(address beneficiary) | onlyOwner | no | invalid address like 0, past deadline + grace, owner as beneficiary | beneficiary, lastCheckIn | SetBeneficiary(address indexed beneficiary) |
| receive() | onlyOwner | yes | past deadline + grace, non-owner call, 0 ETH | lastCheckIn | Deposited(uint256 indexed amount) |
| withdraw(uint256 amount) | onlyOwner | no | sending fails, past deadline + grace, amount > balance | lastCheckIn | Withdrawn(uint256 indexed amount) |
| claim() | onlyBeneficiary | no | no balance, before deadline + grace, already claimed, sending fails | claimed | Claimed(address indexed beneficiary, uint256 amount) |
| checkIn() | onlyOwner | no | past deadline + grace | lastCheckIn | CheckedIn() |
| changeInterval(uint256 newInterval) | onlyOwner | no | non-owner call, 0 interval, past deadline + grace | interval, lastCheckIn | ChangedInterval(uint256 indexed newInterval) |
| changeGrace(uint256 newGracePeriod) | onlyOwner | no | non-owner call | gracePeriod, lastCheckIn, past deadline + grace | ChangedGracePeriod(uint256 indexed period) |
| deadline() view | anyone | no | nothing | nothing | nothing |
| vaultStatus() view | anyone | no | nothing | nothing | nothing |

# Errors
| Error name | Parameters | used in which functions |
|------------|------------|-------------------------|
| Unauthorized | address caller | setBeneficiary, receive, withdraw, claim, checkIn, changeInterval, changeGrace |
| InvalidAmount | uint256 amount | constructor, receive, withdraw |
| InvalidInterval | uint256 interva | constructor, changeInterval |
| PastTimeLimit | uint256 timeLimit | setBeneficiary, receive, withdraw, checkIn, changeInterval, changeGrace |
| BeforeTimeLimit | uint256 timeLimit | claim |
| AlreadyClaimed | empty | claim |
| WrongBeneficiary | address beneficiary | constructor, setBeneficiary |
| SendingFailed | address receiverAddress, uint256 amount | claim, withdraw |
| EmptyVault | empty | claim |

the beneficiary can claim tokens strictly after the time limit.
