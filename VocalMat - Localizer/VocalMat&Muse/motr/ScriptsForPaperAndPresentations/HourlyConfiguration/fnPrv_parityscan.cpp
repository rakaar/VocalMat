/*
 * MEX-file: parityscan
 *
 * Copyright 1993-2007 The MathWorks, Inc.
 * $Revision: 1.1.6.3 $  $Date: 2007/06/04 21:10:14 $
 *
 * Syntax:
 *         BW = PARITYSCAN(F)
 *
 * F is a two-dimensional, real, double matrix containing nonnegative 
 * integers.  BW is a two-dimensional logical matrix of the same size.
 * BW(i,j) is TRUE if the columnwise cumulative sum of F is odd at (i,j);
 * otherwise BW(i,j) is FALSE.
 *
 */

#include <math.h>
#include <mex.h>
// #include "mwsize.h"

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {
    double    *pin, sum;
    mxLogical *pout, pixel;
    mwSize M, N, r, c;

    (void) nlhs;  /* unused parameter */

    if (nrhs != 1) {
        mexErrMsgIdAndTxt("Images:parityscan:numInputs", "%s",
                          "PARITYSCAN expected one input argument.");
    }

    if (!mxIsDouble(prhs[0]) || mxIsComplex(prhs[0]) ||
        mxIsSparse(prhs[0]) || (mxGetNumberOfDimensions(prhs[0]) != 2)) {
        mexErrMsgIdAndTxt("Images:parityscan:invalidInput", "%s",
                          "Input to PARITYSCAN must be a real, full 2-D, double matrix.");
    }

    M = mxGetM(prhs[0]);
    N = mxGetN(prhs[0]);

    plhs[0] = mxCreateLogicalMatrix(M, N);
    pout = mxGetLogicals(plhs[0]);
    pin  = (double *) mxGetData(prhs[0]);

    for (c = 0; c < N; c++) {
        pixel = false;
        sum   = 0.0;
        for (r = 0; r < M; r++) {
            if (*pin != 0.0) {
                sum += *pin;
                pixel = (fmod(sum,2.0) == 1.0) ? true : false;
            }

            *pout = pixel;

            pin++;
            pout++;
        }
    }
}