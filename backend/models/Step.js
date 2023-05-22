const mongoose = require("mongoose");

const stepSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
  },
  description: {
    type: String,
  },
  information_link: {
    type: String,
  },
  eta: {
    type: Number,
    default: 3,
  },
  avatar: {
    type: String, // avatar of every step
  },
  timelineId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "Recruiter",
    required: true,
  },
  order: {
    type: Number,
  },
});

const Step = mongoose.model("Step", stepSchema);
module.exports = Step;
