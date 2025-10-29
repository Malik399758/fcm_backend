/*
const { google } = require("googleapis");
const axios = require("axios");

// Load your Firebase service account key file
const serviceAccount = require("./serviceAccountKey.json");

// ✅ Fix newline issue in private key
const privateKey = serviceAccount.private_key.replace(/\\n/g, "\n");

// Debug check
console.log("🔑 Private key starts with:", privateKey.substring(0, 40));
console.log("🔑 Private key ends with:", privateKey.slice(-40));

async function getAccessToken() {
  try {
    const jwtClient = new google.auth.JWT({
      email: serviceAccount.client_email,
      key: privateKey,
      scopes: ["https://www.googleapis.com/auth/firebase.messaging"],
    });

    const tokens = await jwtClient.authorize();
    console.log("✅ Access Token generated successfully!");
    return tokens.access_token;
  } catch (err) {
    console.error("❌ Error getting access token:", err.message);
    throw err;
  }
}

async function sendNotification(fcmToken, title, body) {
  const accessToken = await getAccessToken();
  const projectId = serviceAccount.project_id;

  const message = {
    message: {
      token: fcmToken,
      notification: { title, body },
      data: { click_action: "FLUTTER_NOTIFICATION_CLICK" },
    },
  };

  try {
    const response = await axios.post(
      `https://fcm.googleapis.com/v1/projects/${projectId}/messages:send`,
      message,
      {
        headers: {
          "Authorization": `Bearer ${accessToken}`,
          "Content-Type": "application/json",
        },
      }
    );

    console.log("✅ Notification sent successfully!");
    console.log(response.data);
  } catch (err) {
    console.error("❌ Error sending notification:", err.response?.data || err.message);
  }
}

// Test send
sendNotification(
  "eCmU7qk4R66wdGhdoDhBzH:APA91bH4QkrlKBQyVk5VJ9V30wpfEb88vYYR4rhZqF03GA9KcwN37FDhrhXyk5uX6Ay-M0NR13ylTrHvjLTj4q9d4ELopI0dlcy7P4q9YdiDl2iv0bWK0n4",
  "🎉 Hello Yaseen!",
  "Your FCM push notification is now working 🚀"
);
*/

const { google } = require("googleapis");
const axios = require("axios");
const express = require("express");
const cors = require("cors");

// Load your Firebase service account key file
const serviceAccount = require("./serviceAccountKey.json");

// Fix newline issue in private key
const privateKey = serviceAccount.private_key.replace(/\\n/g, "\n");

// Express app setup
const app = express();
app.use(cors());
app.use(express.json());

// Function to generate Access Token
async function getAccessToken() {
  const jwtClient = new google.auth.JWT({
    email: serviceAccount.client_email,
    key: privateKey,
    scopes: ["https://www.googleapis.com/auth/firebase.messaging"],
  });

  const tokens = await jwtClient.authorize();
  console.log("Access Token generated successfully!");
  return tokens.access_token;
}

// Main endpoint
app.post("/send", async (req, res) => {
  const { token, title, body } = req.body;

  if (!token || !title || !body) {
    return res.status(400).json({ error: "Missing required fields (token, title, body)" });
  }

  try {
    const accessToken = await getAccessToken();
    const projectId = serviceAccount.project_id;

    const message = {
      message: {
        token,
        notification: { title, body },
        data: { click_action: "FLUTTER_NOTIFICATION_CLICK" },
      },
    };

    const response = await axios.post(
      `https://fcm.googleapis.com/v1/projects/${projectId}/messages:send`,
      message,
      {
        headers: {
          Authorization: `Bearer ${accessToken}`,
          "Content-Type": "application/json",
        },
      }
    );

    console.log("Notification sent successfully!");
    res.status(200).json(response.data);
  } catch (err) {
    console.error("Error sending notification:", err.response?.data || err.message);
    res.status(500).json({ error: err.response?.data || err.message });
  }
});

app.get("/", (req, res) => {
  res.send("FCM Notification Server is running successfully!");
});

// Run the server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`🚀 Server running on port ${PORT}`));
