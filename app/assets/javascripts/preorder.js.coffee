Selfstarter =
	firstTime: true
	validateEmail: ->
		# The regex we use for validating email
		# It probably should be a parser, but there isn't enough time for that (Maybe in the future though!)
		if /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/.test($("#order_email").val())
			$("#order_email").removeClass("highlight")
			$("#self_button").removeClass("disabled")
		else
			$("#order_email").addClass("highlight") unless Selfstarter.firstTime
			$("#self_button").addClass("disabled") unless $("#self_button").hasClass("disabled")
	init: ->
		$("#order_email").bind "textchange", ->
			Selfstarter.validateEmail()
		$("#order_email").bind "hastext", ->
			Selfstarter.validateEmail()
		# The first time they type in their email, we don't want it to throw a validation error
		$("#order_email").change ->
			Selfstarter.firstTime = false
$ ->
	Selfstarter.init()
	$("#order_email").focus()
