import React from "react";
import { useState } from 'react';

//faire une class game button qui prends le user pour savoir si il est co ou pas, car si il n'est pas co
//il faut rediriger vers signin et pas game

function GameButton() {
    function handleClick() {
        location.href= "/Game";
    }
    return (
        <button onClick={handleClick} className="HomeStartButton">Start Playing</button>
    )
}

const Home = () => {
    return (
        <div className="HomePage">
            <header>
                <h1 className="GameTitle">Transcendance</h1>
            </header>
            <p>
                Dummy explicative game description
            </p>
            <GameButton/>
        </div>
    )
}

export default Home;