# Description:
#   Scrape the status of Popcorn Time's StatusPage.io
#
# Dependencies:
#   "htmlparser": "1.7.6"
#   "soupselect": "0.2.0"
#
# Commands:
#   hubot status
#
# Author:
#   frdmn <j@frd.mn>

HtmlParser = require "htmlparser"
Select     = require("soupselect").select

statusUrl = "http://status.get-popcorn.com"

module.exports = (robot) ->
  robot.respond /status( me)?$/i, (msg) ->
    msg.http(statusUrl)
      .get() (err, res, body) ->
        if err
            msg.send "There was an error fetching the status page!"
        else
            handler = new HtmlParser.DefaultHandler()
            parser = new HtmlParser.Parser handler
            parser.parseComplete body

            msgText = ""

            for component in Select(handler.dom, ".component-container")
              # Parse the service name
              element = component.children[0].children[0].data
              # Parse the CSS classes of the service name 
              elementClass = component.children[1].data.split " "[-1..]
              isGreen = /green/i.test(elementClass)

              # Check if status is green => online
              if isGreen
                msgText += "#{element} is online, "
              # If not, it's offline
              else 
                msgText += "#{element} is offline, "

            # Remove trailing ", "
            msgText = msgText.substring(0, msgText.length - 2);
            # Send to user
            msg.send msgText