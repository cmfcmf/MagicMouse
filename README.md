# MagicMouse Browser

[![Build Status](https://travis-ci.com/cmfcmf/MagicMouse.svg?branch=master)](https://travis-ci.com/cmfcmf/MagicMouse)

MagicMouse is a webbrowser for [Squeak](https://squeak.org). It uses Chrome/Chromium under the hood to render websites and displays them as ImageMorphs right inside Squeak.

MagicMouse runs on all platforms that run Squeak and Chrome, but works best and is most tested on Windows.

## Features

- Browse the web with a real browser right from Squeak
- Right-click on images and code to transform them into Morphs. I call those "Portals". Because portals are cool.

## Installation

The installation is a bit cumbersome at the moment:

1. Install a recent version of Chrome or Chromium. MagicMouse uses the Chrome DevTools protocol to communicate with the browser and relies on the newish and experimental [`startScreencast`](https://chromedevtools.github.io/devtools-protocol/tot/Page#method-startScreencast) functionality. Chrome 74 works for me.
2. Install Squeak 5.2+ (you probably have that already :D).
3. Install [Node.js](https://nodejs.org) and [yarn](https://yarnpkg.com).
4. Install MagicMouse via Metacello or the Git Browser (when using the Git Browser, make sure to install the dependencies listed in the Baseline separately).
```smalltalk
Metacello new
	baseline: 'MagicMouse';
	repository: 'github://cmfcmf/MagicMouse:master';
	load.
```
5. Clone this repository using your command-line Git client (**not** Squit), regardless of how you installed MagicMouse.
6. Run `yarn install` within the cloned repository.
7. Open the Squeak Perference Browser and change the `Git Repository Path` in the MagicMouse category to match the location of the cloned repository.
8. You probably also want to enable the `Enable debug` property to log debug output to the Transcript.

## Usage

MagicMouse provides two core classes for you to use: `MMBrowserMorph`, a simple image morph, and `MMBrowser`, a webbrowser with location and search bar.

In general, be advised that there is little to no error handling in place right now. If your webbrowser is no longer responding, there is a good chance it crashed. It is helpful to enable the `Enable debug` preference and watch the Transcript output to troubleshoot problems.

### `MMBrowserMorph`

This ImageMorph displays a website. It intercepts keyboard and mouse events and sends them to Chrome.
Open it by using the `open` or `openOn:` messages:

```smalltalk
MMBrowserMorph open "open with default url"

MMBrowserMorph openOn: 'https://github.com/cmfcmf/MagicMouse'
```

### `MMBrowser`

This tool features a location bar, a Google search bar and the browser content itself. Open it using:

```smalltalk
MMBrowser open "open with default url"

MMBrowser openOn: 'https://github.com/cmfcmf/MagicMouse'
```

## How it works

There are three components to make it work: Squeak, an intermediate Node.js script and Chrome.

### `run.js` <-[DevTools Protocol via WebSocket]-> Chrome

We use Node.js and the [puppeteer-core](https://www.npmjs.com/package/puppeteer-core) library to spawn and communicate with Chrome/Chromium. Puppeteer uses the [Chrome DevTools Protocol](https://chromedevtools.github.io/devtools-protocol/) to connect to Chrome. The DevTools protocol uses WebSockets for communication. The required Node.js script is located inside this repostiory and called `run.js`. It spawns the browser and then calls `startScreencast()` which instructs Chrome to regularly take a screenshot of the current window and send it to Node.js. Chrome is smart enough to only take screenshots when the page visually changes.

### Squeak <-[Pipe]-> `run.js`

Squeak communicates with the `run.js` script via `stdout`, `stdin` and `stderr`. Depending on the operating system, we either use OSProcess (Unix) or FFI (Windows) to pipe these streams into Squeak. We used ProcessWrapper on Windows previously, but found it rather unreliable.

### `stdout` and `stdin`

`stdout` and `stdin` are used for the communication between Squeak and `run.js`. We use a simple, custom protocol for communication. Each message starts with a `uint32_t` that specifies the length of the message in bytes. The following `char` identifies the type of the message. The rest of the message is specific to the message type. Some example messages include:

#### `stdout`: `run.js` -> Squeak

- browser screenshots
- location changes
- portal data (i.e., the data of an image that was requested by a "portal creation request")
- portal positions (everytime the page is re-rendered, an updated list of all portal positions is sent to Squeak)

#### `stdin`: Squeak -> `run.js`

- mouse movement, mouse events
- keyboard events
- viewport size changes
- portal creation requests
- location change requests

### `stderr`

`stderr` is used for debugging only. The `run.js` script prints debug information to `stderr`, which is read by Squeak and written to the Transcript if the `Enable debug` option is set.
