const mongoose = require("mongoose");

const statusSchema = new mongoose.Schema({
  email: {
    type: String,
    required: true,
  },
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "User",
  },
  stepId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "Step",
  },
  stepIdx: {
    type: Number,
    default: 0,
  },
  timelineId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "Timeline",
    required: true,
  },
  interviewLink: {
    type: String,
  },
  status: {
    type: String,
    default: "Pending",
  },
});

const Status = mongoose.model("Status", statusSchema);
module.exports = Status;
