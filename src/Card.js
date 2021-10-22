import './Card.css';
import {Card as MaterialCard} from '@material-ui/core';

function Card(props) {
    return (
        <div className="card-container">
            <MaterialCard className="card" variant="outlined">
                <p className="card-value">{props.value}</p>
                <p className="card-title">{props.title}</p>
            </MaterialCard>
        </div>
    )
}

export default Card