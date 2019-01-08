contract SimpleToken is ERC1404, ERC20Detailed, MessagedERC1404, ManagedWhitelist  {
   
       uint8 public SEND_NOT_ALLOWED_CODE;
        uint8 public RECEIVE_NOT_ALLOWED_CODE;
        string public constant SEND_NOT_ALLOWED_ERROR = "ILLEGAL_TRANSFER_SENDING_ACCOUNT_NOT_WHITELISTED";
         string public constant RECEIVE_NOT_ALLOWED_ERROR = "ILLEGAL_TRANSFER_RECEIVING_ACCOUNT_NOT_WHITELISTED";
         
    constructor (
        uint256 _initialAmount,
        string memory _tokenName,
        uint8 _decimalUnits,
        string memory _tokenSymbol

    ) public ERC20Detailed(_tokenName, _tokenSymbol, _decimalUnits) {
        _mint(msg.sender, _initialAmount * (10 ** uint256(_decimalUnits)));
         SEND_NOT_ALLOWED_CODE = messagesAndCodes.autoAddMessage(SEND_NOT_ALLOWED_ERROR);
        RECEIVE_NOT_ALLOWED_CODE = messagesAndCodes.autoAddMessage(RECEIVE_NOT_ALLOWED_ERROR);
        
    }
       

    function detectTransferRestriction (address from, address to, uint value)
        public
        view
        returns (uint8 restrictionCode)
    {
        if (!sendAllowed[from]) {
            restrictionCode = SEND_NOT_ALLOWED_CODE; 
        } else if (!receiveAllowed[to]) {
            restrictionCode = RECEIVE_NOT_ALLOWED_CODE;
        } else {
            restrictionCode = SUCCESS_CODE;
        }
    }
}