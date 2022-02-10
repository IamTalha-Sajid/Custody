const PAXToken = artifacts.require('PAXToken');

module.exports = function (deployer) {
    deployer.deploy(PAXToken);
};
