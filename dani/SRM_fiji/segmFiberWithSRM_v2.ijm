/*
 * Inspecting CMC samples from Natalie Carlson
 * Algorithm: Detect fiber content
 * INPUT: select a folder containing only cross-sections of the same specime
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

//Customizable parameters
var subsetStack_cylinder = false;
var sep = File.separator; // it will run on Windows
var inputdir = "/Volumes/MacintoshHD3/dataTalita/users/dani/ringingArtifacts/"; //getDirectory("home")
var outputdir = inputdir+"run1"+sep;
var filename = "<filename prefix>";
var sigma_spatial = 10; // domain in euclidean space
var sigma_range = 60; // range or pixel depth
var imageSubset_first = 1;
var imageSubset_last = 756;
var gmin = -12;
var gmax = 12;
var path="";
var bCylinder = false;
var bFullResolution = false; //details are over 10 pixels
var borderThickness = 2; //frame of the canvas that must be erased or added
var bSaveRawANDfiberContent = false; //only if saving masked raw in addition to binary mask
var nFiles=0;
var nslab=10;
var scaleFactor = 0.2;//1/nslab; // notice that these 2 parameters are tied
var mask, new, original;
var fiberGrayEstimate = 0;


macro "visualizeRainbow_Grains" {

 run("Close All");
 //Setting quantization param defaults to ImageJ
 run("Options...", "iterations=1 black count=1"); //set black background
 run("Conversions...", "scale"); //scale when converting from 32bit to 8bit
 run("Colors...", "foreground=white background=black selection=yellow"); //set colors
 run("Display...", " "); //do not use Inverting LUT
 print("\\Clear"); // clean log
 start = getTime;
 print("-----------------------------------------");
 pathHome = getDirectory("home")
 parts=split(pathHome,"/")
 ui_initialization();
 fDriver();             //<<<<<< HERE
 print("Time of processing:"+d2s((getTime-start)/1000,2) + "sec.");
 print(">> End: fiber content identified <<");
 print("-----------------------------------------");
 selectWindow("Log");
 saveAs("Text", outputdir+"Log.txt");
}

/*******************************************
 * Main function
 *******************************************/

function fDriver(){
  nfilesByUser = imageSubset_last - imageSubset_first;
  npasses = round((nfilesByUser)/nslab);

  setBatchMode(true);
  //Detect dense matter
  run("Image Sequence...", "open=["+inputdir+"] number="+nFiles+" starting="+0+" increment=1 scale=50 file="+filename+" or=[] sort use");
  fDownsampling();
  fFindMass();

  print("Number of passes:"+npasses +"\nNumber of images:"+ (nFiles+1)+"\nSlab size:"+nslab);

  for(i=0;i<npasses;i++){
    print("Step: "+i);
    nimag = imageSubset_first+nslab*i-1; //index of the slab top
    if(nimag+nslab>nfilesByUser)
    	nslab = nfilesByUser - nimag+1;
    run("Image Sequence...", "open=["+inputdir+"] number="+nslab+" starting="+nimag+" increment=1 scale=100 file="+filename+" or=[] sort");
    wait(500);
    rename("Original");
    original = getImageID;
    run("Set Scale...", "distance=0 known=0 pixel=1 unit=pixel");
    if (subsetStack_cylinder)
        ui_getCylinderBounds(); //cylinder bounds

    // only if fullResolution raw out of reconstruction fPreprocessing();
    fFindFibers(i,nimag);
    //run("Image Sequence... ", "format=TIFF name="+filename+" start="+nimag+" digits=4 save="+outputdir); //writes
    //print("....>" + nimag);
  }
 setBatchMode(false);

  if (bCylinder)
    print('Subsetting with cylinder');
  if (bSaveRawANDfiberContent)
    print('Saving AND(raw,fiberContent) in addition to masks');
    close;
}

/*******************************************
 * Provide user interface to quickly set up experiment to run
 */

//Downsample for mask creating
function fDownsampling(){
	//orig = getTitle;
	//scaleFactor = 0.1;
	w =  round(getWidth*scaleFactor);
	h =  round(getHeight*scaleFactor);
	d =  round(nSlices*scaleFactor);
	run("Size...", "width="+w+" height="+h+" depth="+d+" constrain average interpolation=Bilinear");
}

