import { useState, useEffect } from "react"
import { FriendApiFetch } from "./Friends"

const Profile = () => {
    const [user, setUser] = useState(null)
    const [loading, setLoading] = useState(true)
    const [error, setError] = useState("")

    useEffect(() => {
        const fetchProfile = async () => {
            try {
                const response = await fetch("/api/me", {
                    method: "GET",
                    cretendials: "include",
                })

                if (response.ok) {
                    const data = await response.json()
                    setUser(data)
                } else {
                    setError("Please sign-in to see your profile!")
                }
            } catch (err) {
                console.log(err)
                setError("Profile couldn't loaad, try again later :(")
            } finally {
                setLoading(false)
            }
        }
        fetchProfile()
    }, [])

    if (loading) return <div>Please wait...</div>
    if (error) return <div>{error}</div>

    return (
        <div className="self-center mx-auto max-w-5xl w-1/1 h-92/100 flex-[0_0_auto] bg-[rgba(0,0,0,0.5)]">
            <div className="h-full relative flex flex-col w-1/1">
                <div className="ppBackground rounded-2xl bg-[url(https://i.pinimg.com/736x/61/18/63/61186384137b2dcc3cc4b3445c7aea25.jpg)] relative bg-cover h-62.5 bg-position-[50%_center]">
                    <div className="bottom-2.5 grid justify-center absolute right-2.5 gap-2.5">
                        <button
                            type="button"
                            className="items-center shadow-none inline-flex justify-center relative no-underline cursor-pointer h-8 w-8 bg-wizard-purple border-amber-500 border rounded-full"
                        >
                            <img
                                className="w-5 h-5 object-contain"
                                src="../src/assets/pencil.png"
                                alt=""
                            ></img>
                        </button>
                    </div>
                </div>
                <div className="ppMainInfo flex h-20 items-center p-[0_50px] relative">
                    <div className="bg-wizard-purple border -mt-12 z-10 border-amber-500 self-start rounded-2xl shadow flex-none h-30 w-30 overflow-hidden transform-gpu">
                        <img
                            className="w-full h-full object-cover"
                            src="./src/assets/Wizard.png"
                            alt=""
                        ></img>
                    </div>
                    <div className="items-start flex flex-1 flex-col ml-5 min-w-0 shadow">
                        <h1 className="object-contain items-center font-medium relative text-3xl m-[-5px_0_0] max-w-1/1 p-0">
                            {user.username}
                        </h1>
                    </div>
                </div>
                <div className="bg-wizard-purple rounded-2xl shadow mt-3 p-[10px_20px] h-1/2 relative flex flex-col transform-gpu">
                    <h2 className="text-4xl my-3">Friends</h2>
                    <div className="overflow-y-auto h-[initial] mb-[10px_!important]">
                        <FriendApiFetch />
                    </div>
                </div>
            </div>
        </div>
    )
}

export default Profile
