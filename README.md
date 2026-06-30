# L-AVRBench

L-AVRBench is a reproducible benchmark for evaluating vulnerability patches, built on top of real-world vulnerable software samples. Each benchmark sample ships with a containerized build environment so that a candidate patch can be compiled and validated through both **security testing** (does it actually fix the vulnerability) and **functionality testing** (does it preserve correct behavior).

## Overview

For each sample, L-AVRBench provides:

- A Docker image containing the vulnerable project pinned to the affected commit/version
- A standard workflow to apply a patch, rebuild the project, and run validation tests
- A security test suite (`sec_test.sh`) that checks whether the vulnerability is resolved
- A functionality test suite (`func_test.sh`) that checks whether existing behavior still works

## Getting Started

### 1. Clone the repository

```shell
git clone https://github.com/rimwoohan/L-AVRBench.git
cd L-AVRBench
```

### 2. Add your patch(es)

Each sample has its own directory, identified by its **Sample ID** (e.g. `LB63`). Place the patch(es) you want to evaluate under that sample's `patches/` directory, then update the `PATCH_DIR` variable in `test_all.sh` to point to it.

```shell
cd <SAMPLE_ID>          # e.g. cd LB63
# add patch files under <SAMPLE_ID>/patches/
# then edit test_all.sh and set PATCH_DIR accordingly
```

### 3. Pull and run the Docker environment

```shell
docker pull rimwoohan/lavrbench:<sample_id>          # e.g. lb63
docker run -it --rm --name <sample_id> -v "$(pwd)":/out rimwoohan/lavrbench:<sample_id> bash
```

> Docker tags are lowercase. For example, sample `LB63` corresponds to tag `lb63`.

### 4. Run the test pipeline

From inside the container:

```shell
/out/test_all.sh
```

`test_all.sh` runs the following steps in order:

1. **Apply patch** — applies the patch(es) found in `PATCH_DIR`
2. **Compile** (`compile.sh`) — builds the project with the patch applied
3. **Security test** (`sec_test.sh`) — verifies the original vulnerability no longer reproduces
4. **Functionality test** (`func_test.sh`) — verifies the project's existing behavior is unaffected

## Repository Structure

```
L-AVRBench/
├── LB63/
│   ├── patches/        # place candidate patches here
│   ├── compile.sh
│   ├── sec_test.sh
│   ├── func_test.sh
│   └── test_all.sh    # PATCH_DIR is set here
├── ...                # additional samples (LBxx)
├── Magma_samples/
└── README.md
```

## Benchmark Samples

L-AVRBench currently includes 70 samples spanning 17 open-source C/C++ projects. Each row corresponds to one sample directory (`LBxx/`).


## Magma Samples

Some L-AVRBench samples are derived from the Magma benchmark. We are currently preparing Docker images for these samples so that they can be evaluated through the same standardized workflow used for the hand-mined samples.

Until those Docker images are available, please follow the instructions provided in the corresponding Magma sample directories to build, run, and validate patches.

<details>
<summary>Click to expand full sample list</summary>

