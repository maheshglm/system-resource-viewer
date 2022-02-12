import logo from './logo.svg';
import './App.css';
import React, { Component } from 'react';

class App extends Component {

  constructor(props) {
    super();
    this.state = {
      cpu: 0,
      ram: 0
    }
    this.loadData = this.loadData.bind(this)
  }

  componentDidMount() {
    this.loadData()
    setInterval(this.loadData, 300);
  }

  async loadData() {
    try {
      const host = (process.env.REACT_APP_API_HOST) 
                    ? process.env.REACT_APP_API_HOST
                    : 'localhost' ;

      console.log(host)

      const res = await fetch('http://' + host +':5000/stats');
      const blocks = await res.json();
      const ram = blocks.ram;
      const cpu = blocks.cpu;
      console.log(ram);
      this.setState({
        cpu, ram
      })
    } catch (e) {
      console.log(e);
    }
  }


  render() {
    return (
      <div className="App" >
        <header className="App-header">
          <img src={logo} className="App-logo" alt="logo" />
          <div>
            <h3>CPU : {this.state.cpu}</h3>
            <h3>RAM : {this.state.ram}</h3>
            <h3>API_HOST: {process.env.REACT_APP_API_HOST}</h3>
          </div>
        </header>
      </div>
    );
  }
}
export default App;
