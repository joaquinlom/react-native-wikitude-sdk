//
//  PlaneType.hpp
//  WikitudeUniversalSDK
//
//  Created by Alexandru Florea on 02.08.18.
//  Copyright © 2018 Wikitude. All rights reserved.
//

#ifndef PlaneType_hpp
#define PlaneType_hpp

#ifdef __cplusplus

<<<<<<< HEAD
=======
#include "CompilerAttributes.hpp"

>>>>>>> 7a80d517418492d323a2b0529e1da11bec307318

namespace wikitude { namespace sdk {

    namespace impl {

        /**
         * @brief Use this enum to determine the type of a plane that was detected by the instant tracker.
         */
<<<<<<< HEAD
        enum class PlaneType {
=======
        enum class WT_EXPORT_API PlaneType {
>>>>>>> 7a80d517418492d323a2b0529e1da11bec307318
            /** HorizontalUpward: The detected plane is horizontal and points upward (e.g. floor). */
            HorizontalUpward,
            /** HorizontalDownward: The detected plane is horizontal and points downward (e.g. ceiling). */
            HorizontalDownward,
            /** Vertical: The detected plane is vertical (e.g. wall). */
            Vertical,
            /** Arbitrary: The detected plane has an arbitrary orientation. */
            Arbitrary,
        };
    }
    using impl::PlaneType;
}}

#endif /* __cplusplus */

#endif /* PlaneType_hpp */
