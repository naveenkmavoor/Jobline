const Step = require("../models/Step");
const TimeLine = require("../models/Timeline");
const Status = require("../models/Status");

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

const addSteps = async (req, res, next) => {
  try {
    const timelineId = req.params.id;

    // data in form [ {} , {} , {} ]

    // const data = { ...req.body,timelineId};
    // const step = new Step(data);
    // await step.save();

    // const timeline = await TimeLine.findById(timelineId);
    // timeline.steps.push(step);
    // timeline.save();

    const data = req.body;
    const timeline = await TimeLine.findById(timelineId);
    if (!timeline) {
      return res.status(404).json({ message: "Timeline not found" });
    }

    if (!timeline.steps) {
      timeline.steps = [];
    }
    const addedSteps = await Promise.all(
      data.map(async (stepData, index) => {
        const step = new Step({ ...stepData, timelineId, order: index });
        await step.save();
        timeline.steps.push(step);
        return step;
      })
    );
    await timeline.save();
    // await timeline.populate("steps").execPopulate();
    res.status(201).json({ timeline, addedSteps });
  } catch (error) {
    next(error);
  }
};

const getTimeLine = async (req, res, next) => {
  try {
    const timelineId = req.params.id;
    const timeline = await TimeLine.findById(timelineId);
    let steps = await Step.find({ timelineId });
    const status = await Status.find({ timelineId });

    steps.sort((a, b) => a.order - b.order); // sorting the steps

    res.status(201).send({ timeline, steps, status });
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

module.exports = { createTimeLine, addSteps, getTimeLine, deleteTimeline };
