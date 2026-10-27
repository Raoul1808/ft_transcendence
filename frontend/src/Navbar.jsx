import React from "react";
import { Link } from "react-router-dom"; 

const Navbar = () => {
    return (
        <>
            <nav className="navbar">
                <ul className="nav-list">
                    <li>
                        <Link to="/"><img src="./src/assets/wizard.svg"/></Link>
                    </li>
                    {/* <li>
                        <Link to="/Game">Game</Link>
                    </li> */}
                    <li>
                        <Link to="/Friends">Friends</Link>
                    </li>
                    <li>
                        <Link to="/Chat">Chat</Link>
                    </li>
                    <li>
                        <Link to="/Profile">Profile</Link>
                    </li>
                    
                </ul>
                <ul className="signin-button">
                        <li>
                            <Link to="/Signin" >Signin</Link>
                        </li>
                </ul>
            </nav>
        </>
    );
};

export default Navbar;