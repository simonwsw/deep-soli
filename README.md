# deep-soli

Gesture Recognition Using Neural Networks with Google's Project Soli Sensor

## Update

Dataset and trained model are now available.

## Introduction

This is the open source evaluation code base of our paper:

**Interacting with Soli: Exploring Fine-Grained Dynamic Gesture Recognition
in the Radio-Frequency Spectrum** <br />
Saiwen Wang, Jie Song, Jamie Lien, Poupyrev Ivan, Otmar Hilliges <br />
(link to the [paper](http://bit.ly/2ftSRcn))

This project uses Google's [Project Soli](atap.google.com/soli) sensor.

> Soli is a new sensing technology that uses miniature radar to
> detect touchless gesture interactions.
>
> ![Soli sensor image](http://bit.ly/2fbwLYm)
>
> Soli sensor technology works by emitting electromagnetic waves in a
> broad beam. Objects within the beam scatter this energy, reflecting
> some portion back towards the radar antenna. Properties of the
> reflected signal, such as energy, time delay, and frequency shift
> capture rich information about the object’s characteristics and
> dynamics, including size, shape, orientation, material, distance,
> and .

Our paper uses a light-weight end-to-end trained Convolutional Neural Networks
and Recurrent Neural Networks architecture, recognizes 11 in-air gestures
with 87% per-frame accuracy, and can perform realtime predictions at 140Hz
on commodity hardware. (link to the [paper video](http://bit.ly/2fDd9iJ))

## Pre-request

- Python 2: HDF5, OpenCV 2 interfaces for python.
- C++: HDF5, OpenCV 2, Boost
- Lua JIT and Torch 7.
- Torch 7 packages: `class`, GPU support `cunn` and `cutorch`, Matlab
  support `mattorch`, JSON support `lunajson`, Torch image library `image`
- Please note that `mattorch` is an outdated packages which is no
  longer maintained.

## Quick start

- Preprocessing (HDF5 to images):

```
python pre/main.py --op image --file [dataset folder]
--target [target image folder] --channel 4 --originsize 32 --outsize 32
```

- Preprocessing (generate mean file):

```
python pre/main.py --op mean --file [image folder]
--target [mean file name] --channel 4 --outsize 32
```

- Load model and evaluate:

```
th net/main.lua --file [image folder] --list [train/test sequence split file]
--load [model file] --inputsize 32 --inputch 4 --label 11 --datasize 32
--datach 3 --batch 16 --maxseq 40 --cuda --cudnn
```

## Dataset

- Download [dataset](https://polybox.ethz.ch/index.php/s/wG93iTUdvRU8EaT)
  (please let me know when the link doesn't work).
- Train/test split file (in JSON format) we used is stored in the repo
  `config/file_half.json`.
- The dataset contains multiple preprocessed Range-Doppler Image sequences.
  Each sequence is saved as a single HDF5 format data file. File names are
  defined as `[gesture ID]_[session ID]_[instance ID].h5`. Range-Doppler Image
  data of a specific channel can be accessed by dataset name `ch[channel ID]`.
  Label can be accessed by dataset name `label`. Range-Doppler Image
  data array has shape of `[number of frame] * 1024` (can be reshape back to 2D Range-Doppler Image to `32 * 32`)
- Simple Python code to access the data:

```python
# Demo code to extract data in python
import h5py

use_channel = 0
with h5py.File(file_name, 'r') as f:
    # Data and label are numpy arrays
    data = f['ch{}'.format(use_channel)][()]
    label = f['label'][()]
```

- Dataset session arrangement for evaluation.
  - 11 (gestures) * 25 (instances) * 10 (users) for cross user evaluation:
    session 2 (25), 3 (25), 5 (25), 6 (25), 8 (25), 9 (25), 10 (25), 11 (25),
    12 (25), 13 (25).
  - 11 (gestures) * (50 (instances) * 4 (sessions) +
    25 (instances) * 2 (sessions)) for single user
    cross session evaluation: session 0 (50), 1 (50), 4 (50), 7 (50),
    13 (25), 14 (25).
  - Please refer to the paper for the gesture collecting
    campaign details.
- The gestures are listed in the table below. Each column represents
  one gesture and we snapshot three important steps for each gestures.
  The gesture label is indicated by the number in the circle above. Please
  notice that the gesture label order is different than the paper, as
  we regroup gestures in the paper. Sequences with gesture ID 11 are
  background signals with no presence of hand.

![gesture](http://bit.ly/2fHcMRX)

## Pre-trained model

- Download [model](https://polybox.ethz.ch/index.php/s/0SEdZqkn433dbEh)
- Trained proposed model, please refer to the paper for model detail.
- Simple Lua (Torch 7) code to load the model:

```
loadFile = 'uni_image_np_50.t7'
net = torch.load(loadFile)
print(net)
```

- The model uses layers support `cudnn`.

## Comments on the code base

This is a simplified version of the original code base we used for all the
experiments in the paper. The complex Torch based class hierarchies in
the `net` reflects varies model architectures we tried during the
experiments. For simplicity, we only make the evaluation part public.
The model detail can be found both in the paper and the model file.

## License

This project is licensed under the terms of the MIT license.
