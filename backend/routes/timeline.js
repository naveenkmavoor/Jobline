const {
  createTimeLine,
  addSteps,
  getTimeLine,
  deleteTimeline,
  deleteStep,
} = require("../controller/timeline");
const {
  verifySameRecruiter,
  verifyToken,
  verifyRecruiter,
} = require("../utils/verifyToken");
const router = require("express").Router();

router.post("/", verifyRecruiter, createTimeLine); // only by recruiter
router.post("/:id", verifySameRecruiter, addSteps);
router.get("/:id", getTimeLine);
// router.delete("/:id", verifySameRecruiter, deleteTimeline);
router.delete("/:id", verifyRecruiter, deleteStep );

module.exports = router;
