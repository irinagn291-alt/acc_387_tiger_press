<!-- gf-brief source=768553ef784050eaaa8af8ecfbb6d2c33311f02c1d3c7d20f5c318ea62de8684 written=2026-11-18T14:17:50+03:00 -->
# Tiger Press

## What it is

Tiger Press is a coloring app for people who want to paint animal illustrations or turn their own photos into coloring stencils. You can work on multiple pictures, return to unfinished artwork, and export a copy to Files or Photos.

## Launch and onboarding

1. On first launch, the app opens directly to the drawing screen. There is no onboarding, welcome button, sign-in step, or permission prompt at launch.
2. The header reads “TIGER” above “PRESS”. The first canvas is the uncolored “Tiger mask”. “Brush” is selected, “INK” shows “Tangerine”, and “Stay inside the lines” is on.
3. Tap or drag on the canvas to paint. Tap “Sketchbook” to browse or import a stencil, or use the icon labeled “Export” to save a copy. On later launches, the last selected stencil and its saved artwork reopen.

## Screens

### “TIGER” / “PRESS”

The main screen is a scrollable drawing workspace with the current stencil on a white print, its title below the illustration, a tool rail, and the “INK” panel. There is no tab bar.

- “Sketchbook” opens the stencil collection.
- “Drawing canvas” is the accessibility label for the illustration. Tap to make a dot or drag to draw a stroke. With “Eraser” selected, the same gestures erase paint. The stencil outlines remain visible.
- “Brush” selects painting. “Eraser” selects erasing. Both are icon buttons with accessibility labels.
- “Undo” and “Redo” step backward and forward through edits to the current stencil, including a clear. Both are icon buttons with accessibility labels.
- “Clear artwork” is the trash icon’s accessibility label. It opens “Clear the artwork?” with “Clear artwork” to remove the current paint and “Cancel” to keep it.
- “INK” shows the selected color name. Tap a swatch to select that color and switch back to “Brush”. The swatches’ accessibility labels are “Marigold”, “Tangerine”, “Brick”, “Rose”, “Lilac”, “Cobalt”, “Sky”, “Teal”, “Fern”, “Pear”, “Sand”, “Umber”, “Charcoal”, and “Paper”. “Paper” is white ink.
- “Brush size” adjusts the width of new brush and eraser strokes.
- “Stay inside the lines” confines each stroke to the region where the gesture begins. Turn it off to draw or erase across regions.
- “Export” is the share-shaped icon’s accessibility label. “Save PNG to Files” opens the iOS save dialog with the stencil title as the suggested filename. “Save to Photos” adds a PNG to Photos. The exported print includes the illustration, the current paint, and the stencil title. An uncolored stencil can also be exported.

### “Sketchbook”

A dismissible sheet with a count such as “100 stencils” or “1 stencil”, photo import controls, search, filters, and a grid of titled previews. Previews show saved paint for each stencil.

- “Close” is the close icon’s accessibility label. Tap it or swipe the sheet down to return to the current canvas.
- Under “Make a stencil from a photo”, “Photo library” opens the iOS picker for a single image. “Camera” opens the iOS camera in still-photo mode when available and allowed. Canceling either system screen returns to “Sketchbook”. A successful import adds a numbered stencil such as “Photo study 1”, closes “Sketchbook”, and opens the new canvas.
- “Find an animal” searches stencil titles and their descriptive terms without regard to case. Search applies within the selected filter.
- “Show stencils” is the filter control’s label. “All stencils” includes built-in and imported stencils. “Tigers” includes titles containing “tiger”. “My artwork” shows stencils with active edits.
- Tap a titled preview to close “Sketchbook” and open that stencil. Switching stencils preserves each stencil’s work. Reopening “Sketchbook” starts with “All stencils” and an empty search.

### iOS photo, camera, and file screens

The photo picker lets you select or cancel an image. The camera lets you take a still photo and confirm, retake, or cancel it. The Files dialog lets you choose a destination and filename or cancel. iOS supplies the labels on these screens in the system language.

## Features

- “Sketchbook” with 100 built-in coloring stencils, searchable previews, and the “All stencils”, “Tigers”, and “My artwork” filters.
- “Make a stencil from a photo” using “Photo library” or “Camera”. Each successful import adds a new “Photo study” to the collection.
- Freehand dots and strokes with “Brush” and “Eraser”, 14 “INK” swatches, adjustable “Brush size”, and optional “Stay inside the lines”.
- Per-stencil “Undo”, “Redo”, and “Clear artwork”, with automatic saving of edits.
- “Save PNG to Files” and “Save to Photos” for the current print.

## Behaviours that can look like bugs

- “Undo” is disabled until there is an edit to undo. “Redo” is disabled until an edit has been undone. Making a new edit after “Undo” discards the redo history beyond that point.
- “Clear artwork” is disabled when the stencil has no active edits. After confirming “Clear artwork”, the stencil remains in “All stencils” and drops out of “My artwork”. Tap “Undo” to restore the previous work.
- “My artwork” can show “No artwork yet” with “Choose a stencil and add your first brushstroke.” Pick “All stencils”, open a stencil, and paint. A newly imported stencil appears in “All stencils” immediately and enters “My artwork” after its first edit.
- A search with no results shows “No matching animals” and “Try a different animal or collection.” Change or clear “Find an animal”, or switch filters. The count reflects the current results.
- With “Stay inside the lines” on, dragging across an outline leaves the stroke clipped to its starting region. Start a new stroke in the next region or switch the toggle off.
- “Photo library” and “Camera” are disabled during processing, with a spinner labeled “Loading photo” for accessibility. A successful import returns to the drawing screen. Each successful import adds another numbered “Photo study”; there is no stencil removal control.
- “Camera and photos” offers “OK” for these messages:
  - “A camera is unavailable on this device. Choose a picture from your photo library.” Use “Photo library”.
  - “Camera access is turned off. You can still choose a picture from your photo library.” When access was denied, the alert also offers “Open Settings”.
  - “This photo could not be opened. Try another image.” Choose another image.
  - “The photo could not be saved. Please try again.” Retry the capture or use “Photo library”.
