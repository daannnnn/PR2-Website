import './Dashboard.css';
import React, { useEffect, useState } from 'react';
import Card from './Card.js';
import DataItem from './DataItem.js';
import dateFormat from 'dateformat';
import { useAuthState } from 'react-firebase-hooks/auth';
import { ref, onValue, limitToLast, query } from 'firebase/database'
import { auth, db, signOut } from './firebase.js'
import { useHistory } from 'react-router-dom'

function Dashboard() {

    const [user, loading] = useAuthState(auth);
    const [lastUpdateTime, setLastUpdateTime] = useState('...');
    const [humidity, setHumidity] = useState('...');
    const [airTemperature, setAirTemperature] = useState('...');
    const [soilTemperature, setSoilTemperature] = useState('...');
    const [soilMoisture, setSoilMoisture] = useState('...');
    const [light, setLight] = useState('...');
    const [listItems, setListItems] = useState('...');
    const history = useHistory();

    useEffect(() => {
        let unsubscribeCurrentData = onValue(ref(db, 'a'), (snapshot) => {
            console.log('test');
            setLastUpdateTime(dateFormat(new Date(snapshot.child("c").val()), 'h:MM:ss TT'));
            setHumidity(snapshot.child("e").val()/100 + '%');
            setAirTemperature(snapshot.child("f").val()/10 + '°C');
            setSoilTemperature(snapshot.child("g").val()/10 + '°C');
            setSoilMoisture(snapshot.child("h").val()/100 + '%');
            setLight(snapshot.child("i").val()/100 + '%');
        });
        let unsubscribePastData = onValue(query(ref(db, 'b'), limitToLast(24)), (snapshot) => {
            let array = new Array(snapshot.size);
            let i = snapshot.size - 1;
            snapshot.forEach((data) => {
                array[i] = (data);
                i--;
            });
            let listItems = array.map((data) => {
                let json = data.toJSON();
                return (
                    <li key={data.key}>
                        <DataItem 
                            date={dateFormat(new Date(json["d"] * 60 * 60 * 1000), 'dddd, mmmm d, yyyy')}
                            time={dateFormat(new Date(json["d"] * 60 * 60 * 1000), 'h:MM:ss TT')}
                            humidity={json["e"]/100 + '%'}
                            air_temp={json["f"]/10 + '°C'}
                            soil_temp={json["g"]/10 + '°C'}
                            soil_moisture={json["h"]/100 + '%'}
                            light={json["i"]/100 + '%'}
                        />
                    </li>
                )
            });
            setListItems(listItems);
        });
        return function cleanup() {
            unsubscribeCurrentData();
            unsubscribePastData();
        }
    })

    useEffect(() => {
        if (loading) return;
        if (!user) return history.replace("/");
    }, [user, loading]);

    return (
        <div className="box">
            <div className="row header">
                <h1 className="title" >PR2 - Bulakin 3</h1>
                <button onClick={signOut}>Sign out</button>
            </div>
            <div className="row content">
                <p id="last-update-time">Last update time: <b>{lastUpdateTime}</b></p>
                <div className="realtime-card">
                    <Card
                        title={"Humidity"}
                        value={humidity} />
                    <Card
                        title={"Air Temperature"}
                        value={airTemperature} />
                    <Card
                        title={"Soil Temperature"}
                        value={soilTemperature} />
                    <Card
                        title={"Soil Moisture"}
                        value={soilMoisture} />
                    <Card
                        title={"Light"}
                        value={light} />
                </div>
            </div>
            <h4 id="past-data">Past data</h4>
            <ul className="past-data-list">{listItems}</ul>
        </div>
    )
}

export default Dashboard