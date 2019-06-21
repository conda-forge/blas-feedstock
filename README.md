About blas-split
================

Home: https://github.com/conda-forge/blas-feedstock

Package license: BSD 3-clause

Feedstock license: BSD 3-Clause

Summary: Metapackage to select the BLAS variant. Use conda's pinning mechanism in your environment to control which variant you want.



Current build status
====================


<table><tr>
    <td>Travis</td>
    <td>
      <a href="https://travis-ci.org/conda-forge/blas-feedstock">
        <img alt="macOS" src="https://img.shields.io/travis/conda-forge/blas-feedstock/master.svg?label=macOS">
      </a>
    </td>
  </tr><tr>
    <td>Appveyor</td>
    <td>
      <a href="https://ci.appveyor.com/project/conda-forge/blas-feedstock/branch/master">
        <img alt="windows" src="https://img.shields.io/appveyor/ci/conda-forge/blas-feedstock/master.svg?label=Windows">
      </a>
    </td>
  </tr>
    
  <tr>
    <td>Azure</td>
    <td>
      <details>
        <summary>
          <a href="https://dev.azure.com/conda-forge/feedstock-builds/_build/latest?definitionId=3701&branchName=master">
            <img src="https://dev.azure.com/conda-forge/feedstock-builds/_apis/build/status/blas-feedstock?branchName=master">
          </a>
        </summary>
        <table>
          <thead><tr><th>Variant</th><th>Status</th></tr></thead>
          <tbody><tr>
              <td>linux_aarch64</td>
              <td>
                <a href="https://dev.azure.com/conda-forge/feedstock-builds/_build/latest?definitionId=3701&branchName=master">
                  <img src="https://dev.azure.com/conda-forge/feedstock-builds/_apis/build/status/blas-feedstock?branchName=master&jobName=linux&configuration=linux_aarch64_" alt="variant">
                </a>
              </td>
            </tr><tr>
              <td>linux_blas_implblisblas_impl_libblis</td>
              <td>
                <a href="https://dev.azure.com/conda-forge/feedstock-builds/_build/latest?definitionId=3701&branchName=master">
                  <img src="https://dev.azure.com/conda-forge/feedstock-builds/_apis/build/status/blas-feedstock?branchName=master&jobName=linux&configuration=linux_blas_implblisblas_impl_libblis" alt="variant">
                </a>
              </td>
            </tr><tr>
              <td>linux_blas_implmklblas_impl_libmkl_rt</td>
              <td>
                <a href="https://dev.azure.com/conda-forge/feedstock-builds/_build/latest?definitionId=3701&branchName=master">
                  <img src="https://dev.azure.com/conda-forge/feedstock-builds/_apis/build/status/blas-feedstock?branchName=master&jobName=linux&configuration=linux_blas_implmklblas_impl_libmkl_rt" alt="variant">
                </a>
              </td>
            </tr><tr>
              <td>linux_blas_implopenblasblas_impl_libopenblas</td>
              <td>
                <a href="https://dev.azure.com/conda-forge/feedstock-builds/_build/latest?definitionId=3701&branchName=master">
                  <img src="https://dev.azure.com/conda-forge/feedstock-builds/_apis/build/status/blas-feedstock?branchName=master&jobName=linux&configuration=linux_blas_implopenblasblas_impl_libopenblas" alt="variant">
                </a>
              </td>
            </tr><tr>
              <td>linux_ppc64le</td>
              <td>
                <a href="https://dev.azure.com/conda-forge/feedstock-builds/_build/latest?definitionId=3701&branchName=master">
                  <img src="https://dev.azure.com/conda-forge/feedstock-builds/_apis/build/status/blas-feedstock?branchName=master&jobName=linux&configuration=linux_ppc64le_" alt="variant">
                </a>
              </td>
            </tr><tr>
              <td>osx_blas_implblisblas_impl_libblis</td>
              <td>
                <a href="https://dev.azure.com/conda-forge/feedstock-builds/_build/latest?definitionId=3701&branchName=master">
                  <img src="https://dev.azure.com/conda-forge/feedstock-builds/_apis/build/status/blas-feedstock?branchName=master&jobName=osx&configuration=osx_blas_implblisblas_impl_libblis" alt="variant">
                </a>
              </td>
            </tr><tr>
              <td>osx_blas_implmklblas_impl_libmkl_rt</td>
              <td>
                <a href="https://dev.azure.com/conda-forge/feedstock-builds/_build/latest?definitionId=3701&branchName=master">
                  <img src="https://dev.azure.com/conda-forge/feedstock-builds/_apis/build/status/blas-feedstock?branchName=master&jobName=osx&configuration=osx_blas_implmklblas_impl_libmkl_rt" alt="variant">
                </a>
              </td>
            </tr><tr>
              <td>osx_blas_implopenblasblas_impl_libopenblas</td>
              <td>
                <a href="https://dev.azure.com/conda-forge/feedstock-builds/_build/latest?definitionId=3701&branchName=master">
                  <img src="https://dev.azure.com/conda-forge/feedstock-builds/_apis/build/status/blas-feedstock?branchName=master&jobName=osx&configuration=osx_blas_implopenblasblas_impl_libopenblas" alt="variant">
                </a>
              </td>
            </tr><tr>
              <td>win_blas_implblisblas_impl_liblibblis.2</td>
              <td>
                <a href="https://dev.azure.com/conda-forge/feedstock-builds/_build/latest?definitionId=3701&branchName=master">
                  <img src="https://dev.azure.com/conda-forge/feedstock-builds/_apis/build/status/blas-feedstock?branchName=master&jobName=win&configuration=win_blas_implblisblas_impl_liblibblis.2" alt="variant">
                </a>
              </td>
            </tr><tr>
              <td>win_blas_implmklblas_impl_libmkl_rt</td>
              <td>
                <a href="https://dev.azure.com/conda-forge/feedstock-builds/_build/latest?definitionId=3701&branchName=master">
                  <img src="https://dev.azure.com/conda-forge/feedstock-builds/_apis/build/status/blas-feedstock?branchName=master&jobName=win&configuration=win_blas_implmklblas_impl_libmkl_rt" alt="variant">
                </a>
              </td>
            </tr><tr>
              <td>win_blas_implopenblasblas_impl_libopenblas</td>
              <td>
                <a href="https://dev.azure.com/conda-forge/feedstock-builds/_build/latest?definitionId=3701&branchName=master">
                  <img src="https://dev.azure.com/conda-forge/feedstock-builds/_apis/build/status/blas-feedstock?branchName=master&jobName=win&configuration=win_blas_implopenblasblas_impl_libopenblas" alt="variant">
                </a>
              </td>
            </tr>
          </tbody>
        </table>
      </details>
    </td>
  </tr>
