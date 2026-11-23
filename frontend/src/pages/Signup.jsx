import { useState } from "react"
import { useNavigate } from "react-router-dom"

function Form() {
    const [name, setName] = useState("")
    const [password, setPassword] = useState("")
    const [passcheckstr, setPassCheckStr] = useState("")
    const [submitted, setSubmitted] = useState(false)
    const [error, setError] = useState("")

    const passwordTooShort = password.length > 0 && password.length < 8
    const passwordsDoNotMatch =
        passcheckstr.length > 0 && password !== passcheckstr
    const navigate = useNavigate();

    const handleSubmit = async (e) => {
        e.preventDefault()
        if (
            name === "" ||
            password === "" ||
            passcheckstr === "" ||
            password.length < 8 ||
            password !== passcheckstr
        ) {
            setSubmitted(false)
            setPassCheck(password === passcheckstr)
            setError("Please fill all the fields properly!")
            return
        }
        setError("")

        try {
            const response = await fetch("/api/register", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({ username: name, password: password }),
            })

            console.log(response)
            if (response.ok) {
                setSubmitted(true)
                navigate("/signin")
                return
            }

            if (response.status === 400) {
                setError("Invalid registration request, check your inputs!")
            } else if (response.status === 409) {
                setError("Username already taken!")
            } else {
                const data = await response.json().catch(() => ({}))
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
                {passwordTooShort && (
                    <div>Password must be at least 8 characters...</div>
                )}
                {passwordsDoNotMatch && <div>Password not identical...</div>}
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
                    placeholder="Username"
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
                    placeholder="Password"
                />
                <input
                    className="m-0.5 p-1.5 text-xl bg-wizard-purple border-amber-300 border rounded-md"
                    type="password"
                    name="password"
                    required
                    autoComplete="current-password"
                    onChange={(e) => {
                        setPassCheckStr(e.target.value)
                        setSubmitted(false)
                    }}
                    value={passcheckstr}
                    placeholder="Confirm password"
                />
                <button
                    onClick={handleSubmit}
                    type="submit"
                    className="bg-wizard-purple rounded-lg text-white p-[15px_32px] text-center inline-block text-3xl m-[20px_40px] cursor-pointer"
                >
                    Submit
                </button>
            </form>
        </>
    )
}

function Signup() {
    return (
        <div className="grid justify-center items-center">
            <div>
                <h1 className="text-5xl">User Sign-up</h1>
            </div>
            <Form />
        </div>
    )
}

export default Signup
