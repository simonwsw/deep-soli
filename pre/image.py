import cv2
import numpy as np

class image:
    def __init__(self, file_name):
        self.file_name = file_name

    # load image and resize image with size
    def load(self, height, width):
        frame = cv2.imread(self.file_name, cv2.IMREAD_GRAYSCALE)
        if height and width:
            frame = cv2.resize(frame, (width, height))
        frame = np.expand_dims(frame, axis=0).astype('float32')
        return frame
