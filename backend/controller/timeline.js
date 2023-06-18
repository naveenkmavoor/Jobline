const Step = require("../models/Step");
const TimeLine = require("../models/Timeline");
const Status = require("../models/Status");
const User = require("../models/User")
const createTimeLine = async (req, res, next) => {
  try {
    const id = req.user.id;
    const data = { ...req.body, recruiterId: id };
    const timeline = new TimeLine(data);
    await timeline.save();
    res.status(201).json(timeline);
  } catch (err) {
    next(err);
  }
};

// const addSteps = async (req, res, next) => {
//   try {
//     const timelineId = req.params.id;

//     // data in form [ {} , {} , {} ]

//     const data = req.body;
//     const timeline = await TimeLine.findById(timelineId);
//     if (!timeline) {
//       return res.status(404).json({ message: "Timeline not found" });
//     }
//     const steps = await Step.find({ timelineId });

//     if (!timeline.steps) {
//       timeline.steps = [];
//     }
//     const currentStepsCount = steps.length;
//     const addedSteps = [];
//     console.log(currentStepsCount);

//     for (let i = 0; i < data.length; i++) {
//       const stepData = data[i];
//       const stepOrder = currentStepsCount + i; // Calculate the order value

//       const step = new Step({
//         ...stepData,
//         timelineId,
//         order: stepOrder,
//       });

//       await step.save();
//       timeline.steps.push(step);
//       addedSteps.push(step);
//     }
//     await timeline.save();
//     res.status(201).json({ timeline, addedSteps });
//   } catch (error) {
//     next(error);
//   }
// };

const addSteps = async (req, res, next) => {
  try {
    const timelineId = req.params.id;
    const data = req.body;

    const timeline = await TimeLine.findById(timelineId);
    if (!timeline) {
      return res.status(404).json({ message: "Timeline not found" });
    }

    // Delete existing steps
    await Step.deleteMany({ timelineId });

    const addedSteps = [];

    for (let i = 0; i < data.length; i++) {
      const stepData = data[i];
      const stepOrder = i;

      const step = new Step({
        ...stepData,
        timelineId,
        order: stepOrder,
      });

      await step.save();
      addedSteps.push(step);
    }

    timeline.steps = addedSteps;
    await timeline.save();

    res.status(201).json({ timeline, steps: addedSteps });
  } catch (error) {
    next(error);
  }
};

const getTimeLine = async (req, res, next) => {
  try {
    const timelineId = req.params.id;
    const timeline = await TimeLine.findById(timelineId);

    if (!timeline) {
      next("TimelineId is incorrect.");
    }

    const recruiterId = timeline.recruiterId;
    const recruiter = await User.findById(recruiterId);

    const email = recruiter.email;

    let steps = await Step.find({ timelineId });
    const status = await Status.find({ timelineId });

    steps.sort((a, b) => a.order - b.order); // sorting the steps

    // Iterate through each step
    for (const step of steps) {
      const stepStatus = status.filter(
        (s) => s.stepId.toString() === step._id.toString()
      );
      step.status = stepStatus; // Assign the statuses to the step
    }

    const numberOfSteps = steps.length;
    const jobLink = timeline.jobPostLink;

    res.status(201).send({ timeline, steps, numberOfSteps, jobLink, email });
  } catch (error) {
    next(error);
  }
};

const deleteTimeline = async (req, res) => {
  try {
    const timelineId = req.params.id;
    const steps = await Step.deleteMany({ timelineId });
    const deletedTimeline = await TimeLine.findByIdAndDelete(timelineId);
    if (!deletedTimeline) {
      return res.status(404).json({ message: "Timeline not found" });
    }
    res.status(201).send("Timeline deleted successfully");
  } catch (error) {
    next(error);
  }
};

const deleteStep = async (req, res, next) => {
  try {
    const stepId = req.params.id;
    const deletedStep = await Step.findByIdAndDelete(stepId);
    if (!deletedStep) {
      return res.status(404).send("Step not found");
    }
    const timelineId = deletedStep.timelineId;

    const steps = await Step.find({ timelineId }).sort({ order: 1 });
    for (let i = 0; i < steps.length; i++) {
      const step = steps[i];
      step.order = i;
      await step.save();
    }

    res.status(201).send("Step deleted successfully");
  } catch (error) {
    next(error);
  }
};

const getAllTimelines = async (req, res, next) => {
  try {
    const id = req.user.id;
    const timeline = await TimeLine.find({ recruiterId: id });

    return res.status(201).send(timeline);
  } catch (error) {
    next(error);
  }
};

module.exports = {
  createTimeLine,
  addSteps,
  getTimeLine,
  deleteTimeline,
  deleteStep,
  getAllTimelines,
};
