//
//  PluginParameterCollection.hpp
//  WikitudeUniversalSDK
//
//  Created by Andreas Schacherbauer on 29.06.18.
//  Copyright © 2018 Wikitude. All rights reserved.
//

#ifndef PluginParameterCollection_hpp
#define PluginParameterCollection_hpp

#ifdef __cplusplus

<<<<<<< HEAD
=======
#include "CompilerAttributes.hpp"

>>>>>>> 7a80d517418492d323a2b0529e1da11bec307318

namespace wikitude { namespace sdk {

    namespace impl {

        
        class RuntimeParameters;
        class CameraParameters;
        class TrackingParameters;
<<<<<<< HEAD
        class PluginParameterCollection {
=======
        class WT_EXPORT_API PluginParameterCollection {
>>>>>>> 7a80d517418492d323a2b0529e1da11bec307318
        public:
            virtual ~PluginParameterCollection() = default;

            virtual const RuntimeParameters& getRuntimeParameters() const = 0;
            virtual RuntimeParameters& getRuntimeParameters() = 0;

            virtual const CameraParameters& getCameraParameters() const = 0;
            virtual CameraParameters& getCameraParameters() = 0;

            virtual const TrackingParameters& getTrackingParameters() const = 0;
            virtual TrackingParameters& getTrackingParameters() = 0;
        };
    }
    using impl::PluginParameterCollection;
}}

#endif /* __cplusplus */

#endif /* PluginParameterCollection_hpp */
