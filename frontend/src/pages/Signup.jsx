import { useState } from "react"

function Form() {
    const [name, setName] = useState("")
    const [password, setPassword] = useState("")
    const [passcheckstr, setPassCheckStr] = useState("")
    const [submitted, setSubmitted] = useState(false)
    const [error, setError] = useState(false)

    const passwordTooShort = password.length > 0 && password.length < 8
    const passwordsDoNotMatch =
        passcheckstr.length > 0 && password !== passcheckstr

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
            setError(true)
            return
        }
        setError(false)

        try {
            const response = await fetch("/api/register", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({ username: name, password: password }),
            })

            console.log(response)
            const _data = await response.json()
            if (response.ok) {
                alert("success!")
                setSubmitted(true)
            } else {
                alert("oh oh :(")
                setSubmitted(false)
            }
        } catch (error) {
            console.log(error)
            alert("couldn't send")
            setSubmitted(false)
        }
    }

    return (
        <>
            <div>
                {submitted && <div>Success!</div>}
                {error && <div>Please fill all the fields!</div>}
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
