//File of compilation in ~/Code
{
	gROOT->Reset();	
	gSystem->CompileMacro("main.C");		
	mainAnalysis();
	//MchiDecaInPSS();
}
