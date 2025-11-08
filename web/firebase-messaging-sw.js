// Import and configure the Firebase SDK
import { initializeApp } from 'https://www.gstatic.com/firebasejs/9.0.0/firebase-app.js';
import { getMessaging } from 'https://www.gstatic.com/firebasejs/9.0.0/firebase-messaging.js';

// Your web app's Firebase configuration
const firebaseConfig = {
  apiKey: "AIzaSyCnqcdVf_RCduJQITtNMAh3dHmZ-Eqx2j4",
  authDomain: "flutter-e273f.firebaseapp.com",
  projectId: "flutter-e273f",
  storageBucket: "flutter-e273f.firebasestorage.app",
  messagingSenderId: "175405197111",
  appId: "1:175405197111:web:1ed8854a16a6b88dc69cb2"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);

// Initialize Firebase Cloud Messaging and get a reference to the service
const messaging = getMessaging(app);

// Handle background messages
messaging.onBackgroundMessage(function(payload) {
  console.log('[firebase-messaging-sw.js] Received background message ', payload);
  
  const notificationTitle = payload.notification.title;
  const notificationOptions = {
    body: payload.notification.body,
    icon: '/icons/Icon-192.png'
  };

  self.registration.showNotification(notificationTitle, notificationOptions);
});