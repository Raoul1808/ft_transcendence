import React from "react"
import { useState } from "react"

class Clock extends React.Component {
    constructor(props) {
        super(props)
        this.state = { date: new Date() }
    }
    componentDidMount() {
        this.timerID = setInterval(() => this.tick(), 1000)
    }
    componentWillUnmount() {
        clearInterval(this.timerID)
    }
    tick() {
        this.setState({ date: new Date() })
    }
    render() {
        return <h1>Il est {this.state.date.toLocaleTimeString("fr-FR")}</h1>
    }
}

function Counter() {
    const [count, setCount] = useState(0)
    function handleClick() {
        setCount(count + 1)
    }
    return (
        <>
            <h2>{count}</h2>
            <button type="submit" onClick={handleClick}>
                UwU
            </button>
        </>
    )
}

// const ApiTest = () => {
//     const [items, setItems] = useState([])
//     const [isLoaded, setIsLoaded] = useState(false)

//     useEffect(() => {
//         fetch("https://jsonplaceholder.typicode.com/users")
//             .then((res) => res.json())
//             .then((json) => {
//                 setItems(json)
//                 setIsLoaded(true)
//             })
//     }, [])
//     if (!isLoaded) {
//         return (
//             <div>
//                 <h1>Waiting for response..</h1>
//             </div>
//         )
//     }
//     return (
//         <div className="Container">
//             {items.map((item) => (
//                 <div className="item " key={item.id}>
//                     <ol>
//                         <div>User_Name: {item.username},</div>
//                         <div>Full_Name: {item.name}</div>
//                         <div>User_Email: {item.email}</div>
//                     </ol>
//                 </div>
//             ))}
//         </div>
//     )
// }

const Test = () => {
    return (
        <section>
            <div>
                <div>
                    <h1>Transcendance</h1>
                    <Clock />
                    <Counter />
                    <div className="bg-black hover:bg-white">uwu</div>
                    <p>
                        This is a test page for the transcendance i know its
                        ugly but i like it :D
                    </p>
                </div>
            </div>
            <div>{/*<ApiTest/> */}</div>
        </section>
    )
}

export default Test
