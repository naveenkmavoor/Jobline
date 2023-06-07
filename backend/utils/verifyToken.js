const JWT =  require("jsonwebtoken");
const Timeline = require("../models/Timeline");

// //verifying token (checkin whether use is loggedin or not)
// const verifyToken = (req, res, next) => {
//   const token = req.cookies.access_token;
//   if (!token) res.status(401).send("You are not authenticated");

//   jwt.verify(token, process.env.JWT_KEY, (err, user) => {
//     if (err) res.status(403).send("invalid token");
//     req.user = user; //creating new user field in our request
//     next();
//   });
// };

const userAuth = async (req, res, next) => {
  const authHeader = req.headers.authorization;
  if (!authHeader || !authHeader.startsWith("Bearer"))
    return next("You are not authorized");

  const token = authHeader.split(" ")[1];

  try {
    const payload = JWT.verify(token, process.env.JWT_KEY);
    req.user = { id: payload.userId, role: payload.role };
    next();
  } catch (error) {
    next("Invalid token");
  }
};

// verifying whether this request on this post is made by its recruiter or not
const verifySameRecruiter = (req, res, next) => {
  userAuth(req, res, async() => {
    const timeline = await Timeline.findById(req.params.id);
    if (!timeline) {
      return res.status(403).send("Timeline id is incorrect");
    }
    // console.log(req.user)
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

// done
const verifyRecruiter = (req, res, next) => {
  userAuth(req, res, () => {
    if (req.user && req.user.role === "recruiter") return next();
    else return next("You are not authorized");
  });
};

// verify seeker
// done
const verifyCandidate = (req, res, next) => {
  userAuth(req, res, () => {
    if (req.user.id === req.params.id) {
      next();
    } else {
      return res.status(403).send("You are not authorized to see timeline");
    }
  });
};

module.exports = {
  userAuth,
  verifyRecruiter,
  verifySameRecruiter,
  verifyCandidate,
};
