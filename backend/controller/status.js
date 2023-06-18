const Status = require("../models/Status");
const Timeline = require("../models/Timeline");
const Step = require("../models/Step");
const User = require("../models/User");
const { MailGenerator, transporter } = require("../utils/nodemailer");

const addUserStatus = async (req, res, next) => {
  try {
    const timelineId = req.params.timelineId;
    const stepId = req.params.stepId;

    const timeline = await Timeline.findById(timelineId);
    const step = await Step.findById(stepId);

    if (!timeline || !step) {
      res.send("add correct stepId and timelineId in params");
    }

    const emails = req.body.emails;
    const link = req.body.link;
    const statusPromises = emails.map(async (email) => {
      const existingStatus = await Status.findOne({ email });

      if (existingStatus) {
        existingStatus.timelineId = timelineId;
        existingStatus.stepId = stepId;
        await existingStatus.save();
        return existingStatus;
      } else {
        const newStatus = new Status({ email, timelineId, stepId });
        await newStatus.save();
        return newStatus;
      }
    });

    const userStatuses = await Promise.all(statusPromises);
    const response = {
      body: {
        name: "Jobline Here",
        intro: `Congratulations! You have been invited to join the recruitment timeline for the position of ${timeline.jobTitle} at ${timeline.company}. You can view your progress and any updates on your application through this link - ${link}. We wish you all the best on this journey!`,
      },
    };
    const mail = MailGenerator.generate(response);

    const messages = emails.map((email) => {
      return {
        from: process.env.EMAIL,
        to: email,
        subject: ` Your Journey with ${timeline.company} for the  ${timeline.jobTitle} Begins!`,
        html: mail,
      };
    });

    const emailPromises = messages.map((message) => {
      return transporter.sendMail(message);
    });

    Promise.all(emailPromises)
      .then(() => {
        console.log("emails sent");
      })
      .catch((err) => {
        console.error("Error sending emails:", err);
        return res.status(500).json({ err });
      });

    res.send(userStatuses);
  } catch (error) {
    next(error);
  }
};

const getUserStatus = async (req, res, next) => {
  try {
    const userId = req.user.id;
    const timelineId = req.params.id;

    // Check if the user is associated
    const user = await User.findById(userId);
    if (!user) {
      return res.status(404).send("User not associated ");
    }

    const email = user.email;

    // Retrieve the status document for the specified timeline and email
    const status = await Status.findOne({ timelineId, email });
    if (!status) {
      return res.send("Status not found for the user and timeline");
    }

    const stepId = status.stepId;
    const step = await Step.findById(stepId);
    const stepNumber = step.order;
    status.stepIdx = stepNumber;
    status.name = user.name;
    // console.log(status.name);
    await status.save();
    res.status(200).json({ status, stepNumber });
  } catch (error) {
    next(error);
  }
};

// const moveUserToNextStep = async (req, res, next) => {
//   try {
//     const timelineId = req.params.id;
//     const emails = req.body.emails; // Assuming 'emails' is an array of email addresses

//     const timeline = await Timeline.findById(timelineId);
//     if (!timeline) {
//       return res.status(404).send("Timeline not found");
//     }

//     // Find the status documents for the specified timeline and emails
//     const statuses = await Status.find({ timelineId, email: { $in: emails } });

//     if (statuses.length === 0) {
//       return res.status(404).send("Statuses not found");
//     }

//     const currentStepId = statuses[0].stepId; // Assuming all statuses have the same stepId

//     // Find the timeline document
//     const allSteps = await Step.find({ timelineId });

//     const sortedSteps = allSteps.sort((a, b) => a.order - b.order);

//     const currentStepIndex = sortedSteps.findIndex(
//       (step) => step._id.toString() === currentStepId.toString()
//     );

//     if (currentStepIndex === sortedSteps.length - 1) {
//       return res.send(
//         `The users have reached the last step of the timeline and step id`
//       );
//     }

//     const nextStep = sortedSteps[currentStepIndex + 1];

//     for (const status of statuses) {
//       status.stepId = nextStep._id;
//       await status.save();
//     }

//     res.send(`Users moved to the next step and step id = ${nextStep._id}`);
//   } catch (error) {
//     next(error);
//   }
// };

