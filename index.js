// qfEplOjttCeI4mLo
const express = require("express");
require("dotenv").config();
const mongoose = require("mongoose");
const authRoutes = require("./routes/auth");
const app = express();
const cookieParser = require("cookie-parser");

const mongoURL = process.env.MONGO_URL;
mongoose.set("strictQuery", true);
mongoose.connect(mongoURL, { useUnifiedTopology: true, useNewUrlParser: true });

const db = mongoose.connection;

db.on("connected", () => {
  console.log("Database Connected");
});
db.on("error", () => {
  console.log("Connection Failed");
  throw "error";
});
db.on("disconnected", () => {
  console.log("Database Disconnected");
});

app.use(cookieParser());
app.use(express.json());
app.use("/api/auth", authRoutes);

//Error Handeling Middleware
app.use((err, req, res, next) => {
  const errorStatus = err.status || 500;
  const errorMessage = err.message || "Something went wrong";
  return res.status(errorStatus).json({
      success: false,
      status: errorStatus,
      message: errorMessage,
      stack: err.stack,
  });
});

app.listen(8080, () => {
  console.log("Server Connected on port 8080");
});