</table>

Current release info
====================

| Name | Downloads | Version | Platforms |
| --- | --- | --- | --- |
| [![Conda Recipe](https://img.shields.io/badge/recipe-blas-green.svg)](https://anaconda.org/conda-forge/blas) | [![Conda Downloads](https://img.shields.io/conda/dn/conda-forge/blas.svg)](https://anaconda.org/conda-forge/blas) | [![Conda Version](https://img.shields.io/conda/vn/conda-forge/blas.svg)](https://anaconda.org/conda-forge/blas) | [![Conda Platforms](https://img.shields.io/conda/pn/conda-forge/blas.svg)](https://anaconda.org/conda-forge/blas) |
| [![Conda Recipe](https://img.shields.io/badge/recipe-libblas-green.svg)](https://anaconda.org/conda-forge/libblas) | [![Conda Downloads](https://img.shields.io/conda/dn/conda-forge/libblas.svg)](https://anaconda.org/conda-forge/libblas) | [![Conda Version](https://img.shields.io/conda/vn/conda-forge/libblas.svg)](https://anaconda.org/conda-forge/libblas) | [![Conda Platforms](https://img.shields.io/conda/pn/conda-forge/libblas.svg)](https://anaconda.org/conda-forge/libblas) |
| [![Conda Recipe](https://img.shields.io/badge/recipe-libcblas-green.svg)](https://anaconda.org/conda-forge/libcblas) | [![Conda Downloads](https://img.shields.io/conda/dn/conda-forge/libcblas.svg)](https://anaconda.org/conda-forge/libcblas) | [![Conda Version](https://img.shields.io/conda/vn/conda-forge/libcblas.svg)](https://anaconda.org/conda-forge/libcblas) | [![Conda Platforms](https://img.shields.io/conda/pn/conda-forge/libcblas.svg)](https://anaconda.org/conda-forge/libcblas) |
| [![Conda Recipe](https://img.shields.io/badge/recipe-liblapack-green.svg)](https://anaconda.org/conda-forge/liblapack) | [![Conda Downloads](https://img.shields.io/conda/dn/conda-forge/liblapack.svg)](https://anaconda.org/conda-forge/liblapack) | [![Conda Version](https://img.shields.io/conda/vn/conda-forge/liblapack.svg)](https://anaconda.org/conda-forge/liblapack) | [![Conda Platforms](https://img.shields.io/conda/pn/conda-forge/liblapack.svg)](https://anaconda.org/conda-forge/liblapack) |
| [![Conda Recipe](https://img.shields.io/badge/recipe-liblapacke-green.svg)](https://anaconda.org/conda-forge/liblapacke) | [![Conda Downloads](https://img.shields.io/conda/dn/conda-forge/liblapacke.svg)](https://anaconda.org/conda-forge/liblapacke) | [![Conda Version](https://img.shields.io/conda/vn/conda-forge/liblapacke.svg)](https://anaconda.org/conda-forge/liblapacke) | [![Conda Platforms](https://img.shields.io/conda/pn/conda-forge/liblapacke.svg)](https://anaconda.org/conda-forge/liblapacke) |

Installing blas-split
=====================

Installing `blas-split` from the `conda-forge` channel can be achieved by adding `conda-forge` to your channels with:

```
conda config --add channels conda-forge
```

Once the `conda-forge` channel has been enabled, `blas, libblas, libcblas, liblapack, liblapacke` can be installed with:

```
conda install blas libblas libcblas liblapack liblapacke
```

It is possible to list all of the versions of `blas` available on your platform with:

```
conda search blas --channel conda-forge
```


About conda-forge
=================

[![Powered by NumFOCUS](https://img.shields.io/badge/powered%20by-NumFOCUS-orange.svg?style=flat&colorA=E1523D&colorB=007D8A)](http://numfocus.org)

conda-forge is a community-led conda channel of installable packages.
In order to provide high-quality builds, the process has been automated into the
conda-forge GitHub organization. The conda-forge organization contains one repository
for each of the installable packages. Such a repository is known as a *feedstock*.

A feedstock is made up of a conda recipe (the instructions on what and how to build
the package) and the necessary configurations for automatic building using freely
available continuous integration services. Thanks to the awesome service provided by
[CircleCI](https://circleci.com/), [AppVeyor](https://www.appveyor.com/)
and [TravisCI](https://travis-ci.org/) it is possible to build and upload installable
packages to the [conda-forge](https://anaconda.org/conda-forge)
[Anaconda-Cloud](https://anaconda.org/) channel for Linux, Windows and OSX respectively.

To manage the continuous integration and simplify feedstock maintenance
[conda-smithy](https://github.com/conda-forge/conda-smithy) has been developed.
Using the ``conda-forge.yml`` within this repository, it is possible to re-render all of
this feedstock's supporting files (e.g. the CI configuration files) with ``conda smithy rerender``.

For more information please check the [conda-forge documentation](https://conda-forge.org/docs/).

Terminology
===========

**feedstock** - the conda recipe (raw material), supporting scripts and CI configuration.

**conda-smithy** - the tool which helps orchestrate the feedstock.
                   Its primary use is in the construction of the CI ``.yml`` files
                   and simplify the management of *many* feedstocks.

**conda-forge** - the place where the feedstock and smithy live and work to
                  produce the finished article (built conda distributions)


Updating blas-split-feedstock
=============================

If you would like to improve the blas-split recipe or build a new
package version, please fork this repository and submit a PR. Upon submission,
your changes will be run on the appropriate platforms to give the reviewer an
opportunity to confirm that the changes result in a successful build. Once
merged, the recipe will be re-built and uploaded automatically to the
`conda-forge` channel, whereupon the built conda packages will be available for
everybody to install and use from the `conda-forge` channel.
Note that all branches in the conda-forge/blas-split-feedstock are
immediately built and any created packages are uploaded, so PRs should be based
on branches in forks and branches in the main repository should only be used to
build distinct package versions.

In order to produce a uniquely identifiable distribution:
 * If the version of a package **is not** being increased, please add or increase
   the [``build/number``](https://conda.io/docs/user-guide/tasks/build-packages/define-metadata.html#build-number-and-string).
 * If the version of a package **is** being increased, please remember to return
   the [``build/number``](https://conda.io/docs/user-guide/tasks/build-packages/define-metadata.html#build-number-and-string)
   back to 0.

Feedstock Maintainers
=====================

* [@isuruf](https://github.com/isuruf/)
* [@jakirkham](https://github.com/jakirkham/)
* [@pelson](https://github.com/pelson/)

