#ifndef H5DATA_H
#define H5DATA_H

#include <iostream>
#include <string>

// hdf5 includes
#include "H5Cpp.h"

// h5 tags
namespace {
	const H5std_string datasetNameLa = "label";
	const H5std_string datasetNameCh = "ch";

	const hsize_t dimsLa[2] = {1, 1};
	const hsize_t dimsCh[2] = {1, 32 * 32};

	const int backgroundClass = 0;
}

#endif

// data class for 5f file
class h5Data {
private:
	std::string fileName;
	int numChannel;
	int length;

	// store dataset
	H5::H5File *dataFile = NULL;
	H5::DataSet *datasetLa = NULL;
	H5::DataSet *datasetCh[8];

	// store label and channels data
	int *label;
	float *ch[8];

public:
	h5Data(std::string f, int n);
	~h5Data();

	H5::DataSet* load(H5std_string datasetName, int whichCh);

	inline float* getCh(int whichCh) { return ch[whichCh]; }
	inline int* getLa() { return label; }
	inline int getLength() { return length; }
};
