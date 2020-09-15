//
//  RenderableCameraFrameBucket.hpp
//  WikitudeUniversalSDK
//
//  Created by Alexander Bendl on 26.06.18.
//  Copyright © 2018 Wikitude. All rights reserved.
//

#ifndef RenderableCameraFrameBucket_h
#define RenderableCameraFrameBucket_h

#ifdef __cplusplus

#include <functional>

#include "Error.hpp"
<<<<<<< HEAD
=======
#include "CompilerAttributes.hpp"
>>>>>>> 7a80d517418492d323a2b0529e1da11bec307318


namespace wikitude { namespace sdk {

    namespace impl {


        class RenderableCameraFrame;
<<<<<<< HEAD
        class RenderableCameraFrameBucket {
=======
        class WT_EXPORT_API RenderableCameraFrameBucket {
>>>>>>> 7a80d517418492d323a2b0529e1da11bec307318
        public:
            virtual ~RenderableCameraFrameBucket() = default;
            
            virtual void getRenderableCameraFrameForId(long id_, std::function<void(RenderableCameraFrame&)> successHandler_, std::function<void(Error&)> errorHandler_) = 0;
        };
    }
    using impl::RenderableCameraFrameBucket;
}}

#endif /* __cplusplus */

#endif /* RenderableCameraFrameBuckett_h */