//Filtering and other stuff
function fPreprocessing(){
  setMinAndMax(gmin,gmax); print("Setting min-max intensity using tested parameters: [-12,12]");
  run("8-bit");
  run("Stack Contrast Adjustment", "is");
  wait(100);
  //selectWindow("Original"); close;
  //print("Filtering stack with bilateral Filter with spatial="+sigma_spatial+" range="+sigma_range);
	//run("Bilateral Filter", "spatial="+sigma_spatial+" range="+sigma_range);
  run("Median 3D...", "x=2 y=2 z=2"); //in place computation

}

/*
 * Mask the full res sample based on pre-calculated mask
 */
function fMaskOriginal(nimag,w,h){
	selectImage(mask);
	//selectWindow("mask");
	setSlice(nimag+1); //relative correspondence between mask and current resolution data
	run("Duplicate...","title=new");
	new = getImageID;
	d =  nslab;
	run("Size...", "width="+w+" height="+h+" depth="+d+" constrain average interpolation=Bicubic");
	setThreshold(10,255); //just to eliminate approximations
	run("Convert to Mask", " black");
	imageCalculator("AND stack", "Original" , "new");
}

/*******************************************
 * Find the fiber content out of the microCT sample
 */
function fFindMass(){
  if(bCylinder){
    makeOval(20, 20, getWidth()-20, getHeight()-20); //TODO: put QuantCT user-interaction routine here
    run("Clear Outside","stack"); run("Select None");
  }

  /*for(i=0;i<nSlices;i++){
    setSlice(i+1);
    setForegroundColor(162, 162, 162);
    floodFill(2, 2);
  }
  */
  //filename = getTitle;
  //run("Median 3D...", "x=1 y=1 z=1"); //in place computation
  //run("Sobel Filter");
  run("Find Edges","stack");
  for(i=0;i<nSlices;i++){
        setSlice(i+1);
        run("Maximum...", "radius=1");
      }

  curr = getImageID;//getTitle();
  //run("Gray Morphology", "radius=1 type=circle operator=[fast dilate]");
  run("Statistical Region Merging", "q=8 showaverages 3d");
  rename("SRM1");
  selectImage(curr); close();
//selectWindow(curr); close();
  ////run("Maximum...", "radius=1");
  run("8-bit");
  grayEstimate = 0;
  for(i=0;i<(nSlices);i++){
  	getStatistics(area,mean,min,max,std);
    grayEstimate = grayEstimate + (mean-std);
  }
  grayEstimate = grayEstimate/nSlices;
  print("Estimated threshold for mask:"+grayEstimate);

  setThreshold(grayEstimate, 255);
  run("Convert to Mask", " black");
  rename("mask");
  mask = getImageID;
  //run("Fill Holes", "stack");

  run("Remove Outliers...", "radius=3 threshold=50 which=Bright stack");

  //Cleaning up debris from ceramic matrix
  if(bCylinder){
    makeOval(10, 10, getWidth()-10, getHeight()-10);
    run("Clear Outside","stack"); run("Select None");
  }
  denseMatter = round(0.5 * getWidth * getHeight); // dense matter is often more than 50% of the sample
  run("Analyze Particles...", "size="+denseMatter+"-Infinity pixels circularity=0.00-1.00 show=Masks in_situ stack");//100=40microns
  //Saving only the mask
  //run("Image Sequence... ", "format=TIFF name=mask"+filename+" start="+nimag+" digits=4 save="+outputdir);
  saveAs("Tiff", outputdir+filename+"_scale"+scaleFactor+"mask.tif");
  rename("mask"); //if you wanna reuse, must bring back the name
  //close();
}

/********************************************************
 * Find fibers - tested on Natalie's data
 ********************************************************/
