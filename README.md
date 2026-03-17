# fiji-connexin-puncta-quantification
DOI: 10.5281/zenodo.19067481
# Connexin puncta quantification macro for Fiji

Macro for quantification of connexin (Cx) puncta in fluorescence microscopy images using Fiji (ImageJ).

Author: Victoria Falco

## Description

This macro performs automated detection and quantification of connexin puncta in fluorescence microscopy images.

The workflow includes:

- selection of the connexin fluorescence channel
- optional restriction to reporter-positive regions
- automatic puncta detection using the Find Maxima function
- export of puncta counts

The macro is designed to facilitate reproducible analysis of connexin puncta distribution in microscopy datasets.

## Requirements

Fiji (ImageJ distribution)

https://fiji.sc/

## Usage

Open the macro in Fiji:

Plugins → Macros → Run

Select the image file and follow the prompts.

## Output

The macro generates:

- puncta detection stack
- text file containing puncta counts
- optional ROI measurements

All files are saved in the same directory as the input image.

## Version

v1.0 – Initial release

## Citation

If you use this macro please cite:

Falco V. (2026)  
Connexin puncta quantification macro for Fiji  
https://doi.org/XXXXX

## License

MIT License
