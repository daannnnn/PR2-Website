import { initializeApp } from "firebase/app";
import { getDatabase } from "firebase/database";
import { getAuth, signInWithEmailAndPassword } from "firebase/auth";

const firebaseConfig = {
  apiKey: "AIzaSyCuAZyTlzRAxdzToDntK4vODxMWg4du2PE",
  authDomain: "arduino-test-d1dc0.firebaseapp.com",
  databaseURL: "https://arduino-test-d1dc0-default-rtdb.asia-southeast1.firebasedatabase.app",
  projectId: "arduino-test-d1dc0",
  storageBucket: "arduino-test-d1dc0.appspot.com",
  messagingSenderId: "650878921562",
  appId: "1:650878921562:web:50ece78906d686a73fa163"
};

const app = initializeApp(firebaseConfig);
const db = getDatabase(app);
const auth = getAuth(app);

function signIn(email, password) {
  signInWithEmailAndPassword(auth, email, password)
    .catch((error) => {
      alert(error.message);
    }
  );
}

function signOut() {
  auth.signOut();
}

export { db, auth, signIn, signOut }