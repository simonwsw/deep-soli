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
> and velocity.

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

- Preprocessing (HDF5 to images): ``
- Preprocessing (generate mean file): ``
- Load model and evaluate: ``

## Dataset

- Download [dataset](https://polybox.ethz.ch/index.php/s/wG93iTUdvRU8EaT)
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
- Please refer to the paper for the gesture collecting
  campaign details.
- The gestures are listed in the table below. Each column represents
  one gesture and we snapshot three important steps for each gestures.
  The gesture label is indicated by the number in the circle above. Please
  notice that the gesture label order is different than the paper, as
  we regroup gestures in the paper.

![gesture](http://bit.ly/2fHcMRX)

## Pre-trained model

- [Download model](https://polybox.ethz.ch/index.php/s/0SEdZqkn433dbEh)
- Trained proposed model, please refer to the paper for model detail.
- Simple Lua (Torch 7) code to load the model:
  ```bash
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
