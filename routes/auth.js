const { registerUser, loginUser } = require("../controller/auth");
const router = require("express").Router();

router.post("/register", registerUser);
router.post("/login", loginUser);
module.exports = router;
