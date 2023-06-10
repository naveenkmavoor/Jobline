const {
  addUserStatus,
  getUserStatus,
  getStatuses,
  feedbackToUser,
  moveUser,
  withdrawStatus,
} = require("../controller/status");
const {
  verifySameRecruiter,
  userAuth,
  verifyRecruiter,
} = require("../utils/verifyToken");

const router = require("express").Router();

router.post(
  "/timeline/:timelineId/step/:stepId",
  verifyRecruiter,
  addUserStatus
);
router.get("/getUser/:id", userAuth, getUserStatus);
router.post("/moveUser/:id", verifySameRecruiter, moveUser);
router.get("/getStatuses/:id", getStatuses);
router.post("/feedback/:id", feedbackToUser);
router.get("/withdraw/:id", userAuth, withdrawStatus);
module.exports = router;
