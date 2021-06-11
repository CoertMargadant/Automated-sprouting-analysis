//// Angiogenesis macro 
//// Angiogenesis macro 


run("Close All");	setBatchMode(false);  saveSettings();
OpenTiffs = 0;			// Dialog.create(" "); Dialog.addCheckbox("open tiffs ", 0); Dialog.show(); OpenTiffs = Dialog.getCheckbox();

if(OpenTiffs==0){
	run("Bio-Formats Macro Extensions");
	print("");  waitForUser("Macro to reiterate Sprouting Analysis    \n \n Choose file    \n \n                                    (first opening : any position, this is just for the macro to retrieve file path"); print(""); 
	open();

		dir = File.directory();  	name = File.name();		SaveSourceFile = name; 		SaveSourceDirectory = dir;
			Ext.setId(dir + name);																																													 
			Ext.isGroupFiles(group);																																												 
			Ext.getSeriesCount(nSeries);																																											
	
	getDimensions(width, height, channels, slices, frames);						
	if(nImages==1){Split=0; nChannels = channels;}else{Split=1; nChannels = nImages;}																																 
	// if the stack is XYZT , recognize!
	XYZT_stack=0;		getDimensions (dummy,dummy,dummy,slices,frames); 	if(slices>1 && frames>1){XYZT_stack=1;}																								 
																																																					 
}else{XYZT_stack=1; nSeries=1;}

	//////////////
	FileSeparator = File.separator; 	if(FileSeparator=="/"){Dialog.create(" "); Dialog.addCheckbox("Running on a Mac ?", 1); Dialog.show(); Var[0] = Dialog.getCheckbox();}else{print("this is a PC");}
	FileSeparator = FileSeparator + FileSeparator;	
		ImageJDirectory	= getDirectory("imagej");				 
		if(File.exists(ImageJDirectory+"Disk.txt")){Disk = File.openAsRawString(ImageJDirectory + "Disk.txt");}						 	 											 
		else{Dialog.create(" "); Dialog.addString("Disk for output storage :", "D"); Dialog.show(); Disk = Dialog.getString();	 File.saveString(Disk , ImageJDirectory + "Disk.txt");}
		Disk=Disk+":";				 
	ResultFolder 	= Disk+FileSeparator+"Results Sprouting Analysis"+FileSeparator;



		// crucial ; otherwise impossible to do proper readout from metadata from chosen file later
		run("Set Scale...", "distance=0 known=0 unit=pixel");	 																																			 
		run("Close All");


		ALL="";
		ColorArray1 = newArray("Cyan","Green","Yellow","Red", "Magenta");
		ColorArray2 = newArray("cyan","green","yellow","red", "magenta");
		ThresholdMethodArray= newArray("Percentile","Triangle","Li","Minimum");
		ChannelArray = newArray("Channel 1","Channel 2" );
		ImageForParametersAndSettings = "Stored_Parameters_Sprout_Macro";
		
		ScaleToMinMax	= 1;
		SaturatedNuclei	= 0.00;
		SaturatedActin 	= 0.00;
		Offset			= 0;

