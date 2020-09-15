//
//  Timestamp.hpp
//  CommonLibrary
//
//  Created by Andreas Schacherbauer on 20.11.17.
//  Copyright © 2017 Wikitude. All rights reserved.
//

#ifndef Timestamp_hpp
#define Timestamp_hpp

#ifdef __cplusplus

#include <cstdint>

<<<<<<< HEAD
=======
#include "CompilerAttributes.hpp"

>>>>>>> 7a80d517418492d323a2b0529e1da11bec307318

namespace wikitude { namespace sdk {

    namespace impl {


        /** @struct Timestamp
         * @brief Timestamp represents a single point in time. _value/_timescale = seconds.
         */
<<<<<<< HEAD
        struct Timestamp {
=======
        struct WT_EXPORT_API Timestamp {
>>>>>>> 7a80d517418492d323a2b0529e1da11bec307318
        public:
            std::int64_t    _value = 0;
            std::int32_t    _timescale = 0;
        };
    }
    using impl::Timestamp;
}}

#endif /* __cplusplus */

#endif /* Timestamp_hpp */