function fFindFibers(i,nimag){
	fMaskOriginal(i,getWidth,getHeight);
	run("Statistical Region Merging","q=100 showaverages 3d");
	run("8-bit");
	if(bFullResolution)
		run("Median 3D...", "x=2 y=2 z=2");
	rename("SRM2");
	srm2 = getImageID;

	run("Remove Outliers...", "radius=2 threshold=50 which=Bright stack");
	fCalculateThreshold();
	//Save
	//selectWindow("SRM2");
	//print("-------->"+nSlices);
	selectImage(srm2);
	run("Image Sequence... ", "format=TIFF name=["+ filename +"] start="+nimag+" digits=4 save=["+outputdir+"]"); //writes notice the brackets to avoid problems with names with _

	wait(100);
	/*
	selectWindow("new"); close;
	selectWindow("Original");close;
	selectWindow("SRM2"); close;
	*/
	selectImage(new); close();
	selectImage(original); close();
	selectImage(srm2); close();

}

//todo: instead of using rectangle, use info inside mask
function fCalculateThreshold_old(){
	//fiberGrayEstimate =0;
	grayEstimate = 0;
	cx = round(getWidth/4);
	cy = round(getHeight/4);
	makeRectangle(cx,cy,2*cx,2*cy); //estimate the average value of the fiber content <<<problem when there is a giant crack!!!!
   	for(i=0;i<(nSlices);i++){
  		getStatistics(area,mean,min,max,std);
  		grayEstimate = grayEstimate + (mean);
    }

    if (fiberGrayEstimate>0)
    	fiberGrayEstimate =  0.7*fiberGrayEstimate + 0.3*(grayEstimate/nSlices) ;
    else
    	fiberGrayEstimate = grayEstimate/nSlices;
    //tmp=grayEstimate/nSlices;
    //print("Estimated threshold from this slab:"+tmp);
    print("Estimated threshold for slab:"+fiberGrayEstimate);

    setThreshold(fiberGrayEstimate+20, 255);
    run("Convert to Mask", " black");
 }

 function fCalculateThreshold(){
	 fiberGrayEstimate =0;
 	 grayEstimate = 0;
	 slabHist = newArray(256);
	 for (i=1;i<=nSlices;i++){
	   setSlice(i);
	   getHistogram(0,sliceHist,256);
	   for (j=10;j<250;j++)
		slabHist[j]+ = sliceHist[j];
	 }
	 		/*x = newArray(256);
	 		for (j=0;j<256;j++)
				x[j]+ = j;
			Plot.create("Hist","Length","Intensity",x,slabHist);
			setColor("black"); setFont("Arial",14);
			*/
		Array.getStatistics(slabHist, min, max, mean);
		ypeak1 = max;
		for (j=10;j<250;j++)
			if(slabHist[j] == ypeak1)
				xpeak1=j;
		init=0;
		if((xpeak1-20)>0)
			init=xpeak1-20;
	 	for (j=init;j<xpeak1+20;j++)
			slabHist[j]=0; //erase peak
	   	Array.getStatistics(slabHist, min, max, mean);
		ypeak2 = max;
		for (j=10;j<250;j++)
			if(slabHist[j] == ypeak2)
				xpeak2=j;
		tmp=xpeak1-xpeak2;print(tmp);
		if(xpeak1>xpeak2)
			grayEstimate = abs(xpeak1-xpeak2)/2 + xpeak2;//grayEstimate = mean;
	    else
	    	grayEstimate = abs(xpeak1-xpeak2)/2 + xpeak1;
	    //print(xpeak1+", "+ypeak1+" "+xpeak2+", "+ypeak2);

	    if (fiberGrayEstimate>0)
	    	fiberGrayEstimate =  0.7*fiberGrayEstimate + 0.3*grayEstimate ;
	    else
	    	fiberGrayEstimate = grayEstimate;
	    print("Estimated threshold for slab:"+grayEstimate);

	    setThreshold(fiberGrayEstimate+5, 255);
	    run("Convert to Mask", " black");
 }
/*******************************************
 * Provide user interface to quickly set up experiment to run
 */
