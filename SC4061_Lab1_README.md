# SC4061 Computer Vision — Lab 1: Image Processing Fundamentals in MATLAB

> SC4061 Computer Vision, Nanyang Technological University
> Choo Yi Ken | U2240710B | College of Computing and Data Science (CCDS)

A MATLAB lab implementing core computer vision and image processing techniques from scratch, covering point processing, spatial filtering, frequency-domain filtering, geometric transformation, and a from-scratch perceptron classifier.

---

## Overview

This lab explores fundamental image processing operations implemented in a single MATLAB script (`sc4061lab1.m`). Each section applies a different technique to real images, comparing results across parameter choices.

| Section | Topic | Input Image(s) |
|---------|-------|----------------|
| 2.1 | Contrast Stretching | `mrt-train.jpg` |
| 2.2 | Histogram Equalization | `mrt-train.jpg` |
| 2.3 | Linear Spatial Filtering (Gaussian) | `lib-gn.jpg`, `lib-sp.jpg` |
| 2.4 | Median Filtering | `lib-gn.jpg`, `lib-sp.jpg` |
| 2.5 | Suppressing Noise Interference (FFT) | `pck-int.jpg`, `primate-caged.jpg` |
| 2.6 | Undoing Perspective Distortion | `book.jpg` |
| 2.7 | Perceptron Algorithms | — (synthetic data) |

---

## Techniques Implemented

### 2.1 Contrast Stretching
Remaps pixel intensities to the full [0, 255] range using the formula:

```
P_new(i,j) = (P_old(i,j) - P_min) / (P_max - P_min) * 255
```

Applied to a grayscale MRT train image (original range: 13–204). Output shows improved visual contrast with darker darks and brighter highlights.

### 2.2 Histogram Equalization
Uses MATLAB's `histeq` to redistribute pixel intensities toward a uniform distribution. Histograms are visualised with 10 and 256 bins before and after equalization. The lab also investigates the idempotency of histogram equalization by applying it twice and comparing the results with `imabsdiff`.

### 2.3 Linear Spatial Filtering (Gaussian)
Constructs 5×5 Gaussian filters at two sigma values (σ=1 and σ=2) using `fspecial`, normalised and applied via `conv2`. The filters are applied to two library images:
- `lib-gn.jpg` — Gaussian noise
- `lib-sp.jpg` — Speckle noise

Higher σ produces stronger smoothing but at the cost of fine detail.

### 2.4 Median Filtering
Applies `medfilt2` with [3×3] and [5×5] neighbourhood windows to the same noisy library images. Compared to Gaussian filtering, median filtering better preserves edges while removing salt-and-pepper noise, but is less effective against Gaussian noise.

### 2.5 Suppressing Noise Interference Patterns (Frequency Domain)
Uses 2D FFT (`fft2`) to compute the power spectrum of images corrupted with diagonal stripe interference. Peaks in the spectrum corresponding to the interference frequency are identified interactively using `ginput` and zeroed out in a configurable neighbourhood window. The cleaned image is reconstructed via `ifft2`. Several window sizes (5×5 up to 21×21) are compared, and the method is applied to both `pck-int.jpg` and `primate-caged.jpg`.

### 2.6 Undoing Perspective Distortion
Corrects the perspective of a photographed book using a projective (homographic) transformation:
1. Four corner points of the book are selected interactively via `ginput`
2. The 3×3 homography matrix `U` is solved from the corner correspondences using least squares (`A \ v`)
3. The image is warped to a frontal view (210×297 mm, A4 proportions) using `maketform` and `imtransform`
4. A HSV-based colour mask is applied to detect and bound the pink region on the cover

### 2.7 Perceptron Algorithms
Two perceptron learning rules are implemented from scratch and tested on three datasets (linearly separable simple, linearly separable complex, and non-linearly separable XOR-like):

- **Algorithm 1** — Misclassification-driven update: `w = w ± α·xk` when a sample is misclassified. Convergence is tracked by counting misclassifications per iteration.
- **Algorithm 2** — Gradient descent on squared error: `w = w + α·(r - output)·xk`. Total squared error per epoch is tracked until convergence (error < 1e-6) or max iterations.

---

## Requirements

- MATLAB (tested on macOS; requires the Image Processing Toolbox)

---

## Setup & Usage

1. Place all input images (`mrt-train.jpg`, `lib-gn.jpg`, `lib-sp.jpg`, `pck-int.jpg`, `primate-caged.jpg`, `book.jpg`) in the same directory as `sc4061lab1.m`.

2. Open `sc4061lab1.m` in MATLAB and run it section by section using the **Run Section** button, or run the entire script at once.

3. Sections 2.5.b, 2.5.c, 2.6.b, and 2.6.f require interactive mouse input via `ginput` — click on the MATLAB figure window when prompted.

4. Processed output images are automatically saved to a `results/` subfolder (created if it does not exist):

```
results/
├── contrast-stretched-mrt-train.png
├── mrt-train-hist-eq1.png
├── mrt-train-hist-eq2.png
├── processed_gn_lib_gauss1.png
├── processed_gn_lib_gauss2.png
├── processed_sp_lib_gauss1.png
├── processed_sp_lib_gauss2.png
├── processed_gn_lib_med_3_3.png
├── processed_gn_lib_med_5_5.png
├── processed_sp_lib_med_3_3.png
├── processed_sp_lib_med_5_5.png
├── fft_pck_int_5_5.png
├── fft_pck_int_7_7.png
├── fft_pck_int_9_9.png
├── fft_pck_int_21_21.png
└── fft_primate_caged_5_5.png
    fft_primate_caged_11_11.png
```

---

## Author

**Choo Yi Ken** | U2240710B  
College of Computing and Data Science (CCDS)  
Nanyang Technological University
