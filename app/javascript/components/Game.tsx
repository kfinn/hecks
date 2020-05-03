import _ from 'lodash';
import React from 'react';
import { Game } from '../models/Game';
import BoardSvg from './BoardSvg';


interface GameProps {
    game: Game
}

export default function Game({ game }: GameProps) {
    return (
        <div>
            <h1>Game</h1>
            <h2>Players</h2>
            <ul>
                {
                    _.map(game.players, ({ id, name }) => (
                        <li key={id}>{name}</li>
                    ))
                }
            </ul>
            <BoardSvg territories={game.territories} />
        </div>
    )
}
