import React from 'react';
import './App.css';
import Card from './Card.js'
import dateFormat from 'dateformat';

import { initializeApp } from "firebase/app";
import { getDatabase, ref, onValue } from "firebase/database";
import { getAuth, signInWithEmailAndPassword } from "firebase/auth";

// Your web app's Firebase configuration
const firebaseConfig = {
  apiKey: "AIzaSyCuAZyTlzRAxdzToDntK4vODxMWg4du2PE",
  authDomain: "arduino-test-d1dc0.firebaseapp.com",
  databaseURL: "https://arduino-test-d1dc0-default-rtdb.asia-southeast1.firebasedatabase.app",
  projectId: "arduino-test-d1dc0",
  storageBucket: "arduino-test-d1dc0.appspot.com",
  messagingSenderId: "650878921562",
  appId: "1:650878921562:web:50ece78906d686a73fa163"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const db = getDatabase(app);
const auth = getAuth(app);

class App extends React.Component {


    constructor(props) {
        super(props)
        this.state = {
            last_update_time: "...",
            humidity: "...",
            air_temp: "...",
            soil_temp: "...",
            soil_moisture: "...",
            light: "...",
        }
        this.valuesRef = ref(db, 'values');
        this.unsubscribe = null;
    }

    componentDidMount() {
        signInWithEmailAndPassword(auth, 'artillagadan@gmail.com', '12345678')
            .then((userCredential) => {
                this.unsubscribe = onValue(this.valuesRef, (snapshot) => {
                    this.setState({
                        last_update_time: dateFormat(new Date(snapshot.child("date").val()), 'h:MM:ss TT'),
                        humidity: snapshot.child("air_humidity").val() + '%',
                        air_temp: snapshot.child("air_temp").val() + '°C',
                        soil_temp: snapshot.child("soil_temp").val() + '°C',
                        soil_moisture: snapshot.child("soil_moisture").val() + '%',
                        light: snapshot.child("light").val() + '%',
                    });
                });
            })
            .catch((error) => {
                console.log(error);
            }
        );
    }

    componentWillUnmount() {
        this.unsubscribe();
    }

    render() {
        return (
            <div className="box">
                <div className="row header">
                    <h1 className="title" >PR2 - Bulakin 3</h1>
                </div>
                <div className="row content">
                    <p id="last-update-time">Last update time: <b>{this.state.last_update_time}</b></p>
                    <div className="cards-container">
                        <Card
                            title={"Humidity"}
                            value={this.state.humidity} />
                        <Card
                            title={"Air Temperature"}
                            value={this.state.air_temp} />
                        <Card
                            title={"Soil Temperature"}
                            value={this.state.soil_temp} />
                        <Card
                            title={"Soil Moisture"}
                            value={this.state.soil_moisture} />
                        <Card
                            title={"Light"}
                            value={this.state.light} />
                    </div>
                </div>
            </div>
        )
    }
}

export default App