function ui_initialization(){
 //Find out stack directory, radix, number of images
 Dialog.create("Welcome to Material Curation");
 Dialog.addMessage("Select any image from the target folder");
 Dialog.show();
 open();//open image win to get attributes of the experiment, including folder location
 inputdir = getInfo("image.directory");
 outputdir = inputdir+"output1"+sep;
 fname = getInfo("image.filename");
 parts=split(fname,".");
 n=lengthOf(parts[0]);
 go = true;
 close; //close image win
 while ((n>0)&&(go)){
 	str = substring(parts[0],n-1,n);
 	if ((str==0)||(str==1)||(str==2)||(str==3)||(str==4)||(str==5)||(str==6)||(str==7)||(str==8)||(str==9))
 		n=n-1;
 	else go=false;
 }
 filename = substring(parts[0],0,n); //radix
 nFiles = 0;
 FileList = getFileList(inputdir);
 for (j=0; j<FileList.length; j++) {
        if (endsWith(FileList[j], "tif") | endsWith(FileList[j], "TIF") | endsWith(FileList[j], "tiff") | endsWith(FileList[j], "TIFF") )
           nFiles++;
     }

 Dialog.create("Find Fiber Content"); //MicroCT Processing Parameters"
 Dialog.addMessage("Enter parameters to label microCT images:\n");
 Dialog.addString("Stack folder:",inputdir,90);
 Dialog.addString("Output folder:",outputdir,90);
 Dialog.addString("Filename radix:",filename,50);

 Dialog.addMessage("Images: parameters to subset stack with "+nFiles+" images\n");
 Dialog.addNumber("First slice at: ",imageSubset_first,0,4,"max="+nFiles);
 Dialog.addNumber("Last slice at: ",20,0,4,"max="+nFiles+" <= SUBSET SUGGESTED");

 Dialog.addCheckbox("Full Resolution? ", false);
 Dialog.addCheckbox("Subset stack with circle? *** Consider only portion inside the circle", false);
 Dialog.addCheckbox("Save AND(mask,raw) slices? ", false);

 Dialog.show();

 inputdir = Dialog.getString();
 outputdir = Dialog.getString();
 filename = Dialog.getString();

 imageSubset_first = Dialog.getNumber(); //NUMBER OF IMAGES TO BE SEGMENTED of images to be segmented
 imageSubset_last = Dialog.getNumber(); //number of images to be segmented
 bFullResolution=Dialog.getCheckbox();
 bCylinder = Dialog.getCheckbox();
 bSaveRawANDfiberContent = Dialog.getCheckbox();

 print("Source folder:\n" + inputdir + " \nOutput folder:\n" + outputdir);
 File.makeDirectory(outputdir);
}

/*******************************************
 * Clean up mask by using ANDing consecutive slices and inplace
 */
function fBooleanCleaning(){
  wactive = getTitle();
  for(i=0;i<(nSlices-1);i++){
    setSlice(i+2);
    run("Duplicate...","title=slice duplicate");
    setSlice(i+1);
    imageCalculator("AND", wactive,"slice");
    selectWindow("slice");
    close();
  }
  //just for last slice
  setSlice(nSlices-1);
  run("Duplicate...","title=slice duplicate");
  setSlice(nSlices);
  imageCalculator("AND", wactive,"slice");
  selectWindow("slice");
  close();
}

/*******************************************
*
*/
function fAddBorders(win){
	selectWindow(win);
	w=getWidth()+borderThickness;
	h=getHeight()+borderThickness;
	run("Canvas Size...", "width="+w+" height="+h+" position=Center zero");
}

/*******************************************
*
*/
function fSubtractBorders(win){
	selectWindow(win);
	w=getWidth()-borderThickness;
	h=getHeight()-borderThickness;
	run("Canvas Size...", "width="+w+" height="+h+" position=Center zero");
}


/*******************************************
 * User interface - get working directory and filename by letting user select one of the images from the experiment
 */

function ui_getWorkingDir()
{
	path="";
	Dialog.create("Create fiber-content mask");
	Dialog.addMessage("Select the multi-tif stack file: click OK!\n");
	Dialog.addCheckbox("Subset stack with cylinder?", false);
	Dialog.show();
	bCylinder =  Dialog.getCheckbox();
	open();
	path = getInfo("image.directory");
	path_file = path+getInfo("image.filename");
	print("Input data at "+path);
	outputdir = path +"test/";
	if (!File.exists(outputdir))
		File.makeDirectory(outputdir);
	return path_file;
}
