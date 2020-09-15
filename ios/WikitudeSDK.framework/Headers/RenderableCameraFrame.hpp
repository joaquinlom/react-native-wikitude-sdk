
//
// RenderableCameraFrame
//
// Created by Alexander Bendl on 27.06.18.
// Copyright (c) 2018 Wikitude. All rights reserved.
//

#ifndef RenderableCameraFrame_hpp
#define RenderableCameraFrame_hpp

#ifdef __cplusplus

#include <vector>

<<<<<<< HEAD
=======
#include "CompilerAttributes.hpp"

>>>>>>> 7a80d517418492d323a2b0529e1da11bec307318
#include "CameraFramePlane.hpp"
#include "CameraFrame.hpp"


namespace wikitude { namespace sdk {

    namespace impl {

<<<<<<< HEAD
        class RenderableCameraFrame {
=======
        class WT_EXPORT_API RenderableCameraFrame {
>>>>>>> 7a80d517418492d323a2b0529e1da11bec307318
        public:
            RenderableCameraFrame() = default;
            RenderableCameraFrame(RenderableCameraFrame& other_) = delete;
            virtual ~RenderableCameraFrame() = default;
            
            RenderableCameraFrame& operator=(RenderableCameraFrame& other_) = delete;

            virtual const std::vector<CameraFramePlane>& getData() = 0;
            virtual const sdk::ColorCameraFrameMetadata& getColorMetadata() const = 0;
        };
    }
    using impl::RenderableCameraFrame;
}}

#endif /* __cplusplus */

#endif //RenderableCameraFrame_hpp
