#include <iostream>
#include "TFile.h"
#include "TTree.h"
#include "TTreeCache.h"
#include "TBranch.h"
#include "TH1F.h"
#include "TImage.h"
#include "TStyle.h"
#include "TCanvas.h"
#include "TEnv.h"

#include <fstream>
#include <ctime>
#include <fstream>
#include <vector>
#include <string>
#include <stdlib.h> 

using namespace std;

int fillTimes(char* fileName, char* enablettreecache);
void createHistogram(int datas, char* nameSite, char* nameProcessor, string protocol);
char* string2char(string st) ;

char* getFileName(string url);
char* getDavSite(string url);
char* getXUrl(string url);
char* getXSite(string url);


int main(int argc, char* argv[])
{
        TEnv *gEnv = new TEnv(".rootrc");
        gEnv->SetValue("Davix.GSI.UserProxy", "./x509up_u68281");
	gEnv->SaveLevel(kEnvLocal);
	//gEnv->Print();
	int timeDatas;
	string protocol;
	if (argv[1][0]=='h')
	{
		cout << argv[1] << endl;
		protocol = "WebDAV";
		timeDatas = fillTimes(argv[1],argv[3]);
		createHistogram(timeDatas,getDavSite(argv[1]), argv[2],protocol);
	}
	else
	{
		cout << getXUrl(argv[1]) << endl;
		protocol = "xrootd";
		timeDatas = fillTimes(getXUrl(argv[1]),argv[3]);
		createHistogram(timeDatas,getXSite(argv[1]), argv[2],protocol);
	}
	return 0;
}

int fillTimes(char* fileName, char* enablettreecache)
{
	double timeDatas;

	Int_t nelec;
	Int_t nmuon;

	//TFile *f = TFile::Open(fileName,"GRID_MODE CA_CHECK=no");
	TFile *f = TFile::Open(fileName);
	if (f!=NULL)
	{	
		TTree *T = (TTree*)f->Get("physics");
		T->SetBranchStatus("*",0);
		T->SetBranchStatus("el_n",1);
		T->SetBranchStatus("mu_n",1);
		T->SetBranchAddress("el_n",&nelec);
	 	T->SetBranchAddress("mu_n",&nmuon);
		//T->SetCacheLearnEntries(50); 
		//T->ResetCache()	;
		//TTreeCache::SetLearnEntries(0); 
		if (enablettreecache==NULL)
			enablettreecache="no";
		if (strcmp(enablettreecache,"ttreecache")==0)
			T->SetCacheSize(1024*1024);	
		//T->SetCacheEntryRange(0,5000);
	
		Long64_t nentries = T->GetEntries();
		//nentries = 10;
		time_t t;	
		time_t t1;
		cout << "START reading datas"  << endl;
		bool err = 0;
		time(&t1);
		for (Long64_t i=0;i<nentries;i++) {
			T->GetEntry(i);
		}
		time(&t);

		if (err)
			timeDatas = 0;
		else
			timeDatas=(double) nentries / (double)(t-t1);
		//cout << timeDatas << endl;
		printf("Reading %lld bytes in %d transactions\n",f->GetBytesRead(),  f->GetReadCalls());
		delete T;
	}
	else
	{
		cout << fileName << " Not opened" << endl;
		timeDatas = 0;
		//cout << timeDatas << endl;
	}
	delete f;
	return timeDatas;
}

