const mongoose = require("mongoose");

const TimelineSchema = new mongoose.Schema({
  recruiterId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "Recruiter",
    required: true,
  },
  steps: [
    {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Step",
      required: true,
    },
  ],
  jobLink: {
    type: String,
  },
});

const Timeline = mongoose.model("Timeline", TimelineSchema);
module.exports = Timeline;
