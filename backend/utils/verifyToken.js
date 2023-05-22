const jwt = require("jsonwebtoken");
const Timeline = require("../models/Timeline");

//verifying token (checkin whether use is loggedin or not)
const verifyToken = (req, res, next) => {
  const token = req.cookies.access_token;
  if (!token) res.status(401).send("You are not authenticated");

  jwt.verify(token, process.env.JWT_KEY, (err, user) => {
    if (err) res.status(403).send("invalid token");
    req.user = user; //creating new user field in our request
    next();
  });
};

// verifying whether this request on this post is made by its recruiter or not
const verifySameRecruiter = (req, res, next) => {
  verifyToken(req, res, async () => {
    // console.log(req.user);

    const timeline = await Timeline.findById(req.params.id);
    if (!timeline) {
      return res.status(403).send("Timeline id is incorrect");
    }
    if (
      timeline.recruiterId.toString() === req.user.id &&
      req.user.role === "recruiter"
    ) {
      next();
    } else {
      return res.status(403).send("You are not authorized");
    }
  });
};

const verifyRecruiter = (req, res, next) => {
  verifyToken(req, res, async () => {
    // console.log(req.user)
    if (req.user.role === "recruiter") {
      next();
    } else {
      return res.status(403).send("You are not authorized");
    }
  });
};

// verify seeker
const verifyCandidate = (req, res, next) => {
  verifyToken(req, res, () => {
    if (req.user.id === req.params.id) {
      next();
    } else {
      return res.status(403).send("You are not authorized to see timeline");
    }
  });
};

module.exports = {
  verifyToken,
  verifyRecruiter,
  verifySameRecruiter,
  verifyCandidate,
};
