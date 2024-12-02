const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.notifyTaskReminder = functions.database
  .ref("/tasks/{taskId}")
  .onCreate(async (snapshot, context) => {
    const task = snapshot.val();

    const timeToComplete = new Date(task.date + "T" + task.timeToComplete);
    const notificationTime = new Date(timeToComplete.getTime() - 10 * 60 * 1000);

    const now = new Date();
    if (notificationTime <= now) {
      console.log("Notification time has already passed");
      return null;
    }

    const payload = {
      notification: {
        title: "Task Reminder",
        body: `Your task "${task.title}" is due in 10 minutes.`,
      },
      data: {
        taskId: context.params.taskId,
      },
    };

    // Get device token(s) from the user profile (modify as needed)
    const tokens = task.userTokens; // Assume you save user tokens with tasks

    if (!tokens || tokens.length === 0) {
      console.log("No tokens available for notification");
      return null;
    }

    try {
      await admin.messaging().sendToDevice(tokens, payload);
      console.log("Notification sent successfully");
    } catch (error) {
      console.error("Error sending notification:", error);
    }

    return null;
  });
