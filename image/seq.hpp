#ifndef SEQ_H
#define SEQ_H

#include <iostream>
#include <string>

// opencv
#include <opencv2/opencv.hpp>

#include "h5Data.hpp"

#endif

class Seq {
private:
	std::string source, target;
	int numChannel;
	int length;
	bool printLabel;

	// use file pointer to avoid call destructor of h5Data too soon
	h5Data *h5file = NULL;

	// not in charge of manage memory
	int *label;
	float *ch[8];

	void resize();
	// void flow();
public:
	Seq(std::string s, std::string t, int n, bool l);
	~Seq();

	inline float cast(float v, float l, float u) {
		if (v > u) return 255;
		else if (v < l) return 0;
		else return cvRound(255 * (v - l) / (u - l));
	}

	void float2Image(const cv::Mat &floatMat, cv::Mat &imageMat,
		double lBound, double uBound);
	cv::Mat loadOrigin(float *image, int originHeight, int originWidth,
		int outHeight, int outWidth);

	void flow(int whichCh, int originHeight, int originWidth,
		int outHeight, int outWidth, double bound);
};
