# Slide / PDF Viewer Component

The `pdf-viewer` component is developed independently from this project. Code as
well as documentation can be found [here](github.com:munen/pdf-viewer).

## How to import a new version

1. If not checked into the repo, compile a new minified version
 * `lein figwheel`
 * `(build-once min)`
1. Copy the new minified file to this repo
 * `cp pdf-viewer-repo/dist/pdf-viewer.js
   voicerepublic_dev/public/pdf_viewer/pdf-viewer-0.x.y.js`
 * Make sure to adapt `x` and `y` to the current release version of
   `pdf-viewer`
1. If the actual [PDFjs](https://github.com/mozilla/pdf.js) version changed in
   `pdf-viewer`, make sure to also import the new `pdf-viewer.worker.js` file
   by copying it over and also giving it a new revision.
1. Update revision in the `<script>` include tag
 * In app/views/talks/show.html.haml, update the revision of pdf-viewer and if
   necessary of pdf-viewer.worker