const moveUser = async (req, res, next) => {
  try {
    const timelineId = req.params.id;
    const userSteps = req.body; // Assuming 'userSteps' is an array of objects containing step ID and email

    const timeline = await Timeline.findById(timelineId);
    if (!timeline) {
      return res.status(404).send("Timeline not found");
    }
    // console.log(userSteps);

    for (const userStep of userSteps) {
      const { email, stepId } = userStep;

      const status = await Status.findOne({ timelineId, email });

      if (!status) {
        return res.status(404).send(`Status not found for email ${email} `);
      }

      if (status.status === "rejected" || status.status === "Rejected") {
        return res
          .status(403)
          .send(`User status is not pending for email ${email}`);
      }

      status.stepId = stepId;
      await status.save();
    }

    // let's notify the users

    const response = {
      body: {
        name: "Jobline Here",
        intro: `Great news! You have moved to the next phase of the recruitment process for ${timeline.jobTitle} at ${timeline.company}. Please log into Jobline to view the details and next steps. Keep up the great work!`,
      },
    };
    const mail = MailGenerator.generate(response);

    const messages = userSteps.map((userStep) => {
      const email = userStep.email;
      return {
        from: process.env.EMAIL,
        to: email,
        subject: `Progress Update for ${timeline.jobTitle}  at ${timeline.company}`,
        html: mail,
      };
    });

    const emailPromises = messages.map((message) => {
      return transporter.sendMail(message);
    });

    Promise.all(emailPromises)
      .then(() => {
        console.log("emails sent");
      })
      .catch((err) => {
        console.error("Error sending emails:", err);
        return res.status(500).json({ err });
      });

    res.send("Users moved successfully");
  } catch (error) {
    next(error);
  }
};

const getStatuses = async (req, res, next) => {
  try {
    const timelineId = req.params.id;

    let steps = await Step.find({ timelineId });
    const status = await Status.find({ timelineId });

    steps.sort((a, b) => a.order - b.order); // sorting the steps

    for (const step of steps) {
      const stepStatus = status.filter(
        (s) => s.stepId.toString() === step._id.toString()
      );
      step.status = stepStatus;
    }

    res.status(201).send({ steps });
  } catch (error) {
    next(error);
  }
};

const feedbackToUser = async (req, res, next) => {
  try {
    const feedbackDetails = req.body;
    const timelineId = req.params.id;

    const timeline = await Timeline.findById(timelineId);
    const messages = feedbackDetails.map((feedbackDetail) => {
      if (feedbackDetail.message === null || feedbackDetail.message === "") {
        const response = {
          body: {
            name: "Jobline Here",
            intro: [
              `We regret to inform you that you have not been selected to proceed to the next phase of the recruitment process for ${timeline.jobTitle} at ${timeline.company}.`,
              `We appreciate your interest in ${timeline.company} and encourage you to apply for future positions. Every experience brings you one step closer to your dream role!`,
            ],
            signature: "Best regards",
          },
        };
        const mail = MailGenerator.generate(response);
        const email = feedbackDetail.email;
        return {
          from: process.env.EMAIL,
          to: email,
          subject: ` Update on Your Application for ${timeline.jobTitle}  at ${timeline.company}`,
          html: mail,
        };
      } else {
        const msg = feedbackDetail.message;
        const response = {
          body: {
            name: "Jobline Here",
            intro: [
              `We regret to inform you that you have not been selected to proceed to the next phase of the recruitment process for ${timeline.jobTitle} at ${timeline.company}.`,
              `However, the recruiter has provided some feedback which may help in your future applications, please find it down below.
            `,
              `${msg}`,
            ],
            signature: "Best regards",
          },
        };
        const mail = MailGenerator.generate(response);
        const email = feedbackDetail.email;
        return {
          from: process.env.EMAIL,
          to: email,
          subject: ` Update on Your Application for ${timeline.jobTitle}  at ${timeline.company}`,
          html: mail,
        };
      }
    });

    const emailPromises = messages.map((message) => {
      return transporter.sendMail(message);
    });

    Promise.all(emailPromises)
      .then(() => {
        console.log("emails sent");
      })
      .catch((err) => {
        console.error("Error sending emails:", err);
        return res.status(500).json({ err });
      });

    res.status(200).send("feedback send successfully");
  } catch (error) {
    next(error);
  }
};

const withdrawStatus = async (req, res, next) => {
  try {
    const timelineId = req.params.id;
    const userId = req.user.id;

    const user = await User.findById(userId);
    const email = user.email;

    await Status.findOneAndDelete({ timelineId, email });

    const timeline = await Timeline.findById(timelineId);
    const recruiterId = timeline.recruiterId;

    const recruiter = await User.findById(recruiterId);
    const recruiterEmail = recruiter.email;

    const mailOptions = {
      from: process.env.EMAIL,
      to: recruiterEmail,
      subject: "Withdrawal Notification",
      text: `Dear Recruiter,
    
    This is to inform you that the timeline for ${timeline.jobTitle} has been withdrawn by the user with email ${email}.
    
    Regards,
    Your Name`,
    };

    const emailPromise = new Promise((resolve, reject) => {
      transporter.sendMail(mailOptions, (error, info) => {
        if (error) {
          reject(error);
        } else {
          resolve(info);
        }
      });
    });

    Promise.all([emailPromise])
      .then(() => {
        console.log("Email sent");
        return res.status(200).json("Successfully sent email");
      })
      .catch((error) => {
        console.error("Error sending email:", error);
        return res.status(500).json({ error: "Failed to send email" });
      });

    return res.status(200).json("Sucessfully withdraw");
  } catch (error) {
    next(error);
  }
};

module.exports = {
  addUserStatus,
  getUserStatus,
  // moveUserToNextStep,
  getStatuses,
  feedbackToUser,
  moveUser,
  withdrawStatus,
};
