// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract Ropstam is ERC20 {
    using SafeMath for uint256;

    uint256 public constant TOKEN_PRICE = 100 wei;
    uint256 public constant INITIAL_SUPPLY = 1000000 * 10**18; // 1,000,000 Ropstam tokens

    address private owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the contract owner can call this function");
        _;
    }

    constructor() ERC20("Ropstam", "ROP") {
        _mint(msg.sender, INITIAL_SUPPLY);
        owner = msg.sender;
    }

    function buyTokens(uint256 amount) external payable {
        require(amount > 0, "Amount should be greater than zero");
        require(msg.value >= amount.mul(TOKEN_PRICE), "Insufficient Ether");

        _mint(msg.sender, amount);
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        uint256 deflationAmount = amount.div(100); // 1% deflation on every transfer
        _burn(msg.sender, deflationAmount);

        return super.transfer(recipient, amount.sub(deflationAmount));
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        uint256 deflationAmount = amount.div(100); // 1% deflation on every transfer
        _burn(sender, deflationAmount);

        return super.transferFrom(sender, recipient, amount.sub(deflationAmount));
    }

    function withdraw() external onlyOwner {
        payable(owner).transfer(address(this).balance);
    }
}
