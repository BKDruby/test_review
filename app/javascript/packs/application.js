import { Application } from "@hotwired/stimulus"
import { definitionsFromContext } from "stimulus/webpack-helpers"
import "bootstrap"
import "@popperjs/core"
import "../stylesheets/application.scss"

const application = Application.start()
const context = require.context("./controllers", true, /_controller\.js$/)
application.load(definitionsFromContext(context))
