Solidity
pragma solidity ^0.8.0;

contract DecentralizedAPIServiceController {
    // Mapping of API endpoints to their implementations
    mapping(string => address) public apiEndpoints;

    // Mapping of authorized API keys to their permissions
    mapping(string => mapping(string => bool)) public authorizedApiKeys;

    // Event emitted when a new API endpoint is registered
    event RegisterAPIEndpoint(string endpoint, address implementation);

    // Event emitted when an API key is authorized
    event AuthorizeAPIKey(string apiKey, string permission);

    // Event emitted when an API request is received
    event APIRequestReceived(string endpoint, string apiKey, string request);

    // Event emitted when an API response is sent
    event APIResponseSent(string endpoint, string apiKey, string response);

    // Function to register a new API endpoint
    function registerAPIEndpoint(string memory _endpoint, address _implementation) public {
        apiEndpoints[_endpoint] = _implementation;
        emit RegisterAPIEndpoint(_endpoint, _implementation);
    }

    // Function to authorize an API key
    function authorizeAPIKey(string memory _apiKey, string memory _permission) public {
        authorizedApiKeys[_apiKey][_permission] = true;
        emit AuthorizeAPIKey(_apiKey, _permission);
    }

    // Function to process an API request
    function processAPIRequest(string memory _endpoint, string memory _apiKey, string memory _request) public {
        require(apiEndpoints[_endpoint] != address(0), "API endpoint not registered");
        require(authorizedApiKeys[_apiKey][_endpoint], "API key not authorized for this endpoint");

        emit APIRequestReceived(_endpoint, _apiKey, _request);

        // Call the implementation contract to process the request
        (bool success, bytes memory response) = apiEndpoints[_endpoint].call(abi.encodeWithSignature("processRequest(string)", _request));

        require(success, "Failed to process API request");

        emit APIResponseSent(_endpoint, _apiKey, response);
    }
}