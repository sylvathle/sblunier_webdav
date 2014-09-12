#include <iostream>
#include <stdlib.h>
#include <dirent.h>
#include <fstream>

#include <time.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <stdio.h>
#include <errno.h>

#include "TFile.h"
#include "TStyle.h"
#include "TH1.h"
#include "TH2.h"
#include "TMatrixD.h"
#include "TColor.h"
#include "TImage.h"
#include "TCanvas.h"


#include <algorithm>
#include <string>
#include <vector>


using namespace std;

char* string2char(string st);
char* getDatadisk(string analy);
bool contains(vector<int> str, int tocompare );

int main()
{
	DIR* rep = NULL;
	struct dirent* fichierLu = NULL;
	string firstpath("/afs/cern.ch/user/s/sblunier/public/Histograms/Davix/");
	rep = opendir(string2char(firstpath));
	if (rep == NULL)
	        exit(1);

	int Xtime=0;
	int XtimeMax=0;
	int Yanaly=0;

        while ((fichierLu = readdir(rep)) != NULL)
        {   
                //if (fichierLu->d_name[0] == '.' || fichierLu->d_name[0] == 'u')
                if (fichierLu->d_name[2] != 0 || fichierLu->d_name[0] == '.')
                        continue;
		if (fichierLu->d_name[0] != 'D' && fichierLu->d_name[1] != 'E')
			continue;
		DIR* clouds = NULL;
		struct dirent* cloudsLu = NULL;
		//cout << fichierLu->d_name << endl;
		string secondpath = firstpath+ string(fichierLu->d_name);
		clouds = opendir(string2char(secondpath));

		Yanaly=0;
		XtimeMax=0;

		bool isFirstDay=true;
		int day=0;
		int month=0;
		int year=0;
		
		vector<int> dates; 
		
		vector<int> hasNumber;
		hasNumber.clear();
		
		while ((cloudsLu = readdir(clouds)) != NULL)
		{
			if (cloudsLu->d_name[0] != 'A')
				continue;
			//cout << cloudsLu->d_name << endl;
			DIR* analys = NULL;
			struct dirent* analyLu = NULL;
			string thirdpath = secondpath+"/"+string(cloudsLu->d_name);
			analys = opendir(string2char(thirdpath));
			
			Xtime=0;		
			while ((analyLu = readdir(analys)) != NULL)
			{
				if (analyLu->d_name[0] != 'a' || analyLu->d_name[3] != 'g')
					continue;
				string forthpath = thirdpath+"/"+string(analyLu->d_name)+"/"+string(cloudsLu->d_name)+".root";

				struct stat buf;
				int result;
				char *timebuf;
				result = stat (string2char(forthpath), &buf);
				TDatime da(buf.st_mtime);
				string strday (da.AsSQLString());
				strday.erase(10,9);
				int secondsFromFirstDay;
				if (isFirstDay)
				{
					isFirstDay=false;
					day = da.GetDay();
					month = da.GetMonth();
					year = da.GetYear();
				}
				if (!contains(hasNumber,secondsFromFirstDay))
				{
					Xtime++;
					dates.push_back((da.GetDay()-day+(da.GetMonth()-month)*31.0)*24.0*3600.0);
					hasNumber.push_back(secondsFromFirstDay);
				}
			}
			
			if (Xtime!=0)
				Yanaly++;
			if (Xtime>XtimeMax)
				XtimeMax=Xtime;
			
		}

		sort(dates.begin(),dates.end());

		cout << XtimeMax << endl;
		cout << Yanaly << endl;

		TDatime d(year,month,day,0,0,0);
		gStyle->SetTimeOffset(d.Convert());

		TCanvas * c = new TCanvas("c", "c");
		c->SetLeftMargin(0.20);
		c->SetBottomMargin(0.10);
		c->SetWindowSize(2100,1500);
	
		gStyle->SetTitleH(0.08);
		string th2Title = "Evolution of file read at " + string(fichierLu->d_name); 
                TH2F* h = new TH2F("title",string2char(th2Title),XtimeMax,0.,XtimeMax,Yanaly,0.,Yanaly);

		clouds = NULL;
		cloudsLu = NULL;
		secondpath = firstpath+ string(fichierLu->d_name);
		clouds = opendir(string2char(secondpath));

		hasNumber.clear();

		while ((cloudsLu = readdir(clouds)) != NULL)
		{
			vector<int> hasNumber;
			hasNumber.clear();
			if (cloudsLu->d_name[0] != 'A')
				continue;
			//cout << cloudsLu->d_name << endl;
			DIR* analys = NULL;
			struct dirent* analyLu = NULL;
			string thirdpath = secondpath+"/"+string(cloudsLu->d_name);
			analys = opendir(string2char(thirdpath));
			
			while ((analyLu = readdir(analys)) != NULL)
			{
				if (analyLu->d_name[0] != 'a' || analyLu->d_name[3] != 'g')
					continue;
				string forthpath = thirdpath+"/"+string(analyLu->d_name)+"/"+string(cloudsLu->d_name)+".root";

				TFile *fr = TFile::Open(string2char(forthpath));
				if (fr==NULL)
					continue;
				TH1F* hist = (TH1F*)fr->Get(getDatadisk(cloudsLu->d_name));
				//cout << getDatadisk(cloudsLu->d_name) << endl;
				if (hist==NULL)
					continue;
				
				struct stat buf;
				int result;
				char *timebuf;
				result = stat (string2char(forthpath), &buf);
				TDatime da(buf.st_mtime);
				string strday (da.AsSQLString());
				strday.erase(10,9);
				int secondsFromFirstDay = (da.GetDay()-day+(da.GetMonth()-month)*31.0)*24.0*3600.0;
				for (int i=0;i<hasNumber.size();i++)
					cout << hasNumber[i] << " " ;
				cout << endl;
				if (!contains(hasNumber,secondsFromFirstDay))
				{
					//h->Fill(string2char(strday),getDatadisk(cloudsLu->d_name),0);
					cout << (da.GetDay()-day+(da.GetMonth()-month)*31.0)*24.0*3600.0 << " " <<  getDatadisk(cloudsLu->d_name) << " " << da.GetDay() << " " << da.GetMonth() <<   endl;
					h->Fill((da.GetDay()-day+(da.GetMonth()-month)*31.0)*24.0*3600.0,getDatadisk(cloudsLu->d_name),0);
					for ( int l=2;l<3000;l++)
					{
						for (int k=0;k<hist->GetBinContent(l);k++)
						{
							//h->Fill(string2char(strday),getDatadisk(cloudsLu->d_name),1.0);
							h->Fill((da.GetDay()-day+(da.GetMonth()-month)*31.0)*24.0*3600.0,getDatadisk(cloudsLu->d_name),1.0);
							hasNumber.push_back(secondsFromFirstDay);
						}
					}
				}
			}
		}
		const Int_t Number = 5;
		Double_t Red[Number] = { 1.00, 0.75, 1.00, 0.25, 0.00 };
		Double_t Green[Number] = { 0.00, 0.25, 0.50, 0.75, 1.00 };
		Double_t Blue[Number] = { 0.00, 0.00, 0.00, 0.00, 0.00 };
		Double_t Stops[Number] = { 0.00, 0.34, 0.61, 0.84, 1.00 };
		Int_t nb=50;
		TColor::CreateGradientColorTable(Number,Stops,Red,Green,Blue,nb);
		gStyle->SetOptStat(0);

		h->GetXaxis()->SetTitle("date");
		//h->GetYaxis()->SetTitle("Percent of file read");

		h->SetTitleOffset(2.3,"Y");
		h->SetTitleOffset(1.0,"X");
		h->GetXaxis()->SetLabelSize(0.02);
		h->GetXaxis()->SetLabelSize(0.02);
		h->GetXaxis()->SetTimeDisplay(1);
		h->GetXaxis()->SetTimeFormat("%d\/%m\/%Y");
		h->Draw("COLZ");
		h->Draw("TEXT SAME");
		gStyle->SetOptStat(0);
		//gStyle->SetTitleY(0.1f);
		h->SetMaximum(100);
		h->SetMinimum(0);


		string epsFileName=string(fichierLu->d_name)+".eps";
		c->Print(Form(string2char(epsFileName)));

		delete c;
		delete h;
		break;
        }   
}

char* getDatadisk(string analy)
{
	ifstream SEvsWN("../SEvsWN.txt");	
	string line;
	int begin=0;
	int end=0;
	while (getline(SEvsWN,line))
	{
		int found = line.find(analy);
		if (found!=string::npos)
		{
			end = line.size()-9;
			for (int i=0;i<line.size();i++)
			{
				if (line[i]==',')
				{
					begin = i+1;
					break;
				}
			}	
			if (begin!=0)
				break;
		}
		if (begin!=0)
			break;
	}
	string datadisk = line.substr(begin,end-begin);
	return string2char(datadisk);
}

char* string2char(string st)
{
	char* title=NULL;
        title = new char[st.size()+1];
        memcpy(title,st.c_str(),st.size()+1);
	return title;
}

bool contains(vector<int> str, int tocompare )
{
	for (int i=0;i<str.size();i++)
	{
		if (str[i]==tocompare)
		{
			cout << "plopinet" << endl;
			return true;
		}
	}
	return false;
}
