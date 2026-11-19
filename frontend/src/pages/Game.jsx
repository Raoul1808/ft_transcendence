const Game = () => {
    return (
        <div className="relative flex w-1/1 min-h-[92svh]">
            <iframe
                className="absolute h-1/1 w-1/1"
                src="game-export/game.html"
            />
        </div>
    )
}

export default Game
