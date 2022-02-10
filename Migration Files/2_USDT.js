const USDTToken = artifacts.require('USDTToken');

module.exports = function (deployer) {
    deployer.deploy(USDTToken);
};
