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
            <form className="form">
                <input
                    className="input"
                    type="text"
                    onChange={handleName}
                    value={name}
                    />
                <input
                    className="input"
                    type="email"
                    onChange={handleEmail}
                    value={email}
                    />
                <input
                    className="input"
                    type="password"
                    onChange={handlePassword}
                    value={password}
                    />
                <button onClick={handleSubmit}
                        type="submit">
                    Submit
                </button>
            </form>
        </>
    )
}

function Signin() {
    return (
        <div className="signin">
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