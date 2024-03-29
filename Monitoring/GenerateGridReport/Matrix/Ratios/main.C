#include <iostream>
#include <fstream>
#include <stdlib.h>
#include <dirent.h>
#ifndef WIN32
    #include <sys/types.h>
#endif

#include "TFile.h"
#include "TStyle.h"
#include "TH1.h"
#include "TH2.h"
#include "TMatrixD.h"
#include "TColor.h"
#include "TCanvas.h"


#include <string>
#include <vector>


using namespace std;

char* siteProcesser(string url);
char* siteRead(string url);

char* string2char(string st);

bool belongToVector(vector<char*> vec, char* value);
vector<char*> deleteFromVector(vector<char*> vec, char* value);

struct ratioMatrixValue
{
	char* analy;
	vector<char*> datadisk;
	vector<double> ratio;
	vector<double> error;
};

vector<ratioMatrixValue> ordenate(vector<ratioMatrixValue> th2array, string cloud);
int* analyDatadiskPosIn(vector<ratioMatrixValue> th2array,char* analy,char* datadisk);

int main(int argc, char* argv[])
{
	string drootpath = "../../../Histograms/TDavix/";
	string xrootpath = "../../../Histograms/xrootd/";

	string cloudpath = argv[1] ;
	cloudpath = cloudpath + "/";
	DIR* dcloudrep = opendir(string2char(drootpath+cloudpath));
	struct dirent* dcloudfichier = NULL;

	vector<ratioMatrixValue> th2array;

	while ((dcloudfichier = readdir(dcloudrep))!=0)
	{
		if (dcloudfichier->d_name[0]=='.')
			continue;
		string dcloudpath = cloudpath + dcloudfichier->d_name + "/";
		DIR* drootfile = opendir(string2char(drootpath+dcloudpath));
		struct dirent* drootfichier = NULL;
		string allgrid;
		allgrid = string(argv[2]);
		string dfilepath = drootpath + dcloudpath + allgrid + "/" + dcloudfichier->d_name + ".root";
		allgrid[0] = 'x';
		string xfilepath = xrootpath + dcloudpath + allgrid + "/" + dcloudfichier->d_name + ".root";

		ratioMatrixValue column;
		
		TFile *xfr = TFile::Open(string2char(xfilepath));
		if (xfr==NULL)
			continue;
		TFile *dfr = TFile::Open(string2char(dfilepath));
		if (dfr==NULL)
			continue;

		column.analy = dcloudfichier->d_name;

		for (int i=0;i<dfr->GetListOfKeys()->GetEntries();i++)
		{
			string dstrRead = string2char(dfr->GetListOfKeys()->At(i)->GetName());
			for (int j=0;j<xfr->GetListOfKeys()->GetEntries();j++)
			{
				string xstrRead = xfr->GetListOfKeys()->At(j)->GetName();

				if (xstrRead == dstrRead)
				{
					TH1F* dhist = (TH1F*)dfr->Get(string2char(dstrRead));
					if (dhist==NULL)
						continue;
					TH1F* hist1 = new TH1F(dhist->GetName(),dhist->GetTitle(),3000,0.,3000.);
					for ( int l=2;l<3000;l++)
						for (int k=0;k<dhist->GetBinContent(l);k++)
							hist1->Fill(l-1);
					TH1F* xhist = (TH1F*)xfr->Get(string2char(xstrRead));
					if (xhist==NULL)
						continue;
					TH1F* hist2 = new TH1F(xhist->GetName(),xhist->GetTitle(),3000,0.,3000.);
					for ( int l=2;l<3000;l++)
						for (int k=0;k<xhist->GetBinContent(l);k++)
							hist2->Fill(l-1);
					column.datadisk.push_back(string2char(dstrRead));
					column.ratio.push_back(hist1->GetMean()/hist2->GetMean());
					//column.error.push_back(0.1);
					continue;
				}
			}
		}	
		th2array.push_back(column);
	}
	
	unsigned int datadisk_number=0;
	unsigned int analy_number=0;
	for (unsigned int i=0;i<th2array.size();i++)
	{
		if (datadisk_number < th2array[i].datadisk.size())
			datadisk_number = th2array[i].datadisk.size();
		if (th2array[i].datadisk.size()!=0)
			analy_number++;
	}

        TCanvas * c = new TCanvas("c", "c");
        c->SetLeftMargin(0.20);
        c->SetBottomMargin(0.15);
        c->SetWindowSize(2100,1500);


	th2array = ordenate(th2array,string(argv[1]));

	string cloud = argv[1];
	char *title = string2char("Ratio davix/xrootd for event's rate at "+cloud);
	TH2F *h = new TH2F("eventMatrix",title,analy_number,0.,analy_number,datadisk_number,0.,datadisk_number);
	for (unsigned int i=0;i<th2array.size();i++)
		for (unsigned int j=0;j<th2array[i].datadisk.size();j++)
			h->Fill(th2array[i].analy,th2array[i].datadisk[j],th2array[i].ratio[j]);
	const Int_t Number = 5;
        Double_t Red[Number] = { 1.00, 0.75, 1.00, 0.25, 0.00 };
        Double_t Green[Number] = { 0.00, 0.25, 0.50, 0.75, 1.00 };
        Double_t Blue[Number] = { 0.00, 0.00, 0.00, 0.00, 0.00 };
        Double_t Stops[Number] = { 0.00, 0.34, 0.61, 0.84, 1.00 };
        Int_t nb=50;
        TColor::CreateGradientColorTable(Number,Stops,Red,Green,Blue,nb);
        h->GetXaxis()->SetTitle("Processing site");
        h->GetXaxis()->CenterTitle();
        h->GetYaxis()->SetTitle("Data source site");
        h->GetYaxis()->CenterTitle();
        h->SetLabelSize(0.03,"Y");
        h->SetTitleOffset(2.3,"Y");
        h->SetLabelSize(0.03,"X");
        h->SetTitleOffset(2.0,"X");
        h->GetYaxis()->SetTitle("Data source site");
        h->Draw("COLZ");
        //h->Draw("TEXTE SAME");
        h->Draw("TEXT SAME");
        gStyle->SetOptStat(0);
        //gStyle->SetTitleY(0.1f);
        h->SetMaximum(1.2);
        h->SetMinimum(0);

	c->Print(Form("canvas.eps"));
        return 0;
}



