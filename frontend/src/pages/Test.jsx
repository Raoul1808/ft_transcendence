import React from "react";
import { useState } from 'react';

class Clock extends React.Component {
  constructor(props) {
    super(props);
    this.state = {date: new Date()};
  }
  componentDidMount() {
    this.timerID = setInterval(
      () => this.tick(),
      1000
    );
  }
  componentWillUnmount() {
    clearInterval(this.timerID);
  }
  tick() {
    this.setState(
      {date: new Date()}
    );
  }
  render() {
    return (
        <h1>Il est {this.state.date.toLocaleTimeString("fr-FR")}</h1>
    );
  }
}

function Counter() {
    const [count, setCount] = useState(0);
    function handleClick() {
        setCount(count + 1);
    }
    return (
        <>
            <h2>{count}</h2>
            <button onClick={handleClick}>UwU</button>
        </>
    )
}

const Test = () => {
    return (
        <section className="section">
            <div className="box-main">
                <div className="firstHalf">
                    <h1 className="text-big">
                        Transcendance
                    </h1>
                    <Clock />
                    <Counter />
                    <p className="text-small">
                        This is a test page for the transcendance i know its ugly but i like it :D
                    </p>
                </div>
            </div>
        </section>
    )
}

export default Test;