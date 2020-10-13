const Web3 = require("web3");
const Asset_Management = require("./build/contracts/Asset_Management.json");

const init = async () => {
  const web3 = new Web3("http://127.0.0.1:7545");
  const id = await web3.eth.net.getId();
  const deployedNetwork = Asset_Management.networks[id];
  const contract = new web3.eth.Contract(
    Asset_Management.abi,
    deployedNetwork.address
  );

  const addressess = await web3.eth.getAccounts();
  const receipt = await contract.methods
    .addAssetManagementOffice("Hey", "Whatsapp")
    .send({
      from: addressess[0],
      gas: 300000,
    });

  const data = await contract.methods.viewAssetManagementOffice(1).call({
    from: addressess[0],
    gas: 300000,
  });
  console.log(receipt);
  console.log(data);
};

init();
