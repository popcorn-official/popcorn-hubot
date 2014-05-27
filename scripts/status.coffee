# Description:
#   Get the status of Popcorn Time's StatusPage.io
#
# Dependencies:
#   "sugar": ""
#
# Commands:
#   hubot status
#
# Author:
#   frdmn <j@frd.mn>

statusUrl = "http://status.get-popcorn.com/index.json"

require("sugar")

module.exports = (robot) ->
  robot.respond /status( me)?$/i, (msg) ->
    msg.http(statusUrl)
      .get() (err, res, body) ->
        if err
          # Error => let user know 
          msg.send "There was an error fetching the status page!"
        else
          # Variables
          incidentsInProgress = 0
          statusLine = ""
          activeIncidents = []

          # Parse JSON
          response = JSON.parse body

          # For each component
          for component in response.components
            # Append to statusLine
            statusLine += "#{component.name}: #{component.status.humanize()}, "
            # Check if there is a non-operational component
            if component.status != "operational"
              # Increment incidents
              ++incidentsInProgress
          
          # Remove trailing ", " in statusLine
          statusLine = statusLine.substring(0, statusLine.length - 2);

          # Check if there are incidents in progress
          if incidentsInProgress != 0
            # Append info to statusLine
            statusLine += " - #{incidentsInProgress} active incident:"
            # Get more informations about incidents 
            for incident in response.incidents
              # If not "completed" or "resolved"
              if incident.status != "completed" && incident.status != "resolved"
                # Add to activeIncidents Array
                activeIncidents.push "* #{incident.name}: #{incident.status} - #{incident.incident_updates[0].body[0...50]}... (#{incident.shortlink})"

          # Send output
          msg.send statusLine
          msg.send activeIncidents.join '\n'