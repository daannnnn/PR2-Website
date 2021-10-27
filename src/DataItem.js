import React from 'react';
import './DataItem.css';
import {Card} from '@material-ui/core';

function DataItem(props) {
    return (
        <Card className="past-data-card" variant="outlined">
            <div className="date-item-container">
                <div>
                    <p id="date">{props.date}</p>
                    <p id="time">{props.time}</p>
                </div>
            </div>
            <div className="past-data-card">
                <p className="sensor-info">Humidity: <b>{props.humidity}</b></p>
                <p className="sensor-info">Air Temp: <b>{props.air_temp}</b></p>
                <p className="sensor-info">Soil Temp: <b>{props.soil_temp}</b></p>
                <p className="sensor-info">Soil Moisture: <b>{props.soil_moisture}</b></p>
                <p className="sensor-info">Light: <b>{props.light}</b></p>
            </div>
        </Card>
    )
}

export default DataItem