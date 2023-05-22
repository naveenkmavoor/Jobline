const {
  addUserStatus,
  getUserStatus,
  moveUserToNextStep,
} = require("../controller/status");
const { verifySameRecruiter, verifyToken } = require("../utils/verifyToken");

const router = require("express").Router();

router.post("/timeline/:timelineId/step/:stepId", verifyToken, addUserStatus);
router.get("/getUser/:id", verifyToken, getUserStatus);
router.post("/moveUser/:id", verifySameRecruiter, moveUserToNextStep);
module.exports = router;
