# ethereum-subscribe

Contract to handle subscriptions.

## MonthlySubscriptions

This contract handles monthly subscriptions based on calendar months.  If your
subscription doesn't follow the calendar, you would need to keep track of the 
day of month on your other systems.

### event Payment

This event is emitted when a payment is made to the contract.

 - `by` is and `address` containing who made the payment
 - `amount` is a `uint`
 - `formonth` is a uint representing the month of the year(1-12)

### function getPayment

Returning a `uint` representing the amount the subscriber has paid for a 
specific month.

#### Parameters

 - `address who` - `address` of the subject account
 - `uint16 year` - The year
 - `uint8 month` - The month of the year

### function [default]

The default function when sending value to the contract.  This allows a 
subscriber to pay for the current month.

    eth.sendTransaction({from: accounts[0], to: subscriptionContract, value: subscriptionCost, gas: 50000})

### function makePayment

Allows a subscriber to make a payment for a specific month.

#### Parameters

 - `uint16 year` - The year
 - `uint8 month` - The month of the year

### function isAlive

Returns `bool` representing whether or not the contract is "alive".  A contract
that is not "alive" can not accept payments.

### function paidUp

Returning a `bool` this function tells us if the user is paid up for the current
month.

#### Parameters

 - `who` `address` of the subject account

### function getManager

Returns the current manager's `address`.

### function setManager

Sets the manager of the contract.

#### Parameters

 - `address newManager` - `address` of the new managing account

### function withdraw

Withdraw the full balance of the contract.

### function escape

Withdraw the full balance of the contract and disable it.




