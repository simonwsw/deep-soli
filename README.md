# deep-soli

Gesture Recognition Using Neural Networks with Google's Project Soli Sensor

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
with 87% accuracy, and can perform realtime predictions at 140Hz on commodity
hardware. (link to the [paper video](http://bit.ly/2fDd9iJ))

## Pre-request

- Python 2: HDF5, OpenCV 2 interfaces for python.
- C++: HDF5, OpenCV 2, Boost
- Lua JIT and Torch 7.
- Torch 7 packages: `class`, GPU support `cunn` and `cutorch`, Matlab
  support `mattorch`, JSON support `lunajson`, Torch image library `image`
- Please note that `mattorch` is an outdated packages which is no
  longer maintained.

## Quick start

## Dataset, model and other files

- Project Soli gesture sequence dataset: ...
- Mean file across all the sequences: ...
- Trained proposed model: ...

## Comments on the code base

This is a simplified version of the original code base we used for all the
experiments in the paper. The complex Torch based class hierarchies in
the `net` reflects varies model architectures we tried during the
experiments. For simplicity, we only make the evaluation part public.
The model detail can be found both in the paper and the model file.

## License

This project is licensed under the terms of the MIT license. 
