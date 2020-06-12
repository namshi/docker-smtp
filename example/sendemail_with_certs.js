// your smtp server is running in localhost port 25
const nodemailer = require("nodemailer");
const tls = require("tls");
const fs = require("fs");

const cert = fs.readFileSync("path to certs(pem)");
const key = fs.readFileSync("path to key(pem)");

const secured = {
  host: "127.0.0.1",
  port: 25,
  secure: true,
  tls: {
    rejectUnauthorized: false,
    secureContext: tls.createSecureContext({
      cert,
      key,
    }),
  },
};

function sendEmailWithTLS() {
  const transporter = nodemailer.createTransport(secured);

  const mailOptions = {
    from: "your@example.com",
    to: "to@example.com",
    subject: "Sending Email with CERTS",
    text: "Send email with certs",
  };

  transporter.sendMail(mailOptions, function (error, info) {
    if (error) {
      console.log(error);
    } else {
      console.log("Email sent: " + info.response);
    }
  });
}

sendEmailWithTLS();
