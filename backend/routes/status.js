const {
  addUserStatus,
  getUserStatus,
  moveUserToNextStep,
} = require("../controller/status");
const { verifySameRecruiter, verifyToken, verifyRecruiter } = require("../utils/verifyToken");

const router = require("express").Router();

router.post("/timeline/:timelineId/step/:stepId", verifyRecruiter, addUserStatus);
router.get("/getUser/:id", verifyToken, getUserStatus);
router.post("/moveUser/:id", verifySameRecruiter, moveUserToNextStep);
module.exports = router;
