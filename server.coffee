watch = require('watch')
email = require('emailjs')
schedule= require('node-schedule')
require('datejs')

parseDataEmail = (filename)=>
  emailAddress = filename.split("_")[0]
  dateTime = new Date(filename.split("_")[1])
  {email: emailAddress.split("/")[1], date: dateTime}


server  = email.server.connect
   user:    "adlerphotoemail" 
   password:"adlerPhotoEmail"
   host:    "smtp.gmail.com"
   ssl:     true


watch.createMonitor 'pics', (monitor)=> 
  monitor.on "created", (f,stat)=>
    details = parseDataEmail(f)
    console.log "scheduling email"
    schedule.scheduleJob details.date, =>
      console.log "sending to #{details.email}"
      server.send
        text:    "i hope this works"
        from:    "The adler <username@gmail.com>"
        to:      details.email
        subject: "testing emailjs"
      , (err, message)=>
        console.log err || message