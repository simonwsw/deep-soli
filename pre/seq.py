import os, re
import numpy as np
import h5py

from flow import flow

class seq:
    def __init__(self):
        pass

    # get files in label directories
    def get_h5(self, file_dir):
        return [os.path.join(file_dir, f)
            for f in os.listdir(file_dir)
            if os.path.isfile(os.path.join(file_dir, f)) and 'h5' in f]

    # get list of target image dir names
    def get_dir(self, file_dir):
        return [os.path.join(file_dir, d)
            for d in os.listdir(file_dir)
            if os.path.isdir(os.path.join(file_dir, d))]

    # generate image
    def generate_image(self, file_dir, target_dir, num_channel,
            origin_size, out_size, redo):
        source_files = self.get_h5(file_dir)
        f = flow()
        for s in source_files:
            t = os.path.join(target_dir, re.sub('.h5', '',
                os.path.basename(s)))
            if redo or not os.path.exists(t):
                print 'Generating', s
                f.generate_flow(s, t, num_channel, origin_size, out_size)

    # clean flow
    def clean_image(self, file_dir):
        file_dirs = self.get_dir(file_dir)
        f = flow()
        for d in file_dirs:
            f.clean_flow(d)

    # generate mean
    def generate_mean(self, file_dir, target, num_channel, out_size):
        f = flow()
        f.setup_mean(num_channel, out_size)
        source_dir = self.get_dir(file_dir)
        for s in source_dir:
            f.accum_mean(s, num_channel, out_size)
        f.save_mean(target, num_channel)
