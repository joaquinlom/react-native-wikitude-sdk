//
//  ImageTrackingPluginModule.hpp
//  WikitudeUniversalSDK
//
//  Created by Andreas Schacherbauer on 17.03.18.
//  Copyright © 2018 Wikitude. All rights reserved.
//

#ifndef ImageTrackingPluginModule_hpp
#define ImageTrackingPluginModule_hpp

#ifdef __cplusplus

#include "Matrix4.hpp"

#include "State.hpp"
#include "CompilerAttributes.hpp"

#include "TrackingPluginModule.hpp"


namespace wikitude {
    namespace sdk {
        namespace impl {
            class ManagedCameraFrame;
        }
        using impl::ManagedCameraFrame;
    }
}

namespace wikitude { namespace sdk {

    namespace impl {

<<<<<<< HEAD
=======
        class ImageTracker;
>>>>>>> 7a80d517418492d323a2b0529e1da11bec307318

        class WT_EXPORT_API ImageTrackingPluginModule : public TrackingPluginModule {
        public:
            virtual ~ImageTrackingPluginModule() = default;            

<<<<<<< HEAD
            virtual universal_sdk::ImageState getTrackingState() const = 0;
=======
            virtual universal_sdk::ImageState getTrackingState(ImageTracker& imageTracker_) const = 0;
>>>>>>> 7a80d517418492d323a2b0529e1da11bec307318
            virtual sdk::Matrix4 getViewMatrix() const = 0;
        };
    }
    using impl::ImageTrackingPluginModule;
}}

#endif /* __cplusplus */

#endif /* ImageTrackingPluginModule_hpp */
