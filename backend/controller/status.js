const Status = require("../models/Status");
const Timeline = require("../models/Timeline");
const Step = require("../models/Step");
const User = require("../models/User");
const addUserStatus = async (req, res, next) => {
  try {
    const timelineId = req.params.timelineId;
    const stepId = req.params.stepId;

    const timeline = await Timeline.findById(timelineId);
    const step = await Step.findById(stepId);

    if (!timeline || !step) {
      res.send("add correct stepId and timelineId in params");
    }

    const email = req.body.email;

    // const user = await User.find({ email });
    // console.log(user[0]._id.valueOf());
    // const userId = user._id;
    // const timeline = await Timeline.find({_id:timelineId});
    // const step = timeline[0].steps[0];
    // const stepId = step.valueOf();
    // console.log(stepId);

    // Check if a document with the same email and timelineId exists
    const existingStatus = await Status.findOne({ email });

    if (existingStatus) {
      // Handle the situation where a document with the same email and timelineId already exists

      existingStatus.timelineId = timelineId;
      existingStatus.stepId = stepId;

      await existingStatus.save();

      return res.send(existingStatus);
    }

    // Create a new Status document
    const userStatus = new Status({ email, timelineId, stepId });
    await userStatus.save();

    // res.status(201).send("User added to the timeline");
    res.send(userStatus);
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
    await status.save();
    res.status(200).json({ status, stepNumber });
  } catch (error) {
    next(error);
  }
};

const moveUserToNextStep = async (req, res, next) => {
  try {
    const timelineId = req.params.id;
    const emails = req.body.emails; // Assuming 'emails' is an array of email addresses

    const timeline = await Timeline.findById(timelineId);
    if (!timeline) {
      return res.status(404).send("Timeline not found");
    }

    // Find the status documents for the specified timeline and emails
    const statuses = await Status.find({ timelineId, email: { $in: emails } });

    if (statuses.length === 0) {
      return res.status(404).send("Statuses not found");
    }

    const currentStepId = statuses[0].stepId; // Assuming all statuses have the same stepId

    // Find the timeline document
    const allSteps = await Step.find({ timelineId });

    // Sort the steps based on their order
    const sortedSteps = allSteps.sort((a, b) => a.order - b.order);

    // Find the index of the current step in the timeline
    const currentStepIndex = sortedSteps.findIndex(
      (step) => step._id.toString() === currentStepId.toString()
    );

    // Check if the current step is the last step in the timeline
    if (currentStepIndex === sortedSteps.length - 1) {
      return res.send(
        `The users have reached the last step of the timeline and step id`
      );
    }
    // Get the next step in the timeline
    const nextStep = sortedSteps[currentStepIndex + 1];

    // Update the status documents with the new stepId
    for (const status of statuses) {
      status.stepId = nextStep._id;
      await status.save();
    }

    res.send(`Users moved to the next step and step id = ${nextStep._id}`);
  } catch (error) {
    next(error);
  }
};

module.exports = { addUserStatus, getUserStatus, moveUserToNextStep };
