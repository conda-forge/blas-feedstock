// Some CBLAS functions that we need.

void cblas_cdotc_sub$NEWLAPACK(const int *, const float _Complex *, const int*, const float _Complex *, const int *, float _Complex *);
void cblas_cdotu_sub$NEWLAPACK(const int *, const float _Complex *, const int*, const float _Complex *, const int *, float _Complex *);
void cblas_zdotc_sub$NEWLAPACK(const int *, const double _Complex *, const int*, const double _Complex *, const int *, double _Complex *);
void cblas_zdotu_sub$NEWLAPACK(const int *, const double _Complex *, const int*, const double _Complex *, const int *, double _Complex *);
void dladiv$NEWLAPACK(double *, double *, double *, double *, double *, double *);
void sladiv$NEWLAPACK(float *, float *, float *, float *, float *, float *);

// These are the only 6 functions that are incompatible
// signature of cdotc is
//
// void cdotu_(__LAPACK_float_complex * _Nonnull ret_val, const __LAPACK_int * _Nonnull N,
//             const __LAPACK_float_complex * _Nullable X, const __LAPACK_int * _Nonnull INCX,
//             const __LAPACK_float_complex * _Nullable Y, const __LAPACK_int * _Nonnull INCY)
//
// Note that there is no return value and we need to pass a pointer to the result as the first argument

float _Complex cdotc(const int *N, const float _Complex *X, const int *incX, const float _Complex *Y, const int *incY)
{
    float _Complex ret;
    cblas_cdotc_sub$NEWLAPACK(N, X, incX, Y, incY, &ret);
    return ret;
}

float _Complex cdotu(const int *N, const float _Complex *X, const int *incX, const float _Complex *Y, const int *incY)
{
    float _Complex ret;
    cblas_cdotu_sub$NEWLAPACK(N, X, incX, Y, incY, &ret);
    return ret;
}

double _Complex zdotc(const int *N, const double _Complex *X, const int *incX, const double _Complex *Y, const int *incY)
{
    double _Complex ret;
    cblas_zdotc_sub$NEWLAPACK(N, X, incX, Y, incY, &ret);
    return ret;
}

double _Complex zdotu(const int *N, const double _Complex *X, const int *incX, const double _Complex *Y, const int *incY)
{
    double _Complex ret;
    cblas_zdotu_sub$NEWLAPACK(N, X, incX, Y, incY, &ret);
    return ret;
}

double _Complex zladiv(const double _Complex *x, const double _Complex *y)
{
    double _Complex ret;
    dladiv$NEWLAPACK((double*)(x), (double*)(x)+1, (double*)(y), (double*)(y)+1, (double*)(&ret), (double*)(&ret)+1);
    return ret;
}

float _Complex cladiv(const float _Complex *x, const float _Complex *y)
{
    float _Complex ret;
    sladiv$NEWLAPACK((float*)(x), (float*)(x)+1, (float*)(y), (float*)(y)+1, (float*)(&ret), (float*)(&ret)+1);
    return ret;
}