- “Export artwork” uses “OK” to dismiss “Couldn’t create the PNG.”, “Couldn’t save the PNG.”, “Couldn’t save your artwork to Photos.”, “Your artwork was saved to Photos.”, or “Allow access in Settings or choose Save PNG to Files.” If Photos access is unavailable, use “Save PNG to Files” or enable access in Settings. Canceling the Files dialog returns without a failure alert.
- If an edit cannot be saved, “Sketchbook” displays “Your changes could not be saved. Check the available space on this device.” Tap “OK”, free up space, and retry the edit.

## Starter content and resume

The app starts with 100 uncolored stencils and no painted samples or imported photos. These are the visible card titles in collection order:

- “Tiger mask”, “Fox in the brush”, “Stained glass tiger”, “Spiral tiger”, “Poppy tiger”, “Sunrise crane”, “Paper boat tiger”, “Constellation tiger”, “Chameleon curl”, “Moon jelly”
- “Checkerboard tiger”, “Leaping tiger”, “Mountain ibex”, “Papercut tiger”, “Crescent tiger”, “Painted wings”, “Bamboo fan tiger”, “Lantern tiger”, “Bloom bear”, “Eclipse tiger”
- “Nautilus shell”, “Sea scroll”, “Lighthouse tiger”, “Coral cuttlefish”, “Roaring tiger”, “Quilt block tiger”, “Diamond tiger”, “Ginkgo tiger”, “Reclining tiger”, “Telescope tiger”
- “Comet tiger”, “Sunburst lion”, “Luna moth”, “Snow globe tiger”, “Striped zebra”, “Lemur ringtail”, “Ceramic tiger”, “Eucalyptus koala”, “Looping tiger”, “Vine swing tiger”
- “Book nook tiger”, “Running hare”, “Mountain badge tiger”, “Fennec fox”, “Moon tiger cub”, “Tiger bookends”, “Pine marten”, “Curled tiger”, “Mosaic tiger”, “Twin tiger circle”
- “Fan-tailed peacock”, “Maple tiger”, “Rain boot tiger”, “Wave crest tiger”, “Spiral octopus”, “Puffin on a cliff”, “Tiger in a locket”, “Hummingbird”, “Toucanet pair”, “Batik tiger”
- “Spiral-horned ram”, “Fan tiger”, “Thistle tiger”, “Window box tiger”, “Lily tiger”, “Thundercloud tiger”, “Koi circle”, “Tiger medallion”, “Tiger wind vane”, “Frilled dragon”
- “Manta ray”, “Woven tiger”, “Kite tiger”, “Leaping dolphin”, “Lotus crown tiger”, “Scarf tiger”, “Aurora tiger”, “Tree frog”, “Armadillo roll”, “Prism beetle”
- “Crested iguana”, “Origami tiger”, “Teacup tiger cub”, “Sun disk tiger”, “Cactus tiger”, “Kite-flying tiger”, “Reticulated giraffe”, “Sunflower tiger cub”, “Flamingo arch”, “Heron in reeds”
- “Wild boar”, “Embossed tiger”, “Totem tiger”, “Penguin and chick”, “Cherry bough tiger”, “Drumming tiger”, “Crocodile”, “Compass tiger”, “Sailfin lizard”, “Long-tailed macaw”

Unfinished work resumes automatically. The app remembers the last open stencil, completed strokes, edit history, imported stencils, ink color, brush size, and “Stay inside the lines” setting. “Brush” is selected again on a fresh launch.

## Permissions

- **Camera.** On first use of “Camera” in “Sketchbook”, when a camera is available, iOS can ask for access. The usage description is “Take a picture to turn it into a coloring stencil.”
- **Add to Photos.** On first use of “Save to Photos”, iOS can ask for permission to add artwork. The usage description is “Save a finished tiger print to your photo library.”
- “Photo library” uses the iOS image picker, which grants access to the image the user chooses without asking for broad photo library access.

## Absent

Login and accounts, in-app purchases, ads, analytics, an account deletion flow, and an App Tracking Transparency prompt are absent. User-generated content exists as private artwork and photo-derived stencils. There is no in-app publishing or community feed.

## Data and support

Artwork, imported stencils, and drawing preferences are kept on the device. The app has no sync service. “Save PNG to Files” and “Save to Photos” place a copy in the user’s chosen Files location or Photos library, where system sync settings may apply. There is no in-app settings screen or contact or support control. “Open Settings” in the camera alert opens the app’s iOS settings.

## Scanning and health

None. The camera takes still photos for coloring stencils. There is no barcode or QR scanning, health, medical, or product-health information, or related citations.

## Platform

Minimum iOS version is 17.0. iPhone supports portrait orientation. iPad supports portrait, upside-down portrait, and both landscape orientations. The app has no region-specific behavior. App-authored interface text is English, and iOS supplies localized text for its own dialogs and pickers.

## Category

Graphics & Design
