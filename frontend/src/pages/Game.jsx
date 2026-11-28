import { useEffect, useRef, useState } from "react"
import { GodotBridgeProvider, GodotFrame, useGodot } from "react-godot-bridge"

function Controls({ username }) {
    const { emit, on } = useGodot()

    useEffect(
        () =>
            on("test", (payload) => {
                console.log("test reveived", payload.test)
                emit("test", { test: 5 })
                emit("user-info", { username: username })
            }),
        [on, username, emit],
    )
}

const GameFrame = ({ username }) => {
    return (
        <GodotBridgeProvider appKey="">
            <GodotFrame
                className=" h-full w-3/4"
                src="game-export/game.html"
                title="game"
            />
            <Controls username={username} />
        </GodotBridgeProvider>
    )
}

const Game = () => {
    const [messages, setMessages] = useState([
        { id: 1, user: "System", text: "Welcome to the lobby chat!" },
    ])
    const [input, setInput] = useState("")
    const bottomRef = useRef(null)
    const [username, setUsername] = useState("")

    useEffect(() => {
        const fetchUser = async () => {
            try {
                const response = await fetch("/api/me", {
                    credentials: "include",
                })
                if (response.ok) {
                    const data = await response.json()
                    setUsername(data.username)
                }
            } catch (err) {
                console.log("Could not fetch user data for the chat:", err)
            }
        }
        fetchUser()
    }, [])

    // biome-ignore lint: `messages` needed for auto-scroll
    useEffect(() => {
        bottomRef.current?.scrollIntoView({ behavior: "smooth" })
    }, [messages])

    const handleSend = (e) => {
        e.preventDefault()

        if (input === "") return
        const newMessage = {
            id: Date.now(),
            user: username,
            text: input,
        }
        setMessages([...messages, newMessage])
        setInput("")
    }

    return (
        <div className="flex w-full h-[92svh]">
            <GameFrame username={username} />
            <div className="flex flex-col h-1/1 w-1/4 bg-[rgba(0,0,0,0.75)] rounded border border-amber-300 text-white">
                <div className="p-3 text-center text-2xl"> Chat </div>

                <div className="flex-1 overflow-y-auto p-3 flex flex-col scrollbar-none">
                    <div className="mt-auto space-y-2">
                        {messages.map((msg) => (
                            <div key={msg.id} className="wrap-break-word">
                                <span className="text-amber-300">
                                    {msg.user}:{" "}
                                </span>
                                <span>{msg.text}</span>
                            </div>
                        ))}
                        <div ref={bottomRef} />
                    </div>
                </div>

                <form
                    onSubmit={handleSend}
                    className="p-2 bg-wizard-purple flex gap-2"
                >
                    <input
                        type="text"
                        onChange={(e) => setInput(e.target.value)}
                        value={input}
                        disabled={!username}
                        placeholder={
                            username
                                ? "Type a message..."
                                : "Sign-in to chat..."
                        }
                        className="flex-1 p-2 rounded border border-amber-300 bg-black/50 text-white"
                    />
                    <button
                        type="submit"
                        disabled={!username}
                        className="px-3 py-2 rounded-lg border border-amber-300 hover:bg-[rgba(0,0,0,0.5)] hover:cursor-pointer"
                    >
                        <img
                            src="./src/assets/arrow.png"
                            alt=""
                            className="[image-rendering:pixelated]"
                        />
                    </button>
                </form>
            </div>
        </div>
    )
}

export default Game
