import React from "react"
import { useState } from "react"

//faire une class game button qui prends le user pour savoir si il est co ou pas, car si il n'est pas co
//il faut rediriger vers signin et pas game

function GameButton() {
    function handleClick() {
        location.href = "/Game"
    }
    return (
        <button
            onClick={handleClick}
            className="px-2 self-center justify-center border align-middle bg-wizard-purple rounded-lg text-white py-2 text-center inline-block text-4xl m-4 cursor-pointer shadow-sm"
        >
            {" "}
            Start Playing{" "}
        </button>
    )
}

const Home = () => {
    return (
        <div className="rounded-lg self-center flex flex-col justify-between">
            <header>
                <h1 className="mt-4 text-8xl">Transcendance</h1>
            </header>
            <p>Dummy explicative game description</p>
            <GameButton />
        </div>
    )
}

export default Home
