const nodemailer = require("nodemailer");
const Mailgen = require("mailgen");

const config = {
  service: "gmail",
  auth: {
    user: process.env.EMAIL,
    pass: process.env.PASS,
  },
  debug: true, // Enable debugging output
};

const transporter = nodemailer.createTransport(config);

const MailGenerator = new Mailgen({
  theme: "default",
  product: {
    name: "Mailgen",
    link: "https://mailgen.js/",
  },
});

module.exports = { transporter, MailGenerator };
