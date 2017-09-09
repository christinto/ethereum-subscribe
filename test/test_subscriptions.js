var Subscriptions = artifacts.require("Subscriptions");

contract("Subscriptions", function(accounts) {

    var mary = accounts[0];
    var joe = accounts[1];
    var sara = accounts[2];

    var manager = mary;

    it("should set joe as manager", function() {

        var sub;

        return Subscriptions.deployed().then(function(instance) {

            sub = instance;

            return sub.setManager(joe, {from: manager});

        }).then(function(retval) {

            return sub.getManager();

        }).then(function(retval) {

            assert.equal(retval, joe);
            manager = joe;

        });

    });

    it("should allow sara to makePayment for 2018-08", function() {

        var sub;

        return Subscriptions.deployed().then(function(instance) {

            sub = instance;

            return sub.makePayment(2018, 8, {from: sara, value: web3.toWei(0.5, "ether")});

        }).then(function(retval) {

            return sub.getPayment(sara, 2018, 8);

        }).then(function(retval) {

            assert.equal(retval, web3.toWei(0.5, "ether"));

        });

    });

    it("should allow mary to makePayment for the current month", function() {

        var sub;

        return Subscriptions.deployed().then(function(instance) {

            sub = instance;

            return web3.eth.sendTransaction({
                from: mary, 
                to: Subscriptions.address, 
                value: web3.toWei(1, "ether")
            });

        }).then(function(retval) {

            return sub.paidUp(mary);

        }).then(function(retval) {

            assert.equal(parseInt(retval), web3.toWei(1, "ether"));

        });

    });

    it("should have a balance of 1.5ETH", function() {

        return Subscriptions.deployed().then(function() {

            return web3.eth.getBalance(Subscriptions.address)

        }).then(function(retval) {

            assert.equal(parseInt(web3.toWei(1.5, "ether")), parseInt(retval));

        });

    });

    it("should allow manager to withdraw", function() {

        var sub;
        var startingBalance = parseInt(web3.eth.getBalance(manager));

        return Subscriptions.deployed().then(function(instance) {

            sub = instance;

            return sub.withdraw({from: manager});

        }).then(function(retval) {

            // Just get the first 4 digits for comparison.  This leaves room for
            // fees from the withdraw function
            var calculated = (startingBalance + parseInt(web3.toWei(1.5, "ether"))).toString().slice(0,4);
            var res = web3.eth.getBalance(manager);
            var current = String(res).slice(0,4);
            assert.equal(calculated, current);

        });

    });

    it("should allow manager to use the escape hatch", function() {

        var sub;
        var startingBalance = parseInt(web3.eth.getBalance(manager));

        return Subscriptions.deployed().then(function(instance) {

            sub = instance;

            return sub.escape({from: manager});

        }).then(function(retval) {

            return sub.isAlive();

        }).then(function(retval) {

            assert.isFalse(retval);
            assert.equal(web3.eth.getBalance(Subscriptions.address), 0);

        });

    });

});