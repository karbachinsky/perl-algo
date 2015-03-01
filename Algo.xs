#ifdef __cplusplus
extern "C" {
#endif

#define PERL_NO_GET_CONTEXT
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "ppport.h"
#include <stdio.h>

#ifdef __cplusplus
} /* extern "C" */
#endif

#define NDEBUG

#include <vector>
#include <cstddef>
#include <stdexcept>
//#include <iterator>

#include "kth_order_statistic.hpp"
#include "debug.hpp"

/* copied from gfx modules */
class PerlCompare {
    SV* compare_;

    public:
    PerlCompare(SV* compare) : compare_(compare) {}

    int operator()(SV* const x, SV* const y) const {
        dTHX;
        dSP;

        ENTER;
        SAVETMPS;

        PUSHMARK(SP);
        EXTEND(SP, 2);
        PUSHs(x);
        PUSHs(y);
        PUTBACK;

        call_sv(compare_, G_SCALAR);
        SPAGAIN;
        int const ret = POPi;
        PUTBACK;

        FREETMPS;
        LEAVE;

        return ret;
    }
};


MODULE = Algo      PACKAGE = Algo

SV *
kth_order_statistic(SV* compare, SV *array_ref, SV *k)
    PROTOTYPE: &$$
    CODE:
    {
        if (!SvROK(array_ref) ||  SvTYPE(SvRV(array_ref)) != SVt_PVAV) {
            warn("Not an array refference passed."); 
            XSRETURN_UNDEF;
        }

        AV * array = (AV*)SvRV(array_ref);
        ssize_t len = av_len(array) + 1;

        DEBUG("array length", len);

        std::vector<SV*> elements;
        elements.reserve(len);

        SV *buf = &PL_sv_undef;
        for (size_t i=0; i<len; ++i) {
            buf = *(SV **)av_fetch(array, i, true);
            elements.push_back(buf);
        }

        DEBUG_ITERABLE("elements", elements.begin(), elements.end());

        try {
            auto it = algo::KthOrderStatistic<std::vector<SV*>::iterator, PerlCompare>(
                elements.begin(), 
                elements.end(), 
                (size_t)SvUV(k),
                PerlCompare(compare)
            );
            //size_t pos = std::distance(elements.begin(), it);

            DEBUG_ITERABLE("elements after", elements.begin(), elements.end());
            RETVAL = SvREFCNT_inc(*it);
        }
        catch (std::exception &e) {
            warn(e.what()); 
            XSRETURN_UNDEF;
        }
    }

    OUTPUT: RETVAL
    
