import "./App.css"
import { useState, useEffect } from "react"
import { Routes, Route } from "react-router-dom"
import Navbar from "./Navbar.jsx"
import Home from "./pages/Home.jsx"
import Test from "./pages/Test.jsx"
import Game from "./pages/Game.jsx"
import Friends from "./pages/Friends.jsx"
import Signin from "./pages/Signin.jsx"
import Signup from "./pages/Signup.jsx"
import Profile from "./pages/Profile.jsx"

const RoutingTable = ({ setIsLoggedIn }) => {
    return (
        <Routes>
            <Route exact path="/" element={<Home />}></Route>
            <Route exact path="/test" element={<Test />}></Route>
            <Route exact path="/Game" element={<Game />}></Route>
            <Route exact path="/Friends" element={<Friends />}></Route>
            <Route
                exact
                path="/Signin"
                element={<Signin onLoginSuccess={() => setIsLoggedIn(true)} />}
            ></Route>
            <Route
                exact
                path="/Signup"
                element={<Signup onLoginSuccess={() => setIsLoggedIn(true)} />}
            ></Route>
            <Route exact path="/Profile" element={<Profile />}></Route>
        </Routes>
    )
}

function App() {
    const [isLoggedIn, setIsLoggedIn] = useState(false)

    useEffect(() => {
        const checkLoginStatus = async () => {
            try {
                const response = await fetch("/api/me", {
                    credentials: "include",
                })

                if (response.ok) {
                    setIsLoggedIn(true)
                }
            } catch (_err) {
                setIsLoggedIn(false)
            }
        }

        checkLoginStatus()
    }, [])

    return (
        <div className="flex flex-col border-box min-h-svh h-svh">
            <Navbar isLoggedIn={isLoggedIn} setIsLoggedIn={setIsLoggedIn} />
            <RoutingTable setIsLoggedIn={setIsLoggedIn} />
        </div>
    )
}

export default App
