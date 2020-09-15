//
//  State.hpp
//  WikitudeUniversalSDK
//
//  Created by Andreas Schacherbauer on 08.11.17.
//  Copyright © 2017 Wikitude. All rights reserved.
//

#ifndef State_hpp
#define State_hpp

#ifdef __cplusplus

#include <map>
#include <vector>
#include <string>

#include "Unit.h"
#include "Geometry.hpp"
#include "Matrix4.hpp"
#include "Timestamp.hpp"
#include "PlaneType.hpp"
<<<<<<< HEAD
=======
#include "ImageTargetType.hpp"
#include "CompilerAttributes.hpp"
>>>>>>> 7a80d517418492d323a2b0529e1da11bec307318


namespace aramis {
    struct State;
    struct TargetState;
    struct Plane;
}

namespace wikitude { namespace universal_sdk {

    namespace impl {


<<<<<<< HEAD
        struct CommonProperties {
=======
        struct WT_EXPORT_API CommonProperties {
>>>>>>> 7a80d517418492d323a2b0529e1da11bec307318
        public:
            CommonProperties(const sdk::Matrix4& modelMatrix_, const sdk::Matrix4& viewMatrix_);
            CommonProperties(aramis::TargetState& targetState_);
            CommonProperties(aramis::Plane& plane_);
            sdk::Matrix4    _matrix;
            sdk::Matrix4    _modelMatrix;
            sdk::Matrix4    _viewMatrix;
        };

<<<<<<< HEAD
        struct TargetProperties {
            TargetProperties(aramis::TargetState& targetState_);

=======
        struct WT_EXPORT_API TargetProperties {
            TargetProperties(long dataSetId_, aramis::TargetState& targetState_);

            long            _dataSetId;
>>>>>>> 7a80d517418492d323a2b0529e1da11bec307318
            std::string     _name;
            float           _depthFactor;
            bool            _isExtended;
            int             _trackingQuality;
        };

<<<<<<< HEAD
        struct ImageTargetState {
            ImageTargetState(aramis::TargetState& targetState_, sdk::Rectangle<int> targetRectInCameraFrame_);

            CommonProperties    _commonProperties;
            TargetProperties    _targetProperties;
            int             _uniqueId;
            sdk::Size<int>  _size;
            mutable sdk::Millimeter _physicalHeight;
            sdk::Rectangle<int>     _targetAreaInCameraFrame;
        };

        struct ObjectTargetState {
            ObjectTargetState(aramis::TargetState& targetState_);

            CommonProperties    _commonProperties;
            TargetProperties    _targetProperties;
            bool                _valid;
=======
        struct WT_EXPORT_API ImageTargetState {
            ImageTargetState(long dataSetId_, aramis::TargetState& targetState_, sdk::Rectangle<int> targetRectInCameraFrame_);

            CommonProperties        _commonProperties;
            TargetProperties        _targetProperties;
            int                     _uniqueId;
            sdk::Size<int>          _size;
            mutable sdk::Millimeter _physicalHeight;
            sdk::Rectangle<int>     _targetAreaInCameraFrame;
            sdk::ImageTargetType    _imageTargetType;
            sdk::Millimeter         _circumferenceBase;
            sdk::Millimeter         _circumferenceTop;
        };

        struct WT_EXPORT_API ObjectTargetState {
            ObjectTargetState(long dataSetId_, aramis::TargetState& targetState_);

            CommonProperties        _commonProperties;
            TargetProperties        _targetProperties;
            long                    _uniqueId;
            bool                    _valid;
>>>>>>> 7a80d517418492d323a2b0529e1da11bec307318
            sdk::Rectangle3D<float> _boundingBox;
        };

        struct InstantTargetState {
            InstantTargetState(const sdk::Matrix4& modelMatrix_, const sdk::Matrix4& viewMatrix_, bool valid_);
            InstantTargetState(aramis::TargetState& targetState_);

            CommonProperties    _commonProperties;
            bool                _valid;
        };

<<<<<<< HEAD
        struct PlaneState {
=======
        struct WT_EXPORT_API PlaneState {
>>>>>>> 7a80d517418492d323a2b0529e1da11bec307318
            PlaneState(aramis::Plane& plane_, InstantTargetState& instantTargetState_);

            CommonProperties    _commonProperties;
            int                 _uniqueId;

            sdk::PlaneType      _planeType;
            float               _confidence;

            sdk::Extent<float>  _extentX;
            sdk::Extent<float>  _extentY;

            std::vector<sdk::Point<float>>       _convexHull;
        };

<<<<<<< HEAD
        struct ImageState {
=======
        struct WT_EXPORT_API ImageState {
>>>>>>> 7a80d517418492d323a2b0529e1da11bec307318
        public:
            ImageState();
            ImageState(aramis::State& state_);
            ImageState(aramis::State& state_, std::map<std::string, sdk::Rectangle<int>> targetAreasInCameraFrame_);

            void update(aramis::State& state_, std::map<std::string, sdk::Rectangle<int>> targetAreasInCameraFrame_);

            long                        _processedFrameId = -1;
            sdk::Timestamp              _processedFrameTimestamp;

<<<<<<< HEAD
            std::vector<ImageTargetState>      _targetStates;
        };

        struct ObjectState {
=======
            std::vector<ImageTargetState>      _targetStates; //TODO(DG): this should probably turn into a std::map<long, ImageTargetState>
        };

        struct WT_EXPORT_API ObjectState {
>>>>>>> 7a80d517418492d323a2b0529e1da11bec307318
        public:
            ObjectState();
            ObjectState(aramis::State& state_);

            void update(aramis::State& state_);

            long                        _processedFrameId = -1;
            sdk::Timestamp              _processedFrameTimestamp;

            std::vector<ObjectTargetState>      _targetStates;
        };

<<<<<<< HEAD
        struct InstantState {
=======
        struct WT_EXPORT_API InstantState {
>>>>>>> 7a80d517418492d323a2b0529e1da11bec307318
        public:
            InstantState();
            InstantState(long processedFrameId_, sdk::Timestamp processedFrameTimestamp_, const sdk::Matrix4& modelMatrix_, const sdk::Matrix4& viewMatrix_, bool valid_);
            InstantState(aramis::State& state_);

            void update(long processedFrameId_, sdk::Timestamp processedFrameTimestamp_, const sdk::Matrix4& modelMatrix_, const sdk::Matrix4& viewMatrix_, bool valid_);
            void update(aramis::State& state_);

            long                        _processedFrameId = -1;
            sdk::Timestamp              _processedFrameTimestamp;

            std::vector<InstantTargetState>      _targetStates;
            std::vector<PlaneState>              _planeStates;
        };
    }
    using impl::ImageTargetState;
    using impl::ObjectTargetState;
    using impl::InstantTargetState;
    using impl::ImageState;
    using impl::InstantState;
    using impl::ObjectState;
}}

#endif /* __cplusplus */

#endif /* State_hpp */
