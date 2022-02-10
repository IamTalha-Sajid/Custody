const custodyn = artifacts.require('custodyn');

module.exports = function (deployer) {
    deployer.deploy(custodyn);
};
