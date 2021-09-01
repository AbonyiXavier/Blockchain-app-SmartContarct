pragma solidity ^0.5.0;



//handles all business logic, read and write from the blockchain
contract Marketplace {
    string public name;  // declaring state variables called name 

    uint public productCount = 0;  // knowing how many product exist by increasing the id by 1

    // mapping is a key value pair relationship from the model, where id is the key and Product is the value
     mapping(uint => Product) public products;


    // struct: Model of the product item 
    struct Product {
        uint id;
        string name;
        uint price;
        address payable owner;
        bool purchased;
    }

// model used to triger event
    event ProductCreated(
        uint id,
        string name,
        uint price,
        address payable owner,
        bool purchased
    );


    event ProductPurchased(
        uint id,
        string name,
        uint price,
        address payable owner,
        bool purchased
    );

    // function inside the contract that runs once when the smart contract is deployed
    constructor() public {
        name = "My first blockchain learning";
    }

    function createProduct(string memory _name, uint _price) public {
        // Require a valid name
        require(bytes(_name).length > 0);
        // Require a valid price
        require(_price > 0);
        // increment productCount
        productCount ++;
        // Create the product
        products[productCount] = Product(productCount, _name, _price, msg.sender, false);
        // Trigger an event: is helpful to print the  logs of the created products
        emit ProductCreated(productCount, _name, _price, msg.sender, false);

    }


    function purchaseProduct(uint _id) public payable{
        //Fetch the product
        Product memory _product = products[_id];
        // Fetch the owner
        address payable _seller = _product.owner;
        // make sure the product has a valid id
        require(_product.id > 0 && _product.id <= productCount);
        // Require that there is enough Ether in the transaction
        require(msg.value >= _product.price);
        // Require that the product has not been purchased already
        require(!_product.purchased);
        // Require the buyer is not the seller
        require(_seller != msg.sender);
        // Purchase it: Transfer of ownership to the buyer
        _product.owner = msg.sender;
        //Mark as purchased
        _product.purchased = true;
        // Update  the product: putting backe to the Product mapping 
        products[_id] = _product;
        // Pay the seller by sending them Ether
        address(_seller).transfer(msg.value); // the amount of Ether been sent on the function call to seller
        // Trigger an event
        emit ProductPurchased(productCount, _product.name, _product.price, msg.sender, true);
    }
}