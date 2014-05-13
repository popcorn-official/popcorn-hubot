# Description:
#   Inspect the data in redis easily
#
# Commands:
#   hubot show users - Display all users that hubot knows about
#   hubot show storage - Display the contents that are persisted in the brain


Util = require "util"

module.exports = (robot) ->
  robot.respond /show storage$/i, (msg) ->
    output = Util.inspect(robot.brain.data, false, 4)
    msg.send output

  robot.respond /show users$/i, (msg) ->
    if robot.auth.hasRole(msg.envelope.user, "admin")
        response = ""

        for own key, user of robot.brain.data.users
          response += "#{user.id} #{user.name}"
          response += " <#{user.email_address}>" if user.email_address
          response += "\n"

        msg.send response
    else
        msg.send "Sorry, you do not have the required permissions to execute this command!"