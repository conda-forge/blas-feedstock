// Some CBLAS functions that we need.

void cblas_cdotc_sub(const int *, const float _Complex *, const int*, const float _Complex *, const int *, float _Complex *);
void cblas_cdotu_sub(const int *, const float _Complex *, const int*, const float _Complex *, const int *, float _Complex *);
void cblas_zdotc_sub(const int *, const double _Complex *, const int*, const double _Complex *, const int *, double _Complex *);
void cblas_zdotu_sub(const int *, const double _Complex *, const int*, const double _Complex *, const int *, double _Complex *);

// These are the only 4 functions that are incompatible
// signature of cdotc is
//
// void cdotu_(__LAPACK_float_complex * _Nonnull ret_val, const __LAPACK_int * _Nonnull N,
//             const __LAPACK_float_complex * _Nullable X, const __LAPACK_int * _Nonnull INCX,
//             const __LAPACK_float_complex * _Nullable Y, const __LAPACK_int * _Nonnull INCY)
//
// Note that there is no return value and we need to pass a pointer to the result as the first argument

float _Complex cdotc_(const int *N, const float _Complex *X, const int *incX, const float _Complex *Y, const int *incY)
{
    float _Complex ret;
    cblas_cdotc_sub(N, X, incX, Y, incY, &ret);
    return ret;
}

float _Complex cdotu_(const int *N, const float _Complex *X, const int *incX, const float _Complex *Y, const int *incY)
{
    float _Complex ret;
    cblas_cdotu_sub(N, X, incX, Y, incY, &ret);
    return ret;
}

double _Complex zdotc_(const int *N, const double _Complex *X, const int *incX, const double _Complex *Y, const int *incY)
{
    double _Complex ret;
    cblas_zdotc_sub(N, X, incX, Y, incY, &ret);
    return ret;
}

double _Complex zdotu_(const int *N, const double _Complex *X, const int *incX, const double _Complex *Y, const int *incY)
{
    double _Complex ret;
    cblas_zdotu_sub(N, X, incX, Y, incY, &ret);
    return ret;
}
