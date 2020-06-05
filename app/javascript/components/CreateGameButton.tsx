import React from 'react';
import { Dropdown } from 'react-bootstrap';
import $ from 'jquery';

export default function CreateGameButton() {
    const authenticityToken = $('meta[name=csrf-token]').attr('content')

    return <Dropdown>
        <Dropdown.Toggle id="create-game-button" variant="outline-success">
            New Game
        </Dropdown.Toggle>
        <Dropdown.Menu className="list-group">
            <form method="post" action="/games" acceptCharset="UTF-8">
                <input type="hidden" name="authenticity_token" value={authenticityToken} />
                <input type="hidden" name="game[board_config_id]" value="small" />
                <button className="dropdown-item" type="submit">Small Board (2-4 players)</button>
            </form>
            <div className="dropdown-divider"></div>
            <form method="post" action="/games" acceptCharset="UTF-8">
                <input type="hidden" name="authenticity_token" value={authenticityToken} />
                <input type="hidden" name="game[board_config_id]" value="large" />
                <button className="dropdown-item" type="submit">Large Board (3-6 players)</button>
            </form>
        </Dropdown.Menu>
    </Dropdown>
}
