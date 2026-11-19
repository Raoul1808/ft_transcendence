import React from "react"
import "./App.css"
import { Routes, Route } from "react-router-dom"
import Navbar from "./Navbar.jsx"
import Home from "./pages/Home.jsx"
import Test from "./pages/Test.jsx"
import Game from "./pages/Game.jsx"
import Friends from "./pages/Friends.jsx"
import Signin from "./pages/Signin.jsx"
import Signup from "./pages/Signup.jsx"
import Profile from "./pages/Profile.jsx"

const RoutingTable = () => {
    return (
        <Routes>
            <Route exact path="/" element={<Home />}></Route>
            <Route exact path="/test" element={<Test />}></Route>
            <Route exact path="/Game" element={<Game />}></Route>
            <Route exact path="/Friends" element={<Friends />}></Route>
            <Route exact path="/Signin" element={<Signin />}></Route>
            <Route exact path="/Signup" element={<Signup />}></Route>
            <Route exact path="/Profile" element={<Profile />}></Route>
        </Routes>
    )
}

function App() {
    return (
        <div className="flex flex-col border-box min-h-svh h-svh">
            <Navbar />
            <RoutingTable />
        </div>
    )
}

export default App
