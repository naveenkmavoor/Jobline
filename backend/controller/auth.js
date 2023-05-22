const User = require("../models/User");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");

const registerUser = async (req, res, next) => {
  try {
    const email = req.body.email;
    const checkEmail = await User.findOne({ email });
    if (checkEmail) {
      return res.status(500).send("User with this email already exists");
    }

    const { password } = req.body;
    const salt = bcrypt.genSaltSync(10);
    const hash = bcrypt.hashSync(password, salt);

    const newUser = new User({ ...req.body, password: hash });
    await newUser.save();

    // generating token while in registering
    const token = jwt.sign(
      { id: newUser._id, role: newUser.role },
      process.env.JWT_KEY,
      { expiresIn: "7d" }
    );

    res
      .cookie("access_token", token, {
        maxAge: 7 * 24 * 60 * 60 * 1000,
      })
      .status(201)
      .json({ ...req.body });
  } catch (error) {
    return res.send(error);
  }
};

const loginUser = async (req, res, next) => {
  try {
    const email = req.body.email;

    const checkUser = await User.findOne({ email });
    if (!checkUser) return res.status(404).send("Wrong username or password");

    if (!req.body.password) {
      return res.status(400).send("Please enter Password");
    }

    const passCheck = await bcrypt.compare(
      req.body.password,
      checkUser.password
    );

    if (!passCheck) return res.status(400).send("Wrong username or password");

    const token = jwt.sign(
      { id: checkUser._id, role: checkUser.role },
      process.env.JWT_KEY
    );

    const { password, role, ...others } = checkUser._doc;

    res
      .cookie("access_token", token, {
        maxAge: 7 * 24 * 60 * 60 * 1000,
      })
      .status(200)
      .json({ ...others, role });
  } catch (error) {
    return res.send(error);
  }
};

module.exports = { registerUser, loginUser };
