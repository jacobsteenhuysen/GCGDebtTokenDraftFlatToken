contract MessagedERC1404 is SimpleRestrictedToken {
    using MessagesAndCodes for MessagesAndCodes.Data;
    MessagesAndCodes.Data internal messagesAndCodes;

    constructor () public {
        messagesAndCodes.addMessage(SUCCESS_CODE, SUCCESS_MESSAGE);
    }

    function messageForTransferRestriction (uint8 restrictionCode)
        public
        view
        returns (string memory message)
    {
        message = messagesAndCodes.messages[restrictionCode];
    }
}