void createHistogram(int data, char* nameSite, char* nameProcessor, string protocol)
{
	string rootFile(nameProcessor);
	string extention(".root");
	rootFile = rootFile+extention;
	char* root=NULL;
	root = new char[rootFile.size()+1];
	memcpy(root,rootFile.c_str(),rootFile.size()+1);

	TFile f(root,"update");
	cout << nameSite << endl;
	string strTitle(nameSite);
	string strNameProcessor(nameProcessor);
	strTitle = strTitle + " at " + strNameProcessor + " with " + protocol;
	TCanvas *c = new TCanvas;
	char *title=new char[strTitle.size()+1];
	memcpy(title,strTitle.c_str(),strTitle.size()+1);


	string strSecondLineTitle = "\tProcessed at ";
	strSecondLineTitle = strSecondLineTitle + strNameProcessor;
	char *secondLineTitle=NULL;
	secondLineTitle = new char[strSecondLineTitle.size()+1];
	memcpy(secondLineTitle,strSecondLineTitle.c_str(),strSecondLineTitle.size()+1);
	
	string strDeleteKey(nameSite);
	strDeleteKey = strDeleteKey + ";1";
	char *deleteKey=NULL;
	deleteKey = new char[strDeleteKey.size()+1];
	memcpy(deleteKey,strDeleteKey.c_str(),strDeleteKey.size()+1);

	
	TH1F *hist = (TH1F*)f.Get(nameSite);
	if (hist==NULL)
		hist = new TH1F(nameSite,title,3000,0.,3000);
	else
		f.Delete(deleteKey);
	//hist->SetTitleSize(0.1); 
	hist->SetXTitle("events rate (event/second)");
	hist->SetYTitle("Nb of file read");
	
	hist->Fill(data);

	cout << "Average : " << hist->GetMean() << " Error : " << hist->GetRMS() << endl;
	hist->Draw();
	f.Write();
	delete hist;
	delete c;
}

 
char* getFileName(string url)
{
	char* charUrl=NULL;
	charUrl = new char[url.size()+1];
	memcpy(charUrl,url.c_str(),url.size()+1);
	int markerIn=0;
	int markerFin=0;
	for (unsigned int i=0;i<url.size();i++)
	{
		if (charUrl[i]=='/')
			markerIn=i;
		if (charUrl[i]=='?')
			markerFin=i;
	}	
	char* name=NULL;
	name = new char[markerFin-markerIn-1];
	
	int it;
	for (it=markerIn+1;it<markerFin;it++)
		name[it-markerIn-1]=charUrl[it];
	name[it-markerIn-1]=0;
	delete charUrl;
	return name;
}



char* getDavSite(string url)
{
	char* charUrl=NULL;
	charUrl = new char[url.size()+1];
	memcpy(charUrl,url.c_str(),url.size()+1);

	int markerIn=0;
	int markerFin=0;
	for (unsigned int i=0;i<url.size();i++)
	{
		if (charUrl[i]=='=')
			markerIn=i;
		if (charUrl[i]=='_')
			markerFin=i;
	}	
	int size = markerFin-markerIn-1;
	char* name=NULL;
	name = new char[size];
//	cout << "size = " << size<< " " << markerIn << " " << markerFin << endl;
	int it;
	for (it=markerIn+1;it<markerFin;it++)
	{
		name[it-markerIn-1]=charUrl[it];
//		cout << it << " " << it-markerIn-1 << " " << charUrl[it] << endl;
	}
	name[it-markerIn-1]=0;
	for (int i=0;i<size;i++)
	{
//		cout << i << " " << name[i] << endl;
	}
	delete charUrl;
//	cout << name << endl;
	return name;
}


char* getXSite(string url)
{
        int markerIn=0;
        int markerFin=0;
        for (unsigned int i=0;i<=url.size();i++)
        {
                if (url[i]=='=')
                        markerIn=i;
		markerFin=i;
        }
        string name=url;
	name.erase(markerIn,markerFin);
        return string2char(name);
}


char* getXUrl(string url)
{
        int markerIn=0;
        //int markerFin=0;
        for (unsigned int i=0;i<=url.size();i++)
        {
                if (url[i]=='=')
                        markerIn=i;
		//markerFin=i;
        }
        string name=url;
	name.erase(0,markerIn+1);
        return string2char(name);
}


char* string2char(string st) 
{
        char* title=NULL;
        title = new char[st.size()+1];
        memcpy(title,st.c_str(),st.size()+1);
        return title;
}