char* string2char(string st)
{
	char* title=NULL;
        title = new char[st.size()+1];
        memcpy(title,st.c_str(),st.size()+1);
	return title;
}


vector<ratioMatrixValue> ordenate(vector<ratioMatrixValue> th2array, string cloud)
{
	string file = "../../Clouds/" + cloud + "/SEvsWN.txt";
	vector<char*> datadisks;
	vector<char*> listdatadisks;
	vector<char*> analy;
	vector<char*> listanaly;

	for (int i=0;i<th2array.size();i++)
		listanaly.push_back(th2array[i].analy);
	for (int i=0;i<th2array.size();i++)
		for (int j=0;j<th2array[i].datadisk.size();j++)
			if (!belongToVector(listdatadisks,th2array[i].datadisk[j]))
				listdatadisks.push_back(th2array[i].datadisk[j]);


	string line;
	ifstream SEvsWN(string2char(file));
	while (getline(SEvsWN,line))
	{
		for (unsigned int i=0; i<th2array.size(); i++)
		{
			int found1 = line.find(th2array[i].analy);
			bool foundAnaly=false;
			if (found1 != string::npos)
			{
				foundAnaly=true;
			}
			for (unsigned int j=0; j<th2array[i].datadisk.size(); j++)
			{
				int found2 = line.find(th2array[i].datadisk[j]);
				bool foundDatadisk=false;
				if (found2 != string::npos)
					foundDatadisk=true;
				if (foundAnaly && foundDatadisk && belongToVector(listdatadisks,th2array[i].datadisk[j]) && belongToVector(listanaly,th2array[i].analy))
				{
					datadisks.push_back(th2array[i].datadisk[j]);
					analy.push_back(th2array[i].analy);
					listdatadisks = deleteFromVector(listdatadisks,th2array[i].datadisk[j]);							
					listanaly = deleteFromVector(listanaly, th2array[i].analy);
					break;
				}
			}
		}
	}

	for (unsigned int i=0;i<listanaly.size();i++)
		analy.push_back(listanaly[i]);

	for (unsigned int i=0;i<listdatadisks.size();i++)
		datadisks.push_back(listdatadisks[i]);

	int I=0;
	int J=0;

	vector<ratioMatrixValue> retour;

	for(unsigned int i=0; i<analy.size();i++)
	{
		ratioMatrixValue column;
		for(unsigned int j=0; j<datadisks.size();j++)
		{
			I = analyDatadiskPosIn(th2array,analy[i],datadisks[j])[0];
			J = analyDatadiskPosIn(th2array,analy[i],datadisks[j])[1];
			if (I==-1 || J==-1)
			{
				column.datadisk.push_back(datadisks[j]);
				column.ratio.push_back(0);
			}
			else
			{
				column.datadisk.push_back(th2array[I].datadisk[J]);
				column.ratio.push_back(th2array[I].ratio[J]);
			}
		}
		column.analy = th2array[I].analy;
		retour.push_back(column);
	}

	//return th2array;
	return retour;
}

bool belongToVector(vector<char*> vec, char* value)
{
	for (unsigned int i=0;i<vec.size();i++)
	{
		if (strcmp(vec[i],value)==0)
			return true;
	}
	return false;
}


vector<char*> deleteFromVector(vector<char*> vec, char* value)
{
	vector<char*> retour;
	for (int i=0;i<vec.size();i++)
		if (strcmp(vec[i],value)!=0)
			retour.push_back(vec[i]);
	return retour;
}


int* analyDatadiskPosIn(vector<ratioMatrixValue> th2array,char* analy,char* datadisk)
{
	int Ianaly_Idatadisk[2];
	Ianaly_Idatadisk[0]=-1;
	Ianaly_Idatadisk[1]=-1;
	for (unsigned int i=0;i<th2array.size();i++)
	{
		if (strcmp(th2array[i].analy,analy)!=0)
			continue;
		Ianaly_Idatadisk[0]=i;
		for (unsigned int j=0;j<th2array[i].datadisk.size();j++)
		{
			//cout << th2array[i].datadisk[j] << " " << datadisk << " " << j << " " << endl;
			if (strcmp(th2array[i].datadisk[j],datadisk)!=0)
				continue;
			Ianaly_Idatadisk[1]=j;
		}
		break;
	}
	return Ianaly_Idatadisk;
}