Continue=1;ToPresets=0;
while(Continue){
Continue=0;

if(File.exists(ImageJDirectory+ImageForParametersAndSettings+".tif")  &&  !ToPresets){						 	 											 
	open(ImageJDirectory+ImageForParametersAndSettings+".tif"); 	TempName = getTitle();	info = getMetadata("info");	List.setList(info);  	List.getList;

	ExperimentID			=  List.get("ExperimentID");
  	Ch_Nuclei 				=  List.get("Ch_Nuclei");		
  	Ch_Actin 				=  List.get("Ch_Actin");
  	ColourNuclei 			=  List.get("ColourNuclei");
  	ColourActin 			=  List.get("ColourActin");
  	CropAroundMedusa 		=  List.get("CropAroundMedusa");
  	Margin 					=  List.get("Margin");
  	Bin 					=  List.get("Bin");
  	DoBin 					=  List.get("DoBin");
  	ChBeads 				=  List.get("ChBeads");
  	ChSprouts 				=  List.get("ChSprouts");
  	ChNuclei 				=  List.get("ChNuclei");
  	ThrMethodBeads 			=  List.get("ThrMethodBeads");
  	ThrMethodSprouts 		=  List.get("ThrMethodSprouts");
  	ThrMethodNuclei 		=  List.get("ThrMethodNuclei");
  	BlurRadiusNuclei 		=  List.get("BlurRadiusNuclei");
 	Tolerance 				=  List.get("Tolerance");
 	MinNucleusArea 			=  List.get("MinNucleusArea");
 	MBR1					= List.get("MBR1") ;
 	MBR2					= List.get("MBR2") ;
 	MBR3					= List.get("MBR3") ;
 	MBR4					= List.get("MBR4") ;
 	MBR5					= List.get("MBR5") ;
 	Do1						= List.get("Do1") ;
 	Do2						= List.get("Do2") ;
 	Do3						= List.get("Do3") ;
 	Do4						= List.get("Do4") ;
 	Do5						= List.get("Do5") ;
 	SproutColour 			= List.get("SproutColour") ;																																											 	
	BeadBorderColour 		= List.get("BeadBorderColour") ;																																												 			
	SaveCombined			= List.get("SaveCombined") ;
	BinOutput				= List.get("BinOutput") ;		
	
	close(TempName);  

}else{
	ExperimentID 	= "Exp_1";											 
	Ch_Nuclei		= 1;
	Ch_Actin		= 2;
	ColourNuclei	= ColorArray1[0];
	ColourActin		= ColorArray1[4];
	CropAroundMedusa = 0 ;
	Margin			= 10;
	Bin				= 2;
	DoBin			= 0;
	ChBeads			= ChannelArray[1];
	ChSprouts		= ChannelArray[0];
	ChNuclei		= ChannelArray[1];

	ThrMethodBeads		= ThresholdMethodArray[0];
	ThrMethodSprouts 	= ThresholdMethodArray[1];
	ThrMethodNuclei 	= ThresholdMethodArray[2];

 	BlurRadiusNuclei 	=  2.54;
 	Tolerance 			=  4;
 	MinNucleusArea 		=  12;	

 	MBR1 = 60 ; 	MBR2 = 70 ;		MBR3 = 80 ; 	MBR4 = 90 ; 	MBR5 = 100 ;
 	Do1	= 1 ; 		Do2	= 1 ; 		Do3	= 1 ; 		Do4	= 0 ;		Do5	= 0 ;
	SproutColour 		= ColorArray2[1];																																												 	
	BeadBorderColour 	= ColorArray2[3];																																												 			
	SaveCombined		= 1 ;
	BinOutput			= 0 ;	
}    

																			if(ChBeads==ChSprouts){
																				ExperimentID 	= "Exp_1";											 
																				Ch_Nuclei		= 1;
																				Ch_Actin		= 2;
																				ColourNuclei	= ColorArray1[0];
																				ColourActin		= ColorArray1[4];
																				Margin			= 10;
																				Bin				= 2;
																				DoBin			= 0;
																				ChBeads			= ChannelArray[1];
																				ChSprouts		= ChannelArray[0];
																				ChNuclei		= ChannelArray[1];
																			
																				ThrMethodBeads		= ThresholdMethodArray[0];
																				ThrMethodSprouts 	= ThresholdMethodArray[1];
																				ThrMethodNuclei 	= ThresholdMethodArray[2];
																			
																			 	BlurRadiusNuclei 	=  2.54;
																			 	Tolerance 			=  4;
																			 	MinNucleusArea 		=  12;	
																			
																			 	MBR1 = 60 ; 	MBR2 = 70 ;		MBR3 = 80 ; 	MBR4 = 90 ; 	MBR5 = 100 ;
																			 	Do1	= 1 ; 		Do2	= 1 ; 		Do3	= 1 ; 		Do4	= 0 ;		Do5	= 0 ;
																				SproutColour 		= ColorArray2[1];																																												 	
																				BeadBorderColour 	= ColorArray2[3];																																												 			
																				SaveCombined		= 1 ;
																				BinOutput			= 0 ;	
																			}


		Dialog.create(" "); 
		if(OpenTiffs){Dialog.addMessage("open Coert's tifs !!!!!!!!!!!!!!");}
		Dialog.addString("OPENING  *************************   Experiment ID :", ExperimentID, 20);
		Dialog.addNumber("First and last position", 1); 
		Dialog.setInsets( -30,90,0); Dialog.addNumber(" ", nSeries); 
		Dialog.addString("Series name must contain ... ", ""); 
		Dialog.addNumber("PROCESSING  ***************     Nuclei are in channel ", Ch_Nuclei); 
		Dialog.addChoice("Nuclei colour ", ColorArray1, ColourNuclei);	 
		Dialog.addNumber("Actin is in channel ", Ch_Actin); 
		Dialog.addChoice("Actin colour" , ColorArray1, ColourActin);	

		Dialog.setInsets(  3,120,0);	Dialog.addCheckbox("CROP around Sprout Outline",CropAroundMedusa);
		Dialog.setInsets( -24,0,0);		Dialog.addNumber("", Margin,0,5, "Margin (%) "); 
		Dialog.setInsets( 0,0,0); 		Dialog.addNumber("Bin upon import", Bin); 	Dialog.setInsets(-23,365,0);	Dialog.addCheckbox(" ",DoBin);		
		Dialog.setInsets(10,0,0);
		Dialog.addChoice("ANALYSIS  ********************************           Beads" , ChannelArray, ChBeads);	
	 	Dialog.addChoice("Sprouts" , 	ChannelArray, ChSprouts);	
	 	Dialog.addChoice("Nuclei" , 	ChannelArray, ChNuclei);	
		//	
		Dialog.addChoice("Threshold Method Bead" , 		ThresholdMethodArray, ThrMethodBeads);	
		Dialog.addChoice("Threshold Method Sprouts" , 	ThresholdMethodArray, ThrMethodSprouts);	
		Dialog.addChoice("Threshold Method Nuclei" , 	ThresholdMethodArray, ThrMethodNuclei);	
		//
		Dialog.addNumber("Blur radius for nuclear segmentation", 	BlurRadiusNuclei);
		Dialog.addNumber("Tolerance for nuclei separation", 		Tolerance );
		Dialog.addNumber("Minimal nucleus area",			 		MinNucleusArea);
	/*
		Dialog.setInsets( 0,0,0); Dialog.addNumber("Variable Minimal Bead Radius    :  MBR value #1", MBR1); 	Dialog.setInsets(-23,365,0);	Dialog.addCheckbox(" ",Do1);		
		Dialog.setInsets( 0,0,0); Dialog.addNumber("MBR value #2", MBR2); 										Dialog.setInsets(-23,365,0);	Dialog.addCheckbox(" ",Do2);		
		Dialog.setInsets( 0,0,0); Dialog.addNumber("MBR value #3", MBR3); 										Dialog.setInsets(-23,365,0);	Dialog.addCheckbox(" ",Do3);		
		Dialog.setInsets( 0,0,0); Dialog.addNumber("MBR value #4", MBR4); 										Dialog.setInsets(-23,365,0);	Dialog.addCheckbox(" ",Do4);		
		Dialog.setInsets( 0,0,0); Dialog.addNumber("MBR value #5", MBR5); 										Dialog.setInsets(-23,365,0);	Dialog.addCheckbox(" ",Do5);		
	*/
		Dialog.setInsets( -4,150,0); Dialog.addMessage("Variable Minimal Bead Radius values");
		Offset=315;		Jump=50;
		Dialog.setInsets(-2,  Offset,0);			Dialog.addCheckbox(" ",Do1);
		Dialog.setInsets(-23,Offset+1*Jump,0);		Dialog.addCheckbox(" ",Do2);
		Dialog.setInsets(-23,Offset+2*Jump,0);		Dialog.addCheckbox(" ",Do3);
		Dialog.setInsets(-23,Offset+3*Jump,0);		Dialog.addCheckbox(" ",Do4);
		Dialog.setInsets(-23,Offset+4*Jump,0);		Dialog.addCheckbox(" ",Do5);
		
		Offset2=0;		Width=3.5;
		Dialog.setInsets( 0,Offset2+0,0); 			Dialog.addNumber("", MBR1, 0, Width,""); 			
		Dialog.setInsets( -23,Offset2+1*Jump,0); 	Dialog.addNumber("", MBR2, 0, Width,"");  														
		Dialog.setInsets( -23,Offset2+2*Jump,0); 	Dialog.addNumber("", MBR3, 0, Width,"");  														
		Dialog.setInsets( -23,Offset2+3*Jump,0); 	Dialog.addNumber("", MBR4, 0, Width,"");  														
		Dialog.setInsets( -23,Offset2+4*Jump,0); 	Dialog.addNumber("", MBR5, 0, Width,""); 														
	 	Dialog.setInsets(5,0,0);
		Dialog.addChoice("OUTPUT  *****************************     Draw Sprout in" , 		ColorArray2, SproutColour);	
		Dialog.addChoice("Draw Bead Border in" , 	ColorArray2, BeadBorderColour);	
		Dialog.setInsets(0,180,0);	Dialog.addCheckbox("Save Combined Output ",SaveCombined);
		Dialog.setInsets(-26,335,0);	Dialog.addCheckbox(" ... and bin it", BinOutput);
		if(!ToPresets){	 Dialog.setInsets(-2,30,0);	Dialog.addCheckbox("Back To Presets ",0);}

			Dialog.show(); 
		
		ExperimentID 		= Dialog.getString(); 		
		FirstPos 			= Dialog.getNumber();
		LastPos		 		= Dialog.getNumber();
		StringRequired 		= Dialog.getString();																															 			
		
		Ch_Nuclei 			= Dialog.getNumber();
		ColourNuclei 		= Dialog.getChoice();																														 			
		Ch_Actin 			= Dialog.getNumber();
		ColourActin 		= Dialog.getChoice();																														 			
		CropAroundMedusa	= Dialog.getCheckbox();
		Margin				= Dialog.getNumber();
		Bin 				= Dialog.getNumber();		if(round(Bin)!=Bin){print("_");  waitForUser("only integers allowed ; please go again"); FinalJoke(); exit("bye bye");}
		DoBin 				= Dialog.getCheckbox();		if(DoBin==0){Bin=1;}
		HideWindows=0;
		ChBeads		 		= Dialog.getChoice();																																											 
		ChSprouts	 		= Dialog.getChoice();																																											 
		ChNuclei	 		= Dialog.getChoice();																																											 
		ThrMethodBeads 		= Dialog.getChoice();																																											 
		ThrMethodSprouts 	= Dialog.getChoice();																																											 
		ThrMethodNuclei 	= Dialog.getChoice();																																											 
		BlurRadiusNuclei 	= Dialog.getNumber();		 
		Tolerance 			= Dialog.getNumber();
		MinNucleusArea		= Dialog.getNumber();
		
		Do1 = Dialog.getCheckbox();
		Do2 = Dialog.getCheckbox();
		Do3 = Dialog.getCheckbox();
		Do4 = Dialog.getCheckbox();
		Do5 = Dialog.getCheckbox();
	
		MBR1				= Dialog.getNumber();					 
		MBR2				= Dialog.getNumber();	//	Do2 = Dialog.getCheckbox();			 
		MBR3				= Dialog.getNumber();	//	Do3 = Dialog.getCheckbox();			   
		MBR4				= Dialog.getNumber();	//	Do4 = Dialog.getCheckbox();			 
		MBR5				= Dialog.getNumber();	//	Do5 = Dialog.getCheckbox();	
		
		SproutColour 		= Dialog.getChoice();																																												 	
		BeadBorderColour 	= Dialog.getChoice();																																												 			
		SaveCombined		= Dialog.getCheckbox();						 
		BinOutput			= Dialog.getCheckbox();
   if(!ToPresets){ToPresets	= Dialog.getCheckbox();		if(ToPresets){Continue=1;}			}else{ToPresets=0;}

}   //  vd  while(Continue){

							// this about Minimal Bead Radius (MBR)
							DoArray=newArray(5);			
							 C=DoArray.length;
						 
							if(Do1){DoArray[0]=1;	 print("Do1 "+ Do1);}
							if(Do2){DoArray[1]=1;	 print("Do2 "+ Do2);}
							if(Do3){DoArray[2]=1;	 print("Do3 "+ Do3);}
							if(Do4){DoArray[3]=1;	 print("Do4 "+ Do4);}
							if(Do5){DoArray[4]=1;	 print("Do5 "+ Do5);}																																						 								 
																																										

							if(ExperimentID==""){print(""); waitForUser("please enter an Experiment ID !!!! \n \n important for saving output data"); FinalJoke(); exit("go again ;-)");}
							if(File.exists(ResultFolder + ExperimentID + FileSeparator)){	 Dialog.create(" THIS OUTPUT FOLDER ALREADY EXISTS "); Dialog.addMessage("THIS OUTPUT FOLDER ALREADY EXISTS ... " );Dialog.addString("adapt ... ", ExperimentID+"_", 100);  Dialog.show(); ExperimentID = Dialog.getString();}



	ResultFolder		= Disk+FileSeparator+"Results Sprouting Analysis"+FileSeparator;
	DateFolder 			= ExperimentID + FileSeparator;
	ImageJDirectory		= getDirectory("imagej");	

	WriteAwayParameters();
																						
																							//  if not, create them
																							if(File.exists(ResultFolder)){print("yep");}
																							else{	print("ResultFolder not found"); 	
																									// try to generate it (works if computer has D-drive)
																									File.makeDirectory(ResultFolder);
																							}			
																							if(File.exists(ResultFolder)){A=0; print("yep, just generated the folder ResultFolder");print("ResultFolder exists ("+ResultFolder+")");}else{A=1;}
																						
																								// try to generate it via the file in the imageJ-directory (hopefully helps if computer has no D-drive)
																								FileName = "For Angiogenesis macro, this file knows where 'Results Sprouting Analysis' is located on this computer.txt";
																								if(A  && File.exists(ImageJDirectory + FileName)){
																									ForResultFolder = File.openAsRawString(ImageJDirectory + FileName);		
																										ForResultFolder = DoubleSeparator(ForResultFolder);	
																										ResultFolder = ForResultFolder + "Results Sprouting Analysis"+FileSeparator;  
																									File.makeDirectory(ResultFolder);
																									if(File.exists(ResultFolder)){B=0;  print("yep, just generated the folder ResultFolder  (2e instantie)");print("ResultFolder exists ("+ResultFolder+")");}else{B=1;}
																								}else{B=1;}
																							// if this does not work ....
																							if(A && B){print(""); waitForUser("OK, first we need to create folders on your computer so we can store analysis output and settings \n" + " \n " + "WHERE ??");  print("ResultFolder not found, because D-drive is not there, hence macro could't generate it ..."); 
																								ForResultFolder = getDirectory("Where shall we create folders for analysis data ??");	print("ForResultFolder (initially) : "+ForResultFolder);		
																								File.saveString(ForResultFolder , ImageJDirectory + FileName);
																								ForResultFolder = DoubleSeparator(ForResultFolder);		
																								ResultFolder = ForResultFolder + "Results Sprouting Analysis"+FileSeparator;
																										File.makeDirectory(ResultFolder);																																				print("ResultFolder exists 111 ("+ResultFolder +")");			
																										File.makeDirectory(ResultFolder  + DateFolder);																																	print("DateFolder exists 111 ("+ResultFolder + DateFolder+")");
																							} // vd else
																						 	if(File.exists(ResultFolder + DateFolder)){	print("yep");}	else {print(" DateFolder not found");			File.makeDirectory(ResultFolder  +DateFolder);}									print("DateFolder exists 222 ("+ResultFolder  + DateFolder+")");



																																										
	WrongSeries	= 0;																																																	print("00");  selectWindow("Log"); setLocation(screenWidth , 0.9*screenHeight);
	run("Brightness/Contrast..."); 
	selectArray=newArray(nSeries);																																										 
	if(HideWindows){setBatchMode(true);}

		nPos =  LastPos-FirstPos+1;																																										 																																					 

		nBeads_1 = newArray(nPos);					nBeads_2 = newArray(nPos);					nBeads_3 = newArray(nPos);					nBeads_4 = newArray(nPos);					nBeads_5 = newArray(nPos);
		nSprouts_1 = newArray(nPos);				nSprouts_2 = newArray(nPos);				nSprouts_3 = newArray(nPos);				nSprouts_4 = newArray(nPos);				nSprouts_5 = newArray(nPos);
		nCells_1 = newArray(nPos);					nCells_2 = newArray(nPos);					nCells_3 = newArray(nPos);					nCells_4 = newArray(nPos);					nCells_5 = newArray(nPos);
		TotalNetworkLength_1 = newArray(nPos);		TotalNetworkLength_2 = newArray(nPos);		TotalNetworkLength_3 = newArray(nPos);		TotalNetworkLength_4 = newArray(nPos);		TotalNetworkLength_5 = newArray(nPos);
		AvgSproutLength_1 = newArray(nPos);			AvgSproutLength_2 = newArray(nPos);			AvgSproutLength_3 = newArray(nPos);			AvgSproutLength_4 = newArray(nPos);			AvgSproutLength_5 = newArray(nPos);
		AvgSproutWidth_1 = newArray(nPos);			AvgSproutWidth_2 = newArray(nPos);			AvgSproutWidth_3 = newArray(nPos);			AvgSproutWidth_4 = newArray(nPos);			AvgSproutWidth_5 = newArray(nPos);
		AvgJunctionsPerSprout_1 = newArray(nPos);	AvgJunctionsPerSprout_2 = newArray(nPos);	AvgJunctionsPerSprout_3 = newArray(nPos);	AvgJunctionsPerSprout_4 = newArray(nPos);	AvgJunctionsPerSprout_5 = newArray(nPos);
		CellDensity_1 = newArray(nPos);				CellDensity_2 = newArray(nPos);				CellDensity_3 = newArray(nPos);				CellDensity_4 = newArray(nPos);				CellDensity_5 = newArray(nPos);

		BeadRoundness_1 = newArray(nPos);			BeadRoundness_2 = newArray(nPos);			BeadRoundness_3 = newArray(nPos);			BeadRoundness_4 = newArray(nPos);			BeadRoundness_5 = newArray(nPos);
		BeadSurface_1 = newArray(nPos);				BeadSurface_2 = newArray(nPos);				BeadSurface_3 = newArray(nPos);				BeadSurface_4 = newArray(nPos);				BeadSurface_5 = newArray(nPos);

		nBeads = newArray(nPos);					 
		nSprouts = newArray(nPos);
		nCells = newArray(nPos);	
		TotalNetworkLength = newArray(nPos);
		AvgSproutLength = newArray(nPos);
		AvgSproutWidth = newArray(nPos);	
		AvgJunctionsPerSprout = newArray(nPos);
		CellDensity = newArray(nPos);

		BeadRoundness = newArray(nPos);		 
		BeadSurface = newArray(nPos);

		Column_1 = newArray(nPos);
		Column_2 = newArray(nPos);
		Column_3 = newArray(nPos);
		Column_4 = newArray(nPos);
		Column_5 = newArray(nPos);
		Column_6 = newArray(nPos);
		Column_7 = newArray(nPos);
		Column_8 = newArray(nPos);

		SeriesNames = newArray(nPos);


		// THE LOOP
		// THE LOOP
		for(i=0 ;i<nPos ;i++){
			FinalForXls="Failed...";
			if(HideWindows){setBatchMode(false);}
			if(isOpen("ROI Manager")){selectWindow("ROI Manager");	run("Close");} run("ROI Manager...");																													 
			if(isOpen("ALL")){selectWindow("ALL"); close("\\Others");}else{run("Close All");}
			
			while(isOpen("Exception")){selectWindow("Exception");run("Close");} 
			if(HideWindows){setBatchMode(true);}
			nr=FirstPos+i;							 
			if(OpenTiffs==0){																																																								 
				run("Bio-Formats Importer", "open=["+dir + name+"] color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT use_virtual_stack series_"+nr);		
				ThisSeries=getTitle;			print("_");  print("ThisSeries "+ThisSeries);
			}else{
				run("Image Sequence...");
				dir = File.directory();  	name = File.name();		SaveSourceFile = name; SaveSourceDirectory=dir;
				ThisSeries=getTitle;		VirtualWindow=ThisSeries; 	 
			}


			// find Resolution
		if(i==0){			
			TestRes=0;
		 	ImageInfoString = getImageInfo();
		 	ResIndex = indexOf(ImageInfoString, "Resolution: ");																													if(TestRes){print("ImageInfoString");	print(ImageInfoString);  waitForUser("kijk __ TheWordResolution         ResIndex : "+ResIndex);}
				if(ResIndex==-1){		ResolutionDetected=0; 																														print("");	waitForUser("oops...... ResolutionDetected : " +ResolutionDetected);			 }
				else{					ResolutionDetected=1;
					A = ResIndex + 13; 																																				if(TestRes){print("");	waitForUser("A : " +A);}
					RestOfImageInfo = substring(ImageInfoString, A);								
					B = indexOf(RestOfImageInfo, " "); 
					ResolutionString = substring(RestOfImageInfo, 0, B); 																											if(TestRes){print("");	waitForUser("ResolutionString : "+ResolutionString); print("");}
					Resolution = parseFloat(ResolutionString); 																														if(TestRes){print("");	waitForUser("Resolution * 1 : " +1*Resolution);print("");			waitForUser("Resolution * 2 : " +2*Resolution);}
					// test whether it is microns
					c = indexOf(RestOfImageInfo, "Voxel size");																														if(TestRes){print("");	waitForUser("c   (start Voxel size) : "+c); print("");}
					MicronString = substring(RestOfImageInfo, 0, c);										 																		if(TestRes){print("");	waitForUser("MicronString : "+MicronString); print("");}
					D = indexOf(RestOfImageInfo, "micron");																															if(TestRes){print("");	waitForUser("D   (woord micron gevonden?) : "+D); print("");}
					if(D!=-1){print("");	print("ok, it's microns"); print("");}else{print("");			print("mmm... is it microns ?????"); print("");}
				run("Set Scale...", "distance="+Resolution/Bin+" known=1 unit=micron global");				print("");	print("_resolution "+Resolution);print("");					if(TestRes){print("");	waitForUser("_resolutie "+Resolution);print("");} 
				
					if(TestRes){
						if(Resolution<1   || Resolution>2 ){print("");waitForUser("_resolutie not OK !!!!    nl "+Resolution);print("");} 
					}
				}
			}  //  vd  	if(i==0){

			
	

		if(indexOf(ThisSeries,StringRequired)==-1){WrongSeries=1; print("");waitForUser("this one is being closed");print(""); close(ThisSeries);}
		else{
		if(OpenTiffs==0){
			if(indexOf(ThisSeries,"Mark_and_Find")==-1){	 }else{ThisSeries = replace(ThisSeries, "Mark_and_Find" , " " );	 	 		 		}
			if(indexOf(ThisSeries,"\\")==-1){				 }else{ThisSeries = replace(ThisSeries, "\\" , "_" );				 	 		 		}
			if(indexOf(ThisSeries,"//")==-1){				 }else{ThisSeries = replace(ThisSeries, "//" , "_" );				 	 		 		}
			if(indexOf(ThisSeries,"/")==-1){				 }else{ThisSeries = replace(ThisSeries, "/" , "_" );				 	 		 		}
			if(indexOf(ThisSeries,"  ")==-1){				 }else{ThisSeries = replace(ThisSeries, "  " , " " );				 	 		 		}
			if(indexOf(ThisSeries,"  ")==-1){				 }else{ThisSeries = replace(ThisSeries, "  " , " " );				 	 				}
			if(indexOf(ThisSeries,"  ")==-1){				 }else{ThisSeries = replace(ThisSeries, "  " , " " );				 	  				}
			if(indexOf(ThisSeries,"- _")==-1){				 }else{ThisSeries = replace(ThisSeries, "- _" , " - " );				  				}
			VirtualWindow=ThisSeries;	rename(VirtualWindow);
		}
			selectWindow(VirtualWindow); 
			Sample=30;
			getDimensions(dummy, dummy, channels, slicesTemp, framesTemp); X=maxOf(slicesTemp,framesTemp);	 Step = floor(X/Sample); nSteps = floor(X/Step); 					 
				DimensionsOK=1;
				if(slicesTemp==1  &&  framesTemp==1){DimensionsOK=0;  }

			
			
			if(DimensionsOK){	
			if(OpenTiffs==0){
				
				nROIs  = roiManager("count");
				if(CropAroundMedusa){
				
					if(HideWindows){}else{setBatchMode(true);}																			 
					for(s=0;s<nSteps;s++){
						wait(50); selectWindow(VirtualWindow); Stack.setPosition(Ch_Actin,  1+s*Step ,1);			 																					 
						run("Duplicate...", "title=plane_"+s+1);		
					}
					wait(50); run("Images to Stack", "name=Stack title=plane_ use");wait(50);	rename("Temp"); wait(50);
					run("Z Project...", "projection=[Max Intensity]");	rename("Temp_Proj"); 	close("Temp");																																																	
					if(HideWindows){}else{setBatchMode("exit and display"); setBatchMode(false);}										 
					
					selectWindow("Temp_Proj"); 	run("Gaussian Blur...", "sigma=10"); 
					run("Threshold..."); selectWindow("Threshold"); setLocation(0.92*screenWidth, 0.4*screenHeight);
					resetThreshold();setAutoThreshold("Mean dark");																																		 
					run("Create Selection");run("To Bounding Box");getSelectionBounds(x, y, width, height); 
					X=maxOf(width, height); 
					NewWidth = ((1+(Margin/100))*    X);
					FinalX = x+0.5*width  - 0.5*NewWidth;
					FinalY = y+0.5*height - 0.5*NewWidth;
					selectWindow("Temp_Proj");  roiManager("Deselect");
					makeRectangle(FinalX , FinalY , NewWidth , NewWidth);	 
					roiManager("Add");																																								 
					close("Temp_Proj"); 																																								
				}
				if(CropAroundMedusa==0){
					selectWindow(VirtualWindow); roiManager("Deselect");
					wait(101); run("Select All");wait(101); run("Select All");	roiManager("Add");																																																																										
				}
				run("Brightness/Contrast...");	selectWindow("B&C"); setLocation(0.92*screenWidth, 0.7*screenHeight);
				selectWindow("ROI Manager"); setLocation(1,1);

																																																									 
				
				// ch1  // ch1  // ch1  // ch1  // ch1  // ch1  // ch1  // ch1  // ch1  // ch1  // ch1  // ch1  // ch1  // ch1  // ch1  
				selectWindow(VirtualWindow); 													
				setBatchMode("exit and display"); setBatchMode(false);																																			 
				selectWindow(VirtualWindow);run("Select None"); roiManager("Deselect");  roiManager("Select", nROIs);																							 
				if(DoBin){
					run("Bin...", "x="+Bin+" y="+Bin+" z=1 bin=Average");																																		 
					rename("Resized"); 	run("Split Channels");
					selectWindow("C"+Ch_Nuclei+"-Resized");		if(CropAroundMedusa){makeRectangle(floor(FinalX/Bin), floor(FinalY/Bin), floor(NewWidth/Bin)+1, floor(NewWidth/Bin)+1); run("Crop");}			 
					rename("Nuclei");
					selectWindow("C"+Ch_Actin+"-Resized");		if(CropAroundMedusa){makeRectangle(floor(FinalX/Bin), floor(FinalY/Bin), floor(NewWidth/Bin)+1, floor(NewWidth/Bin)+1); run("Crop"); } 		
					rename("Actin");																																											 	
				 																																																 
				}else{
					run("Duplicate...", "duplicate channels="+Ch_Nuclei);	rename("Nuclei");		
				}
				selectWindow("Nuclei"); run(ColourNuclei);	getDimensions(widthFinal, heightFinal, dummy, dummy, dummy); 										//  for later, for SaveCombined
				run("Z Project...", "projection=[Max Intensity]"); 	rename("Nuclei_Proj"); 	run("Despeckle");	 																							 	
								run("Set Measurements...", "area fit shape limit redirect=None decimal=3");
								run("Select All"); run("Measure"); 	AreaWindow	= getResult("Area", nResults-1); 																							 	
																																																			 	
				
				if(ScaleToMinMax){run("Enhance Contrast", "saturated="+SaturatedNuclei);}		getMinAndMax(MinNuc,MaxNuc);
				run("RGB Color");	selectWindow("Nuclei");			
				if(ScaleToMinMax){setMinAndMax(MinNuc,MaxNuc); 	}else{setMinAndMax(0,65535);}
				run(ColourNuclei); 
				selectWindow("Nuclei"); run("RGB Color"); 	run("RGB Stack");  			// important : after setting of B&C
										
										if(i==0){	
											selectWindow("Nuclei_Proj"); run("Duplicate...", " "); rename("Temp"); run("8-bit"); run("Smooth"); run("Gaussian Blur...", "sigma=8"); 
											run("Threshold..."); setAutoThreshold("Huang dark");
											nROIsBefore = roiManager("count"); run("Analyze Particles...", "include add"); nROIsAfter = roiManager("count"); 					nParticlesNuclei = nROIsAfter - nROIsBefore;				 
											DeleteArray=newArray(nParticlesNuclei); for(j=0;j<nParticlesNuclei;j++){DeleteArray[j]=nROIsBefore+j;}	roiManager("Select", DeleteArray);  roiManager("Delete"); 							 
											close("Temp");
										}				

				// ch2  // ch2  // ch2  // ch2  // ch2  // ch2  // ch2  // ch2  // ch2  // ch2  // ch2  // ch2  // ch2  // ch2  // ch2  
				// ch2  // ch2  // ch2  // ch2  // ch2  // ch2  // ch2  // ch2  // ch2  // ch2  // ch2  // ch2  // ch2  // ch2  // ch2  
				// ch2  // ch2  // ch2  // ch2  // ch2  // ch2  // ch2  // ch2  // ch2  // ch2  // ch2  // ch2  // ch2  // ch2  // ch2  
				if(DoBin){
							/*nothing "Actin" exists */ 
				}else{
					selectWindow(VirtualWindow);run("Select None"); roiManager("Deselect");  roiManager("Select", nROIs);
					run("Duplicate...", "duplicate channels="+Ch_Actin);	rename("Actin");		
				}
				selectWindow("Actin"); run(ColourActin);																			 
				run("Z Project...", "projection=[Max Intensity]"); 		rename("Actin_Proj"); 	run("Despeckle");	
				if(ScaleToMinMax){run("Enhance Contrast", "saturated="+SaturatedActin);} 		
				getMinAndMax(MinAct,MaxAct);
				if(Offset>0){MinAct=Offset;	}				
				run("RGB Color");	selectWindow("Actin");			
				if(ScaleToMinMax){setMinAndMax(MinAct,MaxAct);}else{setMinAndMax(0,65535);}											 
				run(ColourActin);  
				selectWindow("Actin"); run("RGB Color"); 	run("RGB Stack");  // important : after setting of B&C
										
										if(i==0){
											selectWindow("Actin_Proj"); run("Duplicate...", " "); rename("Temp"); run("8-bit"); run("Smooth"); run("Gaussian Blur...", "sigma=8"); 
											run("Threshold..."); setAutoThreshold("Huang dark");
											nROIsBefore = roiManager("count"); run("Analyze Particles...", "include add"); nROIsAfter = roiManager("count"); 					nParticlesActin = nROIsAfter - nROIsBefore;			 
											DeleteArray=newArray(nParticlesActin); for(j=0;j<nParticlesActin;j++){DeleteArray[j]=nROIsBefore+j;}	roiManager("Select", DeleteArray);  roiManager("Delete"); 					 
											close("Temp");
											// evaluate 
											if(nParticlesActin>nParticlesNuclei){print("");waitForUser("seems the channels are reversed \n \n start again");print("");}
										}
				imageCalculator("Average create 32-bit stack", "Nuclei","Actin");	run("RGB Color", "slices keep");	rename("Merged_Stack"); 				 	
				
				









				
				run("Z Project...", "projection=[Max Intensity]");	run("Despeckle");	run("Enhance Contrast", "saturated=0.3");	rename("Merged_Proj"); 
																						SaveMaxProj=0;	if(SaveMaxProj){Temp=getTitle(); saveAs("Tiff", dir + ExperimentID + "_Series "+ nr +"_Merged_Proj.tif"); wait(50); rename(Temp);}

				// depth
				if(!HideWindows){
					selectWindow("Merged_Stack"); 	run("Temporal-Color Code", "lut=Spectrum");	  run("Enhance Contrast", "saturated=0.35");	rename("Depth_Coded");
				}
				if(HideWindows){
					selectWindow("Merged_Stack"); 	setBatchMode("show"); 
					// Depth code
					selectWindow("Merged_Stack");	run("Temporal-Color Code", "lut=Spectrum");	  selectWindow("MAX_colored"); 	rename("Depth_Coded");	run("Enhance Contrast", "saturated=0.35");  

					selectWindow("Depth_Coded"); 	setLocation(screenWidth,1);
					selectWindow("Nuclei"); 		setLocation(screenWidth,1);
					selectWindow("Actin"); 			setLocation(screenWidth,1);
					selectWindow("Nuclei_Proj"); 	setLocation(screenWidth,1);
					selectWindow("Actin_Proj"); 	setLocation(screenWidth,1);
					selectWindow("Merged_Proj"); 	setLocation(screenWidth,1);
					selectWindow(VirtualWindow); 	setLocation(screenWidth,1);
					selectWindow("Merged_Stack"); 	setLocation(screenWidth,1);
					if(isOpen("Result of Nuclei")){	selectWindow("Result of Nuclei"); 	setLocation(screenWidth,1);	}
																																																					 
					setBatchMode(true);
				}
			}   //  vd   if(OpenTiffs==1){
			
			
			
			
			if(OpenTiffs==1){
				rename("Merged_Stack"); 
				if(DoBin){
					run("Bin...", "x="+Bin+" y="+Bin+" z=1 bin=Average");
				}
				//  
				run("Z Project...", "projection=[Max Intensity]"); rename("Merged_Proj");
				run("Despeckle");	 run("Enhance Contrast", "saturated=0.3"); 	 	getMinAndMax(Min,Max);
				//
				selectWindow("Merged_Stack"); 																									 
				setMinAndMax(Min,Max);			 																								 
				run("Temporal-Color Code", "lut=Spectrum");	  run("Enhance Contrast", "saturated=0.35");	rename("Depth_Coded");
				 																																 
			}
																																											
				// Conversion to RGB-stack is cruciaal for Sprout Morphology Tool
				selectWindow("Merged_Proj"); run("Duplicate...", "duplicate"); run("RGB Stack"); rename("Merged_Proj_RGB_stack"); 
				
				BeenHere=0;
				for(M=0;M<C;M++){				
					run("Collect Garbage");
					wait(1010);
					if(M==0){MBR=MBR1;	Go=0; if(DoArray[0]){Go=1; 	 }}
					if(M==1){MBR=MBR2;	Go=0; if(DoArray[1]){Go=1;	 }}
					if(M==2){MBR=MBR3;	Go=0; if(DoArray[2]){Go=1;	 }}																			
					if(M==3){MBR=MBR4;	Go=0; if(DoArray[3]){Go=1;	 }}
					if(M==4){MBR=MBR5;	Go=0; if(DoArray[4]){Go=1;	 }}																					
																																																				 
					if(Go){
							Final="";
							Before=nImages;
							selectWindow("Merged_Proj_RGB_stack");																																					 
							run("Sprout Morphology", "number_of_beads average_sprout_length number_of_sprouts average_sprout_width number_of_cells cell_density total_network_length branching_level beads=["+ChBeads+"] sprouts=["+ChSprouts+"] nuclei=["+ChNuclei+"] endothelial_cell_marker=[Channel 3] pericytes=[Channel 1] bead_threshold="+ThrMethodBeads+" blur_radius_for_bead=1 minimum_bead_radius="+MBR+" dilate_beads=1 sprout_threshold="+ThrMethodSprouts+" blur_radius_for_sprout=5 minimal_plexus_area=5000 minimal_sprout_area=100 cluster_size=20000 nucleus_threshold="+ThrMethodNuclei+" blur_radius_for_nucleus="+d2s(BlurRadiusNuclei,2)+" tolerance="+d2s(Tolerance,2)+" minimal_nucleus_area="+d2s(MinNucleusArea,2));
							After=nImages;
							wait(101);
							Failed=0; 
							if(After==Before){
								Failed=1;	Result=""; 																																									 
								while(isOpen("Exception")){	selectWindow("Exception");	run("Close");}
								if(isOpen("Results")){		selectWindow("Results"); 	run("Close");} 	 
								run("Collect Garbage");
							}

							
							if(Failed && BeenHere==0){SeriesNames[i] = ThisSeries;}
							
							if(!Failed){
								BeenHere=1;
								Result=getTitle(); 		 																																									 
								roiManager("Show None");
								

								// Draw in the sprouts
								selectWindow(Result);																																							 
								Stack.setPosition(1, 4 , 1); // sprouts
								run("Threshold..."); resetThreshold(); setAutoThreshold("Default dark");				 
								run("Create Selection"); run("Enlarge...", "enlarge=2"); 
								nROIs  = roiManager("count"); roiManager("Add");
								run("Select None");	resetThreshold();
								run("Colors...", "foreground="+SproutColour);
								selectWindow("Depth_Coded");	run("Duplicate...", " "); rename("With_sprout_morphology"); roiManager("Deselect");  roiManager("Select", nROIs); run("Fill", "slice");				 		
								
								// Draw in the bead Ridge
								run("Colors...", "foreground="+BeadBorderColour);
								selectWindow(Result); Stack.setPosition(1, 1 , 1); 																	 
								run("Threshold..."); resetThreshold(); setAutoThreshold("Default dark");					 
								nROIs  = roiManager("count");			BeadROI = nROIs; // for later
								run("Create Selection");  				roiManager("Add");
								run("Enlarge...", "enlarge=-4");		roiManager("Add");													 
								roiManager("Select", newArray(nROIs,nROIs+1));
								roiManager("XOR"); roiManager("Add");   
								selectWindow(Result); run("Select None"); resetThreshold();
								run("RGB Color");
								selectWindow("With_sprout_morphology"); run("Select None");	roiManager("Deselect");  roiManager("Select", nROIs+2); 															 
								setForegroundColor(255, 0, 0);   
								if(BeadBorderColour=="red"){	setForegroundColor(255, 0, 0);}  	 
								if(BeadBorderColour=="green"){	setForegroundColor(0, 255, 0);}  	 
								if(BeadBorderColour=="yellow"){	setForegroundColor(255, 255, 0);}   
								if(BeadBorderColour=="cyan"){	setForegroundColor(0, 255, 255);}   
								if(BeadBorderColour=="Magenta"){setForegroundColor(255, 0, 255);}   
								fill(); 	 
								run("Select None");
																																																						 
								//  make all-results-series
								if(OpenTiffs==0){
									run("Concatenate...", "  title=All_Results keep open image1=Actin_Proj image2=Nuclei_Proj image3=Merged_Proj image4=Depth_Coded image5=With_sprout_morphology image6=["+Result+"] image7=[-- None --]");
								}else{																																														 
									run("Concatenate...", "  title=All_Results keep open image1=Merged_Proj image2=Depth_Coded image3=With_sprout_morphology image4=["+Result+"] image5=[-- None --]");
								}
								
								Final = getTitle;	
								Final = Final + "_" + ThisSeries ;   rename(Final + " (MBR_" +MBR+")"); 
								SeriesNames[i] = Final;
								if(FinalForXls=="Failed..."){FinalForXls=Final;} 
								 	
								roiManager("Show None"); run("Tile");																																
																																				 
								// save Avi
								selectWindow(Final + " (MBR_" +MBR+")"); 	

								run("AVI... ", "compression=JPEG frame=2 save=["+ResultFolder + DateFolder + ExperimentID + "_Pos_"+ FirstPos+i + "_" + Final+ " (MBR_"+MBR+").avi]"); 
								AviNow=getTitle();																																							 
							} 	//  vd if(!Failed){
																																																						 
					if(isOpen("Results")){
								nBeads[i] 				= getResult("n(beads)", nResults-1);								print("i = "+i+" nBeads " +nBeads[i]);	
								nSprouts[i] 			= getResult("n(sprouts)", nResults-1);								print("i = "+i+" nSprouts " +nSprouts[i]);
								nCells[i] 				= getResult("n(cells)", nResults-1);								print("i = "+i+" nCells " +nSprouts[i]);
								TotalNetworkLength[i] 	= getResult("Total network length (microns)", nResults-1);			print("i = "+i+" TotalNetworkLength " +TotalNetworkLength[i]);
								AvgSproutLength[i] 		= getResult("Average sprout length (microns)", nResults-1);			print("i = "+i+" AvgSproutLength " +AvgSproutLength[i]);
								AvgSproutWidth[i] 		= getResult("Average sprout width (microns)", nResults-1);			print("i = "+i+" AvgSproutWidth " +AvgSproutWidth[i]);
								AvgJunctionsPerSprout[i]= getResult("Average junctions per sprout", nResults-1);			print("i = "+i+" AvgJunctionsPerSprout " +AvgJunctionsPerSprout[i]);
								CellDensity[i] 			= getResult("Cell density (1/microns2)", nResults-1);				print("i = "+i+" CellDensity " +CellDensity[i]);							 
					}else{
								// Analysis failed ;; code as -101
								nBeads[i] 				= -101;			print("i = "+i+" nBeads " 				+nBeads[i]);	
								nSprouts[i] 			= -101;			print("i = "+i+" nSprouts " 			+nSprouts[i]);
								nCells[i] 				= -101;			print("i = "+i+" nCells " 				+nSprouts[i]);
								TotalNetworkLength[i] 	= -101;			print("i = "+i+" TotalNetworkLength " 	+TotalNetworkLength[i]);
								AvgSproutLength[i] 		= -101;			print("i = "+i+" AvgSproutLength " 		+AvgSproutLength[i]);
								AvgSproutWidth[i] 		= -101;			print("i = "+i+" AvgSproutWidth " 		+AvgSproutWidth[i]);
								AvgJunctionsPerSprout[i]= -101;			print("i = "+i+" AvgJunctionsPerSprout "+AvgJunctionsPerSprout[i]);
								CellDensity[i] 			= -101;			print("i = "+i+" CellDensity " 			+CellDensity[i]);

								BeadSurface[i] 			= -101;			print("i = "+i+" BeadSurface " 			+BeadSurface[i]);
								BeadRoundness[i] 		= -101;			print("i = "+i+" BeadRoundness " 		+BeadRoundness[i]);
					}
								if(!Failed){
									if(isOpen("Results")){selectWindow("Results"); run("Close");}
									run("Set Measurements...", "area fit shape limit redirect=None decimal=3");
									selectWindow(Result); roiManager("Deselect");  roiManager("Select", BeadROI);	run("Measure");  																					 																																
									BeadSurface[i] 		= getResult("Area", nResults-1);		
									BeadRoundness[i] 	= getResult("Circ.", nResults-1);				 																												 
									selectWindow("Results"); run("Close");
								}
								
								if(M==0){		// arrays_1 ... lowest  Mean Bead Radius
									nBeads_1[i] = 					nBeads[i];
									nSprouts_1[i] = 				nSprouts[i];
									nCells_1[i] = 					nCells[i];
									TotalNetworkLength_1[i] = 		TotalNetworkLength[i];
									AvgSproutLength_1[i] = 			AvgSproutLength[i];
									AvgSproutWidth_1[i] = 			AvgSproutWidth[i];
									AvgJunctionsPerSprout_1[i] = 	AvgJunctionsPerSprout[i];
									CellDensity_1[i] = 				CellDensity[i];

									BeadSurface_1[i] = 				BeadSurface[i];
									BeadRoundness_1[i] = 			BeadRoundness[i];
								}
								if(M==1){		// arrays_2 ... next  Mean Bead Radius
									nBeads_2[i] = 					nBeads[i];
									nSprouts_2[i] = 				nSprouts[i];
									nCells_2[i] = 					nCells[i];
									TotalNetworkLength_2[i] = 		TotalNetworkLength[i];
									AvgSproutLength_2[i] = 			AvgSproutLength[i];
									AvgSproutWidth_2[i] = 			AvgSproutWidth[i];
									AvgJunctionsPerSprout_2[i] = 	AvgJunctionsPerSprout[i];
									CellDensity_2[i] = 				CellDensity[i];

									BeadSurface_2[i] = 				BeadSurface[i];
									BeadRoundness_2[i] = 			BeadRoundness[i];
								}
								if(M==2){		// arrays_2 ... next  Mean Bead Radius
									nBeads_3[i] = 					nBeads[i];
									nSprouts_3[i] = 				nSprouts[i];
									nCells_3[i] = 					nCells[i];
									TotalNetworkLength_3[i] = 		TotalNetworkLength[i];
									AvgSproutLength_3[i] = 			AvgSproutLength[i];
									AvgSproutWidth_3[i] = 			AvgSproutWidth[i];
									AvgJunctionsPerSprout_3[i] = 	AvgJunctionsPerSprout[i];
									CellDensity_3[i] = 				CellDensity[i];

									BeadSurface_3[i] = 				BeadSurface[i];
									BeadRoundness_3[i] = 			BeadRoundness[i];
								}
								if(M==3){		// arrays_2 ... next  Mean Bead Radius
									nBeads_4[i] = 					nBeads[i];
									nSprouts_4[i] = 				nSprouts[i];
									nCells_4[i] = 					nCells[i];
									TotalNetworkLength_4[i] = 		TotalNetworkLength[i];
									AvgSproutLength_4[i] = 			AvgSproutLength[i];
									AvgSproutWidth_4[i] = 			AvgSproutWidth[i];
									AvgJunctionsPerSprout_4[i] = 	AvgJunctionsPerSprout[i];
									CellDensity_4[i] = 				CellDensity[i];

									BeadSurface_4[i] = 				BeadSurface[i];
									BeadRoundness_4[i] = 			BeadRoundness[i];
								}
								if(M==4){		// arrays_2 ... next  Mean Bead Radius
									nBeads_5[i] = 					nBeads[i];
									nSprouts_5[i] = 				nSprouts[i];
									nCells_5[i] = 					nCells[i];
									TotalNetworkLength_5[i] = 		TotalNetworkLength[i];
									AvgSproutLength_5[i] = 			AvgSproutLength[i];
									AvgSproutWidth_5[i] = 			AvgSproutWidth[i];
									AvgJunctionsPerSprout_5[i] = 	AvgJunctionsPerSprout[i];
									CellDensity_5[i] = 				CellDensity[i];

									BeadSurface_5[i] = 				BeadSurface[i];
									BeadRoundness_5[i] = 			BeadRoundness[i];
								}
				if(SaveCombined && !Failed){
					if(indexOf(AviNow, ".avi")!=-1){	ForFrontPage = substring(AviNow,0, lengthOf(AviNow)-4);	}
					else{								ForFrontPage = AviNow ;									}
					ForFrontPage=replace(ForFrontPage, "All_Results_", "Pos "+nr+"_");

					nDecimals=2;
					Font=25;	setFont("SansSerif", Font , " antialiased");																																	 
					while(getStringWidth(ForFrontPage)>(widthFinal-20)){Font--;	setFont("SansSerif", Font , " antialiased");	print("in de while en nu ... getStringWidth(ForFrontPage) = "+getStringWidth(ForFrontPage));}
					if(i==0){	FinalFont=Font;						}
					else{		if(Font>FinalFont){Font=FinalFont;}	}   
					
					setFont("SansSerif", Font , " antialiased"); 	run("Colors...", "foreground=white");
					
					nLines=20; 	Line=floor((0.95*heightFinal)/nLines+2);
					newImage("Front Page", "RGB black", widthFinal, heightFinal, 1);	
																																										 
					CC=0;
					CC++; 
					CC++;
					CC++; 			run("Label...", "format=Text x=10 y="+(1+CC)*Line+" font="+Font+" text=[Source File : "+SaveSourceFile+"]");
					CC++;
					CC++;  			run("Label...", "format=Text x=10 y="+(1+CC)*Line+" font="+Font+" text=[Pos "+nr+"]");
					CC++;
					CC++;  			run("Label...", "format=Text x=10 y="+(1+CC)*Line+" font="+Font+" text=[Binning : "+Bin+"]");
					CC++;  			run("Label...", "format=Text x=10 y="+(1+CC)*Line+" font="+Font+" text=[minimal bead radius : "+MBR+"]");
					CC++;  			run("Label...", "format=Text x=10 y="+(1+CC)*Line+" font="+Font+" text=[blur radius for nuclear segmentations : "+BlurRadiusNuclei+"]");
					CC++;  			run("Label...", "format=Text x=10 y="+(1+CC)*Line+" font="+Font+" text=[tolerance for nuclear segmentations : "+Tolerance+"]");
					CC++;  			run("Label...", "format=Text x=10 y="+(1+CC)*Line+" font="+Font+" text=[minimal nucleus area : "+MinNucleusArea+"]");
					CC++;
					CC++;  			run("Label...", "format=Text x=10 y="+(1+CC)*Line+" font="+Font+" text=[# of beads : "+nBeads[i]+"]");
					CC++;  			run("Label...", "format=Text x=10 y="+(1+CC)*Line+" font="+Font+" text=[# of sprouts : "+nSprouts[i]+"]");					
					CC++;  			run("Label...", "format=Text x=10 y="+(1+CC)*Line+" font="+Font+" text=[# of cells : "+nCells[i]+"]");
					CC++;  			run("Label...", "format=Text x=10 y="+(1+CC)*Line+" font="+Font+" text=[Total Network Length (um) : "+d2s(TotalNetworkLength[i], 	nDecimals)+"]");
					CC++;  			run("Label...", "format=Text x=10 y="+(1+CC)*Line+" font="+Font+" text=[Avg Sprout Length (um) : "+d2s(AvgSproutLength[i], 	nDecimals)+"]");
					CC++;  			run("Label...", "format=Text x=10 y="+(1+CC)*Line+" font="+Font+" text=[Avg # Junctions per sprout : "+AvgJunctionsPerSprout[i]+"]");				 
																																														 
					run("Concatenate...", "  title=TempTemp image1=[Front Page] image2=["+AviNow+"] image3=[-- None --]");		wait(101);									 
					CC++;  			run("Label...", "format=Text x=10 y="+Line+" font="+Font+" text=["+ForFrontPage+"]");

					if(BinOutput){run("Bin...", "x=2 y=2 z=1 bin=Average");}
					
					if(isOpen("ALL")){	
						run("Concatenate...", "  title=[ALL new] open image1=[ALL] image2=[TempTemp] image3=[-- None --]");			 								
					}else{rename("ALL");}																																			 
					saveAs("Tiff", ResultFolder + DateFolder + ExperimentID + "_ALL.tif");
					wait(50); rename("ALL"); 		 
																																													 
				}
					
					// close stuff
					if(isOpen(Result)){							close(Result);							} 																				 
					if(isOpen("With_sprout_morphology")){		close("With_sprout_morphology"); 		}
					if(isOpen(Final + " (MBR_" +MBR+")")){		close(Final + " (MBR_" +MBR+")");		}   																					 
				
				}   	//  vd if(Go){
				}		//  vd  for(M=0;M<C;M++){		
																																																 
	// save raw data			  			
	A=i+1;				 																																											 
	Separator	= ";";	
	SaveRawDataName 	= ExperimentID + "_Pos_"+FirstPos+i+"_"+FinalForXls ;																											 

	ArrayHeader1String 	= newArray(101); 	
	ArrayHeader2String 	= newArray(101); 	
	ArrayHeader3String 	= newArray(101); 	
	ArrayForPrintString = newArray(101);
	PrintStringArray 	= newArray(nPos + 16);					
	
	//  THE LOOP  
	for(r=0;r<A;r++){						 
				 							
		//   first 10 lines  (line 11 will be Header)
		PrintStringArray[0] = "Source File Directory : "	+ SaveSourceDirectory;
		PrintStringArray[1] = "Source File : "				+ SaveSourceFile;
		PrintStringArray[2] = SaveRawDataName;
		PrintStringArray[3] = "from position "+FirstPos+" to position "+LastPos 	;									 
		PrintStringArray[4] = "Channel Nuclei : "+Ch_Nuclei+"     &   Channel Actin : "+ Ch_Actin	;
																										Temp="Off"; Temp2=""; if(CropAroundMedusa){Temp="On"; Temp2=" (Margin : "+d2s(Margin,0)+"%)";}
		PrintStringArray[5] = "Crop Sprout Outline : "+Temp +Temp2 	;
																										Temp="Off"; Temp2=""; if(DoBin){Temp="On"; Temp2=" (bin factor "+d2s(Bin,0)+")";}
		PrintStringArray[6] = "Binning on loaded images : "+Temp +Temp2 	;
		PrintStringArray[7] = "Threshold Methods __ Beads : "+ThrMethodBeads +" , Sprouts : "+ThrMethodSprouts+" , Nuclei : "+ThrMethodNuclei ;
		PrintStringArray[8] = "nuclear segmentation __ Blur : "+BlurRadiusNuclei +" , Tolerance for separation : "+Tolerance+" , Minimal area : "+MinNucleusArea ;
																										if(Do1){Temp=" "+MBR1;}
																										if(Do2){Temp=Temp+"_"+MBR2;}
																										if(Do3){Temp=Temp+"_"+MBR3;}
																										if(Do4){Temp=Temp+"_"+MBR4;}
																										if(Do5){Temp=Temp+"_"+MBR5;}
		PrintStringArray[9]  = "Minimal Bead Radius : "+Temp  +" (um)";
		PrintStringArray[10] = "" ;
		PrintStringArray[11] = "" ;
		

		a = 0 ;
		nDecimals = 2;
		F = "Failed";

				a=0; 	if(r==0){ArrayHeader1String[a]="        ";			ArrayHeader2String[a]="";		   			ArrayHeader3String[a]="";}					ArrayForPrintString[a] = "";	
				a=a+1;	if(r==0){ArrayHeader1String[a]="Series";			ArrayHeader2String[a]="Name";				ArrayHeader3String[a]="";}					ArrayForPrintString[a] = SeriesNames[r];			

		for(MM=0;MM<C;MM++){
			Go=0;																																																	 
			if(MM==0){if(DoArray[0]){Go=1;	M=MBR1;	Column_1 = Array.copy(nBeads_1); 	Column_2 = Array.copy(nSprouts_1); 	Column_3 = Array.copy(nCells_1); 	Column_4 = Array.copy(TotalNetworkLength_1); 	Column_5 = Array.copy(AvgSproutLength_1); 	Column_6 = Array.copy(AvgSproutWidth_1); 	Column_7 = Array.copy(AvgJunctionsPerSprout_1); 	Column_8 = Array.copy(CellDensity_1); 	}}
			if(MM==1){if(DoArray[1]){Go=1;	M=MBR2;	Column_1 = Array.copy(nBeads_2); 	Column_2 = Array.copy(nSprouts_2); 	Column_3 = Array.copy(nCells_2); 	Column_4 = Array.copy(TotalNetworkLength_2); 	Column_5 = Array.copy(AvgSproutLength_2); 	Column_6 = Array.copy(AvgSproutWidth_2); 	Column_7 = Array.copy(AvgJunctionsPerSprout_2); 	Column_8 = Array.copy(CellDensity_2); 	}}
			if(MM==2){if(DoArray[2]){Go=1;	M=MBR3;	Column_1 = Array.copy(nBeads_3); 	Column_2 = Array.copy(nSprouts_3); 	Column_3 = Array.copy(nCells_3); 	Column_4 = Array.copy(TotalNetworkLength_3); 	Column_5 = Array.copy(AvgSproutLength_3); 	Column_6 = Array.copy(AvgSproutWidth_3); 	Column_7 = Array.copy(AvgJunctionsPerSprout_3); 	Column_8 = Array.copy(CellDensity_3); 	}}
			if(MM==3){if(DoArray[3]){Go=1;	M=MBR4;	Column_1 = Array.copy(nBeads_4); 	Column_2 = Array.copy(nSprouts_4); 	Column_3 = Array.copy(nCells_4); 	Column_4 = Array.copy(TotalNetworkLength_4); 	Column_5 = Array.copy(AvgSproutLength_4); 	Column_6 = Array.copy(AvgSproutWidth_4); 	Column_7 = Array.copy(AvgJunctionsPerSprout_4); 	Column_8 = Array.copy(CellDensity_4); 	}}
			if(MM==4){if(DoArray[4]){Go=1;	M=MBR5;	Column_1 = Array.copy(nBeads_5); 	Column_2 = Array.copy(nSprouts_5); 	Column_3 = Array.copy(nCells_5); 	Column_4 = Array.copy(TotalNetworkLength_5); 	Column_5 = Array.copy(AvgSproutLength_5);	Column_6 = Array.copy(AvgSproutWidth_5); 	Column_7 = Array.copy(AvgJunctionsPerSprout_5); 	Column_8 = Array.copy(CellDensity_5); 	}}

			if(Go){
				a=a+1;	if(r==0){ArrayHeader1String[a]="        ";			ArrayHeader2String[a]="";		   			ArrayHeader3String[a]="";}					ArrayForPrintString[a] = "";	
				a=a+1;	if(r==0){ArrayHeader1String[a]="MBR_"+M;			ArrayHeader2String[a]="n(beads)";			ArrayHeader3String[a]="";}					ArrayForPrintString[a] = d2s(Column_1[r],   nDecimals);			if(Column_1[r]==-101){ArrayForPrintString[a]=F;}
				a=a+1;	if(r==0){ArrayHeader1String[a]="MBR_"+M;			ArrayHeader2String[a]="n(sprouts)";			ArrayHeader3String[a]="";}					ArrayForPrintString[a] = d2s(Column_2[r],   nDecimals);			if(Column_2[r]==-101){ArrayForPrintString[a]=F;}																															Array.print(Column_2);    // print("");waitForUser("--3-- Column_2[r]  " +  d2s(Column_2[r],   nDecimals));print("");
				a=a+1;	if(r==0){ArrayHeader1String[a]="MBR_"+M;			ArrayHeader2String[a]="n(Cells)";			ArrayHeader3String[a]="";}					ArrayForPrintString[a] = d2s(Column_3[r],   nDecimals);			if(Column_3[r]==-101){ArrayForPrintString[a]=F;}	
				a=a+1;	if(r==0){ArrayHeader1String[a]="MBR_"+M;			ArrayHeader2String[a]= "Total Network";		ArrayHeader3String[a]="Length (microns)";}	ArrayForPrintString[a] = d2s(Column_4[r],   nDecimals);			if(Column_4[r]==-101){ArrayForPrintString[a]=F;}
				a=a+1;	if(r==0){ArrayHeader1String[a]="MBR_"+M;			ArrayHeader2String[a]= "Avg Sprout " ; 		ArrayHeader3String[a]="Length (microns)";}	ArrayForPrintString[a] = d2s(Column_5[r],   nDecimals);			if(Column_5[r]==-101){ArrayForPrintString[a]=F;} 
				a=a+1;	if(r==0){ArrayHeader1String[a]="MBR_"+M;			ArrayHeader2String[a]= "Avg Sprout " ; 		ArrayHeader3String[a]="Width (microns)";}	ArrayForPrintString[a] = d2s(Column_6[r],   nDecimals);			if(Column_6[r]==-101){ArrayForPrintString[a]=F;}		 
				a=a+1;	if(r==0){ArrayHeader1String[a]="MBR_"+M;			ArrayHeader2String[a]= "Avg Junctions " ; 	ArrayHeader3String[a]="per Sprout";}		ArrayForPrintString[a] = d2s(Column_7[r],   nDecimals);			if(Column_7[r]==-101){ArrayForPrintString[a]=F;}
		//		a=a+1;	if(r==0){ArrayHeader1String[a]="MBR_"+M;			ArrayHeader2String[a]= "Cell Density";		ArrayHeader3String[a]="";}					ArrayForPrintString[a] = d2s(Column_8[r],   nDecimals);			if(Column_8[r]==-101){ArrayForPrintString[a]=F;}
				a=a+1;	if(r==0){ArrayHeader1String[a]="        ";			ArrayHeader2String[a]="";					ArrayHeader3String[a]="";}					ArrayForPrintString[a] = "";	
			}
		}
				a=a+1;	if(r==0){ArrayHeader1String[a]="        ";			ArrayHeader2String[a]="";		   			ArrayHeader3String[a]="";}					ArrayForPrintString[a] = "";	
				a=a+1;	if(r==0){ArrayHeader1String[a]="        ";			ArrayHeader2String[a]="";		   			ArrayHeader3String[a]="";}					ArrayForPrintString[a] = "";	

		for(MM=0;MM<C;MM++){
				Go=0; 
				if(MM==0){if(DoArray[0]){Go=1;	M=MBR1;		Column_9 = Array.copy(BeadSurface_1);	  		}}
				if(MM==1){if(DoArray[1]){Go=1;	M=MBR2;		Column_9 = Array.copy(BeadSurface_2); 	 		}}
				if(MM==2){if(DoArray[2]){Go=1;	M=MBR3;		Column_9 = Array.copy(BeadSurface_3);	  	 	}}
				if(MM==3){if(DoArray[3]){Go=1;	M=MBR4;		Column_9 = Array.copy(BeadSurface_4);	  	 	}}
				if(MM==4){if(DoArray[4]){Go=1;	M=MBR5;		Column_9 = Array.copy(BeadSurface_5);	  		}}
				//
				if(Go){
				a=a+1;	if(r==0){ArrayHeader1String[a]="MBR_"+M;			ArrayHeader2String[a]="Bead";				ArrayHeader3String[a]="Surface";}			ArrayForPrintString[a] = d2s(Column_9[r],   nDecimals+1);				if(Column_9[r]==-101){ArrayForPrintString[a]=F;}		
				}
		}
				a=a+1;	if(r==0){ArrayHeader1String[a]="        ";			ArrayHeader2String[a]="";		   			ArrayHeader3String[a]="";}					ArrayForPrintString[a] = "";	
		
		for(MM=0;MM<C;MM++){
				Go=0;
				if(MM==0){if(DoArray[0]){Go=1;	M=MBR1;		Column_10 = Array.copy(BeadRoundness_1); 	}}
				if(MM==1){if(DoArray[1]){Go=1;	M=MBR2;		Column_10 = Array.copy(BeadRoundness_2); 	}}
				if(MM==2){if(DoArray[2]){Go=1;	M=MBR3;		Column_10 = Array.copy(BeadRoundness_3); 	}}
				if(MM==3){if(DoArray[3]){Go=1;	M=MBR4;		Column_10 = Array.copy(BeadRoundness_4); 	}}
				if(MM==4){if(DoArray[4]){Go=1;	M=MBR5;		Column_10 = Array.copy(BeadRoundness_5); 	}}
				//
				if(Go){
				a=a+1;	if(r==0){ArrayHeader1String[a]="MBR_"+M;			ArrayHeader2String[a]="Bead";				ArrayHeader3String[a]="Roundness";}			ArrayForPrintString[a] = d2s(Column_10[r],   nDecimals);				if(Column_10[r]==-101){ArrayForPrintString[a]=F;}	
				}
		}




		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		nColumns = a+1;		

		ArrayForPrintString = Array.trim(ArrayForPrintString, nColumns); 
		ArrayHeader1String 	= Array.trim(ArrayHeader1String,  nColumns);
		ArrayHeader2String 	= Array.trim(ArrayHeader2String,  nColumns); 
		ArrayHeader3String 	= Array.trim(ArrayHeader3String,  nColumns); 
	
			// build the HeaderStrings (HeaderString1 & HeaderString2) and put in the PrintStringArray
			if(r==0){	
					HeaderString1 = "";																						 
					for(j=1 ; j<nColumns ; j++){HeaderString1 = HeaderString1 + Separator + ArrayHeader1String[j];}		 
					PrintStringArray[12] = HeaderString1;
					
					HeaderString2 = "";
					for(j=1 ; j<nColumns ; j++){HeaderString2 = HeaderString2 + Separator + ArrayHeader2String[j];}
					PrintStringArray[13] = HeaderString2;
	
					HeaderString3 = "";
					for(j=1 ; j<nColumns ; j++){HeaderString3 = HeaderString3 + Separator + ArrayHeader3String[j];}
					PrintStringArray[14] = HeaderString3;
			}
			PrintStringArray[15] = "" ;
			// build the PrintString and put in the PrintStringArray
			  PrintString = "";																																									 
			for(j=1 ; j<nColumns ; j++){PrintString = PrintString + Separator + ArrayForPrintString[j];	}					 
			PrintStringArray[r+16] = PrintString;		
	} // vd  for(r=0;r<A;r++){
																																															 
	//  save
	Analysis_Output = PrintStringArray;
	Array.show(Analysis_Output); selectWindow("Analysis_Output"); //setLocation(1, 1);
	IJ.renameResults(SaveRawDataName);																																							 
		// problems with overwriting?
		Continue = 1;
		while(Continue){
			Continue = 0 ;
			AlreadySavedWithThisName 	= File.exists(ResultFolder + DateFolder + SaveRawDataName + ".xls");																	 
			if(AlreadySavedWithThisName){	SaveRawDataName = SaveRawDataName + "_";	Continue = 1 ;		}
		}
				saveAs("Results", ResultFolder + DateFolder + SaveRawDataName + ".xls"); run("Close");
		} 	// if(DimensionsOK)
		}   //  vd else
		}    //  vd  for(i=0 ;i<nPos ;i++){
	
	setBatchMode("exit and display"); setBatchMode(false);	
	run("Tile"); wait(3000); run("Close All");
	restoreSettings();
	FinalJoke();
	exit("ready");





