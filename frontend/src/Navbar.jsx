import React from "react";
import { Link } from "react-router-dom"; 

const Navbar = () => {
    return (
        <>
            <nav className="navbar">
                <ul className="nav-list flex">
                    <li>
                        <Link to="/"><img src="./src/assets/wizard.svg" /></Link>
                    </li>
                    <li>
                        <Link to="/Friends">Friends</Link>
                    </li>
                    <li>
                        <Link to="/Chat">Chat</Link>
                    </li>
                    <li>
                        <Link to="/Profile">Profile</Link>
                    </li>
                    
                    <li className="ml-auto">
                            <Link to="/Signin" >Sign in</Link>
                    </li>
                    <li>
                            <Link to="/Signup" >Sign up</Link>
                    </li>
                </ul>
                    
            </nav>
        </>
    );
};

export default Navbar;