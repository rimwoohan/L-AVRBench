# patching-bench

## USAGE

### 1. Build AFL

```shell
cd afl_asan
./build_afl.sh
```

### 2. Test Target

```shell
# e.g. libsndfile
cd targets/libsndfile
./fetch.sh
./apply_vulnerability.sh
sudo apt-get install tcl-dev
export C_INCLUDE_PATH=/usr/include/tcl8.6/

# After executing apply_vulnerability.sh, patches directory is created
# 
# patches
# |-- SND001
# |-- SND005
# |-- SND017
# `-- SND020

# Position each patch corresponding to the associated vulnerability 
# (e.g., patches generated for vulnerability SND001 should be placed under SND001)

export ASAN_OPTIONS=detect_leaks=0

./do_whole_stest.sh  # do security test
./do_whole_stest.sh  # do functionality test

./log_whole_stest.sh # make result as a file
./log_whole_ftest.sh # make result as a file
```

### scripts

* `fetch.sh` : install prerequisite, clone project, and build project
* `apply_vulnerability.sh` : insert vulnerability to cloned project
* `do_stest.sh` : do security test for specific vulnerability (e.g. `do_stest.sh SND001`)
* `do_ftest.sh` :  do functionality test for specific vulnerability (e.g. `do_ftest.sh SND001`)
* `do_whole_stest.sh` :  do security test for whole vulnerability
* `do_whole_ftest.sh` :  do functionality test for whole vulnerability
* `print_stest_result.sh` :  print security test result for specific vulnerability (e.g. `print_stest_result.sh SND001`)
* `print_ftest_result.sh` :  print functionality test result for specific vulnerability (e.g. `print_ftest_result.sh SND001`)
* `print_whole_result.sh` :  print functionality & security test results for specific vulnerability (e.g. `print_ftest_result.sh SND001`)
* `log_whole_stest.sh` : record security test results for all vulnerabilities to a file
* `log_whole_ftest.sh` :  record functionality test results for all vulnerabilities to a file
* `log_whole_once.sh` :  record functionality & security test results for all vulnerabilities to a file
* `remove_all.sh` :  delete all generated files (in this case, you will need to start over from fetch)
* `remove_test_result_all.sh` :  delete all test results

### for all scenarios
* `do_all.sh` :  do all security & functionality tests for all scenarios in the targets directory
* `do_all_prepare.sh` :  do all setup steps for all scenarios in the targets directory (e.g. `fetch.sh` & `apply_vulnerability.sh`)
* `remove_all_patches.sh` :  delete all *.patch files in all patches directories
* `remove_all_results.sh` :  delete all test results files for all scenarios in the targets directory