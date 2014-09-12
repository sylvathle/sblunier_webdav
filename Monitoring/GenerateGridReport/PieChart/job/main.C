#include <iostream>
#include <stdlib.h>
#include <dirent.h>
#include <fstream>
#ifndef WIN32
    #include <sys/types.h>
#endif

#include "TFile.h"
#include "TStyle.h"
#include "TH1.h"
#include "TH2.h"
#include "TMatrixD.h"
#include "TColor.h"
#include "TLegend.h"
#include "TPie.h"
#include "TImage.h"
#include "TPieSlice.h"
#include "TCanvas.h"


#include <string>
#include <vector>


using namespace std;

int main(int argc, char **argv )
{
	   
	Float_t vals[] = {atoi(argv[1]),atoi(argv[2]),atoi(argv[3])};
	Int_t colors[] = {3,2,0};
	Int_t nvals = sizeof(vals)/sizeof(vals[0]);

	TCanvas *cpie = new TCanvas("cpie","TPie test",700,300);

	TPie *pie3 = new TPie("pie1","jobs summary",nvals,vals,colors);

	//pie3->SetX(.32);
	pie3->SetCircle(.35,.5,.3);
	pie3->SetAngle3D(90.);
	pie3->SetEntryLabel(0,"Done");
	pie3->SetEntryLabel(1,"Failed");
	pie3->SetEntryLabel(2,"Not finished");
	pie3->SetLabelsOffset(-.1);
	pie3->SetLabelFormat("%perc");
	pie3->Draw("3d t nol");
	TLegend *pieleg = pie3->MakeLegend();
	pieleg->SetY1(.10); pieleg->SetY2(.90);
	pieleg->SetX1(.67); pieleg->SetX2(.96);
	//pieleg->SetY1NDC(.56); pieleg->SetY2NDC(.86);
	//pieleg->SetX1NDC(.56); pieleg->SetX2NDC(.86);

	cpie->Print(Form("canvas.eps"));
	return 0;
}
