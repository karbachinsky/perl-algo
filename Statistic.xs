#ifdef __cplusplus
extern "C" {
#endif

#define PERL_NO_GET_CONTEXT
#include "EXTERN.h"
#include "perl.h"
#define NO_XSLOCKS 
#include "XSUB.h"

#ifdef __cplusplus
} /* extern "C" */
#endif

#include "ppport.h"

#define NDEBUG

#include <vector>
#include <cstddef>
#include <stdexcept>

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


bool is_array_ref(const SV * const  a) {
    return (SvROK(a) && SvTYPE(SvRV(a)) == SVt_PVAV);
}


void AV_to_vector(AV * array, std::vector<SV*> &elements) {
    dTHX; 
    size_t len = av_len(array) + 1;
    
    DEBUG("array length", len);

    elements.reserve(len);

    SV *buf = &PL_sv_undef;
    for (size_t i=0; i<len; ++i) {
        buf = *(SV **)av_fetch(array, i, true);
        elements.push_back(buf);
    }
}


MODULE = Algorithm::Statistic      PACKAGE = Algorithm::Statistic

SV *
kth_order_statistic(SV* compare, SV *array_ref, SV *k)
    PROTOTYPE: &$$
    CODE:
    {
        if (!is_array_ref(array_ref)) {
            warn("Not an array refference passed"); 
            XSRETURN_UNDEF;
        }

        AV * array = (AV*)SvRV(array_ref);
        std::vector<SV*> elements;

        AV_to_vector(array, elements);

        DEBUG_ITERABLE("elements", elements.begin(), elements.end());

        try {
            auto it = algo::KthOrderStatistic<std::vector<SV*>::iterator, PerlCompare>(
                elements.begin(), 
                elements.end(), 
                (size_t)SvUV(k),
                PerlCompare(compare)
            );

            DEBUG_ITERABLE("elements after", elements.begin(), elements.end());
            RETVAL = SvREFCNT_inc(*it);
        }
        catch (std::exception &e) {
            warn(e.what()); 
            XSRETURN_UNDEF;
        }
    }

    OUTPUT: RETVAL
   

SV *
mediana(SV* compare, SV *array_ref)
    PROTOTYPE: &$
    CODE:
    {
        if (!is_array_ref(array_ref)) {
            warn("Not an array refference passed"); 
            XSRETURN_UNDEF;
        }

        AV * array = (AV*)SvRV(array_ref);
        std::vector<SV*> elements;

        AV_to_vector(array, elements);

        size_t k = elements.size() / 2;

        try {
            auto it = algo::KthOrderStatistic<std::vector<SV*>::iterator, PerlCompare>(
                elements.begin(), 
                elements.end(), 
                k,
                PerlCompare(compare)
            );

            DEBUG_ITERABLE("elements after", elements.begin(), elements.end());
            RETVAL = SvREFCNT_inc(*it);
        }
        catch (std::exception &e) {
            warn(e.what()); 
            XSRETURN_UNDEF;
        }
    }

    OUTPUT: RETVAL
   
