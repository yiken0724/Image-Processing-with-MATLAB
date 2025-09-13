% Name: Choo Yi Ken
% Matric No.: U2240710B
% Title: SC4061 Lab 1

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 2.1 Contrast Stretching

%% Question 2.1.a
Pc = imread('mrt-train.jpg');
whos Pc;
if ndims(Pc) == 3 % convert to grayscale if it is rgb
    P = rgb2gray(Pc);
    whos P;
end

%% Question 2.1.b
figure;
imshow(P); 

%% Question 2.1.c
function out = show_intensity(image)
    max_intensity = max(image(:)); % show max intensity for all the pixels in P
    min_intensity = min(image(:)); % show min intensity for all the pixels in P
    fprintf("Min intensity: %d; Max intensity: %d\n", [min_intensity, max_intensity]);
    out = [min_intensity, max_intensity];
end

% results
P_intensity = show_intensity(P);

%% Question 2.1.d (using alternative method)

% preprocess
P_double = double(P);
double_min = double(P_intensity(1));
double_max = double(P_intensity(2));

% perform contrast stretching
P_stretched = (P_double - double_min) * (255 / (double_max - double_min)); 
P2 = uint8(P_stretched); % convert back to uint8 for display

% results
show_intensity(P2);
imshow(P2);

%% Question 2.1.e
figure;
imshow(P2);

if ~exist('results', 'dir')
    mkdir('results');
end

imwrite(P2, fullfile('results', 'contrast-stretched-mrt-train.png'));


%% 2.2 Histogram Equalization
%% Question 2.2.a
figure;
imhist(P, 10); 
title('Histogram without histogram equalization (10 bins)');

figure;
imhist(P, 256);
title('Histogram without histogram equalization (256 bins)');

%% Question 2.2.b
P3 = histeq(P,255); % function to perform histogram equalization
imwrite(P3, fullfile('results', 'mrt-train-hist-eq1.png'));

figure;
imhist(P3, 10); 
title('Histogram with histogram equalization (10 bins)');

figure;
imhist(P3, 256);
title('Histogram with histogram equalization (256 bins)');

%% Question 2.2.c
P3_new = histeq(P3,255); % function to perform histogram equalization
imwrite(P3_new, fullfile('results', 'mrt-train-hist-eq2.png'));

figure;
imhist(P3_new, 10); 
title('Histogram with double histogram equalization (10 bins)');

figure;
imhist(P3_new, 256);
title('Histogram with double histogram equalization (256 bins)');

function is_diff_img(img1, img2)
    diff_img = imabsdiff(img1, img2);   % absolute pixel differences
    figure;
    imshow(diff_img, []); % if it is all black, then it is the same
    title('Difference between images');

    equal = isequal(img1, img2);
    if equal
        disp("The images are same");
    else
        disp("The images are different");
    end
end

is_diff_img(P3, P3_new);

%% 2.3 Linear Spatial Filtering
%% Question 2.3.a

function [norm_filter, sigma] = create_and_display_filter(type, size, sigma)
    filter = fspecial(type, size, sigma); % create filter
    norm_filter = filter / sum(filter(:)); % normalization
    figure; % results
    mesh(norm_filter);
    title(sprintf('3D graph of %s filter (sigma = %.1f)', type, sigma));
end

[norm_filter1, sigma1] = create_and_display_filter('gaussian',[5,5],1); % create gaussian filter for sigma = 1
[norm_filter2, sigma2] = create_and_display_filter('gaussian',[5,5],2); % create gaussian filter for sigma = 2

%% Question 2.3.b

lib_gauss = imread('lib-gn.jpg');
figure;
imshow(lib_gauss);

%% Question 2.3.c

function filtered_image = apply_gauss_filter_to_image(image, filter, shape, sigma, noise_present)
    filtered_image = conv2(double(image), filter, shape);
    filtered_image = uint8(filtered_image);
    figure;
    imshow(filtered_image); 
    title(sprintf('Filtered (%s) Image with gaussian filter (sigma = %.1f)', noise_present, sigma)); 
end

