const mongoose = require("mongoose");
const jwt = require("jsonwebtoken");

const userSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
  },
  email: {
    type: String,
    required: true,
    unique: true,
  },
  password: {
    type: String,
    required: true,
  },
  avatar: {
    type: String,
  },
  role: {
    type: String,
    required: true,
  },
});

// JSON Token
userSchema.methods.createJWT = function () {
  try {
    const token = jwt.sign(
      { userId: this._id, role: this.role },
      process.env.JWT_KEY,
      {
        expiresIn: "3d",
      }
    );
      return token;
  } catch (error) {
    console.log("Token generation error:", error);
  }
};

const User = mongoose.model("User", userSchema);
module.exports = User;
