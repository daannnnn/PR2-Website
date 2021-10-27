import './App.css';
import Dashboard from './Dashboard';
import Login from './Login';

import { BrowserRouter as Router, Route, Switch } from "react-router-dom"

function App() {
    return (
        <div>
            <Router>
                <Switch>
                    <Route exact path='/' component={Login}/>
                    <Route exact path='/dashboard' component={Dashboard}/>
                </Switch>
            </Router>
        </div>
    )
}

export default App