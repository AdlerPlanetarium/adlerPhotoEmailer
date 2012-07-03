watch     = require 'watch'
schedule  = require 'node-schedule'
eco       = require 'eco'
fs        = require 'fs'

moment    = require('moment')

delays       = require('./delays')
emailServer  = require('./emailConfig')
template     = fs.readFileSync 'emailTemplate.eco', 'utf-8'

parseDetails = (filename)=>
  console.log "parsting #{filename}"
  sentDate  = moment(filename.split("_")[1] , "YYYY.M.DD-HH.mm.SS")
  location  = filename.split("_")[2]

  email     : filename.split("_")[0].split("/")[1]
  sentDate  : sentDate
  location  : location
  sendDate  : sentDate.add('hours', delays[location]);


scheduleEmail = (details)=>
  console.log "seding at #{details.sendDate.format('YYYY.M.DD-HH.mm.SS')}"
  schedule.scheduleJob details.sendDate.utc(), =>
    console.log "sending to #{details.email}"
    emailServer.send
      text:    eco.render templage, details
      from:    "The adler <username@gmail.com>"
      to:      details.email
      subject: "Your Blast From the Past"
    , (err, message)=>
      console.log err || message


watch.createMonitor 'pics', (monitor)=> 
  monitor.on "created", (f,stat)=>
    details = parseDetails(f)
    console.log "scheduling email"
    scheduleEmail details
   