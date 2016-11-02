import os, subprocess
import numpy as np
import h5py
import json

from image import image

class Operation:
    def __init__(self):
        pass

    # generate image for each sequence
    def generate_image(self, source, target, num_channel, origin_size=32,
            out_size=32, bound=15.0, bin_image='image/bin/image'):
        if not os.path.exists(target): os.makedirs(target)
        # run flow command
        p = subprocess.Popen([bin_image,
            '--source', source, '--target', target,
            '--channel', str(num_channel),
            '--origin', str(origin_size),
            '--out', str(out_size),
            '--bound', str(bound)])
        p.wait()
        # generate label file
        self._generate_label(source, target)

    # load labels
    def _generate_label(self, source, target, label_file='label.json'):
        with h5py.File(source, 'r') as hf:
            labels = [int(l) for l in hf['label'][()]]
        # save labels as a dict in json file
        labels_dict = {i: l
            for i, l in zip(range(len(labels) - 1), labels[1:])}
        with open(os.path.join(target, label_file), 'w') as jf:
            json.dump(labels_dict, jf)

    # delete generated image files
    def clean_image(self, file_dir, label_file='label.json'):
        print 'Cleaning', file_dir
        # delete images in dir
        image_files = [os.path.join(file_dir, f)
            for f in os.listdir(file_dir)
            if os.path.isfile(os.path.join(file_dir, f)) and 'jpg' in f]
        for image_file in image_files:
            try:
                os.remove(image_file)
            except Exception, e:
                print e
        # delete label file
        try:
            os.remove(os.path.join(file_dir, label_file))
        except Exception, e:
            print e
        # delete dir
        try:
            os.rmdir(file_dir)
        except Exception, e:
            print e

    # get frame count
    def _get_frame_num(self, source, label_file='label.json'):
        with open(os.path.join(source, label_file), 'r') as jf:
            labels_dict = json.load(jf)
        return len(labels_dict)

    # setup mean counter and accumulator at the beginning
    def setup_mean(self, num_channel, out_size):
        self.image_sums = {}
        self.count = 0.0
        for c in range(num_channel):
            self.image_sums['ch%i_image' % (c,)] = \
                np.zeros((1, out_size, out_size), dtype='float32')

    # accumulate mean for each sequence
    def accum_mean(self, source, num_channel, out_size):
        print 'Loading mean', source
        frame_num = self._get_frame_num(source)
        self.count += frame_num
        for c in range(num_channel):
            for i in range(frame_num):
                image_name = os.path.join(source,
                    'ch%i_%i_image.jpg' % (c, i))
                self.image_sums['ch%i_image' % (c,)] += \
                    image(image_name).load(out_size, out_size)

    # save accumulated mean to file
    def save_mean(self, mean_file, num_channel):
        # store file as hdf5
        if mean_file.endswith('h5'):
            print 'Save as hdf5'
            with h5py.File(mean_file, 'w') as f:
                for c in range(num_channel):
                    f.create_dataset('ch%i_image' % (c,),
                        data=self.image_sums['ch%i_image' % (c,)]
                            / self.count)
        # store file as matlab data
        elif mean_file.endswith('mat'):
            import scipy.io as sio
            print 'Save as mat'
            data = {}
            for c in range(num_channel):
                data['ch%i_image' % (c,)] = \
                    self.image_sums['ch%i_image' % (c,)] / self.count
            sio.savemat(mean_file, data)
