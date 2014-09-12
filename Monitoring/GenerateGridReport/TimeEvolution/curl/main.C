
#include <iostream>
#include <stdlib.h>
#include <dirent.h>
#include <fstream>
#ifndef WIN32
    #include <sys/types.h>
#endif

#include "TFile.h"
#include "TStyle.h"
#include "TGraph.h"
#include "TMatrixD.h"
#include "TColor.h"
#include "TImage.h"
#include "TCanvas.h"
#include "TDatime.h"
#include "TAxis.h"


#include <string>
#include <vector>


using namespace std;

int main()
{
   gStyle->SetTitleH(0.08);


	int datanumber=0;
	ifstream fichier("curlsuccess.txt", ios::in);  // on ouvre en lecture
	vector<string> x;
	vector<double> y;
	if(fichier)
	{
		while ( ! fichier.eof())
	        {
			datanumber++;
			string ligne;
			double value;
			fichier >> ligne >> value;
			x.push_back(ligne);
			y.push_back(value);
		}
	}
	
	x.pop_back();
	y.pop_back();

	double *dateNumber = new double[x.size()];
	double *curlvalue = new double[x.size()];

	int day = (int)x[0][0] - '0';
	day = day*10;
	day = day + (int)x[0][1] - '0'; 

	int month = (int)x[0][3] - '0';
	month = month*10;
	month = month + (int)x[0][4] - '0'; 

	int year = (int)x[0][6] - '0';
	year = year*10;
	year = year + (int)x[0][7] - '0'; 
	year = year + 2000;

	for (int i=0;i<x.size();i++)
	{
		int day_ = (int)x[i][0] - '0';
		day_ = day_*10;
		day_ = day_ + (int)x[i][1] - '0'; 

		int month_ = (int)x[i][3] - '0';
		month_ = month_*10;
		month_ = month_ + (int)x[i][4] - '0'; 

		int year_ = (int)x[i][6] - '0';
		year_ = year_*10;
		year_ = year_ + (int)x[i][7] - '0'; 
		year_ = year_ + 2000;

		dateNumber[i]= (day_-day+(month_-month)*31.0)*24.0*3600.0 ;
		curlvalue[i] = y[i];
	}


   TDatime da(year,month,day,0,0,0);
   gStyle->SetTimeOffset(da.Convert());

   TCanvas *ct = new TCanvas("ct","Time on axis",0,0,900,600);

	

  // ht1 = new TGraph("ht1","ht1",30000,0.,260000.);
   TGraph *ht1 = new TGraph(x.size(),dateNumber,curlvalue);
	ht1->SetTitle("Number of sites accessibles with curl");
   //for (Int_t i=1;i<30000;i++) {
    //  Float_t noise = gRandom->Gaus(0,120);
    //  ht1->SetBinContent(i,i);
   //}

   //ct->cd(1);
   ht1->SetLineColor(2);
   ht1->SetLineWidth(2);
   ht1->SetMarkerColor(4);
   ht1->SetMarkerSize(1.5);
   ht1->SetMarkerStyle(29);
   ht1->GetXaxis()->SetLabelSize(0.02);
   ht1->GetXaxis()->SetTimeDisplay(1);
   //ht1->GetXaxis()->SetTimeFormat("%d\/%m\/%Y%F2014-01-01 00:00:00");
   ht1->GetXaxis()->SetTimeFormat("%d\/%m\/%Y");
   ht1->Draw("ALP");


	ct->Print(Form("canvas.eps"));
}
