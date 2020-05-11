// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import 'bootstrap';
import "../css/app.scss"
import "boxicons";

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import deps with the dep name or local files with a relative path, for example:
//
//     import {Socket} from "phoenix"
//     import socket from "./socket"
//
import "phoenix_html"
import {Socket} from "phoenix"
import NProgress from "nprogress"
import {LiveSocket} from "phoenix_live_view"

function sleep(delay) {
  var start = new Date().getTime();
  while (new Date().getTime() < start + delay);
}

let Hooks = {}


Hooks.DisplayPdfModal = {
  mounted() {
    this.el.addEventListener("click", e => {
      const pdf = document.getElementById("pdfBtn")
      sleep(500)
      alert("click")
      pdf.click()
    })
  }
}


let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {hooks: Hooks, params: {_csrf_token: csrfToken}})


// let liveSocket = new LiveSocket("/live", Socket, { _csrf_token: csrfToken, hooks: Hooks });



// Show progress bar on live navigation and form submits
window.addEventListener("phx:page-loading-start", info => NProgress.start())
window.addEventListener("phx:page-loading-stop", info => NProgress.done())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)
window.liveSocket = liveSocket
