#include "h5Data.hpp"

h5Data::h5Data(std::string f, int n) : fileName(f), numChannel(n) {
	// turn off the auto-printing when failure occurs
	dataFile = new H5::H5File(fileName, H5F_ACC_RDONLY);

	datasetLa = load(datasetNameLa, -1);
	for (int i = 0; i < numChannel; i++) {
		datasetCh[i] = load(datasetNameCh + std::to_string(i), i);
	}
}

h5Data::~h5Data() {
	// delete array of label and channels with []
	delete[] label;
	delete datasetLa;
	for (int i = 0; i < numChannel; i++) {
		delete[] ch[i];
		delete datasetCh[i];
	}

	delete dataFile;
}

H5::DataSet* h5Data::load(H5std_string datasetName, int whichCh) {
	// open dataset, dataspace and property list
	try {
		H5::Exception::dontPrint();
		hsize_t dimsr[2];
		H5::DataSet* dataset = new H5::DataSet(dataFile->openDataSet(datasetName));
		H5::DataSpace *filespace = new H5::DataSpace(dataset->getSpace());
		H5::DSetCreatPropList prop = dataset->getCreatePlist();

		// get information to obtain memory dataspace.
		int rank = filespace->getSimpleExtentNdims();
		filespace->getSimpleExtentDims(dimsr);
		H5::DataSpace* memspace = new H5::DataSpace(rank, dimsr, NULL);

		length = dimsr[0];

		// load labels and channels
		if (whichCh == -1) {
			label = new int[length];
			dataset->read(label, H5::PredType::NATIVE_INT, *memspace, *filespace);
		} else {
			ch[whichCh] = new float[length * dimsr[1]];
			dataset->read(ch[whichCh], H5::PredType::NATIVE_FLOAT, *memspace,
				*filespace);
		}

		prop.close();
		delete filespace;
		delete memspace;

		return dataset;
	} catch (H5::FileIException error) {
		error.printError();
		return NULL;
	} catch (H5::DataSetIException error) {
		error.printError();
		return NULL;
	} catch (H5::DataSpaceIException error) {
		error.printError();
		return NULL;
	}
}
