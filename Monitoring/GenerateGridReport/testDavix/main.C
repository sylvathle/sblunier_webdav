#include <iostream>
#include "TDavixFile.h"
#include "TTree.h"
#include "TBranch.h"
#include "TEnv.h"

#include <ctime>
#include <fstream>
#include <vector>
#include <string>
#include <stdlib.h> 

using namespace std;

void fillTimes(char* fileName);

int main(int argc, char* argv[])
{
	fillTimes(argv[1]);
	return 0;
}

void fillTimes(char* fileName)
{
	Int_t nelec;

	TFile *f = TFile::Open(fileName);
	if (f==NULL)	
	{
		cout << fileName << " Not opened" << endl;
		//exit(EXIT_FAILURE);
	}
	TTree *T = (TTree*)f->Get("physics");
	T->SetBranchStatus("*",0);
	T->SetBranchStatus("el_n",1);
	T->SetBranchAddress("el_n",&nelec);
	//T->SetCacheSize(1024*1024);	

	Long64_t nentries = T->GetEntries();
	cout << "START reading datas"  << endl;
	for (Long64_t i=0;i<nentries;i++) {
		T->GetEntry(i);
	}
	delete T;
	delete f;

}
