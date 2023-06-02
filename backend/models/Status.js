const mongoose = require("mongoose");

const statusSchema = new mongoose.Schema({
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
  email:{
    type:String,
    unique:false
  }
});

const Status = mongoose.model("Status", statusSchema);
module.exports = Status;
