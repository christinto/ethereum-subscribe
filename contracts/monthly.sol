pragma solidity ^0.4.15;

/*  Copyright 2017 Mike Shultz

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Lesser General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

import "./DateTime.sol";

/** MonthlySubscriptions

    Contract that takes payment for monthly subscriptions
 */
contract MonthlySubscriptions {

    struct Subscriber {
        bool exists;
        mapping (uint32 => uint) paid;
    }

    bool internal alive;
    address internal manager;
    DateTime internal datetime;
    mapping (address => Subscriber) subscribers;

    /* Payment event
     *
     * @dev Signals a payment has been made for a specific month.
     * @param by  Who sent the payment
     * @param amount  The amount paid in Wei
     * @param formonth  The integer representation of the month(YYYYMM)
     */
    event Payment(
        address by,
        uint amount,
        uint formonth
    );

    /**
     * Only a certain address can use this modified method
     * @param by The address that can use the method
     */
    modifier onlyBy(address by) { 
        require(msg.sender == by);
        _; 
    }

    /**
     * Method can only be used when contract is "alive"
     */
    modifier requireAlive() { 
        require(alive == true);
        _; 
    }

    /* Constructor
     * @param _manager  The account that has full control over this contract 
     */
    function MonthlySubscriptions(address _manager, address _datetime) {
        manager = _manager;
        datetime = DateTime(_datetime);
        alive = true;
    }

    /* isAlive
     * @dev Get the "alive" status for this contract
     */
    function isAlive() constant returns (bool) {
        // Send all value to the manager
        return alive;
    }

    /* makePayment
     * @dev Take payment for a subscriber.  This method uses `tx.origin` since 
     * we want to authenticate against an account, not a contract.  This also 
     * allows the user to setup whatever kind of payment contract they want.
     */
    function makePayment(uint16 year, uint8 month) public payable requireAlive {
        require(msg.value > 0);

        // Do we not know about this account?
        if (subscribers[tx.origin].exists != true) {

            // Save new Subscriber object 
            subscribers[tx.origin] = Subscriber(true);

        }

        // Set paid date
        subscribers[tx.origin].paid[year * 100 + month] = msg.value;

    }

    /* isPaid
     * @dev Has the account paid for the month?
     */
    function paidUp(address who) constant returns (uint) {
        // Send all value to the manager
        return subscribers[who].paid[uint32(datetime.getYear(now) * 100 + datetime.getMonth(now))];
    }

    /* getPayment
     * @dev Has the account paid for the specific month?
     */
    function getPayment(address who, uint16 year, uint8 month) constant returns (uint) {
        // Send all value to the manager
        return subscribers[who].paid[uint32(year * 100 + month)];
    }

    /* getManager
     * @dev Get the managing account for this contract
     */
    function getManager() constant returns (address) {
        // Send all value to the manager
        return manager;
    }

    /* setManager
     * @dev Change the managing account for this contract
     */
    function setManager(address newManager) external onlyBy(manager) requireAlive {
        // Send all value to the manager
        manager = newManager;
    }

    /* withdraw
     * @dev Drain all value from this contract
     */
    function withdraw() external onlyBy(manager) {
        // Send all value to the manager
        manager.transfer(this.balance);
    }

    /* escape
     * @dev Drain all value from this contract and disable it
     */
    function escape() external onlyBy(manager) {
        // Disable ourselves
        alive = false;
        // Send all value to the manager
        manager.transfer(this.balance);
    }

    /* Default Function 
     * @dev Handle any raw payment to this contract
     */
    function () payable requireAlive {

        // Assume they're a subscriber making a payment
        if (msg.value > 0) {

            makePayment(datetime.getYear(now), datetime.getMonth(now));

        }
    }

}