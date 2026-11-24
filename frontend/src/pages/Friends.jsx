import { useState, useEffect } from "react"

export const FriendApiFetch = () => {
    const [items, setItems] = useState([])
    const [isLoaded, setIsLoaded] = useState(false)

    useEffect(() => {
        fetch("https://jsonplaceholder.typicode.com/users")
            .then((res) => res.json())
            .then((json) => {
                setItems(json)
                setIsLoaded(true)
            })
    }, [])
    if (!isLoaded) {
        return (
            <div>
                <h1>Waiting for response..</h1>
            </div>
        )
    }

    return (
        <div className="m-0.5 grid gap-2.5 grid-cols-[repeat(auto-fill,minmax(280px,1fr))] justify-self-center min-w-6/10">
            {items.map((item) => (
                <div
                    className="UserCard border border-amber-300 rounded-lg inline-block h-30 relative w-1/1"
                    key={item.id}
                >
                    <a
                        className="left-0 top-0 absolute h-auto bg-black"
                        href="/Profile"
                    >
                        <img
                            className="opacity-70 rounded-lg h-auto object-contain max-w-1/1 [image-rendering:pixelated]"
                            src="./src/assets/ducking_wizard.png"
                            alt=""
                        />
                    </a>
                    <div className="flex flex-col h-1/1 justify-between pointer-events-none relative no-underline">
                        <div className="grid grid-cols-[minmax(min-content,auto)_1fr]">
                            <div className="items-center flex h-(--avatar-size)">
                                <img src="./src/assets/Wizard.png" alt="" />
                            </div>
                        </div>
                        <div className="flex items-center justify-center h-(--avatar-size) bg-[rgba(0,0,0,0.5)]">
                            <div className="items-center flex flex-wrap font-bold justify-self-center self-center text-white">
                                {" "}
                                {item.username}{" "}
                            </div>
                        </div>
                    </div>
                </div>
            ))}
        </div>
    )
}

const Friends = () => {
    return (
        <div>
            <h1 className="text-8xl"> Friends List </h1>
            <div className="justify-self-center w-10/13 bg-wizard-purple rounded-lg">
                <div className="justify-center content-center">
                    <FriendApiFetch />
                </div>
            </div>
        </div>
    )
}

export default Friends