gn_lib_gauss1 = apply_gauss_filter_to_image(lib_gauss, norm_filter1, 'same', sigma1, 'gn');
gn_lib_gauss2 = apply_gauss_filter_to_image(lib_gauss, norm_filter2, 'same', sigma2, 'gn');

imwrite(gn_lib_gauss1, fullfile('results', 'processed_gn_lib_gauss1.png'));
imwrite(gn_lib_gauss2, fullfile('results', 'processed_gn_lib_gauss2.png'));


%% Question 2.3.d

lib_spec = imread('lib-sp.jpg');
figure;
imshow(lib_spec);

%% Question 2.3.e

sp_lib_gauss1 = apply_gauss_filter_to_image(lib_spec, norm_filter1, 'same', sigma1, 'sp');
sp_lib_gauss2 = apply_gauss_filter_to_image(lib_spec, norm_filter2, 'same', sigma2, 'sp');

imwrite(sp_lib_gauss1, fullfile('results', 'processed_sp_lib_gauss1.png'));
imwrite(sp_lib_gauss2, fullfile('results', 'processed_sp_lib_gauss2.png'));


%% 2.4 Median Filtering
%% Question 2.4.a

% we don't need to construct filter, just use medfilt2() function

%% Question 2.4.b

% lib_gauss = imread('lib-gn.jpg'); 
figure;
imshow(lib_gauss);

%% Question 2.4.c

function filtered_image = apply_med_filter_to_image(image, n, noise_present)
    filtered_image = medfilt2(double(image), [n n]); % double() can be removed 
    filtered_image = uint8(filtered_image); % This line can be removed
    figure;
    imshow(filtered_image); 
    title(sprintf('Filtered (%s) Image with median filter (size = [%.1f %.1f])', noise_present,n ,n)); 
end

gn_lib_med_3_3 = apply_med_filter_to_image(lib_gauss, 3, 'gn');
gn_lib_med_5_5 = apply_med_filter_to_image(lib_gauss, 5, 'gn');

imwrite(gn_lib_med_3_3, fullfile('results', 'processed_gn_lib_med_3_3.png'));
imwrite(gn_lib_med_5_5, fullfile('results', 'processed_gn_lib_med_5_5.png'));

%% Question 2.4.d

% lib_spec = imread('lib-sp.jpg');
figure;
imshow(lib_spec);

%% Question 2.4.e

sp_lib_med_3_3 = apply_med_filter_to_image(lib_spec, 3, 'sp');
sp_lib_med_5_5 = apply_med_filter_to_image(lib_spec, 5, 'sp');

imwrite(sp_lib_med_3_3, fullfile('results', 'processed_sp_lib_med_3_3.png'));
imwrite(sp_lib_med_5_5, fullfile('results', 'processed_sp_lib_med_5_5.png'));


%% 2.5 Suppressing Noise Interference Patterns

%% Question 2.5.a

diagonal_lines_image = imread('pck-int.jpg');
if ndims(diagonal_lines_image) == 3 % convert to grayscale if it is rgb
    diagonal_lines_image = rgb2gray(diagonal_lines_image);
end
figure;
imshow(diagonal_lines_image);
title('Original diagonal lines image');

%% Question 2.5.b

function [dft, peak_x, peak_y] = create_power_spectrum_display_peak(image, fftshift_flag)
    % convert and create power spectrum
    double_image = double(image); 
    dft = fft2(double_image); % create discrere fourier transform of image
    spectrum = abs(dft).^2; % create power spectrum of image

    % display spectrum
    figure;
    if (fftshift_flag)
        imagesc(fftshift(spectrum.^0.1)); % with fftshift
    else
        imagesc(spectrum.^0.1); % without fftshift
    end
    title(sprintf('Power Spectrum of Interference Image (fftshift = %d)', fftshift_flag));
    colormap('default');

    % display peak
    [peak_x, peak_y] = ginput();
    fprintf('Selected %d peaks (fftshift = %d)\n', numel(peak_x), fftshift_flag);
    disp([peak_x(:) peak_y(:)]);
end

