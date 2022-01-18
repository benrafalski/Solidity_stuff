from brownie import Lottery, accounts, config, network
from scripts.deploy_lottery import deploy_lottery
from scripts.helpful_scripts import LOCAL_BLOCKCHAIN_ENVIORNMENTS
from web3 import Web3
import pytest

def test_get_entrance_fee():
    if network.show_active() not in LOCAL_BLOCKCHAIN_ENVIORNMENTS:
        pytest.skip()
    lottery = deploy_lottery()
    excepted_entrance_fee = Web3.toWei(0.025, "ether")
    entrance_fee = lottery.getEntranceFee()
    assert excepted_entrance_fee == entrance_fee