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
	   
	Float_t vals[] = {atoi(argv[1]),atoi(argv[2]),atoi(argv[3]),atoi(argv[4]),atoi(argv[5]),atoi(argv[6]),atoi(argv[7]),atoi(argv[8]),atoi(argv[9]),atoi(argv[10]),atoi(argv[11])};
	Int_t colors[] = {3,4,9,10,6,7,5,2,11,12,13};
	Int_t nvals = sizeof(vals)/sizeof(vals[0]);

	TCanvas *cpie = new TCanvas("cpie","TPie test",700,300);

	TPie *pie3 = new TPie("pie1","curl results",nvals,vals,colors);

	//pie3->SetX(.32);
	pie3->SetCircle(.35,.5,.3);
	pie3->SetAngle3D(90.);
	pie3->SetEntryLabel(0,"HTTP/1.1 200 OK");
	pie3->SetEntryLabel(1,"HTTP/1.1 403 Storage area");
	pie3->SetEntryLabel(2,"HTTP/1.1 403 Foribidden");
	pie3->SetEntryLabel(3,"HTTP/1.1 404 Not Found");
	pie3->SetEntryLabel(4,"HTTP/1.1 500 Internal Server Error");
	pie3->SetEntryLabel(5,"couldn't connect to host");
	pie3->SetEntryLabel(6,"SSL connect error");
	pie3->SetEntryLabel(7,"WebDAV not enabled");
	pie3->SetEntryLabel(8,"No file found");
	pie3->SetEntryLabel(9,"HTTP/1.1 400 Bad Request");
	pie3->SetEntryLabel(10,"Operation timed out");
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
