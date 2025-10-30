/**
 * Firebase Cloud Function for sending FCM notifications
 */

const { onRequest } = require("firebase-functions/v2/https");
const { google } = require("googleapis");
const axios = require("axios");
const express = require("express");
const cors = require("cors");

const serviceAccount = require("./serviceAccountKey.json");

// Fix private key line breaks
const privateKey = serviceAccount.private_key.replace(/\\n/g, "\n");

const app = express();
app.use(cors());
app.use(express.json());

// Generate Access Token
async function getAccessToken() {
  const jwtClient = new google.auth.JWT({
    email: serviceAccount.client_email,
    key: privateKey,
    scopes: ["https://www.googleapis.com/auth/firebase.messaging"],
  });
  const tokens = await jwtClient.authorize();
  return tokens.access_token;
}

// Main endpoint
app.post("/send", async (req, res) => {
  const { token, title, body } = req.body;
  if (!token || !title || !body) {
    return res.status(400).json({ error: "Missing token, title or body" });
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

    res.status(200).json(response.data);
  } catch (err) {
      console.error(
        "Error sending notification:",
        (err.response && err.response.data) ? err.response.data : err.message
      );
      res.status(500).json({
        error: (err.response && err.response.data) ? err.response.data : err.message
      });
    }

});

// Root test route
app.get("/", (req, res) => {
  res.send("🔥 Firebase FCM Notification Server is running!");
});

// ✅ Export the Express app as a Firebase Function
exports.api = onRequest(app);
