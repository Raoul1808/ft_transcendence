import { useState } from "react"

function Form() {
    const [name, setName] = useState("")
    const [password, setPassword] = useState("")
    const [submitted, setSubmitted] = useState(false)
    const [error, setError] = useState("")

    const handleSubmit = async (e) => {
        e.preventDefault()
        if (name === "" || password === "") {
            setSubmitted(false)
            setError("Please fill all the fields properly!")
            return
        }
        setError("")

        try {
            const response = await fetch("/api/login", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({ username: name, password: password }),
            })
            console.log(response)
            if (response.ok) {
                setSubmitted(true)
                return
            }

            if (response.status === 401) {
                setError("Username or password is wrong :(")
            } else {
                const data = await response.json.catch(() => ({}))
                setError(
                    data.message ||
                        data.error ||
                        `Server error: (${response.status})`,
                )
            }
            setSubmitted(false)
        } catch (err) {
            console.log(err)
            setError("Can't connect to server, check your internet!")
            setSubmitted(false)
        }
    }

    return (
        <>
            <div>
                {submitted && <div>Success!</div>}
                {error && <div>{error}</div>}
            </div>
            <form className="grid justify-center items-center">
                <input
                    className="m-0.5 p-1.5 text-xl bg-wizard-purple border-amber-300 border rounded-md"
                    type="text"
                    id="name"
                    name="name"
                    required
                    autoComplete="username"
                    onChange={(e) => {
                        setName(e.target.value)
                        setSubmitted(false)
                    }}
                    value={name}
                />
                <input
                    className="m-0.5 p-1.5 text-xl bg-wizard-purple border-amber-300 border rounded-md"
                    type="password"
                    id="password"
                    name="password"
                    required
                    autoComplete="current-password"
                    onChange={(e) => {
                        setPassword(e.target.value)
                        setSubmitted(false)
                    }}
                    value={password}
                />
                <button
                    onClick={handleSubmit}
                    type="submit"
                    className="bg-wizard-purple rounded-lg text-white p-[15px_32px] text-center inline-block text-3xl m-[20px_40px] cursor-pointer border border-white"
                >
                    Submit
                </button>
            </form>
        </>
    )
}

function Signin() {
    return (
        <div className="grid justify-center items-center">
            <div>
                <h1 className="text-5xl">User Sign-in</h1>
            </div>
            <Form />
        </div>
    )
}

export default Signin
