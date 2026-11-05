import React from "react";
import {useState, useEffect} from 'react';

const FriendApiFetch = () => {
    const [items, setItems] = useState([]);
    const [isLoaded, setIsLoaded] = useState(false);

    useEffect(() => {
        fetch("https://jsonplaceholder.typicode.com/users")
        .then((res) => res.json())
        .then((json) => {
            setItems(json);
            setIsLoaded(true);
        });
    }, []);
    if (!isLoaded){
        return (<div>
            <h1>Waiting for response..</h1>
        </div>
        );
    }
    
    return (
        <div className="UserCards">
            {items.map((item) => (
                <div className="UserCard" key={item.id}>
                    <a className="UserCard-Background" href="/Profile">
                        <img className="UserCard-Profile-Background" src="https://i.pinimg.com/736x/61/18/63/61186384137b2dcc3cc4b3445c7aea25.jpg"></img>
                    </a>
                <div className="UserCard-card">
                    <div className="UserCard-content">
                        <div className="UserCard-avatar">
                            <img className="UserCard-avatar-img" src="./src/assets/Wizard.png"></img>
                        </div>
                    </div>
                    <div className="UserCard-details">
                        <div className="UserCard-Username"> {item.username} </div>
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
            <h1 className="FriendTitle"> Friends List </h1>
            <div className="FriendBox">
                <div className="ListItems">
                    <FriendApiFetch/>
                </div>
            </div>
        </div>
    );
};

export default Friends;