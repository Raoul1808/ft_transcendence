import { Link, useNavigate } from "react-router-dom"

const Navbar = ({ isLoggedIn, setIsLoggedIn }) => {
    const navigate = useNavigate()

    const handleLogout = async () => {
        try {
            await fetch("/api/logout", {
                method: "POST",
                credentials: "include",
            })
        } catch (err) {
            console.log("Logout failed:", err)
        }

        setIsLoggedIn(false)
        navigate("/signin")
        alert("You're logged out!")
    }

    return (
        <nav className="bg-wizard-purple items-center max-h-[8svh]">
            <ul className="flex items-center">
                <li className="py-2 pl-2">
                    <Link to="/">
                        <img src="./src/assets/Wizard.png" alt="" />
                    </Link>
                </li>
                <li className="p-[8px_30px] font-kiwi-soda text-white hover:text-gray-300">
                    <Link to="/Friends">Friends</Link>
                </li>
                <li className="p-[8px_30px] font-kiwi-soda text-white hover:text-gray-300">
                    <Link to="/Profile">Profile</Link>
                </li>

                {isLoggedIn ? (
                    <li className="ml-auto p-[8px_20px] font-kiwi-soda text-[16px] text-white hover:text-gray-300">
                        <button
                            type="button"
                            onClick={handleLogout}
                            className="text-lg"
                        >
                            Log out
                        </button>
                    </li>
                ) : (
                    <>
                        <li className="ml-auto p-[8px_20px] font-kiwi-soda text-white hover:text-gray-300">
                            <Link to="/Signin">Sign in</Link>
                        </li>
                        |
                        <li className="p-[8px_20px] font-kiwi-soda text-white hover:text-gray-300">
                            <Link to="/Signup">Sign up</Link>
                        </li>
                    </>
                )}
            </ul>
        </nav>
    )
}

export default Navbar