create_power_spectrum_display_peak(diagonal_lines_image, 1); % fftshift = true (don't return anything as it would not be used later)

%% Question 2.5.c

[dft, peak_x, peak_y] = create_power_spectrum_display_peak(diagonal_lines_image, 0); % fftshift = false

%% Question 2.5.d

function dft = modify_dft(window_size, dft, peak_x, peak_y)
    neighbourhood_size = floor(window_size/2);
    [height, width] = size(dft);
    iteration = numel(peak_x);
    for i = 1:iteration
        x_cor = round(peak_x(i)); % column
        y_cor = round(peak_y(i)); % row
    
        x_range = max(1, x_cor - neighbourhood_size) : min(width,  x_cor + neighbourhood_size);
        y_range = max(1, y_cor - neighbourhood_size) : min(height, y_cor + neighbourhood_size);
    
        dft(y_range, x_range) = 0;
    end
end

dft_filtered = dft; % make a copy
dft_filtered = modify_dft(5, dft_filtered, peak_x, peak_y);

%% Question 2.5.e

spectrum_filtered = abs(dft_filtered).^2; % create power spectrum of image
figure;
imagesc(fftshift(spectrum_filtered.^0.1)); 
title('Filtered Power Spectrum of Interference Image');
colormap('default');

filtered_diagonal_lines_image = ifft2(dft_filtered);
filtered_diagonal_lines_image = real(uint8(filtered_diagonal_lines_image));
figure;
imshow(filtered_diagonal_lines_image);
title('Filtered Interference Image');
imwrite(filtered_diagonal_lines_image, fullfile('results', 'fft_pck_int_5_5.png'));

%% Further improvements
% improvement 1: change the filter to bigger ones

[dft_improved, ~, ~] = create_power_spectrum_display_peak(diagonal_lines_image, 0);

% we try to fix the peak coordinates to some value by overwriting it (for fair comparison)
peak_x_improved = [9.405380333951761; 248.78200371057510];
peak_y_improved = [240.9222873900293; 17.954545454545411];

function image_improved = filter_image_with_window(dft, peak_x, peak_y, window_size)
    dft_filtered = modify_dft(window_size, dft, peak_x, peak_y);

    % Show filtered spectrum
    spectrum_filtered = abs(dft_filtered).^2;
    figure; 
    imagesc(fftshift(spectrum_filtered.^0.1));
    title(sprintf('Filtered Spectrum (window size = [%d %d])', window_size, window_size));
    colormap('default');
    
    % Inverse FFT to reconstruct image
    image_improved = ifft2(dft_filtered);
    image_improved = real(uint8(image_improved));
    figure;
    imshow(image_improved);
    title(sprintf('Filtered Image (window size = [%d %d])', window_size, window_size));
    imwrite(image_improved, fullfile('results', sprintf('fft_pck_int_%d_%d.png',[window_size, window_size])));
end

filter_image_with_window(dft_improved, peak_x_improved, peak_y_improved, 5);
filter_image_with_window(dft_improved, peak_x_improved, peak_y_improved, 7);
filter_image_with_window(dft_improved, peak_x_improved, peak_y_improved, 9);
filter_image_with_window(dft_improved, peak_x_improved, peak_y_improved, 11);

%% Question 2.5.f
% improvement 1: change the filter to bigger ones
% improvement 2: more than 2 points

diagonal_lines_image = imread('primate-caged.jpg');
if ndims(diagonal_lines_image) == 3 % convert to grayscale if it is rgb
    diagonal_lines_image = rgb2gray(diagonal_lines_image);
end
figure;
imshow(diagonal_lines_image);
title('Original diagonal lines image');

[dft, peak_x, peak_y] = create_power_spectrum_display_peak(diagonal_lines_image, 0);
dft_filtered = modify_dft(5, dft, peak_x, peak_y);

spectrum_filtered = abs(dft_filtered).^2; % create power spectrum of image
figure;
imagesc(fftshift(spectrum_filtered.^0.1)); 
title('Filtered Power Spectrum of Interference Image');
colormap('default');

filtered_diagonal_lines_image = ifft2(dft_filtered);
filtered_diagonal_lines_image = real(uint8(filtered_diagonal_lines_image));
figure;
imshow(filtered_diagonal_lines_image);
title('Filtered Interference Image');
imwrite(filtered_diagonal_lines_image, fullfile('results', 'fft_primate_caged_5_5.png'));

%% 7x7
diagonal_lines_image = imread('primate-caged.jpg');
if ndims(diagonal_lines_image) == 3 % convert to grayscale if it is rgb
    diagonal_lines_image = rgb2gray(diagonal_lines_image);
end
figure;
imshow(diagonal_lines_image);
title('Original diagonal lines image');

[dft, peak_x, peak_y] = create_power_spectrum_display_peak(diagonal_lines_image, 0);
dft_filtered = modify_dft(7, dft, peak_x, peak_y);

spectrum_filtered = abs(dft_filtered).^2; % create power spectrum of image
figure;
imagesc(fftshift(spectrum_filtered.^0.1)); 
title('Filtered Power Spectrum of Interference Image');
colormap('default');

filtered_diagonal_lines_image = ifft2(dft_filtered);
filtered_diagonal_lines_image = real(uint8(filtered_diagonal_lines_image));
figure;
imshow(filtered_diagonal_lines_image);
title('Filtered Interference Image');
imwrite(filtered_diagonal_lines_image, fullfile('results', 'fft_primate_caged_7_7.png'));

%% 2.6 Suppressing Noise Interference Patterns

%% Question 2.6.a

P = imread('book.jpg');
figure;
imshow(P);
title("Original image of slanted book");

%% Question 2.6.b

[X, Y] = ginput(4);
corner_sequence = ["Top Left", "Top Right", "Bottom Right", "Bottom Left"];

fprintf('Selected corners:\n');
for i = 1:4
    fprintf('%s corner: (%.2f, %.2f)\n', corner_sequence(i), X(i), Y(i));
end

x = [0, 210, 210, 0];
y = [0, 0, 297, 297];

fprintf('\nDesired corners:\n');
for i = 1:4
    fprintf('%s corner: (%d, %d)\n', corner_sequence(i), x(i), y(i));
end

%% Question 2.6.c

% set up matrices
n = 4;
A = zeros(2*n, 8);   
v = zeros(2*n, 1);  

for i = 1:n
    v(2*i-1:2*i) = [x(i); y(i)];
    A(2*i-1, :) = [X(i), Y(i), 1, 0, 0, 0, -x(i)*X(i), -x(i)*Y(i)];
    A(2*i, :)   = [0, 0, 0, X(i), Y(i), 1, -y(i)*X(i), -y(i)*Y(i)];
end

u = A \ v;
U = reshape([u;1], 3, 3)';

% to check if we get back the desired coordinates in 3x4 matrix form
w = U*[X'; Y'; ones(1,4)];
w = w ./ (ones(3,1) * w(3,:));
disp(w)



%% Question 2.6.d

T = maketform('projective', U');
P2 = imtransform(P, T, 'XData', [0 210], 'YData', [0 297]);

%% Question 2.6.e

figure;
imshow(P2);
title("Transformed image of slanted book")

%% Question 2.6.f
% detect pink region by defining the largest pink blob as the target
% pink region is detected using default HSV range
hsvImg = rgb2hsv(P2);

% extract HSV channels
H = hsvImg(:,:,1); % hue
S = hsvImg(:,:,2); % saturation
V = hsvImg(:,:,3); % value

% default pink HSV range
pinkMask = (H > 0.9 | H < 0.05) & S > 0.3 & V > 0.5; 

% target
figure;
imshow(pinkMask);
title("Mask for pink region");
pinkMask = bwareafilt(pinkMask, 1);
figure;
imshow(pinkMask);
title("Mask for cleaned region");

% display
props = regionprops(pinkMask, 'BoundingBox');
figure;
imshow(P2); hold on;
rectangle('Position', props.BoundingBox, 'EdgeColor','g', 'LineWidth', 2);
title("Original image with pink region bounded");
hold off;

%-------------------------------------------------------------------------%
%% 2.7 Code Two Perceptrons
