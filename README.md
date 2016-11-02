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
hardware. (link to the [paper video](http://bit.ly/2fDd9iJ): )
