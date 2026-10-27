import React from "react";

const Usercard = () => {
    return (
        <div className="UserCard">
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
                    <div className="UserCard-Username"> Sorcier </div>
                </div>
            </div>
        </div>
    )
}

const Friends = () => {
    return (
        <div>
            <h1 className="FriendTitle"> Friends List </h1>
            <div className="FriendBox">
                <div className="ListItems">
                    <div className="UserCards">
                        <Usercard/>
                        <Usercard/>
                        <Usercard/>
                        <Usercard/>
                        <Usercard/>
                    </div>
                </div>
            </div>
        </div>
    );
};

export default Friends;