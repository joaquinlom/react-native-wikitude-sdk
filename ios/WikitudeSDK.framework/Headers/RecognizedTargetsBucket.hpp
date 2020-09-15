//
//  RecognizedTargetsBucket.h
//  Wikitude SDK
//
//  Created by Andreas Schacherbauer on 12.05.17.
//  Copyright © 2017 Wikitude. All rights reserved.
//

#ifndef RecognizedTargetsBucket_hpp
#define RecognizedTargetsBucket_hpp

#ifdef __cplusplus

#include <vector>

#include "ImageTarget.hpp"
#include "ObjectTarget.hpp"
#include "InstantTarget.hpp"
#include "InitializationPose.hpp"
#include "Plane.hpp"
<<<<<<< HEAD
=======
#include "CompilerAttributes.hpp"
>>>>>>> 7a80d517418492d323a2b0529e1da11bec307318


namespace wikitude { namespace sdk {

    namespace impl {

        class Matrix4;
<<<<<<< HEAD
        class RecognizedTargetsBucket {
=======
        class WT_EXPORT_API RecognizedTargetsBucket {
>>>>>>> 7a80d517418492d323a2b0529e1da11bec307318
        public:
            virtual ~RecognizedTargetsBucket() = default;

            virtual const std::vector<ImageTarget*>& getImageTargets() const = 0;
            virtual const std::vector<ObjectTarget*>& getObjectTargets() const = 0;

            virtual const std::vector<InstantTarget*>& getInstantTargets() const = 0;
            virtual const std::vector<InitializationPose*>& getInitializationPoses() const = 0;
            
            virtual const std::vector<Plane*>& getPlanes() const = 0;
            virtual const Matrix4& getViewMatrix() const = 0;
        };
    }
    using impl::RecognizedTargetsBucket;
}}

#endif /* __cplusplus */

#endif /* RecognizedTargetsBucket_hpp */
