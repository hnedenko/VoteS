pragma solidity ^0.8.11;

/// @title Internal currency VoteS system
/// @author @oleh
/// @notice Functions for working with Voice - the internal currency required to create your own votes
/// @dev Realize ERC20 token standart
contract Voice {
    // используется для указания контрактам и внешним приложениям имени токена
    string name = "Voice";
    // помогает обеспечить его совместимость со стандартом ERC20 и предоставляет внешним программам его сокращенное название
    string symbol = "VCE";

    // эта функция указывает общее количество токенов в блокчейне
    function totalSupply(uint _a, uint _b) public pure returns (uint) {
        uint c = _a + _b;
        return c;
    }

    // с помощью этой функции можно найти количество токенов, которые имеют установленный адрес
    function balanceOf() public {
        //
    }

    // делает возможным передачу токена другим участникам;
    function transfer() public {
        //
    }

    // передает количество токенов с одного адреса на другой;
    function transferFrom() public {
        //
    }

    // этот метод является функцией снятия денег, которую можно использовать, когда пользователь получил определенное количество токенов и хочет удалить их с баланса другого пользователя. В нем указывается, какая учетная запись принадлежит токену в настоящее время и какая другая учетная запись может вступить во владение в будущем
    function takeOwnership() public {
        //
    }

    // Позволяет отправителю снимать со своего счета суммы несколько раз. То есть, является подтверждением;
    function approve() public {
        //
    }

    // Возвращает сумму, с которой отправителю по-прежнему разрешено снимать деньги.
    function allowance() public {
        //
    }
}