function WriteAwayParameters(){
	
		if(isOpen(ImageForParametersAndSettings)  ||  isOpen(ImageForParametersAndSettings+".tif")  ||  isOpen(ImageForParametersAndSettings+".tiff")){
			if(isOpen(ImageForParametersAndSettings)){			selectWindow(ImageForParametersAndSettings);		}	
			if(isOpen(ImageForParametersAndSettings+".tif")){	selectWindow(ImageForParametersAndSettings+".tif");	}	
			if(isOpen(ImageForParametersAndSettings+".tiff")){	selectWindow(ImageForParametersAndSettings+".tiff");	}	
	}else{
		newImage(ImageForParametersAndSettings, "RGB black", 200, 100, 1); setLocation(0.5*screenWidth+101,101);		setFont("SansSerif", 30, " antialiased");	run("Colors...", "foreground=yellow");	drawString("sprout", 10, getHeight-15);
	}
	  
	  List.set("ExperimentID", ExperimentID);
	  List.set("Ch_Nuclei", Ch_Nuclei);
	  List.set("Ch_Actin", Ch_Actin);
	  List.set("ColourNuclei", ColourNuclei);
	  List.set("ColourActin", ColourActin);
	  List.set("CropAroundMedusa", CropAroundMedusa);
	  List.set("Margin", Margin);
	  List.set("Bin", Bin);
	  List.set("DoBin", DoBin);
	  List.set("ChBeads", ChBeads);
	  List.set("ChSprouts", ChSprouts);
	  List.set("ChNuclei", ChNuclei);
	  List.set("ThrMethodBeads", ThrMethodBeads);
	  List.set("ThrMethodSprouts", ThrMethodSprouts);
	  List.set("ThrMethodNuclei", ThrMethodNuclei);
	  List.set("BlurRadiusNuclei", BlurRadiusNuclei);
	  List.set("Tolerance", Tolerance);
	  List.set("MinNucleusArea", MinNucleusArea);
	  List.set("MBR1", MBR1);
	  List.set("MBR2", MBR2);
	  List.set("MBR3", MBR3);
	  List.set("MBR4", MBR4);
	  List.set("MBR5", MBR5);
	  List.set("Do1", Do1);
	  List.set("Do2", Do2);
	  List.set("Do3", Do3);
	  List.set("Do4", Do4);
	  List.set("Do5", Do5);
	  List.set("SproutColour", SproutColour);
	  List.set("BeadBorderColour", BeadBorderColour);
	  List.set("SaveCombined", SaveCombined);
	  List.set("BinOutput", BinOutput);
	
		list = List.getList();  	setMetadata("info", list);												 
		saveAs("Tiff", ImageJDirectory+ImageForParametersAndSettings+".tif");
		List.clear;
}





 
function DoubleSeparator(StringTemp){
	NewString=""; 																								 
	FileSeparator = File.separator; 																			 	
	for(i=0 ; i<lengthOf(StringTemp) ; i++){
		Character = substring(StringTemp, i, i+1);													print("Character = "+ Character);	
		if(Character!= FileSeparator){	NewString = NewString+Character;							print("NewString = "+ NewString);}
		else{							NewString = NewString+FileSeparator+FileSeparator;			print("NewString = "+ NewString);}
	}	
	return NewString;
}


