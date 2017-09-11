/*
 * Inspecting synthetic samples in /Volumes/MacintoshHD3/dataTalita/users/dani/ringingArtifacts
 * Algorithm: Detect dense matter
 * INPUT: select stack
 * OUTPUT: create new stack with only fiber content

Symbols:
 ui_ = user interface
----------------
 Modified: Jul 11 2016
 Dani Ushizima - derived from mechTurk code
----------------
TODO:
1.
*/	
	inputdir = "/Volumes/MacintoshHD3/dataTalita/users/dani/ringingArtifacts/"; //getDirectory("home")
	outputdir = inputdir+"run1/";
	curr=getTitle;
	run("8-bit");
	run("Bilateral Filter", "spatial=3 range=50");
	run("Statistical Region Merging", "q=8 showaverages 3d");
	rename("SRM1");
	//selectImage(curr); close();
	run("8-bit");
	setAutoThreshold("Otsu dark");
	setOption("BlackBackground", true);
	run("Convert to Mask", "method=Otsu background=Dark calculate black");
	run("Remove Outliers...", "radius=3 threshold=50 which=Bright stack");
	saveAs("Tiff", outputdir+curr);
	run("Close All");