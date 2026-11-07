import React from "react";
import { useState } from "react";

function Form () {
    const [name, setName] = useState("");
    const [email, setEmail] = useState("");
    const [password, setPassword] = useState("");
    const [submitted, setSubmitted] = useState(false);
    const [error, setError] = useState(false);

    const handleName = (e) => {
        setName(e.target.value);
        setSubmitted(false);
    }
    const handleEmail = (e) => {
        setEmail(e.target.value);
        setSubmitted(false);
    }
    const handlePassword = (e) => {
        setPassword(e.target.value);
        setSubmitted(false);
    }
    const handleSubmit = (e) => {
        e.preventDefault();
        if (name == "" || email == "" || password == "")
        {
            setSubmitted(false);
            setError(true);
        }
        else
        {
            setSubmitted(true);
            setError(false);
        }
    }

    const SuccessMessage = () => {
        if (submitted)
        {
            return (
            <div>
                Success!
            </div>
            )
        }
    }

    const ErrorMessage = () => {
        if (error)
        {
            return (
            <div>
                Please fill all the fields!
            </div>
            )
        }
    }

    return (
        <>
            <div>
                <SuccessMessage/>
                <ErrorMessage/>
            </div>
            <form className="grid justify-center items-center">
                <input
                    className="m-0.5 p-1.5 text-xl bg-wizard-purple border-amber-300 border rounded-md"
                    type="text"
                    id="name"
                    name="name"
                    required
                    autoComplete="userName"
                    onChange={handleName}
                    value={name}
                    />
                <input
                    className="m-0.5 p-1.5 text-xl bg-wizard-purple border-amber-300 border rounded-md"
                    type="email"
                    id="email"
                    name="email"
                    required
                    autoComplete="email"
                    onChange={handleEmail}
                    value={email}
                    />
                <input
                    className="m-0.5 p-1.5 text-xl bg-wizard-purple border-amber-300 border rounded-md"
                    type="password"
                    id="password"
                    name="password"
                    required
                    autoComplete="current-password"
                    onChange={handlePassword}
                    value={password}
                    />
                <button onClick={handleSubmit}
                        type="submit" className="bg-wizard-purple rounded-lg text-white p-[15px_32px] text-center inline-block text-3xl m-[20px_40px] cursor-pointer">
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
                <h1>
                    User Sign-in
                </h1>
            </div>
            <Form/>
        </div>
        
    );
};

export default Signin;