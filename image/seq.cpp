#include "seq.hpp"

Seq::Seq(std::string s, std::string t, int n, bool l) :
		source(s), target(t), numChannel(n), printLabel(l) {
	// read h5 file and get the data
	h5file = new h5Data(source, numChannel);
	label = h5file->getLa();
	for (int i = 0; i < numChannel; i++) {
		ch[i] = h5file->getCh(i);
	}
	length = h5file->getLength();
}

Seq::~Seq() {
	// delete files with pointer at the end, release channel data in the end
	delete h5file;
}

// convert float (0-1) value images to int (0-255) images with bound limit
void Seq::float2Image(const cv::Mat &floatMat, cv::Mat &imageMat,
		double l, double u) {
	for (int i = 0; i < floatMat.rows; i++) {
		for (int j = 0; j < floatMat.cols; j++) {
			float x = floatMat.at<float>(i, j);
			imageMat.at<uchar>(i, j) = cast(x, l, u);
		}
	}
}

// load array data image with offset to int images with resize
cv::Mat Seq::loadOrigin(float *image, int originHeight, int originWidth,
		int outHeight, int outWidth) {
	// convert array data from float to int image
	cv::Mat originFloat = cv::Mat(originHeight, originWidth, CV_32F, image);
	cv::Mat originInt = cv::Mat(cv::Size(originWidth, originHeight), CV_8UC1);
	float2Image(originFloat, originInt, 0.0, 1.0);

	// resize image if necessary
	cv::Mat resize = cv::Mat(cv::Size(outWidth, outHeight), CV_8UC1);
	if (originHeight == outHeight && originWidth == outWidth) {
		originInt.copyTo(resize);
	} else {
		cv::resize(originInt, resize, cv::Size(outWidth, outHeight),
			0, 0, cv::INTER_LINEAR);
	}

	return resize;
}

// generate flow and original image
void Seq::flow(int whichCh, int originHeight, int originWidth,
		int outHeight, int outWidth, double bound) {
	// following frames (start with one to support original flow computation)
	for (int i = 1; i < length; i++) {
		// load next image
		std::string imageName;
		if (printLabel) {
			imageName = target + "/ch" + std::to_string(whichCh) + "_" +
				std::to_string(i - 1) + "_" + std::to_string(label[i - 1]) + "_";
		} else {
			imageName = target + "/ch" + std::to_string(whichCh) + "_" +
				std::to_string(i - 1) + "_";
		}

		// write the original image and save to file
		cv::Mat image = loadOrigin(ch[whichCh] + i * originHeight * originWidth,
			originHeight, originWidth, outHeight, outWidth); // resize image for out
		cv::imwrite(imageName + "image.jpg", image);
	}
}