| Program | Description | ID | CVE | CWE ID | Original ID |
|---|---|---|---|---|---|
| Libpng | C library for reading and writing PNG image files. | LB1 | CVE-2018-13785 | CWE-369, CWE-190 | PNG001 |
| Libtiff | C library for processing TIFF files. | LB2 | CVE-2016-5314 | CWE-787 | TIF002 |
| Libtiff | C library for processing TIFF files. | LB3 | CVE-2016-10269 | CWE-125 | TIF005 |
| Libtiff | C library for processing TIFF files. | LB4 | CVE-2016-10269 | CWE-125 | TIF006 |
| Libtiff | C library for processing TIFF files. | LB5 | CVE-2015-8784 | CWE-787 | TIF008 |
| Libtiff | C library for processing TIFF files. | LB6 | CVE-2019-7663 | - | TIF009 |
| Libtiff | C library for processing TIFF files. | LB7 | CVE-2017-11613 | CWE-20 | TIF014 |
| Libtiff | C library for processing TIFF files. | LB8 | CVE-2016-9273 | CWE-125 | EF05 |
| Libtiff | C library for processing TIFF files. | LB9 | CVE-2016-5321 | CWE-119 | EF01 |
| Libtiff | C library for processing TIFF files. | LB10 | CVE-2014-8128 | CWE-787 | EF02-1 |
| Libtiff | C library for processing TIFF files. | LB11 | CVE-2014-8128 | CWE-787 | EF02-2 |
| Libtiff | C library for processing TIFF files. | LB12 | CVE-2016-10094 | CWE-189 | EF07 |
| Libtiff | C library for processing TIFF files. | LB13 | CVE-2017-7601 | CWE-20 | EF08 |
| Libtiff | C library for processing TIFF files. | LB14 | CVE-2016-3623 | CWE-369 | EF09 |
| Libtiff | C library for processing TIFF files. | LB15 | CVE-2017-7595 | CWE-369 | EF10 |
| Libtiff | C library for processing TIFF files. | LB16 | CVE-2015-8668 | CWE-787 | - |
| Libtiff | C library for processing TIFF files. | LB17 | CVE-2016-10092 | CWE-119 | - |
| Libxml2 | XML C parser and toolkit. | LB18 | CVE-2017-9047 | CWE-119 | XML001 |
| Libxml2 | XML C parser and toolkit. | LB19 | CVE-2017-7375 | CWE-611 | XML003 |
| Libxml2 | XML C parser and toolkit. | LB20 | CVE-2016-1762 | CWE-119 | XML017 |
| Libxml2 | XML C parser and toolkit. | LB21 | CVE-2016-1839 | CWE-125 | EF16 |
| Libxml2 | XML C parser and toolkit. | LB22 | CVE-2016-1838 | CWE-125 | EF15 |
| Libxml2 | XML C parser and toolkit. | LB23 | CVE-2012-5134 | CWE-119 | EF17 |
| Libxml2 | XML C parser and toolkit. | LB24 | CVE-2017-5969 | CWE-476 | EF18 |
| Libxml2 | XML C parser and toolkit. | LB25 | CVE-2017-0663 | CWE-787 | - |
| Libxml2 | XML C parser and toolkit. | LB26 | CVE-2025-24928 | CWE-121 | - |
| Libxml2 | XML C parser and toolkit. | LB27 | CVE-2025-32415 | CWE-125, CWE-1284 | - |
| Poppler | C++ project for rendering and manipulating PDF files. | LB28 | CVE-2019-12293 | CWE-125 | PDF005 |
| Poppler | C++ project for rendering and manipulating PDF files. | LB29 | Bug #106061 | - | PDF008 |
| Poppler | C++ project for rendering and manipulating PDF files. | LB30 | Bug #101366 | - | PDF010 |
| Poppler | C++ project for rendering and manipulating PDF files. | LB31 | CVE-2019-7310 | CWE-681, CWE-125 | PDF011 |
| Poppler | C++ project for rendering and manipulating PDF files. | LB32 | CVE-2018-13988 | CWE-125 | PDF016 |
| Poppler | C++ project for rendering and manipulating PDF files. | LB33 | CVE-2018-10768 | CWE-476 | PDF018 |
| Poppler | C++ project for rendering and manipulating PDF files. | LB34 | CVE-2017-14617 | CWE-20 | PDF021 |
| curl | command-line tool and library for transferring data using URLs | LB35 | CVE-2018-1000301 | CWE-126 | - |
| libxslt | C library for transforming XML documents using XSLT | LB36 | CVE-2019-18197 | CWE-416, CWE-908 | - |
| OpenSSL | C library for implementing secure communication protocols | LB37 | CVE-2016-6309 | CWE-416 | SSL002 |
| OpenSSL | C library for implementing secure communication protocols | LB38 | CVE-2017-3735 | CWE-119 | SSL009 |
| OpenSSL | C library for implementing secure communication protocols | LB39 | CVE-2016-6302 | CWE-20 | SSL020 |
| OpenSSL | C library for implementing secure communication protocols | LB40 | CVE-2016-7054 | CWE-284 | - |
| SQLite | C library that implements a lightweight, self-contained, and serverless SQL database engine. | LB41 | CVE-2019-20218 | CWE-755, NVD-CWE-Other | SQL002 |
| SQLite | C library that implements a lightweight, self-contained, and serverless SQL database engine. | LB42 | CVE-2013-7443 | CWE-119 | SQL013 |
| SQLite | C library that implements a lightweight, self-contained, and serverless SQL database engine. | LB43 | CVE-2019-19926 | CWE-476 | SQL014 |
| libsndfile | C library for reading and writing various audio file formats | LB44 | CVE-2011-2696 | CWE-119 | SND001 |
| libsndfile | C library for reading and writing various audio file formats | LB45 | CVE-2017-6892 | CWE-119 | SND005 |
| libsndfile | C library for reading and writing various audio file formats | LB46 | commit a8ab5b3 | - | SND017 |
| libsndfile | C library for reading and writing various audio file formats | LB47 | commit a8ab5b3 | - | SND020 |
| Binutils | binary tools for processing object files, libraries, and executables | LB48 | CVE-2018-10372 | CWE-125 | EF12 |
| Binutils | binary tools for processing object files, libraries, and executables | LB49 | CVE-2017-15025 | CWE-369 | EF13 |
| Binutils | binary tools for processing object files, libraries, and executables | LB50 | CVE-2017-9041 | CWE-125 | - |
| Binutils | binary tools for processing object files, libraries, and executables | LB51 | CVE-2020-16590 | CWE-415 | - |
| Libjpeg-turbo | C library for manipulating JPEG files. | LB52 | CVE-2018-19664 | CWE-125 | EF20 |
| Libjpeg-turbo | C library for manipulating JPEG files. | LB53 | CVE-2012-2806 | CWE-787 | EF22 |
| ffmpeg | tools and libraries for processing audio and video files | LB54 | CVE-2024-36615 | CWE-362 | - |
| graphicsmagick | tools and libraries for processing and manipulating image files | LB55 | CVE-2017-8350 | CWE-772 | - |
| graphicsmagick | tools and libraries for processing and manipulating image files | LB56 | CVE-2017-18271 | CWE-835 | - |
| graphicsmagick | tools and libraries for processing and manipulating image files | LB57 | CVE-2018-5685 | CWE-835 | - |
| graphicsmagick | tools and libraries for processing and manipulating image files | LB58 | CVE-2018-20189 | CWE-20 | - |
| graphicsmagick | tools and libraries for processing and manipulating image files | LB59 | CVE-2019-11010 | CWE-401 | - |
| graphicsmagick | tools and libraries for processing and manipulating image files | LB60 | CVE-2019-12921 | CWE-77 | - |
| graphicsmagick | tools and libraries for processing and manipulating image files | LB61 | CVE-2025-27795 | CWE-770 | - |
| Imagemagick | software suite for creating, editing, converting, and manipulating images | LB62 | CVE-2017-9501 | CWE-617 | - |
| Imagemagick | software suite for creating, editing, converting, and manipulating images | LB63 | CVE-2017-12140 | CWE-400, CWE-681 | - |
| Imagemagick | software suite for creating, editing, converting, and manipulating images | LB64 | CVE-2017-12643 | CWE-770 | - |
| Imagemagick | software suite for creating, editing, converting, and manipulating images | LB65 | CVE-2017-12665 | CWE-772 | - |
| Imagemagick | software suite for creating, editing, converting, and manipulating images | LB66 | CVE-2017-14342 | CWE-400 | - |
| Imagemagick | software suite for creating, editing, converting, and manipulating images | LB67 | CVE-2017-14533 | CWE-772 | - |
| Imagemagick | software suite for creating, editing, converting, and manipulating images | LB68 | CVE-2017-18272 | CWE-416 | - |
| jq | command-line tool for parsing and processing JSON data | LB69 | CVE-2023-50246 | CWE-120 | - |
| jq | command-line tool for parsing and processing JSON data | LB70 | CVE-2023-50268 | CWE-120 | - |

</details>

## References

[1] Google OSS-Fuzz. https://github.com/google/oss-fuzz
[2] ARVO: Atlas of Reproducible Vulnerabilities. https://github.com/n132/ARVO-Meta

## Citation

If you use L-AVRBench in your research, please cite this repository.