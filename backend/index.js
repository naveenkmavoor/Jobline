const express = require("express");
require("dotenv").config();
const mongoose = require("mongoose");
const cors = require("cors");
const authRoutes = require("./routes/auth");
const timelineRoutes = require("./routes/timeline");
const statusRoute = require("./routes/status");
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
  // throw "error";
});
db.on("disconnected", () => {
  console.log("Database Disconnected");
});

//middlewares
// app.use(
//   cors({
//     origin: "https://deluxe-gelato-829e45.netlify.app",
//     methods: ["GET", "POST", "PUT", "DELETE"],
//     credentials: true,
//   })
// );

app.use(
  cors({
    origin: "*",                //just want to make sure if it's working 
    methods: ["GET", "POST", "PUT", "DELETE"],
    credentials: true,
  //add the below two lines as well 
    secure: true,
    sameSite: 'none'
  })
);

// app.use(function(req, res, next) {
//   res.header("Access-Control-Allow-Origin", "https://deluxe-gelato-829e45.netlify.app");
//   res.header("Access-Control-Allow-Methods", "GET,PUT,PATCH,POST,DELETE");
//   res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
//   next();
// });

app.use(cookieParser());
app.use(express.json());

app.use("/api/auth", authRoutes);
app.use("/api", timelineRoutes);
app.use("/api/user", statusRoute);

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
