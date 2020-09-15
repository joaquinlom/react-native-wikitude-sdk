//
//  InstantTrackingState.hpp
//  WikitudeUniversalSDK
//
//  Created by Alexandru Florea on 07/11/2017.
//  Copyright © 2017 Wikitude. All rights reserved.
//

#ifndef InstantTrackingState_hpp
#define InstantTrackingState_hpp

#ifdef __cplusplus

<<<<<<< HEAD
=======
#include "CompilerAttributes.hpp"


>>>>>>> 7a80d517418492d323a2b0529e1da11bec307318
namespace wikitude { namespace sdk {
    
    namespace impl {

        
        /** @addtogroup InstantTracking
         *  @{
         */
        /** @enum InstantTrackingState
         *  @brief An enum indicating the current state in which an instant tracker is.
         */
<<<<<<< HEAD
        enum class InstantTrackingState {
=======
        enum class WT_EXPORT_API InstantTrackingState {
>>>>>>> 7a80d517418492d323a2b0529e1da11bec307318
            /** @brief Initializing indicates that the instant tracker is in initialization state, which allows the origin of the tracking scene to be set, as well as the device height above ground.
             */
            Initializing,
            /** @brief Tracking indicates that the instant tracker is in tracking state, which means that the current scene is being tracked and augmentations can be placed.
             */
            Tracking
        };
        /** @}*/
    }
    using impl::InstantTrackingState;
}}

#endif /* __cplusplus */

#endif /* InstantTrackingState_hpp */
