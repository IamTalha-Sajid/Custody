const USDCToken = artifacts.require('USDCToken');

module.exports = function (deployer) {
    deployer.deploy(USDCToken);
};