function FinalJoke(){
	JokeInterval=11;
	nCircleIntervals=25; 		 
	UitwaaierSpeed = 200;		 
	ColorArray=newArray("Grays","Red","Green","Cyan","Blue","Yellow","Magenta");
	
	newImage("Joke", "8-bit white", 100, 100, 1); getDimensions(xJoke,yJoke,dummy,dummy,dummy);
	middleX=0.5*screenWidth; middleY=0.5*screenHeight;	setLocation(middleX - xJoke, middleY - yJoke);
	
	Continue=1;
	Count=0; ColorArrayNumber=0;
	while(Continue){
		Count=Count+1;
		
		Angle	= Count*(2*PI/nCircleIntervals);
		Radius 	= Count*(UitwaaierSpeed/nCircleIntervals);
		xLocation	= middleX + Radius*cos(Angle);
		yLocation	= middleY + Radius*sin(Angle);
		setLocation(xLocation - xJoke, yLocation - yJoke);
		
		Color = ColorArray[ColorArrayNumber]; 	ColorArrayNumber = ColorArrayNumber+1; if(ColorArrayNumber>ColorArray.length-1){ColorArrayNumber=0;} 	run(Color);
		
		if(xLocation > 1.1*screenWidth){Continue=0;}
		wait(JokeInterval);			
	}
		close("Joke");
}
