import React from "react";

const Game = () => {
    return (
        <div className="GameContainer">
            <>
                <iframe className="GameIframe" src="game-export/game.html" />
            </>
        </div>
    );
};

export default Game;