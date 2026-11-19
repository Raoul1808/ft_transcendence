import React from "react"
import { Link } from "react-router-dom"

const Navbar = () => {
    return (
        <>
            <nav className="bg-wizard-purple items-center max-h-[8svh]">
                <ul className="flex items-center">
                    <li className="py-2 pl-2">
                        <Link to="/">
                            <img src="./src/assets/wizard.svg" />
                        </Link>
                    </li>
                    <li className="p-[8px_30px] font-kiwi-soda text-white hover:text-gray-300">
                        <Link to="/Friends">Friends</Link>
                    </li>
                    <li className="p-[8px_30px] font-kiwi-soda text-white hover:text-gray-300">
                        <Link to="/Profile">Profile</Link>
                    </li>
                    <li className="ml-auto p-[8px_20px] font-kiwi-soda text-white hover:text-gray-300">
                        <Link to="/Signin">Sign in</Link>
                    </li>
                    |
                    <li className="p-[8px_20px] font-kiwi-soda text-white hover:text-gray-300">
                        <Link to="/Signup">Sign up</Link>
                    </li>
                </ul>
            </nav>
        </>
    )
}

export default Navbar
