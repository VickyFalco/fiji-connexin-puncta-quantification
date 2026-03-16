// ------------------------------------------------------------
// Connexin puncta quantification macro
// Fiji / ImageJ
//
// Author: Victoria Falco
// Description:
// Automated quantification of connexin puncta within
// reporter-positive cells in fluorescence microscopy images.
//
// Workflow:
// 1. Generate reporter mask
// 2. Create ROIs per slice
// 3. Restrict connexin signal to reporter-positive regions
// 4. Create substack with defined Z step
// 5. Detect puncta using Find Maxima
// 6. Export counts and ROI measurements
// ------------------------------------------------------------

// Open image

Imagen = File.openDialog("Select image file");
open(Imagen);

// Define variables

Carpeta = getDirectory("image");
Nombre = getInfo("image.filename");

// Channel selection

canal_reporter = getNumber("Enter reporter channel number (e.g. tdTomato/RFP)", 0);
canal_Cx = getNumber("Enter connexin channel number", 1);
canal_DAPI = getNumber("Enter DAPI channel number", 2);

// Connexin type

Cx = getNumber("Which connexin are you quantifying? (e.g. 43)", 43);

// Save image metadata

run("Show Info...");
saveAs("txt", Carpeta + Nombre + "_Info.txt");
close();

// ------------------------------------------------------------
// Generate reporter mask
// ------------------------------------------------------------

selectImage(Nombre + " - C=" + canal_reporter);

run("Gaussian Blur...", "sigma=2 stack");

setAutoThreshold("Otsu dark");

run("Convert to Mask", "method=Otsu background=Dark calculate");

run("Fill Holes", "stack");

rename("Reporter_mask");

// ------------------------------------------------------------
// Generate ROIs from reporter mask
// ------------------------------------------------------------

selectImage("Reporter_mask");

setOption("Stack position", true);

for (n = 1; n <= nSlices; n++) {

    setSlice(n);

    run("Create Selection");

    roiManager("add");

    selectImage("Reporter_mask");

}

// ------------------------------------------------------------
// Restrict connexin signal to reporter ROIs
// ------------------------------------------------------------

selectImage(Nombre + " - C=" + canal_Cx);

setOption("Stack position", true);

for (n = 1; n <= nSlices; n++) {

    setSlice(n);

    roiManager("Select", n - 1);

    run("Clear Outside", "Slice");

    selectImage(Nombre + " - C=" + canal_Cx);

}

rename("Connexin_signal");

// ------------------------------------------------------------
// Create substack
// ------------------------------------------------------------

selectImage("Connexin_signal");

z_step = getNumber("Number of slices to skip between planes:", 3);

run("Make Subset...", "slices=1-" + nSlices + "-" + z_step);

rename("Subset_Cx");

selectWindow("Subset_Cx");

run("8-bit");

// ------------------------------------------------------------
// Automatic connexin puncta detection
// ------------------------------------------------------------

noise = getNumber("Noise threshold for connexin detection", 10);

setOption("Stack position", true);

for (n = 1; n <= nSlices; n++) {

    setSlice(n);

    run("Duplicate...", "title=temp_slice");

    output = "Point Selection";

    run("Find Maxima...", "noise=" + noise + " dark output=" + output);

    run("Flatten");

    selectWindow("temp_slice");

    output = "List";

    run("Find Maxima...", "noise=" + noise + " dark output=" + output);

    selectWindow("Results");

    print(getInfo("window.contents"));

    close("temp_slice");

    selectWindow("Subset_Cx");

}

run("Images to Stack");

// ------------------------------------------------------------
// Save output files
// ------------------------------------------------------------

selectImage("Stack");

saveAs("tiff", Carpeta + Nombre + "_Cx" + Cx + "_in_reporter.tif");

selectWindow("Log");

saveAs("txt", Carpeta + Nombre + "_Cx" + Cx + "_counts.txt");

// ------------------------------------------------------------
// Measure reporter area
// ------------------------------------------------------------

selectImage("Reporter_mask");

for (n = 1; n <= nSlices; n++) {

    setSlice(n);

    roiManager("Select", n - 1);

    run("Clear Outside", "Slice");

    run("Measure");

}

selectWindow("Results");

saveAs("txt", Carpeta + Nombre + "_Reporter_area.txt");

// ------------------------------------------------------------
// Save ROIs
// ------------------------------------------------------------

roiManager("deselect");

roiManager("Save", Carpeta + Nombre + "_Reporter_RoiSet.zip");

roiManager("reset");

// ------------------------------------------------------------
// Close windows
// ------------------------------------------------------------

close("Results");

close("Log");

run("Close All");