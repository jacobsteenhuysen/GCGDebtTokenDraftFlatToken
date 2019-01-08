pragma solidity >=0.4.21 <0.6.0;

library MessagesAndCodes {
    string public constant EMPTY_MESSAGE_ERROR = "Message cannot be empty string";
    string public constant CODE_RESERVED_ERROR = "Given code is already pointing to a message";
    string public constant CODE_UNASSIGNED_ERROR = "Given code does not point to a message";

    struct Data {
        mapping (uint8 => string) messages;
        uint8[] codes;
    }

    function messageIsEmpty (string memory _message)
        internal
        pure
        returns (bool isEmpty)
    {
        isEmpty = bytes(_message).length == 0;
    }

    function messageExists (Data storage self, uint8 _code)
        internal
        view
        returns (bool exists)
    {
        exists = bytes(self.messages[_code]).length > 0;
    }

    function addMessage (Data storage self, uint8 _code, string memory _message)
        public
        returns (uint8 code)
    {
        require(!messageIsEmpty(_message), EMPTY_MESSAGE_ERROR);
        require(!messageExists(self, _code), CODE_RESERVED_ERROR);

        self.messages[_code] = _message;
        self.codes.push(_code);
        code = _code;
    }

    function autoAddMessage (Data storage self, string memory _message)
        public
        returns (uint8 code)
    {
        require(!messageIsEmpty(_message), EMPTY_MESSAGE_ERROR);

        code = 0;
        while (messageExists(self, code)) {
            code++;
        }

        addMessage(self, code, _message);
    }

    function removeMessage (Data storage self, uint8 _code)
        public
        returns (uint8 code)
    {
        require(messageExists(self, _code), CODE_UNASSIGNED_ERROR);

        uint8 indexOfCode = 0;
        while (self.codes[indexOfCode] != _code) {
            indexOfCode++;
        }

        for (uint8 i = indexOfCode; i < self.codes.length - 1; i++) {
            self.codes[i] = self.codes[i + 1];
        }
        self.codes.length--;

        self.messages[_code] = "";
        code = _code;
    }

    function updateMessage (Data storage self, uint8 _code, string memory _message)
        public
        returns (uint8 code)
    {
        require(!messageIsEmpty(_message), EMPTY_MESSAGE_ERROR);
        require(messageExists(self, _code), CODE_UNASSIGNED_ERROR);

        self.messages[_code] = _message;
        code = _code;
    }
}