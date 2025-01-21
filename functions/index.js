/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

//const {onRequest} = require("firebase-functions/v2/https");
//const logger = require("firebase-functions/logger");

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.deleteExpiredStories = functions.pubsub.schedule("every 1 hour").onRun(async (context) => {
  const now = admin.firestore.Timestamp.now();
  const cutoff = new Date(now.toDate().getTime() - 24 * 60 * 60 * 1000); // 24 hours ago

  const storiesRef = admin.firestore().collection("stories");
  const expiredStories = await storiesRef.where("timestamp", "<", cutoff).get();

  const batch = admin.firestore().batch();
  expiredStories.forEach((doc) => {
    batch.delete(doc.ref);
  });

  await batch.commit();
  console.log("Expired stories deleted successfully.");
});

