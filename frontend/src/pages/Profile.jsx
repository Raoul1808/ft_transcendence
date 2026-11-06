import React from "react";

const Profile = () => {
    return (
        <div>
            <h1>
                Profile Page
            </h1>
            <div className="ppCoreContainer">
                <a className="ppBackground">
                    <img src="https://i.pinimg.com/736x/61/18/63/61186384137b2dcc3cc4b3445c7aea25.jpg"></img>
                </a>
                <div classname="ppContainer">
                    <div className="ppPicContainer">
                        <img src="./src/assets/Wizard.png"></img>
                    </div>
                </div>
            </div>
        </div>
    );
};

export default Profile;